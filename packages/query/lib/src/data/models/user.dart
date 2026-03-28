import 'package:equatable/equatable.dart';

import 'models.dart';

class UserDto extends Equatable {
  final String id;
  final String email;
  final ProfileDto? profile;

  const UserDto({required this.id, required this.email, this.profile});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(id: json['id'] as String, email: json['email'] as String);
  }

  UserDto copyWith({String? id, String? email, ProfileDto? profile}) {
    return UserDto(
      id: id ?? this.id,
      email: email ?? this.email,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [id, email, profile];
}
