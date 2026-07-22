import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SiamAiApp());
}

class SiamAiApp extends StatelessWidget {
  const SiamAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Siam AI Voice Assistant',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F), // YouTube Dark Mode
      ),
      home: const YouTubeStyleLayout(),
    );
  }
}

class YouTubeStyleLayout extends StatefulWidget {
  const YouTubeStyleLayout({super.key});

  @override
  State<YouTubeStyleLayout> createState() => _YouTubeStyleLayoutState();
}

class _YouTubeStyleLayoutState extends State<YouTubeStyleLayout> {
  bool isRagna = true;
  bool isListening = false;
  bool isVideoVisible = true;

  String get activeName => isRagna ? 'RAGNA AI' : 'MAYA AI';
  Color get activeColor => isRagna ? const Color(0xFF3EA6FF) : const Color(0xFFFF4E4E);

  final List<Map<String, String>> _messages = [
    {"sender": "SYSTEM", "text": "Welcome Siam! AI Voice & Video engine initialized."},
    {"sender": "RAGNA AI", "text": "কী খবর দোস্ত? ইউটিউব মোডে অ্যানিমে ক্যারেক্টার ও ভয়েস রেডি!"},
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.microphone,
      Permission.camera,
      Permission.systemAlertWindow,
    ].request();
  }

  void _togglePersona() {
    setState(() {
      isRagna = !isRagna;
      _messages.insert(0, {
        "sender": "SYSTEM",
        "text": "Switched persona to $activeName"
      });
    });
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _messages.insert(0, {
          "sender": activeName,
          "text": "শুনছি দোস্ত, বল তোর কী করতে হবে..."
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text(
              "Siam AI",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ১. ইউটিউব ভিডিও প্লেয়ার সেকশন (যেখানে অ্যানিমে ক্যারেক্টার বা ভিডিও শো করবে)
            if (isVideoVisible)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // এখানে ফোল্ডারের ছবি লোড করার ট্রাই করবে, ছবি না পেলে আইকন দেখাবে
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: activeColor,
                              child: const Icon(Icons.smart_toy, size: 40, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "$activeName LIVE STREAM",
                              style: TextStyle(
                                color: activeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // প্লেয়ার মিনিমাইজ করার বাটন
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVideoVisible = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ২. ইউটিউব ভিডিও টাইটেল ও চ্যানেল ইনফো
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xFF0F0F0F),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Siam AI Assistant - Custom Anime & Voice Edition",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isVideoVisible)
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              isVideoVisible = true;
                            });
                          },
                        )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: activeColor,
                        child: const Icon(Icons.person, color: Colors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Verified AI Channel",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _togglePersona,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: const Text(
                          "Switch Persona",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12, height: 1),

            // ৩. ইউটিউব লাইভ চ্যাট সেকশন
            Expanded(
              child: Container(
                color: const Color(0xFF0F0F0F),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    bool isUser = msg["sender"] == "USER";
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: isUser ? Colors.grey[700] : activeColor,
                            child: Icon(
                              isUser ? Icons.person : Icons.smart_toy,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg["sender"]!,
                                  style: TextStyle(
                                    color: isUser ? Colors.grey : activeColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  msg["text"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // ৪. ইউটিউব স্টাইল ভয়েস ইনপুট বার
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF212121),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF383838),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        isListening ? "Listening your voice..." : "Type or speak to Siam AI...",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleListening,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: isListening ? Colors.red : activeColor,
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 22,
                      ),
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
}
