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
  Animation playerAnimation;
  AnimationComponent player;
  Offset moveTo;
  double diffX;
  double diffY;
  bool run;
  bool setIdle;

  Player(this.game, Offset center) {
    List<Sprite> sprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/idle/Idle ($i).png')).toList();
    player = AnimationComponent(playerWidth, playerHeight, Animation.spriteList(sprites, loop: true, stepTime: 0.1));
    moveTo = center; 
    diffX = 0;
    diffY = 0;
    run = false;
    setIdle = false;
  }


  void render(Canvas c) {
    player.render(c);
  }

  void update(double t) {
    player.update(t);
    if(run){
      double x = player.x, y = player.y;
      x += diffX;
      y += diffY;
      
      //Round for better stopping conditions at the borders
      if(double.parse((x - moveTo.dx).abs().toStringAsPrecision(2)) <= double.parse(diffX.abs().toStringAsPrecision(2))){
        diffX = 0;
      }
      if(double.parse((y - moveTo.dy).abs().toStringAsPrecision(2)) <= double.parse(diffY.abs().toStringAsPrecision(2))){
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
        player.animation = Animation.spriteList(sprites, loop: true, stepTime: 0.1);
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
    diffX = speed * ((moveTo.dx - player.x).abs() / ((moveTo.dx - player.x).abs() + (moveTo.dy - player.y).abs())) * (reverseX ? 1 : -1);
    diffY = speed * ((moveTo.dy - player.y).abs() / ((moveTo.dx - player.x).abs() + (moveTo.dy - player.y).abs())) * (reverseY ? 1 : -1);

    run = true;
    List<Sprite> sprites = [1, 2, 3, 4, 5, 6, 7, 8].map((i) => new Sprite((reverseX ? 'player/run/Run ($i).png' : 'player/run/Run ($i) Flip.png'))).toList();
    player.animation = Animation.spriteList(sprites, loop: true, stepTime: 0.1);
  }
}