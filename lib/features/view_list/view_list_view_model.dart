import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/core/logger.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:lista_de_entrega_barcode/models/object_delivery_dto.dart';

enum ViewListStatus { loading, content, error, empty }

extension ViewListStatusExt on ViewListStatus {
  bool get isLoading => this == ViewListStatus.loading;
  bool get isContent => this == ViewListStatus.content;
  bool get isEmpty => this == ViewListStatus.empty;
  bool get isError => this == ViewListStatus.error;
}

class ViewListViewModel with ChangeNotifier {
  ViewListStatus status = ViewListStatus.content;

  List<ObjectDeliveryDto> objects = [];

  final DBHelper dbHelper;

  ViewListViewModel({required this.dbHelper});

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

  void _emitContent() {
    status = ViewListStatus.content;
    notifyListeners();
  }

  void _emitEmpty() {
    status = ViewListStatus.empty;
    notifyListeners();
  }

  void _emitLoading() {
    status = ViewListStatus.loading;
    notifyListeners();
  }

  void _emitError() {
    status = ViewListStatus.error;
    notifyListeners();
  }
}
