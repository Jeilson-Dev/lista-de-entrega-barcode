import 'package:json_annotation/json_annotation.dart';
part 'object_delivery_dto.g.dart';

@JsonSerializable()
class ObjectDeliveryDto {
  int? id;
  String? code;
  String? address;
  String? number;

  ObjectDeliveryDto({this.id, this.code, this.address, this.number});

  factory ObjectDeliveryDto.fromJson(Map<String, dynamic> json) => _$ObjectDeliveryDtoFromJson(json);
  factory ObjectDeliveryDto.fixture() => ObjectDeliveryDto(
        id: 1,
        code: 'aa123456677fc',
        address: 'Street alfa',
        number: '112b',
      );

  Map<String, dynamic> toJson() => _$ObjectDeliveryDtoToJson(this);
}
