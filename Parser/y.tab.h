/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_DOT = 258,
    T_SINGLE = 259,
    T_SC = 260,
    T_COMMA = 261,
    T_LETTER = 262,
    T_OPBRACE = 263,
    T_CLBRACE = 264,
    T_CONTINUE = 265,
    T_BREAK = 266,
    T_POW = 267,
    T_OPEN = 268,
    T_CLOSE = 269,
    T_COMMENT = 270,
    T_INT = 271,
    T_FLOAT = 272,
    T_CHAR = 273,
    T_SWITCH = 274,
    T_DOUBLE = 275,
    T_ID = 276,
    T_NUM = 277,
    T_PLUS = 278,
    T_MINUS = 279,
    T_MULT = 280,
    T_DIV = 281,
    T_ASSIGN = 282,
    T_SPLUS = 283,
    T_SMINUS = 284,
    T_SMULT = 285,
    T_SDIV = 286,
    T_INC = 287,
    T_DEC = 288,
    T_MAIN = 289,
    T_RETURN = 290,
    T_DEFAULT = 291,
    T_CASE = 292,
    T_COLON = 293
  };
#endif
/* Tokens.  */
#define T_DOT 258
#define T_SINGLE 259
#define T_SC 260
#define T_COMMA 261
#define T_LETTER 262
#define T_OPBRACE 263
#define T_CLBRACE 264
#define T_CONTINUE 265
#define T_BREAK 266
#define T_POW 267
#define T_OPEN 268
#define T_CLOSE 269
#define T_COMMENT 270
#define T_INT 271
#define T_FLOAT 272
#define T_CHAR 273
#define T_SWITCH 274
#define T_DOUBLE 275
#define T_ID 276
#define T_NUM 277
#define T_PLUS 278
#define T_MINUS 279
#define T_MULT 280
#define T_DIV 281
#define T_ASSIGN 282
#define T_SPLUS 283
#define T_SMINUS 284
#define T_SMULT 285
#define T_SDIV 286
#define T_INC 287
#define T_DEC 288
#define T_MAIN 289
#define T_RETURN 290
#define T_DEFAULT 291
#define T_CASE 292
#define T_COLON 293

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 43 "parser-af.y" /* yacc.c:1909  */
char* var_type; char* text; struct AST *node;

#line 133 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
