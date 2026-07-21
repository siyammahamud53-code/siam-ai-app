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
        scaffoldBackgroundColor: const Color(0xFF0A0B10), // Deep Cyber Dark
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
  final String baseUrl = "https://siyammahamud53-code.onrender.com";

  String currentPersona = "ragna"; 
  bool isGamingMode = false;
  bool isLoading = false;

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // ক্যারেক্টার সুইচিং
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
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // মেসেজ পাঠানো
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
    // রাগনার জন্য সাইয়ান নেওন, মায়ার জন্য পিঙ্ক নেওন
    final Color primaryGlow = currentPersona == 'ragna' 
        ? const Color(0xFF00E5FF) 
        : const Color(0xFFFF007F);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121420),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGlow.withOpacity(0.2),
                border: Border.all(color: primaryGlow, width: 1.5),
              ),
              child: Icon(Icons.bolt, color: primaryGlow, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'SYNAPSE AI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [Shadow(color: primaryGlow, blurRadius: 10)],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isGamingMode ? Icons.sports_esports : Icons.sports_esports_outlined,
              color: isGamingMode ? primaryGlow : Colors.grey,
            ),
            onPressed: () {
              setState(() => isGamingMode = !isGamingMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== ১. ক্যারেক্টার সুইচার ট্যাবস =====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFF0D0E15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // RAGNA TAB
                GestureDetector(
                  onTap: () => switchPersona('ragna'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: currentPersona == 'ragna' ? const Color(0xFF00E5FF).withOpacity(0.15) : const Color(0xFF161823),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: currentPersona == 'ragna' ? const Color(0xFF00E5FF) : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: currentPersona == 'ragna' 
                          ? [BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.3), blurRadius: 10)]
                          : [],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Color(0xFF00E5FF), size: 18),
                        SizedBox(width: 8),
                        Text('RAGNA (Male)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

                // MAYA TAB
                GestureDetector(
                  onTap: () => switchPersona('maya'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: currentPersona == 'maya' ? const Color(0xFFFF007F).withOpacity(0.15) : const Color(0xFF161823),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: currentPersona == 'maya' ? const Color(0xFFFF007F) : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: currentPersona == 'maya' 
                          ? [BoxShadow(color: const Color(0xFFFF007F).withOpacity(0.3), blurRadius: 10)]
                          : [],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Color(0xFFFF007F), size: 18),
                        SizedBox(width: 8),
                        Text('MAYA (Female)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                        // গ্লোয়িং অবতার রিং
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF121420),
                            border: Border.all(color: primaryGlow, width: 2),
                            boxShadow: [
                              BoxShadow(color: primaryGlow.withOpacity(0.4), blurRadius: 30, spreadRadius: 2),
                            ],
                          ),
                          child: Icon(
                            currentPersona == 'ragna' ? Icons.psychology : Icons.face_3,
                            size: 70,
                            color: primaryGlow,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          currentPersona == 'ragna' ? '⚡ RAGNA ONLINE' : '🌸 MAYA ONLINE',
                          style: TextStyle(
                            color: primaryGlow,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentPersona == 'ragna' ? 'কী খবর সিয়াম দোস্ত? বল কী সাহায্য লাগবে!' : 'শুনছি সিয়াম, মিষ্টি কিছু বলবে নাকি?',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser ? primaryGlow.withOpacity(0.15) : const Color(0xFF121420),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                              bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                            ),
                            border: Border.all(
                              color: isUser ? primaryGlow : Colors.white10,
                            ),
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
            LinearProgressIndicator(color: primaryGlow, backgroundColor: Colors.transparent),

          // ===== ৩. ফিউচারিস্টিক ইনপুট ফিল্ড =====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF121420),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0B10),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: primaryGlow.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: currentPersona == 'ragna' ? 'রাগনাকে কমান্ড দে...' : 'মায়াকে কিছু বল...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryGlow,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                    onPressed: sendMessage,
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
