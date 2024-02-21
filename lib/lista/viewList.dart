import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lista_de_entrega_barcode/db/employee.dart';
import 'package:lista_de_entrega_barcode/db/BDHelper.dart';
import 'package:lista_de_entrega_barcode/lista/barcodeList.dart';

class VerLista extends StatefulWidget {
  final String title;

  const VerLista({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _VerListaState();
  }
}

class _VerListaState extends State<VerLista> {
  //
  Future<List<Employee>> employees = Future.value([]);
  TextEditingController controllerObj = TextEditingController();
  TextEditingController controllerLog = TextEditingController();
  TextEditingController controllerNum = TextEditingController();
  String name = '';
  String nameLog = '';
  String nameNum = '';
  int curUserId = 0;
  final focusObjetoNode = FocusNode();
  final focusLogradouroNode = FocusNode();
  final focusNumeroNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating = false;

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
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        Employee e = Employee(id: curUserId, name: name, nameLog: nameLog, nameNum: nameNum);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = Employee(id: 0, name: name, nameLog: nameLog, nameNum: nameNum);
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
        dataRowHeight: 108,
        columns: const [
          DataColumn(
            label: Text('Objeto'),
          ),
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
                DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 15,
                            ),
                            const Icon(CupertinoIcons.cube_box),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Text(employee.name ?? ''),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 15,
                            ),
                            const Icon(
                              Icons.map,
                              color: Color(0xff000000),
                            ),
                            Expanded(
                              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: Text('${employee.nameLog}, ${employee.nameNum}')),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ])),
                /*
                DataCell(
                  Text(employee.nameLog),
                ),
                DataCell(
                  Text(employee.nameNum),
                ),
                */
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
            return dataTable(snapshot.data ?? []);
          }

          if (snapshot.data != null || (snapshot.data ?? []).isEmpty) {
            return const Text("No Data Found");
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => {Navigator.of(context).pop()},
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text('Ver Lista'),
              IconButton(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BarcodeLista(
                            title: 'Lista',
                          )))
                },
                icon: const Icon(Icons.list_alt, color: Colors.white),
              ),
              // Your widgets here
            ],
          ),
        ),
        body: Container(
          child: Column(
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
}
