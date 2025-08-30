import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/helpers/add_equatable_class_field_declaration_listener.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/helpers/convert_fields_names_to_single_string.dart';

/// DartFix to add a missing field in equatable props
class AddFieldToEquatableProps extends DartFix {
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
        if (equatablePropsExpressionDetails == null) {
          return;
        }

        final changeBuilder = reporter.createChangeBuilder(
          message: 'add ${fieldElement.displayName} to equatable props',
          priority: 80,
        );

        changeBuilder.addDartFileEdit((dartFileEditBuilder) {
          dartFileEditBuilder.addSimpleReplacement(
            SourceRange(
              equatablePropsExpressionDetails.offset,
              equatablePropsExpressionDetails.length,
            ),
            equatablePropsExpressionDetails.initialPart +
                convertFieldsNamesToSingleString(
                  [
                    ...equatablePropsExpressionDetails.fieldsNames,
                    fieldElement.name3!,
                  ],
                ) +
                equatablePropsExpressionDetails.lastPart,
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
