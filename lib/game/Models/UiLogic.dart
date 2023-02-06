import 'package:muse_nepu_course/game/Models/TicTacToeLogic.dart';
import 'package:muse_nepu_course/game/constants.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

enum letter { cardX, cardO }

TicTacToe game = TicTacToe();

class UI {
  static late Color xCardColor, oCardColor, oTextColor, xTextColor;
  static late List<String> chars;
  static String finalResult = "",
      character = "",
      ans = "",
      ansLetter = "",
      winningDirection = "";
  static late String side;
  static late List<bool> isSelected;
  static late bool letterX, letterO;
  static late double deviceW;
  static var containerWidth,
      bw,
      mat,
      deviceHeight,
      wpHeight,
      wpWidth,
      colorMap = {},
      playerMap = {};
  static bool muteSound = true;
  static String player1Name = "玩家 1",
      player2Name = "玩家 2",
      player1ImageName = "avatar-1",
      player2ImageName = "avatar-2";
  static int xWins = 0,
      oWins = 0,
      noOfWins = 2,
      noOfDraws = 2,
      draws = 0,
      maxWins = 25,
      maxDraws = 25;
  static int minWins = 1, minDraws = 1;
  static var avatar1Map = {
    'avatar-1': kSettingsBoxColor,
    'avatar-2': kSettingsBoxColor,
    'avatar-3': kSettingsBoxColor,
    'avatar-4': kSettingsBoxColor
  };
  static var avatar2Map = {
    'avatar-1': kSettingsBoxColor,
    'avatar-2': kSettingsBoxColor,
    'avatar-3': kSettingsBoxColor,
    'avatar-4': kSettingsBoxColor
  };

  void initializeColorMap() {
    for (int i = 0; i < 9; i++) {
      colorMap[i] = "kProfileContainerColor";
    }
  }

  void remainingVars() {
    finalResult = "";
    character = "";
    ans = "";
    ansLetter = "";
    winningDirection = "";
    isSelected = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    chars = ["", "", "", "", "", "", "", "", ""];
    mat = [
      ["", "", ""],
      ["", "", ""],
      ["", "", ""]
    ];
    colorMap = {};
  }

  void setWinningVariables() {
    xWins = 0;
    oWins = 0;
    draws = 0;
  }

  void setRemainingVarsColorMap() {
    remainingVars();
    initializeColorMap();
  }

  void setAllVars() {
    remainingVars();
    setWinningVariables();
    initializeColorMap();
  }

  void updateMatrix(int row, int col, String val) {
    if (mat[row][col] == "") game.insertIntoCell(row, col, val);
  }

  void setCardO() {
    oCardColor = kProfileContainerColor;
    oTextColor = kLetterXColor;
    xCardColor = kGameScreenBackgroundColor;
    xTextColor = kLetterOColor;
  }

  void setCardX() {
    oCardColor = kGameScreenBackgroundColor;
    oTextColor = kLetterOColor;
    xCardColor = kProfileContainerColor;
    xTextColor = kLetterXColor;
  }

  void updateColor(letter selectedLetter) {
    if (selectedLetter == letter.cardO) {
      if (oCardColor == kGameScreenBackgroundColor &&
          oTextColor == kLetterOColor) setCardO();
    }
    if (selectedLetter == letter.cardX) {
      if (xCardColor == kGameScreenBackgroundColor &&
          xTextColor == kLetterOColor) setCardX();
    }
  }

  void startLetter(String c) {
    c == "X" ? letterO = false : letterO = true;
    letterX = !letterO;
    c == "X" ? playerMap['X'] = player1Name : playerMap['X'] = player2Name;
    c == "X" ? playerMap['O'] = player2Name : playerMap['O'] = player1Name;
  }

  void colorsAndSide() {
    xCardColor = kProfileContainerColor;
    oTextColor = kLetterOColor;
    oCardColor = kGameScreenBackgroundColor;
    xTextColor = kLetterXColor;
    side = "X";
  }

  /*playing sounds according to the condition of the game*/
  void playWinningSound() => AudioCache().play('winner.wav');
  void playDrawSound() => AudioCache().play('draw.mpeg');
  void playLetterSound() =>
      AudioCache().play(UI.character == "X" ? 'note1.wav' : 'note2.wav');

  /*Making letter X to make the move*/
  void letterXTurn() {
    character = "X";
    letterX = false;
    letterO = true;
  }

  /*Making letter O to make the move*/
  void letterOTurn() {
    character = "O";
    letterX = true;
    letterO = false;
  }

  /*Setting row containers to green color*/
  void setRow1() => colorMap[0] = colorMap[3] = colorMap[6] = kG;
  void setRow2() => colorMap[1] = colorMap[4] = colorMap[7] = kG;
  void setRow3() => colorMap[2] = colorMap[5] = colorMap[8] = kG;

  /*Setting column containers to green color*/
  void setCol1() => colorMap[0] = colorMap[1] = colorMap[2] = kG;
  void setCol2() => colorMap[3] = colorMap[4] = colorMap[5] = kG;
  void setCol3() => colorMap[6] = colorMap[7] = colorMap[8] = kG;

  /*Setting leftDiagnol containers to green color*/
  void setLeftDiagnol() => colorMap[0] = colorMap[4] = colorMap[8] = kG;

  /*Setting rightDiagnol containers to green color*/
  void setRightDiagnol() => colorMap[2] = colorMap[4] = colorMap[6] = kG;

  /*Checking whether any row contains same letters (x or o)*/
  bool checkR1() =>
      mat[0][0] != "" && mat[0][0] == mat[0][1] && mat[0][1] == mat[0][2];
  bool checkR2() =>
      mat[1][0] != "" && mat[1][0] == mat[1][1] && mat[1][1] == mat[1][2];
  bool checkR3() =>
      mat[2][0] != "" && mat[2][0] == mat[2][1] && mat[2][1] == mat[2][2];

  /*Checking whether any column contains same letters (x or o)*/
  bool checkC1() =>
      mat[0][0] != "" && mat[0][0] == mat[1][0] && mat[1][0] == mat[2][0];
  bool checkC2() =>
      mat[0][1] != "" && mat[0][1] == mat[1][1] && mat[1][1] == mat[2][1];
  bool checkC3() =>
      mat[0][2] != "" && mat[0][2] == mat[1][2] && mat[1][2] == mat[2][2];

  /*Checking whether left diagnol contains same letters (x or o)*/
  bool checkLeftDiagnol() => mat[0][0] == mat[1][1] && mat[1][1] == mat[2][2];

  /*Checking whether left diagnol contains same letters (x or o)*/
  bool checkRightDiagnol() => mat[2][0] == mat[1][1] && mat[1][1] == mat[0][2];
}
