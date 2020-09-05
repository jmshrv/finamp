import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

import '../models/JellyfinModels.dart';

part 'JellyfinAPI.chopper.dart';

@ChopperApi()
abstract class JellyfinAPIService extends ChopperService {
  @Get(path: "/Users/Public")
  Future<List<UserDto>> getPublicUsers();

  static JellyfinAPIService create() {
    final client = ChopperClient(
      // The first part of the URL is now here
      baseUrl: 'https://jsonplaceholder.typicode.com',
      services: [
        // The generated implementation
        _$JellyfinAPIService(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      converter: JsonConverter(),
    );

    // The generated class with the ChopperClient passed in
    return _$JellyfinAPIService(client);
  }
}
