import 'package:characters/characters.dart';
import 'package:editable_mascher/src/csv/parse_exception.dart';
import 'package:editable_mascher/src/csv/parse.dart';
import 'package:editable_mascher/src/csv/result.dart';
import 'package:editable_mascher/src/csv/tokenize.dart';
import 'package:test/test.dart';

typedef _Testcase = ({
  List<Token> input,
  Result<List<List<String>>, ParseException> expected
});

void main() {
  group('Parser', () {
    const testcases = <_Testcase>[
      (
        input: [
          Token(0, TokenKind.simpleCharacter, "a"),
          Token(1, TokenKind.simpleCharacter, "a"),
          Token(2, TokenKind.simpleCharacter, "a"),
          Token(3, TokenKind.fieldSeparator, ","),
          Token(4, TokenKind.simpleCharacter, "b"),
          Token(5, TokenKind.simpleCharacter, "b"),
          Token(6, TokenKind.simpleCharacter, "b"),
          Token(7, TokenKind.fieldSeparator, ","),
          Token(8, TokenKind.simpleCharacter, "c"),
          Token(9, TokenKind.simpleCharacter, "c"),
          Token(10, TokenKind.simpleCharacter, "c"),
          Token(11, TokenKind.recordSeparator, "\r\n"),
          Token(12, TokenKind.simpleCharacter, "z"),
          Token(13, TokenKind.simpleCharacter, "z"),
          Token(14, TokenKind.simpleCharacter, "z"),
          Token(15, TokenKind.fieldSeparator, ","),
          Token(16, TokenKind.simpleCharacter, "y"),
          Token(17, TokenKind.simpleCharacter, "y"),
          Token(18, TokenKind.simpleCharacter, "y"),
          Token(19, TokenKind.fieldSeparator, ","),
          Token(20, TokenKind.simpleCharacter, "x"),
          Token(21, TokenKind.simpleCharacter, "x"),
          Token(22, TokenKind.simpleCharacter, "x"),
          Token(23, TokenKind.recordSeparator, "\r\n"),
          Token(24, TokenKind.endOfContents, ""),
        ],
        expected: Success([
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]),
      ),
      (
        input: [
          Token(0, TokenKind.simpleCharacter, "a"),
          Token(1, TokenKind.simpleCharacter, "a"),
          Token(2, TokenKind.simpleCharacter, "a"),
          Token(3, TokenKind.fieldSeparator, ","),
          Token(4, TokenKind.simpleCharacter, "b"),
          Token(5, TokenKind.simpleCharacter, "b"),
          Token(6, TokenKind.simpleCharacter, "b"),
          Token(7, TokenKind.fieldSeparator, ","),
          Token(8, TokenKind.simpleCharacter, "c"),
          Token(9, TokenKind.simpleCharacter, "c"),
          Token(10, TokenKind.simpleCharacter, "c"),
          Token(11, TokenKind.recordSeparator, "\r\n"),
          Token(12, TokenKind.simpleCharacter, "z"),
          Token(13, TokenKind.simpleCharacter, "z"),
          Token(14, TokenKind.simpleCharacter, "z"),
          Token(15, TokenKind.fieldSeparator, ","),
          Token(16, TokenKind.simpleCharacter, "y"),
          Token(17, TokenKind.simpleCharacter, "y"),
          Token(18, TokenKind.simpleCharacter, "y"),
          Token(19, TokenKind.fieldSeparator, ","),
          Token(20, TokenKind.simpleCharacter, "x"),
          Token(21, TokenKind.simpleCharacter, "x"),
          Token(22, TokenKind.simpleCharacter, "x"),
          Token(23, TokenKind.endOfContents, ""),
        ],
        expected: Success([
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ])
      ),
      (
        input: [
          Token(0, TokenKind.quote, "\""),
          Token(1, TokenKind.simpleCharacter, "a"),
          Token(2, TokenKind.simpleCharacter, "a"),
          Token(3, TokenKind.simpleCharacter, "a"),
          Token(4, TokenKind.quote, "\""),
          Token(5, TokenKind.fieldSeparator, ","),
          Token(6, TokenKind.quote, "\""),
          Token(7, TokenKind.simpleCharacter, "b"),
          Token(8, TokenKind.simpleCharacter, "b"),
          Token(9, TokenKind.simpleCharacter, "b"),
          Token(10, TokenKind.quote, "\""),
          Token(11, TokenKind.fieldSeparator, ","),
          Token(12, TokenKind.quote, "\""),
          Token(13, TokenKind.simpleCharacter, "c"),
          Token(14, TokenKind.simpleCharacter, "c"),
          Token(15, TokenKind.simpleCharacter, "c"),
          Token(16, TokenKind.quote, "\""),
          Token(17, TokenKind.recordSeparator, "\r\n"),
          Token(18, TokenKind.simpleCharacter, "z"),
          Token(19, TokenKind.simpleCharacter, "z"),
          Token(20, TokenKind.simpleCharacter, "z"),
          Token(21, TokenKind.fieldSeparator, ","),
          Token(22, TokenKind.simpleCharacter, "y"),
          Token(23, TokenKind.simpleCharacter, "y"),
          Token(24, TokenKind.simpleCharacter, "y"),
          Token(25, TokenKind.fieldSeparator, ","),
          Token(26, TokenKind.simpleCharacter, "x"),
          Token(27, TokenKind.simpleCharacter, "x"),
          Token(28, TokenKind.simpleCharacter, "x"),
          Token(29, TokenKind.endOfContents, ""),
        ],
        expected: Success([
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ])
      ),
      (
        input: [
          Token(0, TokenKind.quote, "\""),
          Token(1, TokenKind.simpleCharacter, "a"),
          Token(2, TokenKind.simpleCharacter, "a"),
          Token(3, TokenKind.simpleCharacter, "a"),
          Token(4, TokenKind.quote, "\""),
          Token(5, TokenKind.fieldSeparator, ","),
          Token(6, TokenKind.quote, "\""),
          Token(7, TokenKind.simpleCharacter, "b"),
          Token(8, TokenKind.recordSeparator, "\r\n"),
          Token(9, TokenKind.simpleCharacter, "b"),
          Token(10, TokenKind.simpleCharacter, "b"),
          Token(11, TokenKind.quote, "\""),
          Token(12, TokenKind.fieldSeparator, ","),
          Token(13, TokenKind.quote, "\""),
          Token(14, TokenKind.simpleCharacter, "c"),
          Token(15, TokenKind.simpleCharacter, "c"),
          Token(16, TokenKind.simpleCharacter, "c"),
          Token(17, TokenKind.quote, "\""),
          Token(18, TokenKind.recordSeparator, "\r\n"),
          Token(19, TokenKind.simpleCharacter, "z"),
          Token(20, TokenKind.simpleCharacter, "z"),
          Token(21, TokenKind.simpleCharacter, "z"),
          Token(22, TokenKind.fieldSeparator, ","),
          Token(23, TokenKind.simpleCharacter, "y"),
          Token(24, TokenKind.simpleCharacter, "y"),
          Token(25, TokenKind.simpleCharacter, "y"),
          Token(26, TokenKind.fieldSeparator, ","),
          Token(27, TokenKind.simpleCharacter, "x"),
          Token(28, TokenKind.simpleCharacter, "x"),
          Token(29, TokenKind.simpleCharacter, "x"),
          Token(30, TokenKind.endOfContents, ""),
        ],
        expected: Success([
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]),
      ),
      (
        input: [
          Token(0, TokenKind.quote, "\""),
          Token(1, TokenKind.simpleCharacter, "a"),
          Token(2, TokenKind.simpleCharacter, "a"),
          Token(3, TokenKind.simpleCharacter, "a"),
          Token(4, TokenKind.quote, "\""),
          Token(5, TokenKind.fieldSeparator, ","),
          Token(6, TokenKind.quote, "\""),
          Token(7, TokenKind.simpleCharacter, "b"),
          Token(8, TokenKind.quote, "\""),
          Token(9, TokenKind.quote, "\""),
          Token(10, TokenKind.simpleCharacter, "b"),
          Token(11, TokenKind.simpleCharacter, "b"),
          Token(12, TokenKind.quote, "\""),
          Token(13, TokenKind.fieldSeparator, ","),
          Token(14, TokenKind.quote, "\""),
          Token(15, TokenKind.simpleCharacter, "c"),
          Token(16, TokenKind.simpleCharacter, "c"),
          Token(17, TokenKind.simpleCharacter, "c"),
          Token(18, TokenKind.quote, "\""),
          Token(19, TokenKind.endOfContents, ""),
        ],
        expected: Success([
          ["aaa", "b\"bb", "ccc"]
        ])
      )
    ];

    final sut = Parser(
      Characters("\r\n").toList(),
      Characters(",").toList(),
      Characters('"').toList(),
    );

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.parse(testcase.input);
        expect(actual is Success, testcase.expected is Success);
        expect((actual as Success).value,
            equals((testcase.expected as Success).value));
      });
    }
  });
}
