import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:equatable_lint_x/src/utils/get_equatable_props_node.dart';
import 'package:equatable_lint_x/src/utils/parse_array_elements_from_string.dart';

/// Method to extract all elements inside the equatable class props array
List<String> getEquatablePropsArrayElements(ClassDeclaration node) {
  final equatablePropsGetterArrayElements = getEquatablePropsGetterNode(
    node,
  )?.childEntities.whereType<ExpressionFunctionBody>().firstOrNull;

  final equatablePropsVariableArrayElements = getEquatablePropsFieldNode(node)
      ?.childEntities
      .whereType<VariableDeclarationList>()
      .firstOrNull
      ?.childEntities
      .whereType<VariableDeclaration>()
      .firstOrNull;

  final equatablePropsArrayElements =
      equatablePropsGetterArrayElements ?? equatablePropsVariableArrayElements;

  if (equatablePropsArrayElements != null) {
    return parseArrayElementsFromString(equatablePropsArrayElements.toString());
  }

  return [];
}
