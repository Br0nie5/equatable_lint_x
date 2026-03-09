import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'missing_field_in_equatable_props_analysis_rule.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MissingFieldInEquatablePropsTestFieldCases);
  }, name: 'Missing Field in Equatable field getter cases test group');
}

@reflectiveTest
class MissingFieldInEquatablePropsTestFieldCases
    extends MissingFieldInEquatablePropsAnalysisRuleTest {
  /// Should show a lint if the class extends Equatable and a field is not in
  /// equatable props field
  Future<void> test_case_1() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  EquatableTestClass({this.field});

  final String? field;

  @override
  late final List<Object?> props = [];
}
''',
      [
        lint(
          142,
          5,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a single lint if the class extends Equatable and multiple
  /// fields on the same line are not in equatable props field
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  EquatableTestClass({this.field1, this.field2});

  final String? field1, field2;

  @override
  late final List<Object?> props = [];
}
''',
      [
        lint(
          156,
          6,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
        lint(
          164,
          6,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a single lint if the class extends Equatable and multiple
  /// fields on multiple lines are not in equatable props field
  Future<void> test_case_3() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  EquatableTestClass({this.field1, this.field2});

  final String? field1;

  final String? field2;

  @override
  late final List<Object?> props = [];
}
''',
      [
        lint(
          156,
          6,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
        lint(
          181,
          6,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a lint if the class is with EquatableMixin and a field is not
  /// in equatable props field
  Future<void> test_case_4() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass with EquatableMixin {
  EquatableTestClass({this.field});

  final String? field;

  @override
  late final List<Object?> props = [];
}
''',
      [
        lint(
          144,
          5,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }
}
