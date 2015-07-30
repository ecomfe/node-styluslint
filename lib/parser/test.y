%{
    /* JavaScript util package here */
    var variables = [];
    var resultAst = {
        variables: [],
        nodes: []
    };

    var chalk = require('chalk');
%}

/* operator associations and precedence */

// %nonassoc block
%nonassoc kvs
// %nonassoc kv
// %nonassoc k v
%nonassoc SPACE TAB
%nonassoc IDENT
// %nonassoc NL


%start root
%%

root
    : nodes EOF
        {
            return $1;
        }
    | EOF
        {
            return {
                root: resultAst
            };
        }
    ;

nodes
    : node
        {
            resultAst = {
                variables: variables,
                nodes: [$1]
            };
            $$ = {
                root: resultAst
            };
        }
    ;

node
    : selector block
        {
            $$ = {
                nodes: [
                    {
                        segments: [
                            {
                                name: $1,
                                originVal: $1
                            }
                        ],
                        // block: $3
                    }
                ]
            }
            // console.warn($1,'block');
        }
    | node selector
    ;

selector
    : space IDENT space
        {
            console.warn(chalk.cyan('selector -> space IDENT space'));
        }
    | space IDENT NL
        {
            console.warn(chalk.cyan('selector -> space IDENT NL'));
        }
    | IDENT space
        {
            console.warn(chalk.cyan('selector -> IDENT space'));
        }
    | IDENT NL
        {
            console.warn(chalk.cyan('selector -> IDENT NL'));
        }
    ;

block
    : kvs
        {
            console.warn(chalk.cyan('block -> kvs'));
        }
    ;

kvs
    : kv
        {
            console.warn(chalk.cyan('kvs -> kv'));
        }
    | kvs kv
        {
            console.warn(chalk.cyan('kvs -> kvs kv'));
        }
    ;

kv
    : k v
        {
            console.warn(chalk.cyan('kv -> k v'));
        }
    ;

k
    : space IDENT
        {
            console.warn(chalk.cyan('k -> space IDENT'));
        }
    | IDENT
        {
            console.warn(chalk.cyan('k -> IDENT'));
        }
    ;

v
    : space IDENT
        {
            console.warn(chalk.cyan('v -> space IDENT'));
        }
    | IDENT
        {
            console.warn(chalk.cyan('v -> IDENT'));
        }
    | IDENT NL
        {
            console.warn(chalk.cyan('v -> IDENT NL'));
            console.warn();
        }
    | space IDENT NL
        {
            console.warn(chalk.cyan('v -> space IDENT NL'));
            console.warn();
        }
    ;


// kv
//     : space IDENT
//         {
//             console.warn(1, 'kv -> space IDENT');
//         }
//     | space IDENT NL
//         {
//             console.warn(2, 'kv -> space IDENT NL');
//         }
//     | IDENT
//         {
//             console.warn(3, 'kv -> IDENT space');
//         }
//     | IDENT NL
//         {
//             console.warn(4, 'kv -> IDENT NL');
//         }
//     ;

space
    : SPACE
    | TAB
    ;

// block
//     : kvs
//         {
//             // console.warn($$, 'kvs');
//         }
//     | node
//         {
//             // console.warn('node');
//         }
//     ;

// kvs
//     : kv
//         {
//             $$ = [].concat($1);
//         }
//     | kvs kv
//         {
//             $$ = [].concat($1, $2);
//         }
//     ;

// kv
//     : IDENT COLON IDENT NL  // prop: value \n
//         {
//             var tmp = {
//                 name: $1,
//                 originVal: $3,
//                 hasColon: true,
//                 after: $4
//             };

//             $$ = [].concat(tmp);
//         }
//     | IDENT COLON IDENT SEMICOLON // prop: value;
//         {
//             var tmp = {
//                 name: $1,
//                 originVal: $3,
//                 hasSemicolon: true,
//                 hasColon: true,
//                 after: $4
//             };

//             $$ = [].concat(tmp);
//         }
//     | IDENT COLON IDENT SEMICOLONANDNL // prop: value; \n
//         {
//             var tmp = {
//                 name: $1,
//                 originVal: $3,
//                 hasSemicolon: true,
//                 hasColon: true,
//                 after: $4.slice(1)
//             };

//             $$ = [].concat(tmp);
//         }
//     | IDENT IDENT NL // prop value \n
//         {
//             var tmp = {
//                 name: $1,
//                 originVal: $2,
//                 hasColon: false,
//                 after: $3
//             };

//             $$ = [].concat(tmp);
//         }
//     | IDENT IDENT SEMICOLON // prop value;
//         {
//             var tmp = {
//                 name: $1,
//                 originVal: $2,
//                 hasSemicolon: true,
//                 hasColon: false,
//                 after: $4
//             };

//             $$ = [].concat(tmp);
//         }
//     | IDENT IDENT SEMICOLONANDNL // prop value; \n
//         {
//             var tmp = {
//                 name: $1,
//                 originVal: $2,
//                 hasSemicolon: true,
//                 hasColon: false,
//                 after: $4.slice(1)
//             };

//             $$ = [].concat(tmp);
//         }
//     | NL
//     ;
