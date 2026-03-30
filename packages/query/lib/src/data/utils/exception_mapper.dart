import '../exceptions/data_exception.dart';

abstract interface class ExceptionMapper<E extends Object> {
  DataException map(E error, {required String operation});
}
