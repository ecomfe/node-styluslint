/* operator associations and precedence */

// %left EOF
// %left NL
// %left SPACE
// %left IDENT

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
    : IDENT COLON IDENT NL  // prop: value \n
        {
            var tmp = {
                name: $1,
                originVal: $3,
                hasColon: true,
                after: $4
            };

            $$ = [].concat(tmp);
        }
    | IDENT COLON IDENT SEMICOLON // prop: value;
        {
            var tmp = {
                name: $1,
                originVal: $3,
                hasSemicolon: true,
                hasColon: true,
                after: $4
            };

            $$ = [].concat(tmp);
        }
    | IDENT COLON IDENT SEMICOLONANDNL // prop: value; \n
        {
            var tmp = {
                name: $1,
                originVal: $3,
                hasSemicolon: true,
                hasColon: true,
                after: $4.slice(1)
            };

            $$ = [].concat(tmp);
        }
    | IDENT IDENT NL // prop value \n
        {
            var tmp = {
                name: $1,
                originVal: $2,
                hasColon: false,
                after: $3
            };

            $$ = [].concat(tmp);
        }
    | IDENT IDENT SEMICOLON // prop value;
        {
            var tmp = {
                name: $1,
                originVal: $2,
                hasSemicolon: true,
                hasColon: false,
                after: $4
            };

            $$ = [].concat(tmp);
        }
    | IDENT IDENT SEMICOLONANDNL // prop value; \n
        {
            var tmp = {
                name: $1,
                originVal: $2,
                hasSemicolon: true,
                hasColon: false,
                after: $4.slice(1)
            };

            $$ = [].concat(tmp);
        }
    | NL
    ;

%%

/* JavaScript util package here */
var variables = [];
var resultAst = {
    variables: [],
    nodes: []
};
