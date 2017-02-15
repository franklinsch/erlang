%%% Franklin Schrans (fs2014)

-module(beb).
-export([init/0]).

init() ->
  Processes = processesReceive(),
  receive {bind, PL, RB} -> 
            RB ! {beb_deliver, 0, {rb_data, 0, {neighbors, Processes}}},
            next(Processes, PL, RB) end.

processesReceive() ->
  receive {pl_deliver, _, {beb_processes, Processes}} -> Processes end.

next(Processes, PL, RB) ->
  receive
    {beb_broadcast, Msg} ->
      [ PL ! {pl_send, Dest, Msg} || Dest <- Processes ];
    {pl_deliver, From, Msg} ->
      RB ! {beb_deliver, From, Msg}
  end,
  next(Processes, PL, RB).
