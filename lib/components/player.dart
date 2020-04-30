import 'dart:ui';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flamerpg/const.dart';
import 'package:flamerpg/game.dart';
import 'package:flutter/gestures.dart';

class Player {
  final FlameRPGGame game;
  Rect playerRect;
  Paint playerPaint;
  Animation playerAnimation;
  AnimationComponent player;
  Offset moveTo;
  double diffX;
  double diffY;
  bool run;
  bool setIdle;

  Player(this.game, Offset center) {
//    playerRect = Rect.fromCenter(center: center, height: y, width: x);
//    playerPaint = Paint();
//    playerPaint.color = Color(0xffff0000);
    List<Sprite> sprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/idle/Idle ($i).png')).toList();
    player = AnimationComponent(playerWidth, playerHeight, Animation.spriteList(sprites, loop: true, stepTime: 0.2));
    moveTo = center; 
    diffX = 0;
    diffY = 0;
    run = false;
    setIdle = false;
  }


  void render(Canvas c) {
    player.render(c);
//    c.drawRect(playerRect, playerPaint);
  }

  void update(double t) {
    player.update(t);
    if(run){
      double x = player.x, y = player.y;
      x += diffX;
      y += diffY;
      if((x - moveTo.dx).abs() <= diffX.abs()){
        diffX = 0;
      }
      if((y - moveTo.dy).abs() <= diffY.abs()){
        diffY = 0;
      }
      if(diffX == 0 && diffY == 0){
        run = false;
        setIdle = true;
      }
      if(x <= 0){
        x = 0;
        moveTo = Offset(x, moveTo.dy);
      }
      if(y <= 0){
        y = 0;
        moveTo = Offset(moveTo.dx, y);
      }
      if(x + player.width >= game.screenSize.width){
        x = game.screenSize.width - player.width;
        moveTo = Offset(x, moveTo.dy);
      }
      if(y + player.height >= game.screenSize.height){
        y = game.screenSize.height - player.height;
        moveTo = Offset(moveTo.dx, y);
      }
      player.setByPosition(Position(x, y));
    }
    else{
      if(setIdle){
        List<Sprite> sprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/idle/Idle ($i).png')).toList();
        player.animation = Animation.spriteList(sprites, loop: true, stepTime: 0.2);
        setIdle = false;
      }
      diffX = 0;
      diffY = 0;
    }
  }

  void onTapUp(TapUpDetails d) {
    moveTo = Offset(d.globalPosition.dx - player.width / 2, d.globalPosition.dy - player.height);
    var speed = 5.0;
    bool reverseX = moveTo.dx - player.x > 0;
    bool reverseY = moveTo.dy - player.y > 0;
    diffX = speed * (reverseX ? 1 : -1);
    diffY = speed * (reverseY ? 1 : -1);
    run = true;
    List<Sprite> sprites = [1, 2, 3, 4, 5, 6, 7, 8].map((i) => new Sprite((reverseX ? 'player/run/Run ($i).png' : 'player/run/Run ($i) Flip.png'))).toList();
    player.animation = Animation.spriteList(sprites, loop: true, stepTime: 0.2);
  }
}