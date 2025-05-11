import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/GenreScreen/genre_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';

class GenreScreen extends ConsumerStatefulWidget {
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

class _GenreScreenState extends ConsumerState<GenreScreen> {
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  Future<void> _refresh() async {
    ref.invalidate(genreCuratedItemsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final BaseItemDto genre = widget.widgetGenre ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: GenreScreenContent(
            parent: genre,
            library: _finampUserHelper.currentUser?.currentView,
          ),
        )
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}