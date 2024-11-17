import 'package:flutter/material.dart';

Decoration monsterHpBarDecoration = BoxDecoration(
    //color: Color.fromRGBO(78, 78, 78, 1),
    border: Border(
        top: BorderSide(color: Color.fromRGBO(212, 0, 0, 1).withOpacity(0.4)),
        bottom:
            BorderSide(color: Color.fromRGBO(212, 0, 0, 1).withOpacity(0.4))),
    //borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
          blurRadius: 5,
          spreadRadius: 0,
          color: Color.fromRGBO(212, 0, 0, 1).withOpacity(0.6))
    ]);
