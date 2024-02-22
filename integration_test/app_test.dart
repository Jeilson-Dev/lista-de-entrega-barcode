import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_de_entrega_barcode/core/inject.dart';
import 'package:lista_de_entrega_barcode/main.dart';

void main() {
  testWidgets('integration tests', (tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupInjection();
    await tester.pumpWidget(const MyApp());

    // open list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-list-key')));

    //open barcode list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('view-barcode-list-key')));

    //create new list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('create-new-list-key')));

    // navigate to list screen
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-list-key')));

    // navigate to barcode list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('view-barcode-list-key')));

    // navigate back to list screen
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('navigate-back-barcode-list-key')));

    // navigate back to list screen
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('navigate-back-list-screen-key')));

    final objects = List.generate(9, (index) => index);
    for (var item in objects) {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('object-key')), 'AA12345600${item}ZZ');

      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('address-key')), 'Rua abc ');

      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('number-key')), '$item');

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-key')));
    }

    // open list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-list-key')));

    //open barcode list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('view-barcode-list-key')));

    //create new list
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('create-new-list-key')));
  });
}
