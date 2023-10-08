import '../base/lexer.dart';

// For `CoffeeScript`_ source code. http://coffeescript.org
class CoffeeScriptLexer extends RegexLexer {
  final name = 'CoffeeScript';
  final aliases = ['coffee-script', 'coffeescript', 'coffee'];
  final filenames = ['*.coffee'];
  final mimetypes = ['text/coffeescript'];

  final _operator_re = (r'\+\+|~|&&|\band\b|\bor\b|\bis\b|\bisnt\b|\bnot\b|\?|:|'
      r'\|\||\\(?=\n)|'
      r'(<<|>>>?|==?(?!>)|!=?|=(?!>)|-(?!>)|[<>+*`%&\|\^/])=?');

  final RegExpFlags flags = const RegExpFlags(
    dotAll: true,
  );
  Map<String, List<Parse>> get parses => {
        'commentsandwhitespace': const [
          Parse(r'\s+', Token.Text),
          Parse(r'###[^#].*?###', Token.CommentMultiline),
          Parse(r'#(?!##[^#]).*?\n', Token.CommentSingle),
        ],
        'multilineregex': const [
          Parse(r'[^/#]+', Token.StringRegex),
          Parse(r'///([gim]+\b|\B)', Token.StringRegex, [POP]),
          Parse(r'#\{', Token.StringInterpol, ['interpoling_string']),
          Parse(r'[/#]', Token.StringRegex),
        ],
        'slashstartsregex': [
          const Parse.include('commentsandwhitespace'),
          const Parse(r'///', Token.StringRegex, ([POP, 'multilineregex'])),
          const Parse(
              r'/(?! )(\\.|[^[/\\\n]|\[(\\.|[^\]\\\n])*])+/'
              r'([gim]+\b|\B)',
              Token.StringRegex,
              [POP]),
          // This isn't really guarding against mis-highlighting well-formed
          // code, just the ability to infinite-loop between root and
          // slashstartsregex.
          const Parse(r'/', Token.Operator),
          const Parse.empty([POP]),
        ],
        'root': [
          const Parse.include('commentsandwhitespace'),
          const Parse(r'^(?=\s|/)', Token.Text, ['slashstartsregex']),
          Parse(_operator_re, Token.Operator, ['slashstartsregex']),
          const Parse(r'(?:\([^()]*\))?\s*[=-]>', Token.NameFunction, ['slashstartsregex']),
          const Parse(r'[{(\[;,]', Token.Punctuation, ['slashstartsregex']),
          const Parse(r'[})\].]', Token.Punctuation),
          const Parse(
              r'(?<![.$])(for|own|in|of|while|until|'
              r'loop|break|return|continue|'
              r'switch|when|then|if|unless|else|'
              r'throw|try|catch|finally|new|delete|typeof|instanceof|super|'
              r'extends|this|class|by)\b',
              Token.Keyword,
              ['slashstartsregex']),
          const Parse(
              r'(?<![.$])(true|false|yes|no|on|off|null|'
              r'NaN|Infinity|undefined)\b',
              Token.KeywordConstant),
          const Parse(
              r'(Array|Boolean|Date|Error|Function|Math|netscape|'
              r'Number|Object|Packages|RegExp|String|sun|decodeURI|'
              r'decodeURIComponent|encodeURI|encodeURIComponent|'
              r'eval|isFinite|isNaN|parseFloat|parseInt|document|window)\b',
              Token.NameBuiltin),
          const Parse(r'[$a-zA-Z_][\w.:$]*\s*[:=]\s', Token.NameVariable, ['slashstartsregex']),
          const Parse(
              r'@[$a-zA-Z_][\w.:$]*\s*[:=]\s', Token.NameVariableInstance, ['slashstartsregex']),
          const Parse(r'@', Token.NameOther, ['slashstartsregex']),
          const Parse(r'@?[$a-zA-Z_][\w$]*', Token.NameOther),
          const Parse(r'[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?', Token.NumberFloat),
          const Parse(r'0x[0-9a-fA-F]+', Token.NumberHex),
          const Parse(r'[0-9]+', Token.NumberInteger),
          const Parse('"""', Token.String, ['tdqs']),
          const Parse("'''", Token.String, ['tsqs']),
          const Parse('"', Token.String, ['dqs']),
          const Parse("'", Token.String, ['sqs']),
        ],
        'strings': [
          const Parse(r"[^#\\'" r'"]+', Token.String),
          // note that all coffee script strings are multi-line.
          // hash marks, quotes and backslashes must be parsed one at a time
        ],
        'interpoling_string': [
          const Parse(r'\}', Token.StringInterpol, [POP]),
          const Parse.include('root')
        ],
        'dqs': [
          const Parse(r'"', Token.String, [POP]),
          const Parse(r"\\.|'", Token.String), // double-quoted string don't need ' escapes
          const Parse(r'#\{', Token.StringInterpol, ['interpoling_string']),
          const Parse(r'#', Token.String),
          const Parse.include('strings')
        ],
        'sqs': [
          const Parse(r"'", Token.String, [POP]),
          const Parse(r'#|\\.|"', Token.String), // single quoted strings don't need " escapses
          const Parse.include('strings')
        ],
        'tdqs': [
          const Parse(r'"""', Token.String, [POP]),
          const Parse(r"\\.|'|" r'"', Token.String), // no need to escape quotes in triple-string
          const Parse(r'#\{', Token.StringInterpol, ['interpoling_string']),
          const Parse(r'#', Token.String),
          const Parse.include('strings'),
        ],
        'tsqs': [
          const Parse(r"'''", Token.String, [POP]),
          const Parse(r"#|\\.|'|" r'"', Token.String), // no need to escape quotes in triple-strings
          const Parse.include('strings')
        ],
      };
}
