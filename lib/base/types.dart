class RegExpFlags {
  const RegExpFlags({
    this.dotAll = false,
    this.unicode = false,
    this.multiline = false,
    this.caseSensitive = false,
  });

  final bool dotAll;
  final bool unicode;
  final bool multiline;
  final bool caseSensitive;
}
