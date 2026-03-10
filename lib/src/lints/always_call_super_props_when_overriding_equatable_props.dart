import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/utils/get_all_extend_classes_and_mixins.dart';
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
    '''Dart class extending a class that extends ${EquatableConst.className} should not forget to call super.${EquatableConst.propsFieldName} when overriding ${EquatableConst.packageName} ${EquatableConst.propsFieldName}.''',
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
    final isDirectlyExtendingEquatable =
        node.extendsClause?.superclass.name.lexeme == EquatableConst.className;

    final isDirectlyWithEquatableMixin =
        node.withClause?.childEntities
            .where(
              (child) =>
                  child is NamedType &&
                  child.name.lexeme == EquatableConst.mixinName,
            )
            .isNotEmpty ??
        false;

    final isDirectlyExtendingOrMixinEquatable =
        isDirectlyExtendingEquatable || isDirectlyWithEquatableMixin;

    final nodeAllExtendClassesAndMixins = getAllExtendClassesAndMixins(node);

    final superClassDoesExtendOrMixinEquatable =
        nodeAllExtendClassesAndMixins.contains(EquatableConst.className) ||
        nodeAllExtendClassesAndMixins.contains(EquatableConst.mixinName);

    if (isDirectlyExtendingOrMixinEquatable ||
        !superClassDoesExtendOrMixinEquatable) {
      return;
    }

    final equatablePropsNode =
        getEquatablePropsGetterNode(node) ?? getEquatablePropsFieldNode(node);

    if (equatablePropsNode != null &&
        !equatablePropsNode.toString().contains(
          'super.${EquatableConst.propsFieldName}',
        )) {
      rule.reportAtNode(equatablePropsNode);
    }
  }
}
