import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:query/query.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

class FakeOptions extends Fake implements Options {}

const authPayload = {
  'access_token': 'access-token',
  'refresh_token': 'refresh-token',
  'expires_in': 3600,
  'token_type': 'bearer',
  'user': {'id': 'user-id', 'email': 'rick@c137.dev'},
};

const profilePayload = {
  'nickname': 'rick',
  'avatar': null,
  'email_visibility': true,
};

final expectedRegisterResponse = AuthResponse(
  accessToken: 'access-token',
  refreshToken: 'refresh-token',
  expiresIn: 3600,
  tokenType: 'bearer',
  user: UserDto(id: 'user-id', email: 'rick@c137.dev', profile: profile),
);

final expectedAuthResponse = AuthResponse(
  accessToken: 'access-token',
  refreshToken: 'refresh-token',
  expiresIn: 3600,
  tokenType: 'bearer',
  user: UserDto(id: 'user-id', email: 'rick@c137.dev'),
);

const profile = ProfileDto(nickname: 'rick', emailVisibility: true);
final game = GameDto(
  id: 'game-id',
  category: 'Image',
  scheduledAt: DateTime.parse('2026-03-29T10:00:00.000Z'),
  isFinished: false,
);
final participant = GameParticipantDto(
  id: 'participant-id',
  gameId: 'game-id',
  userId: 'user-id',
  joinedAt: DateTime.parse('2026-03-29T10:05:00.000Z'),
  score: 0,
  hasLeft: false,
  created: DateTime.parse('2026-03-29T10:05:00.000Z'),
  updated: DateTime.parse('2026-03-29T10:05:00.000Z'),
);
final statistics = UserStatisticsDto(
  id: 'stats-id',
  userId: 'user-id',
  totalEarnings: 100,
  gamesWon: 3,
  gamesPlayed: 5,
  gamesScheduledThisWeek: 2,
  created: DateTime.parse('2026-03-29T10:00:00.000Z'),
  updated: DateTime.parse('2026-03-29T11:00:00.000Z'),
  updatedAt: DateTime.parse('2026-03-29T11:00:00.000Z'),
);
final gameResult = GameResultDto(
  id: 'result-id',
  gameId: 'game-id',
  winnerId: 'user-id',
  completionTimeMs: 12345,
  earnedPoints: 50,
  created: DateTime.parse('2026-03-29T12:00:00.000Z'),
  updated: DateTime.parse('2026-03-29T12:00:00.000Z'),
);

