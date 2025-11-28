import 'package:flutter/material.dart';
import 'package:tucky/Screens/ChatBot/api_response.dart';
import 'package:tucky/Drawer/drawer_build_layout.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService(); // Service Instanz
  bool _isLoading = false; // Ladezustand

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    String userMessage = _messageController.text;

    // User Nachricht hinzufügen
    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isUser: true, isLoading: false),
      );
      _messageController.clear();
      _isLoading = true;
    });

    try {
      // API aufrufen
      String botResponse = await _chatService.sendMessage(userMessage);

      // Bot Antwort hinzufügen
      setState(() {
        _messages.add(
          ChatMessage(text: botResponse, isUser: false, isLoading: false),
        );
        _isLoading = false;
      });
    } catch (e) {
      // Fehler behandeln
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Entschuldigung, ein Fehler ist aufgetreten: $e",
            isUser: false,
            isLoading: false,
          ),
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chatbot'),
        backgroundColor: Color.fromARGB(255, 239, 195, 202),
        elevation: 4.0,
      ),
      
      drawer: MyNavigationDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Chat-Nachrichten Bereich
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // Lade-Indicator
                  if (_isLoading && index == _messages.length) {
                    return _buildLoadingIndicator();
                  }

                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Input Bereich
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 8.0,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Stellen Sie eine Frage...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 239, 195, 202),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: IconButton(
                      onPressed: _isLoading ? null : _sendMessage,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: message.isUser ? Color.fromARGB(255, 239, 195, 202).withOpacity(0.5) : Colors.blue[50],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: message.isUser ? Color.fromARGB(255, 239, 195, 202) : Colors.blue,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.isUser ? "Du" : "AI Assistant",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: message.isUser ? Colors.teal[800] : Colors.blue[800],
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(message.text, style: const TextStyle(fontSize: 16.0)),
          if (message.isLoading) ...[
            const SizedBox(height: 8.0),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.blue, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI Assistant",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12.0),
              Text(
                "Denkt nach...",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

// Verbesserte Message-Klasse
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
  });
}
