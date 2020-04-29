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
    if(moveTo.dx - enemyRect.width / 2 <= 0)
      center = Offset(enemyRect.width / 2, moveTo.dy);
    if(moveTo.dy - enemyRect.height / 2 <= 0)
      center = Offset(moveTo.dx, enemyRect.height / 2);
    if(moveTo.dx + enemyRect.width / 2 >= game.screenSize.width)
      center = Offset(game.screenSize.width - enemyRect.width / 2, moveTo.dy);
    if(moveTo.dy + enemyRect.height / 2 >= game.screenSize.height)
      center = Offset(moveTo.dx, game.screenSize.height - enemyRect.height / 2);
    return center;
  }

  void update(double t) {
    if(enemyRect.center.dx != moveTo.dx || enemyRect.center.dy != moveTo.dy){
      moveTo = bound(moveTo);
      enemyRect = Rect.fromCenter(center: moveTo, width: enemyRect.width, height: enemyRect.height);
    }
  }

  void onTapDown(TapDownDetails d) {
    moveTo = d.globalPosition;
  }
}