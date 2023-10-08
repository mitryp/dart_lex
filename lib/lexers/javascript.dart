import '../base/lexer.dart';
import '../unistring.dart';

final JS_IDENT_START =
    (r'(?:[$_' + uni.combine(['Lu', 'Ll', 'Lt', 'Lm', 'Lo', 'Nl']) + ']|\\\\u[a-fA-F0-9]{4})');
final JS_IDENT_PART = (r'(?:[$' +
    uni.combine(['Lu', 'Ll', 'Lt', 'Lm', 'Lo', 'Nl', 'Mn', 'Mc', 'Nd', 'Pc']) + /*u*/
    '\u200c\u200d]|\\\\u[a-fA-F0-9]{4})');
final JS_IDENT = JS_IDENT_START + '(?:' + JS_IDENT_PART + ')*';

class JavaScriptLexer extends RegexLexer {
  final name = 'JavaScript';
  final aliases = ['js', 'javascript'];
  final filenames = ['*.js', '*.jsm'];
  final mimetypes = [
    'application/javascript',
    'application/x-javascript',
    'text/x-javascript',
    'text/javascript'
  ];

  final RegExpFlags flags = const RegExpFlags(
    dotAll: true,
    unicode: true,
    multiline: true,
  );

  final Map<String, List<Parse>> parses = {
    'commentsandwhitespace': [
      const Parse(r'\s+', Token.Text),
      const Parse(r'<!--', Token.Comment),
      const Parse(r'//.*?\n', Token.CommentSingle),
      const Parse(r'/\*.*?\*/', Token.CommentMultiline),
    ],
    'slashstartsregex': [
      const Parse.include('commentsandwhitespace'),
      /* TODO: disabled Lone quantifier brackets
      https://stackoverflow.com/questions/40939209/invalid-regular-expressionlone-quantifier-brackets
      Parse(
          r'/(\\.|[^[/\\\n]|\[(\\.|[^\]\\\n])*])+/'
          r'([gimuy]+\b|\B)',
          Token.StringRegex,
          [POP]),
       */
      const Parse(r'(?=/)', Token.Text, [POP, 'badregex']),
      const Parse.empty([POP])
    ],
    'badregex': [
      const Parse(r'\n', Token.Text, [POP]),
    ],
    'root': [
      const Parse(r'^#! ?/.*?\n', Token.CommentHashbang), // recognized by node.js
      const Parse(r'^(?=\s|/|<!--)', Token.Text, ['slashstartsregex']),
      const Parse.include('commentsandwhitespace'),
      const Parse(r'(\.\d+|[0-9]+\.[0-9]*)([eE][-+]?[0-9]+)?', Token.NumberFloat),
      const Parse(r'0[bB][01]+', Token.NumberBin),
      const Parse(r'0[oO][0-7]+', Token.NumberOct),
      const Parse(r'0[xX][0-9a-fA-F]+', Token.NumberHex),
      const Parse(r'[0-9]+', Token.NumberInteger),
      const Parse(r'\.\.\.|=>', Token.Punctuation),
      const Parse(
          r'\+\+|--|~|&&|\?|:|\|\||\\(?=\n)|'
          r'(<<|>>>?|==?|!=?|[-<>+*%&|^/])=?',
          Token.Operator,
          ['slashstartsregex']),
      const Parse(r'[{(\[;,]', Token.Punctuation, ['slashstartsregex']),
      const Parse(r'[})\].]', Token.Punctuation),
      const Parse(
          r'(for|in|while|do|break|return|continue|switch|case|default|if|else|'
          r'throw|try|catch|finally|new|delete|typeof|instanceof|void|yield|'
          r'this|of)\b',
          Token.Keyword,
          ['slashstartsregex']),
      const Parse(r'(var|let|with|function)\b', Token.KeywordDeclaration, ['slashstartsregex']),
      const Parse(
          r'(abstract|boolean|byte|char|class|const|debugger|double|enum|export|'
          r'extends|final|float|goto|implements|import|int|interface|long|native|'
          r'package|private|protected|public|short|static|super|synchronized|throws|'
          r'transient|volatile)\b',
          Token.KeywordReserved),
      const Parse(r'(true|false|null|NaN|Infinity|undefined)\b', Token.KeywordConstant),
      const Parse(
          r'(Array|Boolean|Date|Error|Function|Math|netscape|'
          r'Number|Object|Packages|RegExp|String|Promise|Proxy|sun|decodeURI|'
          r'decodeURIComponent|encodeURI|encodeURIComponent|'
          r'Error|eval|isFinite|isNaN|isSafeInteger|parseFloat|parseInt|'
          r'document|this|window)\b',
          Token.NameBuiltin),
      // TODO: should be the below if we want to support unicode
      // Parse(JS_IDENT, Token.NameOther),
      const Parse(r'[a-zA-Z\d_$]+', Token.NameOther),
      const Parse(r'"(\\\\|\\"|[^"])*"', Token.StringDouble),
      const Parse(r"'(\\\\|\\'|[^'])*'", Token.StringSingle),
      const Parse(r'`', Token.StringBacktick, ['interp']),
    ],
    'interp': [
      const Parse(r'`', Token.StringBacktick, [POP]),
      const Parse(r'\\\\', Token.StringBacktick),
      const Parse(r'\\`', Token.StringBacktick),
      const Parse(r'\$\{', Token.StringInterpol, ['interp-inside']),
      const Parse(r'\$', Token.StringBacktick),
      const Parse(r'[^`\\$]+', Token.StringBacktick),
    ],
    'interp-inside': const [
      Parse(r'\}', Token.StringInterpol, [POP]),
      Parse.include('root'),
    ],
    // # (\\\\|\\`|[^`])*`', String.Backtick),
  };
}
