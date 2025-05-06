// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_in_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameInProgress _$GameInProgressFromJson(Map<String, dynamic> json) =>
    GameInProgress(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      scenarioName: json['scenario_name'] as String,
      idGame: (json['id_game'] as num).toInt(),
      idScen: (json['id_scen'] as num).toInt(),
      currentStep:
          CurrentStep.fromJson(json['current_step'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameInProgressToJson(GameInProgress instance) =>
    <String, dynamic>{
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
      'scenario_name': instance.scenarioName,
      'id_game': instance.idGame,
      'id_scen': instance.idScen,
      'current_step': instance.currentStep,
    };

CurrentStep _$CurrentStepFromJson(Map<String, dynamic> json) => CurrentStep(
      latitude: (json['latitude'] as num).toDouble(),
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      title: json['title'] as String,
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrentStepToJson(CurrentStep instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'id': instance.id,
      'text': instance.text,
      'title': instance.title,
      'longitude': instance.longitude,
    };
