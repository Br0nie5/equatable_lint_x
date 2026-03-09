import 'package:equatable/equatable.dart';

class EquatableSuperClassBase extends Equatable {
  const EquatableSuperClassBase({this.field});

  final String? field;

  @override
  List<Object?> get props => [field];
}

class NeedToCallSuperWhenOverridingPropsSuperClassExample
    extends EquatableSuperClassBase {
  NeedToCallSuperWhenOverridingPropsSuperClassExample({this.newField});

  final String? newField;

  // A lint will appear here because props don't call super.props
  @override
  late final List<Object?> props = [newField];
}

class EquatableSuperMixinBase with EquatableMixin {
  const EquatableSuperMixinBase({this.field});

  final String? field;

  @override
  List<Object?> get props => [field];
}

class NoLintOnGetterSuperClassMixinExample extends EquatableSuperMixinBase {
  const NoLintOnGetterSuperClassMixinExample({this.newField});

  final String? newField;

  // A lint will appear here because props don't call super.props
  @override
  List<Object?> get props => [newField];
}
