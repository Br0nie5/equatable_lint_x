import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable_lint_x/src/assists/extend_equatable_class/helpers/add_non_equatable_class_declaration_listener.dart';
import 'package:equatable_lint_x/src/constants/equatable_constants.dart';
import 'package:equatable_lint_x/src/helpers/source_range_from.dart';

/// Assist to make class extends Equatable if needed
class ExtendEquatableClass extends DartAssist {
  /// [ExtendEquatableClass] constructor
  ExtendEquatableClass();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addNonEquatableClassDeclaration(({
      required classNode,
    }) {
      final classHeading = sourceRangeFrom(
        start: classNode.classKeyword.offset,
        end: classNode.leftBracket.offset,
      );

      if (!classHeading.intersects(target)) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Extend $equatableClassName class',
        priority: 90,
      );

      changeBuilder.addDartFileEdit((dartFileEditBuilder) {
        dartFileEditBuilder.importLibrary(
          Uri.parse('package:$equatablePackageName/$equatablePackageName.dart'),
        );

        dartFileEditBuilder.addSimpleReplacement(
          SourceRange(
            classNode.name.offset,
            classNode.name.length,
          ),
          '${classNode.name} extends $equatableClassName',
        );

        dartFileEditBuilder.addSimpleReplacement(
          SourceRange(
            classNode.offset + classNode.length - 1,
            classNode.offset + classNode.length - 1,
          ),
          '''\n\t@override\n\tList<Object?> get $equatablePropsFieldName => [];\n}''',
        );
      });
    });
  }
}
