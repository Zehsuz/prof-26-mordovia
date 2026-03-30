import 'package:graphql/client.dart';

import '../exceptions/data_exception.dart';
import 'exception_mapper.dart';

abstract interface class GraphqlExceptionHandler
    implements ExceptionMapper<OperationException> {
  @override
  DataException map(OperationException error, {required String operation});
}

final class DefaultGraphqlExceptionHandler implements GraphqlExceptionHandler {
  const DefaultGraphqlExceptionHandler();

  @override
  DataException map(OperationException error, {required String operation}) {
    final linkException = error.linkException;

    if (linkException is NetworkException) {
      return DataException(
        message: linkException.message ?? 'Network error while fetching data',
        operation: operation,
        cause: linkException,
      );
    }

    if (linkException is ServerException) {
      return DataException(
        message: 'Server error while fetching data',
        operation: operation,
        cause: linkException,
      );
    }

    if (linkException is UnknownException) {
      return DataException(
        message: 'Unknown client error while fetching data',
        operation: operation,
        cause: linkException,
      );
    }

    return DataException(
      message: error.toString(),
      operation: operation,
      cause: error,
    );
  }
}
