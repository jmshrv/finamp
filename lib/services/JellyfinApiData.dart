import 'dart:convert';

import 'package:finamp/models/JellyfinModels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JellyfinApiData {
  AuthenticationResult _currentUser;

  /// Loads the current user from SharedPreferences if loaded for the first time or from this class if it exists. Returns null if there is no user.
  Future<AuthenticationResult> loadCurrentUser() async {
    if (_currentUser != null) {
      print("Getting user from memory");
      return _currentUser;
    }

    print("Getting user from SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currentUserJson = sharedPreferences.getString("currentUser");

    if (currentUserJson == null) {
      print("User didn't exist in SharedPreferences, returning null");
      return null;
    }

    // We set _currentUser in this class to the value loaded from SharedPreferences because loading it every time we need it (which is on every API request) is very inefficient.
    _currentUser = AuthenticationResult.fromJson(jsonDecode(currentUserJson));
    return _currentUser;
  }

  /// Saves a new user to SharedPreferences and sets the variable in this class.
  Future<void> saveUser(AuthenticationResult newUser) async {
    print("Saving new user");
    _currentUser = newUser;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("currentUser", jsonEncode(newUser));
  }
}
