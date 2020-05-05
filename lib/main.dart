import 'package:firebase_admob/firebase_admob.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flamerpg/ads.dart';
import 'package:flamerpg/redux/actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'components/enemy.dart';
import 'const.dart';
import 'game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int maxLevel = (prefs.getInt('maxLevel') ?? 1);
  int speedbuff = (prefs.getInt('speedbuff') ?? 0);
  int attackbuff = (prefs.getInt('attackbuff') ?? 0);
  int extralives = (prefs.getInt('extralives') ?? 0);
  int gold = (prefs.getInt('gold') ?? 0);
  PowerUp mypowerup = PowerUp(speedbuff, attackbuff, extralives);
  bool audioOn = (prefs.getBool('audio') ?? true);
  store.dispatch(SetMaxLexelAction(maxLevel));
  store.dispatch(SetPowerUpAction(mypowerup));
  store.dispatch(SetGoldAction(gold));

  FlameRPGGame game = FlameRPGGame(size, store);
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
      title: 'Robot Duel',
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
  FocusNode myFocusNode = FocusNode();
  bool shownRewardAd = false;
  bool viewedAnAd = false;
  MobileAdTargetingInfo adInfo = MobileAdTargetingInfo(keywords: ["robot", "game", "battle"]);
  bool lockBack = false;
  bool viewShop = false;
  PowerUp mypowerups = PowerUp(0, 0, 0);
  int cost = 0;
  List<InterstitialAd> intAd = [];
  bool viewHelp = false;

  @override
  initState(){
    super.initState();
    if(!kIsWeb){
      FirebaseAdMob.instance.initialize(appId: appId).then((value) => RewardedVideoAd.instance.load(adUnitId: production ? rewardedId : RewardedVideoAd.testAdUnitId, targetingInfo: adInfo)).then((value) {
        intAd.add(InterstitialAd(adUnitId: production ? interstitialId : InterstitialAd.testAdUnitId));
        intAd[0].load();
      });
      RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        if (event == RewardedVideoAdEvent.rewarded) {
          store.dispatch(SetLivesAction(3));
          restart(4, isNextLexel: false);
        }
      };
    }
  }

  Widget livesView(int lives){
    List<Icon> hearts = [];
    for(int i=0; i<lives; i++){
      hearts.add(Icon(Icons.favorite, size: 24, color: Colors.red));
    }

    return Row(
        children: hearts
      );
  }

  restart(int seconds, {bool isNextLexel}) async {
    setState(() {
      lockBack = true;
    });
    await Future.delayed(Duration(seconds: seconds), (){
      store.dispatch(SetWinAction(WinState.Playing));
      if(!isNextLexel) 
        store.dispatch(SetLivesAction(3));
      widget.game.enemybullets = [];
      widget.game.bullets = [];
      widget.game.player.dead = false;
      widget.game.player.player.x = playerStartX(widget.game.screenSize.width);
      widget.game.player.player.y = playerStartY(widget.game.screenSize.height);
      widget.game.player.player.width = playerWidth;
      widget.game.player.diffX = 0;
      widget.game.player.diffY = 0;
      widget.game.player.idleAnim(widget.game.player.lastDirRight);
      if(store.state.level == 15 && widget.game.enemies.length != 2){
        widget.game.enemies.add(Enemy(widget.game, Offset(widget.game.screenSize.width * 0.95 - widget.game.player.player.width, widget.game.screenSize.height * 0.25)));
      }
      widget.game.enemies.forEach((element) {
        element.dead = false;
        element.player.y = enemyStartY(widget.game.screenSize.height);
        element.player.width = playerWidth;
        element.idleAnim(element.lastDirRight);
      });
      setState(() {
        lockBack = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if(viewHelp){
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            viewHelp = false;
          });
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset("assets/images/background (1).png", fit: BoxFit.fill,),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 32, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      viewHelp = false;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.black26,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, 
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Text("Fight enemy robots in Robot Duel! Gain gold with each enemy robot kill. Spend your gold to upgrade your character. The enemy robots get stronger each level. At level 5 another enemy robot spawns. As the levels get higher, the robot kills give more gold.", style: TextStyle(color: Colors.white, fontSize: 20),)
                      ),
                    )
                  )
                )
              )
            ]
          ),
        )
      );
    }


    if(viewShop){
      return StoreProvider(
        store: widget.store,
        child: WillPopScope(
          onWillPop: () async {
            setState(() {
              viewShop = false;
            });
            return false;
          },
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset("assets/images/background (1).png", fit: BoxFit.fill,),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 32, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        viewShop = false;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.black26,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, 
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child:  Column(
                          children: <Widget>[
                            Container(child: Text("Shop", style: TextStyle(color: Colors.white, fontSize: 26)), margin: EdgeInsets.symmetric(vertical: 12),),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  Text("Attack Speed:", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  Flexible(child: Container(margin: EdgeInsets.symmetric(horizontal: 24), child: LinearProgressIndicator(value: mypowerups.attackSpeed != 0 ? mypowerups.attackSpeed / 10 : 0.02,))),
                                ],
                              ),
                            ),
                            if(mypowerups.attackSpeed != 10)
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black38),
                                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                                      child: Text("Cost: ${30 * (mypowerups.attackSpeed + 1)}", style: TextStyle(color: Colors.white, fontSize: 14))
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      color: Color.fromRGBO(155, 20, 20, 0.7),
                                      onPressed: (){
                                        if(mypowerups.attackSpeed == 10)
                                          return;
                                        setState(() {
                                          cost += 30 * (mypowerups.attackSpeed + 1);
                                          mypowerups.attackSpeed += 1;
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text("Upgrade", style: TextStyle(color: Colors.white, fontSize: 14)),
                                          Icon(Icons.add, color: Colors.white, size: 14),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  Text("Movement Speed:", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  Flexible(child: Container(margin: EdgeInsets.symmetric(horizontal: 24), child: LinearProgressIndicator(value: mypowerups.movSpeed != 0 ? mypowerups.movSpeed / 10 : 0.02,))),
                                ],
                              ),
                            ),
                            if(mypowerups.movSpeed != 10)
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black38),
                                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                                      child: Text("Cost: ${30 * (mypowerups.movSpeed + 1)}", style: TextStyle(color: Colors.white, fontSize: 14))
                                    ),
                                    FlatButton( 
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      color: Color.fromRGBO(155, 20, 20, 0.7),
                                      onPressed: (){
                                        if(mypowerups.movSpeed == 10)
                                          return;
                                        setState(() {
                                          cost += 30 * (mypowerups.movSpeed + 1);
                                          mypowerups.movSpeed += 1;
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text("Upgrade", style: TextStyle(color: Colors.white, fontSize: 14)),
                                          Icon(Icons.add, color: Colors.white, size: 14),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  Text("Extra Lives:", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  Flexible(child: Container(margin: EdgeInsets.symmetric(horizontal: 24), child: LinearProgressIndicator(value: mypowerups.extraLives != 0 ? mypowerups.extraLives / 3 : 0.02,))),
                                ],
                              ),
                            ),
                            if(mypowerups.extraLives != 3)
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black38),
                                        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                                        child: Text("Cost: 400", style: TextStyle(color: Colors.white, fontSize: 14))
                                      ),
                                    FlatButton( 
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      color: Color.fromRGBO(155, 20, 20, 0.7),
                                      onPressed: (){
                                        if(mypowerups.extraLives == 3)
                                          return;
                                        setState(() {
                                          cost += 400;
                                          mypowerups.extraLives += 1;
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text("Upgrade", style: TextStyle(color: Colors.white, fontSize: 14)),
                                          Icon(Icons.add, color: Colors.white, size: 14),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: FlatButton(
                                    onPressed: () async {
                                      if(cost > store.state.gold){
                                        Fluttertoast.showToast(msg: "You do not have enough gold!");
                                        return;
                                      }
                                      int gold = store.state.gold;
                                      gold -= cost;
                                      store.dispatch(SetPowerUpAction(mypowerups));
                                      store.dispatch(SetGoldAction(gold));
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setInt("gold", gold);
                                      await prefs.setInt('speedbuff', mypowerups.movSpeed);
                                      await prefs.setInt('attackbuff', mypowerups.attackSpeed);
                                      await prefs.setInt('extralives', mypowerups.extraLives);
                                      setState(() {
                                        viewShop = false;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    color: Color.fromRGBO(25, 20, 200, 0.7),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Buy for $cost gold!  ", style: TextStyle(color: Colors.white, fontSize: 18)),
                                        Icon(Icons.store, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ),
                    ),
                  )
                )
              ]
            ),
          ),
        ),
      );
    }

    if(!startGame){
      return StoreProvider(
        store: widget.store,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
               Positioned.fill(
                  child: Image.asset("assets/images/background (1).png", fit: BoxFit.fill,),
               ),
               Container(
                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                 child: Align(
                   alignment: Alignment.topCenter,
                   child: Container(
                     padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                     decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.75), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white, width: 1)),
                     child: Text("Robot Duel", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 44, ),)
                    ),
                 ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: IconButton(
                  icon: Icon(Icons.help_outline, color: Colors.white70,),
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      viewHelp = true;
                    });
                  },
                )
              ),
              Positioned(
                right: 12,
                top: 12,
                child: StoreConnector<AppState, List>(
                  converter: (store) => [store.state.maxLevel, store.state.gold],
                  builder: (context, values) {
                    return Text("Max Level: ${values[0]}\nGold: ${values[1]}", style: TextStyle(color: Colors.white),);
                  },
                )
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: IconButton(
                  icon: Icon(Icons.store, size: 32, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      mypowerups = PowerUp(widget.store.state.powerUps.movSpeed, widget.store.state.powerUps.attackSpeed, widget.store.state.powerUps.extraLives);
                      cost = 0;
                      viewShop = true;
                    });
                  },
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: IconButton(
                  icon: Icon(widget.audioOn ? Icons.music_note : Icons.close, size: 28, color: Colors.white70),
                  onPressed: () async {
                    if(widget.audioOn)
                      Flame.bgm.pause();
                    else
                      Flame.bgm.resume();
                    setState(() {
                      widget.audioOn = !widget.audioOn;
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("audio", !widget.audioOn);
                  },
                ),
              ),
               Align(
                 alignment: Alignment.bottomCenter,
                 child: Container(
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white, width: 1)),
                   margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                   child: FlatButton(
                    onPressed: (){
                      widget.game = FlameRPGGame(Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height), widget.game.store);
                      store.dispatch(SetWinAction(WinState.Playing));
                      store.dispatch(SetLivesAction(3));
                      store.dispatch(SetLevelAction(1));
                      setState(() {
                        viewedAnAd = false;
                        startGame = true;
                      });
                    },
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    color: Color.fromRGBO(0, 0, 0, 0.75),
                    child: Text("Play", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 36, letterSpacing: 1.1, ),)
                    ),
                 ),
               )
            ]
          ),
        ),
      );
    }
    return StoreProvider(
      store: widget.store,
      child:  WillPopScope(
        onWillPop: () async {
          if(lockBack)
            return false;
          setState(() {
            startGame = false;
          });
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              if(kIsWeb)
                Positioned.fill(
                  child: RawKeyboardListener(
                    focusNode: myFocusNode,
                    autofocus: true,
                    onKey: (key){
                      if(widget.game.player.dead || widget.game.player.run)
                        return;
                      double speed = MediaQuery.of(context).size.height * 0.05 + store.state.powerUps.movSpeed * MediaQuery.of(context).size.height * 0.0025;
                      if(key.physicalKey == PhysicalKeyboardKey.arrowUp){
                        widget.game.onTapUp(TapUpDetails(globalPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2, widget.game.player.player.y + widget.game.player.player.height - speed), localPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2, widget.game.player.player.y + widget.game.player.player.height - speed)));
                      }
                      else if(key.physicalKey == PhysicalKeyboardKey.arrowLeft){
                        widget.game.onTapUp(TapUpDetails(globalPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2 - speed, widget.game.player.player.y + widget.game.player.player.height), localPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2 - speed, widget.game.player.player.y + widget.game.player.player.height)));      
                        widget.game.player.lastDirRight = false;            
                      }
                      else if(key.physicalKey == PhysicalKeyboardKey.arrowRight){
                        widget.game.onTapUp(TapUpDetails(globalPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2 + speed, widget.game.player.player.y + widget.game.player.player.height), localPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2 + speed, widget.game.player.player.y + widget.game.player.player.height)));                  
                        widget.game.player.lastDirRight = true;            
                      }
                      else if(key.physicalKey == PhysicalKeyboardKey.arrowDown){
                        widget.game.onTapUp(TapUpDetails(globalPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2, widget.game.player.player.y + widget.game.player.player.height + speed), localPosition: Offset(widget.game.player.player.x + widget.game.player.player.width / 2, widget.game.player.player.y + widget.game.player.player.height + speed)));                  

                      }
                      else if(key.physicalKey == PhysicalKeyboardKey.keyA || key.physicalKey == PhysicalKeyboardKey.space){
                        widget.game.player.attackAnim(widget.game.player.lastDirRight);
                      }
                    },
                    child: GestureDetector(
                      onTapUp: widget.game.onTapUp,
                      child: widget.game.widget,
                    ),
                  ),
                ),
              if(!kIsWeb)
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
                    if(lockBack)
                      return;
                    store.dispatch(SetWinAction(WinState.Playing));
                    setState(() {
                      startGame = false;
                    });
                  },
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: IconButton(
                  icon: Icon(widget.audioOn ? Icons.music_note : Icons.close, size: 28, color: Colors.white70),
                  onPressed: () async {
                    if(widget.audioOn)
                      Flame.bgm.pause();
                    else
                      Flame.bgm.resume();
                    setState(() {
                      widget.audioOn = !widget.audioOn;
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("audio", !widget.audioOn);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 12),
                    child: StoreConnector<AppState, int>(
                      converter: (store) => store.state.level,
                      builder: (context, level) {
                        return Text("Level: $level", style: TextStyle(color: Colors.white, fontSize: 16));    
                      }
                    ),
                  ),
                ) 
              ),
              Positioned(
                right: 40,
                bottom: 40,
                child: IconButton(
                  icon: Icon(Icons.crop_square, size: 50, color: Colors.white),
                  onPressed: () {
                    if(!widget.game.player.dead)
                      widget.game.player.attackAnim(widget.game.player.lastDirRight);
                  },
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: IgnorePointer(
                  child: StoreConnector<AppState, int>(
                    converter: (store) => store.state.lives + store.state.powerUps.extraLives,
                    builder: (context, lives){
                      return livesView(lives);
                    },
                  ),
                ),
              ),
              StoreConnector<AppState, WinState>(
                converter: (store) => store.state.win,
                distinct: true,
                onDidChange: (WinState win) async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(win != WinState.Playing){
                    store.dispatch(SetGoldAction(store.state.gold + (1 + store.state.level ~/ 5)));
                    await prefs.setInt("gold", store.state.gold);
                    if(win == WinState.Won){
                      var level = store.state.level + 1;
                      if(level > store.state.maxLevel)
                        store.dispatch(SetMaxLexelAction(level));
                      store.dispatch(IncLevelAction());
                      await prefs.setInt('level', level);
                      await restart(4, isNextLexel: true); 
                    }
                    else {
                      if(kIsWeb || viewedAnAd){
                        await restart(6, isNextLexel: false);
                        setState(() {
                          startGame = false;
                        });
                      }
                      else {
                        try {
                          bool watchAd = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Game Over'),
                                content: const Text('You can watch an ad to get more lives!'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Go Back'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Watch Ad'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if(watchAd){
                            if(!shownRewardAd){
                              await RewardedVideoAd.instance.show();
                              setState(() {
                                shownRewardAd = true;
                                viewedAnAd = true;
                              });
                            }
                            else {
                              intAd.add(InterstitialAd(adUnitId: production ? interstitialId : InterstitialAd.testAdUnitId));
                              intAd[intAd.length-1].load();
                              await intAd[intAd.length-1].show();
                              intAd.add(InterstitialAd(adUnitId: production ? interstitialId : InterstitialAd.testAdUnitId));
                              store.dispatch(SetLivesAction(3));
                              restart(4, isNextLexel: false);
                              setState(() {
                                viewedAnAd = true;
                              });
                            }
                          }
                          else {
                            setState(() {
                              startGame = false;
                            });
                          }
                        } catch(e) {
                          print(e);
                          Fluttertoast.showToast(msg: "An ad could not be found!");
                          setState(() {
                            startGame = false;
                          });
                        }
                      }
                    }
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
      ),
    );
  }
}