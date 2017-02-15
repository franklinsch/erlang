%%% Franklin Schrans (fs2014)

-module(system1).
-export([start/1]).

start(Args) ->
  [First, Second | _] = Args,
  {Max_messages, _} = string:to_integer(atom_to_list(First)),
  {Timeout, _} = string:to_integer(atom_to_list(Second)),

  NumProcesses = 5,
  Processes = spawnProcesses(NumProcesses),
  [Process ! {task1, start, Max_messages, Timeout} 
   || {_, Process} <- Processes].

spawnProcesses(NumProcesses) ->
  Processes = [{ProcessID, spawn(client, init, [ProcessID])} 
               || ProcessID <- lists:seq(1, NumProcesses)],
  [Process ! {neighbors, Processes} || {_, Process} <- Processes],
  Processes.
