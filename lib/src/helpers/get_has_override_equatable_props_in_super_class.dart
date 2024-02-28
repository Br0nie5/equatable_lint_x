import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';

/// Check if the superclass has override props or not
bool getHasOverrideEquatablePropsInSuperClass(
  InterfaceElement superClassElement,
) {
  final equatablePropsAccessorElement =
      superClassElement.accessors.firstWhereOrNull(
    (accessor) =>
        accessor.hasOverride &&
        accessor.isGetter &&
        accessor.name == equatablePropsFieldName,
  );
  if (equatablePropsAccessorElement != null) {
    return true;
  }

  final equatablePropsFieldElement = superClassElement.fields.firstWhereOrNull(
    (field) => field.hasOverride && field.name == equatablePropsFieldName,
  );
  return equatablePropsFieldElement != null;
}
