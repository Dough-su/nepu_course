import 'package:muse_nepu_course/chess/bloc/cubits/settings_cubit.dart';
import 'package:muse_nepu_course/chess/bloc/states/game_state.dart';
import 'package:muse_nepu_course/chess/bloc/states/settings_state.dart';
import 'package:muse_nepu_course/chess/models/board.dart';
import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/models/game_colors.dart';
import 'package:muse_nepu_course/chess/models/lost_figures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(GameState initialState) : super(initialState);

  factory GameCubit.initial() {
    final board =
        Board(cells: [], whiteLost: LostFigures(), blackLost: LostFigures());
    board.createCells();
    board.putFigures();

    return GameCubit(GameState(
        activeColor: GameColors.white,
        selectedCell: null,
        board: board,
        isAIthinking: false,
        availablePositionsHash: {}));
  }

  void startBattle() {
    final settings = _getSettings();

    if (settings.hasAI && !settings.whitePlayer.isHuman) {
      _scheduleAIMove();
    }
  }

  void selectCell(Cell? newCell) {
    emit(state.copyWith(
        selectedCell: newCell,
        availablePositionsHash:
            state.board.getAvailablePositionsHash(newCell)));
  }

  void moveFigure(Cell toCell) async {
    if (state.selectedCell == null) {
      return;
    }

    state.selectedCell!.moveFigure(toCell);

    // if we play with AI
    if (_getSettings().hasAI) {
      final nextColor = state.activeColor.getOpposite();
      final nextPlayer = _getSettings().getPlayerByColor(nextColor);

      if (nextPlayer.isHuman) {
        return;
      }

      await _scheduleAIMove();
    }

    emit(state.copyWith(
        board: state.board.copyThis(),
        activeColor: state.activeColor.getOpposite()));

    selectCell(null);
  }

  Future<void> _scheduleAIMove() async {
    state.copyWith(isAIthinking: true);
    state.copyWith(isAIthinking: false);
  }

  SettingsState _getSettings() {
    return GetIt.I<SettingsCubit>().state;
  }
}
