
import 'package:editable_mascher/src/csv/decoder.dart';

class Encoder {
  Encoder(
      {this.recordSeparator = "\r\n",
        this.fieldSeparator = ",",
        this.fieldQuote = '"',
        this.forceQuote = false,
        this.terminatesWithRecordSeparator = true});

  final String recordSeparator;
  final String fieldSeparator;
  final String fieldQuote;
  final bool forceQuote;
  final bool terminatesWithRecordSeparator;

  String encode(List<List<String>> table) {
    return table.map((record) {
      final quote = fieldQuote;
      final escapedRecord = record.map((field) =>
      (forceQuote || field.contains(quote)) ||
          field.contains(fieldSeparator) ||
          field.contains(recordSeparator)
          ? "$quote${field.replaceAll(quote, quote + quote)}$quote"
          : field);
      return escapedRecord.join(fieldSeparator);
    }).join(recordSeparator) +
        (terminatesWithRecordSeparator ? recordSeparator : "");
  }

  Decoder decoder() {
    return Decoder(
      recordSeparator: recordSeparator,
      fieldSeparator: fieldSeparator,
      fieldQuote: fieldQuote,
    );
  }
}
