import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

/// Method to get all super class of a given class declaration
List<String> getAllSuperClasses(ClassDeclaration node) {
  final nodeSuperClass = node.extendsClause?.superclass;
  if (nodeSuperClass == null) {
    return [];
  }

  final nodeExtendedClassName = nodeSuperClass.name.lexeme;
  List<String>? nodeAllSuperClassNames;

  final nodeClassElement = nodeSuperClass.element;
  if (nodeClassElement is ClassElement) {
    nodeAllSuperClassNames = nodeClassElement.allSupertypes
        .map((superType) => superType.getDisplayString())
        .toList();
  }

  return [nodeExtendedClassName, ...?nodeAllSuperClassNames];
}
