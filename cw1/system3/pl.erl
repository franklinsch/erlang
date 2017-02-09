%%% Franklin Schrans (fs2014)

-module(pl).
-export([init/0]).

init() ->
  PLs = bindPLs(),
  receive {bind_beb, BEB} -> 
            receive {bind, Client} -> next(Client, PLs, BEB) 
            end
  end.

bindPLs() ->
  receive {bind_pls, PLs} -> maps:from_list(PLs) end.

next(Process, PLs, BEB) ->
  receive {pl_send, Dest, M} -> maps:get(Dest, PLs) ! {pl_msg, Process, M};
          {pl_msg, From, M} -> 
            BEB ! {pl_deliver, From, M}
  end,
  next(Process, PLs, BEB).
