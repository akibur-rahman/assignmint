import 'package:assignmint/models/assignment_preview_model.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/controllers/assignment_controller.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentPreview assignment;
  final Function(String) onTap;
  final AssignmentController _assignmentController =
      Get.find<AssignmentController>();

  AssignmentCard({
    Key? key,
    required this.assignment,
    required this.onTap,
  }) : super(key: key);

  void _showEditDialog(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: assignment.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundGreen,
        title: Text(
          "Edit Assignment Title",
          style: TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Title",
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryGreen),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                final updatedAssignment = AssignmentPreview(
                  id: assignment.id,
                  title: titleController.text.trim(),
                  date: assignment.date,
                  content: assignment.content,
                );
                await _assignmentController.updateAssignment(updatedAssignment);
                Navigator.of(context).pop();
              }
            },
            child: Text("Save", style: TextStyle(color: AppTheme.primaryGreen)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundGreen,
        title: Text(
          "Delete Assignment",
          style: TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to delete '${assignment.title}'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _assignmentController.deleteAssignment(assignment.id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showOptionsPopup(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);
    final Size size = button.size;

    showMenu(
      color: AppTheme.backgroundGreen,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      position: RelativeRect.fromLTRB(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Edit Title',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Delete Assignment',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _showEditDialog(context);
      } else if (value == 'delete') {
        _showDeleteDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(assignment.id),
      onLongPress: () => _showOptionsPopup(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 171, 233, 172), // Very light green
                Color.fromARGB(255, 87, 223, 92), // Slightly deeper light green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  assignment.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff15803d),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Divider
                Container(
                  height: 2,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xff15803d),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(Icons.calendar_today, assignment.date),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Icon(icon, size: 16, color: Color(0xff15803d)),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff15803d),
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
