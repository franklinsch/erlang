-module(system3).

-export([start/0]).

start() ->
  Peers = lists:map(fun(Index) ->
                spawn(peer3, start, [Index])
            end,
            lists:seq(1, 10)),

  neighbours(Peers, 1, [2, 7]),
  neighbours(Peers,2,[1,3,4]),
  neighbours(Peers,3,[2,4,5]),
  neighbours(Peers,4,[2,3,6]),
  neighbours(Peers,5,[3]),
  neighbours(Peers,6,[4]),
  neighbours(Peers,7,[1,8]),
  neighbours(Peers,8,[7,9,10]),
  neighbours(Peers, 9, [8, 10]),
  neighbours(Peers, 10, [8, 9]),

  [FirstPeer | _] = Peers,
  FirstPeer ! {hello, 0}.

neighbours(Peers, Index, Neighbours) ->
  Peer = lists:nth(Index, Peers),
  NeighbourPIDs = lists:map(fun(NeighbourIndex) ->
                                lists:nth(NeighbourIndex, Peers)
                            end,
                            Neighbours),
  Peer ! {neighbours, NeighbourPIDs}.
