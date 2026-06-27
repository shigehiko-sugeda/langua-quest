import '../models/app_progress.dart';

class ProgressLogic {
  const ProgressLogic();

  CourseProgress completeLesson(CourseProgress progress, Iterable<String> learnedWordIds, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final last = progress.lastCompletedDate;
    final lastDay = last == null ? null : DateTime(last.year, last.month, last.day);
    final streak = lastDay == null
        ? 1
        : lastDay == today
            ? progress.streak
            : today.difference(lastDay).inDays == 1
                ? progress.streak + 1
                : 1;
    return progress.copyWith(
      completedLessons: progress.completedLessons + 1,
      streak: streak,
      learnedWordIds: {...progress.learnedWordIds, ...learnedWordIds},
      lastCompletedDate: today,
    );
  }

  CourseProgress recordWrongAnswer(CourseProgress progress, String wordId) {
    final missed = Map<String, MissedWordProgress>.from(progress.missedWords);
    missed[wordId] = MissedWordProgress(wordId: wordId);
    return progress.copyWith(missedWords: missed);
  }

  CourseProgress recordReviewAnswer(CourseProgress progress, String wordId, bool isCorrect) {
    final missed = Map<String, MissedWordProgress>.from(progress.missedWords);
    final current = missed[wordId] ?? MissedWordProgress(wordId: wordId);
    if (!isCorrect) {
      missed[wordId] = MissedWordProgress(wordId: wordId);
    } else if (current.correctCount + 1 >= 2) {
      missed.remove(wordId);
    } else {
      missed[wordId] = current.copyWith(correctCount: current.correctCount + 1);
    }
    return progress.copyWith(missedWords: missed);
  }
}
