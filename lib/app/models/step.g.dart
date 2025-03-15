// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      title: json['title'] as String,
      text: json['text'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      choices: (json['choices'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id_step'] as num).toInt(),
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'choices': instance.choices,
      'id_step': instance.id,
    };
