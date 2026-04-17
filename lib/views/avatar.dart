import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  final String label;
  final Color color;
  final bool selected;

  const Avatar({
    super.key,
    required this.label,
    required this.color,
    this.selected = false,
  });

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(99),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
