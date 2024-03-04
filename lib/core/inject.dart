import 'package:get_it/get_it.dart';
import 'package:lista_de_entrega_barcode/db/db_helper.dart';
import 'package:logger/logger.dart';

GetIt inject = GetIt.instance;

setupInjection() async {
  await inject.reset();

  inject.registerLazySingleton<DBHelper>(() => DBHelper());
  inject.registerLazySingleton<Logger>(() => Logger(printer: inject<PrettyPrinter>()));
  inject.registerLazySingleton<PrettyPrinter>(() => PrettyPrinter());
}
