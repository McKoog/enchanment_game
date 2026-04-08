import 'package:flutter/material.dart';

Decoration enemyHpBarDecoration = BoxDecoration(
    //color: Color.fromRGBO(78, 78, 78, 1),
    border: Border(
        top: BorderSide(color: const Color.fromRGBO(212, 0, 0, 1).withValues(alpha: 0.4)),
        bottom: BorderSide(color: const Color.fromRGBO(212, 0, 0, 1).withValues(alpha: 0.4))),
    //borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(blurRadius: 5, spreadRadius: 0, color: const Color.fromRGBO(212, 0, 0, 1).withValues(alpha: 0.6))]);

Decoration characterHpBarDecoration = BoxDecoration(
    //color: Color.fromRGBO(78, 78, 78, 1),
    border:
        Border(top: BorderSide(color: Colors.green.shade900.withValues(alpha: 0.4)), bottom: BorderSide(color: Colors.green.shade900.withValues(alpha: 0.4))),
    //borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(blurRadius: 5, spreadRadius: 0, color: Colors.green.withValues(alpha: 0.6))]);
