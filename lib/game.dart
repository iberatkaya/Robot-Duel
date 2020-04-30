import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'components/enemy.dart';

class FlameRPGGame extends Game {
  Size screenSize;
  double tileSize;
  Enemy enemy;

  FlameRPGGame(){
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    enemy = Enemy(this, Offset(screenSize.width * 0.5, screenSize.height * 0.8), tileSize, tileSize);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    super.resize(size);
  }

  void onTapUp(TapUpDetails d) {
    // handle taps here
    enemy.onTapUp(d);
  }


  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff00f000);
    canvas.drawRect(bgRect, bgPaint);
    enemy.render(canvas);
  }

  void update(double t) {
    // TODO: implement update
    enemy.update(t);
  }
}