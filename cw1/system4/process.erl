%%% Franklin Schrans (fs2014)

-module(process).
-export([init/1]).

init(Name) ->
  receive {bind, System, PLReliability} -> 
            BEB = spawn(beb, init, []),
            PL = spawn(lossyp2plinks, init, [PLReliability]),
            PL ! {bind_beb, BEB},
            System ! {bind_pl, Name, PL},
            App = spawn(app, init, [Name]),
            PL ! {bind, {Name, App}},
            App ! {bind_beb, BEB},
            BEB ! {bind, PL, App}
  end.
