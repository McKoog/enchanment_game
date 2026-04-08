import 'package:flutter/material.dart';

final Decoration inventorySlotDecoration = BoxDecoration(
  color: const Color.fromRGBO(85, 85, 85, 1),
  border: const Border.fromBorderSide(BorderSide(color: Color.fromRGBO(130, 130, 130, 1), width: 2)),
  borderRadius: BorderRadius.circular(15),
);

final Decoration scrollEnchantSlotDecoration = BoxDecoration(
    color: const Color.fromRGBO(70, 70, 70, 1),
    border: Border.fromBorderSide(BorderSide(color: Colors.yellow.withValues(alpha: 0.5), width: 2)),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 20, spreadRadius: 1, color: Color.fromRGBO(70, 70, 70, 1))]);

final Decoration scrollEnchantSlotInsertedDecoration = BoxDecoration(
    color: Color.lerp(const Color.fromRGBO(70, 70, 70, 1), Colors.white, 0.2),
    border: Border.fromBorderSide(BorderSide(color: Colors.yellow.withValues(alpha: 0.5), width: 1)),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 20, spreadRadius: 5, color: Colors.white)]);

final Decoration scrollEnchantProgressSlotDecoration = BoxDecoration(
    color: const Color.fromRGBO(70, 70, 70, 1),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(blurRadius: 25, spreadRadius: 2.5, color: Colors.orange.shade800.withValues(alpha: 0.25))]);

final Decoration scrollEnchantSlotSuccessDecoration = BoxDecoration(
    color: Color.lerp(const Color.fromRGBO(70, 70, 70, 1), Colors.yellow.shade200, 0.15),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1, color: Colors.yellow)]);

final Decoration scrollEnchantSlotFailedDecoration = BoxDecoration(
    color: Color.lerp(const Color.fromRGBO(70, 70, 70, 1), Colors.black, 0.15),
    border: Border.fromBorderSide(BorderSide(color: Colors.black.withValues(alpha: 0.3), width: 2)),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 15, spreadRadius: 5, color: Colors.black)]);
