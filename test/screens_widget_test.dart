import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:langua_quest/models/app_progress.dart';
import 'package:langua_quest/models/vocab_word.dart';
import 'package:langua_quest/screens/home_screen.dart';
import 'package:langua_quest/screens/lesson_screen.dart';
import 'package:langua_quest/screens/quiz_screen.dart';
import 'package:langua_quest/screens/review_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('HomeScreen renders with loaded progress', (tester) async {
    await _pumpScreen(tester, const HomeScreen());
    await tester.pumpAndSettle();

    expect(find.text('ことばクエスト'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('LessonScreen renders long lesson text', (tester) async {
    await _pumpScreen(
      tester,
      LessonScreen(
        languageCode: 'en',
        words: _longWords(),
        progress: const CourseProgress(completedLessons: 0),
      ),
    );

    expect(find.text('今日の10語'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('クイズへすすむ'),
      400,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('クイズへすすむ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('QuizScreen renders long prompts and options', (tester) async {
    final words = _longWords();

    await _pumpScreen(
      tester,
      QuizScreen(
        languageCode: 'en',
        lessonWords: words.take(3).toList(),
        allWords: words,
        progress: const CourseProgress(),
        isReview: false,
      ),
    );

    expect(find.text('クイズ'), findsOneWidget);
    expect(find.textContaining('問題 '), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ReviewScreen renders long missed-word quiz text',
      (tester) async {
    final words = _longWords();
    final progress = CourseProgress(
      missedWords: {
        words[0].id: MissedWordProgress(wordId: words[0].id),
        words[1].id: MissedWordProgress(wordId: words[1].id),
      },
    );

    await _pumpScreen(
      tester,
      ReviewScreen(
        languageCode: 'ko',
        words: words,
        progress: progress,
      ),
    );

    expect(find.text('ふくしゅうクイズ'), findsOneWidget);
    expect(find.textContaining('問題 '), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = const Size(2400, 1600);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            minimumSize: const Size(double.infinity, 58),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
      home: screen,
    ),
  );
  await tester.pump();
}

List<VocabWord> _longWords() {
  const longJapanesePrefix = 'とても長い日本語の意味を持つ単語ラベル';
  const longTargetPrefix =
      'supercalifragilistic vocabulary option with many descriptive words';
  const longPronunciation = 'スーパー・ロング・プロナンシエーション・テキスト';
  const longExample =
      'This is a deliberately long example sentence prepared inside the widget test so layout can be exercised with dynamic-looking content.';

  return List.generate(12, (index) {
    return VocabWord(
      id: 'long_$index',
      category: 'long_text',
      japanese: '$longJapanesePrefix $index 画面の中でも折り返しが必要になるくらい長い説明です',
      target: '$longTargetPrefix number $index for rendering checks',
      pronunciation: '$longPronunciation $index',
      example:
          '$longExample Item $index keeps the sentence unique and long enough.',
    );
  });
}
