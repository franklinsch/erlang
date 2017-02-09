%%% Franklin Schrans (fs2014)

-module(client).
-export([init/2]).

init(Name, System) ->
  PL = spawn(pl, init, [self()]),
  System ! {bind_pl, PL}.
