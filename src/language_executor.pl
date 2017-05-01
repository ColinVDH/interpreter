:-load_files('tokenizer.pl').
:-load_files('lexer.pl').
:-load_files('grammar.pl').
:-load_files('interpreter.pl').


run_program(FileName, Arguments, Result):-
	tokenize_file(FileName, TokenList),
	lexer(TokenList, LexedList),
	parse_list(LexedList, ParsedList),!,
	format_list(TokenList, ParsedList, FormattedList),!,
	interpreter(FormattedList, Arguments, Result),!.

