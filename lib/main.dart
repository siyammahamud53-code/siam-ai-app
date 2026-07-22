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
      title: 'Siam AI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0E), // Ultra Dark Cyber Mode
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
  Color get activeColor => isRagna ? const Color(0xFF00E5FF) : const Color(0xFFFF007F); // Neon Cyan & Pink

  // তোর গিটহাবের রিয়েল ফাইলের নাম অনুযায়ী অ্যাভাটার ইমেজ পাথ
  String get activeAvatar => isRagna 
      ? 'assets/icons/ragna_avatar.png.jpg' 
      : 'assets/icons/maya_avatar.png.jpg';

  final List<Map<String, String>> _messages = [
    {"sender": "SYSTEM", "text": "Siam AI Voice Engine Loaded."},
    {"sender": "RAGNA AI", "text": "কী খবর দোস্ত? প্রিমিয়াম নিয়ন ইন্টারফেস ও কাস্টম অ্যাভাটার একদম রেডি!"},
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
        "text": "Switched Avatar to $activeName"
      });
    });
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _messages.insert(0, {
          "sender": activeName,
          "text": "শুনছি সিয়াম, বল তোর কী লাগবে..."
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0E),
        elevation: 0,
        title: Row(
          children: [
            // স্টারের বদলে প্রিমিয়াম নিয়ন 'S' হেডার লোগো
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFFFF007F)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.5),
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Text(
                "S",
                style: TextStyle(
                  fontWeight: FontWeight.black,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFFFFFFFF)],
              ).createShader(bounds),
              child: const Text(
                "SIAM AI",
                style: TextStyle(
                  fontWeight: FontWeight.extrabold,
                  fontSize: 20,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.cast, color: Colors.white70), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white70), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: Colors.white70), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ১. কাস্টম ভিডিও ও অ্যানিমে অ্যাভাটার ডিসপ্লে
            if (isVideoVisible)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: activeColor.withOpacity(0.3), width: 1),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // এখানে গিটহাবের আসল অ্যানিমে অ্যাভাটার ইমেজ লোড হবে
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: activeColor, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: activeColor.withOpacity(0.4),
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.black,
                                backgroundImage: AssetImage(activeAvatar),
                                onBackgroundImageError: (_, __) {},
                                child: Image.asset(
                                  activeAvatar,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.person,
                                    size: 45,
                                    color: activeColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$activeName LIVE",
                              style: TextStyle(
                                color: activeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
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

            // ২. টাইটেল ও চ্যানেল সুইচ সেকশন
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xFF0A0A0E),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage(activeAvatar),
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
                        "AI Persona Mode",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _togglePersona,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text(
                      "Switch Avatar",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12, height: 1),

            // ৩. ইউটিউব লাইভ চ্যাট
            Expanded(
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
                          backgroundColor: isUser ? Colors.grey[800] : activeColor,
                          child: Icon(
                            isUser ? Icons.person : Icons.smart_toy,
                            size: 14,
                            color: isUser ? Colors.white : Colors.black,
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

            // ৪. প্রিমিয়াম ভয়েস কন্ট্রোল বার
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF14141E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2C),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        isListening ? "Listening your command..." : "Ask Siam AI...",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleListening,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isListening ? Colors.red : activeColor,
                        boxShadow: [
                          BoxShadow(
                            color: (isListening ? Colors.red : activeColor).withOpacity(0.5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.black,
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
