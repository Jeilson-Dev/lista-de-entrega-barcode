import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lista_de_entrega_barcode/db/employee.dart';
import 'package:lista_de_entrega_barcode/db/BDHelper.dart';
//import 'package:barcode_image/barcode_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:lista_de_entrega_barcode/lista/home.dart';

class BarcodeLista extends StatefulWidget {
  final String title;

  BarcodeLista({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BarcodeListaState();
  }
}

class _BarcodeListaState extends State<BarcodeLista> {
  Future<List<Employee>> employees;
  TextEditingController controllerObj = TextEditingController();
  TextEditingController controllerLog = TextEditingController();
  TextEditingController controllerNum = TextEditingController();
  String name;
  String nameLog;
  String nameNum;
  int curUserId;
  final classDbHelper = new DBHelper();
  final focusObjetoNode = FocusNode();
  final focusLogradouroNode = FocusNode();
  final focusNumeroNode = FocusNode();

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      employees = dbHelper.getEmployees();
    });
  }

  clearName() {
    controllerObj.text = '';
    controllerLog.text = '';
    controllerNum.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Employee e = Employee(curUserId, name, nameLog, nameNum);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = Employee(null, name, nameLog, nameNum);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        headingRowHeight: 0,
        dataRowHeight: 340,
        columns: [
          DataColumn(
            label: Text('Objeto'),
          ),
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
                DataCell(Column(children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: employee.name,
                              width: 300,
                              height: 100,
                            ),
                            BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: employee.nameLog,
                              width: 300,
                              height: 100,
                            ),
                            BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: employee.nameNum,
                              width: 300,
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => {Navigator.of(context).pop()},
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Text('Códigos'),
              MaterialButton(
                onPressed: () => limparLista(),
                child: Text('Nova Lista',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),

              // Your widgets here
            ],
          ),
        ),
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                height: 20,
              ),
              list(),
            ],
          ),
        ),
      ),
    );
  }

  limparLista() async {
    classDbHelper.deleteTable();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => DBTestPage()));
    print('ss');
  }
}
