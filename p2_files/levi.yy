%skeleton "lalr1.cc"
%require "3.0"
%debug
%defines
%define api.namespace{leviathan}
%define api.parser.class {Parser}
%define api.value.type variant
%define parse.error verbose
%output "parser.cc"
%token-table

%code requires{
	#include <list>
	#include "tokens.hpp"
	namespace leviathan {
		class Scanner;
	}

//The following definition is required when 
// we don't use the %locations directive (which we won't)
# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

//End "requires" code
}

%parse-param { leviathan::Scanner &scanner }
%code{
   // C std code for utility functions
   #include <iostream>
   #include <cstdlib>
   #include <fstream>

   // Our code for interoperation between scanner/parser
   #include "scanner.hpp"
   #include "tokens.hpp"

  //Request tokens from our scanner member, not 
  // from a global function
  #undef yylex
  #define yylex scanner.yylex
}


/* Terminals 
 *  No need to touch these, but do note the translation type
 *  of each node. Most are just "transToken", which is defined in
 *  the %union above to mean that the token translation is an instance
 *  of leviathan::Token *, and thus has no fields (other than line and column).
 *  Some terminals, like ID, are "transIDToken", meaning the translation
 *  also has a name field. 
*/
%token                   END	0 "end file"
%token	<leviathan::Token *>       AND
%token	<leviathan::Token *>       ASSIGN
%token	<leviathan::Token *>       BOOL
%token	<leviathan::Token *>       COLON
%token	<leviathan::Token *>       COMMA
%token	<leviathan::Token *>       DASH
%token	<leviathan::Token *>       ELSE
%token	<leviathan::Token *>       SINK
%token	<leviathan::Token *>       EQUALS
%token	<leviathan::Token *>       FALSE
%token	<leviathan::Token *>       FILE
%token	<leviathan::Token *>       OUTPUT
%token	<leviathan::Token *>       GREATER
%token	<leviathan::Token *>       GREATEREQ
%token	<leviathan::IDToken *>     ID
%token	<leviathan::Token *>       IF
%token	<leviathan::Token *>       INT
%token	<leviathan::IntLitToken *> INTLITERAL
%token	<leviathan::Token *>       IMMUTABLE
%token	<leviathan::Token *>       LCURLY
%token	<leviathan::Token *>       LESS
%token	<leviathan::Token *>       LESSEQ
%token	<leviathan::Token *>       LPAREN
%token	<leviathan::Token *>       NOT
%token	<leviathan::Token *>       NOTEQUALS
%token	<leviathan::Token *>       OR
%token	<leviathan::Token *>       CROSS
%token	<leviathan::Token *>       POSTDEC
%token	<leviathan::Token *>       POSTINC
%token	<leviathan::Token *>       RETURN
%token	<leviathan::Token *>       RCURLY
%token	<leviathan::Token *>       RPAREN
%token	<leviathan::Token *>       SEMICOL
%token	<leviathan::Token *>       SLASH
%token	<leviathan::Token *>       STAR
%token	<leviathan::StrToken *>    STRINGLITERAL
%token	<leviathan::Token *>       INPUT
%token	<leviathan::Token *>       LBRACKET
%token	<leviathan::Token *>       RBRACKET
%token	<leviathan::Token *>       THRASH
%token	<leviathan::Token *>       TRUE
%token	<leviathan::Token *>       VOID
%token	<leviathan::Token *>       WHILE


/* NOTE: Make sure to add precedence and associativity 
 * declarations
 */

%%

program 	: globals
		  {
		  //For the project, we will only be checking std::cerr for 
		  // correctness. You might choose to uncomment the following
		  // Line to help you debug, which will print when this
		  // production is applied
		  //std::cout << "got to the program ::= globals rule\n";
		  }

globals 	: globals varDecl SEMICOL
	  	  {
	  	  }
		| /* epsilon */
		  {
		  }

varDecl 	: id COLON type
		  {
		  /* There are other rules for varDecl to add as well */
		  }

type		: INT
		  {
		  }

id		: ID
		  {
		  }
 /* TODO: add productions for the entire grammar of the language */
	
%%

void leviathan::Parser::error(const std::string& msg){
	//For the project, we will only be checking std::cerr for 
	// correctness. You might choose to uncomment the following
	// Line to help you debug, since it gives slightly more 
	// descriptive error messages 
	//std::cout << msg << std::endl;
	std::cerr << "syntax error" << std::endl;
}
