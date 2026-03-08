import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../utils/mocks.dart';

void main() {
  defineReflectiveSuite(
    () {
      defineReflectiveTests(
        MissingFieldInEquatablePropsTestGetterCases,
      );
    },
    name: 'Equatable props getter cases group',
  );
  defineReflectiveSuite(
    () {
      defineReflectiveTests(MissingFieldInEquatablePropsTestFieldCases);
    },
    name: 'Equatable props field cases group',
  );
  defineReflectiveSuite(
    () {
      defineReflectiveTests(MissingFieldInEquatablePropsTestExceptionsCases);
    },
    name: 'Equatable props exception cases group',
  );
  defineReflectiveSuite(
    () {
      defineReflectiveTests(MissingFieldInEquatablePropsTestSuperClassCases);
    },
    name: 'Equatable props super class cases group',
  );
}

@reflectiveTest
class MissingFieldInEquatablePropsTestGetterCases extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = MissingFieldInEquatableProps();
    super.setUp();
  }

  /// Should show a lint if a variable is not in equatable props getter
  Future<void> test_case_1() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          134,
          19,
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

  /// Should show a single lint if multiple variables on the same line are not
  /// in equatable props getter
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field1, this.field2});

  final String? field1, field2;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          148,
          28,
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

  /// Should show a single lint if multiple variables on multiple lines are not
  /// in equatable props getter
  Future<void> test_case_3() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field1, this.field2});

  final String? field1;

  final String? field2;

  @override
  List<Object?> get props => [];
}
''',
      [
        lint(
          148,
          20,
          correctionContains:
              MissingFieldInEquatableProps.code.correctionMessage,
          messageContainsAll: [
            MissingFieldInEquatableProps.code.problemMessage,
          ],
          name: MissingFieldInEquatableProps.code.name,
        ),
        lint(
          173,
          20,
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

@reflectiveTest
class MissingFieldInEquatablePropsTestFieldCases extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = MissingFieldInEquatableProps();
    super.setUp();
  }

  /// Should show a lint if a field is not in equatable props field
  Future<void> test_case_1() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  EquatableTestClass({this.field});

  final String? field;

  @override
  late final List<Object?> props = [];
}
''',
      [
        lint(
          128,
          19,
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

@reflectiveTest
class MissingFieldInEquatablePropsTestExceptionsCases extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = MissingFieldInEquatableProps();
    super.setUp();
  }

  /// Should not show a lint if a static variable is not in equatable props
  /// getter
  Future<void> test_case_1() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass();

  static const testStatic = false;

  @override
  List<Object?> get props => [];
}
''',
      [],
    );
  }

  /// Should allow a lint to be ignored if necessary
  Future<void> test_case_2() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass({this.field});

  // ignore: missing_field_in_equatable_props
  final String? field;

  @override
  List<Object?> get props => [];
}
''',
      [],
    );
  }

  /// Should not show a lint if a getter is not in equatable props getter
  Future<void> test_case_3() async {
    await assertDiagnostics(
      '''
import 'package:equatable/equatable.dart';

class EquatableTestClass extends Equatable {
  const EquatableTestClass();

  bool get testGetter => false;

  @override
  List<Object?> get props => [];
}
''',
      [],
    );
  }

  /// Should not show a lint if class is not extending Equatable
  Future<void> test_case_4() async {
    await assertDiagnostics(
      '''
class EquatableTestClass {
  const EquatableTestClass({this.field});

  final String? field;
}
''',
      [],
    );
  }

  /// Should show a lint even if no props field is present
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
          279,
          19,
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

@reflectiveTest
class MissingFieldInEquatablePropsTestSuperClassCases extends AnalysisRuleTest {
  @override
  void setUp() {
    setEquatablePackageMock();
    rule = MissingFieldInEquatableProps();
    super.setUp();
  }

  /// Should show a lint if a variable is not in equatable props variable
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
          282,
          22,
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
