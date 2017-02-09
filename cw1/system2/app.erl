%%% Franklin Schrans (fs2014)

-module(app).
-export([init/1]).

init(Name) ->
  receive {bind_pl, PL} -> neighbors(PL, Name) 
  end.

neighbors(PL, Name) ->
  receive {pl_deliver, {neighbors, Neighbors}} -> 
            task(PL, Name, Neighbors)
  end.

task(PL, Name, Neighbors) ->
  receive {pl_deliver, {task2, start, Max_messages, Timeout}} ->
            % Map format: {Name, NumReceived}}
            Received = maps:from_list([{Neighbor, 0} ||
                                       Neighbor <- Neighbors]),
            timer:send_after(Timeout, timeout),
            start(PL, Max_messages, 0, Name, Neighbors, 0, Received)
  end.

start(PL, Max_messages, Delay, Name, Neighbors, Sent, Received) ->
  receive
    timeout ->
      printStats(Name, Sent, Received);
    {pl_deliver, {message, ClientName}} ->
      Received2 = maps:update_with(ClientName, fun(V) -> V + 1 end, Received),
      start(PL, Max_messages, Delay, Name, Neighbors, Sent, Received2)
  after Delay ->
          if 
            (Sent >= Max_messages) and (Max_messages /= 0) ->
              % If sent Max_messages, process the messages in the queue until 
              % timeout.
              start(PL, Max_messages, infinity, Name, Neighbors, Sent, 
                    Received);
            true ->
              broadcast(PL, Neighbors, {message, Name}),
              start(PL, Max_messages, Delay, Name, Neighbors, 
                    Sent + 1, Received)
          end
  end.

broadcast(PL, Clients, Message) ->
  [PL ! {pl_send, Client, Message} || Client <- Clients].

communications(Sent, Received) ->
  Names = lists:sort(maps:keys(Received)),
  Comms = lists:map(fun(Name) ->
                T = io_lib:format("~p", [{Sent, maps:get(Name, Received)}]),
                lists:flatten(T)
            end,
            Names),
  lists:append(lists:join(" ", Comms)).

printStats(Name, Sent, Received) ->
  Communications = communications(Sent, Received),
  io:format("~p: ~s~n", [Name, Communications]).
