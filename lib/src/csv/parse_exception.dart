import 'dart:math';

import 'package:characters/characters.dart';
import 'package:editable_mascher/src/csv/tokenize.dart';

const codeOpenQuoteNotFound = "open_quote_not_found";
const codeCloseQuoteNotFound = "close_quote_not_found";
const codeRecordNotFound = "record_not_found";
const codeFieldNotFound = "field_not_found";

class ParseException implements Exception {
  ParseException(
    this.code,
    this.message,
    List<Token> input,
    String lineSeparator,
    this.cursor,
  ) : stackTrace = StackTrace.current {
    final inputChars =
        input.expand((e) => Characters(e.content).toList()).toList();
    final lSep = Characters(lineSeparator).toList();
    var line = 1;
    var column = 1;
    for (var i = 0; i < inputChars.length; ++i) {
      if (i >= cursor) break;

      column++;

      if (lSep.join() == inputChars.getRange(i, i + lSep.length).join()) {
        line++;
        column = 1;
        i += lSep.length;
      }
    }

    this.line = line;
    this.column = column;
    const focusLength = 15;
    contentBefore =
        inputChars.getRange(max(0, cursor - focusLength), cursor).join();
    contentAfter = inputChars.getRange(cursor, cursor + focusLength).join();
  }

  StackTrace stackTrace;
  String message;
  String code;
  final int cursor;
  late final String contentBefore;
  late final String contentAfter;
  late final int line;
  late final int column;
}
