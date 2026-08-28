import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:analyzer_testing/src/analysis_rule/pub_package_resolution.dart';
import 'package:equatable_lint_x/src/lints/always_call_super_props_when_overriding_equatable_props/always_call_super_props_when_overriding_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../../utils/mocks.dart';

@reflectiveTest
class AlwaysCallSuperPropsWhenOverridingEquatablePropsAnalysisRuleTest
    extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = AlwaysCallSuperPropsWhenOverridingEquatableProps();
    super.setUp();
  }

  // Impossible to import the return type [ExpectedDiagnostic] of the lint
  // method from the analyzer testing package.
  ExpectedDiagnostic customLint(int offset, int length) => lint(
    offset,
    length,
    correctionContains:
        AlwaysCallSuperPropsWhenOverridingEquatableProps.code.correctionMessage,
    messageContainsAll: [
      AlwaysCallSuperPropsWhenOverridingEquatableProps.code.problemMessage,
    ],
  );
}
