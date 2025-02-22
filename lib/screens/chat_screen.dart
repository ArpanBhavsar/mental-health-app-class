// Suggested code may be subject to a license. Learn more: ~LicenseLog:4219870950.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:551127916.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1975390785.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:764376108.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1164116620.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final gemini = Gemini.instance;

  final List<ChatMessage> _messages = [];

  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, sender: "user"));
    });
    List<Content> chatHistory = [];
    for (var message in _messages) {
      chatHistory.add(Content(parts: [Part.text(message.text)], role: message.sender));
    }
    gemini
        .chat(chatHistory.reversed.toList())
        .then((value) {
          if(value?.output != null){
            setState(() {
              _messages.insert(
                0,
                ChatMessage(text: value?.output ?? '', sender: "model"),
              );
            });
          }else{
             log("response was null");
          }
        })
        .catchError((e) => log('chat', error: e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Options',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: const Text('Mood Logging'), onTap: () {}),
            ListTile(title: const Text('Journaling'), onTap: () {}),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder:
                  (context, index) => ChatBubble(message: _messages[index]),
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String sender;
  ChatMessage({required this.text, required this.sender});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            message.sender == "user"
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color:
                    message.sender == "user"
                        ? Colors.blue[100]
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(message.text),
            ),
          ),
        ],
      ),
    );
  }
}
