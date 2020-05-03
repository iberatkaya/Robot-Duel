import 'dart:math';
import 'package:flutter/foundation.dart';

const production = true;

const factor = kIsWeb ? 2.5 : 1.5;
const actualWidthMin = 30.0;
const actualHeightMin = 47.0;
const playerWidth = actualWidthMin * factor;
const playerHeight = actualHeightMin * factor;

double playerStartX(double width) {
  return width  * 0.5;
}
double playerStartY(double height) {
  Random mynum = Random();
  int thenum = mynum.nextInt((height * 0.15).toInt());
  bool pos = mynum.nextBool();
  return height * 0.5 + thenum * (pos ? 1 : -1);
}
double enemyStartX(double width, int id) {
  if(id == 0)
    return width * 0.05;
  else if(id == 1)
    return width * 0.95;
  else
    throw "Wrong id";
}
double enemyStartY(double height) {
  Random mynum = Random();
  int thenum = mynum.nextInt((height * 0.2).toInt());
  bool pos = mynum.nextBool();
  return height * 0.5 + thenum * (pos ? 1 : -1);
}