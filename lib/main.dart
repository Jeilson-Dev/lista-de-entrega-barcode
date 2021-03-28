import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/lista/home.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => DBTestPage()},
  ));
}
