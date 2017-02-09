%%% Franklin Schrans (fs2014)

-module(system3).
-export([start/0]).

start() ->
  NumProcesses = 5,
  Processes = spawnProcesses(NumProcesses),
  PLs = bindPLs(NumProcesses),
  [PL ! {pl_msg, 0, {beb_processes, Processes}} || PL <- PLs],
  [PL ! {pl_msg, 0, {task3, start, 1000, 1000}} || PL <- PLs].

spawnProcesses(NumProcesses) ->
  Processes = [{ProcessID, spawn(process, init, [ProcessID])} 
             || ProcessID <- lists:seq(1, NumProcesses)],
  [Process ! {bind, self()} || {_, Process} <- Processes],
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
