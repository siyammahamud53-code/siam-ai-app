import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const AuraXApp());
}

class AuraXApp extends StatelessWidget {
  const AuraXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA-X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0608),
        primaryColor: const Color(0xFFE60039),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  final String _backendUrl = "https://siyammahamud53-code.onrender.com/chat";

  final List<Map<String, String>> _messages = [
    {
      'sender': 'aura',
      'text': 'স্বাগতম সিয়াম দোস্ত! AURA-X রেন্ডার ব্যাকএন্ড কানেক্টেড। কিছু জিজ্ঞেস করে দেখতে পারিস!'
    }
  ];

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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      ).timeout(const Duration(seconds: 25));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['reply'] ?? data['response'] ?? 'কোনো রেসপন্স পাওয়া যায়নি!';
        setState(() {
          _messages.add({'sender': 'aura', 'text': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'aura',
            'text': 'সার্ভার রেসপন্স করছে না (Code: ${response.statusCode})। কিছুক্ষণ পর চেষ্টা কর দোস্ত!'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'aura',
          'text': 'নেটওয়ার্ক সমস্যা অথবা রেন্ডার সার্ভার স্লিপ মোডে আছে! ব্যাকএন্ড আবার টিপে দে বা একটু অপেক্ষা কর।'
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow Effects
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE60039).withOpacity(0.25),
                blurRadius: 120,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8A00FF).withOpacity(0.2),
                blurRadius: 100,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.change_history, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'A U R A - X',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: const Color(0xFFE60039).withOpacity(0.8), blurRadius: 12)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE60039).withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE60039).withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE60039).withOpacity(0.2),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.memory, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RENDER CORE: CONNECTED',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isLoading ? 'জেমিনি প্রসেস করছে...' : 'Aura Protocol: Crimson Triangle',
                            style: const TextStyle(color: Color(0xFFFFA5A8), fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Messages Area
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                          decoration: BoxDecoration(
                            color: isUser 
                                ? const Color(0xFFE60039).withOpacity(0.85)
                                : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                              bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                            ),
                            border: Border.all(
                              color: isUser ? Colors.transparent : Colors.white.withOpacity(0.15),
                            ),
                          ),
                          child: Text(
                            msg['text']!,
                            style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Input Bar
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE60039).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            hintText: 'AURA-X কে কমান্ড দাও...',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFE60039), Color(0xFF8A00FF)],
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.send, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
