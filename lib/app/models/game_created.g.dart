// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameCreated _$GameCreatedFromJson(Map<String, dynamic> json) => GameCreated(
      userId: (json['user_id'] as num).toInt(),
      idSes: (json['id_ses'] as num).toInt(),
      idAuthor: (json['id_author'] as num).toInt(),
      idGame: (json['id_game'] as num).toInt(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String,
      firstStep: GameStep.fromJson(json['first_step'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameCreatedToJson(GameCreated instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'id_ses': instance.idSes,
      'id_author': instance.idAuthor,
      'id_game': instance.idGame,
      'name': instance.name,
      'photo_url': instance.photoUrl,
      'first_step': instance.firstStep,
    };
