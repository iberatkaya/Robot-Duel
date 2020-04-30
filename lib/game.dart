import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flamerpg/const.dart';
import 'package:flutter/gestures.dart';

import 'components/player.dart';

class FlameRPGGame extends Game {
  Size screenSize;
  double tileSize;
  Player player;

  FlameRPGGame(){
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    player = Player(this, Offset(screenSize.width * 0.5 - playerWidth / 2, screenSize.height * 0.78 - playerHeight/2));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    super.resize(size);
  }

  void onTapUp(TapUpDetails d) {
    if(d.globalPosition.dy <= screenSize.height * 0.13){
      return;
    }
    // handle taps here
    player.onTapUp(d);
  }


  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff00f000);
    canvas.drawRect(bgRect, bgPaint);
    player.render(canvas);
  }

  void update(double t) {
    player.update(t);
  }
}