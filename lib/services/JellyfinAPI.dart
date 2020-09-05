import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

import '../models/JellyfinModels.dart';

class JellyfinAPI {
  AuthenticationResult currentUser;
  String address;
  String protocol;

  String authHeader;

  Dio _dio = new Dio();

  /// Sets the address that Dio and NetworkImages use for requests
  void setAddress({@required String address, @required String protocol}) {
    _dio.options.baseUrl = "$protocol://$address/";
    this.address = address;
    this.protocol = protocol;
  }

  /// Creates the X-Emby-Authorization header
  Future<String> getAuthHeader() async {
    String authHeader = "MediaBrowser ";
    // authHeader = authHeader + "MediaBrowser ";

    if (currentUser != null) {
      authHeader = authHeader + 'UserId="${currentUser.user.id}", ';
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      authHeader = authHeader + 'Client="Android", ';
      authHeader = authHeader + 'Device="${androidDeviceInfo.model}", ';
      authHeader = authHeader + 'DeviceId="${androidDeviceInfo.androidId}", ';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      authHeader = authHeader + 'Client="iOS", ';
      authHeader = authHeader + 'Device="${iosDeviceInfo.utsname.machine}", ';
      authHeader =
          authHeader + 'DeviceId="${iosDeviceInfo.identifierForVendor}", ';
    } else {
      throw "getAuthHeader() only supports Android and iOS";
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    authHeader = authHeader + 'Version="${packageInfo.version}"';
    return authHeader;
  }

  /// Retrieves a list of public users.
  Future<List<UserDto>> publicUsers() async {
    Response response = await _dio.get(
      "Users/Public",
    );

    List<dynamic> publicUserListJson = jsonDecode(response.data);

    List<UserDto> publicUserList = [];
    for (var publicUserJson in publicUserListJson) {
      publicUserList.add(UserDto.fromJson(publicUserJson));
    }

    return publicUserList;
  }

  /// Gets the profile picture of the given user. If the user doesn't have a profile picture, a "person" icon is returned.
  Widget getProfilePicture({
    @required UserDto user,
    int maxWidth,
    int maxHeight,
  }) {
    if (user.primaryImageTag == null) {
      return Icon(
        Icons.person,
      );
    } else {
      // Ink.image is used here so that it renders properly with an Inkwell (used on login screen)
      return Ink.image(
        image: NetworkImage(
          "$protocol://$address/Users/${user.id}/Images/Primary",
        ),
        fit: BoxFit.cover,
      );
    }
  }

  /// Gets album art if the album has a primary image. If maxWidth OR maxHeight aren't specified, no max width or height will be requested.
  Widget getAlbumPrimaryImage(
      {@required BaseItemDto item, int maxWidth, int maxHeight}) {
    if (item.imageTags["Primary"] == null) {
      return Icon(Icons.album);
    } else {
      if (maxHeight == null || maxWidth == null) {
        return (Image.network(
            "$protocol://$address/Items/${item.id}/Images/Primary",
            headers: {
              "X-Emby-Authorization":
                  'MediaBrowser UserId="2d047997befc4238a2f3e9f485bd09df", Client="Android", Device="sdk_gphone_x86_64_arm64", DeviceId="ce6190f2704b9be8", Version="1.0.0"'
            }));
      } else {
        return (Image.network(
            "$protocol://$address/Items/${item.id}/Images/Primary?MaxWidth=$maxWidth&MaxHeight=$maxHeight",
            headers: {
              "X-Emby-Authorization":
                  'MediaBrowser UserId="2d047997befc4238a2f3e9f485bd09df", Client="Android", Device="sdk_gphone_x86_64_arm64", DeviceId="ce6190f2704b9be8", Version="1.0.0"'
            }));
      }
    }
  }

  /// Authenticates the user via their username and saves the result to currentUser
  Future authenticateViaName(
      {@required String username, String password}) async {
    http.Response response;

    // Accounts that don't have passwords don't need the password value in the body
    if (password == null) {
      response = await http.post(
          "$protocol://$address/Users/AuthenticateByName",
          headers: {"X-Emby-Authorization": await getAuthHeader()},
          body: {"Username": username});
    } else {
      response = await http.post(
          "$protocol://$address/Users/AuthenticateByName",
          headers: {"X-Emby-Authorization": await getAuthHeader()},
          body: {"Username": username, "Pw": password});
    }

    if (response.statusCode == 401) {
      throw ("${response.statusCode}: Incorrect username or password");
    } else if (response.statusCode != 200) {
      throw ("${response.statusCode}: ${response.body}");
    }

    AuthenticationResult authenticationResult =
        AuthenticationResult.fromJson(jsonDecode(response.body));

    currentUser = authenticationResult;
  }

  /// Gets the users views (Music, Movies, TV etc)
  Future<QueryResult_BaseItemDto> getViews() async {
    http.Response response = await http.get(
      "$protocol://$address/Users/${currentUser.user.id}/Views",
      headers: {"X-Emby-Authorization": await getAuthHeader()},
    );

    if (response.statusCode != 200) {
      throw ("${response.statusCode}: ${response.body}");
    }

    return QueryResult_BaseItemDto.fromJson(jsonDecode(response.body));
  }

  Future<QueryResult_BaseItemDto> getAlbums() async {
    QueryResult_BaseItemDto views = await getViews();
    BaseItemDto musicView;
    for (final view in views.items) {
      if (view.collectionType == "music") {
        musicView = view;
        break;
      }
    }

    if (musicView == null) {
      throw "No music library found";
    }

    // print(
    //     "$protocol://$address/Users/${currentUser.user.id}/Items?parentId=${musicView.id}&IncludeItemTypes=MusicAlbum");

    print(currentUser.toJson().toString());
    print(await getAuthHeader());

    http.Response response = await http.get(
        "$protocol://$address/Users/${currentUser.user.id}/Items?Recursive=true&IncludeItemTypes=MusicAlbum&ParentId=${musicView.id}&SortBy=SortName&SortOrder=Ascending",
        headers: {
          "X-Emby-Authorization": await getAuthHeader(),
          "X-Emby-Token": currentUser.accessToken
        });

    if (response.statusCode != 200) {
      throw ("${response.statusCode}: ${response.body}");
    }

    return QueryResult_BaseItemDto.fromJson(jsonDecode(response.body));
  }
}
