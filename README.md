# Interpreter
Author: Colin Vandenhof  
©2017 MIT License 

## Overview 
This interpreter interprets simple scripts given in plain-text files. It was written in Prolog for [CSCI 3136] Principles of Programming Languages, Winter 2017. [SWI-Prolog] is required to use the interpreter.

## Features
* Example script, sample.txt:
```
int add ( int a , int b ) = a + b 
int subtract ( int a , int b ) = a - b 
int letin ( int a ) = let b = 10 in add ( a , b ) 
int equal ( int a , int b ) = if a == b then letin ( a ) else subtract ( a , 199 ) 
int main ( int input ) = equal ( input , 2 ) 

``` 
* Scripts are given in plain-text files, with space-delimited tokens.
* Scripts can contain multiple function definitions, but the interpreter always returns the output from ```main```
* Supports integer and Boolean values for function arguments and return values
* Supports if-else conditional statements and let-in statements.
* Arithmetic operators are implemented for:  
  * addition (`+`)  
  * subtraction (`-`)  
* Relational operators are implemented for:  
  * equal to (`==`)  
  * not equal to (`!=`)  
  * greater than (`>`)  
  * greater than or equal to (`>=`)   
* The example script shows the basic syntax for function definitions.


## Execution
1. In the command line, navigate to the directory containing the interpreter and the script. 2. Run SWI-Prolog
```
swipl
```
2. Load the interpreter
```
[language_executor].
```
3. Run the script
```
run_program(<filename>, <input arguments>, Result).
```
where <filename> is the name of the script (eg. 'sample.txt'),  <input arguments> is a list of arguments for ```main``` (eg. [1]), and Result is the variable that is unified to the output of ```main```. If the script is not valid, or invalid arguments are given, then `false` is returned.

## Source code
* `tokenizer.pl` is used to read in the space-delimited script and create a list of tokens.
* `lexer.pl` converts the list of tokens to a list of token types (lexed list) 
* `grammar.pl` specifies a definite clause grammar that defines the scripting language.
* `parser.pl` converts the lexed list into a structured (bracketed) list, based on the definite clause grammar. Indentifiers and values are recovered from the token list, and injected into the structured list. 
* `symmbol_table.pl` defines predicates to add and remove symbols from the global symbol table. 
* `interpreter.pl` takes in the structured list and returns the output of ```main```.
* `language_executor.pl` contains the `run_program/3` predicate. This subgoals of this predicate are all of the steps in the pipeline (from tokenizer to interpreter).

[CSCI 3136]: http://academiccalendar.dal.ca/Catalog/ViewCatalog.aspx?pageid=viewcatalog&entitytype=CID&entitycode=CSCI+3136  
[SWI-Prolog]: http://portableapps.com/apps/development/swi-prolog_portable  
