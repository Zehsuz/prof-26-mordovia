import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:query/query.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

class FakeOptions extends Fake implements Options {}

Response<dynamic> mockResponse(String path, dynamic data) => Response(
  requestOptions: RequestOptions(path: path),
  data: data,
);

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
  user: UserResponse(
    id: 'user-id',
    email: 'rick@c137.dev',
    profile: profileResponse,
  ),
);

final expectedAuthResponse = AuthResponse(
  accessToken: 'access-token',
  refreshToken: 'refresh-token',
  expiresIn: 3600,
  tokenType: 'bearer',
  user: UserResponse(id: 'user-id', email: 'rick@c137.dev'),
);

const profileRequest = ProfileRequest(nickname: 'rick', emailVisibility: true);
const profileResponse = ProfileResponse(
  nickname: 'rick',
  emailVisibility: true,
);
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
final participant = GameParticipantResponse(
  id: 'participant-id',
  gameId: 'game-id',
  userId: 'user-id',
  joinedAt: DateTime.parse('2026-03-29T10:05:00.000Z'),
  score: 0,
  hasLeft: false,
  created: DateTime.parse('2026-03-29T10:05:00.000Z'),
  updated: DateTime.parse('2026-03-29T10:05:00.000Z'),
);
final statistics = UserStatisticsResponse(
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
final gameResultRequest = GameResultRequest(
  gameId: 'game-id',
  winnerId: 'user-id',
  completionTimeMs: 12345,
  earnedPoints: 50,
);
final gameResultResponse = GameResultResponse(
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
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async =>
            mockResponse('/auth/v1/token?grant_type=password', authPayload),
      );

      final response = await client.login('rick@c137.dev', 'portal-gun');

      expect(response, expectedAuthResponse);
    });

    test('register', () async {
      when(
        () => dio.post('/auth/v1/signup', data: any(named: 'data')),
      ).thenAnswer((_) async => mockResponse('/auth/v1/signup', authPayload));

      final response = await client.register(
        'rick@c137.dev',
        'portal-gun',
        profileRequest,
      );

      expect(response, expectedRegisterResponse);
      expect(authInterceptor.accessToken, 'access-token');
    });

    test('logout', () async {
      authInterceptor.setAccessToken('access-token');

      when(
        () => dio.post('/auth/v1/logout'),
      ).thenAnswer((_) async => mockResponse('/auth/v1/logout', null));

      await client.logout();

      expect(authInterceptor.accessToken, isNull);
    });

    test('changeProfile', () async {
      const changedProfile = ProfileRequest(
        nickname: 'morty',
        avatar: 'https://example.com/avatar.png',
        emailVisibility: false,
      );

      when(
        () => dio.patch(
          '/rest/v1/profiles',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async =>
            mockResponse('/rest/v1/profiles', [changedProfile.toJson()]),
      );

      final response = await client.changeProfile('user-id', changedProfile);

      expect(
        response,
        const ProfileResponse(
          nickname: 'morty',
          avatar: 'https://example.com/avatar.png',
          emailVisibility: false,
        ),
      );
    });

    test('createGame', () async {
      when(
        () => dio.post(
          '/rest/v1/games',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/games', [
          {
            'id': 'game-id',
            'category': 'Image',
            'scheduled_at': '2026-03-29T10:00:00.000Z',
            'is_finished': false,
          },
        ]),
      );

      final response = await client.createGame(gameRequest);

      expect(response, gameResponse);
    });

    test('getAllGames', () async {
      when(
        () => dio.get(
          '/rest/v1/games',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/games', [
          {
            'id': 'game-id',
            'category': 'Image',
            'scheduled_at': '2026-03-29T10:00:00.000Z',
            'is_finished': false,
          },
        ]),
      );

      final response = await client.getAllGames();

      expect(response, [gameResponse]);
    });

    test('getGameById', () async {
      when(
        () => dio.get(
          '/rest/v1/games',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/games', [
          {
            'id': 'game-id',
            'category': 'Image',
            'scheduled_at': '2026-03-29T10:00:00.000Z',
            'is_finished': false,
          },
        ]),
      );

      final response = await client.getGameById('game-id');

      expect(response, gameResponse);
    });

    test('joinGame', () async {
      when(
        () => dio.post(
          '/rest/v1/game_participants',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/game_participants', [
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
        ]),
      );

      final response = await client.joinGame('game-id', 'user-id');

      expect(response, participant);
    });

    test('getUserStatistics', () async {
      when(
        () => dio.get(
          '/rest/v1/user_statistics',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/user_statistics', [
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
        ]),
      );

      final response = await client.getUserStatistics('user-id');

      expect(response, statistics);
    });

    test('getUserStatistics returns null when record is absent', () async {
      when(
        () => dio.get(
          '/rest/v1/user_statistics',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/user_statistics', const []),
      );

      final response = await client.getUserStatistics('user-id');

      expect(response, isNull);
    });

    test('saveGameResult', () async {
      when(
        () => dio.post(
          '/rest/v1/game_results',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => mockResponse('/rest/v1/game_results', [
          {
            'id': 'result-id',
            'game_id': 'game-id',
            'winner_id': 'user-id',
            'completion_time_ms': 12345,
            'earned_points': 50,
            'created': '2026-03-29T12:00:00.000Z',
            'updated': '2026-03-29T12:00:00.000Z',
          },
        ]),
      );

      final response = await client.saveGameResult(gameResultRequest);

      expect(response, gameResultResponse);
    });
  });
}
