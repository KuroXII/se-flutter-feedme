// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bot _$BotFromJson(Map<String, dynamic> json) => Bot(
      id: (json['id'] as num).toInt(),
      isProcessing: json['isProcessing'] as bool? ?? false,
    );

Map<String, dynamic> _$BotToJson(Bot instance) => <String, dynamic>{
      'id': instance.id,
      'isProcessing': instance.isProcessing,
    };
