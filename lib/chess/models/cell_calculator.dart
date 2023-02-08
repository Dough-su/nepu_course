import 'dart:math';

import 'package:muse_nepu_course/chess/models/board.dart';
import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/models/cell_position.dart';
import 'package:muse_nepu_course/chess/models/game_colors.dart';

abstract class CellCalculator {
  static bool hasVerticalWay(Cell from, Cell target) {
    if (from.position.x != target.position.x) {
      return false;
    }

    final minY = min(from.position.y, target.position.y);
    final maxY = max(from.position.y, target.position.y);

    for (int y = minY + 1; y < maxY; y++) {
      if (from.board.getCellAt(from.position.x, y).occupied) {
        return false;
      }
    }

    return true;
  }

  static bool hasHorizontalWay(Cell from, Cell target) {
    if (from.position.y != target.position.y) {
      return false;
    }

    final minX = min(from.position.x, target.position.x);
    final maxX = max(from.position.x, target.position.x);

    for (int x = minX + 1; x < maxX; x++) {
      if (from.board.getCellAt(x, from.position.y).occupied) {
        return false;
      }
    }

    return true;
  }

  static bool hasDiagonalWay(Cell from, Cell target) {
    final absX = (target.position.x - from.position.x).abs();
    final absY = (target.position.y - from.position.y).abs();

    if (absY != absX) {
      return false;
    }

    final originY = from.position.y < target.position.y ? 1 : -1;
    final originX = from.position.x < target.position.x ? 1 : -1;

    for (int i = 1; i < absY; i++) {
      if (from.board
          .getCellAt(
              from.position.x + originX * i, from.position.y + originY * i)
          .occupied) {
        return false;
      }
    }

    return true;
  }

  static bool hasWayForKing(Cell from, Cell target) {
    final v = CellPosition(from.position.x - target.position.x,
        from.position.y - target.position.y);

    if (v.magnitude == 1) {
      return true;
    }

    return false;
  }

  static bool hasWayForKnight(Cell from, Cell target) {
    final dx = (from.position.x - target.position.x).abs();
    final dy = (from.position.y - target.position.y).abs();

    return (dx == 1 && dy == 2) || (dx == 2 && dy == 1);
  }

  static bool hasWayForPawn(Cell from, Cell target, bool canDoubleMove) {
    final step =
        (from.occupied && from.getFigure()!.color == GameColors.black) ? 1 : -1;
    final isStepCorrect = target.position.y == from.position.y + step;
    final isTargetOccupied =
        from.board.getCellAt(target.position.x, target.position.y).occupied;

    // if (target.positionHash == '3-4' && from.positionHash == '3-5') {
    //   final a = 'dd';
    // }

    // for empty cell
    if (isStepCorrect &&
        target.position.x == from.position.x &&
        !isTargetOccupied) {
      return true;
    }

    if (canDoubleMove) {
      final doubleStep =
          (from.occupied && from.getFigure()!.color == GameColors.black)
              ? 2
              : -2;
      final isDoubleStepCorrect =
          target.position.y == from.position.y + doubleStep;

      // for empty cell
      if (isDoubleStepCorrect &&
          target.position.x == from.position.x &&
          !isTargetOccupied) {
        return true;
      }
    }

    // for occupied cell
    if (isStepCorrect &&
        (target.position.x == from.position.x + 1 ||
            target.position.x == from.position.x - 1) &&
        from.occupiedByEnemy(target)) {
      return true;
    }

    return false;
  }

  static bool hasWayForQueen(Cell from, Cell target) {
    if (hasHorizontalWay(from, target)) return true;
    if (hasVerticalWay(from, target)) return true;
    if (hasDiagonalWay(from, target)) return true;

    return false;
  }

  static bool hasWayForRook(Cell from, Cell target) {
    if (hasHorizontalWay(from, target)) return true;
    if (hasVerticalWay(from, target)) return true;

    return false;
  }

  static Set<String> getAvailablePositionsHash(Board board, Cell? fromCell) {
    final Set<String> availableCells = {};

    if (fromCell == null || !fromCell.occupied) return availableCells;

    for (int y = 0; y < boardSize; y++) {
      for (int x = 0; x < boardSize; x++) {
        final target = board.getCellAt(x, y);
        if (fromCell.getFigure()!.availableForMove(target)) {
          availableCells.add(target.positionHash);
        }
      }
    }

    return availableCells;
  }
}
