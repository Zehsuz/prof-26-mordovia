@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:query/query.dart';
import 'package:test/test.dart';

const _supabaseUrl = 'http://83.166.247.201:8000';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzc0NDU1MjMyLCJleHAiOjE5MzIxMzUyMzJ9.eB-ujxyLwP-p9hosBuTV9-cHdnEYbt214Foidi6bBlI';
const _existingUserEmail = 'existing_test@gmail.com';
const _existingUserPassword = 'QQQw1029384756+-';
final _newUserEmail = 'test${DateTime.now().millisecondsSinceEpoch}@gmail.com';
const _newUserPassword = '12j3213w123WD32e2+';
const _newUserProfile = ProfileRequest(
  nickname: 'integration-user',
  avatar: null,
  emailVisibility: true,
);
final _newGame = GameRequest(
  category: 'Image',
  scheduledAt: DateTime.now().toUtc().add(const Duration(days: 1)),
  isFinished: false,
);

void main() {
  group('QueryHttpClient Supabase integration', () {
    late AuthInterceptor authInterceptor;
    late QueryHttpClient client;

    setUp(() {
      authInterceptor = AuthInterceptor();
      final dio = Dio(
        BaseOptions(
          baseUrl: _supabaseUrl,
          headers: {
            'apikey': _supabaseAnonKey,
            'Authorization': 'Bearer $_supabaseAnonKey',
          },
        ),
      );
      dio.interceptors.add(authInterceptor);
      client = QueryHttpClient(dio: dio, authInterceptor: authInterceptor);
    });

    test('login', () async {
      final response = await client.login(
        _existingUserEmail,
        _existingUserPassword,
      );

      expect(response.accessToken, isNotEmpty);
      expect(response.refreshToken, isNotEmpty);
      expect(response.user.email, _existingUserEmail);
      expect(authInterceptor.accessToken, response.accessToken);
    });

    test('register', () async {
      final response = await client.register(
        _newUserEmail,
        _newUserPassword,
        _newUserProfile,
      );

      expect(response.user, isNotNull);
      expect(response.user.email, _newUserEmail);
      expect(response.user.profile?.nickname, _newUserProfile.nickname);
      expect(response.user.profile?.avatar, _newUserProfile.avatar);
      expect(
        response.user.profile?.emailVisibility,
        _newUserProfile.emailVisibility,
      );
      expect(authInterceptor.accessToken, response.accessToken);
    });

    test('logout', () async {
      final response = await client.login(
        _existingUserEmail,
        _existingUserPassword,
      );

      expect(authInterceptor.accessToken, response.accessToken);

      await client.logout();

      expect(authInterceptor.accessToken, isNull);
    });

    test('getProfile', () async {
      final authResponse = await client.register(
        'profile${DateTime.now().millisecondsSinceEpoch}@gmail.com',
        _newUserPassword,
        _newUserProfile,
      );

      final profile = await client.getProfile(authResponse.user.id);

      expect(profile?.nickname, _newUserProfile.nickname);
      expect(profile?.avatar, _newUserProfile.avatar);
      expect(profile?.emailVisibility, _newUserProfile.emailVisibility);
    });

    test('changeProfile', () async {
      final authResponse = await client.login(
        _existingUserEmail,
        _existingUserPassword,
      );
      final changedProfile = ProfileRequest(
        nickname: 'updated-${DateTime.now().millisecondsSinceEpoch}',
        avatar:
            'https://example.com/avatar-${DateTime.now().millisecondsSinceEpoch}.png',
        emailVisibility: true,
      );

      final updated = await client.changeProfile(
        authResponse.user.id,
        changedProfile,
      );
      final fetched = await client.getProfile(authResponse.user.id);

      expect(updated.nickname, changedProfile.nickname);
      expect(updated.avatar, changedProfile.avatar);
      expect(updated.emailVisibility, changedProfile.emailVisibility);

      expect(fetched, isNotNull);
      expect(fetched?.nickname, changedProfile.nickname);
      expect(fetched?.avatar, changedProfile.avatar);
      expect(fetched?.emailVisibility, changedProfile.emailVisibility);
    });

    test('createGame', () async {
      await client.login(_existingUserEmail, _existingUserPassword);

      final created = await client.createGame(_newGame);

      expect(created.id, isNotEmpty);
      expect(created.category, _newGame.category);
      expect(created.scheduledAt, _newGame.scheduledAt);
      expect(created.isFinished, _newGame.isFinished);
    });

    test('getAllGames', () async {
      await client.login(_existingUserEmail, _existingUserPassword);

      final created = await client.createGame(
        GameRequest(
          category: 'Image',
          scheduledAt: DateTime.now().toUtc().add(const Duration(days: 2)),
          isFinished: false,
        ),
      );

      final games = await client.getAllGames();

      expect(games, isNotEmpty);
      expect(games.any((game) => game.id == created.id), isTrue);
    });

    test('getGameById', () async {
      await client.login(_existingUserEmail, _existingUserPassword);

      final created = await client.createGame(
        GameRequest(
          category: 'Image',
          scheduledAt: DateTime.now().toUtc().add(const Duration(days: 3)),
          isFinished: false,
        ),
      );

      final game = await client.getGameById(created.id!);

      expect(game, isNotNull);
      expect(game?.id, created.id);
      expect(game?.category, created.category);
      expect(game?.scheduledAt, created.scheduledAt);
      expect(game?.isFinished, created.isFinished);
    });

    test('joinGame', () async {
      final authResponse = await client.login(
        _existingUserEmail,
        _existingUserPassword,
      );
      final createdGame = await client.createGame(
        GameRequest(
          category: 'Image',
          scheduledAt: DateTime.now().toUtc().add(const Duration(days: 4)),
          isFinished: false,
        ),
      );

      final participant = await client.joinGame(
        createdGame.id!,
        authResponse.user.id,
      );

      expect(participant.id, isNotEmpty);
      expect(participant.gameId, createdGame.id);
      expect(participant.userId, authResponse.user.id);
      expect(participant.hasLeft, anyOf(isFalse, isNull));
    });

    test('getUserStatistics', () async {
      final authResponse = await client.login(
        _existingUserEmail,
        _existingUserPassword,
      );

      final statistics = await client.getUserStatistics(authResponse.user.id);

      if (statistics == null) {
        expect(statistics, isNull);
        return;
      }

      expect(statistics.userId, authResponse.user.id);
    });

    test('saveGameResult', () async {
      final authResponse = await client.login(
        _existingUserEmail,
        _existingUserPassword,
      );
      final createdGame = await client.createGame(
        .new(
          category: 'Image',
          scheduledAt: DateTime.now().toUtc().add(const Duration(days: 5)),
          isFinished: false,
        ),
      );
      final result = GameResultRequest(
        gameId: createdGame.id!,
        winnerId: authResponse.user.id,
        completionTimeMs: 12345,
        earnedPoints: 50,
      );

      final saved = await client.saveGameResult(result);

      expect(saved.id, isNotEmpty);
      expect(saved.gameId, createdGame.id);
      expect(saved.winnerId, authResponse.user.id);
      expect(saved.completionTimeMs, result.completionTimeMs);
      expect(saved.earnedPoints, result.earnedPoints);
    });
  });
}
