import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flamerpg/redux/actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'const.dart';
import 'game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'redux/reducers.dart';
import 'redux/store.dart';

void main() async {

  //Flame settings
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  if (!kIsWeb) {
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);
  }
  var size = await Flame.util.initialDimensions();

  //Shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int level = (prefs.getInt('level') ?? 1);
  bool audioOn = (prefs.getBool('audio') ?? true);
  store.dispatch(SetLevelAction(level));
  int difficulty = (level ~/ 3) + 1;

  FlameRPGGame game = FlameRPGGame(size, difficulty, store);
  var tapper = TapGestureRecognizer();
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);

  //Load audio
  Flame.bgm.initialize();
  Flame.audio.load('music.mp3');
  Flame.bgm.play('music.mp3');

  //Load images
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
      home: App(game, store, audioOn),
      debugShowCheckedModeBanner: false,
    ),
  );
}


class App extends StatefulWidget {
  App(this.game, this.store, this.audioOn);

  FlameRPGGame game;
  final Store<AppState> store;
  bool audioOn;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool startGame = false;

  @override
  Widget build(BuildContext context) {
    if(!startGame){
      return StoreProvider(
        store: widget.store,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
               Positioned.fill(
                  child: Image.asset("assets/images/background (1).png", fit: BoxFit.fill,),
               ),
               Padding(
                 padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                 child: Align(
                   alignment: Alignment.topCenter,
                   child: Container(
                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                     decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(24)),
                     child: Text("FlameRPG", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40, letterSpacing: 1.1, ),)
                    ),
                 ),
               ),
              Positioned(
                left: 12,
                bottom: 12,
                child: IconButton(
                  icon: Icon(widget.audioOn ? Icons.music_note : Icons.close, size: 32, color: Colors.white70),
                  onPressed: () {
                    if(widget.audioOn)
                      Flame.bgm.pause();
                    else
                      Flame.bgm.resume();
                    setState(() {
                      widget.audioOn = !widget.audioOn;
                    });
                  },
                ),
              ),
               Align(
                 alignment: Alignment.center,
                 child: FlatButton(
                  onPressed: (){
                    widget.game = FlameRPGGame(widget.game.size, (store.state.level ~/ 3) + 1, widget.game.store);
                    store.dispatch(SetWinAction(WinState.Playing));
                    setState(() {
                      startGame = true;
                    });
                  },
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  color: Colors.black26,
                  child: Text("Play", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40, letterSpacing: 1.1, ),)
                  ),
               )
            ]
          ),
        ),
      );
    }

    return StoreProvider(
      store: widget.store,
      child:  Scaffold(
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
              top: 12,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 32, color: Colors.white70),
                onPressed: () {
                  store.dispatch(SetWinAction(WinState.Playing));
                  setState(() {
                    startGame = false;
                  });
                },
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: IconButton(
                icon: Icon(widget.audioOn ? Icons.music_note : Icons.close, size: 32, color: Colors.white70),
                onPressed: () {
                  if(widget.audioOn)
                    Flame.bgm.pause();
                  else
                    Flame.bgm.resume();
                  setState(() {
                    widget.audioOn = !widget.audioOn;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 12),
                child: StoreConnector<AppState, int>(
                  converter: (store) => store.state.level,
                  builder: (context, level) {
                    return Text("Level: $level", style: TextStyle(color: Colors.white, fontSize: 24));    
                  }
                ),
              ) 
            ),
            Positioned(
              right: 20,
              bottom: 12,
              child: IconButton(
                icon: Icon(Icons.crop_square, size: 40, color: Colors.white),
                onPressed: () {
                  if(!widget.game.player.dead)
                    widget.game.player.attackAnim(widget.game.player.lastDirRight);
                },
              ),
            ),
            StoreConnector<AppState, WinState>(
              converter: (store) => store.state.win,
              distinct: true,
              onDidChange: (WinState win) async {
                if(win != WinState.Playing){
                  if(win == WinState.Won){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var level = store.state.level + 1;
                    await prefs.setInt('level', level);
                    widget.game.difficulty = (level ~/ 3) + 1;
                    store.dispatch(IncLevelAction());
                  }
                  Future.delayed(Duration(seconds: 7), (){
                    store.dispatch(SetWinAction(WinState.Playing));
                    widget.game.player.dead = false;
                    widget.game.player.player.width = playerWidth;
                    widget.game.player.idleAnim(widget.game.player.lastDirRight);
                    widget.game.enemies.forEach((element) {
                      element.dead = false;
                      element.player.width = playerWidth;
                      element.idleAnim(element.lastDirRight);
                    });
                  });
                }
              },
              builder: (context, win) {
                if(win != WinState.Playing)
                  return Align(
                    alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Colors.black26),
                        child: Text(win == WinState.Won ? "You won!" : "You Lost!", style: TextStyle(color: Colors.white, fontSize: 24)),
                      )
                    );
                return Container();
              }
            )
          ],
        ),
      ),
    );
  }
}