// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scenario _$ScenarioFromJson(Map<String, dynamic> json) => Scenario(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      description: json['description'] as String?,
      limitPlayers: (json['limit_players'] as num).toInt(),
      creationDate: DateTime.parse(json['creation_date'] as String),
      photoUrl: json['photo_url'] as String?,
      firstStep: json['first_step'] == null
          ? null
          : GameStep.fromJson(json['first_step'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScenarioToJson(Scenario instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'author': instance.author,
      'description': instance.description,
      'limit_players': instance.limitPlayers,
      'creation_date': instance.creationDate.toIso8601String(),
      'photo_url': instance.photoUrl,
      'first_step': instance.firstStep,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: (json['id'] as num).toInt(),
      login: json['login'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      creationDate: DateTime.parse(json['creation_date'] as String),
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'email': instance.email,
      'bio': instance.bio,
      'creation_date': instance.creationDate.toIso8601String(),
      'photo_url': instance.photoUrl,
    };
