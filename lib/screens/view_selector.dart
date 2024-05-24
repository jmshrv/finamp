import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../components/ViewSelector/no_music_libraries_message.dart';
import '../components/global_snackbar.dart';
import '../models/jellyfin_models.dart';
import '../services/finamp_user_helper.dart';
import '../services/jellyfin_api_helper.dart';
import 'music_screen.dart';

class ViewSelector extends StatefulWidget {
  const ViewSelector({Key? key}) : super(key: key);

  static const routeName = "/settings/views";

  @override
  State<ViewSelector> createState() => _ViewSelectorState();
}

class _ViewSelectorState extends State<ViewSelector> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  late Future<List<BaseItemDto>> viewListFuture;
  final Map<BaseItemDto, bool> _views = {};
  bool isSubmitButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    viewListFuture = _jellyfinApiHelper.getViews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BaseItemDto>>(
      future: viewListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Finamp only supports music libraries. We used to allow people to
          // select unsupported libraries, but some people selected "general"
          // libraries and thought Finamp was broken.
          if (snapshot.data!.isEmpty ||
              !snapshot.data!
                  .any((element) => element.collectionType == "music")) {
            return NoMusicLibrariesMessage(
              onRefresh: () {
                setState(() {
                  _views.clear();
                  viewListFuture = _jellyfinApiHelper.getViews();
                });
              },
            );
          }

          if (_views.isEmpty) {
            _views.addEntries(snapshot.data!
                .where((element) => element.collectionType != "playlists")
                .map((e) => MapEntry(e, e.collectionType == "music")));

            // If only one music library is available and user doesn't have a
            // view saved (assuming setup is in progress), skip the selector.
            if (_views.values.where((element) => element == true).length == 1 &&
                _finampUserHelper.currentUser!.currentView == null) {
              _submitChoice();
            } else {
              if (mounted) {
                isSubmitButtonEnabled = _views.values.contains(true);
              }
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.selectMusicLibraries),
            ),
            floatingActionButton: isSubmitButtonEnabled
                ? FloatingActionButton(
                    onPressed: _submitChoice,
                    child: const Icon(Icons.check),
                  )
                : null,
            body: ListView.builder(
              itemCount: _views.length,
              itemBuilder: (context, index) {
                final isSelected = _views.values.elementAt(index);
                final view = _views.keys.elementAt(index);

                return CheckboxListTile(
                  value: isSelected,
                  enabled: view.collectionType == "music",
                  title: Text(_views.keys.elementAt(index).name ??
                      AppLocalizations.of(context)!.unknownName),
                  onChanged: (value) {
                    setState(() {
                      _views[_views.keys.elementAt(index)] = value!;
                      isSubmitButtonEnabled = _views.values.contains(true);
                    });
                  },
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          GlobalSnackbar.error(snapshot.error);
          // TODO: Let the user refresh the page
          return const Center(child: Icon(Icons.error));
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  void _submitChoice() {
    if (_views.values.where((element) => element == true).isEmpty) {
      // This should no longer be possible since the submit button only shows
      // when views are selected, but we return just in case
      return;
    } else {
      try {
        _finampUserHelper.setCurrentUserViews(_views.entries
            .where((element) => element.value == true)
            .map((e) => e.key)
            .toList());
        // allow navigation to music screen while selector is being built
        Future.microtask(() => Navigator.of(context)
            .pushNamedAndRemoveUntil(MusicScreen.routeName, (route) => false));
      } catch (e) {
        GlobalSnackbar.error(e);
      }
    }
  }
}
