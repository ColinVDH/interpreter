:-load_files('symbol_table.pl').



interpreter(FormattedList, Arguments, Result):-
	create_empty_table(),
	initialize_functions(FormattedList),
	call_function('main', Arguments, Result),!.


call_function(Function, Arguments, Result):-
	get_symbol(Function, Descrip),
	Descrip = [ReturnType, ParameterList, CodeBody],
	type_id_list_handler(ParameterList, TypeIDs),
	extract_types(TypeIDs, Types, Names),
	type_match(Types, Arguments), %integer
	add_symbol_list(Names, Arguments),
	expression_handler(CodeBody, Result),
	type_match(ReturnType, Result), %integer
	remove_symbol_list(Names),!.



type_id_list_handler([TypeID, TypeIDListCollection], [TypeID|TypeIDs]):-
	type_id_list_collection_handler(TypeIDListCollection, TypeIDs).

type_id_list_collection_handler([],[]).%typeIDlistcollection goes to epsilon (empty list)
type_id_list_collection_handler([',', T], TypeIDs):-
	type_id_list_handler(T, TypeIDs).


extract_types([],[],[]).
extract_types([P|TypeIDs], [T|Types], [N|Names]):-
	P=[T,N],
	extract_types(TypeIDs, Types, Names).



type_match([],[]).
type_match([T|Types], [A|Arguments]):-
	type_match(T, A),
	type_match(Types, Arguments).
type_match('int', Value):-
	integer(Value).
type_match('bool', 0).
type_match('bool', 1).



expression_handler(['if', Comparison, 'then', Value1, 'else', _], Result) :-
	comparison_handler(Comparison),
	value_handler(Value1, Result).
expression_handler(['if', Comparison, 'then', _, 'else', Value2], Result) :-
	\+ comparison_handler(Comparison),
	value_handler(Value2, Result).
expression_handler(['let', Name, '=', Value, 'in', Expression], Result) :-
	value_handler(Value, Number),
	add_symbol(Name, Number),
	expression_handler(Expression, Result),
	remove_symbol(Name).
expression_handler([Value, []], Result) :- %extraexpression is episilon (empty list)
	value_handler(Value, Result).
expression_handler([Value1, ['+', Value2]], Result):-
	value_handler(Value1, Number1),
	value_handler(Value2, Number2),
	Result is Number1 + Number2.
expression_handler([Value1, ['-', Value2]], Result):-
	value_handler(Value1, Number1),
	value_handler(Value2, Number2),
	Result is Number1 - Number2.


comparison_handler([Value1, ['==', Value2]]):-
	value_handler(Value1, Number1),
	value_handler(Value2, Number2),
	Number1 =:= Number2.
comparison_handler([Value1, ['!=', Value2]]):-
	value_handler(Value1, Number1),
	value_handler(Value2, Number2),
	Number1 =\= Number2.
comparison_handler([Value1, ['>', Value2]]):-
	value_handler(Value1, Number1),
	value_handler(Value2, Number2),
	Number1 > Number2.
comparison_handler([Value1, ['>=', Value2]]):-
	value_handler(Value1, Number1),
	value_handler(Value2, Number2),
	Number1 >= Number2.


value_handler([Key, []], Number):- %ValueParameters is episilon (empty list)
	get_symbol(Key, Value), 
	value_handler(Value, Number). 
value_handler([Key, ['(', Parameters, ')']], Number):-
	parameter_handler(Parameters, Numbers), 
	call_function(Key, Numbers, Number).
value_handler(Number, Number):-
	integer(Number).
value_handler(Value, Number):-
	atom(Value),
	atom_number(Value, Number),
	integer(Number).


parameter_handler([Value, ParametersList], [N|Numbers]):- 
	value_handler(Value, N),
	parameter_list_handler(ParametersList, Numbers).

parameter_list_handler([],[]). %ParametersList is epsilon (empty list)
parameter_list_handler([',', P], Numbers):-
	parameter_handler(P, Numbers).

