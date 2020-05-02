import 'dart:ui';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flamerpg/components/bullets.dart';
import 'package:flamerpg/const.dart';
import 'package:flamerpg/game.dart';
import 'package:flutter/gestures.dart';

class Enemy {
  final FlameRPGGame game;
  Animation playerAnimation;
  AnimationComponent player;
  int difficulty;
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

  Enemy(this.game, this.difficulty, Offset center) {
    idleSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('enemy/idle/Idle ($i).png')).toList();
    player = AnimationComponent(playerWidth, playerHeight, Animation.spriteList(idleSprites, loop: true, stepTime: 0.1));
    idleRevSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('enemy/idle/Idle ($i) Flip.png')).toList();
    deadSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('enemy/dead/Dead ($i).png')).toList();
    deadRevSprites = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) => new Sprite('enemy/dead/Dead ($i) Flip.png')).toList();
    runSprites = [1, 2, 3, 4, 5, 6, 7, 8].map((i) => new Sprite('enemy/run/Run ($i).png')).toList();
    runRevSprites = [1, 2, 3, 4, 5, 6, 7, 8].map((i) => new Sprite('enemy/run/Run ($i) Flip.png')).toList();
    attackSprites = [1, 2, 3, 4].map((i) => new Sprite('enemy/shoot/Shoot ($i).png')).toList();
    attackRevSprites = [1, 2, 3, 4].map((i) => new Sprite('enemy/shoot/Shoot ($i) Flip.png')).toList();
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

  void update(double t, int clock) {
    player.update(t);
    if(run){
      double x = player.x, y = player.y;
      x += diffX;
      y += diffY;
      if(game.player.dead){
        run = false;
        idleAnim(lastDirRight);
      }
      else if(dead){
        run = false;
      }
      else {
        //Round for better stopping conditions at the borders
        if(double.parse((x - moveTo.dx).abs().toStringAsPrecision(2)) <= double.parse(diffX.abs().toStringAsPrecision(2))){
          diffX = 0;
        }
        if(double.parse((y - moveTo.dy).abs().toStringAsPrecision(2)) <= double.parse(diffY.abs().toStringAsPrecision(2))){
          diffY = 0;
        }
        if(diffX == 0 && diffY == 0){
          setIdle = true;
          run = false;
          attackAnim(game.player.player.x - player.x >= 0);
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
      int clockAttackAnim = (60 - difficulty * 5 > 20) ? 60 - difficulty * 5 : 20;
      if(clock % clockAttackAnim == 1 && !run && !game.player.dead && !dead){
        attackAnim(game.player.player.x - player.x >= 0);
      }
      diffX = 0;
      diffY = 0;
    }
  }

  void attackAnim(bool right){
    if(attacking || dead)
      return;
    attacking = true;
    double attackDuration = (800.0 - difficulty * 50 > 200) ? (800.0 - difficulty * 50) : 400;
    player.animation = Animation.spriteList(right ? attackSprites : attackRevSprites, loop: true, stepTime: attackDuration/4);
    run = false;
    Future.delayed(Duration(milliseconds: (attackDuration~/2)), (){ 
      Bullet bullet = Bullet(game, lastDirRight, true, player.x + player.width * (lastDirRight ? 1.1 : -0.5), player.y + player.height * 0.35);
      game.enemybullets.add(bullet);
      Future.delayed(Duration(milliseconds: (attackDuration~/2)), (){ 
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
    if(run)
      return;
    player.animation = Animation.spriteList(right ? runSprites : runRevSprites, loop: true, stepTime: 0.1);
    run = true;
  }

  void deadAnim(bool right){
    player.animation = Animation.spriteList(right ? deadSprites : deadRevSprites, loop: false, stepTime: 0.1);  
    player.width = playerWidth * 1.7;
    player.x += lastDirRight ? 15 : -15;
  }
  
  void move(Offset move){
    moveTo = Offset(move.dx - player.width / 2, move.dy - player.height);

    //Increase enemy speed with each difficulty
    var speed = 4.0 + difficulty / 5;
    bool reverseX = moveTo.dx - player.x > 0;
    bool reverseY = moveTo.dy - player.y > 0;
    diffX = speed * (reverseX ? 1 : -1);
    diffY = speed * (reverseY ? 1 : -1);
    diffX = speed * ((moveTo.dx - player.x).abs() / ((moveTo.dx - player.x).abs() + (moveTo.dy - player.y).abs())) * (reverseX ? 1 : -1);
    diffY = speed * ((moveTo.dy - player.y).abs() / ((moveTo.dx - player.x).abs() + (moveTo.dy - player.y).abs())) * (reverseY ? 1 : -1);
    lastDirRight = game.player.player.x - player.x > 0;
    runAnim(lastDirRight);
  }
}