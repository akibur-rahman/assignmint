import 'package:flutter/material.dart';
import 'package:assignmint/models/cover_page_model.dart';
import 'package:intl/intl.dart';

class CoverPageForm extends StatefulWidget {
  final Function(CoverPageDetails) onSave;

  const CoverPageForm({Key? key, required this.onSave}) : super(key: key);

  @override
  State<CoverPageForm> createState() => _CoverPageFormState();
}

class _CoverPageFormState extends State<CoverPageForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  final _institutionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _facultyController = TextEditingController();
  final _semesterController = TextEditingController();
  final _assignmentTypeController = TextEditingController();
  final _labNumberController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _sectionController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _teacherNameController = TextEditingController();

  DateTime? _classDate;
  DateTime? _submissionDate;

  @override
  void initState() {
    super.initState();
    _loadSavedDetails();
  }

  Future<void> _loadSavedDetails() async {
    try {
      final details = await CoverPageDetails.load();
      if (details != null) {
        setState(() {
          _institutionController.text = details.institutionName;
          _departmentController.text = details.department;
          _facultyController.text = details.faculty;
          _semesterController.text = details.semester;
          _assignmentTypeController.text = details.assignmentType;
          _labNumberController.text = details.labNumber.toString();
          _courseTitleController.text = details.courseTitle;
          _courseCodeController.text = details.courseCode;
          _sectionController.text = details.section;
          _studentNameController.text = details.studentName;
          _studentIdController.text = details.studentId;
          _teacherNameController.text = details.teacherName;
          _classDate = details.classDate;
          _submissionDate = details.submissionDate;
        });
      }
    } catch (e) {
      print('Error loading saved details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isClassDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isClassDate
          ? _classDate ?? DateTime.now()
          : _submissionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isClassDate) {
          _classDate = picked;
        } else {
          _submissionDate = picked;
        }
      });
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate() &&
        _classDate != null &&
        _submissionDate != null) {
      final details = CoverPageDetails(
        institutionName: _institutionController.text,
        department: _departmentController.text,
        faculty: _facultyController.text,
        semester: _semesterController.text,
        assignmentType: _assignmentTypeController.text,
        labNumber: int.parse(_labNumberController.text),
        courseTitle: _courseTitleController.text,
        courseCode: _courseCodeController.text,
        section: _sectionController.text,
        studentName: _studentNameController.text,
        studentId: _studentIdController.text,
        classDate: _classDate!,
        submissionDate: _submissionDate!,
        teacherName: _teacherNameController.text,
      );

      try {
        await details.save();
        widget.onSave(details);
      } catch (e) {
        print('Error saving details: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save form data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institution Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter institution name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter department' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _facultyController,
              decoration: const InputDecoration(
                labelText: 'Faculty',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter faculty' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _semesterController,
              decoration: const InputDecoration(
                labelText: 'Semester',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter semester' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _assignmentTypeController,
              decoration: const InputDecoration(
                labelText: 'Assignment Type',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter assignment type'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _labNumberController,
              decoration: const InputDecoration(
                labelText: 'Lab Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter lab number';
                }
                if (int.tryParse(value!) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseTitleController,
              decoration: const InputDecoration(
                labelText: 'Course Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter course title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseCodeController,
              decoration: const InputDecoration(
                labelText: 'Course Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter course code' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sectionController,
              decoration: const InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter section' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentNameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter student name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter student ID' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _classDate == null
                    ? 'Select Class Date'
                    : 'Class Date: ${DateFormat('MMMM d, y').format(_classDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            if (_classDate == null)
              const Text(
                'Please select class date',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _submissionDate == null
                    ? 'Select Submission Date'
                    : 'Submission Date: ${DateFormat('MMMM d, y').format(_submissionDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            if (_submissionDate == null)
              const Text(
                'Please select submission date',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _teacherNameController,
              decoration: const InputDecoration(
                labelText: 'Teacher\'s Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter teacher\'s name'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _departmentController.dispose();
    _facultyController.dispose();
    _semesterController.dispose();
    _assignmentTypeController.dispose();
    _labNumberController.dispose();
    _courseTitleController.dispose();
    _courseCodeController.dispose();
    _sectionController.dispose();
    _studentNameController.dispose();
    _studentIdController.dispose();
    _teacherNameController.dispose();
    super.dispose();
  }
}
