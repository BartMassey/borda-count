countVotes(In, 0, 0, 0, 0, 0, 0) :-
    at_end_of_stream(In).
countVotes(In, A1, B1, C1, D1, E1, F1) :-
    get_char(In, X1), get_char(In, X2), get_char(In, X3),
    get_char(In, X4), get_char(In, X5), get_char(In, X6),
    get_char(In,  _),
    countVotes(In, A, B, C, D, E, F),
    tallyVotes(X1, 6, A, B, C, D, E, F,
                      A1, B1, C1, D1, E1, F1),
    tallyVotes(X2, 5, A, B, C, D, E, F,
                      A1, B1, C1, D1, E1, F1),
    tallyVotes(X3, 4, A, B, C, D, E, F, 
                      A1, B1, C1, D1, E1, F1),
    tallyVotes(X4, 3, A, B, C, D, E, F, 
                      A1, B1, C1, D1, E1, F1),
    tallyVotes(X5, 2, A, B, C, D, E, F, 
                      A1, B1, C1, D1, E1, F1),
    tallyVotes(X6, 1, A, B, C, D, E, F,
                      A1, B1, C1, D1, E1, F1).

tallyVotes(X, N, A, B, C, D, E, F,
                 A1, B1, C1, D1, E1, F1) :-
    X = a, A1 is A + N;
    X = b, B1 is B + N;
    X = c, C1 is C + N;
    X = d, D1 is D + N;
    X = e, E1 is E + N;
    X = f, F1 is F + N.

main :-
    open('votes.txt', read, In),
    countVotes(In, A, B, C, D, E, F),
    write([A,B,C,D,E,F]),
    close(In).

