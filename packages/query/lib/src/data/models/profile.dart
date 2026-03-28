import 'package:equatable/equatable.dart';

class ProfileDto extends Equatable {
  final String nickname;
  final String? avatar;
  final bool? emailVisibility;

  const ProfileDto({required this.nickname, this.avatar, this.emailVisibility});

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      nickname: json['nickname'],
      avatar: json['avatar'],
      emailVisibility: json['email_visibility'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'avatar': avatar,
    'email_visibility': emailVisibility,
  };

  @override
  List<Object?> get props => [nickname, avatar, emailVisibility];
}
