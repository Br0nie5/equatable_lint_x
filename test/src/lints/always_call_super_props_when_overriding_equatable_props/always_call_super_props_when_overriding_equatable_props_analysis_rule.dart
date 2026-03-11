import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:equatable_lint_x/src/lints/always_call_super_props_when_overriding_equatable_props.dart';
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
  // ignore: always_declare_return_types, strict_top_level_inference, type_annotate_public_apis
  customLint(int offset, int length) => lint(
    offset,
    length,
    correctionContains:
        AlwaysCallSuperPropsWhenOverridingEquatableProps.code.correctionMessage,
    messageContainsAll: [
      AlwaysCallSuperPropsWhenOverridingEquatableProps.code.problemMessage,
    ],
  );
}
