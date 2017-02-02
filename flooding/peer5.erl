-module(peer5).

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
            next(Index, Peers, 1, Parent, ParentID, 0)
  end.

next(Index, Peers, Count, Parent, ParentID, Children) ->
  receive {hello, Parent} ->
            next(Index, Peers, Count + 1, Parent, ParentID, Children);
          child ->
            next(Index, Peers, Count + 1, Parent, ParentID, Children + 1)
  after 1000 ->
          TotalChildren = children(Index, Children, 0),
          case ParentID of
            % If ParentID is invalid (i.e. if the parent process is system5, do not forward message.
            0 -> ok;
            _ -> 
              ParentID ! {totalChildren, TotalChildren + 1}
          end,
          io:format("Peer ~p Parent ~p Messages seen = ~p Children ~p TotalChildren ~p~n", [Index, Parent, Count, Children, TotalChildren])
  end.


children(Index, Children, Sum) ->
  case Children of
    0 -> Sum;
    _ -> receive
           {totalChildren, TotalChildren} ->
             children(Index, Children - 1, Sum + TotalChildren)
         end
  end.
