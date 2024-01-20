import 'dart:math';

import 'package:editable_mascher/src/csv/parse_exception.dart';
import 'package:editable_mascher/src/csv/result.dart';
import 'package:editable_mascher/src/csv/tokenize.dart';

class Parser {
  Parser(this.recordSeparator, this.fieldSeparator, this.fieldQuote);

  final List<String> recordSeparator;
  final List<String> fieldSeparator;
  final List<String> fieldQuote;

  Result<List<List<String>>, ParseException> parse(List<Token> input) {
    final s = ParseState(input, recordSeparator.join());
    {
      final t = s.peek(0, 1)[0];
      if (t.kind == TokenKind.endOfContents) {
        return s.failure(codeRecordNotFound, "at least one record required");
      }
    }

    final records = <List<String>>[];
    while (true) {
      final t = s.peek(0, 1)[0];
      if (t.kind == TokenKind.endOfContents) {
        return Success(records);
      }

      final parsed = _parseRecord(s);
      switch (parsed) {
        case Failure(exception: var e):
          return Failure(e);
        case Success(value: var record):
          records.add(record);
      }
    }
  }

  Result<List<String>, ParseException> _parseRecord(ParseState s) {
    var record = <String>[];
    {
      final t = s.peek(0, 1)[0];
      if (t.kind == TokenKind.endOfContents ||
          t.kind == TokenKind.recordSeparator) {
        return s.failure(codeFieldNotFound, "at least one field required");
      }
    }
    while (true) {
      final t = s.peek(0, 1)[0];
      switch (t.kind) {
        case TokenKind.recordSeparator:
          s.move(1);
          return Success(record);
        case TokenKind.endOfContents:
          return Success(record);
        case TokenKind.fieldSeparator:
          s.move(1);
        default:
        // do nothing.
      }

      final parsed = _parseField(s);
      switch (parsed) {
        case (Failure(exception: var e)):
          return Failure(e);
        case (Success(value: var val)):
          record.add(val);
      }
    }
  }

  Result<String, ParseException> _parseQuotedField(ParseState s) {
    // open quote
    final cur = s.peek(0, 1)[0];
    if (cur.kind != TokenKind.quote) {
      return s.failure(
          codeOpenQuoteNotFound, "quote $fieldQuote is expected but not found");
    }
    s.move(1);

    final field = StringBuffer();
    while (true) {
      final found = s.find((token) => token.kind == TokenKind.quote);
      if (found == null) {
        return s.failure(codeCloseQuoteNotFound,
            "quote $fieldQuote is expected but not found");
      }

      field.write(s.peek(0, found).map((t) => t.content).join());
      s.move(found + 1);

      // escaped quote
      final cur = s.peek(0, 1)[0];
      if (cur.kind == TokenKind.quote) {
        field.write(cur.content);
        s.move(1);
        continue;
      }

      // close quote
      return Success(field.toString());
    }
  }

  Result<String, ParseException> _parseUnquotedField(ParseState s) {
    final sep = [
      TokenKind.fieldSeparator,
      TokenKind.recordSeparator,
      TokenKind.endOfContents
    ];
    final found = s.find((token) => sep.contains(token.kind));
    final offset = found ?? s.length;
    final field = s.peek(0, offset).map((t) => t.content).join();
    s.move(offset);
    return Success(field);
  }

  Result<String, ParseException> _parseField(ParseState s) {
    var cur = s.peek(0, 1)[0];
    return switch (cur.kind) {
      TokenKind.fieldSeparator ||
      TokenKind.recordSeparator ||
      TokenKind.endOfContents =>
        const Success(""),
      TokenKind.quote => _parseQuotedField(s),
      TokenKind.simpleCharacter => _parseUnquotedField(s),
    };
  }
}

class ParseState {
  ParseState(this.input, this.lineSeparator, [this._cursor = 0]);

  final List<Token> input;
  final String lineSeparator;

  int get cursor => _cursor;
  int _cursor;

  int? find(bool Function(Token token) satisfies) {
    for (var i = cursor; i < input.length; ++i) {
      if (satisfies(input[i])) return i - cursor;
    }
    return null;
  }

  List<Token> peek(int begin, [int? endExclusive]) {
    endExclusive = endExclusive ?? length;
    return input.sublist(min(input.length, cursor + begin),
        min(input.length, cursor + endExclusive));
  }

  int get length {
    return input.length - cursor;
  }

  void move(int offset) {
    _cursor = min(input.length, _cursor + offset);
  }

  Result<Never, ParseException> failure(String code, String message) {
    return Failure(ParseException(code, message, input, lineSeparator, cursor));
  }
}
