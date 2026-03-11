import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/missing_field_in_equatable_props.dart';
import 'package:equatable_lint_x/src/utils/get_all_non_equatable_variables_from_class_declaration.dart';
import 'package:equatable_lint_x/src/utils/get_equatable_props_array_elements.dart';
import 'package:equatable_lint_x/src/utils/get_equatable_props_node.dart';
import 'package:equatable_lint_x/src/utils/has_equatable_ancestor.dart';
import 'package:equatable_lint_x/src/utils/node_source_range_extension.dart';

/// Fix resolver for lint [MissingFieldInEquatableProps].
/// Add the missing field in the equatable props field or getter.
/// Create the props getter with the missing field if it does not exist already.
class AddMissingFieldInEquatablePropsFix extends ResolvedCorrectionProducer {
  /// [AddMissingFieldInEquatablePropsFix] constructor.
  AddMissingFieldInEquatablePropsFix({required super.context});

  /// [FixKind] defined for [AddMissingFieldInEquatablePropsFix.fixKind].
  static final fix = FixKind(
    MissingFieldInEquatableProps.code.name,
    DartFixKindPriority.standard,
    '''Add the missing field inside the ${EquatableConst.packageName} ${EquatableConst.propsFieldName} field or getter.''',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! VariableDeclaration) {
      return;
    }

    final equatableClassDeclaration = node
        .thisOrAncestorOfType<ClassDeclaration>();
    if (equatableClassDeclaration == null) {
      return;
    }

    final variablesNamesInEquatableProps = getEquatablePropsArrayElements(
      equatableClassDeclaration,
    );

    await buildNewEquatablePropsFromMissingVariables(
      builder,
      node: node,
      allVariablesNeededInProps: [
        ...variablesNamesInEquatableProps,
        node.name.lexeme,
      ],
      equatableClassDeclaration: equatableClassDeclaration,
    );
  }
}

/// Fix resolver for lint [MissingFieldInEquatableProps].
/// Add all the missing fields in the equatable props field or getter.
/// Create the props getter with all the missing field if it does not exist
/// already.
class AddAllMissingFieldInEquatablePropsFix extends ResolvedCorrectionProducer {
  /// [AddAllMissingFieldInEquatablePropsFix] constructor.
  AddAllMissingFieldInEquatablePropsFix({required super.context});

  /// [FixKind] defined for [AddAllMissingFieldInEquatablePropsFix.fixKind].
  static final fix = FixKind(
    MissingFieldInEquatableProps.code.name,
    DartFixKindPriority.inFile,
    '''Add all the missing fields inside the ${EquatableConst.packageName} ${EquatableConst.propsFieldName} field or getter.''',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! VariableDeclaration) {
      return;
    }

    final equatableClassDeclaration = node
        .thisOrAncestorOfType<ClassDeclaration>();
    if (equatableClassDeclaration == null) {
      return;
    }

    final variablesNamesInEquatableProps = getEquatablePropsArrayElements(
      equatableClassDeclaration,
    );

    final missingVariablesNamesInProps =
        getAllNonEquatableVariablesFromClassDeclaration(
              equatableClassDeclaration,
            )
            .map((variable) => variable.name.lexeme)
            .where(
              (variableName) =>
                  !variablesNamesInEquatableProps.contains(variableName),
            )
            .toList();

    if (missingVariablesNamesInProps.length == 1) {
      // Early return:
      // There is already a lint fix to add a single field to props.
      return;
    }

    final allVariablesNeededInProps = [
      ...variablesNamesInEquatableProps,
      ...missingVariablesNamesInProps,
    ];

    await buildNewEquatablePropsFromMissingVariables(
      builder,
      node: node,
      allVariablesNeededInProps: allVariablesNeededInProps,
      equatableClassDeclaration: equatableClassDeclaration,
    );
  }
}

extension _AddMissingFieldInEquatablePropsFixExtension
    on ResolvedCorrectionProducer {
  Future<void> buildNewEquatablePropsFromMissingVariables(
    ChangeBuilder builder, {
    required VariableDeclaration node,
    required List<String> allVariablesNeededInProps,
    required ClassDeclaration equatableClassDeclaration,
  }) async {
    final allVariablesInPropsString =
        '[${allVariablesNeededInProps.join(', ')}]';

    final equatablePropsNode =
        getEquatablePropsGetterNode(equatableClassDeclaration) ??
        getEquatablePropsFieldNode(equatableClassDeclaration);

    if (equatablePropsNode != null) {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addReplacement(equatablePropsNode.sourceRange, (builder) {
          builder.write(
            equatablePropsNode
                .toString()
                .replaceAll(RegExp(r'\[[\s\S]*?\]'), allVariablesInPropsString)
                .replaceAll('@override ', '@override\n\t'),
          );
        });
      });
    } else {
      final hasEquatableDirectAncestor = getHasDirectEquatableAncestor(
        equatableClassDeclaration,
      );

      final propsValueString = hasEquatableDirectAncestor
          ? allVariablesInPropsString
          : '''super.${EquatableConst.propsFieldName}..addAll($allVariablesInPropsString)''';

      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addInsertion(equatableClassDeclaration.end - 1, (builder) {
          builder.write(
            '''\n\t@override\n\tList<Object?> get ${EquatableConst.propsFieldName} => $propsValueString;\n''',
          );
        });
      });
    }
  }
}
