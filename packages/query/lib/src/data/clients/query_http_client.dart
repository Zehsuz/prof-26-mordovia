import 'package:dio/dio.dart';

import '../exceptions/data_exception.dart';
import '../models/models.dart';
import '../utils/auth_interceptor.dart';

class QueryHttpClient {
  final Dio _dio;
  final AuthInterceptor? _authInterceptor;

  const QueryHttpClient({required Dio dio, AuthInterceptor? authInterceptor})
    : _dio = dio,
      _authInterceptor = authInterceptor;

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/v1/token?grant_type=password',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      _authInterceptor?.setAccessToken(authResponse.accessToken);

      return authResponse;
    } on DioException catch (error) {
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
    try {
      final response = await _dio.post(
        '/auth/v1/signup',
        data: {'email': email, 'password': password, 'data': profile.toJson()},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      _authInterceptor?.setAccessToken(authResponse.accessToken);
      final user = authResponse.user;

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
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'register',
        cause: error,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/auth/v1/logout');
      _authInterceptor?.clearAccessToken();
    } on DioException catch (error) {
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'logout',
        cause: error,
      );
    }
  }

  Future<ProfileResponse?> getProfile(String userId) async {
    try {
      final response = await _dio.get<dynamic>(
        '/rest/v1/profiles',
        queryParameters: {
          'id': 'eq.$userId',
          'select': 'nickname,avatar,email_visibility',
        },
      );

      return ProfileResponse.fromJson(response.data.first);
    } on DioException catch (error) {
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

      return ProfileResponse.fromJson(response.data.first);
    } on DioException catch (error) {
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'changeProfile',
        cause: error,
      );
    }
  }

  Future<GameResponse> createGame(GameRequest game) async {
    try {
      final response = await _dio.post<dynamic>(
        '/rest/v1/games',
        data: game.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );

      return GameResponse.fromJson(response.data.first);
    } on DioException catch (error) {
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'createGame',
        cause: error,
      );
    }
  }

  Future<List<GameResponse>> getAllGames() async {
    try {
      final response = await _dio.get<dynamic>(
        '/rest/v1/games',
        queryParameters: {'select': 'id,category,scheduled_at,is_finished'},
      );

      return (response.data as List)
          .map((raw) => GameResponse.fromJson(raw))
          .toList();
    } on DioException catch (error) {
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'getAllGames',
        cause: error,
      );
    }
  }

  Future<GameResponse?> getGameById(String gameId) async {
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
        return null;
      }

      return GameResponse.fromJson(data.first);
    } on DioException catch (error) {
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'getGameById',
        cause: error,
      );
    }
  }

  Future<GameParticipantResponse> joinGame(String gameId, String userId) async {
    try {
      final response = await _dio.post(
        '/rest/v1/game_participants',
        data: {'game_id': gameId, 'user_id': userId},
        options: Options(headers: {'Prefer': 'return=representation'}),
      );

      return GameParticipantResponse.fromJson(response.data.first);
    } on DioException catch (error) {
      throw DataException(
        message: _resolveErrorMessage(error),
        operation: 'joinGame',
        cause: error,
      );
    }
  }

  Future<UserStatisticsResponse?> getUserStatistics(String userId) async {
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
        return null;
      }

      return UserStatisticsResponse.fromJson(data.first);
    } on DioException catch (error) {
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
    try {
      final response = await _dio.post(
        '/rest/v1/game_results',
        data: gameResult.toJson(),
        options: Options(headers: {'Prefer': 'return=representation'}),
      );

      return GameResultResponse.fromJson(response.data.first);
    } on DioException catch (error) {
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
