class Note {
  int? id;
  String title;
  String description;
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // Helper method to get a formatted date string
  String get formattedDate {
    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }
}
