class AssignmentPreview {
  final String id;
  final String title;
  final String date;
  final String content;

  AssignmentPreview({
    required this.id,
    required this.title,
    required this.date,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'content': content,
  };

  // Create AssignmentPreview from JSON
  factory AssignmentPreview.fromJson(Map<String, dynamic> json) =>
      AssignmentPreview(
        id: json['id'],
        title: json['title'],
        date: json['date'],
        content: json['content'],
      );
}
