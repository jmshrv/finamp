import 'package:finamp/services/contains_login.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'case_insensitive_pattern.dart';
import 'finamp_user_helper.dart';

extension CensoredMessage on LogRecord {
  /// The uncensored log string to be shown to the user
  String get logString =>
      "[$loggerName/${level.name}] $time: $message\n\n${stackTrace.toString()}";

  String get loginCensoredMessage => containsLogin ? "LOGIN BODY" : message;

  String get censoredMessage {
    if (containsLogin) {
      return loginCensoredMessage;
    }

    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    String workingLogString = logString;

    for (final user in finampUserHelper.finampUsers) {
      workingLogString = workingLogString.replaceAll(
          CaseInsensitivePattern(user.baseUrl), "BASEURL");
      workingLogString = workingLogString.replaceAll(
          CaseInsensitivePattern(user.accessToken), "TOKEN");
    }

    return workingLogString;
  }
}
