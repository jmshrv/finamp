import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_list.dart';
import 'package:finamp/components/AddToPlaylistScreen/playlist_actions_menu.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../models/jellyfin_models.dart';
import '../../services/favorite_provider.dart';
import '../../services/feedback_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/theme_provider.dart';
import '../AlbumScreen/song_menu.dart';
import '../global_snackbar.dart';
import '../themed_bottom_sheet.dart';

const outputMenuRouteName = "/output-menu";

Future<void> showOutputMenu({
  required BuildContext context,
  bool usePlayerTheme = true,
  FinampTheme? themeProvider,
}) async {
  final outputPanelLogger = Logger("OutputPanel");

  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final queueService = GetIt.instance<QueueService>();

  FeedbackHelper.feedback(FeedbackType.selection);

  await showThemedBottomSheet(
      context: context,
      item: (await queueService.getCurrentTrack()?.baseItem)!, //TODO fix this
      routeName: outputMenuRouteName,
      minDraggableHeight: 0.2,
      buildSlivers: (context) {
        var themeColor = Theme.of(context).colorScheme.primary;
        var playlistsFuture = jellyfinApiHelper.getItems(
          includeItemTypes: "Playlist",
          sortBy: "SortName",
        );

        final menuEntries = [
          // SongInfo.condensed(
          //   item: item,
          //   useThemeImage: usePlayerTheme,
          // ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, child) {
              return VolumeSlider(
                initialValue: FinampSettingsHelper.finampSettings.currentVolume,
                onChange: (double currentValue) async {
                  FinampSettingsHelper.setCurrentVolume(currentValue);
                  outputPanelLogger.fine("Volume set to $currentValue");
                },
              );
            },
          ),
          // FutureBuilder(
          //     future: playlistsFuture.then((value) =>
          //         value?.firstWhereOrNull((x) => x.id == parentPlaylist?.id)),
          //     initialData: parentPlaylist,
          //     builder: (context, snapshot) {
          //       if (snapshot.data != null) {
          //         return OutputSelectorTile(
          //           playlist: snapshot.data!,
          //           song: item,
          //           playlistItemId: item.playlistItemId,
          //         );
          //       } else {
          //         return const SizedBox.shrink();
          //       }
          //     })
        ];

        var menu = [
          SliverStickyHeader(
              header: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
                child: Center(
                  child: Text(
                      AppLocalizations.of(context)!.addRemoveFromPlaylist,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
              ),
              sliver: SliverToBoxAdapter(
                child: SizedBox.shrink(),
              )),
          SliverStickyHeader(
            header: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: Text("Available Outputs",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            sliver: MenuMask(
                height: 36.0,
                child: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                  menuEntries,
                ))),
          ),
          SliverStickyHeader(
            header: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: Text("Available Outputs",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            sliver: MenuMask(
              height: 35.0,
              child:
                  // SizedBox.shrink(),
                  OutputTargetList(
                      playlistsFuture: playlistsFuture
                          .then((value) => value?.toList() ?? [])),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100.0))
        ];
        // TODO better estimate, how to deal with lag getting playlists?
        var stackHeight = MediaQuery.sizeOf(context).height * 0.9;
        return (stackHeight, menu);
      },
      usePlayerTheme: usePlayerTheme,
      themeProvider: themeProvider);
}

class OutputTargetList extends StatefulWidget {
  const OutputTargetList({
    super.key,
    required this.playlistsFuture,
  });

  final Future<List<BaseItemDto>> playlistsFuture;

  @override
  State<OutputTargetList> createState() => _OutputTargetListState();
}

class _OutputTargetListState extends State<OutputTargetList> {
  @override
  void initState() {
    super.initState();
    playlistsFuture = widget.playlistsFuture.then(
        (value) => value.map((e) => (e, false, null as String?)).toList());
  }

