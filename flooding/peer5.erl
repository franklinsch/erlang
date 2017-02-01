-module(peer5).

-export([start/1]).

start(Index) ->
  Peers = neighbours(),
  next(Index, Peers, 0).

neighbours() ->
  receive {neighbours, Peers} -> Peers
  end.

next(Index, Peers, 0) ->
  receive {hello, Parent} -> 
            lists:foreach(fun(Peer) ->
                              Peer ! {hello, Index}
                          end,
                          Peers),
            next(Index, Peers, 1, Parent, 0)
  end.

next(Index, Peers, Count, Parent, Children) ->
  receive {hello, Parent} ->
            next(Index, Peers, Count + 1, Parent, Children);
          {children, NewChildren} ->
            next(Index, Peer, Count + 1, Parent, Children + NewChildren)
  after 1000 ->
          io:format("Peer ~p Parent ~p Messages seen = ~p Children ~p~n", [Index, Parent, Count, NumChildren]),
          exit(normal)
  end.

