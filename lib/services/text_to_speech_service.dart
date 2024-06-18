import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  FlutterTts? flutterTts;

  Future init() async {
    flutterTts = FlutterTts();
  }

  void textToSpeech({ required String text }) async {
    await flutterTts?.setLanguage("en-US");
    await flutterTts?.setVolume(1.0);
    await flutterTts?.setSpeechRate(0.5);
    await flutterTts?.setPitch(1.0);
    await flutterTts?.speak(text);
  }

  void dispose() async {
    await flutterTts?.stop();
  }
}
