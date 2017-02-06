-module(system1).

-export([start/0]).

start() ->
  Peers = lists:map(fun(Index) ->
                spawn(peer1, start, [Index])
            end,
            lists:seq(1, 10)),
  
  neighbours(Peers, 10, [1,2,3,4,5,6,7,8,9]),
  neighbours(Peers, 9, [1,2,3,4,5,6,7,8,10]),
  neighbours(Peers, 8, [1,2,3,4,5,6,7,9,10]),
  neighbours(Peers, 7, [1,2,3,4,5,6,8,9,10]),
  neighbours(Peers, 6, [1,2,3,4,5,7,8,9,10]),
  neighbours(Peers, 5, [1,2,3,4,6,7,8,9,10]),
  neighbours(Peers, 4, [1,2,3,5,6,7,8,9,10]),
  neighbours(Peers, 3, [1,2,4,5,6,7,8,9,10]),
  neighbours(Peers, 2, [1,3,4,5,6,7,8,9,10]),
  neighbours(Peers, 1, [2,3,4,5,6,7,8,9,10]),

  [FirstPeer | _] = Peers,
  FirstPeer ! {hello}.

neighbours(Peers, Index, Neighbours) ->
  Peer = lists:nth(Index, Peers),
  NeighbourPIDs = lists:map(fun(NeighbourIndex) ->
                                lists:nth(NeighbourIndex, Peers)
                            end,
                            Neighbours),
  Peer ! {neighbours, NeighbourPIDs}.
