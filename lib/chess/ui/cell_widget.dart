import 'package:muse_nepu_course/chess/bloc/cubits/game_cubit.dart';
import 'package:muse_nepu_course/chess/config/colors.dart';
import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/ui/figure_widget.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

class CellWidget extends StatelessWidget {
  final Cell cell;
  final bool isSelected;
  final bool isAvailable;

  const CellWidget(
      {Key? key,
      required this.cell,
      required this.isSelected,
      required this.isAvailable})
      : super(key: key);

  _onTap(BuildContext context) {
    final gameCubit = GetIt.I<GameCubit>();

    // if AI calculating position => block any interactions
    if (gameCubit.state.isAIthinking) {
      return;
    }

    final activeColor = gameCubit.state.activeColor;

    if (isAvailable || (cell.occupied && isAvailable)) {
      gameCubit.moveFigure(cell);
      return;
    }

    if (cell.occupied && activeColor == cell.getFigure()!.color) {
      gameCubit.selectCell(cell);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Stack(
        children: [
          Container(
            color: cell.isBlack ? AppColors.black : AppColors.white,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: isSelected
                ? Colors.blueAccent.withOpacity(0.3)
                : Colors.transparent,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: isAvailable && cell.occupied
                ? Colors.redAccent.withOpacity(0.8)
                : Colors.transparent,
          ),
          Center(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isAvailable ? constraints.maxWidth * 0.2 : 0,
              height: isAvailable ? constraints.maxWidth * 0.2 : 0,
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent.withOpacity(0.9),
                borderRadius: BorderRadius.circular(constraints.maxWidth),
              ),
            );
          })),
          if (cell.occupied) FigureWidget(figure: cell.getFigure()!),
          // Text(
          //   cell.positionHash,
          //   style: const TextStyle(color: Colors.red),
          // )
        ],
      ),
    );
  }
}
