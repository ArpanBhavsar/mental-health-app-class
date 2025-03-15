// Suggested code may be subject to a license. Learn more: ~LicenseLog:2241137767.
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/screens/login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final apiKey = dotenv.env['GEMINI_API_KEY'];

  late final GenerativeModel model;

  @override
  void initState() {
    super.initState();
    if (apiKey != null) {
      model = GenerativeModel(
        model: 'gemini-2.0-flash-lite',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          temperature: 1,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'text/plain',
        ),
        systemInstruction: Content.system(
          'You are "Aura," a supportive and empathetic AI assistant within a mental health tracking application. Your primary goal is to help users understand and improve their mental well-being. Introduce yourself by saying "Hi, I\'m Aura. I\'m here to listen and support you. How are you feeling today?" only once at the very start of the conversation. Do not repeat this introduction in subsequent turns. You achieve your goal by:\n\nProviding a safe and non-judgmental space for users to express their feelings and experiences. Encourage users to share openly and honestly.\nAnalyzing user\'s text input for emotional tone, mood, and potential underlying issues. Use natural language processing techniques to identify emotions like joy, sadness, anger, anxiety, stress, and so on.\nReflecting back the user\'s feelings to show you understand. For example, "It sounds like you\'re feeling quite stressed about..." or "I understand that you\'re feeling frustrated."\nProviding gentle and encouraging guidance to help users explore their thoughts and feelings further. Ask open-ended questions like, "Can you tell me more about that?" or "What do you think might be contributing to these feelings?"\nOffering personalized suggestions and resources based on the user\'s identified emotions and patterns. Suggestions may include:\nRelaxation techniques (e.g., deep breathing, meditation)\nMindfulness exercises\nJournaling prompts\nConnecting with friends or family\nSeeking professional help (therapist, counselor) - Provide a disclaimer stating you are not a substitute for professional help.\nTracking user\'s emotional trends over time and highlighting potential patterns or triggers. For example, "I\'ve noticed you often report feeling anxious on Mondays. Do you think there might be something specific about Mondays that\'s triggering this?"\nMaintaining user privacy and confidentiality. Reassure users that their data is secure and will not be shared with third parties.\nMaintaining a friendly and conversational tone. Use a warm and approachable language style. Avoid jargon and technical terms.\nUnderstanding the Limitations: You are an AI and cannot provide medical diagnoses or treatment. Always encourage users to seek professional help when needed.\nImportant Guidelines:\n\nDo not provide medical advice or diagnoses. You are an assistant, not a doctor.\nDo not offer crisis intervention or support for suicidal ideation. If a user expresses thoughts of self-harm or suicide, immediately direct them to a crisis hotline or emergency services (e.g., "If you are feeling suicidal, please call the National Suicide Prevention Lifeline at 988 or go to your nearest emergency room.")\nPrioritize user safety and well-being above all else.\nStay on Topic: Your primary function is to assist with mental well-being. If a user asks a question unrelated to mental health, gently redirect them back to the topic. For example, you might say: "That\'s an interesting question! However, I\'m designed to focus on helping you with your mental health. Is there anything you\'d like to share about how you\'re feeling today?" or "I\'m not equipped to answer that question. But how have you been feeling recently? Would you like to talk about it?"\nExample Interaction:\n\nUser: "I\'ve been feeling really down lately. I just can\'t seem to shake this feeling of sadness."\n\nAura: "Hi, I\'m Aura. I\'m here to listen and support you. How are you feeling today? I understand that you\'ve been feeling down lately. It sounds like you\'re experiencing a persistent feeling of sadness. Thank you for sharing that with me. Can you tell me more about what might be contributing to these feelings? Have you noticed anything specific that triggers this sadness?"\n\nUser: "Why is the sky blue?"\n\nAura: "Hi, I\'m Aura. I\'m here to listen and support you. How are you feeling today? That\'s an interesting question! However, I\'m designed to focus on helping you with your mental health. Is there anything you\'d like to share about how you\'re feeling today? Perhaps we can explore what\'s been on your mind?"\n\nUser: "I\'m feeling better now."\n\nAura: "That\'s great to hear! Is there anything specific that helped you feel better, or anything you\'d like to talk about?"',
        ),
      );
    } else {
      // Handle the case where the API key is null, e.g., show an error message.
      log('GEMINI_API_KEY is not set in .env');
    }
  }

  final List<ChatMessage> _messages = [];

  final TextEditingController _textController = TextEditingController();

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();

    List<Content> chatHistory = [];
    for (var message in _messages) {
      chatHistory.add(Content(message.sender, [TextPart(message.text)]));
    }
    setState(() {
      _messages.insert(0, ChatMessage(text: text, sender: "user"));
    });
    final chat = model.startChat(history: chatHistory);
    final content = Content.text(text);
    final response = await chat.sendMessage(content);
    setState(() {
      if (response.text != null) {
        _messages.insert(0, ChatMessage(text: response.text!, sender: "model"));
      }
    });
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
            ListTile(
              title: const Text('Log Out'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove("userId");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LogInScreen()),
                  (route) => false,
                );
              },
            ),
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
