import 'lexer.dart';

enum Token {
  Text,
  Whitespace,
  Escape,
  Error,
  Other,
  Keyword,
  KeywordConstant,
  KeywordDeclaration,
  KeywordNamespace,
  KeywordPseudo,
  KeywordReserved,
  KeywordType,
  Name,
  NameAttribute,
  NameBuiltin,
  NameBuiltinPseudo,
  NameClass,
  NameConstant,
  NameDecorator,
  NameEntity,
  NameException,
  NameFunction,
  NameFunctionMagic,
  NameProperty,
  NameLabel,
  NameNamespace,
  NameOther,
  NameTag,
  NameVariable,
  NameVariableClass,
  NameVariableGlobal,
  NameVariableInstance,
  NameVariableMagic,
  Literal,
  LiteralDate,
  String,
  StringAffix,
  StringBacktick,
  StringChar,
  StringDelimiter,
  StringDoc,
  StringDouble,
  StringEscape,
  StringHeredoc,
  StringInterpol,
  StringOther,
  StringRegex,
  StringSingle,
  StringSymbol,
  Number,
  NumberBin,
  NumberFloat,
  NumberHex,
  NumberInteger,
  NumberIntegerLong,
  NumberOct,
  Operator,
  OperatorWord,
  Punctuation,
  Comment,
  CommentHashbang,
  CommentMultiline,
  CommentPreproc,
  CommentPreprocFile,
  CommentSingle,
  CommentSpecial,
  Generic,
  GenericDeleted,
  GenericEmph,
  GenericError,
  GenericHeading,
  GenericInserted,
  GenericOutput,
  GenericPrompt,
  GenericStrong,
  GenericSubheading,
  GenericTraceback,

// Special
  IncludeOtherParse,
  ParseByGroups,
  RecurseSameLexer,
}

const POP = '#pop';
const POP2 = '#pop:2';
const PUSH = '#push';

class Parse {
  const Parse(
    this.pattern,
    this.token, [
    this.newStates = const [],
    this.flags,
  ]);

  const Parse.include(String s) : this(s, Token.IncludeOtherParse);

  const Parse.empty(List<String> nextState) : this('', Token.Text, nextState);

  factory Parse.bygroups(
    String pattern,
    List<Token> tokens, [
    List<String>? nextState,
  ]) =>
      GroupParse(pattern, tokens);

  final String pattern;
  final Token token;
  final List<String> newStates;
  final RegExpFlags? flags;

  Parse? get parent => null;

  List<Token> get groupTokens => [];

  String toString() {
    return '''Parse {
      pattern: $pattern
      token: $token
      newStates: $newStates
    }''';
  }

  List<String> split() {
    List<String> buf = [];
    Parse? node = this;
    while (node != null) {
      buf.add(node.toString());
      node = node.parent;
    }
    return buf.reversed.toList();
  }
}

// Yields multiple actions for each group in the match.
class GroupParse extends Parse {
  const GroupParse(
    String pattern,
    this.groupTokens, [
    List<String> newStates = const [],
  ]) : super(pattern, Token.ParseByGroups);

  final List<Token> groupTokens;
}
