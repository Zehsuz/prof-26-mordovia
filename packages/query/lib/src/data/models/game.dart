import 'package:equatable/equatable.dart';

class GameDto extends Equatable {
  final String? id;
  final String category;
  final DateTime scheduledAt;
  final bool isFinished;

  const GameDto({
    this.id,
    required this.category,
    required this.scheduledAt,
    required this.isFinished,
  });

  factory GameDto.fromJson(Map<String, dynamic> json) {
    return GameDto(
      id: json['id'] as String?,
      category: json['category'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      isFinished: json['is_finished'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'scheduled_at': scheduledAt.toIso8601String(),
    'is_finished': isFinished,
  };

  @override
  List<Object?> get props => [id, category, scheduledAt, isFinished];
}
