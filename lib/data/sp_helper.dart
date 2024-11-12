import 'package:actividad2wearables/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  static const keyName = 'name';
  static const keyImage = 'image';
  static const keyFavs = 'favs';

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

  Future<List<String>> getFavIds() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> favorites = prefs.getStringList(keyFavs) ?? [];
      return favorites;
    } on Exception {
      throw Exception('Error recuperando perfil');
    }
  }

  Future<bool> addFavorite(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> favorites = prefs.getStringList(keyFavs) ?? [];
      favorites.add(id);
      await prefs.setStringList(keyFavs, favorites);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeFavorite(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> favorites = prefs.getStringList(keyFavs) ?? [];
      favorites.remove(id);
      await prefs.setStringList(keyFavs, favorites);
      return true;
    } on Exception {
      return false;
    }
  }
}
