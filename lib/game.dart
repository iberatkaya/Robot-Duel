import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flamerpg/components/bullets.dart';
import 'package:flamerpg/components/enemy.dart';
import 'package:flamerpg/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'components/player.dart';

class FlameRPGGame extends BaseGame {
  double leftEnemySpanX;
  Size screenSize;
  double tileSize;
  Player player;
  Image img;
  int difficulty;
  List<Bullet> bullets;
  List<Bullet> enemybullets;
  List<Enemy> enemies;
  int clock;

  FlameRPGGame(this.screenSize){
    initialize();
  }

  void initialize() async {
    resize(screenSize);
    img = await Flame.images.load(kIsWeb ? 'background (1).png' : 'background (2).png');
    
    //Centering with screenSize on Android causes bug where player is rendered offscreen.
    //Probably caused by the screen rotation.
    player = Player(this, Offset(screenSize.height * 0.6 - playerHeight/2, screenSize.width * 0.5 - playerWidth / 2));
    print(player.player.x);
    print(player.player.y);
    bullets = [];
    difficulty = 1;
    enemybullets = [];
    //Keep at a fixed x
    leftEnemySpanX = 20 + screenSize.width * 0.05;
    enemies = [Enemy(this, difficulty, Offset(screenSize.height * 0.2 - playerHeight/2 - 60, leftEnemySpanX))];
    clock = 0;
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
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


  void update(double t) {
    clock += 1;
    player.update(t);
    bullets.forEach((element) {
      element.update(t);
    });
    enemybullets.forEach((element) {
      element.update(t);
    });
    enemies.forEach((element) {
      element.update(t, clock);

      //Delete later
      element.difficulty = difficulty;
      //If not close, move
      if((player.moveTo.dy.toInt()-element.player.y.toInt()).abs() > 10 && !element.attacking){
        element.move(Offset(leftEnemySpanX, player.player.y + player.player.height));
      }
    });
    bullets.removeWhere((element) => (element.bullet.x < 0 || element.bullet.x > screenSize.width));
  }
}