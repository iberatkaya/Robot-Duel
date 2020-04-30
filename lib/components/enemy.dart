import 'dart:ui';
import 'package:flamerpg/game.dart';
import 'package:flutter/gestures.dart';

class Enemy {
  final FlameRPGGame game;
  Rect enemyRect;
  Paint enemyPaint;
  Offset moveTo;
  bool down;
  bool right;

  Enemy(this.game, Offset center, double x, double y){
    enemyRect = Rect.fromCenter(center: center, height: y, width: x);
    enemyPaint = Paint();
    enemyPaint.color = Color(0xffff0000);
    moveTo = center; 
    down = false;
    right = false;
  }

  void render(Canvas c) {
    c.drawRect(enemyRect, enemyPaint);
  }

  Offset bound(Offset center) {
    var x = center.dx;
    var y = center.dy;
    if(moveTo.dx - enemyRect.width / 2 <= 0)
      x = enemyRect.width / 2;
    if(moveTo.dy - enemyRect.height / 2 <= 0)
      y = enemyRect.height / 2;
    if(moveTo.dx + enemyRect.width / 2 >= game.screenSize.width)
      x = game.screenSize.width - enemyRect.width / 2;
    if(moveTo.dy + enemyRect.height / 2 >= game.screenSize.height)
      y = game.screenSize.height - enemyRect.height / 2;
    return Offset(x, y);
  }

  void update(double t) {
    if(enemyRect.center.dx != moveTo.dx || enemyRect.center.dy != moveTo.dy){
      moveTo = bound(moveTo);
      enemyRect = Rect.fromCenter(center: moveTo, width: enemyRect.width, height: enemyRect.height);
    }
  }

  void onTapUp(TapUpDetails d) {
    moveTo = d.globalPosition;
  }
}