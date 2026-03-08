import 'package:collection/collection.dart';

/// Function that take a string as an [input] then parse it to find any array
/// inside it in order to return a list of all of these arrays' elements
List<String> parseArrayElementsFromString(String input) {
  // Extract content between [ and ]
  final matches = RegExp(r'\[([^\]]*)\]', dotAll: true).allMatches(input);
  if (matches.isEmpty) {
    return [];
  }

  final contents = matches
      .map((match) => match.group(1)!.trim())
      .where((content) => content.isNotEmpty)
      .toList();

  return contents
      .map(
        (content) => content
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      )
      .flattenedToList;
}
