%%% Franklin Schrans (fs2014)

-module(pl).
-export([init/0]).

init() ->
  PLs = bindPLs(),
  receive {bind, Client} -> next(Client, PLs) 
  end.

bindPLs() ->
  receive {bind_pls, PLs} -> maps:from_list(PLs)
  end.

next(Client, PLs) ->
  receive {pl_send, Dest, M} -> maps:get(Dest, PLs) ! {pl_msg, M};
          {pl_msg, M} -> Client ! {pl_deliver, M}
  end,
  next(Client, PLs).
