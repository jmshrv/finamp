import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:finamp/color_schemes.g.dart';
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
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
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
          Consumer(
            builder: (context, ref, child) {
            return VolumeSlider(
              initialValue:
                  ((ref.watch(finampSettingsProvider).value?.currentVolume ??
                                  1.0) *
                              100)
                          .floor() /
                      100.0,
              onChange: (double currentValue) async {
                FinampSettingsHelper.setCurrentVolume(currentValue);
                outputPanelLogger.fine("Volume set to $currentValue");
              },
              forceLoading: true,
              );
            }
          ),
          const SizedBox(height: 10),
        ];

        var menu = [
          SliverStickyHeader(
              header: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      // just for justifying the remaining contents of the row
                      width: 38,
                    ),
                    Center(
                      child: Text(AppLocalizations.of(context)!.outputMenuTitle,
                          // AppLocalizations.of(context)!.outputMenuTitle,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                    if (Platform.isIOS)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          switchOutCurve: const Threshold(0.0),
                          child: Consumer(builder: (context, ref, child) {
                            return AirPlayRoutePickerView(
                              key: ValueKey(
                                  ref.watch(localThemeProvider).primary),
                              tintColor: ref.watch(localThemeProvider).primary,
                              activeTintColor: jellyfinBlueColor,
                              onShowPickerView: () => FeedbackHelper.feedback(
                                  FeedbackType.selection),
                            );
                          }),
                        ),
                      ),
                    if (Platform.isAndroid)
                      IconButton(
                        icon: Icon(TablerIcons.cast),
                        onPressed: () {
                          final audioHandler =
                              GetIt.instance<MusicPlayerBackgroundTask>();
                          audioHandler.getRoutes();
                          // audioHandler.setOutputToDeviceSpeaker();
                          // audioHandler.setOutputToBluetoothDevice();
                          audioHandler.showOutputSwitcherDialog();
                        },
                      ),
                  ],
                ),
              ),
              sliver: SliverToBoxAdapter(
                child: SizedBox.shrink(),
              )),
          SliverStickyHeader(
            header: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: Text(
                  AppLocalizations.of(context)!.outputMenuVolumeSectionTitle,
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
              child: Text(
                  AppLocalizations.of(context)!.outputMenuDevicesSectionTitle,
                  // AppLocalizations.of(context)!.outputMenuDevicesSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            sliver: MenuMask(
              height: 35.0,
              child: OutputTargetList(), // Pass the outputRoutes
            ),
          ),
        ];
        // TODO better estimate, how to deal with lag getting playlists?
        var stackHeight = MediaQuery.sizeOf(context).height * 0.65;
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
            text: AppLocalizations.of(context)!
                .outputMenuOpenConnectionSettingsButtonTitle,
            icon: TablerIcons.cast,
            //accentColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
              // await audioHandler.showOutputSwitcherDialog();
              await audioHandler.openBluetoothSettings();
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
      subtitle: (routeInfo.isDeviceSpeaker
          ? AppLocalizations.of(context)!.deviceType("speaker")
          : switch (routeInfo.deviceType) {
              1 => AppLocalizations.of(context)!.deviceType("tv"),
              3 => AppLocalizations.of(context)!.deviceType("bluetooth"),
              _ => AppLocalizations.of(context)!.deviceType("unknown"),
            }),
      // subtitle: AppLocalizations.of(context)!.songCount(childCount ?? 0),
      leading: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        child: Icon(switch (routeInfo.deviceType) {
          1 => TablerIcons.device_tv,
          3 => TablerIcons.bluetooth,
          _ => TablerIcons.volume,
        }),
      ),
      positiveIcon: TablerIcons.device_speaker_filled,
      negativeIcon: TablerIcons.device_speaker,
      initialState: routeInfo.isSelected,
      onToggle: (bool currentState) async {
        final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
        await audioHandler.setOutputToRoute(routeInfo);
        unawaited(Future.delayed(const Duration(milliseconds: 1250)).then((_) {
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
  Timer? debounce;

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
    double sliderHeight = 56.0;
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
            SizedBox(
                height: sliderHeight,
                width: double.infinity,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: sliderHeight, // Same as container height
                    padding: EdgeInsets.zero,

                    trackShape: RoundedRectangleTrackShape(),
                    thumbShape: VerticalSliderThumbShape(
                      thumbWidth: 2.0,
                      thumbHeight: 24.0,
                      borderRadius: 8.0,
                      offsetLeft: -8.0,
                    ),
                    thumbColor: Colors.white,
                    activeTrackColor: themeColor,
                    inactiveTrackColor: themeColor.withOpacity(0.3),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
              child: Slider(
                value: currentValue,
                onChanged: (value) {
                  setState(() {
                        currentValue = value;
                  });
                      if (debounce?.isActive ?? false) debounce!.cancel();
                      debounce = Timer(const Duration(milliseconds: 100), () {
                        widget.onChange(value);
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
                )),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "${(currentValue * 100).floor()}%",
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

class RoundedRectangleTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Active track
    final activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx +
          sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width,
      trackRect.bottom,
    );

    // Inactive track
    final inactiveRect = Rect.fromLTRB(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    final Paint activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    final radius = Radius.circular(12.0);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        trackRect,
        radius,
      ),
      inactivePaint,
    );

    final activeRRect = RRect.fromRectAndRadius(activeRect, radius);

    canvas.drawRRect(
      activeRRect,
      activePaint,
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
    return Size(thumbWidth - offsetLeft * 3, thumbHeight);
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
      center: center.translate(-offsetLeft * 2, 0),
      width: getPreferredSize(true, true).width + offsetLeft * 3,
      height: getPreferredSize(true, true).height,
    );

    final RRect thumbRRect = RRect.fromRectAndRadius(
      thumbRect,
      Radius.circular(borderRadius),
    );

    context.canvas.drawRRect(thumbRRect, paint);
  }
}
