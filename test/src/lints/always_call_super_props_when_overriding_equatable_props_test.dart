import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:equatable_lint_x/src/lints/always_call_super_props_when_overriding_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../utils/mocks.dart';

void main() {
  defineReflectiveSuite(
    () {
      defineReflectiveTests(
        AlwaysCallSuperPropsWhenOverridingEquatablePropsTestGetterCases,
      );
    },
    name: 'Equatable props getter cases group',
  );
  defineReflectiveSuite(
    () {
      defineReflectiveTests(
        AlwaysCallSuperPropsWhenOverridingEquatablePropsTestFieldCases,
      );
    },
    name: 'Equatable props field cases group',
  );
}

@reflectiveTest
class AlwaysCallSuperPropsWhenOverridingEquatablePropsTestGetterCases
    extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = AlwaysCallSuperPropsWhenOverridingEquatableProps();
    super.setUp();
  }

  /// Should show a lint if a variable is not in equatable props getter
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
      [
        lint(
          303,
          47,
          correctionContains: AlwaysCallSuperPropsWhenOverridingEquatableProps
              .code.correctionMessage,
          messageContainsAll: [
            AlwaysCallSuperPropsWhenOverridingEquatableProps
                .code.problemMessage,
          ],
          name: AlwaysCallSuperPropsWhenOverridingEquatableProps.code.name,
        ),
      ],
    );
  }
}

@reflectiveTest
class AlwaysCallSuperPropsWhenOverridingEquatablePropsTestFieldCases
    extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = AlwaysCallSuperPropsWhenOverridingEquatableProps();
    super.setUp();
  }

  /// Should show a lint if a variable is not in equatable props getter
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
      [
        lint(
          297,
          53,
          correctionContains: AlwaysCallSuperPropsWhenOverridingEquatableProps
              .code.correctionMessage,
          messageContainsAll: [
            AlwaysCallSuperPropsWhenOverridingEquatableProps
                .code.problemMessage,
          ],
          name: AlwaysCallSuperPropsWhenOverridingEquatableProps.code.name,
        ),
      ],
    );
  }
}
