import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/vocab_word.dart';

class VocabRepository {
  Future<List<VocabWord>> loadWords(String languageCode) async {
    final jsonText = await rootBundle.loadString('assets/vocab/$languageCode.json');
    final rows = jsonDecode(jsonText) as List<dynamic>;
    return rows.map((row) => VocabWord.fromJson(row as Map<String, dynamic>)).toList();
  }
}
