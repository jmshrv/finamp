import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:finamp/services/chopper_aggregate_logger.dart';

final aggregateLogger = ChopperAggregateLogger();

/// A HttpLoggingInterceptor that aggregates the request and
/// response logs from Chopper, using the [ChopperAggregateLogger].
class HttpAggregateLoggingInterceptor extends HttpLoggingInterceptor {
  HttpAggregateLoggingInterceptor({super.level = Level.body})
      : super(logger: aggregateLogger);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    aggregateLogger.onStartRequest(chain.request);
    final Response<BodyType> response =
        await super.intercept(HttpAggregateLoggingChain(chain));
    // Request info isn't printed until after response completes
    aggregateLogger.onEndRequest(chain.request);
    aggregateLogger.onEndResponse(response);
    return response;
  }
}

class HttpAggregateLoggingChain<T> implements Chain<T> {
  HttpAggregateLoggingChain(this._chain);

  final Chain<T> _chain;

  @override
  FutureOr<Response<T>> proceed(Request request) async {
    var response = await _chain.proceed(request);
    aggregateLogger.onStartResponse(response);
    return response;
  }

  @override
  Request get request => _chain.request;
}
