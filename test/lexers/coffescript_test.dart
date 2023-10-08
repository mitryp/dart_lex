import 'package:lex/base/lexer.dart';
import 'package:lex/lexers/coffeescript.dart';
import 'package:test/test.dart';

import 'regex_lexer_runner.dart';

class CoffeeScriptLexerRunner extends RegexLexerRunner {
  final lexer = CoffeeScriptLexer();
  final specs = {
    ''
        'math ='
        '  root:   Math.sqrt'
        '  square: square'
        '  cube:   (x) -> x * square x': [
      const UnprocessedToken(0, Token.NameBuiltin, 'math'),
      const UnprocessedToken(4, Token.Text, ' '),
      const UnprocessedToken(5, Token.Operator, '='),
      const UnprocessedToken(6, Token.Text, '  '),
      const UnprocessedToken(8, Token.NameVariable, 'root: '),
      const UnprocessedToken(14, Token.Text, '  '),
      const UnprocessedToken(16, Token.NameBuiltin, 'Math'),
      const UnprocessedToken(20, Token.Punctuation, '.'),
      const UnprocessedToken(21, Token.NameOther, 'sqrt'),
      const UnprocessedToken(25, Token.Text, '  '),
      const UnprocessedToken(27, Token.NameVariable, 'square: '),
      const UnprocessedToken(35, Token.NameOther, 'square'),
      const UnprocessedToken(41, Token.Text, '  '),
      const UnprocessedToken(43, Token.NameVariable, 'cube: '),
      const UnprocessedToken(49, Token.Text, '  '),
      const UnprocessedToken(51, Token.NameFunction, '(x) ->'),
      const UnprocessedToken(57, Token.Text, ' '),
      const UnprocessedToken(58, Token.NameOther, 'x'),
      const UnprocessedToken(59, Token.Text, ' '),
      const UnprocessedToken(60, Token.Operator, '*'),
      const UnprocessedToken(61, Token.Text, ' '),
      const UnprocessedToken(62, Token.NameOther, 'square'),
      const UnprocessedToken(68, Token.Text, ' '),
      const UnprocessedToken(69, Token.NameOther, 'x'),
    ]
  };
}

void main() {
  group('Lexer: Dart', () {
    CoffeeScriptLexerRunner().run();
  });
}
