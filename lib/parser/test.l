%{
    yy.a = 'aaa';
%}

// 状态：
// %s 指包容性的状态，%x 指非包容性的状态
// 如果是包容性的状态，那么没有状态的规则也会被激活；如果是非包容的，那么只有声明了相应状态的规则才会被激活。

// semi 结尾是分号的状态
%x semi

// 不需要 \r 了，解析前已经做了替换
nl              \n+
// ident           \-*[_a-zA-Z$][-\w\d$]+
ident           \-*[_a-zA-Z0-9$]+
// indent          [\s\t]+
space           \s+
tab 			\t+
dot             \.+
colon           \:+
semicolon       \;+
semicolonAndNL  \;+\n+
number          ([0-9]+(\.[0-9]+)?)|(\.[0-9]+)
// comment         (\/\*([\s\S]*?)\*\/|([^:]|^)\/\/(.*)$)
comment         (\/\/[\s\S]*)
// nlAndComment    ([\n\s]*\/\/[\s\S]*)
// nlAndComment    ([\n\s]*\/\/[\s\S]*)
// nlAndComment    \/\*[^*]*\*+([^/][^*]*\*+)*\/

// %options flex case-insensitive
%options backtrack_lexer
%%

/* lexical grammar */

{number}                    { return 'NUMBER'; }
{string}                    { return 'STRING'; }
{ident}                     {/*console.warn(lexer.reject(), 1);*/ return 'IDENT'; }
{nl}                        { /*console.log(this, '11');*/ return 'NL'; }
<semi>{nl}                  { return 'NL1'; }
{semicolonAndNL}            { return 'SEMICOLONANDNL'; }
{space}                     {return 'SPACE'; }
{tab}                     { return 'TAB'; }
{dot}                       { return 'DOT'; }
{colon}                     { return 'COLON'; }
{semicolon}                 { return 'SEMICOLON'; }

// // {space}/{comment}           ; // {console.warn(yytext, yytext.length); console.warn(111);}
// // {nl}/{comment}              ; // {console.warn(yytext, yytext.length); console.warn(111);}
// {nlAndComment}                   {console.log(this, 'sdsds');return 'COMMENT'};
{comment}                   ;//{console.log(yy.lexer.next()); console.warn(yy);};

// {indent}                    { return 'INDENT'; }
// .                           { return yytext; }
<INITIAL><<EOF>>            { return 'EOF'; }

%%

