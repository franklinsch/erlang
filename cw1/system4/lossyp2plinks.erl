%%% Franklin Schrans (fs2014)

-module(lossyp2plinks).
-export([init/1]).

init(Reliability) ->
  PLs = bindPLs(),
  receive {bind_beb, BEB} -> 
            receive {bind, {Name, Client}} -> next(Name, Client, PLs, BEB, Reliability) 
            end
  end.

bindPLs() ->
  receive {bind_pls, PLs} -> maps:from_list(PLs) end.

next(Name, Process, PLs, BEB, Reliability) ->
  receive {pl_send, Dest, M} -> 
            unreliableSend({pl_msg, Name, M}, maps:get(Dest, PLs), Reliability);
          {pl_msg, From, M} -> 
            BEB ! {pl_deliver, From, M}
  end,
  next(Name, Process, PLs, BEB, Reliability).

unreliableSend(M, Dest, Reliability) ->
  case rand:uniform(100) =< Reliability of
    true -> Dest ! M;
    false -> ok
  end.
