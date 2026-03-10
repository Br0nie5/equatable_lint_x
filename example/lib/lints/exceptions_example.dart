import 'package:equatable/equatable.dart';

// Should not show any lint or fixes for this class
class NotEquatableClass {
  const NotEquatableClass({this.field});

  final String? field;
}

class IgnoreFieldExample extends Equatable {
  const IgnoreFieldExample({this.ignoredField});

  // With this ignore, no lint will be showed on ignoredField even if it's not
  // in props
  // ignore: equatable_lint_x/missing_field_in_equatable_props
  final String? ignoredField;

  @override
  List<Object?> get props => [];
}

class NoLintOnGetterExample extends Equatable {
  const NoLintOnGetterExample();

  bool get testGetter => false;

  @override
  List<Object?> get props => [];
}

class NoLintOnStaticVariableExample extends Equatable {
  const NoLintOnStaticVariableExample();

  static const testStatic = false;

  @override
  List<Object?> get props => [];
}

class EquatableSuperClassBase extends Equatable {
  const EquatableSuperClassBase();

  @override
  List<Object?> get props => [];
}

class FieldNotInPropsNoPropsExample extends EquatableSuperClassBase {
  const FieldNotInPropsNoPropsExample({this.field});

  // A lint will appear here because field is not in props even if props is not
  // defined
  final String? field;
}
