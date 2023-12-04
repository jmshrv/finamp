import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/downloads_helper.dart';
import '../AlbumScreen/download_dialog.dart';
import '../confirmation_prompt_dialog.dart';
import '../error_snackbar.dart';

class ArtistDownloadButton extends StatefulWidget {
  const ArtistDownloadButton({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final BaseItemDto artist;

  @override
  State<ArtistDownloadButton> createState() => _ArtistDownloadButtonState();
}

class _ArtistDownloadButtonState extends State<ArtistDownloadButton> {
  static const _disabledButton = IconButton(
    icon: Icon(Icons.download),
    onPressed: null,
  );
  Future<List<BaseItemDto>?>? _artistDownloadButtonFuture;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  List<BaseItemDto> _getUndownloadedAlbums(List<BaseItemDto> albums) {
    return albums
        .where((element) => !_downloadsHelper.isAlbumDownloaded(element.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, _) {
        final isOffline = box.get("FinampSettings")?.isOffline ?? false;
        bool deleteAlbums = false;

        if (isOffline) {
          return _disabledButton;
        } else {
          // We only want to get album data if we're online
          _artistDownloadButtonFuture ??= _jellyfinApiHelper.getItems(
            parentItem: widget.artist,
            includeItemTypes: "MusicAlbum",
            isGenres: false,
          );
          return FutureBuilder<List<BaseItemDto>?>(
            future: _artistDownloadButtonFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final undownloadedAlbums =
                    _getUndownloadedAlbums(snapshot.data!);
                deleteAlbums = undownloadedAlbums.isEmpty;

                return IconButton(
                  icon: deleteAlbums
                      ? const Icon(Icons.delete)
                      : const Icon(Icons.download),
                  onPressed:() async {
                    if (deleteAlbums) {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationPromptDialog(
                          promptText: AppLocalizations.of(context)!
                              .deleteDownloadsPrompt(
                                  widget.artist.name ?? "",
                                  widget.artist.type == "MusicArtist" ? "artist" : "genre"),
                          confirmButtonText: AppLocalizations.of(context)!
                              .deleteDownloadsConfirmButtonText,
                          abortButtonText: AppLocalizations.of(context)!
                              .deleteDownloadsAbortButtonText,
                          onConfirmed: () async {
                            try {
                              final deleteFutures = snapshot.data!.map((e) =>
                                  _downloadsHelper.deleteDownloads(
                                      jellyfinItemIds: _downloadsHelper
                                          .getDownloadedParent(e.id)!
                                          .downloadedChildren
                                          .keys
                                          .toList(),
                                      deletedFor: e.id));
                              await Future.wait(deleteFutures);
                              ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Downloads deleted.")));
                              final undownloadedAlbums =
                                  _getUndownloadedAlbums(snapshot.data!);
                              setState(() {
                                deleteAlbums = undownloadedAlbums.isEmpty;
                              });
                            } catch (error) {
                              errorSnackbar(error, context);
                            }
                          },
                          onAborted: () {},
                        ),
                      );
                    } else {
                      List<Future<List<BaseItemDto>?>> albumInfoFutures = [];
                      for (var element in undownloadedAlbums) {
                        albumInfoFutures.add(_jellyfinApiHelper.getItems(
                          parentItem: element,
                          sortBy: "SortName",
                          includeItemTypes: "Audio",
                          isGenres: false,
                        ));
                      }

                      List<List<BaseItemDto>?> albumInfo;

                      try {
                        albumInfo = await Future.wait(albumInfoFutures);
                      } catch (e) {
                        errorSnackbar(e, context);
                        return;
                      }

                      await showDialog(
                        context: context,
                        builder: (context) => DownloadDialog(
                          parents: undownloadedAlbums,
                          // getItems returns null so we have to null check
                          // each element
                          items: albumInfo.map((e) => e!).toList(),
                          viewId: _finampUserHelper.currentUser!.currentViewId!,
                        ),
                      );
                    }
                    // We call a setState so that the downloaded albums are
                    // checked again (so that the download icon turns into a
                    // delete icon and vice-versa)
                    setState(() {});
                  },
                );
              } else if (snapshot.hasError) {
                errorSnackbar(snapshot.error, context);
                return _disabledButton;
              } else {
                return _disabledButton;
              }
            },
          );
        }
      },
    );
  }
}
