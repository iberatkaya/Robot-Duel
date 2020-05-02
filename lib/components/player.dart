import 'dart:ui';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flamerpg/components/bullets.dart';
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
  bool lastDirRight;
  bool attacking;
  bool dead;
  List<Sprite> idleSprites;
  List<Sprite> idleRevSprites;
  List<Sprite> attackSprites;
  List<Sprite> attackRevSprites;
  List<Sprite> runSprites;
  List<Sprite> runRevSprites;
  List<Sprite> deadSprites;
  List<Sprite> deadRevSprites;

  Player(this.game, Offset center) {
    idleSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/idle/Idle ($i).png')).toList();
    player = AnimationComponent(playerWidth, playerHeight, Animation.spriteList(idleSprites, loop: true, stepTime: 0.1));
    idleRevSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/idle/Idle ($i) Flip.png')).toList();
    deadSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/dead/Dead ($i).png')).toList();
    deadRevSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('player/dead/Dead ($i) Flip.png')).toList();
    runSprites = [1, 2, 3, 4, 5, 6, 7, 8].map((i) => new Sprite('player/run/Run ($i).png')).toList();
    runRevSprites = [1, 2, 3, 4, 5, 6, 7, 8].map((i) => new Sprite('player/run/Run ($i) Flip.png')).toList();
    attackSprites = [1, 2, 3, 4].map((i) => new Sprite('player/shoot/Shoot ($i).png')).toList();
    attackRevSprites = [1, 2, 3, 4].map((i) => new Sprite('player/shoot/Shoot ($i) Flip.png')).toList();
    player.setByPosition(Position.fromOffset(center));
    dead = false;
    moveTo = center; 
    diffX = 0;
    diffY = 0;
    run = false;
    setIdle = false;
    lastDirRight = true;
    attacking = false;
  }

  void render(Canvas c) {
    player.render(c);
  }

  void update(double t) {
    player.update(t);
    if(run){
      if(dead){
        run = false;
      }
      else {
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
    }
    else{
      if(setIdle && !dead){
        idleAnim(lastDirRight);
        setIdle = false;
      }
      diffX = 0;
      diffY = 0;
    }
  }

  void attackAnim(bool right){
    if(attacking)
      return;
    attacking = true;
    player.animation = Animation.spriteList(right ? attackSprites : attackRevSprites, loop: true, stepTime: 0.2);
    run = false;
    Future.delayed(Duration(milliseconds: 400), (){ 
      Bullet bullet = Bullet(game, lastDirRight, false, player.x + player.width * (lastDirRight ? 1.1 : -0.5), player.y + player.height * 0.35);
      game.bullets.add(bullet);
      Future.delayed(Duration(milliseconds: 400), (){ 
        if(!run && !dead){
          idleAnim(lastDirRight);
        }
        attacking = false;  
      });
    });
  }

  void idleAnim(bool right){
    player.animation = Animation.spriteList(right ? idleSprites : idleRevSprites, loop: true, stepTime: 0.1);  
  }

  void runAnim(bool right){
    player.animation = Animation.spriteList(right ? runSprites : runRevSprites, loop: true, stepTime: 0.1);
    run = true;
  }

  void deadAnim(bool right){
    player.animation = Animation.spriteList(right ? deadSprites : deadRevSprites, loop: false, stepTime: 0.1);  
    player.width = playerWidth * 1.7;
    player.x += lastDirRight ? 15 : -15;
  }

  void onTapUp(TapUpDetails d) {
    if(dead)
      return;
    moveTo = Offset(d.localPosition.dx - player.width / 2, d.localPosition.dy - player.height);
    var speed = 5.0;
    print(moveTo);
    bool reverseX = moveTo.dx - player.x > 0;
    bool reverseY = moveTo.dy - player.y > 0;
    diffX = speed * (reverseX ? 1 : -1);
    diffY = speed * (reverseY ? 1 : -1);
    diffX = speed * ((moveTo.dx - player.x).abs() / ((moveTo.dx - player.x).abs() + (moveTo.dy - player.y).abs())) * (reverseX ? 1 : -1);
    diffY = speed * ((moveTo.dy - player.y).abs() / ((moveTo.dx - player.x).abs() + (moveTo.dy - player.y).abs())) * (reverseY ? 1 : -1);
    lastDirRight = reverseX;
    runAnim(lastDirRight);
  }
}