import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_progress.dart';

class ProgressStore {
  static String _key(String languageCode) => 'progress_$languageCode';

  Future<CourseProgress> load(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key(languageCode));
    if (text == null) return const CourseProgress();
    return CourseProgress.fromJson(jsonDecode(text) as Map<String, dynamic>);
  }

  Future<void> save(String languageCode, CourseProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(languageCode), jsonEncode(progress.toJson()));
  }
}
