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
            Received = maps:from_list([{ClientName, {0, 0}} || 
                                       {ClientName, _} <- Neighbors]),
            timer:send_after(Timeout, timeout),
            start(Max_messages, Timeout, Name, Neighbors, 0, Received)
  end.

start(Max_messages, Timeout, Name, Neighbors, Sent, Received) ->
  broadcast_after(rand:uniform(500), Neighbors, {message, Name}),
  receive timeout ->
            Communications = communications(Sent, Received),
            io:format("~p: ~p", [Name, Communications]);
          {message, ClientName} -> 
            NumReceived = maps:get(ClientName, Received),
            Received2 = maps:update(ClientName, NumReceived + 1, Received),
            start(Max_messages, Timeout, Name, Neighbors, Sent, Received2)
  end.  

broadcast_after(Time, Clients, Message) ->
  [timer:send_after(Time, Client, Message) || Client <- Clients].

communications(Sent, Received) ->
  Names = lists:sort(maps:keys(Received)),
  string:join([{Name, {Sent, maps:get(Name, Received)}} || Name <- Names], " "). 
