import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'gemini_client.dart';

class VoiceAIService {
  final SpeechToText _stt = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final GeminiClient _geminiClient = GeminiClient();

  bool isListening = false;
  bool isSpeaking = false;

  Future<void> initVoice() async {
    await _stt.initialize();
    await _tts.setLanguage("bn-BD");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  Future<void> startListening(Function(String text) onResultText) async {
    bool available = await _stt.initialize();
    if (available) {
      isListening = true;
      _stt.listen(
        onResult: (result) {
          if (result.finalResult) {
            isListening = false;
            onResultText(result.recognizedWords);
          }
        },
      );
    }
  }

  Future<void> stopListening() async {
    await _stt.stop();
    isListening = false;
  }

  Future<void> processAiResponse(
    String text, 
    Function(bool speaking) onSpeakingChange,
    Function(String aiReply) onReplyReceived
  ) async {
    onSpeakingChange(true);
    isSpeaking = true;

    String responseText = await _geminiClient.sendMessage(text);
    onReplyReceived(responseText);

    await _tts.speak(responseText);

    _tts.setCompletionHandler(() {
      onSpeakingChange(false);
      isSpeaking = false;
    });
  }
}
