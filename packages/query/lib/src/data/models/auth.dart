import 'package:equatable/equatable.dart';

import 'models.dart';

class AuthResponse extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
  final UserResponse user;

  const AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

    return AuthResponse(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      tokenType: json['token_type'] as String?,
      user: UserResponse.fromJson(userJson),
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    expiresIn,
    tokenType,
    user,
  ];
}
