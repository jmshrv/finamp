import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApi.dart';
import '../errorSnackbar.dart';
import '../../services/JellyfinApiData.dart';
import '../../models/JellyfinModels.dart';

/// Function to handle logging in for Widgets, including a snackbar for errors.
Future loginHelper(
    {@required JellyfinApi jellyfinApiServiceProvider,
    @required String username,
    String password,
    @required BuildContext context}) async {
  // TODO: Make this type safe in Chopper
  dynamic newUser;

  try {
    newUser = await jellyfinApiServiceProvider
        .authenticateViaName({"Username": username, "Pw": password});
    // If authenticateViaName succeeds, we can just move on to the music home page.
    // pushNamedAndRemoveUntil is used to clear the route history.
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/music", ModalRoute.withName("/"));
  } catch (e) {
    errorSnackbar(e, context);

    // We return null here to stop the function from continuing.
    return null;
  }

  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  print(newUser.body.runtimeType);
  jellyfinApiData.saveUser(AuthenticationResult.fromJson(newUser.body));
}
