import 'package:graphql/client.dart';

import '../exceptions/data_exception.dart';
import 'exception_mapper.dart';

abstract interface class GraphqlExceptionHandler
    implements ExceptionMapper<OperationException> {
  @override
  QueryException map(OperationException error, {required String operation});
}

final class DefaultGraphqlExceptionHandler implements GraphqlExceptionHandler {
  const DefaultGraphqlExceptionHandler();

  @override
  QueryException map(OperationException error, {required String operation}) {
    final linkException = error.linkException;

    if (linkException is NetworkException) {
      return QueryException(
        message: linkException.message ?? 'Network error while fetching data',
        operation: operation,
        cause: linkException,
      );
    }

    if (linkException is ServerException) {
      return QueryException(
        message: 'Server error while fetching data',
        operation: operation,
        cause: linkException,
      );
    }

    if (linkException is UnknownException) {
      return QueryException(
        message: 'Unknown client error while fetching data',
        operation: operation,
        cause: linkException,
      );
    }

    return QueryException(
      message: error.toString(),
      operation: operation,
      cause: error,
    );
  }
}
