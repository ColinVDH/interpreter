

%!  parse_list(+LexedList, -StructuredList)
%   return parsed version of the lexed list (productions are bracketted)
parse_list(LexedList, StructuredList):-
	program(StructuredList, LexedList, []),!.


program(FunctionList) --> 
	function_list(FunctionList).

function_list([Function, FunctionListCollection]) --> 
	function(Function), 
	function_list_collection(FunctionListCollection).

function_list_collection(FunctionList) --> 
	function_list(FunctionList).
function_list_collection([]) --> [].

function([TypeID,'(',TypeIDList,')','=',Expression]) --> 
	typeID(TypeID), ['OPEN_P'], 
	typeID_list(TypeIDList), 
	['CLOSE_P','ASSIGN'], 
	expression(Expression).

typeID(['int','id']) --> 
	['TYPE_INT','IDENTIFIER'].
typeID(['bool','id']) --> 
	['TYPE_BOOL','IDENTIFIER'].

typeID_list([TypeID, TypeIDListCollection]) --> 
	typeID(TypeID), 
	typeID_list_collection(TypeIDListCollection).

typeID_list_collection([',',TypeIDList]) --> 
	['COMMA'], 
	typeID_list(TypeIDList).
typeID_list_collection([]) --> [].

expression(['if', Comparison, 'then', Value1, 'else', Value2]) --> 
	['COND_IF'], 
	comparison(Comparison),
	['COND_THEN'], 
	value(Value1), 
	['COND_ELSE'], 
	value(Value2).
expression(['let', 'id', '=', Value, 'in', Expression]) --> 
	['LET','IDENTIFIER','ASSIGN'], 
	value(Value), 
	['LET_IN'], 
	expression(Expression).
expression([Value,ExtraExpression]) --> 
	value(Value), 
	extra_expression(ExtraExpression).

extra_expression(Arithmetic)--> 
	arithmetic(Arithmetic).
extra_expression([])--> [].

arithmetic(['+',Value])--> 
	['ARITH_ADD'], 
	value(Value).
arithmetic(['-',Value])-->
	['ARITH_SUB'], 
	value(Value).

comparison([Value, ComparisonRight])--> 
	value(Value), 
	comparison_right(ComparisonRight).

comparison_right(['==',Value])-->
	['LOGIC_EQ'], 
	value(Value).
comparison_right(['!=',Value])-->
	['LOGIC_NOT_EQ'], 
	value(Value).
comparison_right(['>',Value])-->
	['LOGIC_GT'],
	value(Value).
comparison_right(['>=',Value])-->
	['LOGIC_GTEQ'],
	value(Value).

value('num') --> 
	['INTEGER'].
value(['id', ValueParameters])--> 
	['IDENTIFIER'], 
	value_parameters(ValueParameters).

value_parameters(['(',Parameters,')'])--> 
	['OPEN_P'], 
	parameters(Parameters), 
	['CLOSE_P'].
value_parameters([])-->[].

parameters([Value, ParametersList])-->
	value(Value), 
	parameters_list(ParametersList).

parameters_list([',',Parameters])-->
	['COMMA'], 
	parameters(Parameters).
parameters_list([])-->[].



%!  format_list(+TokenList, +StructuredList, -FormattedList)
%   generate formatted list from token list and structured (parsed) list. 
%   formatted list is the structured list with the identifiers and numbers replaced.
format_list(TokenList, StructuredList, FormattedList):-
	format_list(TokenList, _, StructuredList, FormattedList),!.
format_list(TokenList,TokenList,[],[]).
format_list(TokenList, TokenListSuffix, [H1|StructuredList], [H2|FormattedList]):-
	is_list(H1),
	format_list(TokenList, Remaining, H1, H2),
	format_list(Remaining, TokenListSuffix, StructuredList, FormattedList).
format_list([H|TokenList], TokenListSuffix, [_|StructuredList], [H|FormattedList]):-
	format_list(TokenList, TokenListSuffix, StructuredList, FormattedList).
