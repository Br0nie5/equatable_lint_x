/// Take every fields names and concatenate them in a single string
String convertFieldsNamesToSingleString(List<String> fieldsNames) {
  final fieldsString = fieldsNames.fold(
    '[',
    (previousValue, fieldName) => '$previousValue $fieldName,',
  );
  return '$fieldsString ]';
}
