import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/list.dart';
import 'package:flutter_app/Bakerys/Weichardt/screens/shopInventoryScrenn.dart';

class Bakery {
  final String link;
  final String title;
  final int color;

  Bakery({this.link, this.title, this.color});
}

final bk = <Bakery>[
  Bakery(
    title: "Weichhardt_Brot",
    link: "assets/images/Weichardt.jpg",
    color: 0xFFBCAAA4,
  ),
  Bakery(
    title: "Bakery B",
    link: "assets/images/Beumer.jpg",
    color: 0xFFE83835,
  ),
  Bakery(
    title: "Bakery C",
    link: "assets/images/Christa.jpg",
    color: 0xFF354C6C,
  ),
];
