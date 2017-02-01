-module(peer1).

-export([start/1]).

start(Index) ->
  Peers = neighbours(),
  next(Index, Peers, 0).

neighbours() ->
  receive {neighbours, Peers} -> Peers
  end.

next(Index, Peers, 0) ->
  receive {hello} -> 
            lists:foreach(fun(Peer) ->
                              Peer ! {hello}
                          end,
                          Peers),
            next(Index, Peers, 1)
  end;

next(Index, Peers, Count) ->
  receive {hello} ->
            next(Index, Peers, Count + 1)
  after 1000 ->
          io:format("Peer ~p Messages seen = ~p~n", [Index, Count]),
          exit(normal)
  end.

