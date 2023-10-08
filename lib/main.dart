import 'lexers/javascript.dart';

void main() {
  final lexer = JavaScriptLexer();
  final tokens = lexer.getTokensUnprocessed('''
  const а = 1.a;
  ''');
  for (final token in tokens) {
    print('${token.pos}:"${token.match.replaceAll('\n', '\\n')}" (${token.token})');
  }
}
