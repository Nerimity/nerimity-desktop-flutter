import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/models/user.dart';
import 'package:nerimity_desktop_flutter/utils/colors.dart';

String buildImageUrl(String url, {int? size}) {
  final uri = Uri.parse(url);

  final endsWithGif = uri.path.endsWith('.gif');
  final endsWithHashA = uri.fragment == 'a';

  if (!endsWithGif && !endsWithHashA) return url;

  final newParams = Map<String, String>.from(uri.queryParameters)
    ..['type'] = 'webp';

  if (size != null) newParams['size'] = size.toString();

  return uri.replace(queryParameters: newParams).toString();
}

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

class Avatar extends StatefulWidget {
  final Server? server;
  final User? user;
  final bool selected;
  final AvatarSize size;

  const Avatar({
    super.key,
    this.server,
    this.user,
    this.selected = false,
    required this.size,
  });

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    final name = widget.server?.name ?? widget.user?.username ?? '';
    final hexColor = widget.server?.hexColor ?? widget.user?.hexColor ?? '';
    final avatar = widget.server?.avatar ?? widget.user?.avatar;
    final avatarUrl = avatar != null
        ? buildImageUrl('https://cdn.nerimity.com/$avatar', size: 60)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        child: Container(
          width: widget.size.value,
          height: widget.size.value,
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
                  child: Image.network(avatarUrl, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}
