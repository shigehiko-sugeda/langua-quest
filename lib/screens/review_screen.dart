import 'package:flutter/material.dart';

import '../models/app_progress.dart';
import '../models/vocab_word.dart';
import 'quiz_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key, required this.languageCode, required this.words, required this.progress});
  final String languageCode;
  final List<VocabWord> words;
  final CourseProgress progress;

  @override
  Widget build(BuildContext context) {
    final missedIds = progress.missedWords.keys.toSet();
    final reviewWords = words.where((word) => missedIds.contains(word.id)).toList();
    return QuizScreen(languageCode: languageCode, lessonWords: reviewWords, allWords: words, progress: progress, isReview: true);
  }
}
