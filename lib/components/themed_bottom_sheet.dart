import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:finamp/components/padded_custom_scrollview.dart';
import 'package:finamp/screens/blurred_player_screen_background.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../models/jellyfin_models.dart';
import '../services/album_image_provider.dart';
import '../services/feedback_helper.dart';
import '../services/finamp_settings_helper.dart';

typedef SliverBuilder = (double, List<Widget>) Function(BuildContext);
typedef WrapperBuilder = Widget Function(
    BuildContext, DraggableScrollableController, ScrollBuilder);
typedef ScrollBuilder = Widget Function(double, List<Widget>);

Future<void> showThemedBottomSheet({
  required BuildContext context,
  required BaseItemDto item,
  required String routeName,
  SliverBuilder? buildSlivers,
  WrapperBuilder? buildWrapper,
  bool usePlayerTheme = false,
  required FinampTheme? themeProvider,
  double minDraggableHeight = 0.6,
  bool showDragHandle = true,
}) async {
  if (usePlayerTheme) {
    // Theme will be calculated later
  } else if (themeProvider == null) {
    if (item.blurHash != null) {
      themeProvider = FinampTheme.fromImage(BlurHashImage(item.blurHash!),
          item.blurHash, Theme.of(context).brightness,
          useIsolate: false);
    }
  } else {
    // If calling widget failed to precalculate theme and we have a cached image,
    // calculate in foreground.  This causes a lag spike but is far quicker.
    // This will be a no-op if the theme is already calculated
    unawaited(themeProvider.calculate(Theme.of(context).brightness,
        useIsolate: false));
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
          themeProvider: themeProvider,
          buildSlivers: buildSlivers,
          buildWrapper: buildWrapper,
          minDraggableHeight: minDraggableHeight,
          showDragHandle: showDragHandle,
        );
      });
}

class ThemedBottomSheet extends ConsumerStatefulWidget {
  const ThemedBottomSheet({
    super.key,
    required this.item,
    required this.usePlayerTheme,
    required this.themeProvider,
    this.buildSlivers,
    this.buildWrapper,
    required this.minDraggableHeight,
    required this.showDragHandle,
  });

  final BaseItemDto item;
  final bool usePlayerTheme;
  final FinampTheme? themeProvider;
  final SliverBuilder? buildSlivers;
  final WrapperBuilder? buildWrapper;
  final double minDraggableHeight;
  final bool showDragHandle;

  @override
  ConsumerState<ThemedBottomSheet> createState() => _ThemedBottomSheetState();
}

class _ThemedBottomSheetState extends ConsumerState<ThemedBottomSheet> {
  final ScrollController _controller = ScrollController();

  late FinampTheme? _themeProvider;
  final dragController = DraggableScrollableController();

  @override
  void initState() {
    if (widget.usePlayerTheme) {
      // We do not want to update theme/image on track changes.
      _themeProvider =
          ref.read(playerScreenThemeDataProvider) ?? FinampTheme.defaultTheme();
    } else {
      _themeProvider = widget.themeProvider;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Exactly one builder must be supplied.
    assert(widget.buildSlivers == null || widget.buildWrapper == null);
    assert(widget.buildSlivers != null || widget.buildWrapper != null);
    var brightness = ref.watch(brightnessProvider);
    if (_themeProvider == null) {
      var image = ref.read(albumImageProvider(AlbumImageRequest(
        item: widget.item,
        maxWidth: 100,
        maxHeight: 100,
      )));
      if (image != null) {
        _themeProvider = FinampTheme.fromImage(
            image, widget.item.blurHash, brightness,
            useIsolate: false);
      } else {
        _themeProvider = FinampTheme.defaultTheme();
      }
    }
    return ProviderScope(
      overrides: [
        themeDataProvider.overrideWith((provider) => _themeProvider!)
      ],
      child: FutureBuilder(
          // Calculate only runs once,
          future: _themeProvider!.calculate(brightness, useIsolate: false),
          initialData: _themeProvider!.colorScheme(brightness),
          builder: (context, snapshot) {
            return Theme(
                data: ThemeData(
                    colorScheme: snapshot.data ?? getGreyTheme(brightness)),
                child: Builder(
                  builder: (BuildContext context) {
                    if (widget.buildWrapper != null) {
                      return widget.buildWrapper!(context, dragController,
                          (height, slivers) => buildInternal(height, slivers));
                    } else {
                      var (height, slivers) = widget.buildSlivers!(context);
                      return buildInternal(height, slivers);
                    }
                  },
                ));
          }),
    );
  }

  Widget buildInternal(double stackHeight, List<Widget> slivers) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isIOS || Platform.isAndroid) {
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
      } else {
        var minSize = widget.minDraggableHeight * constraints.maxHeight;
        return SizedBox(
          // This is an overestimate of stack height on desktop, but this widget
          // needs some bottom padding on large displays anyway.
          height: max(minSize, stackHeight),
          child: menu(_controller, slivers),
        );
      }
    });
  }

  Widget menu(ScrollController scrollController, List<Widget> slivers) {
    var scrollview = PaddedCustomScrollview(
      controller: scrollController,
      slivers: slivers,
    );
    return Stack(
      children: [
        if (FinampSettingsHelper.finampSettings.useCoverAsBackground)
          const BlurredPlayerScreenBackground(),
        widget.showDragHandle
            ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10.0),
                      child: Builder(builder: (context) {
                        var textColor =
                            Theme.of(context).textTheme.bodySmall!.color!;
                        return Container(
                          width: 40,
                          height: 3.5,
                          decoration: BoxDecoration(
                            color: textColor,
                            borderRadius: BorderRadius.circular(3.5),
                          ),
                        );
                      })),
                  Expanded(child: scrollview)
                ],
              )
            : scrollview,
      ],
    );
  }

  @override
  void dispose() {
    widget.themeProvider?.dispose();
    super.dispose();
  }
}

class MenuMask extends SingleChildRenderObjectWidget {
  const MenuMask({
    super.key,
    super.child,
    required this.height,
  });

  final double height;

  @override
  RenderSongMenuMask createRenderObject(BuildContext context) {
    return RenderSongMenuMask(height);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSongMenuMask renderObject) {
    renderObject.updateHeight(height);
    super.updateRenderObject(context, renderObject);
  }
}

class RenderSongMenuMask extends RenderProxySliver {
  RenderSongMenuMask(this.height);

  double height;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  void updateHeight(double newHeight) {
    if (height != newHeight) {
      height = newHeight;
      layer = null;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      layer ??= ShaderMaskLayer(
          shader: const LinearGradient(colors: [
            Color.fromARGB(0, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              .createShader(Rect.fromLTWH(0, height, 0, 10)),
          blendMode: BlendMode.modulate,
          maskRect: Rect.fromLTWH(0, 0, 99999, height + 15));

      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }
}
