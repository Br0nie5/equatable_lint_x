import 'package:analyzer/dart/ast/ast.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/utils/get_all_extend_classes_and_mixins.dart';

/// Method that returns wether this node directly extends Equatable or use
/// Equatable mixin
bool getHasDirectEquatableAncestor(ClassDeclaration node) {
  final isDirectlyExtendingEquatable =
      node.extendsClause?.superclass.name.lexeme == EquatableConst.className;

  final isDirectlyWithEquatable =
      node.withClause?.childEntities
          .where(
            (child) =>
                child is NamedType &&
                child.name.lexeme == EquatableConst.mixinName,
          )
          .isNotEmpty ??
      false;

  return isDirectlyExtendingEquatable || isDirectlyWithEquatable;
}

/// Method that returns wether this node has Equatable or Equatable mixin as an
/// ancestor
bool getHasEquatableAncestor(ClassDeclaration node) {
  final nodeAllExtendClassesAndMixin = getAllExtendClassesAndMixins(node);

  return nodeAllExtendClassesAndMixin.contains(EquatableConst.className) ||
      nodeAllExtendClassesAndMixin.contains(EquatableConst.mixinName);
}
