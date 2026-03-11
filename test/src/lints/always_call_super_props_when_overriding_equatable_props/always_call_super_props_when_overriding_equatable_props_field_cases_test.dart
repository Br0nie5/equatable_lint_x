import 'package:test_reflective_loader/test_reflective_loader.dart';

import '''always_call_super_props_when_overriding_equatable_props_analysis_rule.dart''';

void main() {
  defineReflectiveSuite(
    () {
      defineReflectiveTests(
        AlwaysCallSuperPropsWhenOverridingEquatablePropsTestFieldCases,
      );
    },
    name:
        'Always call super props when overriding equatable props field cases '
        'test group',
  );
}

@reflectiveTest
class AlwaysCallSuperPropsWhenOverridingEquatablePropsTestFieldCases
    extends AlwaysCallSuperPropsWhenOverridingEquatablePropsAnalysisRuleTest {
  /// Should show a lint if a class has Equatable as a superclass but its props
  /// field doesn't call super.props
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
  EquatableTestClass({this.field});

  final String? field;

  @override
  late final List<Object?> props = [field];
}
''',
      [customLint(297, 53)],
    );
  }

  /// Should show a lint if a class has a superclass with EquatableMixin but its
  /// props field doesn't call super.props
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class BaseEquatableTestClass with EquatableMixin {
  BaseEquatableTestClass();

  @override
  late final List<Object?> props = [];
}

class EquatableTestClass extends BaseEquatableTestClass {
  EquatableTestClass({this.field});

  final String? field;

  @override
  late final List<Object?> props = [field];
}
''',
      [customLint(299, 53)],
    );
  }
}
