import 'package:flutter/material.dart';

const Color blueLight = Color.fromRGBO(163, 196, 243, 1);
const Color purpleLight = Color.fromRGBO(207, 186, 240, 1);
const Color purpleStrong = Color.fromRGBO(113, 97, 239, 1);
const Color orangeLight = Color.fromRGBO(253, 228, 207, 1);
const Color pinkStrong = Color.fromRGBO(255, 93, 143, 1);
const Color blue1 = Color.fromRGBO(144, 219, 244, 1);
const Color blue2 = Color.fromRGBO(142, 236, 245, 1);
const Color yellowLight = Color.fromRGBO(251, 248, 204, 1);
const Color white = Colors.white;
const Color black = Colors.black;

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
