import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';

class ContentArea extends StatefulWidget {
  const ContentArea({super.key});

  @override
  State<ContentArea> createState() => _ContentAreaState();
}

class _ContentAreaState extends State<ContentArea> {
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: _handleSubmitted,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Send a message to ${widget.channelName}',
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
          Avatar(color: Colors.teal, label: 'SK'),
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
