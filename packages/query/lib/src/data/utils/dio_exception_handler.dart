import 'package:dio/dio.dart';

import '../exceptions/data_exception.dart';
import 'exception_mapper.dart';

abstract interface class DioExceptionHandler
    implements ExceptionMapper<DioException> {
  @override
  QueryException map(DioException error, {required String operation});
}

final class DefaultDioExceptionHandler implements DioExceptionHandler {
  const DefaultDioExceptionHandler();

  @override
  QueryException map(DioException error, {required String operation}) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message =
          responseData['msg'] ??
          responseData['message'] ??
          responseData['error_description'] ??
          responseData['error'];

      if (message is String && message.isNotEmpty) {
        return QueryException(
          message: message,
          operation: operation,
          cause: error,
        );
      }
    }

    return QueryException(
      message: error.message ?? 'Network error while fetching data',
      operation: operation,
      cause: error,
    );
  }
}
