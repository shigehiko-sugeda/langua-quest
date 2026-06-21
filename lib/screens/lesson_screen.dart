import 'package:flutter/material.dart';

import '../models/app_progress.dart';
import '../models/vocab_word.dart';
import '../services/speech_service.dart';
import 'quiz_screen.dart';

class LessonScreen extends StatelessWidget {
  LessonScreen({
    super.key,
    required this.languageCode,
    required this.words,
    required this.progress,
  });

  final String languageCode;
  final List<VocabWord> words;
  final CourseProgress progress;
  final SpeechService _speech = SpeechService();

  Widget _buttonLabel(String label) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        textWidthBasis: TextWidthBasis.parent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = (progress.completedLessons * 10) % words.length;
    final lessonWords =
        List.generate(10, (index) => words[(start + index) % words.length]);
    return Scaffold(
      appBar: AppBar(title: const Text('今日の10語')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessonWords.length + 1,
        itemBuilder: (context, index) {
          if (index == lessonWords.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      languageCode: languageCode,
                      lessonWords: lessonWords,
                      allWords: words,
                      progress: progress,
                      isReview: false,
                    ),
                  ),
                ),
                child: _buttonLabel('クイズへすすむ'),
              ),
            );
          }
          final word = lessonWords[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.japanese,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                    ),
                  ),
                  Text(
                    word.target,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'よみかた: ${word.pronunciation}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(word.example, style: const TextStyle(fontSize: 16)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _speech.speak(word.target, languageCode),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up),
                          SizedBox(width: 6),
                          Text(
                            'きく',
                            textWidthBasis: TextWidthBasis.parent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
