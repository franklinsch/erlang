%%% Franklin Schrans (fs2014)

-module(system2).
-export([start/1]).

start(Args) ->
  [FirstArg | _] = Args,
  {NumClients, _} = string:to_integer(atom_to_list(FirstArg)),
  Clients = spawnProcesses(NumClients),
  bindPLs(NumClients),
  [Client ! {task2, start, 1000, 1000} || {_, Client} <- Clients].

spawnProcesses(NumClients) ->
  Clients = [{ClientID, spawn(client, init, [ClientID])} 
             || ClientID <- lists:seq(1, NumClients)],
  [Client ! {neighbors, Clients} || {_, Client} <- Clients],
  Clients.

bindPLs(NumClients) ->
  PLs = receivePLs(NumClients, []),
  [PL ! {bind_pls, lists:delete(PL, PLs)} || PL <- PLs].

receivePLs(NumClients, PLs) ->
  case NumClients of
    0 -> PLs;
    _ -> 
      receive {pl_bind, ID} ->
                PLs2 = lists:append(PLs, [ID]),
                receivePLs(NumClients - 1, PLs2)
      end
  end,
  PLs.
