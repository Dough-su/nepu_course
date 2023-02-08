import 'package:flutter/material.dart';

class CardsGridView extends StatelessWidget {
  const CardsGridView({
    Key? key,
    required this.cards,
  }) : super(key: key);

  final List<Image> cards;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: cards[index],
          );
        },
      ),
    );
  }
}
