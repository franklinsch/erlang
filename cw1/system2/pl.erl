%%% Franklin Schrans (fs2014)

-module(pl).
-export([init/1]).

init(Client) ->
  PLs = bindPLs(),
  next(Client, PLs).

bindPLs() ->
  receive {bind_pl, PLs} -> PLs
  end.

next(Client, PLs) ->
  receive {pl_send, M} ->
            [PL ! M || PL <- PLs],
            next(Client, PLs);
          M ->
            Client ! {pl_deliver, M},
            next(Client, PLs)
  end.
