import 'package:equatable/equatable.dart';

class FieldNotInPropsFieldExample extends Equatable {
  FieldNotInPropsFieldExample({this.field});

  // A lint will appear here because field is not in props field
  final String? field;

  @override
  late final List<Object?> props = [];
}

class SameLineFieldsNotInPropsFieldExample extends Equatable {
  SameLineFieldsNotInPropsFieldExample({this.field1, this.field2});

  // A lint will appear here because field1 and/or field2 is not in props field
  final String? field1, field2;

  @override
  late final List<Object?> props = [];
}

class MultipleFieldsNotInPropsFieldExample extends Equatable {
  MultipleFieldsNotInPropsFieldExample({this.field1, this.field2});

  // A lint will appear here because field1 is not in props field
  final String? field1;

  // A lint will appear here because field2 is not in props field
  final String? field2;

  @override
  late final List<Object?> props = [];
}

class FieldNotInPropsFieldWithEquatableMixinExample with EquatableMixin {
  FieldNotInPropsFieldWithEquatableMixinExample({this.field});

  final String? field;

  @override
  late final List<Object?> props = [];
}
