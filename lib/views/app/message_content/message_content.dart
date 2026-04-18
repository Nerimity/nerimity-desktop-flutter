import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';

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
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.serverId} / ${widget.channelId}'),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (ctx, i) => MessageTile(message: messages[i]),
          ),
        ),
        MessageInput(
          channelName: 'general',
          onSubmitted: (message) {
            setState(() {
              messages.insert(0, message);
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
  final String message;
  const MessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Avatar(
            server: Server(
              id: '1',
              name: 'SK',
              hexColor: '#FF0000',
              defaultChannelId: '',
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("SK", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(message),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
