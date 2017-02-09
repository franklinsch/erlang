%%% Franklin Schrans (fs2014)

-module(system1).
-export([start/0]).

start() ->
  NumProcesses = 5,
  Processes = spawnProcesses(NumProcesses),
  [Process ! {task1, start, 1000, 3000} || {_, Process} <- Processes].

spawnProcesses(NumProcesses) ->
  Processes = [{ProcessID, spawn(client, init, [ProcessID])} 
               || ProcessID <- lists:seq(1, NumProcesses)],
  [Process ! {neighbors, Processes} || {_, Process} <- Processes],
  Processes.
