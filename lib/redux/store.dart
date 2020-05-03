
import 'package:redux/redux.dart';
import 'actions.dart';
import 'reducers.dart';


final store = Store<AppState>(reducer, initialState: AppState(1, WinState.Playing, 3, 1, 0, PowerUp(0, 0, 0)));

class AppState {
  int level;
  WinState win;
  int lives;
  int maxLevel;
  int gold;
  PowerUp powerUps;
  AppState(this.level, this.win, this.lives, this.maxLevel, this.gold, this.powerUps);
}

class PowerUp {
  int movSpeed;
  int attackSpeed;
  int extraLives;
  PowerUp(this.movSpeed, this.attackSpeed, this.extraLives);
}