import 'package:analyzer/source/source_range.dart';

/// Allow to select a [SourceRange] by giving start and end indexes instead of
/// start and length
SourceRange sourceRangeFrom({required int start, required int end}) =>
    SourceRange(start, end - start);
