import 'package:flutter/material.dart';

class PopPageButton extends StatelessWidget {
  const PopPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        elevation: 0,
        side: const BorderSide(color: Colors.grey),
        backgroundColor: Colors.transparent
      ),
      child: const Icon(
        Icons.close,
        size: 28,
        color: Colors.grey,
      ),
    );
    ;
  }
}
