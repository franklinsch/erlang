
%%% distributed algorithms, n.dulay, 4 jan 17
%%% simple client-server, v1

-module(client).
-export([start/0]).
 
start() -> 
  receive 
    {bind, S} -> next(S) 
  end.
 
next(S) ->
  Shape = case rand:uniform(2) of
            1 -> circle;
            2 -> square
          end,
  Sleep = rand:uniform(10),
  S ! {Shape, 1.0, self()},
  receive 
    {result, Area} -> 
      io:format("Client ~p: Area is ~p~n", [self(), Area]) 
  end,
  timer:sleep(Sleep * 1000),
  next(S).

