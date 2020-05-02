import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'const.dart';
import 'game.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  if (!kIsWeb) {
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);
  }
  var size = await Flame.util.initialDimensions();
  FlameRPGGame game = FlameRPGGame(size);
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
  for(int i=1; i<=10; i++){
    imgs.add("player/dead/Dead ($i).png");
    imgs.add("player/dead/Dead ($i) Flip.png");
    imgs.add("enemy/dead/Dead ($i).png");
    imgs.add("enemy/dead/Dead ($i) Flip.png");
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
  imgs.add("beam.png");
  imgs.add("beamred.png");
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

  FlameRPGGame game;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool playing = true;
  int difficulty = 1;

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
              left: MediaQuery.of(context).size.width / 3,
              bottom: 12,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: DropdownButton<int>(
                  style: TextStyle(color: Colors.white),
                  value: difficulty,
                  items: [
                    for(int i=1; i<=10; i++) DropdownMenuItem(child: Text(i.toString(), style: TextStyle(color: Colors.black)), value: i,),
                  ], 
                  onChanged: (val){
                    widget.game.difficulty = val;
                    setState(() {
                      difficulty = val;
                    });
                  }
                ),
              )
            ),
            Positioned(
              left: 2 * MediaQuery.of(context).size.width / 3,
              bottom: 12,
              child: IconButton(
                icon: Icon(Icons.refresh, size: 32, color: Colors.white,),
                onPressed: (){
                  widget.game.player.dead = false;
                  widget.game.player.player.width = playerWidth;
                  widget.game.player.idleAnim(widget.game.player.lastDirRight);
                  widget.game.enemies.forEach((element) {
                    element.dead = false;
                    element.player.width = playerWidth;
                    element.idleAnim(element.lastDirRight);
                  });
                },
              )
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: IconButton(
                icon: Icon(Icons.crop_square, size: 32, color: Colors.white),
                onPressed: () {
                  if(!widget.game.player.dead)
                    widget.game.player.attackAnim(widget.game.player.lastDirRight);
                },
              ),
            ),
          ],
        ),
      );
  }
}