void main() {
  setUpAll(() {
    registerFallbackValue(FakeOptions());
  });

  group('QueryHttpClient with MockDio', () {
    late MockDio dio;
    late AuthInterceptor authInterceptor;
    late QueryHttpClient client;

    setUp(() {
      dio = MockDio();
      authInterceptor = AuthInterceptor();
      client = QueryHttpClient(dio: dio, authInterceptor: authInterceptor);
    });

    test('login', () async {
      when(
        () => dio.post(
          '/auth/v1/token?grant_type=password',
          data: {'email': 'rick@c137.dev', 'password': 'portal-gun'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '/auth/v1/token?grant_type=password',
          ),
          data: authPayload,
        ),
      );

      final response = await client.login('rick@c137.dev', 'portal-gun');

      expect(response, expectedAuthResponse);
      expect(authInterceptor.accessToken, 'access-token');
    });

    test('register', () async {
      when(
        () => dio.post(
          '/auth/v1/signup',
          data: {
            'email': 'rick@c137.dev',
            'password': 'portal-gun',
            'data': profile.toJson(),
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/v1/signup'),
          data: authPayload,
        ),
      );

      final response = await client.register(
        'rick@c137.dev',
        'portal-gun',
        profile,
      );

      expect(response, expectedRegisterResponse);
      expect(authInterceptor.accessToken, 'access-token');
    });

    test('logout', () async {
      authInterceptor.setAccessToken('access-token');

      when(() => dio.post('/auth/v1/logout')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/v1/logout'),
          data: null,
        ),
      );

      await client.logout();

      expect(authInterceptor.accessToken, isNull);
    });

    test('changeProfile', () async {
      const changedProfile = ProfileDto(
        nickname: 'morty',
        avatar: 'https://example.com/avatar.png',
        emailVisibility: false,
      );

      when(
        () => dio.patch(
          '/rest/v1/profiles',
          queryParameters: {
            'id': 'eq.user-id',
            'select': 'nickname,avatar,email_visibility',
          },
          data: changedProfile.toJson(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/profiles'),
          data: [changedProfile.toJson()],
        ),
      );

      final response = await client.changeProfile('user-id', changedProfile);

      expect(response, changedProfile);
    });

    test('createGame', () async {
      when(
        () => dio.post(
          '/rest/v1/games',
          data: game.toJson(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/games'),
          data: [
            {
              'id': 'game-id',
              'category': 'Image',
              'scheduled_at': '2026-03-29T10:00:00.000Z',
              'is_finished': false,
            },
          ],
        ),
      );

      final response = await client.createGame(game);

      expect(response, game);
    });

    test('getAllGames', () async {
      when(
        () => dio.get(
          '/rest/v1/games',
          queryParameters: {'select': 'id,category,scheduled_at,is_finished'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/games'),
          data: [
            {
              'id': 'game-id',
              'category': 'Image',
              'scheduled_at': '2026-03-29T10:00:00.000Z',
              'is_finished': false,
            },
          ],
        ),
      );

      final response = await client.getAllGames();

      expect(response, [game]);
    });

    test('getGameById', () async {
      when(
        () => dio.get(
          '/rest/v1/games',
          queryParameters: {
            'id': 'eq.game-id',
            'select': 'id,category,scheduled_at,is_finished',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/games'),
          data: [
            {
              'id': 'game-id',
              'category': 'Image',
              'scheduled_at': '2026-03-29T10:00:00.000Z',
              'is_finished': false,
            },
          ],
        ),
      );

      final response = await client.getGameById('game-id');

      expect(response, game);
    });

    test('joinGame', () async {
      when(
        () => dio.post(
          '/rest/v1/game_participants',
          data: {'game_id': 'game-id', 'user_id': 'user-id'},
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/game_participants'),
          data: [
            {
              'id': 'participant-id',
              'game_id': 'game-id',
              'user_id': 'user-id',
              'joined_at': '2026-03-29T10:05:00.000Z',
              'score': 0,
              'has_left': false,
              'created': '2026-03-29T10:05:00.000Z',
              'updated': '2026-03-29T10:05:00.000Z',
            },
          ],
        ),
      );

      final response = await client.joinGame('game-id', 'user-id');

      expect(response, participant);
    });

    test('getUserStatistics', () async {
      when(
        () => dio.get(
          '/rest/v1/user_statistics',
          queryParameters: {
            'user_id': 'eq.user-id',
            'select':
                'id,user_id,total_earnings,games_won,games_played,games_scheduled_this_week,created,updated,updated_at',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/user_statistics'),
          data: [
            {
              'id': 'stats-id',
              'user_id': 'user-id',
              'total_earnings': 100,
              'games_won': 3,
              'games_played': 5,
              'games_scheduled_this_week': 2,
              'created': '2026-03-29T10:00:00.000Z',
              'updated': '2026-03-29T11:00:00.000Z',
              'updated_at': '2026-03-29T11:00:00.000Z',
            },
          ],
        ),
      );

      final response = await client.getUserStatistics('user-id');

      expect(response, statistics);
    });

    test('getUserStatistics returns null when record is absent', () async {
      when(
        () => dio.get(
          '/rest/v1/user_statistics',
          queryParameters: {
            'user_id': 'eq.user-id',
            'select':
                'id,user_id,total_earnings,games_won,games_played,games_scheduled_this_week,created,updated,updated_at',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/user_statistics'),
          data: const [],
        ),
      );

      final response = await client.getUserStatistics('user-id');

      expect(response, isNull);
    });

    test('saveGameResult', () async {
      when(
        () => dio.post(
          '/rest/v1/game_results',
          data: gameResult.toJson(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rest/v1/game_results'),
          data: [
            {
              'id': 'result-id',
              'game_id': 'game-id',
              'winner_id': 'user-id',
              'completion_time_ms': 12345,
              'earned_points': 50,
              'created': '2026-03-29T12:00:00.000Z',
              'updated': '2026-03-29T12:00:00.000Z',
            },
          ],
        ),
      );

      final response = await client.saveGameResult(gameResult);

      expect(response, gameResult);
    });
  });
}
