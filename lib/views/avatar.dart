import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/utils/colors.dart';

class Avatar extends StatefulWidget {
  final Server? server;

  final bool selected;

  const Avatar({super.key, this.server, this.selected = false});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    final name = widget.server?.name ?? '';
    final hexColor = widget.server?.hexColor ?? '';
    final avatar = widget.server?.avatar;
    final avatarUrl = avatar != null
        ? 'https://cdn.nerimity.com/${avatar}'
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: avatarUrl == null ? hexToColor(hexColor) : null,
            borderRadius: BorderRadius.circular(99),
          ),
          alignment: Alignment.center,
          child: avatarUrl == null
              ? Text(
                  name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                )
              : Image.network(avatarUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
