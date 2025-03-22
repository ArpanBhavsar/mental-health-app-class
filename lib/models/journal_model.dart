class JournalModel {
  final String title;
  final String journalEntry;
  final String createdAt;

  JournalModel({
    required this.title,
    required this.journalEntry,
    required this.createdAt,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      title: json['title'],
      journalEntry: json['journal_entry'],
      createdAt: json['datetime'],
    );
  }
}
