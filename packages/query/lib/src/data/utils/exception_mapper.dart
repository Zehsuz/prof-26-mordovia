import '../exceptions/data_exception.dart';

abstract interface class ExceptionMapper<E extends Object> {
  QueryException map(E error, {required String operation});
}
