import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

/// Method to get all super class of a given class declaration
List<String> getAllExtendClassesAndMixins(ClassDeclaration node) {
  final nodeAllExtendClassesAndMixins = <String>[];

  final nodeSuperClass = node.extendsClause?.superclass;
  if (nodeSuperClass != null) {
    nodeAllExtendClassesAndMixins.add(nodeSuperClass.name.lexeme);

    final nodeClassElement = nodeSuperClass.element;
    if (nodeClassElement is ClassElement) {
      nodeAllExtendClassesAndMixins.addAll(
        nodeClassElement.allSupertypes
            .map((superType) => superType.getDisplayString())
            .toList(),
      );
    }
  }

  final nodeMixin = node.withClause;
  if (nodeMixin != null) {
    nodeAllExtendClassesAndMixins.addAll(
      nodeMixin.childEntities.whereType<NamedType>().map(
        (child) => child.name.lexeme,
      ),
    );
  }

  return nodeAllExtendClassesAndMixins;
}
