// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameHistoryRecord _$GameHistoryRecordFromJson(Map<String, dynamic> json) =>
    GameHistoryRecord(
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      previousStepText: json['previous_step_text'] as String?,
      idGame: (json['id_game'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      currentStep: (json['current_step'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      choiceText: json['choice_text'] as String?,
    );

Map<String, dynamic> _$GameHistoryRecordToJson(GameHistoryRecord instance) =>
    <String, dynamic>{
      'end_date': instance.endDate?.toIso8601String(),
      'previous_step_text': instance.previousStepText,
      'id_game': instance.idGame,
      'user': instance.user,
      'current_step': instance.currentStep,
      'start_date': instance.startDate.toIso8601String(),
      'choice_text': instance.choiceText,
    };
