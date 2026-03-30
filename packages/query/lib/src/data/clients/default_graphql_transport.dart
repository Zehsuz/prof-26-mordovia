import 'package:graphql/client.dart';

import 'graphql_transport.dart';

final class DefaultGraphqlTransport implements GraphqlTransport {
  final GraphQLClient _client;

  const DefaultGraphqlTransport({required GraphQLClient client})
    : _client = client;

  @override
  Future<QueryResult<Object?>> mutate({
    required String document,
    required String operationName,
    Map<String, dynamic> variables = const {},
  }) {
    return _client.mutate(
      MutationOptions(
        document: gql(document),
        operationName: operationName,
        variables: variables,
      ),
    );
  }

  @override
  Future<QueryResult<Object?>> query({
    required String document,
    required String operationName,
    Map<String, dynamic> variables = const {},
  }) {
    return _client.query(
      QueryOptions(
        document: gql(document),
        operationName: operationName,
        variables: variables,
      ),
    );
  }
}
