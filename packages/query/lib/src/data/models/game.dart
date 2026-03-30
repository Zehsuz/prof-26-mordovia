import 'package:equatable/equatable.dart';

class GameRequest extends Equatable {
  final String category;
  final DateTime scheduledAt;
  final bool isFinished;

  const GameRequest({
    required this.category,
    required this.scheduledAt,
    required this.isFinished,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'scheduled_at': scheduledAt.toIso8601String(),
    'is_finished': isFinished,
  };

  @override
  List<Object?> get props => [category, scheduledAt, isFinished];
}

class GameResponse extends Equatable {
  final String? id;
  final String category;
  final DateTime scheduledAt;
  final bool isFinished;

  const GameResponse({
    this.id,
    required this.category,
    required this.scheduledAt,
    required this.isFinished,
  });

  factory GameResponse.fromJson(Map<String, dynamic> json) {
    return GameResponse(
      id: json['id'] as String?,
      category: json['category'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      isFinished: json['is_finished'] as bool,
    );
  }

  @override
  List<Object?> get props => [id, category, scheduledAt, isFinished];
}
