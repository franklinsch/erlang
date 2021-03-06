-module(peer4).

-export([start/1]).

start(Index) ->
  Peers = neighbours(),
  next(Index, Peers, 0).

neighbours() ->
  receive {neighbours, Peers} -> Peers
  end.

next(Index, Peers, 0) ->
  receive {hello, Parent, ParentID} -> 
            lists:foreach(fun(Peer) ->
                              Peer ! {hello, Index, self()}
                          end,
                          Peers),
            case ParentID of
              0 -> ok;
              _ -> ParentID ! child
            end,
            next(Index, Peers, 1, Parent, 0)
  end.

next(Index, Peers, Count, Parent, Children) ->
  receive {hello, Parent} ->
            next(Index, Peers, Count + 1, Parent, Children);
          child ->
            next(Index, Peers, Count + 1, Parent, Children + 1)
  after 1000 ->
          io:format("Peer ~p Parent ~p Messages seen = ~p Children ~p~n", [Index, Parent, Count, Children]),
          exit(normal)
  end.

