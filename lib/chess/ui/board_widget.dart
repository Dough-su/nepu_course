import 'package:muse_nepu_course/chess/models/board.dart';
import 'package:muse_nepu_course/chess/models/cell.dart';
import 'package:muse_nepu_course/chess/ui/cell_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final Cell? selectedCell;
  final Set<String> availablePositionsHash;

  const BoardWidget(
      {Key? key,
      required this.board,
      required this.selectedCell,
      required this.availablePositionsHash})
      : super(key: key);

  List<CellWidget> _buildCells(BuildContext context) {
    final List<CellWidget> cellWidgets = [];

    for (var cellList in board.cells) {
      for (var cell in cellList) {
        cellWidgets.add(CellWidget(
          cell: cell,
          isSelected: selectedCell != null && selectedCell! == cell,
          isAvailable: availablePositionsHash.contains(cell.positionHash),
        ));
      }
    }

    return cellWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.brown, width: 16),
        bottom: BorderSide(color: Colors.brown, width: 16),
      )),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.count(
          padding: const EdgeInsets.all(0),
          crossAxisCount: boardSize,
          children: _buildCells(context),
        ),
      ),
    );
  }
}
