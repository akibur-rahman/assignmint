import 'package:assignmint/controllers/pdf_controller.dart';
import 'package:assignmint/pages/main_scaffold_page.dart';
import 'package:assignmint/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:assignmint/controllers/assignment_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:assignmint/services/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await TokenService().initialize();
  await dotenv.load(fileName: "assets/.env");
  final apiKey = dotenv.env['API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('GEMINI_API_KEY not found in .env file');
  }
  Gemini.init(apiKey: apiKey);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AssignMint',
      theme: AppTheme.lightTheme,
      initialBinding: AppBindings(),
      home: MainScaffold(),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentController>(
      () => AssignmentController(),
      fenix: true,
    );
    Get.put(PdfController());
    Get.put(TokenService());
  }
}
