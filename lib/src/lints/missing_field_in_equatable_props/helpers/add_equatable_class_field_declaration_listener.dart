import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/helpers/get_equatable_props_expression_infos.dart';

/// Extension to add a specific listener for equatable class fields
extension AddEquatableClassFieldDeclarationListener on LintRuleNodeRegistry {
  /// Getter to add a specific listener for equatable class fields
  void addEquatableClassFieldDeclaration(
    void Function({
      required FieldDeclaration fieldNode,
      required FieldElement fieldElement,
      required ClassDeclaration classNode,
      required List<FieldElement> watchableFields,
      required EquatablePropsExpressionDetails? equatablePropsExpressionDetails,
    })
        listener, {
    bool Function(FieldDeclaration)? optionalPreCheck,
  }) {
    addFieldDeclaration((fieldNode) {
      if (optionalPreCheck != null) {
        final canContinue = optionalPreCheck(fieldNode);
        if (!canContinue) {
          return;
        }
      }

      final classNode = fieldNode.parent;

      if (classNode is! ClassDeclaration) {
        return;
      }

      final classElement = classNode.declaredElement;
      if (classElement == null) {
        return;
      }

      const typeChecker = TypeChecker.fromName(
        equatableClassName,
        packageName: equatablePackageName,
      );
      final classType = classElement.thisType;

      if (!typeChecker.isAssignableFromType(classType)) {
        return;
      }

      final watchableFields = classElement.fields
          .where((field) => !field.isSynthetic)
          .where((field) => !field.isStatic)
          .where((field) => field.displayName != equatablePropsFieldName)
          .toList();

      final fieldElement = watchableFields.firstWhereOrNull(
        (field) =>
            fieldNode.toString().contains('$field ') ||
            fieldNode.toString().contains('$field;'),
      );

      if (fieldElement == null) {
        return;
      }

      final equatablePropsExpressionDetails =
          classNode.equatablePropsExpressionDetails;

      listener(
        fieldNode: fieldNode,
        fieldElement: fieldElement,
        classNode: classNode,
        watchableFields: watchableFields,
        equatablePropsExpressionDetails: equatablePropsExpressionDetails,
      );
    });
  }
}
