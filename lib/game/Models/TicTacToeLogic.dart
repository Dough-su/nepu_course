import 'package:muse_nepu_course/game/Models/UiLogic.dart';

class TicTacToe {
  void insertIntoCell(int rowIndex, int columnIndex, String val) {
    UI.mat[rowIndex][columnIndex] = val;
    UI.ansLetter = val;
  }

  String checkWinningCondition() {
    for (int i = 0; i < 3; i++) {
      if ((UI.mat[i][0] != "") &&
          (UI.mat[i][0] == UI.mat[i][1]) &&
          (UI.mat[i][1] == UI.mat[i][2])) {
        UI.ans = "Win";
        UI.winningDirection = "checkRows";
        break;
      }
    }

    for (int i = 0; i < 3; i++) {
      if ((UI.ans != "you win") &&
          (UI.mat[0][i] != "") &&
          (UI.mat[0][i] == UI.mat[1][i]) &&
          (UI.mat[1][i] == UI.mat[2][i])) {
        UI.ans = "Win";
        UI.winningDirection = "checkColumns";
        break;
      }
    }

    if ((UI.ans != "you win") &&
        (UI.mat[0][0] != "") &&
        (UI.mat[0][0] == UI.mat[1][1]) &&
        (UI.mat[1][1] == UI.mat[2][2])) {
      UI.ans = "Win";
      UI.winningDirection = "checkLeftDiagnol";
    }

    if ((UI.ans != "you win") &&
        (UI.mat[2][0] != "") &&
        (UI.mat[2][0] == UI.mat[1][1]) &&
        (UI.mat[1][1] == UI.mat[0][2])) {
      UI.ans = "Win";
      UI.winningDirection = "checkRightDiagnol";
    }

    return UI.ans;
  }

  String checkDrawCondition() {
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (UI.mat[i][j] == "") {
          isDraw = false;
          break;
        }
      }
      if (isDraw)
        continue;
      else
        break;
    }
    isDraw ? UI.ans = "Draw" : UI.ans = "";
    return UI.ans;
  }
}
