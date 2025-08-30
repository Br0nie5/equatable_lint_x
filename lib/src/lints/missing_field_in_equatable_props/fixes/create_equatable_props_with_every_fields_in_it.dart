import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable_lint_x/src/helpers/get_has_override_equatable_props_in_super_class.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/helpers/add_equatable_class_field_declaration_listener.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/helpers/get_equatable_props_override_with_fields.dart';

/// DartFix to create missing equatable props with every fields in it
class CreateEquatablePropsWithEveryFieldsInIt extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addEquatableClassFieldDeclaration(
      ({
        required fieldNode,
        required fieldElement,
        required classNode,
        required watchableFields,
        required equatablePropsExpressionDetails,
      }) {
        if (equatablePropsExpressionDetails != null) {
          return;
        }

        final classSuperType = classNode.declaredFragment?.supertype;

        if (classSuperType == null) {
          return;
        }

        final fieldsToAdd =
            watchableFields.map((field) => field.displayName).toList();

        if (fieldsToAdd.equals([fieldElement.displayName])) {
          return;
        }

        final changeBuilder = reporter.createChangeBuilder(
          message: 'create equatable props override with every fields in it',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((dartFileEditBuilder) {
          dartFileEditBuilder.addSimpleReplacement(
            SourceRange(
              classNode.offset + classNode.length - 2,
              1,
            ),
            getEquatablePropsOverrideWithFields(
              fieldsNames:
                  watchableFields.map((field) => field.displayName).toList(),
              hasOverrideEquatablePropsInSuperClass:
                  getHasOverrideEquatablePropsInSuperClass(classSuperType),
            ),
          );
        });
      },
      optionalPreCheck: (fieldNode) {
        if (!fieldNode.sourceRange.intersects(analysisError.sourceRange)) {
          return false;
        }
        return true;
      },
    );
  }
}