  // playlist, isLoading, playlistItemId
  late Future<List<(BaseItemDto, bool, String?)>> playlistsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: playlistsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == snapshot.data!.length) {
                return openOsOutputOptionsButton(context);
              }
              final (playlist, isLoading, playListItemId) =
                  snapshot.data![index];
              return OutputSelectorTile(
                  playlist: playlist,
                  playlistItemId: playListItemId,
                  isLoading: isLoading);
            },
            childCount: snapshot.data!.length + 1,
          ));
        } else if (snapshot.hasError) {
          GlobalSnackbar.error(snapshot.error);
          return const SliverToBoxAdapter(
            child: Center(
              heightFactor: 3.0,
              child: Icon(Icons.error, size: 64),
            ),
          );
        } else {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 1) {
              return openOsOutputOptionsButton(context);
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }, childCount: 2));
        }
      },
    );
  }

  Widget openOsOutputOptionsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CTAMedium(
            text: AppLocalizations.of(context)!.newPlaylist,
            icon: TablerIcons.plus,
            //accentColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              var dialogResult = await showDialog<(Future<String>, String?)?>(
                context: context,
                builder: (context) => SizedBox.shrink(),
                // NewPlaylistDialog(itemToAdd: widget.itemToAdd.id),
              );
              if (dialogResult != null) {
                var oldFuture = playlistsFuture;
                setState(() {
                  var loadingItem = [
                    (
                      BaseItemDto(id: "pending", name: dialogResult.$2),
                      true,
                      null as String?
                    )
                  ];
                  playlistsFuture =
                      oldFuture.then((value) => value + loadingItem);
                });
                try {
                  var newId = await dialogResult.$1;
                  // Give the server time to calculate an initial playlist image
                  await Future.delayed(const Duration(seconds: 1));
                  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
                  var playlist = await jellyfinApiHelper.getItemById(newId);
                  var playlistItems = await jellyfinApiHelper.getItems(
                      parentItem: playlist, fields: "");
                  // var song = playlistItems?.firstWhere(
                  //     (element) => element.id == widget.itemToAdd.id);
                  setState(() {
                    // var newItem = [(playlist, false, song?.playlistItemId)];
                    // playlistsFuture =
                    //     oldFuture.then((value) => value + newItem);
                  });
                } catch (e) {
                  GlobalSnackbar.error(e);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class OutputSelectorTile extends StatefulWidget {
  const OutputSelectorTile(
      {super.key,
      required this.playlist,
      this.playlistItemId,
      this.isLoading = false});

  final BaseItemDto playlist;
  final String? playlistItemId;
  final bool isLoading;

  @override
  State<OutputSelectorTile> createState() => OutputSelectorTileState();
}

class OutputSelectorTileState extends State<OutputSelectorTile> {
  String? playlistItemId;
  int? childCount;
  bool? itemIsIncluded;

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  @override
  void didUpdateWidget(OutputSelectorTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState();
  }

  void _updateState() {
    if (!widget.isLoading) {
      playlistItemId = widget.playlistItemId;
      childCount = widget.playlist.childCount;
      if (widget.playlistItemId != null) {
        itemIsIncluded = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;
    return ToggleableListTile(
      forceLoading: widget.isLoading,
      title: widget.playlist.name ?? AppLocalizations.of(context)!.unknownName,
      subtitle: AppLocalizations.of(context)!.songCount(childCount ?? 0),
      leading: AlbumImage(item: widget.playlist),
      positiveIcon: TablerIcons.circle_check_filled,
      negativeIcon: itemIsIncluded == null
          // we don't actually know if the track is part of the playlist
          ? TablerIcons.circle_dashed_plus
          : TablerIcons.circle_plus,
      initialState: itemIsIncluded ?? false,
      onToggle: (bool currentState) async {
        if (currentState) {
          // If playlistItemId is null, we need to fetch from the server before we can remove
          if (playlistItemId == null) {
            final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
            var newItems = await jellyfinApiHelper.getItems(
                parentItem: widget.playlist, fields: "");

            playlistItemId = null;
            if (playlistItemId == null) {
              // We were already not part of the playlist,. so removal is complete
              setState(() {
                childCount = newItems?.length ?? 0;
                itemIsIncluded = false;
              });
              return false;
            }
            if (!context.mounted) {
              return true;
            }
          }
          // part of playlist, remove
          bool removed = true;
          if (removed) {
            setState(() {
              childCount = childCount == null ? null : childCount! - 1;
              itemIsIncluded = false;
            });
          }
          return !removed;
        } else {
          // add to playlist
          bool added = true;
          if (added) {
            final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
            var newItems = await jellyfinApiHelper.getItems(
                parentItem: widget.playlist, fields: "");
            setState(() {
              childCount = newItems?.length ?? 0;
              itemIsIncluded = true;
            });
            return true; // this is called before the state is updated
          }
          return false;
        }
      },
      enabled: !isOffline,
    );
  }
}

class VolumeSlider extends ConsumerStatefulWidget {
  const VolumeSlider({
    super.key,
    required this.initialValue,
    required this.onChange,
    this.forceLoading = false,
    this.feedback = true,
  });

  final double initialValue;
  final bool forceLoading;
  final Future<void> Function(double currentValue) onChange;
  final bool feedback;

  @override
  ConsumerState<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends ConsumerState<VolumeSlider> {
  double currentValue = 0;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(VolumeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.forceLoading) {
      currentValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
      child: Container(
          decoration: ShapeDecoration(
            color: themeColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          child: Stack(children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: themeColor,
                inactiveTrackColor: themeColor.withOpacity(0.3),
                trackHeight: 40.0,
                trackShape: RoundedRectSliderTrackShape(),
                thumbColor: Colors.white,
                thumbShape: VerticalSliderThumbShape(
                  thumbWidth: 2.0,
                  thumbHeight: 24.0,
                  borderRadius: 8.0,
                  offsetLeft: -8.0,
                ),
                overlayColor: themeColor.withOpacity(0.2),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
              ),
              child: Slider(
                value: currentValue,
                onChanged: (value) {
                  setState(() {
                    currentValue = value;
                  });
                },
                onChangeEnd: (value) async {
                  unawaited(widget.onChange(value));
                  if (widget.feedback) {
                    FeedbackHelper.feedback(FeedbackType.selection);
                  }
                  setState(() {
                    currentValue = value;
                  });
                },
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "${(currentValue * 100).round()}%",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            )
          ])),
    );
  }
}

class VerticalSliderThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;
  final double borderRadius;
  final double offsetLeft;

  VerticalSliderThumbShape({
    this.thumbWidth = 4.0,
    this.thumbHeight = 40.0,
    this.borderRadius = 8.0,
    this.offsetLeft = 0.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final Rect thumbRect = Rect.fromCenter(
      center: center.translate(offsetLeft, 0),
      width: getPreferredSize(true, true).width,
      height: getPreferredSize(true, true).height,
    );

    final RRect thumbRRect = RRect.fromRectAndRadius(
      thumbRect,
      Radius.circular(borderRadius),
    );

    context.canvas.drawRRect(thumbRRect, paint);
  }
}
