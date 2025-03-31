import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_list.dart';
import 'package:finamp/components/AddToPlaylistScreen/playlist_actions_menu.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
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
        ];

        var menu = [
          SliverStickyHeader(
              header: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
                child: Center(
                  child: Text("TODO",
                      // AppLocalizations.of(context)!.outputMenuTitle,
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
              child: Text("TODO",
                  // AppLocalizations.of(context)!.outputMenuVolumeSectionTitle,
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
              child: Text("TODO",
                  // AppLocalizations.of(context)!.outputMenuDevicesSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            sliver: MenuMask(
              height: 35.0,
              child: OutputTargetList(), // Pass the outputRoutes
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100.0))
        ];
        // TODO better estimate, how to deal with lag getting playlists?
        var stackHeight = MediaQuery.sizeOf(context).height * 0.9;
        return (stackHeight, menu);
      });
}

class OutputTargetList extends StatefulWidget {
  const OutputTargetList({
    super.key,
  });

  @override
  State<OutputTargetList> createState() => _OutputTargetListState();
}

class _OutputTargetListState extends State<OutputTargetList> {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  @override
  Widget build(BuildContext context) {
    Future<List<FinampOutputRoute>> outputRoutes = audioHandler.getRoutes();
    return FutureBuilder(
      future: outputRoutes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == snapshot.data!.length) {
                return openOsOutputOptionsButton(context);
              }
              final route = snapshot.data![index];
              return OutputSelectorTile(
                  routeInfo: route,
                  onSelect: () {
                    print("refreshing2");
                    setState(() {});
                  });
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
              if (dialogResult != null) {}
            },
          ),
        ],
      ),
    );
  }
}

class OutputSelectorTile extends StatelessWidget {
  const OutputSelectorTile(
      {super.key,
      required this.routeInfo,
      this.isLoading = false,
      this.onSelect});

  final FinampOutputRoute routeInfo;
  final bool isLoading;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return ToggleableListTile(
      forceLoading: isLoading,
      title: routeInfo.name ?? AppLocalizations.of(context)!.unknownName,
      subtitle: "TODO",
      // subtitle: AppLocalizations.of(context)!.songCount(childCount ?? 0),
      leading: Icon(TablerIcons.device_speaker),
      positiveIcon: TablerIcons.circle_check_filled,
      negativeIcon: TablerIcons.circle_plus,
      initialState: routeInfo.isSelected,
      onToggle: (bool currentState) async {
        final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
        await audioHandler.setOutputToRoute(routeInfo);
        unawaited(Future.delayed(const Duration(milliseconds: 1250)).then((_) {
          print("refreshing");
          onSelect?.call();
        }));
        return true;
      },
      enabled: true,
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
                        color: Colors.white,
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
