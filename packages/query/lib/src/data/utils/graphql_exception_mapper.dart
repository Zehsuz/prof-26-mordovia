import 'package:graphql/client.dart';

import '../exceptions/data_exception.dart';

DataException mapGraphqlException(
  OperationException exception, {
  required String operation,
}) {
  final linkException = exception.linkException;

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
    message: exception.toString(),
    operation: operation,
    cause: exception,
  );
}
