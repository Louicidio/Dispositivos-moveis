import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const AppBackButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.blueAccent,
    this.iconColor = Colors.white,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        child: IconButton(
          icon: Icon(icon, color: iconColor, size: size * 0.6),
          onPressed: onPressed,
          splashRadius: size * 0.7,
        ),
      ),
    );
  }
}
