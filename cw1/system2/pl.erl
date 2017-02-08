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
  receive {pl_send, Msg} ->
            [PL ! {pl_deliver, Msg} || PL <- PLs],
            next(Client, PLs)
  end.
