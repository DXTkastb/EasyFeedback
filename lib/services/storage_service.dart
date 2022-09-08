import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._singleton();
  late SharedPreferences sharedPreferences;
  static final StorageService service = StorageService._singleton();

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  Future<void> deleteToken() async {
    await service.sharedPreferences.remove('auth-token');
  }
  Future<void> saveToken(String token) async {
    await service.sharedPreferences.setString('auth-token', token);
  }

}