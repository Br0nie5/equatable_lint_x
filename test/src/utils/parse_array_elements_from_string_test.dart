import 'package:equatable_lint_x/src/utils/parse_array_elements_from_string.dart';
import 'package:test/test.dart';

void main() {
  test('should parse these strings into the correct arrays.', () {
    const testElements = [
      _TestElement(
        description: 'Should parse my two field into an two-elements array.',
        input: '[firstField, secondField]',
        correctAnswer: ['firstField', 'secondField'],
      ),
      _TestElement(
        description:
            'Should parse my two field on 2 lines into an '
            'two-elements array',
        input: '''
[
  firstField,
  secondField
]
''',
        correctAnswer: ['firstField', 'secondField'],
      ),
      _TestElement(
        description:
            'Should parse every arrays and put all the elements '
            'inside a single returned array.',
        input: '[firstField, secondField].addAll([thirdField, fourthField])',
        correctAnswer: [
          'firstField',
          'secondField',
          'thirdField',
          'fourthField',
        ],
      ),
      _TestElement(
        description:
            'Should return an empty array if no array found in the input.',
        input: 'random string without any array',
        correctAnswer: [],
      ),
      _TestElement(
        description:
            'Should return an empty array if array in the input is empty.',
        input: '[]',
        correctAnswer: [],
      ),
      _TestElement(
        description: 'Should ignore strings outside the array in the input.',
        input: 'some string then an array [my value] then some other string',
        correctAnswer: ['my value'],
      ),
    ];

    for (final testElement in testElements) {
      expect(
        parseArrayElementsFromString(testElement.input),
        testElement.correctAnswer,
        reason:
            '''
Test '${testElement.description}' failed.
Parsing of ${testElement.input} returned ${parseArrayElementsFromString(testElement.input)} instead of ${testElement.correctAnswer}.
''',
      );
    }
  });
}

class _TestElement {
  const _TestElement({
    required this.description,
    required this.input,
    required this.correctAnswer,
  });

  final String description;
  final String input;
  final List<String> correctAnswer;
}
