import 'dart:math';

import 'package:characters/characters.dart';

class Tokenizer {
  Tokenizer(this.recordSeparator, this.fieldSeparator, this.fieldQuote);

  final List<String> recordSeparator;
  final List<String> fieldSeparator;
  final List<String> fieldQuote;

  List<Token> tokenize(String input) {
    final s = TokenizeState(Characters(input).toList());
    final tokens = <Token>[];

    while (s.cursor < s.input.length) {
      for (final scanner in [
        _PatternScanner(fieldQuote, TokenKind.quote),
        _PatternScanner(fieldSeparator, TokenKind.fieldSeparator),
        _PatternScanner(recordSeparator, TokenKind.recordSeparator),
        _SingleCharacterScanner(),
      ]) {
        final token = scanner.scan(s);
        if (token != null) {
          tokens.add(token);
          break;
        }
      }
    }
    tokens.add(Token(s.cursor, TokenKind.endOfContents, ""));
    return tokens;
  }
}

class TokenizeState {
  TokenizeState(this.input);

  final List<String> input;
  int _cursor = 0;

  int get cursor => _cursor;

  List<String> peek(int length) {
    return input.sublist(cursor, min(input.length, cursor + length));
  }

  void move(int offset) {
    _cursor = min(_cursor + offset, input.length);
  }
}

enum TokenKind {
  recordSeparator,
  fieldSeparator,
  quote,
  simpleCharacter,
  endOfContents,
}

class Token {
  const Token(this.position, this.kind, this.content);

  final int position;
  final TokenKind kind;
  final String content;

  @override
  String toString() => "Token(position:$position,kind:$kind,content:$content)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Token &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          kind == other.kind &&
          content == other.content;

  @override
  int get hashCode => Object.hashAll([position, kind, content]);
}

sealed class _Scanner {
  Token? scan(TokenizeState s);
}

class _PatternScanner extends _Scanner {
  _PatternScanner(this.pattern, this.kind);

  final List<String> pattern;
  final TokenKind kind;

  @override
  Token? scan(TokenizeState s) {
    final peek = s.peek(pattern.length);
    if (peek.join() == pattern.join()) {
      final t = Token(s.cursor, kind, peek.join());
      s.move(pattern.length);
      return t;
    }
    return null;
  }
}

class _SingleCharacterScanner extends _Scanner {
  _SingleCharacterScanner();

  @override
  Token? scan(TokenizeState s) {
    final peek = s.peek(1);
    if (peek.join() != "") {
      final t = Token(s.cursor, TokenKind.simpleCharacter, peek.join());
      s.move(1);
      return t;
    }
    return null;
  }
}
