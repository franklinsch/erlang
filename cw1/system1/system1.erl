%%% Franklin Schrans (fs2014)

-module(system1).
-export([start/0]).

start() ->
  NumClients = 5,
  Clients = spawnProcesses(NumClients),
  [Client ! {task1, start, 1000, 3000} || {_, Client} <- Clients].

spawnProcesses(NumClients) ->
  Clients = [{ClientID, spawn(client, init, [ClientID])} || ClientID <- lists:seq(1, NumClients)],
  [Client ! {neighbors, Clients} || {_, Client} <- Clients],
  Clients.
