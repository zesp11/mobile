// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatedGame _$CreatedGameFromJson(Map<String, dynamic> json) => CreatedGame(
      userId: (json['user_id'] as num).toInt(),
      idSes: (json['id_ses'] as num).toInt(),
      idAuthor: (json['id_author'] as num).toInt(),
      idGame: (json['id_game'] as num).toInt(),
      name: json['name'] as String,
      firstStep: Step.fromJson(json['first_step'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatedGameToJson(CreatedGame instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'id_ses': instance.idSes,
      'id_author': instance.idAuthor,
      'id_game': instance.idGame,
      'name': instance.name,
      'first_step': instance.firstStep,
    };
