import 'package:get_storage/get_storage.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  final _storage = GetStorage();

  factory TokenService() {
    return _instance;
  }

  TokenService._internal();

  Future<void> initialize() async {
    await GetStorage.init();
  }

  BigInt getTotalTokens() {
    final storedValue = _storage.read('totalTokens');
    if (storedValue == null) return BigInt.zero;
    return BigInt.parse(storedValue.toString());
  }

  Future<void> addTokens(int tokens) async {
    final currentTokens = getTotalTokens();
    final newTotal = currentTokens + BigInt.from(tokens);
    await _storage.write('totalTokens', newTotal.toString());
  }

  Future<void> resetTokens() async {
    await _storage.write('totalTokens', '0');
  }
}
