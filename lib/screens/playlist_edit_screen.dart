import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:get_it/get_it.dart';
import '../models/jellyfin_models.dart';

class PlaylistEditScreen extends ConsumerStatefulWidget {
  const PlaylistEditScreen({super.key, required this.playlist});

  static const routeName = "/music/album/edit";
  final BaseItemDto playlist;

  @override
  ConsumerState<PlaylistEditScreen> createState() => _PlaylistEditScreenState();
}

class _PlaylistEditScreenState extends ConsumerState<PlaylistEditScreen> {
  String? _name;
  BaseItemId? _id;
  bool? _publicVisibility;
  bool _isUpdating = false;

  BaseItemDto? _albumImage;
  // Future<File?> newAlbumImage; 
  // int _songCount = 1;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = widget.playlist.name;
    _id = widget.playlist.id;
    _albumImage = widget.playlist;
    // newAlbumImage = widget.playlist as Future<File?>;
    _fetchPublicVisibility();
    // _songCount = 1;
  }

  Future<File?> filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,      
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  void setNewAlbumImage() async {}

  Future<void> _fetchPublicVisibility() async {
    if (_publicVisibility != null) return;
    final resultPlaylist = await _jellyfinApiHelper.getPlaylist(_id!);
    setState(() {
      _publicVisibility = resultPlaylist['OpenAccess'] as bool;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isUpdating = true;
      });

      _formKey.currentState!.save();

      try {
        BaseItemDto playlistTemp = widget.playlist;
        playlistTemp.name = _name;
        await _jellyfinApiHelper.updatePlaylist(
          newPlaylist: NewPlaylist(
            isPublic: _publicVisibility,
            userId: GetIt.instance<FinampUserHelper>().currentUserId,
            ids: null,
            name: _name,
          ),
          itemId: widget.playlist.id,
        );




        if (!mounted) return;

        GlobalSnackbar.message((context) => AppLocalizations.of(context)!.playlistUpdated, isConfirmation: true);
        Navigator.of(context).pop();
      } catch (e) {
        errorSnackbar(e, context);

        if (mounted) {
          setState(() {
            _isUpdating = false;
          });
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editItemTitle("playlist"))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Album Image
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      AlbumImage(
                        item: _albumImage,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        tapToZoom: false,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Future<File?> _newImage = filePicker();

                        },
                        child: Container(color: Colors.black.withValues(alpha: 0.25)),
                      ),
                      (Icon(TablerIcons.edit)),
                    ],
                  ),
                ),

                // Playlist Name + Public Visibility
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 10),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            initialValue: _name,
                            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.required;
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) async => await _submit(),
                            onSaved: (newValue) => _name = newValue,
                          ),
                        ),

                        FormField<bool>(
                          builder: (state) {
                            return CheckboxListTile(
                              value: _publicVisibility ?? false,
                              title: Text(
                                AppLocalizations.of(context)!.publiclyVisiblePlaylist,
                                textAlign: TextAlign.left,
                              ),
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                state.didChange(value);
                                setState(() {
                                  _publicVisibility = value!;
                                });
                              },
                            );
                          },
                        ),

                        // Text(_songCount as String),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ReorderableList(itemBuilder: null, itemCount: _songCount, onReorder: (oldIndex, newIndex) => newIndex,)
        ],
      ),
      floatingActionButton: SizedBox(
        width: 140,
        child: FloatingActionButton(
          onPressed: _isUpdating ? null : () async => await _submit(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.save), SizedBox(width: 8), Text("Save Playlist")],
          ),
        ),
      ),
    );
  }
}
