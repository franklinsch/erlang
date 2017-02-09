%%% Franklin Schrans (fs2014)

-module(process).
-export([init/1]).

init(Name) ->
  PL = spawn(pl, init, []),
  receive {bind, System} -> 
            System ! {bind_pl, Name, PL},
            App = spawn(app, init, [Name]),
            App ! {bind_pl, PL},
            PL ! {bind, App}
  end.
