import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SynapseApp());
}

class SynapseApp extends StatelessWidget {
  const SynapseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SYNAPSE AI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
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
  // ব্যাকএন্ড ইউআরএল
  final String baseUrl = "https://siyammahamud53-code.onrender.com";

  // ক্যারেক্টার স্টেট ('ragna' অথবা 'maya')
  String currentPersona = "ragna"; 
  bool isGamingMode = false;
  bool isLoading = false;

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // ক্যারেক্টার চেঞ্জ ফাংশন
  Future<void> switchPersona(String personaName) async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/switch'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'persona': personaName}),
      );

      if (response.statusCode == 200) {
        setState(() {
          currentPersona = personaName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(personaName == 'ragna' ? '⚡ রাগনা একটিভ হয়েছে!' : '🌸 মায়া একটিভ হয়েছে!'),
            backgroundColor: personaName == 'ragna' ? Colors.cyan : Colors.pinkAccent,
          ),
        );
      }
    } catch (e) {
      print("Error switching persona: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // মেসেজ পাঠানোর ফাংশন
  Future<void> sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      isLoading = true;
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': userMessage,
          'user_id': 'siam_user',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _messages.add({"sender": "ai", "text": data['reply']});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "ai", "text": "⚠️ ব্যাকএন্ডের সাথে সংযোগ পাওয়া যাচ্ছে না দোস্ত!"});
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // রাগনার জন্য সাইয়ান (Cyan) এবং মায়ার জন্য পিঙ্ক (Pink) কালার থিম
    final themeColor = currentPersona == 'ragna' ? const Color(0xFF00E5FF) : const Color(0xFFFF4081);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161823),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: themeColor),
            const SizedBox(width: 8),
            Text(
              'SYNAPSE AI',
              style: TextStyle(fontWeight: FontWeight.bold, color: themeColor, letterSpacing: 1.2),
            ),
          ],
        ),
        actions: [
          // গেম মোড বাটন
          IconButton(
            icon: Icon(
              isGamingMode ? Icons.sports_esports : Icons.sports_esports_outlined,
              color: isGamingMode ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isGamingMode = !isGamingMode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isGamingMode ? '🎮 গেম মোড চালু!' : '⚙️ নরমাল মোড চালু!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== ১. ডুয়েল অবতার সুইচার হেডার =====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFF10121D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // রাগনা বাটন
                GestureDetector(
                  onTap: () => switchPersona('ragna'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: currentPersona == 'ragna' ? const Color(0xFF00E5FF).withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: currentPersona == 'ragna' ? const Color(0xFF00E5FF) : Colors.grey.shade800,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.face, color: Color(0xFF00E5FF)),
                        SizedBox(width: 6),
                        Text('রাগনা (Ragna)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

                // মায়া বাটন
                GestureDetector(
                  onTap: () => switchPersona('maya'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: currentPersona == 'maya' ? const Color(0xFFFF4081).withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: currentPersona == 'maya' ? const Color(0xFFFF4081) : Colors.grey.shade800,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.face_3, color: Color(0xFFFF4081)),
                        SizedBox(width: 6),
                        Text('মায়া (Maya)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== ২. চ্যাট বডি =====
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 30, spreadRadius: 5),
                            ],
                          ),
                          child: Icon(
                            currentPersona == 'ragna' ? Icons.smart_toy : Icons.face_3_rounded,
                            size: 70,
                            color: themeColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          currentPersona == 'ragna' ? 'রাগনা অনলাইন! কীভাবে সাহায্য করব দোস্ত?' : 'মায়া শুনছে... কিছু বলবে?',
                          style: TextStyle(color: themeColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? themeColor.withOpacity(0.2) : const Color(0xFF161823),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: isUser ? themeColor : Colors.grey.shade800),
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (isLoading)
            LinearProgressIndicator(color: themeColor, backgroundColor: Colors.transparent),

          // ===== ৩. ইনপুট বার =====
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF161823),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: currentPersona == 'ragna' ? 'কথা বল রাগনার সাথে...' : 'কথা বল মায়ার সাথে...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: themeColor),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
