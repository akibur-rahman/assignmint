import 'package:get/get.dart';
import 'package:assignmint/models/assignment_preview_model.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class AssignmentController extends GetxController {
  final RxList<AssignmentPreview> assignments = <AssignmentPreview>[].obs;
  final Map<String, String> assignmentContents = {};
  final GetStorage _storage = GetStorage();
  final String _assignmentsKey = 'assignments';
  final String _contentsKey = 'assignmentContents';

  void _showSnackBar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.shade100 : Colors.green.shade100,
      colorText: isError ? Colors.red.shade800 : Colors.green.shade800,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadAssignments();
  }

  int getRecentAssignmentsCount() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return assignments.where((assignment) {
      final assignmentDate = DateTime.parse(assignment.date);
      return assignmentDate.isAfter(sevenDaysAgo);
    }).length;
  }

  Future<void> addAssignment(AssignmentPreview preview, String content) async {
    try {
      assignments.add(preview);
      assignmentContents[preview.id] = content;
      await _saveAssignments();
      _showSnackBar('Assignment saved successfully');
    } catch (e) {
      _showSnackBar('Failed to save assignment: ${e.toString()}',
          isError: true);
      // Rollback changes if save fails
      assignments.remove(preview);
      assignmentContents.remove(preview.id);
    }
  }

  String? getAssignmentContent(String id) {
    return assignmentContents[id];
  }

  Future<void> deleteAssignment(String id) async {
    try {
      final assignment = assignments.firstWhere((a) => a.id == id);
      assignments.removeWhere((a) => a.id == id);
      assignmentContents.remove(id);
      await _saveAssignments();
      _showSnackBar('Assignment "${assignment.title}" removed');
    } catch (e) {
      _showSnackBar('Failed to delete assignment: ${e.toString()}',
          isError: true);
    }
  }

  Future<void> _saveAssignments() async {
    try {
      final List<Map<String, dynamic>> assignmentsJson =
          assignments.map((a) => a.toJson()).toList();
      final Map<String, dynamic> contentsJson = assignmentContents;

      await _storage.write(_assignmentsKey, jsonEncode(assignmentsJson));
      await _storage.write(_contentsKey, jsonEncode(contentsJson));
    } catch (e) {
      throw Exception('Failed to save assignments: $e');
    }
  }

  Future<void> _loadAssignments() async {
    try {
      final String? assignmentsJson = _storage.read(_assignmentsKey);
      final String? contentsJson = _storage.read(_contentsKey);

      if (assignmentsJson != null) {
        List<dynamic> decoded = jsonDecode(assignmentsJson);
        assignments.assignAll(
          decoded.map((e) => AssignmentPreview.fromJson(e)).toList(),
        );
      }

      if (contentsJson != null) {
        assignmentContents.addAll(
          Map<String, String>.from(jsonDecode(contentsJson)),
        );
      }
    } catch (e) {
      throw Exception('Failed to load assignments: $e');
    }
  }

  Future<void> clearAllAssignments() async {
    try {
      assignments.clear();
      assignmentContents.clear();
      await _storage.remove(_assignmentsKey);
      await _storage.remove(_contentsKey);
      _showSnackBar('All assignments removed');
    } catch (e) {
      _showSnackBar('Failed to clear assignments: ${e.toString()}',
          isError: true);
    }
  }

  bool hasAssignmentWithId(String id) {
    return assignments.any((assignment) => assignment.id == id);
  }

  Future<void> updateAssignment(AssignmentPreview updatedAssignment) async {
    try {
      final index = assignments.indexWhere((a) => a.id == updatedAssignment.id);
      if (index != -1) {
        assignments[index] = updatedAssignment;
        await _saveAssignments();
        _showSnackBar('Assignment title updated successfully');
      } else {
        _showSnackBar('Assignment not found', isError: true);
      }
    } catch (e) {
      _showSnackBar('Failed to update assignment: ${e.toString()}',
          isError: true);
    }
  }
}
