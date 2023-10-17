import 'package:flutter/material.dart';

class BookMark {
  final String id;
  String title;
  String description;
  Color color;

  BookMark({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
  });

  factory BookMark.fromValues({required String id, required String title, required String description, required int colorValue}) {
    return BookMark(id: id, title: title, description: description, color: getColorFromValue(colorValue));
  }

  static Color getColorFromValue(int colorValue) {
    return colors.firstWhere((element) => element.value == colorValue, orElse: () => Colors.red);
  }

  static List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];
}
