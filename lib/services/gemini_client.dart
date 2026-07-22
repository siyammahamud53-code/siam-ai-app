import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiClient {
  // TODO: তোর Gemini API Key টা খালি জায়গায় বসাবি
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  Future<String> sendMessage(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'দুঃখিত দোস্ত, কোনো রেসপন্স পাওয়া যায়নি।';
    } catch (e) {
      return 'এরর ঘটেছে: $e';
    }
  }
}
