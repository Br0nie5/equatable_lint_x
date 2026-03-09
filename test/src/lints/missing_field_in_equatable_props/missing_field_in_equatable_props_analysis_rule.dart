import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';
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
}
