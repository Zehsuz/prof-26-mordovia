import 'package:graphql/client.dart';
import 'package:logging_helper/logging_helper.dart';

import '../exceptions/data_exception.dart';
import '../models/models.dart';
import '../utils/graphql_exception_mapper.dart';

class QueryGraphqlClient with CustomLogger {
  final GraphQLClient _client;

  const QueryGraphqlClient({required GraphQLClient client}) : _client = client;

  Future<GameResponse> createGame(GameRequest game) async {
    logInfo(
      'Начало createGame для category=${game.category}, scheduledAt=${game.scheduledAt.toIso8601String()}',
    );
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(_createGameMutation),
          operationName: 'CreateGame',
          variables: {
            'category': game.category,
            'scheduledAt': game.scheduledAt.toIso8601String(),
            'isFinished': game.isFinished,
          },
        ),
      );

      if (result.hasException) {
        final exception = mapGraphqlException(
          result.exception!,
          operation: 'createGame',
        );
        logError(
          'createGame завершился с ${result.exception.runtimeType}: ${exception.message}',
        );
        throw exception;
      }

      final records =
          result.data?['insertIntogamesCollection']?['records']
              as List<dynamic>?;
      if (records == null || records.isEmpty) {
        const exception = DataException(
          message: 'GraphQL response does not contain created game',
          operation: 'createGame',
        );
        logError(
          'createGame завершился с ${exception.runtimeType}: ${exception.message}',
        );
        throw exception;
      }

      logDebug('Успех createGame для category=${game.category}');
      return GameResponse.fromJson(
        Map<String, dynamic>.from(records.first as Map),
      );
    } catch (error) {
      if (error is DataException) {
        rethrow;
      }
      logError('createGame завершился с ${error.runtimeType}: $error');
      throw DataException(
        message: error.toString(),
        operation: 'createGame',
        cause: error,
      );
    }
  }

  Future<GameResponse?> getGameById(String gameId) async {
    logInfo('Начало getGameById для gameId=$gameId');
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(_getGameByIdQuery),
          operationName: 'GetGameById',
          variables: {'id': gameId},
        ),
      );

      if (result.hasException) {
        final exception = mapGraphqlException(
          result.exception!,
          operation: 'getGameById',
        );
        logError(
          'getGameById завершился с ${result.exception.runtimeType}: ${exception.message}',
        );
        throw exception;
      }

      final edges = result.data?['gamesCollection']?['edges'] as List<dynamic>?;
      if (edges == null || edges.isEmpty) {
        logDebug('getGameById не нашёл игру gameId=$gameId');
        return null;
      }

      final node = (edges.first as Map)['node'];
      logDebug('Успех getGameById для gameId=$gameId');
      return GameResponse.fromJson(node);
    } catch (error) {
      if (error is DataException) {
        rethrow;
      }
      logError('getGameById завершился с ${error.runtimeType}: $error');
      throw DataException(
        message: error.toString(),
        operation: 'getGameById',
        cause: error,
      );
    }
  }
}

const _createGameMutation = r'''
mutation CreateGame(
  $category: String!
  $scheduledAt: Datetime!
  $isFinished: Boolean!
) {
  insertIntogamesCollection(
    objects: [
      {
        category: $category
        scheduled_at: $scheduledAt
        is_finished: $isFinished
      }
    ]
  ) {
    records {
      id
      category
      scheduled_at
      is_finished
    }
  }
}
''';

const _getGameByIdQuery = r'''
query GetGameById($id: UUID!) {
  gamesCollection(filter: {id: {eq: $id}}, first: 1) {
    edges {
      node {
        id
        category
        scheduled_at
        is_finished
      }
    }
  }
}
''';
