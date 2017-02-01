-module(peer3).

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
            next(Index, Peers, 1, Parent)
  end.

next(Index, Peers, Count, Parent) ->
  receive {hello, Parent} ->
            next(Index, Peers, Count + 1, Parent)
  after 1000 ->
          io:format("Peer ~p Parent ~p Messages seen = ~p~n", [Index, Parent, Count]),
          exit(normal)
  end.

