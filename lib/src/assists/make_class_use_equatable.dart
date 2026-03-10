import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/utils/get_all_non_equatable_variables_from_class_declaration.dart';
import 'package:equatable_lint_x/src/utils/has_equatable_ancestor.dart';

/// Assist resolver that make a non Equatable class extend Equatable.
class MakeClassExtendEquatable extends ResolvedCorrectionProducer {
  /// [MakeClassExtendEquatable] constructor.
  MakeClassExtendEquatable({required super.context});

  @override
  AssistKind get assistKind => const AssistKind(
    'make_class_extends_${EquatableConst.packageName}',
    50,
    'Make class extends ${EquatableConst.className}',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! ClassDeclaration) {
      return;
    }

    final hasEquatableAncestor = getHasEquatableAncestor(node);

    if (hasEquatableAncestor) {
      return;
    }

    final isClassAlreadyExtendingSomething = node.extendsClause != null;

    if (isClassAlreadyExtendingSomething) {
      return;
    }

    await addEquatableImportConditionally(builder);

    await builder.addDartFileEdit(file, (fileBuilder) {
      fileBuilder.addInsertion(node.name.end, (builder) {
        builder.write(' extends ${EquatableConst.className}');
      });
    });

    await addEquatablePropsGetter(builder, node: node);
  }
}

/// Assist resolver that make a non Equatable class use EquatableMixin.
class MakeClassWithEquatableMixin extends ResolvedCorrectionProducer {
  /// [MakeClassWithEquatableMixin] constructor.
  MakeClassWithEquatableMixin({required super.context});

  @override
  AssistKind get assistKind => const AssistKind(
    'make_class_with_${EquatableConst.packageName}_mixin',
    50,
    'Make class use ${EquatableConst.mixinName}',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! ClassDeclaration) {
      return;
    }

    final hasEquatableAncestor = getHasEquatableAncestor(node);

    if (hasEquatableAncestor) {
      return;
    }

    await addEquatableImportConditionally(builder);

    final classWithClause = node.withClause;

    if (classWithClause != null) {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addInsertion(classWithClause.end, (builder) {
          builder.write(', ${EquatableConst.mixinName}');
        });
      });

      await addEquatablePropsGetter(builder, node: node);

      return;
    }

    final classExtendsClause = node.extendsClause;

    if (classExtendsClause == null) {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addInsertion(node.name.end, (builder) {
          builder.write(' with ${EquatableConst.mixinName}');
        });
      });

      await addEquatablePropsGetter(builder, node: node);
    } else {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addInsertion(classExtendsClause.end, (builder) {
          builder.write(' with ${EquatableConst.mixinName}');
        });
      });

      await addEquatablePropsGetter(builder, node: node);
    }
  }
}

extension _MakeClassUseEquatable on ResolvedCorrectionProducer {
  Future<void> addEquatableImportConditionally(ChangeBuilder builder) async {
    final node = this.node;

    final allImportsDirectives = node.root.childEntities
        .whereType<ImportDirective>()
        .toList();

    final isEquatablePackageAlreadyImported = allImportsDirectives
        .where(
          (importDirective) =>
              importDirective.libraryImport?.importedLibrary?.identifier ==
              EquatableConst.packageIdentifier,
        )
        .isNotEmpty;

    if (isEquatablePackageAlreadyImported) {
      return;
    }

    final lastImportDirective = allImportsDirectives.lastOrNull;

    if (lastImportDirective != null) {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addInsertion(lastImportDirective.end, (builder) {
          builder.write("\nimport '${EquatableConst.packageIdentifier}';");
        });
      });
    } else {
      await builder.addDartFileEdit(file, (fileBuilder) {
        fileBuilder.addReplacement(SourceRange.EMPTY, (builder) {
          builder.write("import '${EquatableConst.packageIdentifier}';\n\n");
        });
        fileBuilder.addInsertion(0, (builder) {
          builder.write("import '${EquatableConst.packageIdentifier}';\n\n");
        });
      });
    }
  }

  Future<void> addEquatablePropsGetter(
    ChangeBuilder builder, {
    required ClassDeclaration node,
  }) async {
    final allClassVariables = getAllNonEquatableVariablesFromClassDeclaration(
      node,
    ).map((variable) => variable.name.lexeme);

    await builder.addDartFileEdit(file, (fileBuilder) {
      fileBuilder.addInsertion(node.end - 1, (builder) {
        builder.write(
          '''\n\t@override\n\tList<Object?> get ${EquatableConst.propsFieldName} => [${allClassVariables.join(', ')}];\n''',
        );
      });
    });
  }
}
