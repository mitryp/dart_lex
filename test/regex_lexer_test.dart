import 'package:lex/base/lexer.dart';
import 'package:test/test.dart';

// Tests adapted from: pygments tests/test_regexlexer.py

class TestTransitionLexer extends RegexLexer {
  final Map<String, List<Parse>> parses = {
    'root': [
      const Parse('a', Token.Comment, ['rag']),
      const Parse('e', Token.Comment),
      const Parse('#', Token.Comment, [POP]),
      const Parse('@', Token.Comment, [POP, POP]),
      const Parse.empty(['beer', 'beer']),
    ],
    'beer': [
      const Parse('d', Token.Escape, [POP, POP]),
    ],
    'rag': [
      const Parse('b', Token.StringEscape, [PUSH]),
      const Parse('c', Token.StringEscape, [POP, 'beer']),
    ],
  };

  @override
  double analyseText(String text) => 0;

  @override
  RegExpFlags get flags => const RegExpFlags();
}

final _lexer = TestTransitionLexer();

void main() {
  group('regex lexer', () {
    test('Transitions including pop', () {
      expect(
        _lexer.getTokensUnprocessed('abcde'),
        equals([
          const UnprocessedToken(0, Token.Comment, 'a'),
          const UnprocessedToken(1, Token.StringEscape, 'b'),
          const UnprocessedToken(2, Token.StringEscape, 'c'),
          const UnprocessedToken(3, Token.Escape, 'd'),
          const UnprocessedToken(4, Token.Comment, 'e'),
        ]),
      );
    });
    test('Multiline', () {
      expect(
        _lexer.getTokensUnprocessed('a\ne'),
        equals([
          const UnprocessedToken(0, Token.Comment, 'a'),
          const UnprocessedToken(1, Token.Text, '\n'),
          const UnprocessedToken(2, Token.Comment, 'e'),
        ]),
      );
    });

    test('Default', () {
      expect(
        _lexer.getTokensUnprocessed('d'),
        equals([
          const UnprocessedToken(0, Token.Escape, 'd'),
        ]),
      );
    });

    test('Regular', () {
      expect(
        _lexer.getTokensUnprocessed('#e'),
        equals([
          const UnprocessedToken(0, Token.Comment, '#'),
          const UnprocessedToken(1, Token.Comment, 'e'),
        ]),
      );
    });

    test('Tuple', () {
      expect(
        _lexer.getTokensUnprocessed('@e'),
        equals([
          const UnprocessedToken(0, Token.Comment, '@'),
          const UnprocessedToken(1, Token.Comment, 'e'),
        ]),
      );
    });
  });
}
