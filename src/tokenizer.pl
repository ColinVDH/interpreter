%! tokenize_file(+FileName, -TokenList)
% supply a FileName string, list of atoms in the file will be printed.
tokenize_file(FileName, TokenList):-
    open(FileName,read,Stream),
    read_chars(Stream, CharList),
    close(Stream),!,
    process_chars(CharList, TokenList).
 

%! read_chars(+Stream, -List)
% reads chars from the Stream and store as elements in the list
read_chars(Stream,[]):-
     at_end_of_stream(Stream).
read_chars(Stream,[W|L]):-
     \+  at_end_of_stream(Stream),
     get_char(Stream,W),
     read_chars(Stream,L). 

%! process_chars(+L1, -L2)
% takes list of chars L1, and converts into a list of Atoms L2.
process_chars(L1, L2):-
    process_chars(L1, '',L2).

%! process_chars(+L1, +PartialToken -L2)
% takes list of chars L1, and partial Token, converts into a list of Atoms L2.
process_chars([Curr|L1], PartialToken, L2):- 
    \+char_type(Curr, space), 
    atom_concat(PartialToken, Curr, NextPartialToken),
    process_chars(L1, NextPartialToken, L2).
process_chars([Curr|L1], Token, L2):- 
    char_type(Curr,space),
    Token = '',  %no Token in progress
    process_chars(L1, '', L2).
process_chars([Curr|L1], Token, [Token|L2]):- %add completed Token to list
    char_type(Curr,space),
    \+Token='',
    process_chars(L1, '', L2).
process_chars([], '', []).
process_chars([], Token, [Token]):-
    \+Token=''.












