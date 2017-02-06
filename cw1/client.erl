-module(client).
-export([init/1]).

init(Name) ->
  neighbors(Name).

neighbors(Name) ->
  receive {neighbors, Neighbors} -> 
            Messages = maps:from_list([{P, 0} || P <- Processes]),
            next(Name, Neighbors, Messages).

next(Name, Neighbors, Received) ->
  receive {message, Client} -> 
          Received2 = maps:update(Client, Received#{Client} + 1, Received),
          next(Name, Neighbors, Received2).
  after 0 ->
          broadcast({message, self()}, Neighbors),

broadcast(Message, Clients) ->
  [Client ! Message, Client <- Clients].
