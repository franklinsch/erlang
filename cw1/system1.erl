-module(system1).
-export([start/1]).

start(Args) ->
  [FirstArg | _] = Args,
  {NumClients, _} = string:to_integer(atom_to_list(FirstArg)),
  Clients = spawnProcesses(NumClients, true),
  [ID ! {task1, start, 1000, 3000} || {_, ID} <- Clients].

spawnProcesses(NumClients, FullyConnected) ->
  ClientNames = lists:seq(1, NumClients),
  Clients = [{Name, spawn(client, init, [Name])} || Name <- ClientNames],
  case FullyConnected of
    false -> Clients;
    true  -> 
      [ID ! {neighbors, Clients} || {_, ID} <- Clients]
  end.
