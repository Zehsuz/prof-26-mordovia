import 'package:equatable/equatable.dart';

import 'models.dart';

class UserResponse extends Equatable {
  final String id;
  final String email;
  final ProfileResponse? profile;

  const UserResponse({required this.id, required this.email, this.profile});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }

  UserResponse copyWith({String? id, String? email, ProfileResponse? profile}) {
    return UserResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [id, email, profile];
}
