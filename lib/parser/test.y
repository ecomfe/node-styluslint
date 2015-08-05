%{
    var util = require('../util');
    var chalk = require('chalk');

    /* JavaScript util package here */
    var variables = [];
    var resultAst = {
        variables: [],
        nodes: [],
        selectors: []
    };

    var indentMark = 0;
    var block = {};

    // 上一行
    var prevLine = {};

    function debugYY(ruleStr, actionStr) {
        console.log(chalk.yellow(ruleStr + ': ') + chalk.cyan(actionStr));
        console.warn();
    }

    var curSelector = null;
    // var curProp = null;

    // 记录 selector 是否 push 到 resultAst.selectors 中
    var selectors = {};

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
    : lines EOF
        {
            return {
                root: resultAst
            };
        }
    | EOF
        {
            return {
                root: resultAst
            };
        }
    ;

lines
    : line NL
        {
            debugYY('lines', 'line NL');
        }
    | lines line NL
        {
            if ($1.type === 'selector' && $2.type === 'selector') {
                return;
            }

            if (!selectors[curSelector.name]) {
                selectors[curSelector.name] = curSelector;
                resultAst.selectors.push(curSelector);
            }


            // 说明 $2 是一个子选择器
            if ($2.values.length === 0) {
                util.removeArrByCondition($1.props, function (item) {
                    return item.name === $2.name;
                });
                $2.parent = null;
                $2.type = 'selector';
                $2.props = [];
                delete $2.values;
                curSelector = JSON.parse(JSON.stringify($2));
                if (!selectors[curSelector.name]) {
                    selectors[curSelector.name] = curSelector;
                }
                $1.children.push(curSelector);
            }

            // console.warn($1);
            // console.warn($2);
            // console.warn(curSelector);
            debugYY('lines', 'lines line NL');
        }
    ;

line
    : IDENT
        {
            curSelector = {
                name: $1,
                indentCount: 0,
                type: 'selector',
                loc: {
                    firstLine: @1.first_line,
                    lastLine: @1.last_line,
                    firstCol: @1.first_column,
                    lastCol: @1.last_column
                },
                props: [],
                children: [],
                parent: null
            };
            $$ = curSelector;
            debugYY('line', 'IDENT');
        }
    | IDENT space
        {
            debugYY('line', 'IDENT space');
        }
    | space IDENT
        {
            // console.warn($2, curSelector);
            if (!curSelector) {
                curSelector = {
                    name: $2,
                    indentCount: 0,
                    type: 'selector',
                    loc: {
                        firstLine: @1.first_line,
                        lastLine: @1.last_line,
                        firstCol: @1.first_column,
                        lastCol: @1.last_column
                    },
                    props: [],
                    children: []
                };
                $$ = curSelector;
            }
            else {
                // console.warn($2, curSelector);
                var re = /^([\t]*)[ \t]*/;
                var captures = re.exec($1);

                // nope, try spaces
                if (captures && !captures[1].length) {
                    re = /^([ \t]*)/;
                    captures = re.exec($1);
                }

                if (captures && captures[1].length) {
                    $$ = {
                        name: $2,
                        indentRe: re,
                        indentCount: captures[1].length,
                        type: 'prop',
                        loc: {
                            firstLine: @2.first_line,
                            lastLine: @2.last_line,
                            firstCol: @2.first_column,
                            lastCol: @2.last_column
                        },
                        parent: curSelector,
                        values: []
                    };
                    // curProp = $$;
                    curSelector.props.push($$);
                }
            }
            debugYY('line', 'space IDENT');
        }
    | space IDENT space
        {
            debugYY('line', 'space IDENT space');
        }
    | line IDENT
        {
            debugYY('line', 'line IDENT');
        }
    | line IDENT space
        {
            debugYY('line', 'line IDENT space');
        }
    | line space IDENT
        {
            if ($1.type === 'prop') {
                $1.values.push($2 + $3);
                // $$ = {
                //     name: $1.name,
                //     indentCount: $1.indentCount,
                //     indentRe: $1.indentRe,
                //     type: $1.type,
                //     parent: $1.parent,
                //     value: $3
                // };
                // curSelector.props.push($$);
            }
            else {
                var loc = $1.loc;
                loc.lastCol = @3.last_column;
                curSelector = {
                    name: $1.name + $2 + $3,
                    indentCount: 0,
                    type: $1.type,
                    loc: loc,
                    props: [],
                    children: []
                };
                $$ = curSelector;
            }
            debugYY('line', 'line space IDENT');
        }
    | line space IDENT space
        {
            debugYY('line', 'line space IDENT space');
        }
    ;




/*line
    : IDENT NL
        {
            block = {
                selector: $1,
                children: [],
                props: [],
                indentCount: 0
            };
            resultAst.nodes.push(block);
            $$ = resultAst;
            console.warn(chalk.cyan('line -> IDENT NL'));
        }
    | IDENT space
        {
            block = {
                selector: $1,
                children: [],
                props: [],
                indentCount: 0
            };
            resultAst.nodes.push(block);
            $$ = resultAst;
            console.warn(chalk.cyan('line -> IDENT sapce'));
        }
    | IDENT space NL
        {
            $$ = $1;
            console.warn(chalk.cyan('line -> IDENT space NL'));
        }
    | space IDENT NL
        {
            $$ = $2;
            console.warn(chalk.cyan('line -> space IDENT NL'));
        }
    | space IDENT space
        {
            $$ = $2;
            console.warn(chalk.cyan('line -> space IDENT space'));
        }
    | space IDENT space NL
        {
            $$ = $2;
            console.warn(chalk.cyan('line -> space IDENT space NL'));
        }
    | line IDENT NL
        {
            var firstLine1 = @1.first_line;
            var lastLine1 = @1.last_line;
            var firstLine2 = @2.first_line;
            var lastLine2 = @2.last_line;
            console.warn($1, $2);
            // 同一行的选择器
            if (firstLine1 === firstLine2
                && lastLine1 === lastLine2
            ) {
                block.selector += (' ' + ((typeof $1 === 'string') ? $1 + ' ' : '') + $2);
            }
            else {
                // 另一个顶级 block 了
                if ($1.selector) {
                    // console.warn($1, $2);
                    // console.warn();
                    block = {
                        selector: $2,
                        children: [],
                        props: []
                    };
                    resultAst.nodes.push(block);
                }
                else {
                    // console.warn($1, block, prevLine);
                    if ($1.before > prevLine.before) {
                        var props = block.props;
                        for (var i = 0, len = props.length; i < len; i++) {
                            if (props[i].prop === prevLine.prop) {
                                props.splice(i, 1);
                                break;
                            }
                        }
                        block.selector += (' ' + prevLine.prop + ' ' + prevLine.value);
                    }

                    prevLine = {
                        before: $1.before,
                        prop: $1.name,
                        value: $2
                    };
                    block.props.push(prevLine);
                }
            }

            $$ = block;
            console.warn(chalk.cyan('line -> line IDENT NL'));
        }
    | line IDENT space
        {
            $$ = $2;
            console.warn(chalk.cyan('line -> line IDENT sapce'));
        }
    | line IDENT space NL
        {
            $$ = $2;
            console.warn(chalk.cyan('line -> line IDENT space NL'));
        }
    | line space IDENT NL
        {
            // 同一层级
            if ($1.indentCount === $2.length) {
                block = {
                    selector: $3,
                    children: [],
                    props: [],
                    indentCount: $2.length,
                    parent: $1
                };
                $1.parent.children.push(block);
            }
            else {
                block = {
                    selector: $3,
                    children: [],
                    props: [],
                    indentCount: $2.length,
                    parent: $1
                };
                $1.children.push(block);
            }

            console.warn(chalk.cyan('line -> line space IDENT NL'));
        }
    | line space IDENT space
        {
            // console.warn($1);
            // $$ = $3;
            $$ = {
                before: $2.length,
                name: $3
            };
            console.warn(chalk.cyan('line -> line space IDENT space'));
        }
    | line space IDENT space NL
        {
            $$ = $3;
            console.warn(chalk.cyan('line -> line space IDENT space NL'));
        }
    ;*/

space
    : SPACE
    | TAB
    ;

// root
//     : nodes EOF
//         {
//             return $1;
//         }
//     | EOF
//         {
//             return {
//                 root: resultAst
//             };
//         }
//     ;

// nodes
//     : node
//         {
//             resultAst = {
//                 variables: variables,
//                 nodes: [$1]
//             };
//             $$ = {
//                 root: resultAst
//             };
//         }
//     ;

// node
//     : selector block
//         {
//             $$ = {
//                 nodes: [
//                     {
//                         segments: [
//                             {
//                                 name: $1,
//                                 originVal: $1
//                             }
//                         ],
//                         // block: $3
//                     }
//                 ]
//             }
//             console.warn($1,'block');
//         }
//     | node selector
//     ;

// selector
//     : space IDENT space
//         {
//             indentMark = $1.length;
//             console.warn(chalk.cyan('selector -> space IDENT space'));
//         }
//     | space IDENT NL
//         {
//             indentMark = $1.length;
//             console.warn(chalk.cyan('selector -> space IDENT NL'));
//         }
//     | IDENT space
//         {
//             console.warn(chalk.cyan('selector -> IDENT space'));
//         }
//     | IDENT NL
//         {
//             console.warn(chalk.cyan('selector -> IDENT NL'));
//         }
//     ;

// block
//     : kvs
//         {
//             console.warn($1, 'kvs');
//             console.warn(chalk.cyan('block -> kvs'));
//         }
//     ;

// kvs
//     : kv
//         {
//             $$ = $1;
//             console.warn($1, 'kkk');
//             console.warn(chalk.cyan('kvs -> kv'));
//         }
//     | kvs kv
//         {
//             console.warn(yytext.length, 'yytext');
//             $$ = [].concat($1, $2);
//             console.warn($1, $2, 'sss');
//             // console.warn(yy);
//             console.warn(chalk.cyan('kvs -> kvs kv'));
//         }
//     ;

// kv
//     : space IDENT IDENT
//         {
//             console.warn(chalk.cyan('kv -> space IDENT IDENT'));
//         }
//     | space IDENT space IDENT
//         {
//             console.warn(chalk.cyan('kv -> space IDENT space IDENT'));
//         }
//     | space IDENT IDENT NL
//         {
//             console.warn(chalk.cyan('kv -> space IDENT IDENT NL'));
//         }
//     | space IDENT space IDENT NL
//         {
//             $$ = [].concat($2, $4)
//             console.warn(chalk.cyan('kv -> space IDENT space IDENT NL'));
//         }
//     | IDENT IDENT
//         {
//             console.warn(chalk.cyan('kv -> IDENT IDENT'));
//         }
//     | IDENT space IDENT
//         {
//             console.warn(chalk.cyan('kv -> IDENT space IDENT'));
//         }
//     | IDENT IDENT NL
//         {
//             console.warn(chalk.cyan('kv -> IDENT IDENT NL'));
//         }
//     | IDENT space IDENT NL
//         {
//             console.warn(chalk.cyan('kv -> IDENT space IDENT NL'));
//         }
//     ;

// // kv
// //     : k v
// //         {
// //             // console.warn($1, $2, 'sdsd');
// //             console.warn(chalk.cyan('kv -> k v'));
// //         }
// //     ;

// // k
// //     : space IDENT
// //         {
// //             console.warn(chalk.cyan('k -> space IDENT'));
// //             $$ = $2;
// //         }
// //     | IDENT
// //         {
// //             console.warn(chalk.cyan('k -> IDENT'));
// //         }
// //     ;

// // v
// //     : space IDENT
// //         {
// //             console.warn(chalk.cyan('v -> space IDENT'));
// //         }
// //     | IDENT
// //         {
// //             console.warn(chalk.cyan('v -> IDENT'));
// //         }
// //     | IDENT NL
// //         {
// //             console.warn(chalk.cyan('v -> IDENT NL'));
// //             console.warn();
// //         }
// //     | space IDENT NL
// //         {
// //             $$ = $2;
// //             console.warn(chalk.cyan('v -> space IDENT NL'));
// //             console.warn($2, 'sss');
// //             // console.warn(yystate);
// //             console.warn();
// //         }
// //     ;

// space
//     : SPACE
//     | TAB
//     ;

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
