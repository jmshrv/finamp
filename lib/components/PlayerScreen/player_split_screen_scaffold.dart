import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:split_view/split_view.dart';

import '../../models/finamp_models.dart';
import '../../screens/player_screen.dart';
import '../../services/queue_service.dart';

bool _inSplitScreen = false;

bool get usingPlayerSplitScreen => _inSplitScreen;

double _weight = 0.0;

SplitViewController _controller =
    SplitViewController(limits: [WeightLimit(min: 0.3, max: 0.8)]);

Widget buildPlayerSplitScreenScaffold(BuildContext context, Widget? widget) {
  return LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth < 900) {
      _inSplitScreen = false;
      return widget!;
    }
    final queueService = GetIt.instance<QueueService>();

    return Consumer(
      builder: (context, ref, child) {
        bool allowSplitScreen = ref.watch(FinampSettingsHelper
                .finampSettingsProvider
                .select((value) => value.value?.allowSplitScreen)) ??
            true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          GlobalSnackbar.materialAppNavigatorKey.currentState?.popUntil(
              (x) => !ModalRoute.withName(PlayerScreen.routeName)(x));
        });

        return StreamBuilder<FinampQueueInfo?>(
            stream: queueService.getQueueStream(),
            initialData: queueService.getQueue(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.saveState != SavedQueueState.loading &&
                  snapshot.data!.saveState != SavedQueueState.failed &&
                  snapshot.data!.currentTrack != null &&
                  allowSplitScreen) {
                _inSplitScreen = true;
                var size = MediaQuery.sizeOf(context);
                var padding = MediaQuery.paddingOf(context);
                // When resizing window, update weights to keep player width consistent
                _weight = (1.0 -
                        FinampSettingsHelper
                                .finampSettings.splitScreenPlayerWidth /
                            constraints.maxWidth)
                    .clamp(0.3, 0.8);
                _controller.weights = [_weight];
                return SplitView(
                    resizingAreaSize: 20,
                    gripSize: 0,
                    viewMode: SplitViewMode.Horizontal,
                    controller: _controller,
                    onWeightChanged: (weights) {
                      if (weights[0]! == _weight) {
                        // Weight is changing due to window resize, not drag action.
                        // Do not update setting.
                        return;
                      }
                      var box = Hive.box<FinampSettings>("FinampSettings");
                      FinampSettings finampSettingsTemp =
                          box.get("FinampSettings")!;
                      finampSettingsTemp.splitScreenPlayerWidth =
                          (1.0 - weights[0]!) * constraints.maxWidth;
                      box.put("FinampSettings", finampSettingsTemp);
                    },
                    children: [
                      ListenableBuilder(
                        listenable: _controller,
                        builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                                size: Size(
                                    size.width *
                                        (_controller.weights[0] ?? 1.0),
                                    size.height),
                                padding: padding.copyWith(
                                    right: padding.right + 10)),
                            child: child!),
                        child: widget,
                      ),
                      ListenableBuilder(
                        listenable: _controller,
                        builder: (context, child) {
                          return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  size: Size(
                                      size.width *
                                          (1.0 -
                                              (_controller.weights[0] ?? 1.0)),
                                      size.height)),
                              child: child!);
                        },
                        child: HeroControllerScope(
                            controller: HeroController(),
                            child: ScaffoldMessenger(
                              child: Navigator(
                                  pages: const [
                                    MaterialPage(child: PlayerScreen())
                                  ],
                                  onPopPage: (_, __) => false,
                                  onGenerateRoute: (x) {
                                    GlobalSnackbar
                                        .materialAppNavigatorKey.currentState!
                                        .pushNamed(x.name!,
                                            arguments: x.arguments);
                                    return EmptyRoute();
                                  }),
                            )),
                      )
                    ]);
              } else {
                _inSplitScreen = false;
                return widget!;
              }
            });
      },
    );
  });
}

class EmptyRoute extends Route {
  @override
  List<OverlayEntry> get overlayEntries =>
      [OverlayEntry(builder: (_) => SizedBox.shrink())];
  @override
  void didAdd() {
    super.didAdd();
    navigator?.pop();
  }
}
