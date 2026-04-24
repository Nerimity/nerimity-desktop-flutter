import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/channel.dart';
import 'package:nerimity_desktop_flutter/models/message.dart';
import 'package:nerimity_desktop_flutter/models/user.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/utils/nevula.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';

TextSpan transformCustomTextSpan(
  Entity entity,
  String fullText,
  Message? message,
) {
  final String customType = entity.params["type"] ?? "";
  final String content = fullText.substring(
    entity.innerSpan.start,
    entity.innerSpan.end,
  );

  // debugPrint('$customType $content');

  switch (customType) {
    case "#":
      final channel = channelStore.channels[content];

      if (channel != null && channel.name != null) {
        return channelMention(channel);
      }

    case "@":
      final user = message?.mentions.where((u) => u.id == content).firstOrNull;

      if (user != null) {
        return userMention(user);
      }
  }
  return TextSpan(text: "[$customType:$content]");
}

TextSpan userMention(User user) {
  return TextSpan(
    children: [
      WidgetSpan(
        child: Container(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(28, 255, 255, 255),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Avatar(size: AvatarSize.xs, user: user),
              Text(user.username),
            ],
          ),
        ),
      ),
    ],
  );
}

TextSpan channelMention(Channel channel) {
  return TextSpan(
    children: [
      WidgetSpan(
        child: Container(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(28, 255, 255, 255),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Icon(Icons.tag, size: 14, color: Colors.white70),
              Text(channel.name!),
            ],
          ),
        ),
      ),
    ],
  );
}

TextSpan buildTextSpan(Entity entity, String fullText, Message? message) {
  final String content = fullText.substring(
    entity.innerSpan.start,
    entity.innerSpan.end,
  );

  List<InlineSpan> children = entity.entities
      .map((e) => buildTextSpan(e, fullText, message))
      .toList();

  switch (entity.type) {
    case "bold":
      return TextSpan(
        children: children,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    case "italic":
      return TextSpan(
        children: children,
        style: const TextStyle(fontStyle: FontStyle.italic),
      );
    case "underline":
      return TextSpan(
        children: children,
        style: const TextStyle(decoration: TextDecoration.underline),
      );
    case "strikethrough":
      return TextSpan(
        children: children,
        style: const TextStyle(decoration: TextDecoration.lineThrough),
      );
    case "spoiler":
      return TextSpan(
        children: children,
        style: const TextStyle(
          backgroundColor: Colors.black,
          color: Colors.black,
        ),
      );
    case "link":
    case "named_link":
      return TextSpan(
        text: entity.type == "named_link" ? entity.params["name"] : content,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      );
    case "color":
      final colorStr = entity.params["color"] as String;
      Color? color;
      if (colorStr == "reset") {
        color = null;
      } else {
        String hexStr = colorStr.substring(1);
        if (hexStr.length == 3) {
          hexStr = hexStr.split('').map((char) => '$char$char').join();
        }
        color = Color(int.parse('0xFF$hexStr'));
      }
      return TextSpan(
        children: children,
        style: TextStyle(color: color),
      );
    case "code":
      return TextSpan(
        text: content,
        style: const TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey,
        ),
      );
    case "heading":
      final int level = entity.params["level"] ?? 1;
      double fontSize = (36 - (level * 4)).toDouble();

      return TextSpan(
        children: [
          const WidgetSpan(child: SizedBox(height: 20)),
          TextSpan(
            children: children,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ],
      );
    case "custom":
      return transformCustomTextSpan(entity, fullText, message);
    case "text":
    default:
      return TextSpan(
        text: children.isEmpty ? content : null,
        children: children,
      );
  }
}

class MarkupView extends StatelessWidget {
  final String? rawText;
  final Message? message;

  const MarkupView({super.key, this.rawText, this.message});

  @override
  Widget build(BuildContext context) {
    Entity rootEntity = parseMarkup(rawText ?? '');

    Entity fullEntityTree = addTextSpans(rootEntity);

    return Text.rich(
      buildTextSpan(fullEntityTree, rawText ?? '', message),
    );
  }
}
