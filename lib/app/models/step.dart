import 'package:gotale/app/models/choice.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'step.g.dart';

Step stepFromJson(String str) => Step.fromJson(json.decode(str));

String stepToJson(Step data) => json.encode(data.toJson());

@JsonSerializable()
class Step {
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "longitude")
  double longitude;
  @JsonKey(name: "latitude")
  double latitude;
  @JsonKey(name: "choices")
  List<Choice> choices;
  @JsonKey(name: "id_step")
  int id;

  Step({
    required this.title,
    required this.text,
    required this.longitude,
    required this.latitude,
    required this.choices,
    required this.id,
  });

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
}
