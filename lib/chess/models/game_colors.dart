enum GameColors {
  white,
  black,
}

extension GameColorsExt on GameColors {
  String toName() {
    return toString().split('.').last;
  }

  GameColors getOpposite() {
    return this == GameColors.white ? GameColors.black : GameColors.white;
  }
}
