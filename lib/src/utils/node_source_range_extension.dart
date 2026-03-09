import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';

/// Extension to get a [SourceRange] from an [AstNode]
extension NodeSourceRange on AstNode {
  /// Getter to get a [SourceRange] from an [AstNode]
  SourceRange get sourceRange => SourceRange(offset, length);
}
