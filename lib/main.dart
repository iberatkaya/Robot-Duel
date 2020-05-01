import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  if (!kIsWeb) {
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);
  }
  FlameRPGGame game = FlameRPGGame();
  Flame.bgm.initialize();
  var tapper = TapGestureRecognizer();
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);
//  Flame.audio.load('music.mp3');
//  Flame.bgm.play('music.mp3');
  List<String> imgs = [];
  for(int i=1; i<=10; i++){
    imgs.add("player/idle/Idle ($i).png");
    imgs.add("player/idle/Idle ($i) Flip.png");
    imgs.add("enemy/idle/Idle ($i).png");
    imgs.add("enemy/idle/Idle ($i) Flip.png");
  }
  for(int i=1; i<=8; i++){
    imgs.add("player/run/Run ($i).png");
    imgs.add("player/run/Run ($i) Flip.png");
    imgs.add("enemy/run/Run ($i).png");
    imgs.add("enemy/run/Run ($i) Flip.png");
  }
  for(int i=1; i<=4; i++){
    imgs.add("player/shoot/Shoot ($i).png");
    imgs.add("player/shoot/Shoot ($i) Flip.png");
    imgs.add("enemy/shoot/Shoot ($i).png");
    imgs.add("enemy/shoot/Shoot ($i) Flip.png");
  }
  for(int i=1; i<=2; i++){
    imgs.add("background ($i).png");
  }
  await Flame.images.loadAll(imgs);

  runApp(
    MaterialApp(
      title: 'Flame RPG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(game),
      debugShowCheckedModeBanner: false,
    ),
  );
}


class App extends StatefulWidget {
  App(this.game);

  final FlameRPGGame game;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool playing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
             Positioned.fill(
                child: GestureDetector(
                  onTapUp: widget.game.onTapUp,
                  child: widget.game.widget,
                ),
             ),
            Positioned(
              left: 12,
              bottom: 12,
              child: IconButton(
                icon: Icon(playing ? Icons.music_note : Icons.close, size: 32, color: Colors.white70),
                onPressed: () {
                  if(playing)
                    Flame.bgm.pause();
                  else
                    Flame.bgm.resume();
                  setState(() {
                    playing = !playing;
                  });
                },
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: IconButton(
                icon: Icon(Icons.crop_square, size: 32, color: Colors.white),
                onPressed: () {
                  widget.game.player.attackAnim(widget.game.player.lastDirRight);
                },
              ),
            ),
          ],
        ),
      );
  }
}