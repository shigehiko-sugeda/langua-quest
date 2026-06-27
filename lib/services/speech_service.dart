import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  SpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;

  Future<void> speak(String text, String languageCode) async {
    await _tts.setLanguage(languageCode == 'ko' ? 'ko-KR' : 'en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }
}
