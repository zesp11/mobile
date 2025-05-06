// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStep _$GameStepFromJson(Map<String, dynamic> json) => GameStep(
      title: json['title'] as String?,
      text: json['text'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      photoUrl: json['photo_url'] as String?,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id_step'] as num).toInt(),
    );

Map<String, dynamic> _$GameStepToJson(GameStep instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'photo_url': instance.photoUrl,
      'choices': instance.choices,
      'id_step': instance.id,
    };
