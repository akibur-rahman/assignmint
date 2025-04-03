import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class MarkdownFormatter {
  static List<Widget> formatAssignmentText(String text) {
    List<Widget> widgets = [];
    final lines = text.split('\n');
    bool inCodeBlock = false;
    String? codeLanguage;
    List<String> codeLines = [];

    for (var i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Handle code blocks
      if (line.startsWith('```')) {
        if (inCodeBlock) {
          // End of code block
          widgets.add(_buildSyntaxView(codeLanguage, codeLines.join('\n')));
          codeLines.clear();
          codeLanguage = null;
          inCodeBlock = false;
        } else {
          // Start of code block - check for language
          inCodeBlock = true;
          final language = line.substring(3).trim();
          if (language.isNotEmpty) {
            codeLanguage = _normalizeLanguage(language);
          }
        }
        continue;
      }

      if (inCodeBlock) {
        codeLines.add(line);
        continue;
      }

      // Skip empty lines outside code blocks
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Check if the line is a section header (ends with ':')
      bool isHeader = line.endsWith(':') && !line.startsWith('```');

      if (isHeader) {
        if (i > 0) widgets.add(const SizedBox(height: 16));
        widgets.add(
          Text(
            line,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 8));
      } else {
        widgets.addAll(_parseInlineElements(line));
      }
    }

    return widgets;
  }

  static Widget _buildSyntaxView(String? language, String code) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SyntaxView(
          code: code,
          syntax: _getSyntax(language),
          syntaxTheme: SyntaxTheme.dracula(),
          fontSize: 12,
          withZoom: false,
          withLinesCount: true,
        ),
      ),
    );
  }

  static Syntax _getSyntax(String? language) {
    switch (language?.toLowerCase()) {
      case 'dart':
        return Syntax.DART;
      case 'java':
        return Syntax.JAVA;
      case 'python':
        return Syntax.PYTHON;
      case 'javascript':
        return Syntax.JAVASCRIPT;
      case 'c':
        return Syntax.C;
      case 'cpp':
      case 'c++':
        return Syntax.CPP;
      case 'kotlin':
        return Syntax.KOTLIN;
      case 'swift':
        return Syntax.SWIFT;
      case 'yaml':
        return Syntax.YAML;
      default:
        return Syntax.DART;
    }
  }

  static String? _normalizeLanguage(String language) {
    final normalized = language.toLowerCase();
    if (normalized == 'js') return 'javascript';
    if (normalized == 'c++') return 'cpp';
    return normalized;
  }

  static List<Widget> _parseInlineElements(String line) {
    List<Widget> elements = [];
    final textSpans = <TextSpan>[];
    final pattern = RegExp(r'`([^`]+)`');
    final matches = pattern.allMatches(line);
    int currentPosition = 0;

    for (final match in matches) {
      // Add normal text before the code
      if (match.start > currentPosition) {
        textSpans.add(
          TextSpan(text: line.substring(currentPosition, match.start)),
        );
      }

      // Add the code text
      textSpans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            backgroundColor: Color(0xFFF5F5F5),
            fontFamily: 'RobotoMono',
            color: Colors.black,
          ),
        ),
      );

      currentPosition = match.end;
    }

    // Add remaining text
    if (currentPosition < line.length) {
      textSpans.add(TextSpan(text: line.substring(currentPosition)));
    }

    elements.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 15, color: Colors.black),
            children: textSpans,
          ),
        ),
      ),
    );

    return elements;
  }
}
