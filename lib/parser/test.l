
// semi 结尾是分号的状态
%x semi

// 不需要 \r 了，解析前已经做了替换
nl              \n+
ident           \-*[_a-zA-Z$][-\w\d$]+
space           \s+
dot             \.+
colon           \:+
semicolon       \;+
semicolonAndNL  \;+\n+
number          ([0-9]+(\.[0-9]+)?)|(\.[0-9]+)

// %options flex case-insensitive
%%

/* lexical grammar */

{number}                    { return 'NUMBER'; }
{string}                    { return 'STRING'; }
{ident}                     { return 'IDENT'; }
{nl}                        { /*console.log(this, '11');*/ return 'NL'; }
<semi>{nl}                  { return 'NL1'; }
{semicolonAndNL}                  { return 'SEMICOLONANDNL'; }
{space}                     ;//{ return 'SPACE'; }
{dot}                       { return 'DOT'; }
{colon}                     { return 'COLON'; }
{semicolon}                 { return 'SEMICOLON'; }
// .                           { return yytext; }
<INITIAL><<EOF>>            { return 'EOF'; }

%%

