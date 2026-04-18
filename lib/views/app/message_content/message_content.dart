import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nerimity_desktop_flutter/models/message.dart';
import 'package:nerimity_desktop_flutter/stores/message_store.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';

class MessageContent extends ConsumerStatefulWidget {
  final String serverId;
  final String channelId;

  const MessageContent({
    required this.serverId,
    required this.channelId,
    super.key,
  });

  @override
  ConsumerState<MessageContent> createState() => _MessageContentState();
}

class _MessageContentState extends ConsumerState<MessageContent> {
  @override
  void initState() {
    super.initState();
    ref.read(messageStoreProvider.notifier).loadMessages(widget.channelId);
  }

  @override
  void didUpdateWidget(MessageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channelId != widget.channelId) {
      ref.read(messageStoreProvider.notifier).loadMessages(widget.channelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(
      messageStoreProvider.select((s) => s[widget.channelId] ?? []),
    );

    return Column(
      children: [
        Text('${widget.serverId} / ${widget.channelId}'),
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (ctx, i) => MessageTile(
              message: messages[i],
              prevMessage: i > 0 ? messages[i - 1] : null,
            ),
          ),
        ),
        MessageInput(
          channelName: 'general',
          onSubmitted: (message) {
            setState(() {
              // messages.insert(0, message);
            });
          },
        ),
      ],
    );
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
                      Text(message.content),
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
