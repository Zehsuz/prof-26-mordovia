import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:query/query.dart';
import 'package:test/test.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

class FakeMutationOptions extends Fake implements MutationOptions<Object?> {}

class FakeQueryOptions extends Fake implements QueryOptions<Object?> {}

final gameRequest = GameRequest(
  category: 'Image',
  scheduledAt: DateTime.parse('2026-03-29T10:00:00.000Z'),
  isFinished: false,
);

final gameResponse = GameResponse(
  id: 'game-id',
  category: 'Image',
  scheduledAt: DateTime.parse('2026-03-29T10:00:00.000Z'),
  isFinished: false,
);

QueryResult<Object?> graphqlResult({
  Map<String, dynamic>? data,
  OperationException? exception,
}) {
  return QueryResult(
    options: QueryOptions(document: gql('query Test { __typename }')),
    source: QueryResultSource.network,
    data: data,
    exception: exception,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMutationOptions());
    registerFallbackValue(FakeQueryOptions());
  });

  group('QueryGraphqlClient', () {
    late MockGraphQLClient graphQLClient;
    late QueryGraphqlClient client;

    setUp(() {
      graphQLClient = MockGraphQLClient();
      client = QueryGraphqlClient(client: graphQLClient);
    });

    test('createGame', () async {
      when(() => graphQLClient.mutate(any())).thenAnswer(
        (_) async => graphqlResult(
          data: {
            'insertIntogamesCollection': {
              'records': [
                {
                  'id': 'game-id',
                  'category': 'Image',
                  'scheduled_at': '2026-03-29T10:00:00.000Z',
                  'is_finished': false,
                },
              ],
            },
          },
        ),
      );

      final response = await client.createGame(gameRequest);

      expect(response, gameResponse);

      final captured =
          verify(() => graphQLClient.mutate(captureAny())).captured.single
              as MutationOptions<Object?>;
      expect(captured.operationName, 'CreateGame');
      expect(captured.variables, {
        'category': 'Image',
        'scheduledAt': '2026-03-29T10:00:00.000Z',
        'isFinished': false,
      });
    });

    test('getGameById', () async {
      when(() => graphQLClient.query(any())).thenAnswer(
        (_) async => graphqlResult(
          data: {
            'gamesCollection': {
              'edges': [
                {
                  'node': {
                    'id': 'game-id',
                    'category': 'Image',
                    'scheduled_at': '2026-03-29T10:00:00.000Z',
                    'is_finished': false,
                  },
                },
              ],
            },
          },
        ),
      );

      final response = await client.getGameById('game-id');

      expect(response, gameResponse);

      final captured =
          verify(() => graphQLClient.query(captureAny())).captured.single
              as QueryOptions<Object?>;
      expect(captured.operationName, 'GetGameById');
      expect(captured.variables, {'id': 'game-id'});
    });

    test('getGameById returns null when game is absent', () async {
      when(() => graphQLClient.query(any())).thenAnswer(
        (_) async => graphqlResult(
          data: {
            'gamesCollection': {'edges': []},
          },
        ),
      );

      final response = await client.getGameById('missing-game-id');

      expect(response, isNull);
    });

    test('createGame maps graphql exception', () async {
      when(() => graphQLClient.mutate(any())).thenAnswer(
        (_) async => graphqlResult(
          exception: OperationException(
            graphqlErrors: [const GraphQLError(message: 'mutation failed')],
          ),
        ),
      );

      expect(
        () => client.createGame(gameRequest),
        throwsA(
          isA<DataException>().having(
            (error) => error.operation,
            'operation',
            'createGame',
          ),
        ),
      );
    });

    test('getGameById maps graphql exception', () async {
      when(() => graphQLClient.query(any())).thenAnswer(
        (_) async => graphqlResult(
          exception: OperationException(
            graphqlErrors: [const GraphQLError(message: 'query failed')],
          ),
        ),
      );

      expect(
        () => client.getGameById('game-id'),
        throwsA(
          isA<DataException>().having(
            (error) => error.operation,
            'operation',
            'getGameById',
          ),
        ),
      );
    });
  });
}
