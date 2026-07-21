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
        scaffoldBackgroundColor: const Color(0xFF07090E), // Ultra Dark Obsidian
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
  late AnimationController _pulseController;
  
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'AURA-X নিওন কোর অনলাইন। স্বাগতম সিয়াম দোস্ত! বলো কীভাবে সাহায্য করতে পারি?'
    }
  ];
  bool _isLoading = false;

  final String _apiUrl = "https://siam-ai-backend.onrender.com/chat";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            letterSpacing: 6.0,
            color: const Color(0xFFBD00FF), // Cyber Neon Purple
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Atmosphere Soft Glow (No circles)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  radialGradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2 + (_pulseController.value * 0.2),
                    colors: [
                      const Color(0xFFBD00FF).withOpacity(0.25), // Neon Violet Soft Atmosphere
                      const Color(0xFF00F0FF).withOpacity(0.10), // Electric Cyan Atmosphere
                      const Color(0xFF07090E), // Deep Dark Background
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),

          // Main Screen Content
          SafeArea(
            child: Column(
              children: [
                // Futuristic Glass Soul Core Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFBD00FF).withOpacity(0.2),
                          const Color(0xFF00F0FF).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFBD00FF).withOpacity(0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFBD00FF).withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFBD00FF).withOpacity(0.2),
                                border: Border.all(
                                  color: const Color(0xFF00F0FF),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFBD00FF).withOpacity(0.6 * _pulseController.value),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.psychology_rounded,
                                size: 36,
                                color: Color(0xFF00F0FF),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 18),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SYSTEM CORE: ONLINE',
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Aura Protocol: Cyber Violet',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF00F0FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                ? const Color(0xFFBD00FF).withOpacity(0.3)
                                : Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isUser ? 18 : 2),
                              bottomRight: Radius.circular(isUser ? 2 : 18),
                            ),
                            border: Border.all(
                              color: isUser
                                  ? const Color(0xFFBD00FF)
                                  : const Color(0xFF00F0FF).withOpacity(0.3),
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
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Color(0xFF00F0FF),
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
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFBD00FF).withOpacity(0.5),
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: GoogleFonts.outfit(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'AURA-X কে কমান্ড দাও...',
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
                            colors: [Color(0xFFBD00FF), Color(0xFF00F0FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFBD00FF).withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
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
