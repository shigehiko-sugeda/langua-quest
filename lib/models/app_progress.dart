class MissedWordProgress {
  const MissedWordProgress({required this.wordId, this.correctCount = 0});

  final String wordId;
  final int correctCount;

  MissedWordProgress copyWith({int? correctCount}) =>
      MissedWordProgress(wordId: wordId, correctCount: correctCount ?? this.correctCount);

  Map<String, dynamic> toJson() => {'wordId': wordId, 'correctCount': correctCount};

  factory MissedWordProgress.fromJson(Map<String, dynamic> json) => MissedWordProgress(
        wordId: json['wordId'] as String,
        correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      );
}

class CourseProgress {
  const CourseProgress({
    this.completedLessons = 0,
    this.streak = 0,
    this.learnedWordIds = const <String>{},
    this.missedWords = const <String, MissedWordProgress>{},
    this.lastCompletedDate,
  });

  final int completedLessons;
  final int streak;
  final Set<String> learnedWordIds;
  final Map<String, MissedWordProgress> missedWords;
  final DateTime? lastCompletedDate;

  int get learnedCount => learnedWordIds.length;

  CourseProgress copyWith({
    int? completedLessons,
    int? streak,
    Set<String>? learnedWordIds,
    Map<String, MissedWordProgress>? missedWords,
    DateTime? lastCompletedDate,
  }) {
    return CourseProgress(
      completedLessons: completedLessons ?? this.completedLessons,
      streak: streak ?? this.streak,
      learnedWordIds: learnedWordIds ?? this.learnedWordIds,
      missedWords: missedWords ?? this.missedWords,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'completedLessons': completedLessons,
        'streak': streak,
        'learnedWordIds': learnedWordIds.toList(),
        'missedWords': missedWords.map((key, value) => MapEntry(key, value.toJson())),
        'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      };

  factory CourseProgress.fromJson(Map<String, dynamic> json) => CourseProgress(
        completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
        streak: (json['streak'] as num?)?.toInt() ?? 0,
        learnedWordIds: Set<String>.from(json['learnedWordIds'] as List? ?? const []),
        missedWords: (json['missedWords'] as Map<String, dynamic>? ?? const {}).map(
          (key, value) => MapEntry(key, MissedWordProgress.fromJson(value as Map<String, dynamic>)),
        ),
        lastCompletedDate: json['lastCompletedDate'] == null
            ? null
            : DateTime.parse(json['lastCompletedDate'] as String),
      );
}
