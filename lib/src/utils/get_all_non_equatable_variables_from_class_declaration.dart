import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';

/// Method to get all the [VariableDeclaration]s from a [ClassDeclaration]
List<VariableDeclaration> getAllNonEquatableVariablesFromClassDeclaration(
  ClassDeclaration node,
) => node.childEntities
    .whereType<FieldDeclaration>()
    .where((fieldDeclaration) => !fieldDeclaration.isStatic)
    .map(
      (fieldDeclaration) => fieldDeclaration.fields.childEntities
          .whereType<VariableDeclaration>()
          .where(
            (variableDeclaration) =>
                variableDeclaration.name.lexeme !=
                EquatableConst.propsFieldName,
          ),
    )
    .flattenedToList;
