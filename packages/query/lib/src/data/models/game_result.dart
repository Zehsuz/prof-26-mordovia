import 'package:equatable/equatable.dart';

class GameResultRequest extends Equatable {
  final String gameId;
  final String winnerId;
  final num completionTimeMs;
  final num earnedPoints;

  const GameResultRequest({
    required this.gameId,
    required this.winnerId,
    required this.completionTimeMs,
    required this.earnedPoints,
  });

  Map<String, dynamic> toJson() => {
    'game_id': gameId,
    'winner_id': winnerId,
    'completion_time_ms': completionTimeMs,
    'earned_points': earnedPoints,
  };

  @override
  List<Object?> get props => [gameId, winnerId, completionTimeMs, earnedPoints];
}

class GameResultResponse extends Equatable {
  final String? id;
  final String gameId;
  final String winnerId;
  final num completionTimeMs;
  final num earnedPoints;
  final DateTime? created;
  final DateTime? updated;

  const GameResultResponse({
    this.id,
    required this.gameId,
    required this.winnerId,
    required this.completionTimeMs,
    required this.earnedPoints,
    this.created,
    this.updated,
  });

  factory GameResultResponse.fromJson(Map<String, dynamic> json) {
    return GameResultResponse(
      id: json['id'] as String?,
      gameId: json['game_id'] as String,
      winnerId: json['winner_id'] as String,
      completionTimeMs: json['completion_time_ms'] as num,
      earnedPoints: json['earned_points'] as num,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    gameId,
    winnerId,
    completionTimeMs,
    earnedPoints,
    created,
    updated,
  ];
}
