import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_entrega_barcode/core/inject.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:lista_de_entrega_barcode/features/create_list/create_list_view_model.dart';
import 'package:lista_de_entrega_barcode/features/view_list/view_list_screen.dart';
import 'package:provider/provider.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key});

  static Widget create() => ChangeNotifierProvider(
        create: (context) => CreateListViewModel(dbHelper: inject<DBHelper>()),
        child: const CreateListScreen(),
      );
  @override
  State<StatefulWidget> createState() {
    return _CreateListScreenState();
  }
}

class _CreateListScreenState extends State<CreateListScreen> {
  CreateListViewModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.refreshList());
  }

  form() {
    return Form(
        key: model!.formKey,
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
                            Container(width: 15),
                            const Icon(CupertinoIcons.cube_box),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: TextFormField(
                                  key: const Key('object-key'),
                                  autocorrect: false,
                                  maxLength: 13,
                                  controller: model!.controllerObj,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9]"))],
                                  textCapitalization: TextCapitalization.characters,
                                  autofocus: true,
                                  focusNode: model!.focusObjetoNode,
                                  validator: (val) => (val ?? '').isEmpty ? 'Falta o Nº do Objeto' : null,
                                  onSaved: (val) => model!.code = (val ?? ''),
                                  onChanged: (String value) async {
                                    if (model!.controllerObj.text.length == 13) model!.focusLogradouroNode.requestFocus();
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
                                  key: const Key('address-key'),
                                  autocorrect: false,
                                  maxLength: 25,
                                  controller: model!.controllerLog,
                                  focusNode: model!.focusLogradouroNode,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9 .]"))],
                                  textCapitalization: TextCapitalization.characters,
                                  validator: (val) => (val ?? '').isEmpty ? 'Falta o Logradouro' : null,
                                  onSaved: (val) => model!.address = (val ?? ''),
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
                                  key: const Key('number-key'),
                                  maxLength: 6,
                                  controller: model!.controllerNum,
                                  focusNode: model!.focusNumeroNode,
                                  validator: (val) => (val ?? '').isEmpty ? 'Falta o Nº' : null,
                                  onSaved: (val) => model!.number = (val ?? ''),
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
                                key: const Key('open-list-key'),
                                child: const Text("Ver Lista"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewListScreen.create()));
                                }),
                            MaterialButton(
                                key: const Key('clean-form-key'),
                                child: const Text("Limpar"),
                                onPressed: () {
                                  model!.clearFields();
                                  model!.focusObjetoNode.requestFocus();
                                }),
                            MaterialButton(key: const Key('add-key'), onPressed: () async => await model!.save(), child: const Text("Adicionar"))
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
    model = context.watch();
    if (model!.status.isSaving) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // Don't show the leading button
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text('Criar Lista')],
            ),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Don't show the leading button
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Criar Lista')],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
      model!.controllerObj.text = scanResult.rawContent;
      model!.focusLogradouroNode.requestFocus();
    }
  }
}
