// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryModelImpl _$$DeliveryModelImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryModelImpl(
      addresses:
          (json['addresses'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$DeliveryModelImplToJson(_$DeliveryModelImpl instance) =>
    <String, dynamic>{
      'addresses': instance.addresses,
    };
