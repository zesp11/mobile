// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      idChoice: (json['id_choice'] as num).toInt(),
      text: json['text'] as String,
      idNextStep: (json['id_next_step'] as num).toInt(),
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'id_choice': instance.idChoice,
      'text': instance.text,
      'id_next_step': instance.idNextStep,
    };
