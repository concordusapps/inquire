# Inquire grammar.
module.exports =
  lex:
    rules: [
      ['\\(',                 'return "(";']
      ['\\)',                 'return ")";']
      ['[A-Za-z]+',           'return "ALPHA";']
      ['[0-9]+',              'return "DIGIT";']
      ['[\\$\\-_@\\.\\+]+',  'return "SAFE";']
      ['[\\*"\\\',]+',        'return "EXTRA";']
      ['%[A-Fa-f0-9]{2}',     'return "ESCAPE";']
      ['=',                   'return "EQ";']
      ['!=',                  'return "NEQ";']
      ['>',                   'return "GT";']
      ['>=',                  'return "GTE";']
      ['<',                   'return "LT";']
      ['<=',                  'return "LTE";']
      ['&',                   'return "AND";']
      [';',                   'return "OR";']
      ['!',                   'return "NOT";']
      ['&!',                  'return "ANDNOT";']
    ]
  operators: [
    <[ left AND OR NOT ]>
    <[ left EQ GT LT ]>
    <[ left NEQ GTE LTE ]>
    <[ left ( ) ]>
  ]
  bnf:
    expressions: [
      [ 'q',  'return { "_parsedQueryString": $1 };']
    ]
    q: [
      ['group',                   '$$ = $1;']
      ['predicate',               '$$ = $1;']
      ['group binaryBool q',      '$$ = { arity: "2", bool: $2, left: $1, right: $3 };']
      ['predicate binaryBool q',  '$$ = { arity: "2", bool: $2, left: $1, right: $3 };']
      ['unaryBool q',             '$$ = { arity: "1", bool: $1, value: $2 };']
    ]
    group: [
      ['( q )', '$$ = { arity: "1", bool: "", value: $2 };']
      ['( )',   '$$ = { arity: "1", bool: "", value: ""};']
    ]
    predicate: [
      ['variable rel variable', '$$ = { arity: "2", rel: $2, left: $1, right: $3 };']
      ['variable rel rel variable', '$$ = { arity: "2", rel: $2 + $3, left: $1, right: $4 };']
    ]
    variable: [
      ['( variable )', '$$ = { arity: "1", bool: "", value: $2 };']
      ['_var', '$$ = $1;']
      ['_var variable', '$$ = $1 + $2;']
    ]
    _var: [
      ['ALPHA', '$$ = yytext;']
      ['DIGIT', '$$ = yytext;']
      ['SAFE', '$$ = yytext;']
      ['EXTRA', '$$ = yytext;']
      ['ESCAPE', '$$ = yytext;']
    ]
    rel: [
      ['NEQ', '$$ = yytext;']
      ['GTE', '$$ = yytext;']
      ['LTE', '$$ = yytext;']
      ['EQ',  '$$ = yytext;']
      ['GT',  '$$ = yytext;']
      ['LT',  '$$ = yytext;']
    ]
    binaryBool: [
      ['AND', '$$ = yytext;']
      ['OR',  '$$ = yytext;']
    ]
    unaryBool: [
      ['NOT',     '$$ = yytext;']
      ['ANDNOT',  '$$ = yytext;']
    ]
