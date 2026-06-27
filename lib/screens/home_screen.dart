import 'package:flutter/material.dart';

import '../models/app_progress.dart';
import '../models/vocab_word.dart';
import '../services/progress_store.dart';
import '../services/vocab_repository.dart';
import 'lesson_screen.dart';
import 'review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = VocabRepository();
  final _store = ProgressStore();
  String _languageCode = 'en';
  List<VocabWord> _words = const [];
  CourseProgress _progress = const CourseProgress();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      _repo.loadWords(_languageCode),
      _store.load(_languageCode),
    ]);
    setState(() {
      _words = results[0] as List<VocabWord>;
      _progress = results[1] as CourseProgress;
    });
  }

  Future<void> _openLesson() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LessonScreen(
        languageCode: _languageCode,
        words: _words,
        progress: _progress,
      ),
    ));
    await _load();
  }

  Future<void> _openReview() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReviewScreen(
        languageCode: _languageCode,
        words: _words,
        progress: _progress,
      ),
    ));
    await _load();
  }

  Widget _actionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ことばクエスト')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('まなぶ言語をえらぼう',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'en', label: Text('英語')),
                ButtonSegment(value: 'ko', label: Text('韓国語')),
              ],
              selected: {_languageCode},
              onSelectionChanged: (value) {
                setState(() => _languageCode = value.first);
                _load();
              },
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.lightBlue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(label: 'れんぞく', value: '${_progress.streak}日'),
                    _Stat(label: 'おぼえた', value: '${_progress.learnedCount}語'),
                    _Stat(
                      label: 'ふくしゅう',
                      value: '${_progress.missedWords.length}語',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _actionButton(
              onPressed: _words.isEmpty ? null : _openLesson,
              icon: Icons.play_arrow,
              label: '今日のレッスンをはじめる',
            ),
            const SizedBox(height: 14),
            _actionButton(
              onPressed: _progress.missedWords.isEmpty ? null : _openReview,
              icon: Icons.refresh,
              label: 'まちがえた単語をふくしゅう',
            ),
            const Spacer(),
            const Text('広告なし・ログインなし・オフラインで使えます', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ]);
}
