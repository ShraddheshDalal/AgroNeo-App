import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:agri/util/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  final String routeC = "/chat-bot";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  late GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    // Initialize Gemini API
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: 'AIzaSyCQkJQ5iKy47My7soMdHkQ4xEnqvzgmSJ4', // Replace with your actual API key
    );

    
    
    // Add welcome message
    _messages.add(
      Message(
        text: "नमस्ते! Hello! I'm your agriculture assistant. Ask me anything about farming, crops, or agricultural practices. मैं हिंदी और अंग्रेजी दोनों में जवाब दे सकता हूं।",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isLoading = true;
      _textController.clear();
    });

    _scrollToBottom();

    try {
      print("In try😀");
      final prompt = '''
You are an agriculture expert chatbot specialized in providing farming advice, crop information, and agricultural best practices.

Important rules:
1. Always respond in BOTH Hindi and English. First provide the Hindi response, then the English response.
2. Only answer questions related to agriculture, farming, crops, soil, irrigation, fertilizers, pesticides, and related topics.
3. If asked about non-agricultural topics, politely redirect the conversation to agriculture.
4. Provide practical, actionable advice that farmers can implement.
5. Keep responses concise but informative.
6. Use simple language that's easy to understand.
7. Include traditional and modern farming techniques when appropriate.

User query: $text
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      print("😀😀😀😀");
      print(response);
      final responseText = response.text ?? 'Sorry, I couldn\'t process your request. Please try again.';

      setState(() {
        _messages.add(Message(text: responseText, isUser: false));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e, stackTrace) {
  print('❌ Gemini API error: $e');
  print('🔍 Stack trace: $stackTrace');
  setState(() {
    _messages.add(
      Message(
        text: "Sorry, I couldn't process your request. Please try again. क्षमा करें, मैं आपके अनुरोध को संसाधित नहीं कर सका। कृपया पुनः प्रयास करें।",
        isUser: false,
      ),
    );
    _isLoading = false;
  });
  _scrollToBottom();
}

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(181, 166, 251, 1),
        title: const Row(
          children: [
            Icon(Icons.agriculture, size: 24),
            SizedBox(width: 8),
            Text('कृषि सहायक'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF5F0FF),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF9D8CE0),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Thinking...'),
                ],
              ),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFFC7B6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: message.isUser
              ? null
              : Border.all(color: const Color(0xFFE6DEFF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.black : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE6DEFF)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Ask about crops, farming techniques, etc...',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              enabled: !_isLoading,
              onSubmitted: _handleSubmit,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _isLoading
                ? null
                : () => _handleSubmit(_textController.text),
            backgroundColor: const Color(0xFF9D8CE0),
            foregroundColor: Colors.white,
            disabledElevation: 0,
            elevation: 2,
            mini: true,
            child: Icon(_isLoading ? Icons.hourglass_empty : Icons.send),
          ),
        ],
      ),
    );
  }
}