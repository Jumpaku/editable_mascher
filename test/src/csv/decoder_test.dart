import 'package:editable_mascher/src/csv/decoder.dart';
import 'package:editable_mascher/src/csv/parse_exception.dart';
import 'package:editable_mascher/src/csv/result.dart';
import 'package:test/test.dart';

typedef _Testcase = ({
  String input,
  Result<List<List<String>>, ParseException> expected
});

void main() {
  group('Decoder', () {
    const testcases = <_Testcase>[
      (
        input: "aaa,bbb,ccc\r\nzzz,yyy,xxx\r\n",
        expected: Success([
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ])
      ),
      (
        input: "aaa,bbb,ccc\r\nzzz,yyy,xxx",
        expected: Success([
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ])
      ),
      (
        input: "\"aaa\",\"bbb\",\"ccc\"\r\nzzz,yyy,xxx",
        expected: Success([
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ])
      ),
      (
        input: "\"aaa\",\"b\r\nbb\",\"ccc\"\r\nzzz,yyy,xxx",
        expected: Success([
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ])
      ),
      (
        input: "\"aaa\",\"b\"\"bb\",\"ccc\"",
        expected: Success([
          ["aaa", "b\"bb", "ccc"]
        ])
      ),
      (
        input: "\"aaa\",\"b,bb\",\"ccc\"",
        expected: Success([
          ["aaa", "b,bb", "ccc"]
        ])
      ),
    ];

    final sut = Decoder(
      fieldQuote: '"',
      fieldSeparator: ",",
      recordSeparator: "\r\n",
    );

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.decode(testcase.input);
        expect(actual is Success, testcase.expected is Success);
        expect((actual as Success).value,
            equals((testcase.expected as Success).value));
      });
    }
  });
}
