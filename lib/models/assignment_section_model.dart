class AssignmentSection {
  String title;
  String prompt;
  String id;

  AssignmentSection({
    required this.title,
    required this.prompt,
    required this.id,
  });

  AssignmentSection copyWith({String? title, String? prompt, String? id}) {
    return AssignmentSection(
      title: title ?? this.title,
      prompt: prompt ?? this.prompt,
      id: id ?? this.id,
    );
  }
}
