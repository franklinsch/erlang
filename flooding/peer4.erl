-module(peer4).

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
            next(Index, Peers, 1, Parent, length(Peers))
  end.

next(Index, Peers, Count, Parent, NumChildren) ->
  receive {hello} ->
            next(Index, Peers, Count + 1)
  after 1000 ->
          io:format("Peer ~p Parent ~p Messages seen = ~p Children ~p~n", [Index, Parent, Count, NumChildren]),
          exit(normal)
  end.

