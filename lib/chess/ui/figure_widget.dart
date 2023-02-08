import 'package:muse_nepu_course/chess/models/figure.dart';
import 'package:flutter/material.dart';

class FigureWidget extends StatelessWidget {
  final Figure figure;

  const FigureWidget({Key? key, required this.figure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      figure.imageAsset,
      fit: BoxFit.fill,
    );
  }
}
