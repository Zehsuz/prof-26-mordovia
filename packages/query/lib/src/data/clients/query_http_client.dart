import 'package:dio/dio.dart';
import 'package:logging_helper/logging_helper.dart';

import '../exceptions/data_exception.dart';
import '../models/models.dart';
import '../utils/auth_interceptor.dart';
import '../utils/dio_exception_handler.dart';
import 'dio_rest_transport.dart';
import 'query_client.dart';
import 'rest_transport.dart';

class QueryHttpClient
    with CustomLogger
    implements AuthClient, ProfileClient, GameClient {
  final RestTransport _transport;
  final AuthInterceptor? _authInterceptor;
  final DioExceptionHandler _errorHandler;

  factory QueryHttpClient({
    required Dio dio,
    AuthInterceptor? authInterceptor,
    DioExceptionHandler? errorHandler,
  }) {
    return QueryHttpClient._(
      transport: DioRestTransport(dio: dio),
      authInterceptor: authInterceptor,
      errorHandler: errorHandler ?? const DefaultDioExceptionHandler(),
    );
  }

  const QueryHttpClient._({
    required RestTransport transport,
    AuthInterceptor? authInterceptor,
    DioExceptionHandler errorHandler = const DefaultDioExceptionHandler(),
  }) : _transport = transport,
       _authInterceptor = authInterceptor,
       _errorHandler = errorHandler;

  @override
  Future<AuthResponse> login(String email, String password) async {
    logInfo('Начало login для $email');
    try {
      final response = await _transport.post(
        '/auth/v1/token?grant_type=password',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(
        response as Map<String, dynamic>,
      );
      _authInterceptor?.setAccessToken(authResponse.accessToken);
      logDebug('Успех login для $email');

      return authResponse;
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'login');
    }
  }

  @override
  Future<AuthResponse> register(
    String email,
    String password,
    ProfileRequest profile,
  ) async {
    logInfo('Начало register для $email');
    try {
      final response = await _transport.post(
        '/auth/v1/signup',
        data: {'email': email, 'password': password, 'data': profile.toJson()},
      );
      final authResponse = AuthResponse.fromJson(
        response as Map<String, dynamic>,
      );
      _authInterceptor?.setAccessToken(authResponse.accessToken);
      final user = authResponse.user;
      logDebug('Успех register для $email');

      return AuthResponse(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        expiresIn: authResponse.expiresIn,
        tokenType: authResponse.tokenType,
        user: UserResponse(
          id: user.id,
          email: email,
          profile: ProfileResponse(
            nickname: profile.nickname,
            avatar: profile.avatar,
            emailVisibility: profile.emailVisibility,
          ),
        ),
      );
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'register');
    }
  }

  @override
  Future<void> logout() async {
    logInfo('Начало logout');
    try {
      await _transport.post('/auth/v1/logout');
      _authInterceptor?.clearAccessToken();
      logDebug('Успех logout');
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'logout');
    }
  }

  @override
  Future<ProfileResponse?> getProfile(String userId) async {
    logInfo('Начало getProfile для userId=$userId');
    try {
      final response = await _transport.get(
        '/rest/v1/profiles',
        queryParameters: {
          'id': 'eq.$userId',
          'select': 'nickname,avatar,email_visibility',
        },
      );
      final data = response as List<dynamic>;
      if (data.isEmpty) {
        logDebug('getProfile не нашёл профиль для userId=$userId');
        return null;
      }

      logDebug('Успех getProfile для userId=$userId');
      return ProfileResponse.fromJson(data.first as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'getProfile');
    }
  }

  @override
  Future<ProfileResponse> changeProfile(
    String userId,
    ProfileRequest profile,
  ) async {
    logInfo('Начало changeProfile для userId=$userId');
    try {
      final response = await _transport.patch(
        '/rest/v1/profiles',
        queryParameters: {
          'id': 'eq.$userId',
          'select': 'nickname,avatar,email_visibility',
        },
        data: profile.toJson(),
        headers: {'Prefer': 'return=representation'},
      );
      logDebug('Успех changeProfile для userId=$userId');

      return ProfileResponse.fromJson(
        (response as List).first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'changeProfile');
    }
  }

  @override
  Future<GameResponse> createGame(GameRequest game) async {
    logInfo(
      'Начало createGame для category=${game.category}, scheduledAt=${game.scheduledAt.toIso8601String()}',
    );
    try {
      final response = await _transport.post(
        '/rest/v1/games',
        data: game.toJson(),
        headers: {'Prefer': 'return=representation'},
      );
      logDebug('Успех createGame для category=${game.category}');

      return GameResponse.fromJson(
        (response as List).first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'createGame');
    }
  }

  @override
  Future<List<GameResponse>> getAllGames() async {
    logInfo('Начало getAllGames');
    try {
      final response = await _transport.get(
        '/rest/v1/games',
        queryParameters: {'select': 'id,category,scheduled_at,is_finished'},
      );
      final games = (response as List)
          .map((raw) => GameResponse.fromJson(raw as Map<String, dynamic>))
          .toList();
      logDebug('Успех getAllGames, получено ${games.length} игр');

      return games;
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'getAllGames');
    }
  }

  @override
  Future<GameResponse?> getGameById(String gameId) async {
    logInfo('Начало getGameById для gameId=$gameId');
    try {
      final response = await _transport.get(
        '/rest/v1/games',
        queryParameters: {
          'id': 'eq.$gameId',
          'select': 'id,category,scheduled_at,is_finished',
        },
      );

      final data = response as List;
      if (data.isEmpty) {
        logDebug('getGameById не нашёл игру gameId=$gameId');
        return null;
      }
      logDebug('Успех getGameById для gameId=$gameId');

      return GameResponse.fromJson(data.first as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'getGameById');
    }
  }

  @override
  Future<GameParticipantResponse> joinGame(String gameId, String userId) async {
    logInfo('Начало joinGame для gameId=$gameId, userId=$userId');
    try {
      final response = await _transport.post(
        '/rest/v1/game_participants',
        data: {'game_id': gameId, 'user_id': userId},
        headers: {'Prefer': 'return=representation'},
      );
      logDebug('Успех joinGame для gameId=$gameId, userId=$userId');

      return GameParticipantResponse.fromJson(
        (response as List).first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'joinGame');
    }
  }

  @override
  Future<UserStatisticsResponse?> getUserStatistics(String userId) async {
    logInfo('Начало getUserStatistics для userId=$userId');
    try {
      final response = await _transport.get(
        '/rest/v1/user_statistics',
        queryParameters: {
          'user_id': 'eq.$userId',
          'select':
              'id,user_id,total_earnings,games_won,games_played,games_scheduled_this_week,created,updated,updated_at',
        },
      );

      final data = response as List;
      if (data.isEmpty) {
        logDebug('getUserStatistics не нашёл статистику для userId=$userId');
        return null;
      }
      logDebug('Успех getUserStatistics для userId=$userId');

      return UserStatisticsResponse.fromJson(
        data.first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'getUserStatistics');
    }
  }

  @override
  Future<GameResultResponse> saveGameResult(
    GameResultRequest gameResult,
  ) async {
    logInfo(
      'Начало saveGameResult для gameId=${gameResult.gameId}, winnerId=${gameResult.winnerId}',
    );
    try {
      final response = await _transport.post(
        '/rest/v1/game_results',
        data: gameResult.toJson(),
        headers: {'Prefer': 'return=representation'},
      );
      logDebug('Успех saveGameResult для gameId=${gameResult.gameId}');

      return GameResultResponse.fromJson(
        ((response as List).first as Map).cast<String, dynamic>(),
      );
    } on DioException catch (error) {
      throw _logAndMapError(error, operation: 'saveGameResult');
    }
  }

  DataException _logAndMapError(
    DioException error, {
    required String operation,
  }) {
    final exception = _errorHandler.map(error, operation: operation);
    logError(
      '$operation завершился с ${error.runtimeType}: ${exception.message}',
    );
    return exception;
  }
}
