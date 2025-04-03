import 'package:get_storage/get_storage.dart';

class UserProfile {
  static final _storage = GetStorage();
  static const String _storageKey = 'user_profile';

  String name;
  String email;
  String? profileImagePath;

  UserProfile({
    required this.name,
    required this.email,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profileImagePath': profileImagePath,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      email: json['email'] as String,
      profileImagePath: json['profileImagePath'] as String?,
    );
  }

  Future<void> save() async {
    await _storage.write(_storageKey, toJson());
  }

  static UserProfile? load() {
    final data = _storage.read(_storageKey);
    if (data == null) return null;
    return UserProfile.fromJson(data);
  }
}
