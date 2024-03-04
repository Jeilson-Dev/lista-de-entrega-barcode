import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/models/object_delivery_dto.dart';

class BarcodeObjectDeliveryItem extends StatelessWidget {
  final ObjectDeliveryDto object;
  const BarcodeObjectDeliveryItem({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 340,
          child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: object.code ?? '',
                        width: 300,
                        height: 100,
                      ),
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: object.address ?? '',
                        width: 300,
                        height: 100,
                      ),
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: object.number ?? '',
                        width: 300,
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
