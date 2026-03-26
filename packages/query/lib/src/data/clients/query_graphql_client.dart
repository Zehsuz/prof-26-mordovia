import 'package:graphql/client.dart';

import '../models/character.dart';
import '../exceptions/data_exception.dart';
import '../utils/graphql_exception_mapper.dart';

class QueryGraphqlClient {
  final GraphQLClient _client;

  QueryGraphqlClient({
    required String url,
    Map<String, String> defaultHeaders = const {},
  }) : _client = GraphQLClient(
         link: HttpLink(url, defaultHeaders: defaultHeaders),
         cache: GraphQLCache(),
       );

  Future<List<CharacterDto>> allCharacters() async {
    const query = r'''
      {
        charactersCollection(first: 100) {
          edges {
            node {
              id
              name
              gender
              image
              status
            }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw mapGraphqlException(result.exception!, operation: 'allCharacters');
    }

    final edges =
        result.data?['charactersCollection']?['edges'] as List<dynamic>?;
    if (edges == null) {
      throw const DataException(
        message: 'Response does not contain charactersCollection.edges',
        operation: 'allCharacters',
      );
    }

    return edges.map((raw) => CharacterDto.fromJson(raw['node'])).toList();
  }
}
