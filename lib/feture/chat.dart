import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "ChatBot",
                style: GoogleFonts.prompt(
                    fontSize: 24, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              elevation: 5.0,
              backgroundColor: Colors.red[300],
            ),
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
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red[300],
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
                            style: GoogleFonts.prompt(
                                fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: GoogleFonts.prompt(
                                  fontSize: 16, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.red[500],
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                            onPressed: () {
                              sendMessage(_controller.text);
                              _controller.clear();
                            },
                            icon: const Icon(Icons.send),
                            color: Colors.white,
                          ),
                        ),
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
