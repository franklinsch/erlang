%%% Franklin Schrans (fs2014)

-module(beb).
-export([init/0]).

init() ->
  Processes = processesReceive(),
  receive {bind, PL, C} -> 
            C ! {beb_deliver, {neighbors, Processes}},
            next(Processes, PL, C) end.

processesReceive() ->
  receive {pl_deliver, _, {beb_processes, Processes}} -> Processes end.

next(Processes, PL, C) ->
  receive
    {beb_broadcast, Msg} ->
      [ PL ! {pl_send, Dest, Msg} || Dest <- Processes ];
    {pl_deliver, From, Msg} ->
      C ! {beb_deliver, From, Msg}
  end,
  next(Processes, PL, C).
