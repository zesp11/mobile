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
      previousStep: json['previous_step'] == null
          ? null
          : PreviousStep.fromJson(
              json['previous_step'] as Map<String, dynamic>),
      idGame: (json['id_game'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      currentStep:
          CurrentStep.fromJson(json['current_step'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['start_date'] as String),
      choice: json['choice'] == null
          ? null
          : GameHistoryChoice.fromJson(json['choice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameHistoryRecordToJson(GameHistoryRecord instance) =>
    <String, dynamic>{
      'end_date': instance.endDate?.toIso8601String(),
      'previous_step': instance.previousStep,
      'id_game': instance.idGame,
      'user': instance.user,
      'start_date': instance.startDate.toIso8601String(),
      'choice': instance.choice,
      'current_step': instance.currentStep,
    };

GameHistoryChoice _$GameHistoryChoiceFromJson(Map<String, dynamic> json) =>
    GameHistoryChoice(
      idChoice: (json['id_choice'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$GameHistoryChoiceToJson(GameHistoryChoice instance) =>
    <String, dynamic>{
      'id_choice': instance.idChoice,
      'text': instance.text,
    };

CurrentStep _$CurrentStepFromJson(Map<String, dynamic> json) => CurrentStep(
      latitude: (json['latitude'] as num).toDouble(),
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      photoUrl: json['photo_url'] as String?,
      title: json['title'] as String,
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrentStepToJson(CurrentStep instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'id': instance.id,
      'text': instance.text,
      'photo_url': instance.photoUrl,
      'title': instance.title,
      'longitude': instance.longitude,
    };

PreviousStep _$PreviousStepFromJson(Map<String, dynamic> json) => PreviousStep(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$PreviousStepToJson(PreviousStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'title': instance.title,
    };
