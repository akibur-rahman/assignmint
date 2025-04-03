import 'package:assignmint/controllers/assignment_controller.dart';
import 'package:assignmint/models/assignment_preview_model.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:assignmint/widgets/assignment_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/pages/view_assignment_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AssignmentController _assignmentController = Get.put(
    AssignmentController(),
  );

  void _showDeleteDialog(BuildContext context, AssignmentPreview assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundGreen,
        title: const Text(
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
            child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _assignmentController.deleteAssignment(assignment.id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffdcfce7),
        title: Text("My Assignments", style: AppTheme.HeadingTextStyle),
      ),
      body: Obx(
        () => _assignmentController.assignments.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Assignments yet!",
                      style: AppTheme.HeadingTextStyle,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Tap the + button to create a new assignment",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: _assignmentController.assignments.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisExtent: 180,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    final assignment = _assignmentController.assignments[index];
                    return GestureDetector(
                      onLongPress: () => _showDeleteDialog(context, assignment),
                      child: AssignmentCard(
                        assignment: assignment,
                        onTap: (id) {
                          Get.to(
                            () => ViewAssignmentPage(assignment: assignment),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
