import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/voice_ai_service.dart';

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
  bool isFullScreen = false;
  bool isSpeaking = false;

  final TextEditingController _textController = TextEditingController();
  final VoiceAIService _voiceService = VoiceAIService();

  String get activeName => isRagna ? 'RAGNA AI' : 'MAYA AI';
  Color get activeColor => isRagna ? const Color(0xFF00E5FF) : const Color(0xFFFF007F);
  String get activeAvatar => isRagna 
      ? 'assets/icons/ragna_avatar.png.jpg' 
      : 'assets/icons/maya_avatar.png.jpg';

  final List<Map<String, String>> _messages = [
    {"sender": "SYSTEM", "text": "Cinematic AI Engine Active."},
    {"sender": "RAGNA AI", "text": "কী খবর সিয়াম দোস্ত? বল তোর কী সাহায্য লাগবে!"},
  ];

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await [
      Permission.microphone,
      Permission.camera,
      Permission.systemAlertWindow,
    ].request();
    await _voiceService.initVoice();
  }

  void _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.insert(0, {"sender": "USER", "text": text});
      _textController.clear();
    });

    await _voiceService.processAiResponse(text, (speaking) {
      if (mounted) {
        setState(() {
          isSpeaking = speaking;
        });
      }
    }, (aiReply) {
      if (mounted) {
        setState(() {
          _messages.insert(0, {"sender": activeName, "text": aiReply});
        });
      }
    });
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

  void _startVoiceListening() async {
    await _voiceService.startListening((recognizedText) {
      _handleSendMessage(recognizedText);
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
                    ),
                    child: const Text("S", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
                  ),
                  const SizedBox(width: 10),
                  const Text("SIAM AI", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white)),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white70),
                  onPressed: () => setState(() => isFullScreen = !isFullScreen),
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: isFullScreen ? MediaQuery.of(context).size.height * 0.75 : MediaQuery.of(context).size.height * 0.32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: activeColor.withOpacity(0.4), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    scale: isSpeaking ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.all(isSpeaking ? 8 : 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: activeColor, width: isSpeaking ? 4 : 2),
                        boxShadow: [
                          BoxShadow(color: activeColor.withOpacity(isSpeaking ? 0.8 : 0.3), blurRadius: isSpeaking ? 25 : 10)
                        ],
                      ),
                      child: CircleAvatar(
                        radius: isFullScreen ? 75 : 45,
                        backgroundColor: Colors.black,
                        backgroundImage: AssetImage(activeAvatar),
                      ),
                    ),
                  ),
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
                        style: TextStyle(color: activeColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (!isFullScreen)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFF0A0A0E),
                child: Row(
                  children: [
                    CircleAvatar(radius: 16, backgroundColor: Colors.black, backgroundImage: AssetImage(activeAvatar)),
                    const SizedBox(width: 10),
                    Text(activeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _togglePersona,
                      style: ElevatedButton.styleFrom(backgroundColor: activeColor, foregroundColor: Colors.black),
                      child: const Text("Switch Persona", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
              ),

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
                          child: Icon(isUser ? Icons.person : Icons.smart_toy, size: 14, color: isUser ? Colors.white : Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(msg["sender"]!, style: TextStyle(color: isUser ? Colors.grey : activeColor, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(msg["text"]!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2C),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: "Ask Siam AI...",
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                        onSubmitted: _handleSendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: activeColor),
                    onPressed: () => _handleSendMessage(_textController.text),
                  ),
                  GestureDetector(
                    onTap: _startVoiceListening,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: activeColor),
                      child: const Icon(Icons.mic, color: Colors.black, size: 20),
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
