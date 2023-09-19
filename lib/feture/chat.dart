import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'package:tracker_covid_v1/feture/Messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DialogFlowtter? dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  Future<DialogFlowtter> initializeDialogFlowtter() async {
    return await DialogFlowtter.fromFile(
        path: 'assets/krit-hgyk-f9e8ca580c2b.json');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DialogFlowtter>(
      future: initializeDialogFlowtter(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error initializing DialogFlowtter',
                    style: TextStyle(color: Colors.red)));
          }
          dialogFlowtter = snapshot.data;

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white10, Colors.blue.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(child: MessagesScreen(messages: messages)),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: const TextStyle(color: Colors.white38),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.deepPurple.shade700,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                            onPressed: () {
                              sendMessage(_controller.text);
                              _controller.clear();
                            },
                            backgroundColor: Colors.deepPurple.shade600,
                            child: const Icon(Icons.send)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text('Error initializing DialogFlowtter',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepPurple)));
        }
      },
    );
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) {
      print('Message is empty');
      return;
    }

    setState(() {
      addMessage(Message(text: DialogText(text: [text])), true);
    });

    try {
      DetectIntentResponse response = await dialogFlowtter!.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );
      if (response.message != null) {
        setState(() {
          addMessage(response.message!);
        });
      }
    } catch (e) {
      print("Error sending the message to DialogFlow: $e");
      // Optionally, you can display this error to the user
    }
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }
}
