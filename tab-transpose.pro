% Copyright © 2013 Cameron White 
% [This program is licensed under the "MIT License"]
% Please see the file COPYING in the source
% distribution of this software for license terms.

% Gets all the votes by column, multiply each column
% by its respective point value, concatenates each 
% column list together, then counts up the occurrences
% of each letter as A, B, C, D, E, and F.
getAndCountVotes([(A,a), (B,b), (C,c), (D,d), (E,e), (F,f)]) :-
    getVotesByColumn(user_input, As, Bs, Cs, Ds, Es, Fs),
    multiplyList(As, 6, A1s),
    multiplyList(Bs, 5, B1s),
    multiplyList(Cs, 4, C1s),
    multiplyList(Ds, 3, D1s),
    multiplyList(Es, 2, E1s),
    multiplyList(Fs, 1, F1s),
    concatenate6(A1s, B1s, C1s, D1s, E1s, F1s, Xs),
    countVotes(Xs, A, B, C, D, E, F).

% For every line in the file In getVotesByColumn will put
% all the votes that appear in the first column into the
% first list, all the votes that appear in the second 
% column in the second list and so forth.
getVotesByColumn(In, [], [], [], [], [], []) :-
    at_end_of_stream(In).
getVotesByColumn(In, [X1|X1s], [X2|X2s], [X3|X3s], 
                     [X4|X4s], [X5|X5s], [X6|X6s]) :-
    get_char(In, X1), get_char(In, X2), get_char(In, X3),
    get_char(In, X4), get_char(In, X5), get_char(In, X6),
    get_char(In,  _),
    getVotesByColumn(In, X1s, X2s, X3s, X4s, X5s, X6s).

% Multiply the list Xs by N into Ys.
multiplyList(Xs, 1, Xs).
multiplyList(Xs, N, Ys) :-
    N > 1,
    N1 is N - 1,
    multiplyList(Xs, N1, Y1s),
    append(Y1s, Xs, Ys).

% Concatenate6 will concatentate 6 lists together into Ys.
concatenate6(X1s, X2s, X3s, X4s, X5s, X6s, Ys) :-
    append(X1s, X2s, Y1s),
    append(Y1s, X3s, Y2s),
    append(Y2s, X4s, Y3s),
    append(Y3s, X5s, Y4s),
    append(Y4s, X6s, Ys).

% Given a list of characters as the first argument
% countVote will determine the number of occurrences
% of the letters a, b, c, d, e, f repectfully.
countVotes([], 0, 0, 0, 0, 0, 0).
countVotes([X|Xs], A, B, C, D, E, F) :-
    countVotes(Xs, A1, B1, C1, D1, E1, F1),
    countVote(X, A1, B1, C1, D1, E1, F1, A, B, C, D, E, F).

% The first argument is a letter. The next 6 arguments are the 
% previous vote count A-F. The last 6 arguments are the new 
% vote count A-F. countVote will increment the appropriate 
% count depending on the input letter.
countVote(a, A1, B, C, D, E, F, A, B, C, D, E, F) :- A is A1 + 1.
countVote(b, A, B1, C, D, E, F, A, B, C, D, E, F) :- B is B1 + 1.
countVote(c, A, B, C1, D, E, F, A, B, C, D, E, F) :- C is C1 + 1.
countVote(d, A, B, C, D1, E, F, A, B, C, D, E, F) :- D is D1 + 1.
countVote(e, A, B, C, D, E1, F, A, B, C, D, E, F) :- E is E1 + 1.
countVote(f, A, B, C, D, E, F1, A, B, C, D, E, F) :- F is F1 + 1.
countVote(-, A, B, C, D, E, F, A, B, C, D, E, F).

% Given the 6 votecounts printVotes will print them out.
% The Votes are a list of tuples where the first item
% is the count and the secound item is the letter.
printVotes([]).
printVotes([(C,L)|Votes]) :-
    write(L), write(': '), writeln(C),
    printVotes(Votes).

main :-
    prompt(_,''),
    getAndCountVotes(Votes),
    sort(Votes, SortedVotes), 
    reverse(SortedVotes, ReversedVotes),
    printVotes(ReversedVotes).
