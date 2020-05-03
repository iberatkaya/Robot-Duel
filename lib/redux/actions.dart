import 'package:flamerpg/redux/store.dart';

class LevelAction {}

class IncLevelAction extends LevelAction { 
  int level;
  IncLevelAction();
}

int incLevel(int level, IncLevelAction action){
  return level + 1;
}

class SetLevelAction extends LevelAction { 
  int level;
  SetLevelAction(this.level);
}

setLevel(int level, SetLevelAction action){
  return action.level;
}

enum WinState {
  Won,
  Lost,
  Playing
}

class WinAction {}

class SetWinAction extends WinAction{
  WinState win;
  SetWinAction(this.win);
}

setWin(WinState win, SetWinAction action){
  return action.win;
}

class LivesAction {}

class SetLivesAction extends LivesAction {
  int lives;
  SetLivesAction(this.lives);
}

setLives(int lives, SetLivesAction action){
  return action.lives;
}

class MaxLexelAction {}

class SetMaxLexelAction extends MaxLexelAction {
  int maxLevel;
  SetMaxLexelAction(this.maxLevel);
}

setMaxLexel(int maxLevel, SetMaxLexelAction action){
  return action.maxLevel;
}

class GoldAction {}

class SetGoldAction extends GoldAction {
  int gold;
  SetGoldAction(this.gold);
}

setGold(int gold, SetGoldAction action){
  return action.gold;
}

class PowerUpAction {}

class SetPowerUpAction extends PowerUpAction {
  PowerUp powerUps;
  SetPowerUpAction(this.powerUps);
}

setPowerUp(PowerUp powerUps, SetPowerUpAction action){
  return action.powerUps;
}