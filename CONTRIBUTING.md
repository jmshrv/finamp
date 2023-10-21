# Contributing to Finamp

Thanks for your interest in contributing to Finamp! This document goes over how to get started on Finamp development, and other ways to contribute.

## Setting up a Development Environment

Finamp is a fairly standard Flutter app, so all you have to do is [install Flutter](https://docs.flutter.dev/get-started/install). Once Flutter is installed, you should be able to run Finamp on emulators/real devices.

### Android Keys

To build release APKs, you need to set up a signing key for Android. To get that set up, follow [this guide](https://docs.flutter.dev/deployment/android#signing-the-app) from the Flutter documentation. Note that if you have Finamp installed already, your phone may panic because the key is different.

### The Arcane Arts (Code Generation)

![A conversation between me and Chaphasilor. I say "did you try running (the Dart build command)?" They reply "I wasn't aware I need to use the arcane arts for this"](assets/arcane-arts.png)

Because Dart doesn't support macros and stuff, a few dependencies rely on code generation which must be run manually. These dependencies are:

* Hive - the database that Finamp uses for storing all data
* `json_serializable` - For deserialising JSON into classes
* Chopper - For talking to Jellyfin over HTTP
    * This layer (`lib/services/jellyfin_api.dart`) is not used by the app directly. The user-facing API is located at `lib/services/jellyfin_api_helper.dart`.

To rebuild these files, run `dart run build_runner build --delete-conflicting-outputs`. This must be done when:

* Modifying a class that is returned by Jellyfin (such as the classes in `lib/models/jellyfin_models.dart`)
* Adding fields to a database class (annotated with `@HiveType`)

### Hive

As said earlier, Finamp uses Hive for all data storage needs. If you're doing work that involves data storage, I recommend you read [the Hive docs](https://docs.hivedb.dev/#/). Please ensure that your changes work when upgrading Finamp from the current release to your changes, as not handling upgrades will cause the app to crash.

## Translating

Finamp uses Weblate to manage translations: **https://hosted.weblate.org/engage/finamp/**

Feel free to add new languages if yours isn't there yet. If you have any questions, such as the context of a string, you can ask in the [Translation Discussions](https://github.com/jmshrv/finamp/discussions/categories/translations).