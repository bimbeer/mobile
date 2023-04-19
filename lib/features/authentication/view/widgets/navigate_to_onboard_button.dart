import 'package:flutter/material.dart';

class NavigateToOnboardButton extends StatelessWidget {
  const NavigateToOnboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).popAndPushNamed('/');
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(5),
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
