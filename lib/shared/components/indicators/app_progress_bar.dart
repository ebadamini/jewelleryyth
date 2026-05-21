import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
  });

  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: height,
        value: value,
        valueColor: AlwaysStoppedAnimation(color ?? Theme.of(context).colorScheme.primary),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
