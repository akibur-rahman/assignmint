import 'package:assignmint/pages/template_page.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:assignmint/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Assignment', style: AppTheme.HeadingTextStyle),
        backgroundColor: Color(0xffdcfce7),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/lottie/greenPurpleMan.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 40), // Add some space between animation and button
            // Green Elevated Button
            GreenElevatedButton(
              buttontext: "Create Assignment",
              onPressed: () {
                // Navigate to the AssignmentPage
                Get.to(() => TemplatePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
