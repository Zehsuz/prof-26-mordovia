import 'package:dio/dio.dart';
import 'package:logging_helper/logging_helper.dart';

import '../exceptions/data_exception.dart';
import '../models/models.dart';
import '../utils/auth_interceptor.dart';

class QueryHttpClient with CustomLogger {
  final Dio _dio;
  final AuthInterceptor? _authInterceptor;

  const QueryHttpClient({required Dio dio, AuthInterceptor? authInterceptor})
    : _dio = dio,
      _authInterceptor = authInterceptor;

  Future<AuthResponse> login(String email, String password) async {
    logInfo('Начало login для $email');
    try {
      final response = await _dio.post<dynamic>(
        '/auth/v1/token?grant_type=password',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      _authInterceptor?.setAccessToken(authResponse.accessToken);
      logDebug('Успех login для $email');

      return authResponse;
    } on DioException catch (error) {
      logError(
        'login завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'login',
        cause: error,
      );
    }
  }

  Future<AuthResponse> register(
    String email,
    String password,
    ProfileRequest profile,
  ) async {
    logInfo('Начало register для $email');
    try {
      final response = await _dio.post(
        '/auth/v1/signup',
        data: {'email': email, 'password': password, 'data': profile.toJson()},
      );
      final authResponse = AuthResponse.fromJson(response.data);
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
      logError(
        'register завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'register',
        cause: error,
      );
    }
  }

  Future<void> logout() async {
    logInfo('Начало logout');
    try {
      await _dio.post<dynamic>('/auth/v1/logout');
      _authInterceptor?.clearAccessToken();
      logDebug('Успех logout');
    } on DioException catch (error) {
      logError(
        'logout завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'logout',
        cause: error,
      );
    }
  }

  Future<ProfileResponse?> getProfile(String userId) async {
    logInfo('Начало getProfile для userId=$userId');
    try {
      final response = await _dio.get<dynamic>(
        '/rest/v1/profiles',
        queryParameters: {
          'id': 'eq.$userId',
          'select': 'nickname,avatar,email_visibility',
        },
      );
      final data = response.data as List<dynamic>;
      if (data.isEmpty) {
        logDebug('getProfile не нашёл профиль для userId=$userId');
        return null;
      }

      logDebug('Успех getProfile для userId=$userId');
      return ProfileResponse.fromJson(data.first as Map<String, dynamic>);
    } on DioException catch (error) {
      logError(
        'getProfile завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'getProfile',
        cause: error,
      );
    }
  }

  Future<ProfileResponse> changeProfile(
    String userId,
    ProfileRequest profile,
  ) async {
    logInfo('Начало changeProfile для userId=$userId');
    try {
      final response = await _dio.patch<dynamic>(
        '/rest/v1/profiles',
        queryParameters: {
          'id': 'eq.$userId',
          'select': 'nickname,avatar,email_visibility',
        },
        data: profile.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      logDebug('Успех changeProfile для userId=$userId');

      return ProfileResponse.fromJson(
        response.data.first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      logError(
        'changeProfile завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'changeProfile',
        cause: error,
      );
    }
  }

  Future<GameResponse> createGame(GameRequest game) async {
    logInfo(
      'Начало createGame для category=${game.category}, scheduledAt=${game.scheduledAt.toIso8601String()}',
    );
    try {
      final response = await _dio.post<dynamic>(
        '/rest/v1/games',
        data: game.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      logDebug('Успех createGame для category=${game.category}');

      return GameResponse.fromJson(response.data.first as Map<String, dynamic>);
    } on DioException catch (error) {
      logError(
        'createGame завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'createGame',
        cause: error,
      );
    }
  }

  Future<List<GameResponse>> getAllGames() async {
    logInfo('Начало getAllGames');
    try {
      final response = await _dio.get<dynamic>(
        '/rest/v1/games',
        queryParameters: {'select': 'id,category,scheduled_at,is_finished'},
      );
      final games = (response.data as List)
          .map((raw) => GameResponse.fromJson(raw as Map<String, dynamic>))
          .toList();
      logDebug('Успех getAllGames, получено ${games.length} игр');

      return games;
    } on DioException catch (error) {
      logError(
        'getAllGames завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'getAllGames',
        cause: error,
      );
    }
  }

  Future<GameResponse?> getGameById(String gameId) async {
    logInfo('Начало getGameById для gameId=$gameId');
    try {
      final response = await _dio.get(
        '/rest/v1/games',
        queryParameters: {
          'id': 'eq.$gameId',
          'select': 'id,category,scheduled_at,is_finished',
        },
      );

      final data = response.data as List;
      if (data.isEmpty) {
        logDebug('getGameById не нашёл игру gameId=$gameId');
        return null;
      }
      logDebug('Успех getGameById для gameId=$gameId');

      return GameResponse.fromJson(data.first as Map<String, dynamic>);
    } on DioException catch (error) {
      logError(
        'getGameById завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'getGameById',
        cause: error,
      );
    }
  }

  Future<GameParticipantResponse> joinGame(String gameId, String userId) async {
    logInfo('Начало joinGame для gameId=$gameId, userId=$userId');
    try {
      final response = await _dio.post(
        '/rest/v1/game_participants',
        data: {'game_id': gameId, 'user_id': userId},
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      logDebug('Успех joinGame для gameId=$gameId, userId=$userId');

      return GameParticipantResponse.fromJson(
        response.data.first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      logError(
        'joinGame завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'joinGame',
        cause: error,
      );
    }
  }

  Future<UserStatisticsResponse?> getUserStatistics(String userId) async {
    logInfo('Начало getUserStatistics для userId=$userId');
    try {
      final response = await _dio.get(
        '/rest/v1/user_statistics',
        queryParameters: {
          'user_id': 'eq.$userId',
          'select':
              'id,user_id,total_earnings,games_won,games_played,games_scheduled_this_week,created,updated,updated_at',
        },
      );

      final data = response.data as List;
      if (data.isEmpty) {
        logDebug('getUserStatistics не нашёл статистику для userId=$userId');
        return null;
      }
      logDebug('Успех getUserStatistics для userId=$userId');

      return UserStatisticsResponse.fromJson(
        data.first as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      logError(
        'getUserStatistics завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'getUserStatistics',
        cause: error,
      );
    }
  }

  Future<GameResultResponse> saveGameResult(
    GameResultRequest gameResult,
  ) async {
    logInfo(
      'Начало saveGameResult для gameId=${gameResult.gameId}, winnerId=${gameResult.winnerId}',
    );
    try {
      final response = await _dio.post(
        '/rest/v1/game_results',
        data: gameResult.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      logDebug('Успех saveGameResult для gameId=${gameResult.gameId}');

      return GameResultResponse.fromJson(response.data.first);
    } on DioException catch (error) {
      logError(
        'saveGameResult завершился с ${error.runtimeType}: ${_resolveErrorMessage(error)}',
      );
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'saveGameResult',
        cause: error,
      );
    }
  }

  String _resolveErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message =
          responseData['msg'] ??
          responseData['message'] ??
          responseData['error_description'] ??
          responseData['error'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return error.message ?? 'Network error while fetching data';
  }
}
