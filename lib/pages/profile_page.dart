import 'package:assignmint/utils/theme/theme.dart';
import 'package:assignmint/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:assignmint/services/token_service.dart';
import 'package:assignmint/controllers/assignment_controller.dart';
import 'package:assignmint/models/user_profile.dart';
import 'package:assignmint/widgets/edit_profile_form.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final tokenService = TokenService();
  final assignmentController = Get.find<AssignmentController>();
  late UserProfile _userProfile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    _userProfile = UserProfile.load() ??
        UserProfile(
          name: 'User',
          email: 'user@gmail.com',
        );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 180,
        maxHeight: 180,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _userProfile.profileImagePath = image.path;
        });
        await _userProfile.save();
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: EditProfileForm(
          initialProfile: _userProfile,
          onSave: (updatedProfile) async {
            setState(() {
              _userProfile = updatedProfile;
            });
            await _userProfile.save();
          },
        ),
      ),
    );
  }

  String formatNumber(BigInt number) {
    if (number >= BigInt.from(1000000)) {
      return '${(number / BigInt.from(1000000)).toStringAsFixed(1)}M';
    } else if (number >= BigInt.from(1000)) {
      return '${(number / BigInt.from(1000)).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final totalTokens = tokenService.getTotalTokens();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTheme.HeadingTextStyle),
        backgroundColor: Color(0xffdcfce7),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: _userProfile.profileImagePath != null
                      ? Image.file(
                          File(_userProfile.profileImagePath!),
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            color: Color.fromARGB(255, 97, 228, 143),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              _userProfile.name,
              style: TextStyle(
                color: Color(0xff15803d),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Center(
            child: Text(
              _userProfile.email,
              style: TextStyle(
                color: Color.fromARGB(255, 43, 211, 105),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: GreenElevatedButton(
              buttontext: 'Edit Profile',
              onPressed: _showEditProfileDialog,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => Column(
                          children: [
                            Text(
                              assignmentController.assignments.length
                                  .toString(),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Assignments',
                              style: TextStyle(
                                color: Color.fromARGB(255, 43, 211, 105),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            formatNumber(totalTokens),
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Tokens Used',
                            style: TextStyle(
                              color: Color.fromARGB(255, 43, 211, 105),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => Column(
                          children: [
                            Text(
                              assignmentController
                                  .getRecentAssignmentsCount()
                                  .toString(),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Last 7 days',
                              style: TextStyle(
                                color: Color.fromARGB(255, 43, 211, 105),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
