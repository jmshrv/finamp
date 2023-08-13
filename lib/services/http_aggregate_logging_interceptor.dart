import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:finamp/services/chopper_aggregate_logger.dart';

final aggregateLogger = ChopperAggregateLogger();

/// A HttpLoggingInterceptor that aggregates the request and
/// response logs from Chopper, using the [ChopperAggregateLogger].
class HttpAggregateLoggingInterceptor extends HttpLoggingInterceptor {
  HttpAggregateLoggingInterceptor({level = Level.body})
      : super(level: level, logger: aggregateLogger);

  @override
  FutureOr<Request> onRequest(Request request) async {
    aggregateLogger.onStartRequest(request);
    final result = await super.onRequest(request);
    aggregateLogger.onEndRequest(request);
    return result;
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    aggregateLogger.onStartResponse(response);
    final result = super.onResponse(response);
    aggregateLogger.onEndResponse(response);
    return result;
  }
}
