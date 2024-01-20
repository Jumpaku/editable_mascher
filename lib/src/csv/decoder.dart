import 'package:characters/characters.dart';
import 'package:editable_mascher/src/csv/encoder.dart';
import 'package:editable_mascher/src/csv/parse_exception.dart';
import 'package:editable_mascher/src/csv/parse.dart';
import 'package:editable_mascher/src/csv/result.dart';
import 'package:editable_mascher/src/csv/tokenize.dart';

class Decoder {
  Decoder(
      {String recordSeparator = "\r\n",
      String fieldSeparator = ",",
      String fieldQuote = '"'})
      : recordSeparator = Characters(recordSeparator).toList(),
        fieldSeparator = Characters(fieldSeparator).toList(),
        fieldQuote = Characters(fieldQuote).toList();

  final List<String> recordSeparator;
  final List<String> fieldSeparator;
  final List<String> fieldQuote;

  Result<List<List<String>>, ParseException> decode(String input) {
    final tokenizer = Tokenizer(recordSeparator, fieldSeparator, fieldQuote);
    final tokens = tokenizer.tokenize(input);

    final parser = Parser(recordSeparator, fieldSeparator, fieldQuote);
    final result = parser.parse(tokens);
    return result;
  }

  Encoder encoder(
      {bool forceQuote = false, terminatesWithRecordSeparator = false}) {
    return Encoder(
      recordSeparator: recordSeparator.join(),
      fieldSeparator: fieldSeparator.join(),
      fieldQuote: fieldQuote.join(),
      forceQuote: forceQuote,
      terminatesWithRecordSeparator: terminatesWithRecordSeparator,
    );
  }
}
