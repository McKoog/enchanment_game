import 'package:flutter/material.dart';

Decoration inventorySlotDecoration = BoxDecoration(
  color: const Color.fromRGBO(85, 85, 85, 1),
  border: const Border.fromBorderSide(
      BorderSide(
          color: Color.fromRGBO(130, 130, 130, 1),
          width: 2)
  ),
  borderRadius: BorderRadius.circular(15),
);

Decoration scrollEnchantSlotDecoration = BoxDecoration(
    color: const Color.fromRGBO(70, 70, 70, 1),
    border: const Border.fromBorderSide(
        BorderSide(
            color: Color.fromRGBO(160, 160, 160, 1),
            width: 2)
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 20,spreadRadius: 1,color:Color.fromRGBO(70, 70, 70, 1))]
);

Decoration scrollEnchantSlotSuccessDecoration = BoxDecoration(
    color: const Color.fromRGBO(70, 70, 70, 1),
    border: const Border.fromBorderSide(
        BorderSide(
            color: Color.fromRGBO(160, 160, 160, 1),
            width: 2)
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 40,spreadRadius: 20,color:Colors.yellow)]
);

Decoration scrollEnchantSlotFailedDecoration = BoxDecoration(
    color: const Color.fromRGBO(70, 70, 70, 1),
    border: const Border.fromBorderSide(
        BorderSide(
            color: Color.fromRGBO(160, 160, 160, 1),
            width: 2)
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 40,spreadRadius: 20,color:Colors.black)]
);