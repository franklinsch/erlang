%%% Franklin Schrans (fs2014)

-module(pl).
-export([init/0]).

init() ->
  PLs = bindPLs(),
  receive {bind, Client} -> next(Client, PLs) 
  end.

bindPLs() ->
  receive {bind_pl, PLs} -> PLs
  end.

next(Client, PLs) ->
  receive {pl_send, M} -> [PL ! M || PL <- PLs];
          M -> Client ! {pl_deliver, M}
  end,
  next(Client, PLs).
