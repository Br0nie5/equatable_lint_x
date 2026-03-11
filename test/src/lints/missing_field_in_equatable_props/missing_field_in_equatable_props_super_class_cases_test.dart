import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'missing_field_in_equatable_props_analysis_rule.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MissingFieldInEquatablePropsTestSuperClassCases);
  }, name: 'Missing Field in Equatable props super class cases test group');
}

@reflectiveTest
class MissingFieldInEquatablePropsTestSuperClassCases
    extends MissingFieldInEquatablePropsAnalysisRuleTest {
  /// Should show a lint if the class has a superclass that extends Equatable
  /// and a field is not in equatable props getter
  Future<void> test_case_1() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class BaseEquatableTestClass extends Equatable {
  const BaseEquatableTestClass();

  @override
  List<Object?> get props => [];
}

class EquatableTestClass extends BaseEquatableTestClass {
  const EquatableTestClass({this.newField});

  final String? newField;

  @override
  List<Object?> get props => super.props..addAll([]);
}
''',
      [
        lint(
          296,
          8,
          correctionContains: MissingFieldInEquatableProps
              .code
              .correctionMessage
              ?.replaceAll('{0}', 'newField'),
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage.replaceAll(
              '{0}',
              'newField',
            ),
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
      ],
    );
  }

  /// Should show a lint if the class has a superclass with EquatableMixin and a
  /// field is not in equatable props getter
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class BaseEquatableClass with EquatableMixin {
  const BaseEquatableClass();

  @override
  List<Object?> get props => [];
}

class EquatableTestClass extends BaseEquatableClass {
  const EquatableTestClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          283,
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
