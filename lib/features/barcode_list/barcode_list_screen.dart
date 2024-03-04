import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/components/barcode_object_delivery_item.dart';
import 'package:lista_de_entrega_barcode/core/inject.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:lista_de_entrega_barcode/features/barcode_list/barcode_list_view_model.dart';
import 'package:lista_de_entrega_barcode/features/create_list/create_list_screen.dart';
import 'package:provider/provider.dart';

class BarcodeListScreen extends StatefulWidget {
  const BarcodeListScreen({super.key});

  static Widget create() => ChangeNotifierProvider(
        create: (context) => BarcodeListViewModel(dbHelper: inject<DBHelper>()),
        child: const BarcodeListScreen(),
      );

  @override
  State<StatefulWidget> createState() {
    return _BarcodeListScreenState();
  }
}

class _BarcodeListScreenState extends State<BarcodeListScreen> {
  BarcodeListViewModel? model;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await model!.loadObjects());
    model = context.read();
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch();
    final status = model!.status;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                key: const Key('navigate-back-barcode-list-key'),
                onPressed: () => {Navigator.of(context).pop()},
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text('Códigos'),
              MaterialButton(
                key: const Key('create-new-list-key'),
                onPressed: () async {
                  await model!.deleteList();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreateListScreen.create()));
                },
                child: const Text('Nova Lista', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),

              // Your widgets here
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            Container(height: 20),
            Builder(builder: (context) {
              if (status.isLoading) return const Expanded(child: Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())));
              if (status.isEmpty) return const Expanded(child: Center(child: Text("No Data Found")));
              if (status.isEmpty) return const Expanded(child: Center(child: Text("Failed to fetch Objects!")));

              return Expanded(
                child: ListView.builder(
                  itemCount: model!.objects.length,
                  itemBuilder: (context, index) => BarcodeObjectDeliveryItem(object: model!.objects[index]),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
