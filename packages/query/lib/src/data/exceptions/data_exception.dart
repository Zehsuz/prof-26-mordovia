class QueryException implements Exception {
  final String message;
  final String operation;
  final Object? cause;

  const QueryException({
    required this.message,
    required this.operation,
    this.cause,
  });

  @override
  String toString() {
    final buffer = StringBuffer(
      'DataException(message: $message, operation: $operation',
    );

    if (cause != null) {
      buffer.write(', cause: $cause');
    }

    buffer.write(')');
    return buffer.toString();
  }
}
