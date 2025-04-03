import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:assignmint/widgets/green_elevated_button.dart';
import 'package:assignmint/models/assignment_section_model.dart';
import 'package:assignmint/services/assignment_templates_service.dart';
import 'package:assignmint/widgets/assignment_section_card.dart';
import 'package:lottie/lottie.dart';
import 'package:reorderables/reorderables.dart';
import 'assignment_page.dart';

class TemplatePage extends StatefulWidget {
  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  final TextEditingController _typeController = TextEditingController();
  List<AssignmentSection> _sections = [];
  bool _isLoadingTemplate = false;
  bool _isEditingSections = true;

  Future<void> _generateTemplate() async {
    if (_typeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an assignment type')),
      );
      return;
    }

    setState(() {
      _isLoadingTemplate = true;
    });

    try {
      final sections = await AssignmentTemplatesService.generateTemplate(
        _typeController.text,
      );
      setState(() {
        _sections = sections;
        _isLoadingTemplate = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating template: $e')));
      setState(() {
        _isLoadingTemplate = false;
      });
    }
  }

  void _addNewSection() {
    setState(() {
      _sections.add(
        AssignmentSection(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'New Section',
          prompt: 'Enter section prompt...',
        ),
      );
    });
  }

  void _deleteSection(String id) {
    setState(() {
      _sections.removeWhere((section) => section.id == id);
    });
  }

  void _updateSectionTitle(String id, String newTitle) {
    final index = _sections.indexWhere((section) => section.id == id);
    if (index != -1) {
      final updatedSection = _sections[index].copyWith(title: newTitle);
      _sections[index] = updatedSection;
    }
  }

  void _updateSectionPrompt(String id, String newPrompt) {
    final index = _sections.indexWhere((section) => section.id == id);
    if (index != -1) {
      final updatedSection = _sections[index].copyWith(prompt: newPrompt);
      _sections[index] = updatedSection;
    }
  }

  void _navigateToAssignmentPage() {
    if (_sections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate a template first')),
      );
      return;
    }

    Get.to(
      () => AssignmentPage(
        sections: _sections,
        assignmentType: _typeController.text,
      ),
    );
  }

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Template', style: AppTheme.HeadingTextStyle),
        backgroundColor: const Color(0xffdcfce7),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.primaryGreen,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoadingTemplate
                    ? Center(
                        child: Column(
                          children: [
                            Lottie.asset(
                              'assets/lottie/generating.json',
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Generating template...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 8),
                          TextField(
                            controller: _typeController,
                            decoration: const InputDecoration(
                              labelText:
                                  'Assignment Type (e.g., Essay, Lab Report, etc.)',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GreenElevatedButton(
                            buttontext: "Generate Template",
                            onPressed: _generateTemplate,
                          ),
                        ],
                      ),
              ),
              if (_sections.isNotEmpty) ...[
                const SizedBox(height: 24),
                if (_isEditingSections) ...[
                  ReorderableColumn(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        final item = _sections.removeAt(oldIndex);
                        _sections.insert(newIndex, item);
                      });
                    },
                    children: List.generate(
                      _sections.length,
                      (index) => AssignmentSectionCard(
                        key: ValueKey(_sections[index].id),
                        section: _sections[index],
                        onDelete: () {
                          setState(() {
                            _sections.removeAt(index);
                          });
                        },
                        onTitleChanged: (newTitle) => _updateSectionTitle(
                          _sections[index].id,
                          newTitle,
                        ),
                        onPromptChanged: (newPrompt) => _updateSectionPrompt(
                          _sections[index].id,
                          newPrompt,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GreenElevatedButton(
                    buttontext: "Add New Section",
                    onPressed: _addNewSection,
                  ),
                  const SizedBox(height: 16),
                  GreenElevatedButton(
                    buttontext: "Done Editing Sections",
                    onPressed: () {
                      setState(() {
                        _isEditingSections = false;
                      });
                    },
                  ),
                ] else ...[
                  GreenElevatedButton(
                    buttontext: "Edit Sections",
                    onPressed: () {
                      setState(() {
                        _isEditingSections = true;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                GreenElevatedButton(
                  buttontext: "Generate Assignment",
                  onPressed: _navigateToAssignmentPage,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
