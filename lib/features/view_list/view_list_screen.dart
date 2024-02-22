import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/components/object_delivery_item.dart';
import 'package:lista_de_entrega_barcode/core/inject.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:lista_de_entrega_barcode/features/barcode_list/barcode_list_screen.dart';
import 'package:lista_de_entrega_barcode/features/view_list/view_list_view_model.dart';
import 'package:provider/provider.dart';

class ViewListScreen extends StatefulWidget {
  const ViewListScreen({super.key});

  static Widget create() => ChangeNotifierProvider(
        create: (context) => ViewListViewModel(dbHelper: inject<DBHelper>()),
        child: const ViewListScreen(),
      );

  @override
  State<StatefulWidget> createState() {
    return _ViewListScreenState();
  }
}

class _ViewListScreenState extends State<ViewListScreen> {
  ViewListViewModel? model;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  key: const Key('navigate-back-list-screen-key'),
                  onPressed: () => {Navigator.of(context).pop()},
                  icon: const Icon(Icons.arrow_back, color: Colors.white)),
              const Text('Ver Lista'),
              IconButton(
                key: const Key('view-barcode-list-key'),
                onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => BarcodeListScreen.create()))},
                icon: const Icon(Icons.list_alt, color: Colors.white),
              ),
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
                  itemBuilder: (context, index) => ObjectDeliveryItem(object: model!.objects[index]),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
