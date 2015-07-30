var path = require('path');
var fs = require('fs');
var chalk = require('chalk');
var stylus = require('stylus');

var content = fs.readFileSync(
    __dirname + path.sep + 'test.styl',
    'utf8'
);

content = content.replace(/\r\n?/g, '\n');

stylus.render(content, function (err, css) {
    if (err) {
        console.warn(chalk.red('stylus err: '));
        console.warn(err);
        console.warn();
    }
    else {
        console.warn(css);
        console.warn(chalk.green('stylus compile success'));
    }
    console.warn('-----------------------------------');
    // console.log(css);
});

// var stylusParser = new stylus.Parser(content, {});
// var stylusAst = stylusParser.parse();
// console.warn(stylusAst);
// console.warn();
// console.log(require('util').inspect(stylusAst, { showHidden: true, depth: null }));

var parser = require('./parser/test');
// // console.warn(parser.parse(content));
// console.warn(parser.generate);
console.warn();
console.log(require('util').inspect(parser.parse(content), { showHidden: true, depth: null }), '---result');
