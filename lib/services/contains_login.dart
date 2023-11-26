import 'package:logging/logging.dart';

extension ContainsLogin on LogRecord {
  /// Whether or not the log record contains the user's login details.
  bool get containsLogin => message.contains('{"Username');
}
