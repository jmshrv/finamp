#!/bin/sh -ve
flutter config --enable-linux-desktop
flutter clean
flutter pub get
flutter build linux --release -v
