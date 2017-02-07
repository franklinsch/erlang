-module(system1).
-export([start/1]).

start(Args) ->
  [FirstArg | _] = Args,
  {NumClients, _} = string:to_integer(atom_to_list(FirstArg)),
  Clients = spawnProcesses(NumClients),
  [ID ! {task1, start, 1000, 3000} || {_, ID} <- Clients].

spawnProcesses(NumClients) ->
  ClientNames = lists:seq(1, NumClients),
  Clients = [{Name, spawn(client, init, [Name])} 
             || Name <- ClientNames],
  [ID ! {neighbors, Clients} || {_, ID} <- Clients],
  Clients.
