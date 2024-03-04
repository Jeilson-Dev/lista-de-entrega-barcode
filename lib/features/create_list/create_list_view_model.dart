import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/core/logger.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:lista_de_entrega_barcode/models/object_delivery_dto.dart';

enum CreateListStatus { saving, content, error }

extension CreateListStatusExt on CreateListStatus {
  bool get isSaving => this == CreateListStatus.saving;
  bool get isContent => this == CreateListStatus.content;
  bool get isError => this == CreateListStatus.error;
}

class CreateListViewModel with ChangeNotifier {
  CreateListStatus status = CreateListStatus.content;

  TextEditingController controllerObj = TextEditingController();
  TextEditingController controllerLog = TextEditingController();
  TextEditingController controllerNum = TextEditingController();
  String code = '';
  String address = '';
  String number = '';

  List<ObjectDeliveryDto> objects = [];
  final focusObjetoNode = FocusNode();
  final focusLogradouroNode = FocusNode();
  final focusNumeroNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  final DBHelper dbHelper;

  CreateListViewModel({required this.dbHelper});

  Future<void> refreshList() async {
    try {
      DLLogger.i('refreshList try get objects from db');
      objects = await dbHelper.getObjects();
      notifyListeners();
    } catch (error, stackTrace) {
      DLLogger.e('Fail to get objects from db', error: error, stackTrace: stackTrace);
    }
  }

  clearFields() {
    DLLogger.i('clear fields');
    controllerObj.clear();
    controllerLog.clear();
    controllerNum.clear();
  }

  Future<void> save() async {
    try {
      _emitSaving();

      if (_validate()) {
        DLLogger.i('valid!');
        formKey.currentState!.save();
        await _save();
        clearFields();
        _emitContent();
      }
    } catch (error, stackTrace) {
      DLLogger.e('Fail to save', error: error, stackTrace: stackTrace);
    }
  }

  _validate() {
    DLLogger.i('validate');
    return formKey.currentState != null && formKey.currentState!.validate();
  }

  Future<void> _save() async {
    ObjectDeliveryDto obj = ObjectDeliveryDto(code: code, address: address, number: number);
    DLLogger.i('save');
    await dbHelper.save(obj);
  }

  void _emitContent() {
    status = CreateListStatus.content;
    notifyListeners();
  }

  void _emitSaving() {
    status = CreateListStatus.saving;
    notifyListeners();
  }

  void _emitError() {
    status = CreateListStatus.error;
    notifyListeners();
  }
}
