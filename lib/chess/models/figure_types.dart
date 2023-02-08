enum FigureTypes {
  king,
  knight,
  pawn,
  queen,
  rook,
  bishop,
}

extension ParseToString on FigureTypes {
  String toName() {
    return toString().split('.').last;
  }
}
