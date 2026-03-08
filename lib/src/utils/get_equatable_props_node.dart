import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';

/// Method to get the equatable props getter node
MethodDeclaration? getEquatablePropsGetterNode(ClassDeclaration node) =>
    node.childEntities.whereType<MethodDeclaration>().firstWhereOrNull(
      (methodDeclaration) =>
          methodDeclaration.name.lexeme == EquatableConst.propsFieldName,
    );

/// Method to get the equatable props field node
FieldDeclaration? getEquatablePropsFieldNode(ClassDeclaration node) =>
    node.childEntities.whereType<FieldDeclaration>().where((fieldDeclaration) {
      final variableDeclarationList = fieldDeclaration.childEntities
          .whereType<VariableDeclarationList>()
          .firstOrNull;
      if (variableDeclarationList == null) {
        return false;
      }

      final variableDeclaration = variableDeclarationList.childEntities
          .whereType<VariableDeclaration>()
          .firstOrNull;
      if (variableDeclaration == null) {
        return false;
      }

      if (variableDeclaration.name.lexeme != EquatableConst.propsFieldName) {
        return false;
      }

      return true;
    }).firstOrNull;
