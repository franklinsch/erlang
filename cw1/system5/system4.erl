%%% Franklin Schrans (fs2014)

-module(system4).
-export([start/1]).

start(Args) ->
  [First, Second, Third| _] = Args,
  {Max_messages, _} = string:to_integer(atom_to_list(First)),
  {Timeout, _} = string:to_integer(atom_to_list(Second)),
  {PLReliability, _} = string:to_integer(atom_to_list(Third)),

  NumProcesses = 5,
  Processes = spawnProcesses(NumProcesses, PLReliability),
  PLs = bindPLs(NumProcesses),
  [PL ! {pl_msg, 0, {beb_processes, Processes}} || PL <- PLs],
  [PL ! {pl_msg, 0, {task5, start, Max_messages, Timeout}} || PL <- PLs].

spawnProcesses(NumProcesses, PLReliability) ->
  Processes = [{ProcessID, spawn(process, init, [ProcessID])} 
             || ProcessID <- lists:seq(1, NumProcesses)],
  [Process ! {bind, self(), PLReliability} || {_, Process} <- Processes],
  {ProcessNames, _} = lists:unzip(Processes),
  ProcessNames.

bindPLs(NumProcesses) ->
  PLs = receivePLs(NumProcesses, []),
  [PL ! {bind_pls, lists:filter(fun({PL2, _}) -> PL /= PL2 end, PLs)} 
   || {_, PL} <- PLs],
  {_, IDs} = lists:unzip(PLs),
  IDs.

receivePLs(NumProcesses, PLs) ->
  case NumProcesses of
    0 -> PLs;
    _ -> 
      receive {bind_pl, Process, ID} ->
                PLs2 = lists:append(PLs, [{Process, ID}]),
                receivePLs(NumProcesses - 1, PLs2)
      end
  end.
