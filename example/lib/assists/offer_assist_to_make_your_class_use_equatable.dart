// Should show an assist to make this class extends Equatable or with
// EquatableMixin
class NonEquatableClass {
  const NonEquatableClass({this.field});

  final String? field;
}

class TempExtends {
  const TempExtends();
}

// Should show an assist to make this class with EquatableMixin
class NonEquatableAlreadyExtendingClass extends TempExtends {
  const NonEquatableAlreadyExtendingClass({this.field});

  final String? field;
}

mixin TempMixin {}

// Should show an assist to make this class extends Equatable or with
// EquatableMixin
class NonEquatableAlreadyWithMixinClass with TempMixin {
  const NonEquatableAlreadyWithMixinClass({this.field});

  final String? field;
}
