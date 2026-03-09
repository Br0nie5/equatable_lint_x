import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'missing_field_in_equatable_props_analysis_rule.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MissingFieldInEquatablePropsTestExceptionsCases);
  }, name: 'Missing Field in Equatable props exception cases test group');
}

@reflectiveTest
class MissingFieldInEquatablePropsTestExceptionsCases
    extends MissingFieldInEquatablePropsAnalysisRuleTest {
  /// Should not show a lint if the class extends Equatable and a static
  /// variable is not in equatable props
  Future<void> test_case_1() async {
    await assertNoDiagnostics('''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass();

  static const testStatic = false;

  @override
  List<Object?> get props => [];
}
''');
  }

  /// Should allow the lint "missing_field_in_equatable_props" to be ignored
  Future<void> test_case_2() async {
    await assertNoDiagnostics('''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field});

  // ignore: missing_field_in_equatable_props
  final String? field;

  @override
  List<Object?> get props => [];
}
''');
  }

  /// Should not show a lint if the class extends Equatable and a getter is not
  /// in equatable props
  Future<void> test_case_3() async {
    await assertNoDiagnostics('''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass();

  bool get testGetter => false;

  @override
  List<Object?> get props => [];
}
''');
  }

  /// Should not show a lint if the class is not extending Equatable
  Future<void> test_case_4() async {
    await assertNoDiagnostics('''
class NotEquatableTestClass {
  const NotEquatableTestClass({this.field});

  final String? field;
}
''');
  }

  /// Should show a lint if the class that has Equatable as a superclass and no
  /// props field nor getter is present
  Future<void> test_case_5() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class BaseEquatableTestClass extends Equatable {
  const BaseEquatableTestClass();

  @override
  List<Object?> get props => [];
}

class EquatableTestClass extends BaseEquatableTestClass {
  const EquatableTestClass({this.field});

  final String? field;
}
''',
      [
        lint(
          293,
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
