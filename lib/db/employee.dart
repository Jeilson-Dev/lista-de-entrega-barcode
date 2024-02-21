import 'package:json_annotation/json_annotation.dart';
part 'employee.g.dart';

@JsonSerializable()
class Employee {
  int? id;
  String? name;
  String? nameLog;
  String? nameNum;

  Employee({this.id, this.name, this.nameLog, this.nameNum});

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
  factory Employee.fixture() => Employee(
        id: 12,
        name: '',
        nameLog: '',
        nameNum: '',
      );

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
