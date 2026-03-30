@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:graphql/client.dart';
import 'package:query/query.dart';
import 'package:test/test.dart';

const _supabaseUrl = 'http://83.166.247.201:8000';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzc0NDU1MjMyLCJleHAiOjE5MzIxMzUyMzJ9.eB-ujxyLwP-p9hosBuTV9-cHdnEYbt214Foidi6bBlI';
const _existingUserEmail = 'existing_test@gmail.com';
const _existingUserPassword = 'QQQw1029384756+-';

void main() {
  group('QueryGraphqlClient Supabase integration', () {
    late QueryHttpClient httpClient;

    setUp(() {
      httpClient = QueryHttpClient(
        transport: DioRestTransport(
          dio: Dio(
            BaseOptions(
              baseUrl: _supabaseUrl,
              headers: {
                'apikey': _supabaseAnonKey,
                'Authorization': 'Bearer $_supabaseAnonKey',
              },
            ),
          ),
        ),
      );
    });

    test('createGame', () async {
      final auth = await httpClient.login(
        _existingUserEmail,
        _existingUserPassword,
      );
      final client = _buildGraphqlClient(accessToken: auth.accessToken);
      final game = GameRequest(
        category: 'Image',
        scheduledAt: DateTime.now().toUtc().add(const Duration(days: 1)),
        isFinished: false,
      );

      final created = await client.createGame(game);

      expect(created.id, isNotEmpty);
      expect(created.category, game.category);
      expect(created.scheduledAt, game.scheduledAt);
      expect(created.isFinished, game.isFinished);
    });

    test('getGameById', () async {
      final auth = await httpClient.login(
        _existingUserEmail,
        _existingUserPassword,
      );
      final client = _buildGraphqlClient(accessToken: auth.accessToken);
      final game = GameRequest(
        category: 'Image',
        scheduledAt: DateTime.now().toUtc().add(const Duration(days: 2)),
        isFinished: false,
      );

      final created = await client.createGame(game);
      final fetched = await client.getGameById(created.id!);

      expect(fetched, isNotNull);
      expect(fetched?.id, created.id);
      expect(fetched?.category, created.category);
      expect(fetched?.scheduledAt, created.scheduledAt);
      expect(fetched?.isFinished, created.isFinished);
    });
  });
}

QueryGraphqlClient _buildGraphqlClient({String? accessToken}) {
  return QueryGraphqlClient(
    client: GraphQLClient(
      link: HttpLink(
        '$_supabaseUrl/graphql/v1',
        defaultHeaders: {
          'apikey': _supabaseAnonKey,
          'Authorization': 'Bearer ${accessToken ?? _supabaseAnonKey}',
        },
      ),
      cache: GraphQLCache(),
    ),
  );
}
