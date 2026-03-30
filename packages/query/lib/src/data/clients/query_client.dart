import '../models/models.dart';

abstract interface class AuthClient {
  Future<AuthResponse> login(String email, String password);

  Future<AuthResponse> register(
    String email,
    String password,
    ProfileRequest profile,
  );

  Future<void> logout();
}

abstract interface class ProfileClient {
  Future<ProfileResponse?> getProfile(String userId);

  Future<ProfileResponse> changeProfile(String userId, ProfileRequest profile);
}

abstract interface class GameClient {
  Future<GameResponse> createGame(GameRequest game);

  Future<List<GameResponse>> getAllGames();

  Future<GameResponse?> getGameById(String gameId);

  Future<GameParticipantResponse> joinGame(String gameId, String userId);

  Future<UserStatisticsResponse?> getUserStatistics(String userId);

  Future<GameResultResponse> saveGameResult(GameResultRequest gameResult);
}
