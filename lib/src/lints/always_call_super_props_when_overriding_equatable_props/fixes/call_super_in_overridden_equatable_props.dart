import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable_lint_x/src/lints/always_call_super_props_when_overriding_equatable_props/helpers/add_equatable_super_class_declaration_listener.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/helpers/convert_fields_names_to_single_string.dart';

/// DartFix to always call super props when overriding equatable props
class CallSuperInOverriddenEquatableProps extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addEquatableSuperClassDeclaration(
      ({
        required classNode,
        required equatablePropsClassMember,
        required equatablePropsExpressionDetails,
      }) {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'call super in overridden equatable props',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((dartFileEditBuilder) {
          dartFileEditBuilder.addSimpleReplacement(
            SourceRange(
              equatablePropsExpressionDetails.offset,
              equatablePropsExpressionDetails.length,
            ),
            '''
${equatablePropsExpressionDetails.initialPart}super.props..addAll(${convertFieldsNamesToSingleString(
              equatablePropsExpressionDetails.fieldsNames,
            )})${equatablePropsExpressionDetails.lastPart}''',
          );
        });
      },
      optionalPreCheck: (classNode) {
        if (!classNode.sourceRange.intersects(analysisError.sourceRange)) {
          return false;
        }
        return true;
      },
    );
  }
}
