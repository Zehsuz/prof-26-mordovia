import 'package:equatable/equatable.dart';

class UserStatisticsDto extends Equatable {
  final String? id;
  final String userId;
  final num? totalEarnings;
  final int? gamesWon;
  final int? gamesPlayed;
  final int? gamesScheduledThisWeek;
  final DateTime? created;
  final DateTime? updated;
  final DateTime? updatedAt;

  const UserStatisticsDto({
    this.id,
    required this.userId,
    this.totalEarnings,
    this.gamesWon,
    this.gamesPlayed,
    this.gamesScheduledThisWeek,
    this.created,
    this.updated,
    this.updatedAt,
  });

  factory UserStatisticsDto.fromJson(Map<String, dynamic> json) {
    return UserStatisticsDto(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      totalEarnings: json['total_earnings'] as num?,
      gamesWon: json['games_won'] as int?,
      gamesPlayed: json['games_played'] as int?,
      gamesScheduledThisWeek: json['games_scheduled_this_week'] as int?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    totalEarnings,
    gamesWon,
    gamesPlayed,
    gamesScheduledThisWeek,
    created,
    updated,
    updatedAt,
  ];
}
