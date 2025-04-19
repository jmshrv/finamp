import 'package:flutter/material.dart';

import '../components/GenreScreen/genre_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({
    super.key,
    this.widgetGenre,
  });

  static const routeName = "/music/genre";

  /// The genre to show. Can also be provided as an argument in a named route
  final BaseItemDto? widgetGenre;


  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {

  @override
  Widget build(BuildContext context) {
    final BaseItemDto genre = widget.widgetGenre ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: GenreScreenContent(
          parent: genre,
        ),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
