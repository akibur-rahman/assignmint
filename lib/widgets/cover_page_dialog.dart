import 'package:flutter/material.dart';
import 'package:assignmint/models/cover_page_model.dart';
import 'package:assignmint/widgets/cover_page_form.dart';

class CoverPageDialog extends StatelessWidget {
  const CoverPageDialog({Key? key}) : super(key: key);

  static Future<CoverPageDetails?> show(BuildContext context) {
    return showDialog<CoverPageDetails>(
      context: context,
      builder: (context) => const CoverPageDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: CoverPageForm(
          onSave: (details) {
            Navigator.of(context).pop(details);
          },
        ),
      ),
    );
  }
}
