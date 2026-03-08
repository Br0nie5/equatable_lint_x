import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:collection/collection.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/utils/get_all_super_classes.dart';
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
    final nodeSuperClasses = getAllSuperClasses(node);
    if (!nodeSuperClasses.contains(EquatableConst.className)) {
      return;
    }

    final fieldsInEquatableProps = getEquatablePropsArrayElements(node);

    final variablesDeclaration = node.childEntities
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

    for (final variableDeclaration in variablesDeclaration) {
      if (!fieldsInEquatableProps.contains(variableDeclaration.name.lexeme)) {
        rule.reportAtNode(variableDeclaration.parent);
      }
    }
  }
}
