%%% Franklin Schrans (fs2014)

-module(process).
-export([init/1]).

init(Name) ->
  receive {bind, System} -> 
            PL = spawn(pl, init, []),
            System ! {bind_pl, Name, PL},
            App = spawn(app, init, [Name]),
            App ! {bind_pl, PL},
            PL ! {bind, App}
  end.
