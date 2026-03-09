import 'package:equatable/equatable.dart';

class FieldNotInPropsGetterExample extends Equatable {
  const FieldNotInPropsGetterExample({this.field});

  // A lint will appear here because field is not in props getter
  final String? field;

  @override
  List<Object?> get props => [];
}

class SameLineFieldsNotInPropsGetterExample extends Equatable {
  const SameLineFieldsNotInPropsGetterExample({this.field1, this.field2});

  // A lint will appear here because field1 and/or field2 is not in props getter
  final String? field1, field2;

  @override
  List<Object?> get props => [];
}

class MultipleFieldsNotInPropsGetterExample extends Equatable {
  const MultipleFieldsNotInPropsGetterExample({this.field1, this.field2});

  // A lint will appear here because field1 is not in props getter
  final String? field1;

  // A lint will appear here because field2 is not in props getter
  final String? field2;

  @override
  List<Object?> get props => [];
}

class FieldNotInPropsGetterWithEquatableMixinExample with EquatableMixin {
  const FieldNotInPropsGetterWithEquatableMixinExample({this.field});

  final String? field;

  @override
  List<Object?> get props => [];
}
