%%% Franklin Schrans (fs2014)

-module(process).
-export([init/1]).

init(Name) ->
  receive {bind, System, PLReliability} -> 
            App = spawn(app, init, [Name]),
            RB = spawn(reliable_broadcast, init, []),
            BEB = spawn(beb, init, []),
            PL = spawn(lossyp2plinks, init, [PLReliability]),
            PL ! {bind_beb, BEB},
            System ! {bind_pl, Name, PL},
            PL ! {bind, {Name, App}},
            App ! {bind_rb, RB},
            BEB ! {bind, PL, RB},
            RB ! {bind, BEB, App}
  end.
