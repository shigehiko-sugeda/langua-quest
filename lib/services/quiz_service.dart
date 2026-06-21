import 'dart:math';

import '../models/vocab_word.dart';

enum QuizDirection { japaneseToTarget, targetToJapanese }

class QuizQuestion {
  const QuizQuestion({
    required this.word,
    required this.direction,
    required this.prompt,
    required this.correctAnswer,
    required this.options,
  });

  final VocabWord word;
  final QuizDirection direction;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
}

class QuizService {
  const QuizService({Random? random}) : _random = random;

  final Random? _random;

  List<QuizQuestion> buildQuestions(List<VocabWord> lessonWords, List<VocabWord> allWords) {
    final questions = <QuizQuestion>[];
    for (final word in lessonWords) {
      questions
        ..add(_buildQuestion(word, allWords, QuizDirection.japaneseToTarget))
        ..add(_buildQuestion(word, allWords, QuizDirection.targetToJapanese));
    }
    return questions..shuffle(_random ?? Random());
  }

  QuizQuestion _buildQuestion(VocabWord word, List<VocabWord> allWords, QuizDirection direction) {
    final correct = direction == QuizDirection.japaneseToTarget ? word.target : word.japanese;
    final candidates = allWords
        .where((candidate) => candidate.id != word.id)
        .map((candidate) => direction == QuizDirection.japaneseToTarget ? candidate.target : candidate.japanese)
        .where((answer) => answer != correct)
        .toSet()
        .toList()
      ..shuffle(_random ?? Random());
    final options = <String>[correct, ...candidates.take(3)]..shuffle(_random ?? Random());
    return QuizQuestion(
      word: word,
      direction: direction,
      prompt: direction == QuizDirection.japaneseToTarget ? word.japanese : word.target,
      correctAnswer: correct,
      options: options,
    );
  }
}
