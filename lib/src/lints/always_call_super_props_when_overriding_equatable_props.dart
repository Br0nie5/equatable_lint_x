import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/utils/get_all_super_classes.dart';
import 'package:equatable_lint_x/src/utils/get_equatable_props_node.dart';

/// [AlwaysCallSuperPropsWhenOverridingEquatableProps] analysis rule that look
/// for any class that extend a class extending Equatable and don't call
/// super.props when overriding equatable props
class AlwaysCallSuperPropsWhenOverridingEquatableProps extends AnalysisRule {
  /// [AlwaysCallSuperPropsWhenOverridingEquatableProps] constructor.
  AlwaysCallSuperPropsWhenOverridingEquatableProps()
    : super(name: code.name, description: code.problemMessage);

  /// [LintCode] defined for [AlwaysCallSuperPropsWhenOverridingEquatableProps]
  /// rule.
  static const code = LintCode(
    '''always_call_super_${EquatableConst.propsFieldName}_when_overriding_${EquatableConst.packageName}_${EquatableConst.propsFieldName}''',
    '''Dart class extending a class that extend ${EquatableConst.className} should not forget to call super.${EquatableConst.propsFieldName} when overriding ${EquatableConst.packageName} ${EquatableConst.propsFieldName}.''',
    correctionMessage:
        '''You should add all your fields to the super.${EquatableConst.propsFieldName} array.''',
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
    final nodeExtendedClass = node.extendsClause?.superclass.name.lexeme;
    final nodeSuperClasses = getAllSuperClasses(node);

    if (nodeExtendedClass == EquatableConst.className ||
        !nodeSuperClasses.contains(EquatableConst.className)) {
      return;
    }

    final equatablePropsGetter = getEquatablePropsGetterNode(node);

    if (equatablePropsGetter != null &&
        !equatablePropsGetter.toString().contains(
          'super.${EquatableConst.propsFieldName}',
        )) {
      rule.reportAtNode(equatablePropsGetter);
    }

    final equatablePropsField = getEquatablePropsFieldNode(node);

    if (equatablePropsField != null &&
        !equatablePropsField.toString().contains(
          'super.${EquatableConst.propsFieldName}',
        )) {
      rule.reportAtNode(equatablePropsField);
    }
  }
}
