class VocabWord {
  const VocabWord({
    required this.id,
    required this.category,
    required this.japanese,
    required this.target,
    required this.pronunciation,
    required this.example,
  });

  final String id;
  final String category;
  final String japanese;
  final String target;
  final String pronunciation;
  final String example;

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      id: json['id'] as String,
      category: json['category'] as String,
      japanese: json['japanese'] as String,
      target: json['target'] as String,
      pronunciation: json['pronunciation'] as String,
      example: json['example'] as String,
    );
  }
}
