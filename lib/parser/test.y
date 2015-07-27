/* operator associations and precedence */

%{
    /* JavaScript util package here */
    var variables = [];
    var resultAst = {
        variables: [],
        nodes: []
    };
%}


%left EOF
%left NL
%left SPACE
%left IDENT

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
    : selector NL block
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
                        block: $3
                    }
                ]
            }
            // console.warn($1,'block');
        }
    ;

selector
    : IDENT
        {
            // console.log($1);
        }
    ;

block
    : kvs
        {
            // console.warn($$, 'kvs');
        }
    | node
        {
            // console.warn('node');
        }
    ;

kvs
    : kv
        {
            $$ = [].concat($1);
        }
    | kvs kv
        {
            $$ = [].concat($1, $2);
        }
    ;

kv
    : IDENT COLON IDENT
        {
            var tmp = {
                name: $1,
                originVal: $3
            };

            $$ = [].concat(tmp);
        }
    | IDENT COLON IDENT SEMICOLON
        {
            var tmp = {
                name: $1,
                originVal: $3,
                hasSemicolon: true
            };

            $$ = [].concat(tmp);
        }
    | NL
    ;

// node
//     : IDENT
//         {
//             $$ = {
//                 type: 'IDENT'
//             }
//         }
//     | SPACE
//         {
//             $$ = {
//                 type: 'SPACE'
//             }
//         }
//     | NL
//         {
//             $$ = {
//                 type: 'NL'
//             }
//         }
//     | node IDENT
//         {
//             if (!$$.nodes) {
//                 $$.nodes = [];
//             }
//             $2 = {
//                 type: 'IDENT1'
//             }
//             $$.nodes.push($2);
//         }
//     | node SPACE
//         {
//             if (!$$.nodes) {
//                 $$.nodes = [];
//             }
//             $2 = {
//                 type: 'SPACE1'
//             }
//             $$.nodes.push($2);
//         }
//     | node NL
//         {
//             if (!$$.nodes) {
//                 $$.nodes = [];
//             }
//             $2 = {
//                 type: 'NL1'
//             }
//             $$.nodes.push($2);
//         }
//     ;
