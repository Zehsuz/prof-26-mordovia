import 'package:graphql/client.dart';
import 'package:logging_helper/logging_helper.dart';

import '../exceptions/data_exception.dart';
import '../models/models.dart';
import '../utils/graphql_exception_handler.dart';
import 'default_graphql_transport.dart';
import 'graphql_transport.dart';
import 'query_client.dart';

class QueryGraphqlClient with CustomLogger implements GameClient {
  final GraphqlTransport _transport;
  final GraphqlExceptionHandler _errorHandler;

  factory QueryGraphqlClient({
    required GraphQLClient client,
    GraphqlExceptionHandler? errorHandler,
  }) {
    return QueryGraphqlClient.withDependencies(
      transport: DefaultGraphqlTransport(client: client),
      errorHandler: errorHandler ?? const DefaultGraphqlExceptionHandler(),
    );
  }

  const QueryGraphqlClient.withDependencies({
    required GraphqlTransport transport,
    GraphqlExceptionHandler errorHandler =
        const DefaultGraphqlExceptionHandler(),
  }) : _transport = transport,
       _errorHandler = errorHandler;

  @override
  Future<GameResponse> createGame(GameRequest game) async {
    logInfo(
      'Начало createGame для category=${game.category}, scheduledAt=${game.scheduledAt.toIso8601String()}',
    );
    try {
      final result = await _transport.mutate(
        document: _createGameMutation,
        operationName: 'CreateGame',
        variables: {
          'category': game.category,
          'scheduledAt': game.scheduledAt.toIso8601String(),
          'isFinished': game.isFinished,
        },
      );

      if (result.hasException) {
        final exception = _errorHandler.map(
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

  @override
  Future<List<GameResponse>> getAllGames() {
    throw UnimplementedError(
      'QueryGraphqlClient.getAllGames is not implemented',
    );
  }

  @override
  Future<GameResponse?> getGameById(String gameId) async {
    logInfo('Начало getGameById для gameId=$gameId');
    try {
      final result = await _transport.query(
        document: _getGameByIdQuery,
        operationName: 'GetGameById',
        variables: {'id': gameId},
      );

      if (result.hasException) {
        final exception = _errorHandler.map(
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

  @override
  Future<GameParticipantResponse> joinGame(String gameId, String userId) {
    throw UnimplementedError('QueryGraphqlClient.joinGame is not implemented');
  }

  @override
  Future<UserStatisticsResponse?> getUserStatistics(String userId) {
    throw UnimplementedError(
      'QueryGraphqlClient.getUserStatistics is not implemented',
    );
  }

  @override
  Future<GameResultResponse> saveGameResult(GameResultRequest gameResult) {
    throw UnimplementedError(
      'QueryGraphqlClient.saveGameResult is not implemented',
    );
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
