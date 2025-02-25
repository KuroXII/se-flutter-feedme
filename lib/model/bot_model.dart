import 'package:json_annotation/json_annotation.dart';

part 'bot_model.g.dart';

@JsonSerializable()
class Bot {
  final int id;
  bool isProcessing;

  Bot({
    required this.id,
    this.isProcessing = false,
  });

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);

  Map<String, dynamic> toJson() => _$BotToJson(this);
}
