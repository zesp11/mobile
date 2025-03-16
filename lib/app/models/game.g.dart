// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      startTime: DateTime.parse(json['start_time'] as String),
      currentStepText: json['current_step_text'] as String,
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      scenarioName: json['scenario_name'] as String,
      idGame: (json['id_game'] as num).toInt(),
      idScen: (json['id_scen'] as num).toInt(),
      currentStep: (json['current_step'] as num).toInt(),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'start_time': instance.startTime.toIso8601String(),
      'current_step_text': instance.currentStepText,
      'end_time': instance.endTime?.toIso8601String(),
      'scenario_name': instance.scenarioName,
      'id_game': instance.idGame,
      'id_scen': instance.idScen,
      'current_step': instance.currentStep,
    };
