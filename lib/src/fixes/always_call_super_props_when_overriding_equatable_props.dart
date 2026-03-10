import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/lints/always_call_super_props_when_overriding_equatable_props.dart';
import 'package:equatable_lint_x/src/utils/node_source_range_extension.dart';

/// Fix resolver for lint [AlwaysCallSuperPropsWhenOverridingEquatableProps].
/// Call super.props in the equatable props field or getter.
class CallSuperPropsWhenOverridingEquatableProps
    extends ResolvedCorrectionProducer {
  /// [CallSuperPropsWhenOverridingEquatableProps] constructor.
  CallSuperPropsWhenOverridingEquatableProps({required super.context});

  /// [FixKind] defined for [CallSuperPropsWhenOverridingEquatableProps.fixKind]
  static final fix = FixKind(
    AlwaysCallSuperPropsWhenOverridingEquatableProps.code.name,
    DartFixKindPriority.standard,
    '''Call super.${EquatableConst.propsFieldName} in the ${EquatableConst.packageName} ${EquatableConst.propsFieldName} field or getter.''',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;

    if (node is MethodDeclaration) {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addReplacement(node.sourceRange, (builder) {
          builder.write(
            node
                .toString()
                .replaceFirstMapped(
                  RegExp('(get ${EquatableConst.propsFieldName} => )(.*?);'),
                  (m) =>
                      '''get ${EquatableConst.propsFieldName} => super.${EquatableConst.propsFieldName}..addAll(${m[2]});''',
                )
                .replaceAll('@override ', '@override\n\t'),
          );
        });
      });
    } else if (node is FieldDeclaration) {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addReplacement(node.sourceRange, (builder) {
          builder.write(
            node
                .toString()
                .replaceFirstMapped(
                  RegExp('(${EquatableConst.propsFieldName} = )(.*?);'),
                  (m) =>
                      '''${EquatableConst.propsFieldName} = super.${EquatableConst.propsFieldName}..addAll(${m[2]});''',
                )
                .replaceAll('@override ', '@override\n\t'),
          );
        });
      });
    }
  }
}
