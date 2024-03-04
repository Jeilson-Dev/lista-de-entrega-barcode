import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/core/inject.dart';
import 'package:lista_de_entrega_barcode/features/create_list/create_list_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => CreateListScreen.create()},
    );
  }
}
