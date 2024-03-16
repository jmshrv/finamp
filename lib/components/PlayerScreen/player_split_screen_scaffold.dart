import 'package:finamp/components/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:split_view/split_view.dart';

import '../../models/finamp_models.dart';
import '../../screens/player_screen.dart';
import '../../services/queue_service.dart';

bool _inSplitScreen = false;

bool get usingPlayerSplitScreen => _inSplitScreen;

SplitViewController _controller = SplitViewController(
    weights: [0.7], limits: [WeightLimit(min: 0.3, max: 0.8)]);

Widget buildPlayerSplitScreenScaffold(BuildContext context, Widget? widget) {
  return LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth < 900) {
      _inSplitScreen = false;
      return widget!;
    }
    final queueService = GetIt.instance<QueueService>();
    return StreamBuilder<FinampQueueInfo?>(
        stream: queueService.getQueueStream(),
        initialData: queueService.getQueue(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.saveState != SavedQueueState.loading &&
              snapshot.data!.saveState != SavedQueueState.failed &&
              snapshot.data!.currentTrack != null) {
            _inSplitScreen = true;
            var size = MediaQuery.sizeOf(context);
            return SplitView(
                viewMode: SplitViewMode.Horizontal,
                controller: _controller,
                children: [
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                            size: Size(
                                size.width * (_controller.weights[0] ?? 1.0),
                                size.height)),
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
                                      (1.0 - (_controller.weights[0] ?? 1.0)),
                                  size.height)),
                          child: child!);
                    },
                    child: HeroControllerScope(
                        controller: HeroController(),
                        child: Navigator(
                            pages: const [MaterialPage(child: PlayerScreen())],
                            onPopPage: (_, __) => false,
                            onGenerateRoute: (x) {
                              GlobalSnackbar
                                  .materialAppNavigatorKey.currentState!
                                  .pushNamed(x.name!, arguments: x.arguments);
                              return EmptyRoute();
                            })),
                  )
                ]);
          } else {
            _inSplitScreen = false;
            return widget!;
          }
        });
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
