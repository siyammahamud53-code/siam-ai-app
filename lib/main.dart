import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const SiamAiApp());
}

class SiamAiApp extends StatelessWidget {
  const SiamAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siam AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'হ্যালো সিয়াম দোস্ত! আমি তোর AI অ্যাসিস্ট্যান্ট। কীভাবে সাহায্য করতে পারি?'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': _messageController.text,
      });
      _messages.add({
        'sender': 'ai',
        'text': 'তোর বার্তা পেয়েছি! লাইভ ব্যাকএন্ড রেডি হলে আমি এক সেকেন্ডে রিপ্লাই দেব।',
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Siam AI Assistant',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Glowing Orbs
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withAlpha(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withAlpha(150),
                    blurRadius: 100,
                    spreadRadius: 20,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withAlpha(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha(150),
                    blurRadius: 100,
                    spreadRadius: 20,
                  )
                ],
              ),
            ),
          ),
          // Main UI
          Column(
            children: [
              // Character Avatar Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.smart_toy_rounded,
                          size: 60,
                          color: Colors.purpleAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '3D AI Character Active',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Chat List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.purpleAccent.withAlpha(180)
                              : Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Input Box
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'এখানে কিছু লেখ দোস্ত...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white.withAlpha(20),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      radius: 25,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
