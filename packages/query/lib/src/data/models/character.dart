import 'package:equatable/equatable.dart';

class CharacterDto extends Equatable {
  final String id;
  final String name;
  final String gender;
  final String image;
  final CharacterStatus status;

  const CharacterDto({
    required this.id,
    required this.name,
    required this.gender,
    required this.image,
    required this.status,
  });

  CharacterDto.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      gender = json['gender'],
      image = json['image'],
      status = CharacterStatus.values.byName(json['status']);

  @override
  List<Object?> get props => [id, name, gender, image, status];
}

enum CharacterStatus { alive, dead, unknown }
