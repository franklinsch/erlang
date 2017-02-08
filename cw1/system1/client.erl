%%% Franklin Schrans (fs2014)

-module(client).
-export([init/1]).

init(Name) ->
  neighbors(Name).

neighbors(Name) ->
  receive {neighbors, Neighbors} ->
            task(Name, Neighbors)
  end.

task(Name, Neighbors) ->
  receive {task1, start, Max_messages, Timeout} ->
            % Map format: {Name, NumReceived}}
            Received = maps:from_list([{ClientName, 0} ||
                                       {ClientName, _} <- Neighbors]),
            timer:send_after(Timeout, timeout),
            start(Max_messages, 0, Name, Neighbors, 0, Received)
  end.

start(Max_messages, Delay, Name, Neighbors, Sent, Received) ->
  receive
    timeout ->
      printStats(Name, Sent, Received);
    {message, ClientName} ->
      Received2 = maps:update_with(ClientName, fun(V) -> V + 1 end, Received),
      start(Max_messages, Delay, Name, Neighbors, Sent, Received2)
  after Delay ->
          if 
            (Sent >= Max_messages) and (Max_messages /= 0) ->
              % If sent Max_messages, process the messages in the queue until 
              % timeout.
              start(Max_messages, infinity, Name, Neighbors, Sent, 
                    Received);
            true ->
              broadcast(Neighbors, {message, Name}),
              start(Max_messages, Delay, Name, Neighbors, 
                    Sent + 1, Received)
          end
  end.

broadcast(Clients, Message) ->
  [ID ! Message || {_, ID} <- Clients].

communications(Sent, Received) ->
  % TODO: If the key is a string, will sort lexicographically.
  Names = lists:sort(maps:keys(Received)),
  lists:map(fun(Name) ->
                T = io_lib:format("~p", [{Sent, maps:get(Name, Received)}]),
                lists:flatten(T)
            end,
            Names).

printStats(Name, Sent, Received) ->
  Communications = communications(Sent, Received),
  io:format("~p: ~p~n", [Name, Communications]).
