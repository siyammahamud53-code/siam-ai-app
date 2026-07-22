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
        scaffoldBackgroundColor: const Color(0xFF0A0A0E),
      ),
      home: const CyberCinematicLayout(),
    );
  }
}

class CyberCinematicLayout extends StatefulWidget {
  const CyberCinematicLayout({super.key});

  @override
  State<CyberCinematicLayout> createState() => _CyberCinematicLayoutState();
}

class _CyberCinematicLayoutState extends State<CyberCinematicLayout> {
  bool isRagna = true;
  bool isListening = false;
  bool isFullScreen = false;
  bool isSpeaking = false;

  String get activeName => isRagna ? 'RAGNA AI' : 'MAYA AI';
  Color get activeColor => isRagna ? const Color(0xFF00E5FF) : const Color(0xFFFF007F);

  String get activeAvatar => isRagna 
      ? 'assets/icons/ragna_avatar.png.jpg' 
      : 'assets/icons/maya_avatar.png.jpg';

  final List<Map<String, String>> _messages = [
    {"sender": "SYSTEM", "text": "Cinematic AI Engine & Camera Tracking Active."},
    {"sender": "RAGNA AI", "text": "কী খবর সিয়াম দোস্ত? এখন আমি কথা বললে জুম হব এবং ক্যামেরা মুভ করবে!"},
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
      isSpeaking = isListening;
      if (isListening) {
        _messages.insert(0, {
          "sender": activeName,
          "text": "শুনছি সিয়াম, বল তোর কী করতে হবে..."
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF0A0A0E),
              elevation: 0,
              title: Row(
                children: [
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
                  const Text(
                    "SIAM AI",
                    style: TextStyle(
                      fontWeight: FontWeight.extrabold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      isFullScreen = !isFullScreen;
                    });
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            // ১. সিনেমাটিক মুভিং ও ফুল স্ক্রিন ডিসপ্লে
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: isFullScreen
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: activeColor.withOpacity(0.4), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ক্যারেক্টার জুম ও মুভমেন্ট অ্যানিমেশন
                  AnimatedScale(
                    scale: isSpeaking ? 1.25 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(isSpeaking ? 8 : 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: activeColor, width: isSpeaking ? 4 : 2),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(isSpeaking ? 0.8 : 0.3),
                            blurRadius: isSpeaking ? 25 : 10,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: isFullScreen ? 75 : 45,
                        backgroundColor: Colors.black,
                        backgroundImage: AssetImage(activeAvatar),
                        child: Image.asset(
                          activeAvatar,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 50,
                            color: activeColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ফুল স্ক্রিন টগল বাটন
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFullScreen = !isFullScreen;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // লাইভ স্টেটাস টেক্সট
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: activeColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        isSpeaking ? "• $activeName SPEAKING..." : "• $activeName IDLE",
                        style: TextStyle(
                          color: activeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ২. টাইটেল ও সাবস্ক্রাইব/সুইচ সেকশন
            if (!isFullScreen)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFF0A0A0E),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black,
                      backgroundImage: AssetImage(activeAvatar),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      activeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text(
                        "Switch Persona",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),

            if (!isFullScreen) const Divider(color: Colors.white12, height: 1),

            // ৩. লাইভ চ্যাট হিস্ট্রি
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
                        isListening ? "Listening to Siam..." : "Ask Siam AI...",
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
