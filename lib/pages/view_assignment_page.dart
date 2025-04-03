import 'package:assignmint/utils/formatters/markdown_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/models/assignment_preview_model.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:assignmint/controllers/pdf_controller.dart';

class ViewAssignmentPage extends StatelessWidget {
  final AssignmentPreview assignment;

  const ViewAssignmentPage({Key? key, required this.assignment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the PDF controller using GetX
    final PdfController pdfController = Get.find<PdfController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(assignment.title, style: AppTheme.HeadingTextStyle),
        backgroundColor: const Color(0xffdcfce7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryGreen),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.lightGreen),
            onPressed: () {
              pdfController.shareAssignment(
                title: assignment.title,
                content: assignment.content,
                context: context,
              );
            },
          ),
        ],
      ),

      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor: AppTheme.primaryGreen,
          onPressed:
              pdfController.isExporting.value
                  ? null
                  : () {
                    pdfController.exportAssignment(
                      title: assignment.title,
                      content: assignment.content,
                      context: context,
                    );
                  },
          child:
              pdfController.isExporting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.picture_as_pdf),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: MarkdownFormatter.formatAssignmentText(
                assignment.content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
