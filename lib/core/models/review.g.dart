// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      userId: json['userId'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'content': instance.content,
      'rating': instance.rating,
      'date': instance.date.toIso8601String(),
    };
