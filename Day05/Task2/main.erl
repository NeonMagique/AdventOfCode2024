-module(main).
-export([main/1]).

main(Filename) ->
    {ok, Binary} = file:read_file(Filename),
    Parts = binary:split(Binary, <<"\n\n">>, [global, trim]),
    First = binary:split(lists:nth(1, Parts), <<"\n">>, [global, trim]),
    Rules = [process_pair(Line) || Line <- First],
    Second = binary:split(lists:nth(2, Parts), <<"\n">>, [global, trim]),
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
        false ->
            Sorted_list = order_line(Line, Rules),
            Len = length(Sorted_list),
            MidIndex = Len div 2,
            lists:nth(MidIndex + 1, Sorted_list);
        true ->
            0
    end.

order_line(Line, Rules) ->
    case lists:all(fun(Rule) -> validate_rule(Line, Rule) end, Rules) of
        false ->
            {IndexA, IndexB} = get_index(Line, Rules),
            NewLine = swap_elements(Line, IndexA, IndexB),
            order_line(NewLine, Rules);
        true ->
            Line
    end.

get_index(Line, [Rule | Rest]) ->
    case validate_rule(Line, Rule) of
        true -> get_index(Line, Rest);
        false ->
            {A, B} = Rule,
            IndexA = lists:nth(1, [Idx || {Val, Idx} <- lists:zip(Line, lists:seq(1, length(Line))), Val == A]),
            IndexB = lists:nth(1, [Idx || {Val, Idx} <- lists:zip(Line, lists:seq(1, length(Line))), Val == B]),
            {IndexA, IndexB}
    end;
get_index(_, []) -> {0, 0}.


swap_elements(List, IndexA, IndexB) ->
    {ElemA, ElemB} = {lists:nth(IndexA, List), lists:nth(IndexB, List)},
    List1 = lists:sublist(List, IndexA - 1) ++ [ElemB] ++ lists:nthtail(IndexA, List),
    lists:sublist(List1, IndexB - 1) ++ [ElemA] ++ lists:nthtail(IndexB, List1).

validate_rule(Numbers, {A, B}) ->
    case {lists:member(A, Numbers), lists:member(B, Numbers)} of
        {true, true} ->
            IndexA = lists:nth(1, [Idx || {Val, Idx} <- lists:zip(Numbers, lists:seq(1, length(Numbers))), Val == A]),
            IndexB = lists:nth(1, [Idx || {Val, Idx} <- lists:zip(Numbers, lists:seq(1, length(Numbers))), Val == B]),
            IndexA < IndexB;
        _ ->
            true
    end.
