import 'package:flutter/material.dart';

import '../models/app_progress.dart';
import '../models/vocab_word.dart';
import '../services/progress_logic.dart';
import '../services/progress_store.dart';
import '../services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.languageCode,
    required this.lessonWords,
    required this.allWords,
    required this.progress,
    required this.isReview,
  });
  final String languageCode;
  final List<VocabWord> lessonWords;
  final List<VocabWord> allWords;
  final CourseProgress progress;
  final bool isReview;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _logic = const ProgressLogic();
  final _store = ProgressStore();
  late final List<QuizQuestion> _questions =
      const QuizService().buildQuestions(widget.lessonWords, widget.allWords);
  late CourseProgress _progress = widget.progress;
  int _index = 0;
  String? _feedback;

  Future<void> _answer(String option) async {
    final question = _questions[_index];
    final correct = option == question.correctAnswer;
    setState(
      () =>
          _feedback = correct ? 'せいかい！' : 'ざんねん。正解は「${question.correctAnswer}」',
    );
    if (widget.isReview) {
      _progress =
          _logic.recordReviewAnswer(_progress, question.word.id, correct);
    } else if (!correct) {
      _progress = _logic.recordWrongAnswer(_progress, question.word.id);
    }
    await _store.save(widget.languageCode, _progress);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    if (_index == _questions.length - 1) {
      if (!widget.isReview) {
        _progress = _logic.completeLesson(
          _progress,
          widget.lessonWords.map((word) => word.id),
          DateTime.now(),
        );
        await _store.save(widget.languageCode, _progress);
      }
      if (mounted) Navigator.of(context).pop();
    } else {
      setState(() {
        _index++;
        _feedback = null;
      });
    }
  }

  Widget _optionButton(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: _feedback == null ? () => _answer(option) : null,
        child: Text(
          option,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_index];
    return Scaffold(
      appBar: AppBar(title: Text(widget.isReview ? 'ふくしゅうクイズ' : 'クイズ')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_index + 1) / _questions.length),
            const SizedBox(height: 24),
            Text(
              '問題 ${_index + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              question.direction == QuizDirection.japaneseToTarget
                  ? 'この意味の単語は？'
                  : 'この単語の意味は？',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.yellow.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  question.prompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  for (final option in question.options) _optionButton(option),
                  if (_feedback != null)
                    Text(
                      _feedback!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
