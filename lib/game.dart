import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flamerpg/components/bullets.dart';
import 'package:flamerpg/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'components/player.dart';

class FlameRPGGame extends BaseGame {
  Size screenSize;
  double tileSize;
  Player player;
  Image img;
  List<Bullet> bullets;

  FlameRPGGame(){
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    img = await Flame.images.load(kIsWeb ? 'background (1).png' : 'background (2).png');
    player = Player(this, Offset(screenSize.width * 0.5 - playerWidth / 2, screenSize.height * 0.7 - playerHeight/2));
    bullets = [];
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
    canvas.save();
    player.render(canvas);
    canvas.restore();
  }

  void update(double t) {
    player.update(t);
    bullets.forEach((element) {
      element.update(t);
    });
    bullets.removeWhere((element) => (element.bullet.x < 0 || element.bullet.x > screenSize.width));
  }
}