import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/models/cell_calculator.dart';
import 'package:muse_nepu_course/chess/models/cell_position.dart';
import 'package:muse_nepu_course/chess/models/figure.dart';
import 'package:muse_nepu_course/chess/models/figures/bishop.dart';
import 'package:muse_nepu_course/chess/models/figures/king.dart';
import 'package:muse_nepu_course/chess/models/figures/knight.dart';
import 'package:muse_nepu_course/chess/models/figures/pawn.dart';
import 'package:muse_nepu_course/chess/models/figures/queen.dart';
import 'package:muse_nepu_course/chess/models/figures/rook.dart';
import 'package:muse_nepu_course/chess/models/game_colors.dart';
import 'package:muse_nepu_course/chess/models/lost_figures.dart';

const boardSize = 8;

class Board {
  final List<List<Cell>> cells;

  final LostFigures blackLost;
  final LostFigures whiteLost;

  Board(
      {required this.cells, required this.blackLost, required this.whiteLost});

  void createCells() {
    for (int y = 0; y < boardSize; y++) {
      final List<Cell> row = [];

      for (int x = 0; x < boardSize; x++) {
        if ((x + y) % 2 != 0) {
          row.add(Cell.white(board: this, position: CellPosition(x, y)));
        } else {
          row.add(Cell.black(board: this, position: CellPosition(x, y)));
        }
      }

      cells.add(row);
    }
  }

  void pushFigureLoLost(Figure lostFigure) {
    if (lostFigure.isBlack) {
      blackLost.push(lostFigure);
    }

    if (lostFigure.isWhite) {
      whiteLost.push(lostFigure);
    }
  }

  Set<String> getAvailablePositionsHash(Cell? selectedCell) {
    return CellCalculator.getAvailablePositionsHash(this, selectedCell);
  }

  Board copyThis() {
    return Board(cells: cells, blackLost: blackLost, whiteLost: whiteLost);
  }

  Cell getCellAt(int x, int y) {
    return cells[y][x];
  }

  putFigures() {
    _putPawns();
    _putBishops();
    _putKnights();
    _putRooks();
    _putQueens();
    _putKings();
  }

  _putPawns() {
    for (int i = 0; i < 8; i++) {
      Pawn(color: GameColors.white, cell: getCellAt(i, 6));
      Pawn(color: GameColors.black, cell: getCellAt(i, 1));
    }
  }

  _putBishops() {
    Bishop(color: GameColors.white, cell: getCellAt(2, 7));
    Bishop(color: GameColors.white, cell: getCellAt(5, 7));
    Bishop(color: GameColors.black, cell: getCellAt(2, 0));
    Bishop(color: GameColors.black, cell: getCellAt(5, 0));
  }

  _putKnights() {
    Knight(color: GameColors.white, cell: getCellAt(1, 7));
    Knight(color: GameColors.white, cell: getCellAt(6, 7));
    Knight(color: GameColors.black, cell: getCellAt(1, 0));
    Knight(color: GameColors.black, cell: getCellAt(6, 0));
  }

  _putRooks() {
    Rook(color: GameColors.white, cell: getCellAt(0, 7));
    Rook(color: GameColors.white, cell: getCellAt(7, 7));
    Rook(color: GameColors.black, cell: getCellAt(0, 0));
    Rook(color: GameColors.black, cell: getCellAt(7, 0));
  }

  _putKings() {
    King(color: GameColors.white, cell: getCellAt(4, 7));
    King(color: GameColors.black, cell: getCellAt(4, 0));
  }

  _putQueens() {
    Queen(color: GameColors.white, cell: getCellAt(3, 7));
    Queen(color: GameColors.black, cell: getCellAt(3, 0));
  }
}
