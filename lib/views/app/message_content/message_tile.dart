import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/message.dart';
import 'package:nerimity_desktop_flutter/utils/image.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';
import 'package:nerimity_desktop_flutter/views/markup.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final Message? prevMessage;
  const MessageTile({super.key, required this.message, this.prevMessage});

  @override
  Widget build(BuildContext context) {
    final prevSameCreator =
        prevMessage != null &&
        prevMessage!.createdBy.id == message.createdBy.id;

    return Container(
      margin: !prevSameCreator
          ? const EdgeInsets.only(top: 8)
          : const EdgeInsets.only(top: 0),
      child: InkWell(
        onTap: () {},
        hoverColor: const Color.fromARGB(19, 255, 255, 255),
        child: Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              prevSameCreator
                  ? SizedBox(width: AvatarSize.lg.value, height: 1)
                  : Avatar(user: message.createdBy, size: AvatarSize.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    prevSameCreator
                        ? const SizedBox.shrink()
                        : Text(
                            message.createdBy.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    MarkupView(rawText: message.content, message: message),
                    MessageEmbeds(message: message),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageEmbeds extends StatelessWidget {
  final Message message;
  const MessageEmbeds({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachments.firstOrNull;

    final imageAttachment =
        attachment?.width != null &&
        attachment?.mime?.startsWith("image/") == true;

    return imageAttachment
        ? MessageImageEmbed(attachment: attachment!, message: message)
        : const SizedBox.shrink();
  }
}

class MessageImageEmbed extends StatelessWidget {
  final Message message;
  final Attachment attachment;
  const MessageImageEmbed({
    super.key,
    required this.message,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    final url = buildImageUrl(attachment.path!);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constrainDimensions(
          width: attachment.width!.toDouble(),
          height: attachment.height!.toDouble(),
          maxWidth: constraints.maxWidth.clamp(0, 1920),
          maxHeight: 1080,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
