

import 'package:shared_preferences/shared_preferences.dart';

class DataStore {
  Future<bool> setDataString(String nama, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(nama, value);
    return true;
  }

  Future<String?> getDataString(String nama) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nama) ?? 'Kosong';
  }

  Future<bool> setDataBool(String nama, bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(nama, value);
    return true;
  }

  Future<bool?> getDataBool(String nama) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(nama);
  }

  Future<bool> setDataInteger(String nama, int value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(nama, value);
    return true;
  }

  Future<int> getDataInteger(String nama) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(nama) ?? 0;
  }

  Future<bool> logout() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    return true;
  }

  Future<bool> setDataList(String nama, List<String> list) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(nama, list);
  }

  Future<List<String>> getDataList(String nama) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(nama) ?? [];
  }
}
