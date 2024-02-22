import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_entrega_barcode/models/object_delivery_dto.dart';

class ObjectDeliveryItem extends StatelessWidget {
  final ObjectDeliveryDto object;
  const ObjectDeliveryItem({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(width: 15),
                  const Icon(CupertinoIcons.cube_box),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(object.code ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(width: 15),
                const Icon(
                  Icons.map,
                  color: Color(0xff000000),
                ),
                Expanded(
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: Text('${object.address}, ${object.number}')),
                ),
              ],
            ),
            Container(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
