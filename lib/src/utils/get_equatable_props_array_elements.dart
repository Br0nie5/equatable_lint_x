import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:equatable_lint_x/src/utils/get_equatable_props_node.dart';
import 'package:equatable_lint_x/src/utils/parse_array_elements_from_string.dart';

/// Method to extract all elements inside the equatable class props array
List<String> getEquatablePropsArrayElements(ClassDeclaration node) {
  final equatablePropsGetterArrayElements = getEquatablePropsGetterNode(
    node,
  )?.childEntities.whereType<ExpressionFunctionBody>().firstOrNull;

  if (equatablePropsGetterArrayElements != null) {
    return parseArrayElementsFromString(
      equatablePropsGetterArrayElements.toString(),
    );
  }

  final equatablePropsVariableArrayElements = getEquatablePropsFieldNode(node)
      ?.childEntities
      .whereType<VariableDeclarationList>()
      .firstOrNull
      ?.childEntities
      .whereType<VariableDeclaration>()
      .firstOrNull;

  if (equatablePropsVariableArrayElements != null) {
    return parseArrayElementsFromString(
      equatablePropsVariableArrayElements.toString(),
    );
  }

  return [];
}
