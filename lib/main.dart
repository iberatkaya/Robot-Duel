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
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  }
  FlameRPGGame game = FlameRPGGame();
  Flame.bgm.initialize();
  var tapper = TapGestureRecognizer();
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);
  Flame.audio.load('music.mp3');
  Flame.bgm.play('music.mp3');

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
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(playing ? Icons.music_note : Icons.close),
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
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.9),
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