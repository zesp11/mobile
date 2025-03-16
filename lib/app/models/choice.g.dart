// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      idChoice: (json['id_choice'] as num).toInt(),
      nextStepId: (json['id_next_step'] as num).toInt(),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'id_choice': instance.idChoice,
      'id_next_step': instance.nextStepId,
      'text': instance.text,
    };
