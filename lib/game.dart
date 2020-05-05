import 'dart:ui';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flamerpg/components/bullets.dart';
import 'package:flamerpg/components/enemy.dart';
import 'package:flamerpg/const.dart';
import 'package:flamerpg/redux/actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:redux/redux.dart';
import 'components/player.dart';
import "./main.dart";
import 'redux/store.dart';

class FlameRPGGame extends BaseGame {
  Store<AppState> store;
  double leftEnemySpanX;
  Size screenSize;
  Player player;
  Image img;
  List<Bullet> bullets;
  List<Bullet> enemybullets;
  List<Enemy> enemies;
  int clock;
  bool won;

  FlameRPGGame(this.screenSize, this.store){
    initialize();
  }

  void initialize() async {
    resize(screenSize);
    img = await Flame.images.load(kIsWeb ? 'background (1).png' : 'background (2).png');
    
    //Centering with screenSize on Android causes bug where player is rendered offscreen.
    //Probably caused by the screen rotation.
    player = Player(this, Offset(playerStartX(screenSize.width), playerStartY(screenSize.height)));
    bullets = [];
    enemybullets = [];
    //Keep at a fixed x
    enemies = (store.state.level > 14) ? [Enemy(this, Offset(enemyStartX(screenSize.width, 0), enemyStartY(screenSize.height))), Enemy(this, Offset(enemyStartX(screenSize.width - player.player.width, 1), enemyStartY(screenSize.height)))] : [Enemy(this, Offset(enemyStartX(screenSize.width, 0), enemyStartY(screenSize.height)))];
    clock = 0;
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  void onTapUp(TapUpDetails d) {
    player.onTapUp(d);
  }


  void render(Canvas canvas) {
    var paint = Paint()..color = Color(0xffffffff);
    var rect = Rect.fromLTWH(0.0, 0.0, img.width.toDouble(), img.height.toDouble());
    var rect2 = Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height);
    canvas.drawImageRect(img, rect, rect2, paint);

    //Canvas save and restoring is used to render multiple elements

    bullets.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
    enemybullets.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
    enemies.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
    canvas.save();
    player.render(canvas);
    canvas.restore();
  }

  bool collision(SpriteComponent a1, AnimationComponent a2){
    return (
      a1.x < a2.x + a2.width &&
      a1.x + a1.width > a2.x &&
      a1.y < a2.y +  a2.height &&
      a1.y + a1.height > a2.y
    );
  }


  void update(double t) {
    clock += 1;
    player.update(t);
    bullets.forEach((element) {
      element.update(t);
      enemies.forEach((enemy) { 
        if(collision(element.bullet, enemy.player)){
          if(!enemy.dead && !player.dead){
            enemy.dead = true;
            enemy.deadAnim(enemy.lastDirRight);
          }
        }
      });
    });
    enemybullets.forEach((element) {
      element.update(t);
      if(collision(element.bullet, player.player)){
        int deadEnemies = 0;
        enemies.forEach((element) => (element.dead) ? deadEnemies++ : null);
        if(!player.dead && deadEnemies != enemies.length){
          player.dead = true;
          player.deadAnim(player.lastDirRight); 
          int lives = store.state.lives - 1;
          store.dispatch(SetLivesAction(lives));
          if(lives + store.state.powerUps.extraLives == 0)
            store.dispatch(SetWinAction(WinState.Lost));
          else{
            Future.delayed(Duration(seconds: 2), (){
              player.player.width = playerWidth;
              player.dead = false;
              player.idleAnim(player.lastDirRight); 
              player.player.x = playerStartX(screenSize.width);
              player.player.y = playerStartY(screenSize.height);
              enemies.forEach((element) {
                element.dead = false;
                element.player.width = playerWidth;
                element.player.y = screenSize.height * 0.2;
              });
            });
          }
        }
        enemies.forEach((i) { 
          if(!i.dead)
            i.idleAnim(i.lastDirRight);
        });
      }
    });
    int deadctr = 0;
    enemies.forEach((element) {
      element.update(t, clock);
      if(element.dead)
        deadctr++;
        
      //If not close, move
      if((player.moveTo.dy.toInt()-element.player.y.toInt()).abs() > 10 && !player.dead && !element.attacking && !element.dead){
        element.move(Offset(element.player.x + element.player.width / 2, player.player.y + player.player.height));
      }
    });
    if(deadctr == enemies.length){
      store.dispatch(SetWinAction(WinState.Won));
    }
    bullets.removeWhere((element) => (element.bullet.x < 0 || element.bullet.x > screenSize.width));
    enemybullets.removeWhere((element) => (element.bullet.x < 0 || element.bullet.x > screenSize.width));
  }
}