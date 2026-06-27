import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:langua_quest/models/vocab_word.dart';
import 'package:langua_quest/services/quiz_service.dart';

void main() {
  test('quiz generation creates four options that include the correct answer', () {
    final words = List.generate(5, (i) => VocabWord(id: 'w$i', category: 'test', japanese: '意味$i', target: 'word$i', pronunciation: 'word$i', example: 'example'));
    final questions = QuizService(random: Random(1)).buildQuestions(words.take(1).toList(), words);

    expect(questions, hasLength(2));
    for (final question in questions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(question.options, contains(question.correctAnswer));
    }
  });
}
