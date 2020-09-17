import 'dart:convert';

import 'package:finamp/models/JellyfinModels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JellyfinApiData {
  AuthenticationResult _currentUser;

  BaseItemDto _view;

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

  Future<BaseItemDto> loadView() async {
    if (_view != null) {
      print("Getting view from memory");
      return _view;
    }

    print("Getting view from SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String viewJson = sharedPreferences.getString("view");

    if (viewJson == null) {
      return null;
    }

    _view = BaseItemDto.fromJson(jsonDecode(viewJson));
    return _view;
  }

  Future<void> saveView(BaseItemDto newView) async {
    print("Saving view");
    _view = newView;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("view", jsonEncode(newView));
  }
}
