import 'dart:async';
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
        scaffoldBackgroundColor: const Color(0xFF0D0F12), // Cyberpunk Dark
      ),
      home: const CyberDashboardPage(),
    );
  }
}

class CyberDashboardPage extends StatefulWidget {
  const CyberDashboardPage({super.key});

  @override
  State<CyberDashboardPage> createState() => _CyberDashboardPageState();
}

class _CyberDashboardPageState extends State<CyberDashboardPage>
    with SingleTickerProviderStateMixin {
  // ক্যারেক্টার স্টেট (Ragna / Maya)
  bool isRagna = true;
  bool isListening = false;
  
  // অ্যানিমেশন কন্ট্রোলার (Glowing Avatar Pulse)
  late AnimationController _pulseController;
  
  // ক্যারেক্টার তথ্য
  String get activeName => isRagna ? 'RAGNA' : 'MAYA';
  String get activeAvatarPath =>
      isRagna ? 'assets/icons/ragna_avatar.png' : 'assets/icons/maya_avatar.png';
  Color get activeThemeColor =>
      isRagna ? const Color(0xFF00E5FF) : const Color(0xFFFF2A85); // Neon Cyan / Neon Pink

  // সাইবার লগ স্ট্রিম
  final List<String> _logs = [
    "[SYSTEM]: Initializing Siam AI Core...",
    "[NETWORK]: Render Backend Sync: OK",
    "[AUDIO]: High-Fidelity Waveform Ready.",
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleAvatar() {
    setState(() {
      isRagna = !isRagna;
      _logs.insert(0, "[USER]: Switched Partner Persona to $activeName");
    });
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _logs.insert(0, "[$activeName]: Listening to Siam...");
      } else {
        _logs.insert(0, "[SYSTEM]: Audio Processing Complete.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.stretch,
            children: [
              // ১. টপ হেডার ও ক্যারেক্টার সুইচ বার
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      const Text(
                        "SIAM AI OS v1.0",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ACTIVE: $activeName",
                        style: TextStyle(
                          color: activeThemeColor,
                          fontSize: 20,
                          fontWeight: FontWeight.extrabold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  // ক্যারেক্টার সুইচ বাটন
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeThemeColor.withOpacity(0.2),
                      side: BorderSide(color: activeThemeColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _toggleAvatar,
                    icon: Icon(Icons.swap_horiz, color: activeThemeColor),
                    label: Text(
                      isRagna ? "Switch to Maya" : "Switch to Ragna",
                      style: TextStyle(color: activeThemeColor, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // ২. অ্যানিমে ডিসপ্লে বক্স উইথ নেওন গ্লো (Avatar Circle)
              Expanded(
                flex: 5,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      double glowRadius = 15 + (_pulseController.value * 20);
                      return Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeThemeColor.withOpacity(0.6),
                              blurRadius: glowRadius,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color: activeThemeColor,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            activeAvatarPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // ছবি লোড না হলে সাইবার প্লেসহোল্ডার
                              return Container(
                                color: Colors.black54,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person, size: 60, color: activeThemeColor),
                                    const SizedBox(height: 8),
                                    Text(
                                      activeName,
                                      style: TextStyle(color: activeThemeColor),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ৩. সাইবার ব্যাকএন্ড স্ট্রিম লগার (Terminal Log Window)
              Container(
                height: 110,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: index == 0 ? activeThemeColor : Colors.grey[400],
                      ),
                      child: Text(_logs[index]),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ৪. ডায়নামিক ভয়েস ট্রিগার বাটন
              Center(
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isListening ? activeThemeColor : Colors.black,
                      border: Border.all(color: activeThemeColor, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: activeThemeColor.withOpacity(0.4),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      size: 35,
                      color: isListening ? Colors.black : activeThemeColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Center(
                child: Text(
                  isListening ? "LISTENING..." : "TAP MIC TO SPEAK",
                  style: TextStyle(
                    color: activeThemeColor.withOpacity(0.8),
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
