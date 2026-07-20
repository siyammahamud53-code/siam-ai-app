import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF060913), // Deep Cosmos Background
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _auraController;
  
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'স্বাগতম সিয়াম দোস্ত! AURA-X সিস্টেম অ্যাক্টিভ। আজকের নির্দেশ বলো?'
    }
  ];
  bool _isLoading = false;

  // Render Server URL
  final String _apiUrl = "https://siam-ai-backend.onrender.com/chat";

  @override
  void initState() {
    super.initState();
    // Continuous aura breathing animation
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _auraController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({'sender': 'ai', 'text': data['reply'] ?? 'কোনো উত্তর পাওয়া যায়নি!'});
        });
      } else {
        setState(() {
          _messages.add({'sender': 'ai', 'text': 'সার্ভার রেসপন্স করছে না দোস্ত! ব্যাকএন্ড কানেকশন চেক কর।'});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': 'নেটওয়ার্ক সমস্যা অথবা সার্ভার অফলাইন আছে!'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'A U R A - X',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
            color: const Color(0xFF00F2FE),
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.black.withAlpha(50),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Dynamic Glowing Energy Aura Background
          AnimatedBuilder(
            animation: _auraController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -80 + (_auraController.value * 20),
                    left: -80 + (_auraController.value * 20),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00F2FE).withAlpha((60 + (_auraController.value * 40)).toInt()),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F2FE).withAlpha(100),
                            blurRadius: 150,
                            spreadRadius: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40 - (_auraController.value * 20),
                    right: -80,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4FACFE).withAlpha((50 + (_auraController.value * 30)).toInt()),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C6FF).withAlpha(90),
                            blurRadius: 160,
                            spreadRadius: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Layout
          SafeArea(
            child: Column(
              children: [
                // Anime Character Soul Core Display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withAlpha(25),
                          Colors.white.withAlpha(5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF00F2FE).withAlpha(90),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F2FE).withAlpha(30),
                          blurRadius: 20,
                          spreadRadius: -5,
                        )
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00F2FE).withAlpha(30),
                              border: Border.all(color: const Color(0xFF00F2FE)),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 40,
                              color: Color(0xFF00F2FE),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AURA-X SOUL CORE',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Aura Level: Max | Engine Ready',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF00F2FE),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Chat Messages List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.78,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF00F2FE).withAlpha(40)
                                : Colors.black.withAlpha(120),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isUser ? 20 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 20),
                            ),
                            border: Border.all(
                              color: isUser
                                  ? const Color(0xFF00F2FE)
                                  : Colors.white.withAlpha(40),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF00F2FE),
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                // Glassmorphism Input Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(100),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFF00F2FE).withAlpha(80),
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: GoogleFonts.outfit(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'AURA-X কে কিছু জিজ্ঞেস করো...',
                              hintStyle: GoogleFonts.outfit(color: Colors.white38),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00F2FE).withAlpha(100),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.black),
                          onPressed: _sendMessage,
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
