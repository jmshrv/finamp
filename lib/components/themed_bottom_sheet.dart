import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:finamp/components/padded_custom_scrollview.dart';
import 'package:finamp/screens/blurred_player_screen_background.dart';
import 'package:finamp/services/current_album_image_provider.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../models/jellyfin_models.dart';
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
  double minDraggableHeight = 0.6,
  bool showDragHandle = true,
}) async {
  FeedbackHelper.feedback(FeedbackType.impact);
  var usePlayerTheme =
      ProviderScope.containerOf(context).read(isPlayerThemedProvider);
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
    this.buildSlivers,
    this.buildWrapper,
    required this.minDraggableHeight,
    required this.showDragHandle,
  });

  final BaseItemDto item;
  final bool usePlayerTheme;
  final SliverBuilder? buildSlivers;
  final WrapperBuilder? buildWrapper;
  final double minDraggableHeight;
  final bool showDragHandle;

  @override
  ConsumerState<ThemedBottomSheet> createState() => _ThemedBottomSheetState();
}

class _ThemedBottomSheetState extends ConsumerState<ThemedBottomSheet> {
  final ScrollController _controller = ScrollController();

  late (ImageProvider?, String?, bool) _playerImage;
  final dragController = DraggableScrollableController();

  @override
  void initState() {
    if (widget.usePlayerTheme) {
      _playerImage = ref.read(currentAlbumImageProvider);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Exactly one builder must be supplied.
    assert(widget.buildSlivers == null || widget.buildWrapper == null);
    assert(widget.buildSlivers != null || widget.buildWrapper != null);
    return ProviderScope(
        overrides: [
          if (widget.usePlayerTheme)
            localImageProvider.overrideWithValue(_playerImage),
          if (widget.usePlayerTheme)
            isPlayerThemedProvider.overrideWithValue(true),
          if (!widget.usePlayerTheme)
            localThemeRequestProvider
                .overrideWithValue(ThemeRequest(widget.item, useIsolate: false))
        ],
        child: Consumer(builder: (_, ref, __) {
          return Theme(
              data: ThemeData(colorScheme: ref.watch(localThemeProvider)),
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
        }));
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
}

class MenuMask extends SingleChildRenderObjectWidget {
  const MenuMask({
    super.key,
    super.child,
    required this.height,
  });

  final double height;

  @override
  RenderTrackMenuMask createRenderObject(BuildContext context) {
    return RenderTrackMenuMask(height);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderTrackMenuMask renderObject) {
    renderObject.updateHeight(height);
    super.updateRenderObject(context, renderObject);
  }
}

class RenderTrackMenuMask extends RenderProxySliver {
  RenderTrackMenuMask(this.height);

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
