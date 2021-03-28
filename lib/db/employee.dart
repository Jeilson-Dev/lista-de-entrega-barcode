class Employee {
  int id;
  String name;
  String nameLog;
  String nameNum;
  Employee(this.id, this.name, this.nameLog, this.nameNum);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'nameLog': nameLog,
      'nameNum': nameNum,
    };
    return map;
  }

  Employee.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    nameLog = map['nameLog'];
    nameNum = map['nameNum'];
  }
}
