


%!  lexer(+TokenList, -LexedList)
%   return lexed version of a token list
lexer([], []):-!.
lexer([H1|TokenList], [H2|LexedList]):-
	convert_token(H1, H2),
	lexer(TokenList, LexedList),!.

convert_token('int', 'TYPE_INT').
convert_token('bool','TYPE_BOOL').
convert_token(',','COMMA').
convert_token('=','ASSIGN').
convert_token('let','LET').
convert_token('in','LET_IN').
convert_token('if','COND_IF').
convert_token('then', 'COND_THEN').
convert_token('else','COND_ELSE').
convert_token('==','LOGIC_EQ').
convert_token('!=','LOGIC_NOT_EQ').
convert_token('>','LOGIC_GT').
convert_token('>','LOGIC_GTEQ').
convert_token('+','ARITH_ADD').
convert_token('-','ARITH_SUB').
convert_token('(','OPEN_P').
convert_token(')','CLOSE_P').
convert_token(Atom, 'INTEGER'):-
	atom_number(Atom, Number),
	integer(Number).
convert_token(_, 'IDENTIFIER').


	