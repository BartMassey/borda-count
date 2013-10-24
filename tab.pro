% Copyright © 2013 Bart Massey and Cameron White
% [This program is licensed under the "MIT License"]
% Please see the file COPYING in the source
% distribution of this software for license terms.

addVote(L, _, Vs, Vs_out) :-
        char_code('-', L),
        Vs_out = Vs.
addVote(L, C, [V | Vs], Vs_out) :-
        length(Vs, N),
        char_code('a', A),
        N =:= 5 - (L - A),
        T is V + C,
        Vs_out = [T | Vs].
addVote(L, C, [V | Vs], Vs_out) :-
        addVote(L, C, Vs, Vs_new),
        Vs_out = [V | Vs_new].

getAndCountVotes(_, _, Vs_in, Vs_out) :-
        at_end_of_stream,
        Vs_out = Vs_in.
getAndCountVotes(Cs0, [], Vs_in, Vs_out) :-
        get_code(_),   % discard newline
        getAndCountVotes(Cs0, Cs0, Vs_in, Vs_out).
getAndCountVotes(Cs0, [C | Cs], Vs_in, Vs_out) :-
        get_code(L),
        addVote(L, C, Vs_in, Vs_new),
        getAndCountVotes(Cs0, Cs, Vs_new, Vs_out).

tupleVotes("", [], []).
tupleVotes([L | Ls], [V | Vs], Ts) :-
        tupleVotes(Ls, Vs, Ts0),
        Ts = [vote(V, L) | Ts0].

printVotes([]).
printVotes([vote(V, L) | Ts]) :-
        put_code(L), write(': '), writeln(V),
        printVotes(Ts).

main :-
        prompt(_,''),
        getAndCountVotes([6,5,4,3,2,1], [6,5,4,3,2,1], [0,0,0,0,0,0], Votes),
        tupleVotes("abcdef", Votes, TupledVotes),
        sort(TupledVotes, SortedVotes), 
        reverse(SortedVotes, ReversedVotes),
        printVotes(ReversedVotes).
