import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'choice.g.dart';

Choice choiceFromJson(String str) => Choice.fromJson(json.decode(str));

String choiceToJson(Choice data) => json.encode(data.toJson());

@JsonSerializable()
class Choice {
  @JsonKey(name: "id_choice")
  int idChoice;
  @JsonKey(name: "choice_text")
  String text;
  @JsonKey(name: "id_next_step")
  int idNextStep;

  Choice({
    required this.idChoice,
    required this.text,
    required this.idNextStep,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
