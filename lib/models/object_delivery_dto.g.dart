// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_delivery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectDeliveryDto _$ObjectDeliveryDtoFromJson(Map<String, dynamic> json) =>
    ObjectDeliveryDto(
      id: json['id'] as int?,
      code: json['code'] as String?,
      address: json['address'] as String?,
      number: json['number'] as String?,
    );

Map<String, dynamic> _$ObjectDeliveryDtoToJson(ObjectDeliveryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'address': instance.address,
      'number': instance.number,
    };
