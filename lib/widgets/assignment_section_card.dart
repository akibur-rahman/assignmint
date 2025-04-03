import 'package:flutter/material.dart';
import 'package:assignmint/models/assignment_section_model.dart';

class AssignmentSectionCard extends StatefulWidget {
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
  State<AssignmentSectionCard> createState() => _AssignmentSectionCardState();
}

class _AssignmentSectionCardState extends State<AssignmentSectionCard> {
  late TextEditingController _titleController;
  late TextEditingController _promptController;
  late FocusNode _titleFocusNode;
  late FocusNode _promptFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.section.title);
    _promptController = TextEditingController(text: widget.section.prompt);
    _titleFocusNode = FocusNode();
    _promptFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _promptController.dispose();
    _titleFocusNode.dispose();
    _promptFocusNode.dispose();
    super.dispose();
  }

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
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'Section Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      widget.onTitleChanged(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: widget.onDelete,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _promptController,
              focusNode: _promptFocusNode,
              decoration: const InputDecoration(
                labelText: 'Section Prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                widget.onPromptChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
