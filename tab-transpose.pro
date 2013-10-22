% Copyright © 2013 Cameron White 

getVotesByColumn(In, [], [], [], [], [], []) :-
    at_end_of_stream(In).
getVotesByColumn(In, [X1|X1s], [X2|X2s], [X3|X3s], 
                     [X4|X4s], [X5|X5s], [X6|X6s]) :-
    get_char(In, X1), get_char(In, X2), get_char(In, X3),
    get_char(In, X4), get_char(In, X5), get_char(In, X6),
    get_char(In,  _),
    getVotesByColumn(In, X1s, X2s, X3s, X4s, X5s, X6s).

multiplyList(Xs, 1, Xs).
multiplyList(Xs, N, Ys) :-
    N > 1,
    N1 is N - 1,
    multiplyList(Xs, N1, Y1s),
    append(Y1s, Xs, Ys).

concatenate6(X1s, X2s, X3s, X4s, X5s, X6s, Ys) :-
    append(X1s, X2s, Y1s),
    append(Y1s, X3s, Y2s),
    append(Y2s, X4s, Y3s),
    append(Y3s, X5s, Y4s),
    append(Y4s, X6s, Ys).

countVotes([], 0, 0, 0, 0, 0, 0).
countVotes([X|Xs], A, B, C, D, E, F) :-
    countVotes(Xs, A1, B1, C1, D1, E1, F1),
    countVote(X, A1, B1, C1, D1, E1, F1, A, B, C, D, E, F).

countVote(a, A1, B, C, D, E, F, A, B, C, D, E, F) :- A is A1 + 1.
countVote(b, A, B1, C, D, E, F, A, B, C, D, E, F) :- B is B1 + 1.
countVote(c, A, B, C1, D, E, F, A, B, C, D, E, F) :- C is C1 + 1.
countVote(d, A, B, C, D1, E, F, A, B, C, D, E, F) :- D is D1 + 1.
countVote(e, A, B, C, D, E1, F, A, B, C, D, E, F) :- E is E1 + 1.
countVote(f, A, B, C, D, E, F1, A, B, C, D, E, F) :- F is F1 + 1.
countVote(-, A, B, C, D, E, F, A, B, C, D, E, F).

main :-
    open('votes.txt', read, In),
    getVotesByColumn(In, As, Bs, Cs, Ds, Es, Fs),
    multiplyList(As, 6, A1s),
    multiplyList(Bs, 5, B1s),
    multiplyList(Cs, 4, C1s),
    multiplyList(Ds, 3, D1s),
    multiplyList(Es, 2, E1s),
    multiplyList(Fs, 1, F1s),
    concatenate6(A1s, B1s, C1s, D1s, E1s, F1s, Xs),
    countVotes(Xs, A, B, C, D, E, F),
    write('a:'), writeln(A),
    write('b:'), writeln(B),
    write('c:'), writeln(C),
    write('d:'), writeln(D),
    write('f:'), writeln(E),
    write('g:'), writeln(F),
    close(In).
