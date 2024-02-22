import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/core/logger.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:lista_de_entrega_barcode/models/object_delivery_dto.dart';

enum BarcodeListStatus { loading, content, error, empty }

extension BarcodeListStatusExt on BarcodeListStatus {
  bool get isLoading => this == BarcodeListStatus.loading;
  bool get isContent => this == BarcodeListStatus.content;
  bool get isEmpty => this == BarcodeListStatus.empty;
  bool get isError => this == BarcodeListStatus.error;
}

class BarcodeListViewModel with ChangeNotifier {
  BarcodeListStatus status = BarcodeListStatus.content;

  List<ObjectDeliveryDto> objects = [];

  final DBHelper dbHelper;

  BarcodeListViewModel({required this.dbHelper});

  Future<void> loadObjects() async {
    try {
      _emitLoading();
      DLLogger.i('refreshList try get objects from db');

      objects = await dbHelper.getObjects();
      objects.isEmpty ? _emitEmpty() : _emitContent();
    } catch (error, stackTrace) {
      DLLogger.e('Fail to get objects from db', error: error, stackTrace: stackTrace);
      _emitError();
    }
  }

  Future<void> deleteList() async => await dbHelper.deleteTable();

  void _emitContent() {
    status = BarcodeListStatus.content;
    notifyListeners();
  }

  void _emitEmpty() {
    status = BarcodeListStatus.empty;
    notifyListeners();
  }

  void _emitLoading() {
    status = BarcodeListStatus.loading;
    notifyListeners();
  }

  void _emitError() {
    status = BarcodeListStatus.error;
    notifyListeners();
  }
}
