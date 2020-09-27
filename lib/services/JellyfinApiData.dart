import 'dart:convert';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JellyfinApi.dart';

class JellyfinApiData {
  JellyfinApi jellyfinApi = JellyfinApi.create();
  AuthenticationResult _currentUser;
  BaseItemDto _view;
  String _baseUrl;

  /// Loads the current user from SharedPreferences if loaded for the first time or from this class if it exists. Returns null if there is no user.
  Future<AuthenticationResult> getCurrentUser() async {
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

  Future<BaseItemDto> getView() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return BaseItemDto.fromJson(
        jsonDecode(sharedPreferences.getString("view")));
  }

  Future<List<BaseItemDto>> getAlbums() async {
    List futures = await Future.wait([getCurrentUser(), getView()]);
    AuthenticationResult currentUser = futures[0];
    BaseItemDto view = futures[1];
    Response response =
        await jellyfinApi.getAlbums(currentUser.user.id, view.id);

    return (QueryResult_BaseItemDto.fromJson(response.body).items);
  }

  Future<Uint8List> getAlbumPrimaryImage(BaseItemDto album) async {
    Response response =
        await jellyfinApi.getAlbumPrimaryImage(id: album.id, format: "webp");
    if (!response.isSuccessful) {
      return Future.error("Error code ${response.statusCode}");
    }
    return Uint8List.fromList(response.body.codeUnits);
  }

  Future<String> getBaseUrl() async {
    if (_baseUrl != null) {
      print("Getting baseUrl from memory");
      return _baseUrl;
    }

    print("Getting baseUrl from SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _baseUrl = sharedPreferences.getString("baseUrl");
    return _baseUrl;
  }

  Future<void> saveBaseUrl(String protocol, String address) async {
    // Formats the protocol and the address like a proper URL
    String newBaseUrl = "$protocol://$address";
    _baseUrl = newBaseUrl;

    print("Saving baseUrl to SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("baseUrl", newBaseUrl);
  }

  /// Authenticates a user and saves the login details
  Future<void> authenticateViaName(
      {@required String username, String password}) async {
    Response response;

    // Some users won't have a password.
    if (password == null) {
      response = await jellyfinApi.authenticateViaName({"Username": username});
    } else {
      response = await jellyfinApi
          .authenticateViaName({"Username": username, "Pw": password});
    }

    if (response.isSuccessful) {
      AuthenticationResult newUser =
          AuthenticationResult.fromJson(response.body);
      await saveUser(newUser);
    } else {
      return Future.error(response.error);
    }
  }

  /// Gets all the user's views with the type "music".
  Future<List<BaseItemDto>> getMusicViews() async {
    Response response = await jellyfinApi.getViews(_currentUser.user.id);

    if (response.isSuccessful) {
      // This converts the list of items into a usable list of BaseItemDtos.
      List<BaseItemDto> viewList = [];
      for (final i in response.body["Items"]) {
        if (i["CollectionType"] == "music") {
          viewList.add(BaseItemDto.fromJson(i));
        }
      }
      return viewList;
    } else {
      return Future.error(response.error);
    }
  }
}
