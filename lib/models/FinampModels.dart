import 'package:hive/hive.dart';

import 'JellyfinModels.dart';

part 'FinampModels.g.dart';

@HiveType(typeId: 8)
class FinampUser {
  FinampUser({
    this.baseUrl,
    this.userDetails,
    this.view,
  });

  @HiveField(0)
  String baseUrl;
  @HiveField(1)
  AuthenticationResult userDetails;
  @HiveField(2)
  BaseItemDto view;
}

@HiveType(typeId: 28)
class FinampSettings {
  FinampSettings({
    this.isOffline = false,
  });

  @HiveField(0)
  bool isOffline;
}
