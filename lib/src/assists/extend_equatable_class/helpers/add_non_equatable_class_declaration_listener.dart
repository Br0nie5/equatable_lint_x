import 'package:analyzer/dart/ast/ast.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';

/// Extension to add a specific listener for non equatable class
extension AddNonEquatableClassDeclarationListener on LintRuleNodeRegistry {
  /// Getter to add a specific listener for non equatable class
  void addNonEquatableClassDeclaration(
    void Function({
      required ClassDeclaration classNode,
    }) listener,
  ) {
    addClassDeclaration((classNode) {
      final classElement = classNode.declaredElement;
      if (classElement == null) {
        return;
      }

      const typeChecker = TypeChecker.fromName(
        equatableClassName,
        packageName: equatablePackageName,
      );
      final classType = classElement.thisType;

      if (typeChecker.isAssignableFromType(classType)) {
        return;
      }

      listener(
        classNode: classNode,
      );
    });
  }
}
