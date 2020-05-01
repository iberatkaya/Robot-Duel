
import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flamerpg/game.dart';
import 'package:flamerpg/components/player.dart';

class Bullet {
  FlameRPGGame game;
  SpriteComponent bullet;
  bool dirRight;

  Bullet(this.game, this.dirRight, double x, double y){
    bullet = SpriteComponent.rectangle(28, 8, "beam.png");
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
    bullet.setByPosition(Position(dirRight ? 1 + bullet.x : -1 + bullet.x, bullet.y));
  }
}