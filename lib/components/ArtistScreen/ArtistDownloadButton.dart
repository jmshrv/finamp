import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/JellyfinModels.dart';
import '../../models/FinampModels.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/DownloadsHelper.dart';
import '../AlbumScreen/DownloadDialog.dart';
import '../errorSnackbar.dart';

class ArtistDownloadButton extends StatefulWidget {
  const ArtistDownloadButton({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final BaseItemDto artist;

  @override
  _ArtistDownloadButtonState createState() => _ArtistDownloadButtonState();
}

class _ArtistDownloadButtonState extends State<ArtistDownloadButton> {
  static const _disabledButton = IconButton(
    icon: Icon(Icons.download),
    onPressed: null,
  );
  Future<List<BaseItemDto>?>? _artistDownloadButtonFuture;

  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();

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

        if (isOffline) {
          return _disabledButton;
        } else {
          // We only want to get album data if we're online
          if (_artistDownloadButtonFuture == null) {
            _artistDownloadButtonFuture = _jellyfinApiData.getItems(
              parentItem: widget.artist,
              includeItemTypes: "MusicAlbum",
              isGenres: false,
            );
          }
          return FutureBuilder<List<BaseItemDto>?>(
            future: _artistDownloadButtonFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final undownloadedAlbums =
                    _getUndownloadedAlbums(snapshot.data!);

                return IconButton(
                  icon: undownloadedAlbums.isEmpty
                      ? Icon(Icons.delete)
                      : Icon(Icons.download),
                  onPressed: () async {
                    if (undownloadedAlbums.isEmpty) {
                      final deleteFutures = snapshot.data!.map((e) =>
                          _downloadsHelper.deleteDownloads(
                              jellyfinItemIds: _downloadsHelper
                                  .getDownloadedParent(e.id)!
                                  .downloadedChildren
                                  .keys
                                  .toList(),
                              deletedFor: e.id));
                      Future.wait(deleteFutures).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Downloads deleted.")));
                      },
                          onError: (error, stackTrace) =>
                              errorSnackbar(error, context));
                    } else {
                      List<Future<List<BaseItemDto>?>> albumInfoFutures = [];
                      undownloadedAlbums.forEach((element) {
                        albumInfoFutures.add(_jellyfinApiData.getItems(
                          parentItem: element,
                          sortBy: "SortName",
                          includeItemTypes: "Audio",
                          isGenres: false,
                        ));
                      });

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
                            items: albumInfo.map((e) => e!).toList()),
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
