import 'package:lex/lexers/javascript.dart';

void main() {
  final lexer = JavaScriptLexer();
  final tokens = lexer.getTokensUnprocessed('''
  const str = 'I love Kate \'<3';
  function foo() {
    for (let i = 0; i < str.length; i++) {
      console.log(str.charAt(i));
    }
  }
  
  foo();
  ''');
  for (final token in tokens) {
    print('${token.pos}:"${token.match.replaceAll('\n', '\\n')}" (${token.token})');
  }
}
