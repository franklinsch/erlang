%%% Franklin Schrans (fs2014)

-module(reliable_broadcast).
-export([init/0]).

init() ->
  receive {bind, BEB, C} -> next(BEB, C, []) end.

next(BEB, C, Delivered) ->
  receive
    {rb_broadcast, M} ->
      BEB ! {beb_broadcast, {rb_data, self(), M}},
      next(BEB, C, Delivered);
    {beb_deliver, From, {rb_data, _, M}} ->
      case lists:member(M, Delivered) of
        true -> next(C, BEB, Delivered);
        false ->
          C ! {rb_deliver, From, M},
          BEB ! {beb_broadcast, {rb_data, From, M}},
          next(BEB, C, Delivered ++ [M])
      end
  end.
