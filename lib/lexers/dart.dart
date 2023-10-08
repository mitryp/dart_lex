import '../base/lexer.dart';

class DartLexer extends RegexLexer {
  final name = 'Dart';
  final aliases = ['dart'];
  final filenames = ['*.dart'];
  final mimetypes = ['text/x-dart'];

  final RegExpFlags flags = const RegExpFlags(
    dotAll: true,
    multiline: true,
  );
  Map<String, List<Parse>> get parses => {
        'root': [
          const Parse.include('string_literal'),
          const Parse(r'#!(.*?)$', Token.CommentPreproc),
          const Parse(r'\b(import|export)\b', Token.Keyword, ['import_decl']),
          const Parse(r'\b(library|source|part of|part)\b', Token.Keyword),
          const Parse(r'[^\S\n]+', Token.Text),
          const Parse(r'//.*?\n', Token.CommentSingle),
          const Parse(r'/\*.*?\*/', Token.CommentMultiline),
          Parse.bygroups(r'\b(class)\b(\s+)', [Token.KeywordDeclaration, Token.Text], ['class']),
          const Parse(
              r'\b(assert|break|case|catch|continue|default|do|else|finally|for|'
              r'if|in|is|new|return|super|switch|this|throw|try|while)\b',
              Token.Keyword),
          const Parse(
              r'\b(abstract|async|await|const|extends|factory|final|get|'
              r'implements|native|operator|set|static|sync|typedef|var|with|'
              r'yield)\b',
              Token.KeywordDeclaration),
          const Parse(r'\b(bool|double|dynamic|int|num|Object|String|void)\b', Token.KeywordType),
          const Parse(r'\b(false|null|true)\b', Token.KeywordConstant),
          const Parse(r'[~!%^&*+=|?:<>/-]|as\b', Token.Operator),
          const Parse(r'[a-zA-Z_$]\w*:', Token.NameLabel),
          const Parse(r'[a-zA-Z_$]\w*', Token.Name),
          const Parse(r'[(){}\[\],.;]', Token.Punctuation),
          const Parse(r'0[xX][0-9a-fA-F]+', Token.NumberHex),
          const Parse(r'\d+(\.\d*)?([eE][+-]?\d+)?', Token.Number),
          const Parse(r'\.\d+([eE][+-]?\d+)?', Token.Number),
          const Parse(r'\n', Token.Text)
        ],
        'class': [
          const Parse(r'[a-zA-Z_$]\w*', Token.NameClass, [POP])
        ],
        'import_decl': [
          const Parse.include('string_literal'),
          const Parse(r'\s+', Token.Text),
          const Parse(r'\b(as|show|hide)\b', Token.Keyword),
          const Parse(r'[a-zA-Z_$]\w*', Token.Name),
          const Parse(r'\,', Token.Punctuation),
          const Parse(r'\;', Token.Punctuation, [POP])
        ],
        'string_literal': [
          // Raw strings.
          const Parse(r'r"""([\w\W]*?)"""', Token.StringDouble),
          const Parse(r"r'''([\w\W]*?)'''", Token.StringSingle),
          const Parse(r'r"(.*?)"', Token.StringDouble),
          const Parse(r"r'(.*?)'", Token.StringSingle),
          // Normal Strings.
          const Parse(r'"""', Token.StringDouble, ['string_double_multiline']),
          const Parse(r"'''", Token.StringSingle, ['string_single_multiline']),
          const Parse(r'"', Token.StringDouble, ['string_double']),
          const Parse(r"'", Token.StringSingle, ['string_single'])
        ],
        'string_common': [
          const Parse(
              r"\\(x[0-9A-Fa-f]{2}|u[0-9A-Fa-f]{4}|u\{[0-9A-Fa-f]*\}|[a-z'"
              r'"$\\])',
              Token.StringEscape),
          Parse.bygroups(r'(\$)([a-zA-Z_]\w*)', [Token.StringInterpol, Token.Name]),
          Parse.bygroups(r'(\$\{)(.*?)(\})', [
            Token.StringInterpol,
            Token.RecurseSameLexer,
            Token.StringInterpol,
          ])
        ],
        'string_double': [
          const Parse(r'"', Token.StringDouble, [POP]),
          const Parse(r'[^"$\\\n]+', Token.StringDouble),
          const Parse.include('string_common'),
          const Parse(r'\$+', Token.StringDouble)
        ],
        'string_double_multiline': [
          const Parse(r'"""', Token.StringDouble, [POP]),
          const Parse(r'[^"$\\]+', Token.StringDouble),
          const Parse.include('string_common'),
          const Parse(r'(\$|\")+', Token.StringDouble)
        ],
        'string_single': [
          const Parse(r"'", Token.StringSingle, [POP]),
          const Parse(r"[^'$\\\n]+", Token.StringSingle),
          const Parse.include('string_common'),
          const Parse(r'\$+', Token.StringSingle)
        ],
        'string_single_multiline': [
          const Parse(r"'''", Token.StringSingle, [POP]),
          const Parse(r"[^'$\\]+", Token.StringSingle),
          const Parse.include('string_common'),
          const Parse(r"(\$|\')+", Token.StringSingle)
        ]
      };
}
