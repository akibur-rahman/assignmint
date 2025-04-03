import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/services/pdf_export_service.dart';

class PdfController extends GetxController {
  final RxBool isExporting = false.obs;

  Future<void> exportAssignment({
    required String title,
    required String content,
    required BuildContext context,
  }) async {
    try {
      isExporting.value = true;

      // Generate PDF
      final pdfFile = await PdfExportService.generateAssignmentPdf(
        title: title,
        content: content,
        context: context,
      );

      if (pdfFile == null) return; // User cancelled

      // Open PDF after generation
      await PdfExportService.openPdf(pdfFile);

      Get.snackbar(
        'Success',
        'Assignment exported successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export assignment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> shareAssignment({
    required String title,
    required String content,
    required BuildContext context,
  }) async {
    try {
      isExporting.value = true;

      // Generate PDF
      final pdfFile = await PdfExportService.generateAssignmentPdf(
        title: title,
        content: content,
        context: context,
      );

      if (pdfFile == null) return;

      // Share PDF
      await PdfExportService.sharePdf(pdfFile);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share assignment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isExporting.value = false;
    }
  }
}
