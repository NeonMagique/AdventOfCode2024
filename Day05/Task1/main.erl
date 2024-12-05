-module(main).
-export([main/1]).

main(Filename) ->
    {ok, Binary} = file:read_file(Filename),
    Parts = binary:split(Binary, <<"\n\n">>, [global, trim]),
    First = binary:split(lists:nth(1, Parts), <<"\n">>, [global, trim]),
    Second = binary:split(lists:nth(2, Parts), <<"\n">>, [global, trim]),
    Rules = [process_pair(Line) || Line <- First],
    Lists = [
        [binary_to_integer(Item) || Item <- binary:split(Line, <<",">>, [global, trim])]
        || Line <- Second
    ],
    Sum = lists:foldl(fun(List, Acc) -> Acc + check_line(List, Rules) end, 0, Lists),

    io:format("Total Sum: ~p~n", [Sum]).

process_pair(Line) ->
    case binary:split(Line, <<"|">>, [global, trim]) of
        [A, B] -> {binary_to_integer(A), binary_to_integer(B)};
        _ -> undefined
    end.

check_line(Line, Rules) ->
    case lists:all(fun(Rule) -> validate_rule(Line, Rule) end, Rules) of
        true ->
            Len = length(Line),
            MidIndex = Len div 2,
            lists:nth(MidIndex + 1, Line);
        false ->
            0
    end.

validate_rule(Numbers, {A, B}) ->
    case {lists:member(A, Numbers), lists:member(B, Numbers)} of
        {true, true} ->
            IndexA = lists:nth(1, [Idx || {Val, Idx} <- lists:zip(Numbers, lists:seq(1, length(Numbers))), Val == A]),
            IndexB = lists:nth(1, [Idx || {Val, Idx} <- lists:zip(Numbers, lists:seq(1, length(Numbers))), Val == B]),
            IndexA < IndexB;
        _ -> true
    end.
