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