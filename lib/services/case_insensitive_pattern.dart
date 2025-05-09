/// A pattern for case-insensitive matching. Used when sanitising logs as
/// Chopper logs the base URL in lowercase.
class CaseInsensitivePattern implements Pattern {
  late String matcher;

  CaseInsensitivePattern(String matcher) {
    this.matcher = matcher.toLowerCase();
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    if (matcher.isEmpty) return [];
    return matcher.allMatches(string.toLowerCase(), start);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    if (matcher.isEmpty) return null;
    return matcher.matchAsPrefix(string.toLowerCase(), start);
  }
}
