
%%% distributed algorithms, n.dulay, 4 jan 17
%%% simple client-server, v1

%%% run all processes on one node
 
-module(system1).
-export([start/1]).
 
start(Args) ->  
  [Arg0 | _ ] = Args,
  {NumClients, _} = string:to_integer(atom_to_list(Arg0)),
  S   = spawn(server, start, []),

  _ = lists:map(fun(_) ->
                ClientID = spawn(client, start, []),
                ClientID ! {bind, S},
                ClientID
            end,
            lists:seq(1, NumClients)).
