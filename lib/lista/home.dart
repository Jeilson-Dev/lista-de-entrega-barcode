import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_entrega_barcode/db/employee.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:lista_de_entrega_barcode/db/BDHelper.dart';
import 'package:lista_de_entrega_barcode/lista/viewList.dart';

class ListaDeEntregasApp extends StatefulWidget {
  final String title;

  const ListaDeEntregasApp({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _ListaDeEntregasAppState();
  }
}

class _ListaDeEntregasAppState extends State<ListaDeEntregasApp> {
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

  form() {
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 0.0,
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
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: TextFormField(
                                  autocorrect: false,
                                  maxLength: 13,
                                  controller: controllerObj,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Z0-9]"))],
                                  textCapitalization: TextCapitalization.characters,
                                  autofocus: true,
                                  focusNode: focusObjetoNode,
                                  validator: (val) => (val ?? '').isEmpty ? 'Falta o Nº do Objeto' : null,
                                  onSaved: (val) => name = (val ?? ''),
                                  onChanged: (String value) async {
                                    if (controllerObj.text.length == 13) {
                                      focusLogradouroNode.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                scan();
                              },
                              child: const Icon(
                                Icons.search,
                              ),
                            ),
                            Container(
                              width: 15,
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
                              color: Color(0xff808080),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: TextFormField(
                                  autocorrect: false,
                                  maxLength: 25,
                                  controller: controllerLog,
                                  focusNode: focusLogradouroNode,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Z0-9 .]"))],
                                  textCapitalization: TextCapitalization.characters,
                                  validator: (val) => (val ?? '').isEmpty ? 'Falta o Logradouro' : null,
                                  onSaved: (val) => nameLog = (val ?? ''),
                                ),
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
                              Icons.home,
                              color: Color(0xff808080),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: TextFormField(
                                  maxLength: 6,
                                  controller: controllerNum,
                                  focusNode: focusNumeroNode,
                                  validator: (val) => (val ?? '').isEmpty ? 'Falta o Nº' : null,
                                  onSaved: (val) => nameNum = (val ?? ''),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            Container(
                              width: 105,
                            )
                          ],
                        ),
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                                child: const Text("Ver Lista"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VerLista(title: 'Lista')));
                                }),
                            MaterialButton(
                                child: const Text("Limpar"),
                                onPressed: () {
                                  clearName();
                                  focusObjetoNode.requestFocus();
                                }),
                            MaterialButton(onPressed: validate, child: const Text("Adicionar"))
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Don't show the leading button
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Criar Lista'),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.list, color: Colors.transparent),
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
            form(),
          ],
        ),
      ),
    );
  }

  Future scan() async {
    final scanResult = await BarcodeScanner.scan();
    if (scanResult.type == ResultType.Barcode) {
      String barcode = controllerObj.text = scanResult.rawContent;
      focusLogradouroNode.requestFocus();
    }
  }
}
