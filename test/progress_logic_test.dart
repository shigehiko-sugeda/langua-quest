import 'package:flutter_test/flutter_test.dart';
import 'package:langua_quest/models/app_progress.dart';
import 'package:langua_quest/services/progress_logic.dart';

void main() {
  const logic = ProgressLogic();

  test('completeLesson updates learned words and streak', () {
    final first = logic.completeLesson(const CourseProgress(), ['a', 'b'], DateTime(2026, 6, 20));
    final second = logic.completeLesson(first, ['b', 'c'], DateTime(2026, 6, 21));

    expect(second.completedLessons, 2);
    expect(second.streak, 2);
    expect(second.learnedCount, 3);
  });

  test('missed word clears after two correct review answers', () {
    final missed = logic.recordWrongAnswer(const CourseProgress(), 'word1');
    final oneCorrect = logic.recordReviewAnswer(missed, 'word1', true);
    final twoCorrect = logic.recordReviewAnswer(oneCorrect, 'word1', true);

    expect(oneCorrect.missedWords['word1']?.correctCount, 1);
    expect(twoCorrect.missedWords.containsKey('word1'), isFalse);
  });
}
