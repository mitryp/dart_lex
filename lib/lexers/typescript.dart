// For `TypeScript http://typescriptlang.org/` source code.
import '../base/lexer.dart';
import 'javascript.dart';

final _jsLexer = JavaScriptLexer();

class TypeScriptLexer extends RegexLexer {
  final name = 'TypeScript';
  final aliases = ['ts', 'typescript'];
  final filenames = ['*.ts', '*.tsx'];
  final mimetypes = ['text/x-typescript'];

  final RegExpFlags flags = const RegExpFlags(
    dotAll: true,
    multiline: true,
  );

  Map<String, List<Parse>> get parses => {
        'commentsandwhitespace': [
          const Parse(r'\s+', Token.Text),
          const Parse(r'<!--', Token.Comment),
          const Parse(r'//.*?\n', Token.CommentSingle),
          const Parse(r'/\*.*?\*/', Token.CommentMultiline)
        ],
        'slashstartsregex': [
          const Parse.include('commentsandwhitespace'),
          const Parse(
              r'/(\\.|[^[/\\\n]|\[(\\.|[^\]\\\n])*])+/'
              r'([gim]+\b|\B)',
              Token.StringRegex,
              [POP]),
          const Parse(r'(?=/)', Token.Text, [POP, 'badregex']),
          const Parse.empty([POP])
        ],
        'badregex': [
          const Parse(r'\n', Token.Text, [POP])
        ],
        'root': [
          const Parse(r'^(?=\s|/|<!--)', Token.Text, ['slashstartsregex']),
          const Parse.include('commentsandwhitespace'),
          const Parse(
              r'\+\+|--|~|&&|\?|:|\|\||\\(?=\n)|'
              r'(<<|>>>?|==?|!=?|[-<>+*%&|^/])=?',
              Token.Operator,
              ['slashstartsregex']),
          const Parse(r'[{(\[;,]', Token.Punctuation, ['slashstartsregex']),
          const Parse(r'[})\].]', Token.Punctuation),
          const Parse(
              r'(for|in|while|do|break|return|continue|switch|case|default|if|else|'
              r'throw|try|catch|finally|new|delete|typeof|instanceof|void|of|'
              r'this)\b',
              Token.Keyword,
              ['slashstartsregex']),
          const Parse(
              r'(var|let|with|const|function)\b', Token.KeywordDeclaration, ['slashstartsregex']),
          const Parse(
              r'(abstract|async|await|boolean|byte|char|class|debugger|double|enum|export|'
              r'extends|final|float|goto|implements|import|int|interface|long|native|'
              r'package|private|protected|public|short|static|super|synchronized|throws|'
              r'transient|volatile)\b',
              Token.KeywordReserved),
          const Parse(r'(true|false|null|NaN|Infinity|undefined)\b', Token.KeywordConstant),
          const Parse(
              r'(Array|Boolean|Date|Error|Function|Math|netscape|'
              r'Number|Object|Packages|RegExp|String|sun|decodeURI|'
              r'decodeURIComponent|encodeURI|encodeURIComponent|'
              r'Error|eval|isFinite|isNaN|parseFloat|parseInt|document|this|'
              r'window)\b',
              Token.NameBuiltin),
          // Match stuff like: module name {...}
          Parse.bygroups(
              r'\b(module)(\s*)(\s*[\w?.$][\w?.$]*)(\s*)',
              [Token.KeywordReserved, Token.Text, Token.NameOther, Token.Text],
              ['slashstartsregex']),
          // Match variable type keywords
          const Parse(r'\b(string|bool|number)\b', Token.KeywordType),
          // Match things like: constructor
          const Parse(r'\b(constructor|declare|interface|as|AS)\b', Token.KeywordReserved),
          // Match things like: super(argument, list)
          Parse.bygroups(r'(super)(\s*)(\([\w,?.$\s]+\s*\))', [Token.KeywordReserved, Token.Text],
              ['slashstartsregex']),
          // Match things like: function() {...}
          const Parse(r'([a-zA-Z_?.$][\w?.$]*)\(\) \{', Token.NameOther, ['slashstartsregex']),
          // Match things like: (function: return type)
          Parse.bygroups(r'([\w?.$][\w?.$]*)(\s*:\s*)([\w?.$][\w?.$]*)',
              [Token.NameOther, Token.Text, Token.KeywordType]),
          const Parse(r'[$a-zA-Z_]\w*', Token.NameOther),
          const Parse(r'[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?', Token.NumberFloat),
          const Parse(r'0x[0-9a-fA-F]+', Token.NumberHex),
          const Parse(r'[0-9]+', Token.NumberInteger),
          const Parse(r'"(\\\\|\\"|[^"])*"', Token.StringDouble),
          const Parse(r"'(\\\\|\\'|[^'])*'", Token.StringSingle),
          const Parse(r'`', Token.StringBacktick, ['interp']),
          // Match things like: Decorators
          const Parse(r'@\w+', Token.KeywordDeclaration),
        ],
        'interp': _jsLexer.parses['interp'] ?? [],
        'interp-inside': _jsLexer.parses['interp-inside'] ?? [],
      };
}
