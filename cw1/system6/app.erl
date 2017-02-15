%%% Franklin Schrans (fs2014)

-module(app).
-export([init/1]).

init(Name) ->
  receive {bind_rb, RB} -> neighbors(RB, Name) 
  end.

neighbors(RB, Name) ->
  receive {rb_deliver, 0, {neighbors, Neighbors}} -> 
            task(RB, Name, Neighbors)
  end.

task(RB, Name, Neighbors) ->
  receive {rb_deliver, _, {task6, start, Max_messages, Timeout}} ->
            % Map format: {Name, NumReceived}}
            Received = maps:from_list([{Neighbor, 0} ||
                                       Neighbor <- Neighbors]),
            case Name of
              3 -> timer:send_after(5, exit_timeout);
              _ -> ok
            end,
            timer:send_after(Timeout, timeout),
            start(RB, Max_messages, 0, Name, 0, Received)
  end.

start(RB, Max_messages, Delay, Name, Sent, Received) ->
  receive
    timeout ->
      printStats(Name, Sent, Received);
    exit_timeout ->
      printStats(Name, Sent, Received),
      exit(0);
    {rb_deliver, From, {message, _}} ->
      Received2 = maps:update_with(From, fun(V) -> V + 1 end, Received),
      start(RB, Max_messages, Delay, Name, Sent, Received2)
  after Delay ->
          if 
            (Sent >= Max_messages) and (Max_messages /= 0) ->
              % If sent Max_messages, process the messages in the queue until 
              % timeout.
              start(RB, Max_messages, infinity, Name, Sent, Received);
            true ->
              UUID = {Name, Sent},
              broadcast(RB, {message, UUID}),
              start(RB, Max_messages, Delay, Name, Sent + 1, Received)
          end
  end.

broadcast(RB, Message) ->
  RB ! {rb_broadcast, Message}.

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
