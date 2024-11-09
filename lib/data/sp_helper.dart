import 'package:actividad2wearables/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  static const keyName = 'name';
  static const keyImage = 'image';

  Future<bool> setProfile(String name, String urlImage) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyName, name);
      await prefs.setString(keyImage, urlImage);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<Profile> getProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String name = prefs.getString(keyName) ?? '';
      final String urlImage = prefs.getString(keyImage) ?? '';
      return Profile(name: name, urlImage: urlImage);
    } on Exception {
      throw Exception('Error recuperando perfil');
    }
  }
}
