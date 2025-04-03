import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';

class CoverPageDetails {
  static final _storage = GetStorage();
  static const String _storageKey = 'cover_page_details';

  final String institutionName;
  final String department;
  final String faculty;
  final String semester;
  final String assignmentType;
  final int labNumber;
  final String courseTitle;
  final String courseCode;
  final String section;
  final String studentName;
  final String studentId;
  final DateTime classDate;
  final DateTime submissionDate;
  final String teacherName;

  CoverPageDetails({
    required this.institutionName,
    required this.department,
    required this.faculty,
    required this.semester,
    required this.assignmentType,
    required this.labNumber,
    required this.courseTitle,
    required this.courseCode,
    required this.section,
    required this.studentName,
    required this.studentId,
    required this.classDate,
    required this.submissionDate,
    required this.teacherName,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'institutionName': institutionName,
        'department': department,
        'faculty': faculty,
        'semester': semester,
        'assignmentType': assignmentType,
        'labNumber': labNumber,
        'courseTitle': courseTitle,
        'courseCode': courseCode,
        'section': section,
        'studentName': studentName,
        'studentId': studentId,
        'classDate': classDate.toIso8601String(),
        'submissionDate': submissionDate.toIso8601String(),
        'teacherName': teacherName,
      };

  // Create from JSON
  factory CoverPageDetails.fromJson(Map<String, dynamic> json) {
    return CoverPageDetails(
      institutionName: json['institutionName'] as String,
      department: json['department'] as String,
      faculty: json['faculty'] as String,
      semester: json['semester'] as String,
      assignmentType: json['assignmentType'] as String,
      labNumber: json['labNumber'] as int,
      courseTitle: json['courseTitle'] as String,
      courseCode: json['courseCode'] as String,
      section: json['section'] as String,
      studentName: json['studentName'] as String,
      studentId: json['studentId'] as String,
      classDate: DateTime.parse(json['classDate'] as String),
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      teacherName: json['teacherName'] as String,
    );
  }

  // Save to GetStorage
  Future<void> save() async {
    try {
      print('Attempting to save cover page details...');
      final jsonStr = jsonEncode(toJson());
      print('JSON string to save: $jsonStr');

      await _storage.write(_storageKey, jsonStr);
      print('Successfully saved cover page details');
    } catch (e, stackTrace) {
      print('Error saving cover page details: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to save cover page details: $e');
    }
  }

  // Load from GetStorage
  static Future<CoverPageDetails?> load() async {
    try {
      print('Attempting to load cover page details...');
      final jsonStr = _storage.read<String>(_storageKey);

      if (jsonStr == null) {
        print('No saved cover page details found');
        return null;
      }

      print('Loaded JSON string: $jsonStr');
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      final details = CoverPageDetails.fromJson(json);
      print('Successfully loaded cover page details');
      return details;
    } catch (e, stackTrace) {
      print('Error loading cover page details: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  // Format dates for display
  String get formattedClassDate => DateFormat('MMMM d, y').format(classDate);
  String get formattedSubmissionDate =>
      DateFormat('MMMM d, y').format(submissionDate);
}
