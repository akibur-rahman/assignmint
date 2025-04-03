import 'package:assignmint/models/assignment_section_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:assignmint/services/token_service.dart';

class AssignmentTemplatesService {
  static final tokenService = TokenService();

  static Future<List<AssignmentSection>> generateTemplate(
    String assignmentType,
  ) async {
    try {
      final String prompt = '''
Given the assignment type "${assignmentType}", provide a list of appropriate sections that should be included in this type of assignment.
For each section, provide:
1. A clear title
2. A detailed prompt explaining what should be included in that section

Format the response as follows:
Section 1:
Title: [section title]
Prompt: [detailed explanation of what this section should contain]

Section 2:
Title: [section title]
Prompt: [detailed explanation of what this section should contain]

And so on...
''';

      final response = await Gemini.instance.text(prompt);
      final String output = response?.output ?? '';

      // Track token usage (rough estimate: 1 token ≈ 4 characters)
      final estimatedTokens = (prompt.length + output.length) ~/ 4;
      await tokenService.addTokens(estimatedTokens);

      // Parse the AI response into sections
      final List<AssignmentSection> sections = [];
      final RegExp sectionRegex = RegExp(
        r'Section \d+:\s*Title:\s*([^\n]+)\s*Prompt:\s*([^\n]+(?:\n(?!Section \d+:)[^\n]+)*)',
        multiLine: true,
      );

      final matches = sectionRegex.allMatches(output);

      for (final match in matches) {
        final title = match.group(1)?.trim() ?? '';
        final prompt = match.group(2)?.trim() ?? '';

        if (title.isNotEmpty && prompt.isNotEmpty) {
          sections.add(
            AssignmentSection(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              prompt: prompt,
            ),
          );
        }
      }
      return sections;
    } catch (e) {
      print('Error generating template: $e');
      // Return a basic template in case of error
      return [
        AssignmentSection(
          id: '1',
          title: 'Title',
          prompt: 'Provide a title for your $assignmentType.',
        ),
        AssignmentSection(
          id: '2',
          title: 'Content',
          prompt: 'Main content of your $assignmentType.',
        ),
        AssignmentSection(
          id: '3',
          title: 'Conclusion',
          prompt: 'Conclude your $assignmentType.',
        ),
      ];
    }
  }
}
