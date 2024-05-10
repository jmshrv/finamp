import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:finamp/screens/blurred_player_screen_background.dart';
import 'package:finamp/services/album_image_provider.dart';
import 'package:finamp/services/current_album_image_provider.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../models/jellyfin_models.dart';
import '../services/feedback_helper.dart';
import '../services/finamp_settings_helper.dart';

typedef SliverBuilder = (int, List<Widget>) Function(BuildContext);
typedef WrapperBuilder = Widget Function(
    BuildContext, ImageProvider, ScrollBuilder);
typedef ScrollBuilder = Widget Function(int, List<Widget>);

Future<void> showThemedBottomSheet({
  required BuildContext context,
  required BaseItemDto item,
  required String routeName,
  SliverBuilder? buildSlivers,
  WrapperBuilder? buildWrapper,
  bool usePlayerTheme = false,
  ImageProvider? cachedImage,
  ThemeProvider? themeProvider,
  double minDraggableHeight = 0.4,
}) async {
  if (themeProvider == null && !usePlayerTheme) {
    if (cachedImage != null) {
      // If calling widget failed to precalculate theme and we have a cached image,
      // calculate in foreground.  This causes a lag spike but is far quicker.
      themeProvider = ThemeProvider(cachedImage, Theme.of(context).brightness,
          useIsolate: false);
    } else if (item.blurHash != null) {
      themeProvider = ThemeProvider(
          BlurHashImage(item.blurHash!), Theme.of(context).brightness,
          useIsolate: false);
    }
  }

  FeedbackHelper.feedback(FeedbackType.impact);

  await showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth: (Platform.isIOS || Platform.isAndroid)
              ? 500
              : min(500, MediaQuery.sizeOf(context).width * 0.9)),
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      routeSettings: RouteSettings(name: routeName),
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: (Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black)
          .withOpacity(0.9),
      builder: (BuildContext context) {
        return ThemedBottomSheet(
          key: ValueKey(item.id + routeName),
          item: item,
          usePlayerTheme: usePlayerTheme,
          cachedImage: cachedImage,
          themeProvider: themeProvider,
          brightness: Theme.of(context).brightness,
          buildSlivers: buildSlivers,
          buildWrapper: buildWrapper,
          minDraggableHeight: minDraggableHeight,
        );
      });
}

class ThemedBottomSheet extends ConsumerStatefulWidget {
  const ThemedBottomSheet({
    super.key,
    required this.item,
    required this.usePlayerTheme,
    this.cachedImage,
    this.themeProvider,
    required this.brightness,
    this.buildSlivers,
    this.buildWrapper,
    required this.minDraggableHeight,
  });

  final BaseItemDto item;
  final bool usePlayerTheme;
  final ImageProvider? cachedImage;
  final ThemeProvider? themeProvider;
  final Brightness brightness;
  final SliverBuilder? buildSlivers;
  final WrapperBuilder? buildWrapper;
  final double minDraggableHeight;

  @override
  ConsumerState<ThemedBottomSheet> createState() => _ThemedBottomSheetState();
}

class _ThemedBottomSheetState extends ConsumerState<ThemedBottomSheet> {
  final ScrollController _controller = ScrollController();

  ColorScheme? _imageTheme;
  ImageProvider? _imageProvider;
  final dragController = DraggableScrollableController();
  double inputStep = 0.9;

  @override
  void initState() {
    if (widget.usePlayerTheme) {
      // We do not want to update theme/image on track changes.
      _imageTheme = ref.read(playerScreenThemeProvider(widget.brightness));
      _imageProvider = ref.read(currentAlbumImageProvider);
    } else {
      _imageTheme = widget.themeProvider?.colorScheme;
      if (_imageTheme == null) {
        _imageTheme = getGreyTheme(widget.brightness);
        // Rebuild widget if/when theme calculation completes
        widget.themeProvider?.colorSchemeFuture.then((value) => setState(() {
              _imageTheme = value;
            }));
      }
      _imageProvider = widget.cachedImage ??
          ref.read(albumImageProvider(AlbumImageRequest(
            item: widget.item,
            maxWidth: 100,
            maxHeight: 100,
          )));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Exactly one builder must be supplied.
    assert(widget.buildSlivers == null || widget.buildWrapper == null);
    assert(widget.buildSlivers != null || widget.buildWrapper != null);
    return Theme(
        data: ThemeData(colorScheme: _imageTheme),
        child: Builder(
          builder: (BuildContext context) {
            if (widget.buildWrapper != null) {
              return widget.buildWrapper!(context, _imageProvider!,
                  (height, slivers) => buildInternal(height, slivers));
            } else {
              var (height, slivers) = widget.buildSlivers!(context);
              return buildInternal(height, slivers);
            }
          },
        ));
  }

  Widget buildInternal(int stackHeight, List<Widget> slivers) {
    if (Platform.isIOS || Platform.isAndroid) {
      return LayoutBuilder(builder: (context, constraints) {
        var size = (stackHeight / constraints.maxHeight)
            .clamp(widget.minDraggableHeight, 1.0);
        return DraggableScrollableSheet(
          controller: dragController,
          snap: true,
          initialChildSize: size,
          minChildSize: size * 0.75,
          expand: false,
          builder: (context, scrollController) =>
              menu(scrollController, slivers),
        );
      });
    } else {
      return SizedBox(
        // This is an overestimate of stack height on desktop, but this widget
        // needs some bottom padding on large displays anyway.
        height: stackHeight.toDouble(),
        child: menu(_controller, slivers),
      );
    }
  }

  Widget menu(ScrollController scrollController, List<Widget> slivers) {
    return Stack(
      children: [
        if (FinampSettingsHelper.finampSettings.useCoverAsBackground)
          BlurredPlayerScreenBackground(
              customImageProvider: _imageProvider,
              blurHash: widget.item.blurHash,
              opacityFactor: widget.brightness == Brightness.dark ? 1.0 : 1.0),
        CustomScrollView(
          controller: scrollController,
          slivers: slivers,
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.themeProvider?.dispose();
    super.dispose();
  }
}
