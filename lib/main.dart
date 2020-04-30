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
    await flameUtil.setOrientation(DeviceOrientation.landscapeRight);
  }
  FlameRPGGame game = FlameRPGGame();
  Flame.bgm.initialize();
  var tapper = TapGestureRecognizer();
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);
  Flame.audio.load('music.mp3');
  Flame.bgm.play('music.mp3');
  List<String> playerimgs = [];
  for(int i=1; i<=10; i++){
    playerimgs.add("player/idle/Idle ($i).png");
  }
  for(int i=1; i<=8; i++){
    playerimgs.add("player/run/Run ($i).png");
    playerimgs.add("player/run/Run ($i) Flip.png");
  }
  await Flame.images.loadAll(playerimgs);

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
  print(playing);
    return Scaffold(
        body: Column(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.green,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(playing ? Icons.music_note : Icons.close, size: 24,),
                      onPressed: () {
                        if(playing)
                          Flame.bgm.pause();
                        else
                          Flame.bgm.resume();
                        setState(() {
                          playing = !playing;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.88),
              child: GestureDetector(
                onTapUp: widget.game.onTapUp,
                child: widget.game.widget,
              ),
            ),
          ],
        ),
      );
  }
}