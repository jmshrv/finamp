import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../screens/artist_screen.dart';

List<TextSpan> buildArtistsTextSpans(
    BaseItemDto item,
    Color? textColour,
    BuildContext context,
    bool popRoutes
  ) {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  List<TextSpan> separatedArtistTextSpans = [];

  List<NameIdPair>? artists =
    item.type == "MusicAlbum"
    ? item.albumArtists
    : item.artistItems;

  if (artists?.isEmpty ?? true) {
    separatedArtistTextSpans = [
      TextSpan(
        text: "Unknown Artist",
        style: TextStyle(color: textColour),
      )
    ];
  } else {
    artists
      ?.map((e) => TextSpan(
      text: e.name,
      style: TextStyle(color: textColour),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // Offline artists aren't implemented yet so we return if offline
          if (FinampSettingsHelper.finampSettings.isOffline) return;

          jellyfinApiHelper.getItemById(e.id).then((artist) =>
            popRoutes
            ? Navigator.of(context).popAndPushNamed(
                ArtistScreen.routeName,
                arguments: artist)
            : Navigator.of(context).pushNamed(
                ArtistScreen.routeName,
                arguments: artist)
          );
        }))
      .forEach((artistTextSpan) {
      separatedArtistTextSpans.add(artistTextSpan);
      separatedArtistTextSpans.add(TextSpan(
        text: ", ",
        style: TextStyle(color: textColour),
      ));
    });
    separatedArtistTextSpans.removeLast();
  }
  return separatedArtistTextSpans;
}
