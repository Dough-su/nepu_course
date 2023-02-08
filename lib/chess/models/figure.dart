import 'package:muse_nepu_course/chess/config/assets.dart';
import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/models/figure_types.dart';
import 'package:muse_nepu_course/chess/models/game_colors.dart';

class FiguresAssetPresenter {
  final FigureTypes type;
  final GameColors color;

  FiguresAssetPresenter(this.type, this.color);

  getAsset() {
    return figuresAssetPath + color.toName() + '/' + type.toName() + '.png';
  }
}

abstract class Figure {
  final GameColors color;
  final FigureTypes type;

  Cell cell;

  String get imageAsset => FiguresAssetPresenter(type, color).getAsset();

  bool get isBlack => color == GameColors.black;
  bool get isWhite => color == GameColors.white;

  Figure({required this.color, required this.cell, required this.type}) {
    cell.setFigure(this);
  }

  bool availableForMove(Cell to) {
    if (!to.occupied) {
      return true;
    }

    Figure occupiedFigure = to.getFigure()!;

    if (occupiedFigure.color == color) {
      return false;
    }

    if (occupiedFigure.type == FigureTypes.king) {
      return false;
    }

    return true;
  }

  void onMoved(Cell to) {
    cell = to;
  }
}
