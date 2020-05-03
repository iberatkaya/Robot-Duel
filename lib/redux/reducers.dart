import 'package:flamerpg/redux/store.dart';
import 'actions.dart';


AppState reducer(AppState state, action){
  if(action is LevelAction){
    if(action is SetLevelAction){
      state.level = setLevel(state.level, action);
    }
    else if(action is IncLevelAction){
      state.level = incLevel(state.level, action);
    }
  }
  else if(action is WinAction){
    if(action is SetWinAction){
      state.win = setWin(state.win, action);
    }
  }
  else if(action is LivesAction){
    if(action is SetLivesAction){
      state.lives = setLives(state.lives, action);
    }
  }
  else if(action is MaxLexelAction){
    if(action is SetMaxLexelAction){
      state.maxLevel = setMaxLexel(state.maxLevel, action);
    }
  }
  else if(action is GoldAction){
    if(action is SetGoldAction){
      state.gold = setGold(state.gold, action);
    }
  }
  else if(action is PowerUpAction){
    if(action is SetPowerUpAction){
      state.powerUps = setPowerUp(state.powerUps, action);
    }
  }
  return state;
}
