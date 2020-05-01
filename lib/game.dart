import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flamerpg/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'components/player.dart';

class FlameRPGGame extends Game {
  Size screenSize;
  double tileSize;
  Player player;
  Image img;

  FlameRPGGame(){
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    img = await Flame.images.load(kIsWeb ? 'background (1).png' : 'background (2).png');
    player = Player(this, Offset(screenSize.width * 0.5 - playerWidth / 2, screenSize.height * 0.7 - playerHeight/2));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    super.resize(size);
  }

  void onTapUp(TapUpDetails d) {
    // handle taps here
    print("click");
    player.onTapUp(d);
  }


  void render(Canvas canvas) {
    var paint = Paint()..color = Color(0xffffffff);
    var rect = Rect.fromLTWH(0.0, 0.0, img.width.toDouble(), img.height.toDouble());
    var rect2 = Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height);
    canvas.drawImageRect(img, rect, rect2, paint);
    player.render(canvas);
  }

  void update(double t) {
    player.update(t);
  }
}