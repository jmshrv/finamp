import 'package:finamp/services/contains_login.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'case_insensitive_pattern.dart';
import 'finamp_user_helper.dart';

extension CensoredMessage on LogRecord {
  /// The uncensored log string to be shown to the user
  String get logString =>
      "[$loggerName/${level.name}] $time: $message${stackTrace == null ? "" : "\n${stackTrace.toString()}"}";

  String get loginCensoredMessage => containsLogin ? "LOGIN BODY" : message;

  String get censoredMessage {
    if (containsLogin) {
      return loginCensoredMessage;
    }

    String workingLogString = logString;

    if (GetIt.instance.isRegistered<JellyfinApiHelper>()) {
      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

      if (jellyfinApiHelper.baseUrlTemp != null) {
        // Replace the temporary base URL with BASEURL
        final tempUriMatcher = jellyfinApiHelper.baseUrlTemp!;
        tempUriMatcher.replace(
            scheme:
                ""); // don't replace the scheme, it might be important for diagnosing issues
        workingLogString = workingLogString.replaceAll(
            CaseInsensitivePattern(tempUriMatcher.toString()), "TEMP_BASEURL");

        // remove anything between the quotes in "Failed host lookup: ''"
        workingLogString = workingLogString.replaceAll(
            CaseInsensitivePattern(tempUriMatcher.host.toString()),
            "TEMP_HOST");
      }
    }

    // If userHelper is not initialized, calling code cannot have used baseurl/token
    // so skipping censoring is fine.
    if (GetIt.instance.isRegistered<FinampUserHelper>()) {
      final finampUserHelper = GetIt.instance<FinampUserHelper>();

      for (final user in finampUserHelper.finampUsers) {
        workingLogString = workingLogString.replaceAll(
            CaseInsensitivePattern(user.baseUrl), "BASEURL");
        workingLogString = workingLogString.replaceAll(
            CaseInsensitivePattern(user.baseUrl), "BASEURL");
        workingLogString = workingLogString.replaceAll(
            CaseInsensitivePattern(user.accessToken), "TOKEN");
      }
    }

    workingLogString = workingLogString.replaceAll("\n", "\n\t\t");

    return workingLogString;
  }
}
