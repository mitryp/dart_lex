import 'package:lex/base/lexer.dart';
import 'package:lex/lexers/javascript.dart';
import 'package:test/test.dart';

void main() {
  final lexer = JavaScriptLexer();
  group('Lexer: JavaScript', () {
    test('const s = 1', () {
      expect(
        lexer.getTokensUnprocessed('const s = 1'),
        equals([
          const UnprocessedToken(0, Token.KeywordReserved, 'const'),
          const UnprocessedToken(5, Token.Text, ' '),
          const UnprocessedToken(6, Token.NameOther, 's'),
          const UnprocessedToken(7, Token.Text, ' '),
          const UnprocessedToken(8, Token.Operator, '='),
          const UnprocessedToken(9, Token.Text, ' '),
          const UnprocessedToken(10, Token.NumberInteger, '1'),
        ]),
      );
    });

    test('var name = \'hello\'', () {
      expect(
        lexer.getTokensUnprocessed('var name = \'hello\''),
        equals([
          const UnprocessedToken(0, Token.KeywordDeclaration, 'var'),
          const UnprocessedToken(3, Token.Text, ' '),
          const UnprocessedToken(4, Token.NameOther, 'name'),
          const UnprocessedToken(8, Token.Text, ' '),
          const UnprocessedToken(9, Token.Operator, '='),
          const UnprocessedToken(10, Token.Text, ' '),
          const UnprocessedToken(11, Token.StringSingle, '\'hello\''),
        ]),
      );
    });
  });
}
