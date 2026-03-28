import 'package:equatable/equatable.dart';

class GameParticipantDto extends Equatable {
  final String? id;
  final String gameId;
  final String userId;
  final DateTime? joinedAt;
  final num? score;
  final bool? hasLeft;
  final DateTime? created;
  final DateTime? updated;

  const GameParticipantDto({
    this.id,
    required this.gameId,
    required this.userId,
    this.joinedAt,
    this.score,
    this.hasLeft,
    this.created,
    this.updated,
  });

  factory GameParticipantDto.fromJson(Map<String, dynamic> json) {
    return GameParticipantDto(
      id: json['id'] as String?,
      gameId: json['game_id'] as String,
      userId: json['user_id'] as String,
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
      score: json['score'] as num?,
      hasLeft: json['has_left'] as bool?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );
  }

  Map<String, dynamic> toJson() => {'game_id': gameId, 'user_id': userId};

  @override
  List<Object?> get props => [
    id,
    gameId,
    userId,
    joinedAt,
    score,
    hasLeft,
    created,
    updated,
  ];
}
