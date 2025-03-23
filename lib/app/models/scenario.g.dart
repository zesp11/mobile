// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scenario _$ScenarioFromJson(Map<String, dynamic> json) => Scenario(
      id: (json['id'] as num).toInt(),
      firstStep: json['first_step'] == null
          ? null
          : FirstStep.fromJson(json['first_step'] as Map<String, dynamic>),
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      limitPlayers: (json['limit_players'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      creationDate: DateTime.parse(json['creation_date'] as String),
      idPhoto: (json['id_photo'] as num).toInt(),
    );

Map<String, dynamic> _$ScenarioToJson(Scenario instance) => <String, dynamic>{
      'id': instance.id,
      'first_step': instance.firstStep,
      'author': instance.author,
      'limit_players': instance.limitPlayers,
      'name': instance.name,
      'description': instance.description,
      'creation_date': instance.creationDate.toIso8601String(),
      'id_photo': instance.idPhoto,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: (json['id'] as num).toInt(),
      login: json['login'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'email': instance.email,
      'bio': instance.bio,
      'creation_date': instance.creationDate.toIso8601String(),
    };

FirstStep _$FirstStepFromJson(Map<String, dynamic> json) => FirstStep(
      id: (json['id_step'] as num).toInt(),
      latitude: json['latitude'],
      text: json['text'],
      title: json['title'],
      choices: json['choices'] as List<dynamic>,
      longitude: json['longitude'],
    );

Map<String, dynamic> _$FirstStepToJson(FirstStep instance) => <String, dynamic>{
      'id_step': instance.id,
      'latitude': instance.latitude,
      'text': instance.text,
      'title': instance.title,
      'choices': instance.choices,
      'longitude': instance.longitude,
    };
