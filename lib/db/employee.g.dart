// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameLog: json['nameLog'] as String?,
      nameNum: json['nameNum'] as String?,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameLog': instance.nameLog,
      'nameNum': instance.nameNum,
    };
