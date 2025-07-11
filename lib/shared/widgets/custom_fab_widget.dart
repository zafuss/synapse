import 'package:flutter/material.dart';

class CustomFABWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;

  const CustomFABWidget({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        tooltip: tooltip,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Icon(icon, size: 28, color: Colors.black),
      ),
    );
  }
}
