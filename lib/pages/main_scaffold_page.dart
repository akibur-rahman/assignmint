import 'package:assignmint/controllers/main_scaffold_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignmint/pages/create_page.dart';
import 'package:assignmint/pages/home_page.dart';
import 'package:assignmint/pages/profile_page.dart';

class MainScaffold extends StatelessWidget {
  MainScaffold({Key? key}) : super(key: key);

  final MainScaffoldController controller = Get.put(MainScaffoldController());

  final List<Widget> _pages = [HomePage(), CreatePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Center(child: _pages[controller.selectedIndex.value]),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Create',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: Color(0xff15803d),
          unselectedItemColor: Color.fromARGB(255, 70, 194, 113),
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xfff0fdf4),
        ),
      ),
    );
  }
}
