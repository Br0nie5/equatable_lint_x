import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/missing_field_in_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../../utils/mocks.dart';

@reflectiveTest
class MissingFieldInEquatablePropsAnalysisRuleTest extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = MissingFieldInEquatableProps();
    super.setUp();
  }

  // Impossible to import the return type [ExpectedDiagnostic] of the lint
  // method from the analyzer testing package.
  // ignore: always_declare_return_types, strict_top_level_inference, type_annotate_public_apis
  customLint(int offset, int length, {String? variableName}) {
    const variableNamePlaceholder = '{0}';
    return lint(
      offset,
      length,
      correctionContains: MissingFieldInEquatableProps.code.correctionMessage
          ?.replaceAll(
            variableNamePlaceholder,
            variableName ?? variableNamePlaceholder,
          ),
      messageContainsAll: [
        MissingFieldInEquatableProps.code.problemMessage.replaceAll(
          variableNamePlaceholder,
          variableName ?? variableNamePlaceholder,
        ),
      ],
    );
  }
}
