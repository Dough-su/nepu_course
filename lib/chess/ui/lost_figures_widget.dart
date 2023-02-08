import 'package:muse_nepu_course/chess/models/figure.dart';
import 'package:flutter/material.dart';

class LostFiguresWidget extends StatelessWidget {
  final List<Figure> figures;

  const LostFiguresWidget({Key? key, required this.figures}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: figures.length,
          itemBuilder: (context, index) {
            return SizedBox(
              child: Image.asset(figures[index].imageAsset),
              width: 30,
              height: 40,
            );
          }),
    );
  }
}
