import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'missing_field_in_equatable_props_analysis_rule.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MissingFieldInEquatablePropsTestGetterCases);
  }, name: 'Missing Field in Equatable props getter cases test group');
}

@reflectiveTest
class MissingFieldInEquatablePropsTestGetterCases
    extends MissingFieldInEquatablePropsAnalysisRuleTest {
  /// Should show a lint if the class extends Equatable and a field is not in
  /// equatable props getter
  Future<void> test_case_1() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          148,
          5,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'field'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'field',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a single lint if the class extends Equatable and multiple
  /// fields on the same line are not in equatable props getter
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field1, this.field2});

  final String? field1, field2;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          162,
          6,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'field1'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'field1',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
        lint(
          170,
          6,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'field2'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'field2',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a single lint if the class extends Equatable and multiple
  /// fields on multiple lines are not in equatable props getter
  Future<void> test_case_3() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field1, this.field2});

  final String? field1;

  final String? field2;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          162,
          6,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'field1'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'field1',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
        lint(
          187,
          6,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'field2'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'field2',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a lint if the class is with EquatableMixin and a field is not
  /// in equatable props getter
  Future<void> test_case_4() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass with EquatableMixin {
  const EquatableTestClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          150,
          5,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'field'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'field',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }
}
