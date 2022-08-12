import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../services/finamp_user_helper.dart';
import 'music_screen.dart';
import '../services/jellyfin_api_helper.dart';
import '../models/jellyfin_models.dart';
import '../components/error_snackbar.dart';

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

  @override
  void initState() {
    super.initState();
    viewListFuture = _jellyfinApiHelper.getViews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectMusicLibraries),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitChoice,
        child: const Icon(Icons.check),
      ),
      body: FutureBuilder<List<BaseItemDto>>(
        future: viewListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // If snapshot.data is empty, getMusicViews returned no music libraries. This means that the user doesn't have any music libraries.
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child:
                      Text(AppLocalizations.of(context)!.couldNotFindLibraries),
                ),
              );
            } else {
              if (_views.isEmpty) {
                _views.addEntries(snapshot.data!
                    .where((element) => element.collectionType != "playlists")
                    .map((e) => MapEntry(e, e.collectionType == "music")));
              }

              // If only one music library is available and user doesn't have a
              // view saved (assuming setup is in progress), skip the selector.
              if (_views.values.where((element) => element == true).length ==
                      1 &&
                  _finampUserHelper.currentUser!.currentView == null) {
                _submitChoice();
              }

              return Scrollbar(
                child: ListView.builder(
                  itemCount: _views.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: _views.values.elementAt(index),
                      title: Text(_views.keys.elementAt(index).name ??
                          AppLocalizations.of(context)!.unknownName),
                      onChanged: (value) {
                        setState(() {
                          _views[_views.keys.elementAt(index)] = value!;
                        });
                      },
                      // onTap: () async {
                      //   JellyfinApiData jellyfinApiHelper =
                      //       GetIt.instance<JellyfinApiData>();
                      //   try {
                      //     jellyfinApiHelper.saveView(snapshot.data![index],
                      //         jellyfinApiHelper.currentUser!.id);
                      //     Navigator.of(context)
                      //         .pushNamedAndRemoveUntil("/music", (route) => false);
                      //   } catch (e) {
                      //     errorSnackbar(e, context);
                      //   }
                      // },
                    );
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            errorSnackbar(snapshot.error, context);
            // TODO: Let the user refresh the page
            return const Center(child: Icon(Icons.error));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }

  void _submitChoice() {
    if (_views.values.where((element) => element == true).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("A library is required.")));
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
        errorSnackbar(e, context);
      }
    }
  }
}
