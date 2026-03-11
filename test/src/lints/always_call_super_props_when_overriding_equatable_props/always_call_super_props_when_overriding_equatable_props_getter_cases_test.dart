import 'package:test_reflective_loader/test_reflective_loader.dart';

import '''always_call_super_props_when_overriding_equatable_props_analysis_rule.dart''';

void main() {
  defineReflectiveSuite(
    () {
      defineReflectiveTests(
        AlwaysCallSuperPropsWhenOverridingEquatablePropsTestGetterCases,
      );
    },
    name:
        'Always call super props when overriding equatable props getter cases '
        'test group',
  );
}

@reflectiveTest
class AlwaysCallSuperPropsWhenOverridingEquatablePropsTestGetterCases
    extends AlwaysCallSuperPropsWhenOverridingEquatablePropsAnalysisRuleTest {
  /// Should show a lint if a class has Equatable as a superclass but its props
  /// getter doesn't call super.props
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
  const EquatableTestClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [field];
}
''',
      [customLint(303, 47)],
    );
  }

  /// Should show a lint if a class has a superclass with EquatableMixin but its
  /// props getter doesn't call super.props
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class BaseEquatableTestClass with EquatableMixin {
  const BaseEquatableTestClass();

  @override
  List<Object?> get props => [];
}

class EquatableTestClass extends BaseEquatableTestClass {
  const EquatableTestClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [field];
}
''',
      [customLint(305, 47)],
    );
  }
}
