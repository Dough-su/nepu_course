import 'package:muse_nepu_course/chess/bloc/states/settings_state.dart';
import 'package:muse_nepu_course/chess/models/board.dart';
import 'package:muse_nepu_course/chess/models/lost_figures.dart';
import 'package:muse_nepu_course/chess/models/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(SettingsState initialState) : super(initialState);

  factory SettingsCubit.initial() {
    final board =
        Board(cells: [], whiteLost: LostFigures(), blackLost: LostFigures());
    board.createCells();
    board.putFigures();

    return SettingsCubit(SettingsState(
      whitePlayer: Player.human(),
      blackPlayer: Player.human(),
      difficulty: 1,
    ));
  }
}
