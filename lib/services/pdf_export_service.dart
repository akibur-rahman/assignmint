import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as material;
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:assignmint/widgets/cover_page_dialog.dart';

class PdfExportService {
  static Future<File?> generateAssignmentPdf({
    required String title,
    required String content,
    required material.BuildContext context,
  }) async {
    // Show cover page dialog
    final coverPageDetails = await CoverPageDialog.show(context);
    if (coverPageDetails == null) {
      return null; // User cancelled
    }

    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/TimesNewRoman.ttf");
    final ttf = pw.Font.ttf(font);

    final boldFont = await rootBundle.load(
      "assets/fonts/TimesNewRoman-Bold.ttf",
    );
    final boldTtf = pw.Font.ttf(boldFont);

    final monoFont = await rootBundle.load("assets/fonts/CascadiaCode.ttf");
    final monoTtf = pw.Font.ttf(monoFont);

    // Create cover page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                coverPageDetails.institutionName,
                style: pw.TextStyle(font: boldTtf, fontSize: 18),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                coverPageDetails.department,
                style: pw.TextStyle(font: boldTtf, fontSize: 16),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                coverPageDetails.faculty,
                style: pw.TextStyle(font: ttf, fontSize: 14),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Semester: ${coverPageDetails.semester}',
                style: pw.TextStyle(font: ttf, fontSize: 14),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                '${coverPageDetails.assignmentType}: ${coverPageDetails.labNumber.toString().padLeft(2, '0')}',
                style: pw.TextStyle(font: boldTtf, fontSize: 14),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Course Title: ${coverPageDetails.courseTitle}',
                style: pw.TextStyle(font: ttf, fontSize: 14),
              ),
              pw.Text(
                'Course Code: ${coverPageDetails.courseCode}        Section: ${coverPageDetails.section}',
                style: pw.TextStyle(font: ttf, fontSize: 14),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                'Title: $title',
                style: pw.TextStyle(font: boldTtf, fontSize: 16),
              ),
              pw.SizedBox(height: 40),
              pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Student Details',
                      style: pw.TextStyle(
                        font: boldTtf,
                        fontSize: 14,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Table(
                      columnWidths: {
                        0: const pw.FixedColumnWidth(50),
                        1: const pw.FixedColumnWidth(200),
                        2: const pw.FixedColumnWidth(100),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text('1.'),
                            pw.Text(coverPageDetails.studentName),
                            pw.Text(coverPageDetails.studentId),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                          'Class Date',
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          ': ${coverPageDetails.formattedClassDate}',
                          style: pw.TextStyle(font: ttf),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Text(
                          'Submission Date',
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          ': ${coverPageDetails.formattedSubmissionDate}',
                          style: pw.TextStyle(font: ttf),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Text(
                          'Course Teacher\'s Name',
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          ': ${coverPageDetails.teacherName}',
                          style: pw.TextStyle(font: ttf),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'CLP Status',
                      style: pw.TextStyle(font: boldTtf, fontSize: 14),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Marks: ..............................',
                            ),
                            pw.Text('Comments: .........................'),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Signature: ......................'),
                            pw.Text('Date: ............................'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Define styles
    final normalStyle = pw.TextStyle(
      font: ttf,
      fontSize: 12,
      color: PdfColors.black,
    );
    final headerStyle = pw.TextStyle(
      font: boldTtf,
      fontSize: 16,
      color: PdfColors.black,
    );
    final codeStyle = pw.TextStyle(
      font: monoTtf,
      fontSize: 10,
      color: PdfColors.black,
    );

    // Parse content sections
    final lines = content.split('\n');
    List<pw.Widget> widgets = [];
    bool inCodeBlock = false;
    List<String> codeLines = [];

    // Add content
    for (var i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Handle code blocks
      if (line.trim().startsWith('```')) {
        if (inCodeBlock) {
          // End of code block
          if (codeLines.isNotEmpty) {
            // Split code into chunks that fit on a page
            const int maxLinesPerPage = 50;
            for (int i = 0; i < codeLines.length; i += maxLinesPerPage) {
              final end = (i + maxLinesPerPage < codeLines.length)
                  ? i + maxLinesPerPage
                  : codeLines.length;
              final chunk = codeLines.sublist(i, end);

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text(chunk.join('\n'), style: codeStyle),
                ),
              );

              // Add a page break if there's more code to come
              if (end < codeLines.length) {
                widgets.add(pw.SizedBox(height: 20));
              }
            }
          }
          codeLines.clear();
          inCodeBlock = false;
        } else {
          // Start of code block
          inCodeBlock = true;
        }
        continue;
      }

      if (inCodeBlock) {
        codeLines.add(line);
        continue;
      }

      // Skip empty lines outside code blocks
      if (line.trim().isEmpty) {
        widgets.add(pw.SizedBox(height: 5));
        continue;
      }

      // Check if the line is a section header (ends with ':')
      bool isHeader =
          line.trim().endsWith(':') && !line.trim().startsWith('```');

      if (isHeader) {
        widgets.add(pw.SizedBox(height: 10));
        widgets.add(pw.Text(line.trim(), style: headerStyle));
        widgets.add(pw.SizedBox(height: 5));
      } else {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text(line.trim(), style: normalStyle),
          ),
        );
      }
    }

    // Add content pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => widgets,
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final String sanitizedTitle = _sanitizeFilename(title);
    final String filename =
        '${sanitizedTitle}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$filename');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static String _sanitizeFilename(String title) {
    // Remove any AI-generated options or explanations
    if (title.contains('Here are a few options')) {
      // Extract the first option if it exists
      final match = RegExp(r'Option 1[^:]*:\s*>\s*([^\n]+)').firstMatch(title);
      if (match != null) {
        title = match.group(1) ?? title;
      }
    }

    // Remove special characters and limit length
    return title
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
        .substring(
            0, title.length.clamp(0, 50)) // Limit length to 50 characters
        .trim();
  }

  static Future<void> sharePdf(File pdfFile) async {
    await Share.shareXFiles([
      XFile(pdfFile.path),
    ], text: 'Sharing Assignment PDF');
  }

  static Future<void> openPdf(File pdfFile) async {
    final result = await OpenFile.open(pdfFile.path);
    if (result.type != ResultType.done) {
      throw Exception('Could not open the PDF file: ${result.message}');
    }
  }
}
