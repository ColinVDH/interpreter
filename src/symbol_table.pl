:-use_module(library(assoc)).

create_empty_table():-
	empty_assoc(SymbolTable),
	b_setval(symboltable, SymbolTable),!.

initialize_functions([]). %end of functionlist
initialize_functions([[]]). %functionlistcollection goes to epsilon (empty list)
initialize_functions([[ReturnType, FunctionName], '(', ParameterList, ')','=', CodeBody]):-
	b_getval(symboltable, SymbolTable),
	put_assoc(FunctionName, SymbolTable, [[ReturnType, ParameterList, CodeBody]] , UpdatedSymbolTable),
	b_setval(symboltable, UpdatedSymbolTable),!.

initialize_functions([Function|FunctionList]):-
	initialize_functions(Function),
	initialize_functions(FunctionList),!.


add_symbol(Key, Value):-
	b_getval(symboltable, SymbolTable),
	contains_symbol(Key, SymbolTable, CurrentValues),
	put_assoc(Key, SymbolTable, [Value|CurrentValues], UpdatedSymbolTable),
	b_setval(symboltable, UpdatedSymbolTable),!.

contains_symbol(Key, SymbolTable, Value) :-
	get_assoc(Key, SymbolTable, Value). % get_assoc(+Key, +Assoc, ?Value)
contains_symbol(_, _, []).

add_symbol_list([],[]).
add_symbol_list([Key|KeyList], [Value|ValueList]):-
	add_symbol(Key, Value),
	add_symbol_list(KeyList,ValueList),!.

remove_symbol(Key):-
	b_getval(symboltable, SymbolTable),
	get_assoc(Key, SymbolTable, [_|CurrentValues], UpdatedSymbolTable, CurrentValues),
	b_setval(symboltable, UpdatedSymbolTable),!.


remove_symbol_list([]).
remove_symbol_list([K|Keys]):-
	remove_symbol(K),
	remove_symbol_list(Keys),!.

get_symbol(Key, Value):-
	b_getval(symboltable, SymbolTable),
	get_assoc(Key, SymbolTable, [Value|_]),!.


