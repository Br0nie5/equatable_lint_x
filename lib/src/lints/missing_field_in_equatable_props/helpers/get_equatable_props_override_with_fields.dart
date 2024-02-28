import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props/helpers/convert_fields_names_to_single_string.dart';

/// Helper to get a formatted string with the correct fields in it
/// Depending on whether your super class override equatable props
String getEquatablePropsOverrideWithFields({
  required List<String> fieldsNames,
  required bool hasOverrideEquatablePropsInSuperClass,
}) {
  const override = '\n\n\t@override';
  const equatablePropsGetterDefinition = '\n\tList<Object?> get props => ';

  final fieldsNamesPrefix =
      hasOverrideEquatablePropsInSuperClass ? 'super.props..addAll(' : '';
  final fieldsNamesSuffix = hasOverrideEquatablePropsInSuperClass ? ')' : '';

  const end = ';\n';

  final fieldsNamesSingleString = convertFieldsNamesToSingleString(fieldsNames);

  return override +
      equatablePropsGetterDefinition +
      fieldsNamesPrefix +
      fieldsNamesSingleString +
      fieldsNamesSuffix +
      end;
}
