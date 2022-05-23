import 'package:flutter/material.dart';

class ToolBarButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const ToolBarButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          primary: Colors.red,
          onPrimary: Colors.white,
        ),
      ),
    );
  }
}
