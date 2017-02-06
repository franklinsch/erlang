-module(client).
-export([init/1]).

init(Name) ->
  neighbors(Name).

neighbors(Name) ->
  receive {neighbors, Neighbors} -> 
            % Map format: {ProcessID, {NumReceived, NumSent}}
            Messages = maps:from_list([{P, {0, 0}} || P <- Processes]),
            next(Name, Neighbors, Messages).

next(Name, Neighbors, Messages) ->
  receive {message, Client} -> 
          {Received, _} = Messages#{Client}
          Messages2 = maps:update(Client, Received + 1, Received),
          next(Name, Neighbors, Messages2).
  after 0 ->
          broadcast({message, self()}, Neighbors),
          {Sent, _} = Messages

broadcast(Message, Clients) ->
  [Client ! Message, Client <- Clients].
