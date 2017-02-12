%%% Franklin Schrans (fs2014)

-module(app).
-export([init/1]).

init(Name) ->
  receive {bind_beb, BEB} -> task(BEB, Name) end.

task(BEB, Name) ->
  receive {beb_deliver, _, {task4, start, Max_messages, Timeout}} ->
            % Map format: {Name, NumReceived}}
            Received = #{},
            timer:send_after(Timeout, timeout),
            start(BEB, Max_messages, 0, Name, 0, Received)
  end.

start(BEB, Max_messages, Delay, Name, Sent, Received) ->
  receive
    timeout ->
      printStats(Name, Sent, Received);
    {beb_deliver, From, message} ->
      Received2 = maps:update_with(From, fun(V) -> V + 1 end, 1, Received),
      start(BEB, Max_messages, Delay, Name, Sent, Received2)
  after Delay ->
          if 
            (Sent >= Max_messages) and (Max_messages /= 0) ->
              % If sent Max_messages, process the messages in the queue until 
              % timeout.
              start(BEB, Max_messages, infinity, Name, Sent, Received);
            true ->
              broadcast(BEB, message),
              start(BEB, Max_messages, Delay, Name, Sent + 1, Received)
          end
  end.

broadcast(BEB, Message) ->
  BEB ! {beb_broadcast, Message}.

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
