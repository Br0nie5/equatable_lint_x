import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';

extension Mocks on AnalysisRuleTest {
  void setEquatablePackageMock() {
    final package = newPackage('equatable');
    package.addFile('lib/equatable.dart', '''
@immutable
abstract class Equatable {
  const Equatable();

  List<Object?> get props;
}

@immutable
mixin EquatableMixin {
  List<Object?> get props;
}
''');
  }
}
