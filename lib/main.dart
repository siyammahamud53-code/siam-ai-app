import 'package:flutter/material.dart';

void main() {
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
        scaffoldBackgroundColor: const Color(0xFF0D0F12),
      ),
      home: const MainCyberLayout(),
    );
  }
}

class MainCyberLayout extends StatefulWidget {
  const MainCyberLayout({super.key});

  @override
  State<MainCyberLayout> createState() => _MainCyberLayoutState();
}

class _MainCyberLayoutState extends State<MainCyberLayout> {
  bool isRagna = true;
  bool isListening = false;

  String get activeName => isRagna ? 'RAGNA' : 'MAYA';
  Color get activeThemeColor =>
      isRagna ? const Color(0xFF00E5FF) : const Color(0xFFFF2A85);

  final List<Map<String, String>> _messages = [
    {"sender": "SYSTEM", "text": "[SYSTEM]: Siam AI Background Core Active."},
    {"sender": "RAGNA", "text": "কী খবর সিয়াম দোস্ত? আমি ব্যাকগ্রাউন্ডে প্রস্তুত আছি!"},
  ];

  void _toggleAvatar() {
    setState(() {
      isRagna = !isRagna;
      _messages.insert(0, {
        "sender": "SYSTEM",
        "text": "[SYSTEM]: Switched to $activeName Mode"
      });
    });
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _messages.insert(0, {
          "sender": activeName,
          "text": "শুনছি দোস্ত, বল কী সাহায্য করতে হবে..."
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161920),
        title: Text(
          "SIAM AI - $activeName",
          style: TextStyle(color: activeThemeColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz, color: activeThemeColor),
            onPressed: _toggleAvatar,
            tooltip: "Switch Persona",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ১. ওপরে লাইভ ভিডিও / ক্যারেক্টার ডিসপ্লে (Top 35% Screen)
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: activeThemeColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: activeThemeColor.withOpacity(0.3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.live_tv, size: 50, color: activeThemeColor),
                        const SizedBox(height: 8),
                        Text(
                          "$activeName LIVE DISPLAY",
                          style: TextStyle(
                            color: activeThemeColor,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("ভিডিও মিনিমাইজ করা হয়েছে। ব্যাকগ্রাউন্ডে এআই এক্টিভ আছে!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ২. নিচে চ্যাট হিস্ট্রি ডিসপ্লে (Bottom Full Chat)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF12141A),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    bool isUser = msg["sender"] == "USER";
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isUser
                              ? activeThemeColor.withOpacity(0.2)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isUser ? activeThemeColor : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          "${msg['sender']}: ${msg['text']}",
                          style: TextStyle(
                            color: isUser ? activeThemeColor : Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ৩. নিচে ভয়েস কন্ট্রোল
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        isListening ? "Listening to Siam..." : "Tap mic to command...",
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleListening,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: activeThemeColor,
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
