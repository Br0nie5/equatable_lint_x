# equatable_lint_x

---

This package used the [analysis_server_plugin](https://github.com/dart-lang/sdk/tree/main/pkg/analysis_server_plugin) package.

---

## Table of content

- [Table of content](#table-of-content)
- [Setup local](#setup-local)
- [Setup CI](#setup-ci)
- [All the lints](#all-the-lints)
  - [missing\_field\_in\_equatable_props](#missing_field_in_equatable_props)
  - [always\_call\_super\_props\_when\_overriding\_equatable\_props](#always_call_super_props_when_overriding_equatable_props)
- [All the lints' fixes](#all-the-lints'-fixes)
  - [missing\_field\_in\_equatable_props fixes](#missing_field_in_equatable_props-fixes)
    - [Add every fields to equatable props](#add-every-fields-to-equatable-props)
    - [Add field to equatable props](#add-field-to-equatable-props)
    - [Create equatable props with every fields in it](#create-equatable-props-with-every-fields-in-it)
    - [Create equatable props with field in it](#create-equatable-props-with-field-in-it)
  - [always\_call\_super\_props\_when\_overriding\_equatable\_props fixes](#always_call_super_props_when_overriding_equatable_props-fixes)
    - [Call super in overridden equatable props](#call-super-in-overridden-equatable-props)
- [All the assists](#all-the-assists)
  - [Make class extend Equatable](#make-class-extend-Equatable)

## Setup local

- In your `pubspec.yaml`, add these `dev_dependencies`:

```yaml
dev_dependencies:
  equatable_lint_x:
```

- In your `analysis_options.yaml`, add this plugin:

```yaml
plugins:
  equatable_lint_x:

# Optional : Disable unwanted rules
plugins:
  equatable_lint_x:
    diagnostics:
        always_call_super_props_when_overriding_equatable_props: false
```

- Run `flutter pub get` or `dart pub get` in your package.

- Possibly restart your IDE.

## Setup CI

You will see the errors with the usual`flutter analyze` or `dart analyze` commands.

## To ignore a lint

To ignore one of this plugin rule, you need to add the plugin name before the lint code like this:

```dart
// ignore: equatable_lint_x/some_code

// ignore_for_file: equatable_lint_x/some_code
```

## All the lints

### missing_field_in_equatable_props

Class extending Equatable should put every fields into equatable props

**Good**:

```dart
class MyClass extends Equatable {
  const MyClass({this.myField});

  final String? myField;

  @override
  List<Object?> get props => [myField];
}
```

**Bad**:

```dart
class MyClass extends Equatable {
  const MyClass({this.myField});

  final String? myField;

  @override
  List<Object?> get props => [];
}
```

Class using EquatableMixin should put every fields into equatable props

**Good**:

```dart
class MyClass with EquatableMixin {
  const MyClass({this.myField});

  final String? myField;

  @override
  List<Object?> get props => [myField];
}
```

**Bad**:

```dart
class MyClass with EquatableMixin {
  const MyClass({this.myField});

  final String? myField;

  @override
  List<Object?> get props => [];
}
```

### always_call_super_props_when_overriding_equatable_props

Should always call super when overriding equatable props.

**Good**:

```dart
class MyClass extends RandomClassExtendingEquatable {
  const MyClass({this.newField});

  final String? newField;

  @override
  List<Object?> get props => super.props..addAll([newField]);
}
```

**Bad**:

```dart
class MyClass extends RandomClassExtendingEquatable {
  const MyClass({this.newField});

  final String? newField;

  @override
  List<Object?> get props => [newField];
}
```

## All the lints' fixes

### missing_field_in_equatable_props fixes

#### Add all fields to equatable props

![Add all fields to existing equatable props sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/add_all_fields_to_existing_equatable_props.gif)

#### Add field to equatable props

![Add field to existing equatable props sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/add_field_to_existing_equatable_props.gif)

#### Create equatable props with all fields

![Create equatable props with all fields sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/create_equatable_props_with_all_fields.gif)

#### Create equatable props with single field

![Create equatable props with single field sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/create_equatable_props_with_single_field.gif)

### always_call_super_props_when_overriding_equatable_props fixes

#### Call super in overridden equatable props

![Call super in overridden equatable props sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/call_super_in_overridden_equatable_props.gif)

## All the assists

### Make class extend Equatable

![Make class extend Equatable sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/make_class_extend_equatable.gif)

### Make class use EquatableMixin

![Make class use EquatableMixin sample](https://raw.githubusercontent.com/Br0nie5/equatable_lint_x/main/resources/make_class_use_equatable_mixin.gif)
