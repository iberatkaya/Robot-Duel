
import 'package:redux/redux.dart';
import 'actions.dart';
import 'reducers.dart';


final store = Store<AppState>(reducer, initialState: AppState(1, WinState.Playing));

class AppState {
  int level;
  WinState win;
  AppState(this.level, this.win);
}
