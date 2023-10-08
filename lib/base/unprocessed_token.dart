import 'package:equatable/equatable.dart';

import 'token.dart';

class UnprocessedToken extends Equatable {
  const UnprocessedToken(this.pos, this.token, this.match);

  final int pos;
  final Token token;
  final String match;

  String toString() {
    return 'UnprocessedToken($pos, $token, \'${_stringifyMatch(match)}\')';
  }

  String _stringifyMatch(String match) {
    if (match == '\n') return '\\n';
    if (match == "'") return "\\'";
    return match;
  }

  @override
  List<Object> get props => [pos, token, match];
}
