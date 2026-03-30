import 'package:graphql/client.dart';

abstract interface class GraphqlTransport {
  Future<QueryResult<Object?>> query({
    required String document,
    required String operationName,
    Map<String, dynamic> variables = const {},
  });

  Future<QueryResult<Object?>> mutate({
    required String document,
    required String operationName,
    Map<String, dynamic> variables = const {},
  });
}
