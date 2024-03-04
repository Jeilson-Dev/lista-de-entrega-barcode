import 'package:flutter/foundation.dart';
import 'package:lista_de_entrega_barcode/core/inject.dart';
import 'package:logger/logger.dart';

class DLLogger {
  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) inject<Logger>().d(message, error: error, stackTrace: stackTrace);
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) inject<Logger>().e(message, error: error, stackTrace: stackTrace);
  }

  static void f(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) inject<Logger>().f(message, error: error, stackTrace: stackTrace);
  }

  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) inject<Logger>().i(message, error: error, stackTrace: stackTrace);
  }

  static void t(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) inject<Logger>().t(message, error: error, stackTrace: stackTrace);
  }

  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) inject<Logger>().w(message, error: error, stackTrace: stackTrace);
  }
}
