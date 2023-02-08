import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/models/cell_calculator.dart';
import 'package:muse_nepu_course/chess/models/figure.dart';
import 'package:muse_nepu_course/chess/models/figure_types.dart';
import 'package:muse_nepu_course/chess/models/game_colors.dart';

class King extends Figure {
  King({required GameColors color, required Cell cell})
      : super(color: color, cell: cell, type: FigureTypes.king);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) {
      return false;
    }

    return CellCalculator.hasWayForKing(cell, to);
  }
}
