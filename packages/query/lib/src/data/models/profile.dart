import 'package:equatable/equatable.dart';

class ProfileRequest extends Equatable {
  final String nickname;
  final String? avatar;
  final bool? emailVisibility;

  const ProfileRequest({
    required this.nickname,
    this.avatar,
    this.emailVisibility,
  });

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'avatar': avatar,
    'email_visibility': emailVisibility,
  };

  @override
  List<Object?> get props => [nickname, avatar, emailVisibility];
}

class ProfileResponse extends Equatable {
  final String nickname;
  final String? avatar;
  final bool? emailVisibility;

  const ProfileResponse({
    required this.nickname,
    this.avatar,
    this.emailVisibility,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      nickname: json['nickname'],
      avatar: json['avatar'],
      emailVisibility: json['email_visibility'],
    );
  }

  @override
  List<Object?> get props => [nickname, avatar, emailVisibility];
}
