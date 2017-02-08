%%% Franklin Schrans (fs2014)

-module(system1).
-export([start/1]).

start(Args) ->
  [FirstArg | _] = Args,
  {NumClients, _} = string:to_integer(atom_to_list(FirstArg)),
  Clients = spawnProcesses(NumClients),
  [Client ! {task1, start, 1000, 3000} || {_, Client} <- Clients].

spawnProcesses(NumClients) ->
  Clients = [{ClientID, spawn(client, init, [ClientID])} || ClientID <- lists:seq(1, NumClients)],
  [Client ! {neighbors, Clients} || {_, Client} <- Clients],
  Clients.
