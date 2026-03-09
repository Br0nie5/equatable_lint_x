import 'package:test_reflective_loader/test_reflective_loader.dart';

import '''always_call_super_props_when_overriding_equatable_props_analysis_rule.dart''';

void main() {
  defineReflectiveSuite(
    () {
      defineReflectiveTests(
        AlwaysCallSuperPropsWhenOverridingEquatablePropsTestExceptionCases,
      );
    },
    name:
        'Always call super props when overriding equatable props exception '
        'cases test group',
  );
}

@reflectiveTest
class AlwaysCallSuperPropsWhenOverridingEquatablePropsTestExceptionCases
    extends AlwaysCallSuperPropsWhenOverridingEquatablePropsAnalysisRuleTest {
  /// Should not show a lint if a class is directly extending Equatable and
  /// props does not call super.props
  Future<void> test_case_1() async {
    await assertNoDiagnostics('''
import 'package:equatable/equatable.dart';

class BaseEquatableTestClass extends Equatable {
  const BaseEquatableTestClass();

  @override
  List<Object?> get props => [];
}
''');
  }

  /// Should not show a lint if a class is directly with EquatableMixin and
  /// props does not call super.props
  Future<void> test_case_2() async {
    await assertNoDiagnostics('''
import 'package:equatable/equatable.dart';

class BaseEquatableTestClass with EquatableMixin {
  const BaseEquatableTestClass();

  @override
  List<Object?> get props => [];
}
''');
  }
}
