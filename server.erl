
%%% distributed algorithms, n.dulay, 4 jan 17
%%% simple client-server, v1

-module(server).
-export([start/0]).
 
start() ->  
  next().

next() ->
  receive
    {circle, Radius, ClientID} ->  ClientID ! {result, 3.14159 * Radius * Radius};
    {square, Side, ClientID}   ->  ClientID ! {result, Side * Side}
  end,
  next().
