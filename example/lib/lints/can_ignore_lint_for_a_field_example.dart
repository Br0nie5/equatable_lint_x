import 'package:equatable/equatable.dart';

class IgnoreOnePropExample extends Equatable {
  const IgnoreOnePropExample({this.ignoredField, this.nonIgnoredField});

  // With this ignore, no lint will be showed on ignoredField
  // ignore: equatable_lint_x/missing_field_in_equatable_props
  final String? ignoredField;

  final String? nonIgnoredField;

  @override
  List<Object?> get props => [];
}
