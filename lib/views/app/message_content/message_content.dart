import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/message.dart';
import 'package:nerimity_desktop_flutter/services/channel_service.dart';
import 'package:nerimity_desktop_flutter/stores/message_store.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';
import 'package:nerimity_desktop_flutter/views/markup.dart';
import 'package:signals/signals_flutter.dart';

class MessageContent extends StatefulWidget {
  final String serverId;
  final String channelId;

  const MessageContent({
    required this.serverId,
    required this.channelId,
    super.key,
  });

  @override
  State<MessageContent> createState() => _MessageContentState();
}

class _MessageContentState extends State<MessageContent> {
  @override
  void initState() {
    super.initState();
    messageStore.loadMessages(widget.channelId);
  }

  @override
  void didUpdateWidget(MessageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channelId != widget.channelId) {
      messageStore.loadMessages(widget.channelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: MessageLog(channelId: widget.channelId)),
        MessageInput(
          channelName: 'general',
          onSubmitted: (message) => postMessage(widget.channelId, message),
        ),
      ],
    );
  }
}

class MessageLog extends StatelessWidget {
  final String channelId;
  const MessageLog({required this.channelId, super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final messages = messageStore.messages[channelId] ?? [];
      return ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (ctx, i) {
          final reversedIndex = messages.length - 1 - i;
          return MessageTile(
            message: messages[reversedIndex],
            prevMessage: reversedIndex > 0 ? messages[reversedIndex - 1] : null,
          );
        },
      );
    });
  }
}

class MessageInput extends StatefulWidget {
  final String channelName;
  final ValueChanged<String> onSubmitted;

  const MessageInput({
    super.key,
    required this.channelName,
    required this.onSubmitted,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    _focusNode.requestFocus();
    if (value.trim().isEmpty) return;
    widget.onSubmitted(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Column(
                    children: [
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: _handleSubmitted,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade800,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade800,
                              width: 1.0,
                            ),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          hintText: 'Send a message to ${widget.channelName}',
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 1,
                      decoration: BoxDecoration(
                        color: _focusNode.hasFocus
                            ? const Color(0xff4c93ff)
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                child: Container(
                  margin: !prevSameCreator
                      ? const EdgeInsets.only(top: 6)
                      : const EdgeInsets.only(top: 0),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
