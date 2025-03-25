// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameHistoryRecord _$GameHistoryRecordFromJson(Map<String, dynamic> json) =>
    GameHistoryRecord(
      endDate: DateTime.parse(json['end_date'] as String),
      previousStepText: json['previous_step_text'] as String?,
      idSes: (json['id_ses'] as num).toInt(),
      idUser: (json['id_user'] as num).toInt(),
      idGame: (json['id_game'] as num).toInt(),
      currentStep: (json['current_step'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      choiceText: json['choice_text'] as String?,
    );

Map<String, dynamic> _$GameHistoryRecordToJson(GameHistoryRecord instance) =>
    <String, dynamic>{
      'end_date': instance.endDate.toIso8601String(),
      'previous_step_text': instance.previousStepText,
      'id_ses': instance.idSes,
      'id_user': instance.idUser,
      'id_game': instance.idGame,
      'current_step': instance.currentStep,
      'start_date': instance.startDate.toIso8601String(),
      'choice_text': instance.choiceText,
    };
