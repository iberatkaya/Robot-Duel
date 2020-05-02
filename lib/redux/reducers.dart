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
  return state;
}
