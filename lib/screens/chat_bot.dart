import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class MedicalChatBot extends StatefulWidget {
  const MedicalChatBot({super.key});

  @override
  State<MedicalChatBot> createState() => _MedicalChatBotState();
}

class _MedicalChatBotState extends State<MedicalChatBot> {
  final Gemini _gemini = Gemini.instance;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];

  static const Color primaryGreen = Color.fromARGB(255, 193, 233, 99);
  static const Color darkGreen = Color.fromARGB(255, 100, 141, 20);

  void sendMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
    });
    _scrollToBottom();

    _gemini.text(message).then((response) {
      setState(() {
        _messages.add(ChatMessage(text: response?.output ?? "I'm sorry, I couldn't process your request. Please try again or consult a healthcare professional for accurate medical advice.", isUser: false));
      });
      _scrollToBottom();
    }).catchError((error) {
      setState(() {
        _messages.add(ChatMessage(text: "I apologize, but I encountered an error. Please try again or seek professional medical advice if you have urgent concerns.", isUser: false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediGuide Assistant', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: darkGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Important Notice'),
                    content: const Text('This chatbot provides general medical information and guidance. It is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Understand', style: TextStyle(color: darkGreen)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryGreen.withOpacity(0.6), Colors.white],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Describe your symptoms or ask a health question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: (String message) {
                        if (message.isNotEmpty) {
                          sendMessage(message);
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () {
                      String message = _textEditingController.text.trim();
                      if (message.isNotEmpty) {
                        sendMessage(message);
                        _textEditingController.clear();
                      }
                    },
                    child: const Icon(Icons.healing, color: Colors.white),
                    backgroundColor: darkGreen,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isUser) CircleAvatar(
            backgroundColor: _MedicalChatBotState.darkGreen,
            child: const Icon(Icons.medical_services, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: isUser ? _MedicalChatBotState.primaryGreen.withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isUser
                ? Text(text)
                : Markdown(
                    data: text,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: _MedicalChatBotState.darkGreen),
                      strong: const TextStyle(color: Colors.black87),
                      em: TextStyle(color: _MedicalChatBotState.darkGreen.withOpacity(0.8)),
                      h1: TextStyle(color: _MedicalChatBotState.darkGreen),
                      h2: TextStyle(color: _MedicalChatBotState.darkGreen),
                      h3: TextStyle(color: _MedicalChatBotState.darkGreen),
                      blockquote: const TextStyle(color: Colors.blueGrey),
                    ),
                  ),
            ),
          ),
          if (isUser) const SizedBox(width: 10),
          if (isUser) CircleAvatar(
            backgroundColor: _MedicalChatBotState.darkGreen,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}