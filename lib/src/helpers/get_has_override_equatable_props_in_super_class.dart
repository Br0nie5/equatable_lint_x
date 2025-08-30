import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';

/// Check if the superclass has override props or not
bool getHasOverrideEquatablePropsInSuperClass(
  InterfaceType classSuperType,
) {
  final listOfEquatableOverride = classSuperType.element3.getOverridden(
    Name(classSuperType.element3.library2.uri, equatablePropsFieldName),
  );
  if (listOfEquatableOverride != null && listOfEquatableOverride.isNotEmpty) {
    return true;
  }
  return false;
}
