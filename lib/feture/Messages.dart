import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final isUserMessage = widget.messages[index]['isUserMessage'] as bool;
        final messageText =
            widget.messages[index]['message'].text.text[0] as String;

        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Align(
            alignment: isUserMessage ? Alignment.topRight : Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(maxWidth: w * 2 / 3),
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.green[300] : Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomRight: isUserMessage
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                  bottomLeft: isUserMessage
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                messageText,
                style: TextStyle(
                  fontSize: 16,
                  color: isUserMessage ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
