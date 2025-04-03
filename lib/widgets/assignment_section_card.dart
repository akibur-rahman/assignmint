import 'package:flutter/material.dart';
import 'package:assignmint/models/assignment_section_model.dart';

class AssignmentSectionCard extends StatelessWidget {
  final AssignmentSection section;
  final VoidCallback onDelete;
  final Function(String) onTitleChanged;
  final Function(String) onPromptChanged;

  const AssignmentSectionCard({
    Key? key,
    required this.section,
    required this.onDelete,
    required this.onTitleChanged,
    required this.onPromptChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: section.title),
                    decoration: const InputDecoration(
                      labelText: 'Section Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: onTitleChanged,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: section.prompt),
              decoration: const InputDecoration(
                labelText: 'Section Prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: onPromptChanged,
            ),
          ],
        ),
      ),
    );
  }
}
