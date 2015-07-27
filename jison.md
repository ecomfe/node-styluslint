http://mockbrian.com/talk/peg-jison/#/

bison 语法结构

... 定义部分 ...
%%
... 规则部分 ...
%%
... 用户子例程

由词法分析器产生的符号称为终结符 (terminal symbol) 或记号 (token)。在规则左部定义的符号称为非终结符 (nonterminal symbol)。
记号可以是用引号引起来的文本字符。惯例是记号名字都为大写字母而非终结符则是小写。

定义部分可以包含文本块，这些文本块是原样拷贝到生成的 js 文件开始部分的 js 代码。文本块存在于 {% 和 %} 或者 %code 中。
定义部分通常包括声明。声明包含 %union, %start, %token, %type, %left, %right, %nonassoc。

规则部分包含语法规则和语义动作的 js 代码。

用户子例程的内容将被 jison 原样拷贝到 js 文件，这个部分通常包括语义动作中需要调用的例程。

动作 (action) 是 jison 匹配语法中一条规则时所执行的 js 代码。动作必须是 js 的复合语句。例如：
    date: month '/' day '/' year {console.log('date found');}

动作可以通过一个美元符加上一个数字来使用规则中语法符号所关联的值，冒号后第一个语法符号的数字是 1，如上例 $1 为 month
    date: month '/' day '/' year {console.log('date %s %s %s', $1, $3, $5);}
        ;
