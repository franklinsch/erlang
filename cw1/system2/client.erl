%%% Franklin Schrans (fs2014)

-module(client).
-export([init/1]).

init(Name) ->
  PL = spawn(pl, init, [self()]).
