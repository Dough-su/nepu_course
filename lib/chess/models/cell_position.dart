import 'dart:math';

class CellPosition {
  final int x;
  final int y;

  CellPosition(this.x, this.y);

  int get magnitude => sqrt(x * x + y * y).toInt();
}
