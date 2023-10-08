import 'package:lex/base/lexer.dart';
import 'package:lex/lexers/typescript.dart';
import 'package:test/test.dart';

import 'regex_lexer_runner.dart';

class TypeScriptLexerRunner extends RegexLexerRunner {
  final lexer = TypeScriptLexer();

  final specs = {
    // isolated byGroups case
    'canRead(p: string)': [
      const UnprocessedToken(0, Token.NameOther, 'canRead'),
      const UnprocessedToken(7, Token.Punctuation, '('),
      const UnprocessedToken(8, Token.NameOther, 'p'),
      const UnprocessedToken(9, Token.Text, ': '),
      const UnprocessedToken(11, Token.KeywordType, 'string'),
      const UnprocessedToken(17, Token.Punctuation, ')'),
    ],
    // longer example including byGroups
    'export async function canRead(p: string): Promise<boolean> {'
        '  try {'
        '    await access(p, fs.constants.R_OK)'
        '    return true'
        '  } catch (err) {'
        '    return false'
        '  }'
        '}': [
      const UnprocessedToken(0, Token.KeywordReserved, 'export'),
      const UnprocessedToken(6, Token.Text, ' '),
      const UnprocessedToken(7, Token.KeywordReserved, 'async'),
      const UnprocessedToken(12, Token.Text, ' '),
      const UnprocessedToken(13, Token.KeywordDeclaration, 'function'),
      const UnprocessedToken(21, Token.Text, ' '),
      const UnprocessedToken(22, Token.NameOther, 'canRead'),
      const UnprocessedToken(29, Token.Punctuation, '('),
      const UnprocessedToken(30, Token.NameOther, 'p'),
      const UnprocessedToken(31, Token.Text, ': '),
      const UnprocessedToken(33, Token.KeywordType, 'string'),
      const UnprocessedToken(39, Token.Punctuation, ')'),
      const UnprocessedToken(40, Token.Operator, ':'),
      const UnprocessedToken(41, Token.Text, ' '),
      const UnprocessedToken(42, Token.NameOther, 'Promise'),
      const UnprocessedToken(49, Token.Operator, '<'),
      const UnprocessedToken(50, Token.KeywordReserved, 'boolean'),
      const UnprocessedToken(57, Token.Operator, '>'),
      const UnprocessedToken(58, Token.Text, ' '),
      const UnprocessedToken(59, Token.Punctuation, '{'),
      const UnprocessedToken(60, Token.Text, '  '),
      const UnprocessedToken(62, Token.Keyword, 'try'),
      const UnprocessedToken(65, Token.Text, ' '),
      const UnprocessedToken(66, Token.Punctuation, '{'),
      const UnprocessedToken(67, Token.Text, '    '),
      const UnprocessedToken(71, Token.KeywordReserved, 'await'),
      const UnprocessedToken(76, Token.Text, ' '),
      const UnprocessedToken(77, Token.NameOther, 'access'),
      const UnprocessedToken(83, Token.Punctuation, '('),
      const UnprocessedToken(84, Token.NameOther, 'p'),
      const UnprocessedToken(85, Token.Punctuation, ','),
      const UnprocessedToken(86, Token.Text, ' '),
      const UnprocessedToken(87, Token.NameOther, 'fs'),
      const UnprocessedToken(89, Token.Punctuation, '.'),
      const UnprocessedToken(90, Token.NameOther, 'constants'),
      const UnprocessedToken(99, Token.Punctuation, '.'),
      const UnprocessedToken(100, Token.NameOther, 'R_OK'),
      const UnprocessedToken(104, Token.Punctuation, ')'),
      const UnprocessedToken(105, Token.Text, '    '),
      const UnprocessedToken(109, Token.Keyword, 'return'),
      const UnprocessedToken(115, Token.Text, ' '),
      const UnprocessedToken(116, Token.KeywordConstant, 'true'),
      const UnprocessedToken(120, Token.Text, '  '),
      const UnprocessedToken(122, Token.Punctuation, '}'),
      const UnprocessedToken(123, Token.Text, ' '),
      const UnprocessedToken(124, Token.Keyword, 'catch'),
      const UnprocessedToken(129, Token.Text, ' '),
      const UnprocessedToken(130, Token.Punctuation, '('),
      const UnprocessedToken(131, Token.NameOther, 'err'),
      const UnprocessedToken(134, Token.Punctuation, ')'),
      const UnprocessedToken(135, Token.Text, ' '),
      const UnprocessedToken(136, Token.Punctuation, '{'),
      const UnprocessedToken(137, Token.Text, '    '),
      const UnprocessedToken(141, Token.Keyword, 'return'),
      const UnprocessedToken(147, Token.Text, ' '),
      const UnprocessedToken(148, Token.KeywordConstant, 'false'),
      const UnprocessedToken(153, Token.Text, '  '),
      const UnprocessedToken(155, Token.Punctuation, '}'),
      const UnprocessedToken(156, Token.Punctuation, '}'),
    ],
  };
}

void main() {
  group('Lexer: TypeScript', () {
    TypeScriptLexerRunner().run();
  });
}
