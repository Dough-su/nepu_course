import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  const CustomButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(label),
      color: Colors.brown[200],
    );
  }
}
