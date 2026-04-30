import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/models/user.dart';
import 'package:nerimity_desktop_flutter/utils/colors.dart';
import 'package:nerimity_desktop_flutter/utils/image.dart';

enum AvatarSize {
  xs(16),
  sm(24),
  md(32),
  lg(40),
  xl(48),
  xxl(64);

  final double value;
  const AvatarSize(this.value);
}

class Avatar extends StatelessWidget {
  final Server? server;
  final User? user;
  final AvatarSize size;

  const Avatar({super.key, this.server, this.user, required this.size});

  @override
  Widget build(BuildContext context) {
    final name = server?.name ?? user?.username ?? '';
    final hexColor = server?.hexColor ?? user?.hexColor ?? '';
    final avatar = server?.avatar ?? user?.avatar;
    final avatarExists = avatar != null && avatar.trim() != '';
    final avatarUrl = avatarExists ? buildImageUrl(avatar, size: 60) : null;

    return Container(
      width: size.value,
      height: size.value,
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
          : ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                width: size.value,
                height: size.value,
                errorBuilder: (context, error, stackTrace) =>
                    SizedBox(height: size.value, width: size.value),
              ),
            ),
    );
  }
}
