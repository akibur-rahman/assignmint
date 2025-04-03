import 'package:assignmint/utils/formatters/markdown_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:assignmint/widgets/green_elevated_button.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:assignmint/models/assignment_preview_model.dart';
import 'package:assignmint/models/assignment_section_model.dart';
import 'package:lottie/lottie.dart';
import 'package:assignmint/controllers/assignment_controller.dart';
import 'package:assignmint/controllers/pdf_controller.dart';
import 'package:assignmint/services/token_service.dart';

class AssignmentPage extends StatefulWidget {
  final List<AssignmentSection> sections;
  final String assignmentType;

  const AssignmentPage({
    Key? key,
    required this.sections,
    required this.assignmentType,
  }) : super(key: key);

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final TextEditingController _promptController = TextEditingController();
  late final AssignmentController _assignmentController;
  late final PdfController _pdfController;
  final tokenService = TokenService();
  String _generatedAssignment = '';
  bool _isGeneratingAssignment = false;
  String _assignmentTitle = '';

  @override
  void initState() {
    super.initState();
    _assignmentController = Get.find<AssignmentController>();
    _pdfController = Get.find<PdfController>();
  }

  String _cleanText(String text) {
    return text
        .replaceAll('**', '')
        .replaceAll('*', '')
        .replaceAll('#', '')
        .trim();
  }

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

  Future<void> _generateAssignment() async {
    if (_promptController.text.isEmpty) {
      _showSnackBar('Please enter assignment requirements', isError: true);
      return;
    }

    setState(() {
      _isGeneratingAssignment = true;
      _generatedAssignment = '';
      _assignmentTitle = '';
    });

    try {
      // First, generate a proper title
      final titleResponse = await Gemini.instance.text(
        'Create a specific, professional, and concise title for a ${widget.assignmentType} about: ${_promptController.text}\n\n'
        'Rules:\n'
        '1. Return ONLY the title, nothing else\n'
        '2. Make it specific to the topic\n'
        '3. Keep it under 10 words\n'
        '4. Do not include any explanations or options\n'
        '5. Do not use generic titles like "Untitled Assignment"',
      );
      _assignmentTitle = _cleanText(titleResponse?.output ?? 'Assignment');

      // Then generate the content
      final StringBuffer fullPrompt = StringBuffer();
      fullPrompt.writeln(
        'Create a ${widget.assignmentType} with the following sections:\n',
      );

      for (var section in widget.sections) {
        if (section.title.toLowerCase() != 'title') {
          fullPrompt.writeln('${section.title}:');
          fullPrompt.writeln(section.prompt);
          fullPrompt.writeln();
        }
      }

      fullPrompt.writeln('\nTopic: ${_promptController.text}');

      final response = await Gemini.instance.text(fullPrompt.toString());
      final String cleanedResponse = _cleanText(
        response?.output ?? 'Failed to generate assignment.',
      );

      // Track token usage (rough estimate: 1 token ≈ 4 characters)
      final estimatedTokens = (fullPrompt.length + cleanedResponse.length) ~/ 4;
      await tokenService.addTokens(estimatedTokens);

      setState(() {
        _generatedAssignment = cleanedResponse;
        _isGeneratingAssignment = false;
      });

      final DateTime now = DateTime.now();
      final String date =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final AssignmentPreview newAssignment = AssignmentPreview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _assignmentTitle,
        date: date,
        content: _generatedAssignment,
      );

      await _assignmentController.addAssignment(
        newAssignment,
        _generatedAssignment,
      );
    } catch (e) {
      print('Error generating assignment: $e');
      setState(() {
        _isGeneratingAssignment = false;
      });
      _showSnackBar('Failed to generate assignment', isError: true);
    }
  }

  void _exportAsPdf() {
    if (_generatedAssignment.isEmpty) {
      _showSnackBar('No assignment to export', isError: true);
      return;
    }

    _pdfController.exportAssignment(
      title: _assignmentTitle,
      content: _generatedAssignment,
      context: context,
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Assignment', style: AppTheme.HeadingTextStyle),
        backgroundColor: const Color(0xffdcfce7),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.primaryGreen,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_generatedAssignment.isNotEmpty && !_isGeneratingAssignment)
            IconButton(
              icon: const Icon(Icons.share, color: Colors.lightGreen),
              onPressed: () {
                _pdfController.shareAssignment(
                  title: _assignmentTitle,
                  content: _generatedAssignment,
                  context: context,
                );
              },
            ),
        ],
      ),
      floatingActionButton:
          _generatedAssignment.isNotEmpty && !_isGeneratingAssignment
              ? Obx(
                  () => FloatingActionButton(
                    backgroundColor: AppTheme.primaryGreen,
                    onPressed:
                        _pdfController.isExporting.value ? null : _exportAsPdf,
                    child: _pdfController.isExporting.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.picture_as_pdf),
                  ),
                )
              : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isGeneratingAssignment && _generatedAssignment.isEmpty) ...[
                TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(
                    hintText: 'Enter assignment requirements...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                GreenElevatedButton(
                  buttontext: "Generate Assignment",
                  onPressed: _generateAssignment,
                ),
              ],
              if (_isGeneratingAssignment)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey('generating'),
                    children: [
                      const SizedBox(height: 100),
                      Lottie.asset(
                        'assets/lottie/generating.json',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Generating your assignment...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_generatedAssignment.isNotEmpty && !_isGeneratingAssignment)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey('generated'),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: MarkdownFormatter.formatAssignmentText(
                        _generatedAssignment,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
