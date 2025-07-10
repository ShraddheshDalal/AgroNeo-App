import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyCQkJQ5iKy47My7soMdHkQ4xEnqvzgmSJ4', // 🔒 Replace with your actual Gemini API key
  );

  try {
    final response = await model.generateContent([
      Content.text('गेहूं की खेती के लिए कौनसी मिट्टी सबसे उपयुक्त है?')
    ]);
    print('✅ Response: ${response.text}');
  } catch (e) {
    print('❌ Gemini API error: $e');
  }
}
