import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/utils/get_all_extend_classes_and_mixins.dart';
import 'package:equatable_lint_x/src/utils/get_all_non_equatable_variables_from_class_declaration.dart';
import 'package:equatable_lint_x/src/utils/get_equatable_props_array_elements.dart';

/// [MissingFieldInEquatableProps] analysis rule that look for any class that
/// extend Equatable and don't put all its fiels inside the equatable props
/// field override.
class MissingFieldInEquatableProps extends AnalysisRule {
  /// [MissingFieldInEquatableProps] constructor.
  MissingFieldInEquatableProps()
    : super(name: code.name, description: code.problemMessage);

  /// [LintCode] defined for [MissingFieldInEquatableProps] rule.
  static const code = LintCode(
    '''missing_field_in_${EquatableConst.packageName}_${EquatableConst.propsFieldName}''',
    '''Dart class extending ${EquatableConst.className} must contain each field inside its ${EquatableConst.propsFieldName} field override.''',
    correctionMessage:
        '''You should add this field to the ${EquatableConst.packageName} ${EquatableConst.propsFieldName} field.''',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addClassDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final nodeAllExtendClassesAndMixin = getAllExtendClassesAndMixins(node);
    final doesExtendOrMixinEquatable =
        nodeAllExtendClassesAndMixin.contains(EquatableConst.className) ||
        nodeAllExtendClassesAndMixin.contains(EquatableConst.mixinName);
    if (!doesExtendOrMixinEquatable) {
      return;
    }

    final variablesNamesInEquatableProps = getEquatablePropsArrayElements(node);

    final variablesDeclaration =
        getAllNonEquatableVariablesFromClassDeclaration(node);

    for (final variableDeclaration in variablesDeclaration) {
      if (!variablesNamesInEquatableProps.contains(
        variableDeclaration.name.lexeme,
      )) {
        rule.reportAtNode(variableDeclaration);
      }
    }
  }
}
