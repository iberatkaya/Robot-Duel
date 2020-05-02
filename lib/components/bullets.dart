
import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flamerpg/game.dart';
import 'package:flamerpg/components/player.dart';
import 'package:flutter/foundation.dart';

class Bullet {
  FlameRPGGame game;
  SpriteComponent bullet;
  bool dirRight;
  bool enemyBullet;

  Bullet(this.game, this.dirRight, this.enemyBullet, double x, double y){
    bullet = SpriteComponent.rectangle(28, 8, enemyBullet ? "beamred.png" : "beam.png");
    bullet.setByPosition(Position(x, y));
  }

  void render(Canvas c){
    Paint p = Paint();
    p.color = Color(0xffff0000);
    bullet.render(c);
  }

  void update(double t){
    if(bullet.x < 0 || game.screenSize.width < bullet.x){
      bullet.destroy();
    }
    //Speed up bullets for web
    bullet.setByPosition(Position(bullet.x + game.screenSize.width * (kIsWeb ? 0.01 : 0.006) * (dirRight ? 1 : -1), bullet.y));
  }
}