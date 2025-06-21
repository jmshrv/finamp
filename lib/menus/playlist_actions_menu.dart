import 'package:collection/collection.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_list.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menu_item_info_header.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

const playlistActionsMenuRouteName = "/playlist-actions-menu";

Future<void> showPlaylistActionsMenu({
  required BuildContext context,
  required BaseItemDto item,
  BaseItemDto? parentPlaylist,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  FeedbackHelper.feedback(FeedbackType.selection);

  await showThemedBottomSheet(
    context: context,
    item: item,
    routeName: playlistActionsMenuRouteName,
    minDraggableHeight: 0.2,
    buildSlivers: (context) {
      var themeColor = Theme.of(context).colorScheme.primary;
      var playlistsFuture = jellyfinApiHelper.getItems(includeItemTypes: "Playlist", sortBy: "SortName");

      final menuEntries = [
        MenuItemInfoHeader.condensed(item: item),
        const SizedBox(height: 16),
        Consumer(
          builder: (context, ref, child) {
            bool isFavorite = ref.watch(isFavoriteProvider(item));
            return ToggleableListTile(
              title: AppLocalizations.of(context)!.favorites,
              leading: AspectRatio(
                aspectRatio: 1.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: themeColor.withOpacity(0.3)),
                  child: const Center(child: Icon(TablerIcons.heart, size: 36.0, color: Colors.white)),
                ),
              ),
              positiveIcon: TablerIcons.heart_filled,
              negativeIcon: TablerIcons.heart,
              initialState: isFavorite,
              tapFeedback: false,
              onToggle: (bool currentState) async {
                return ref.read(isFavoriteProvider(item).notifier).updateFavorite(!isFavorite);
              },
              enabled: !ref.watch(finampSettingsProvider.isOffline),
            );
          },
        ),
        FutureBuilder(
          future: playlistsFuture.then((value) => value?.firstWhereOrNull((x) => x.id == parentPlaylist?.id)),
          initialData: parentPlaylist,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return AddToPlaylistTile(playlist: snapshot.data!, track: item, playlistItemId: item.playlistItemId);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ];

      var menu = [
        SliverStickyHeader(
          header: const PlaylistActionsMenuHeader(),
          sliver: MenuMask(
            height: PlaylistActionsMenuHeader.defaultHeight,
            child: SliverList(delegate: SliverChildListDelegate(menuEntries)),
          ),
        ),
        SliverStickyHeader(
          header: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 16.0, right: 16.0),
            child: Text(
              AppLocalizations.of(context)!.addPlaylistSubheader,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          sliver: MenuMask(
            height: PlaylistActionsMenuHeader.defaultHeight,
            child: AddToPlaylistList(
              itemToAdd: item,
              playlistsFuture: playlistsFuture.then(
                (value) => (value?.where((element) => element.id != parentPlaylist?.id).toList() ?? []),
              ),
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100.0)),
      ];
      // TODO better estimate, how to deal with lag getting playlists?
      var stackHeight = MediaQuery.sizeOf(context).height * 0.9;
      return (stackHeight, menu);
    },
  );
}

class PlaylistActionsMenuHeader extends ConsumerWidget {
  const PlaylistActionsMenuHeader({super.key});
  static MenuMaskHeight defaultHeight = MenuMaskHeight(35.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.addRemoveFromPlaylist,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color!,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class ToggleableListTile extends ConsumerStatefulWidget {
  const ToggleableListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    required this.positiveIcon,
    required this.negativeIcon,
    required this.initialState,
    required this.onToggle,
    required this.enabled,
    this.forceLoading = false,
    this.tapFeedback = true,
  });

  final String title;
  final String? subtitle;
  final Widget leading;
  final IconData positiveIcon;
  final IconData negativeIcon;
  final bool initialState;
  final Future<bool> Function(bool currentState) onToggle;
  final bool enabled;
  final bool forceLoading;
  final bool tapFeedback;

  @override
  ConsumerState<ToggleableListTile> createState() => _ToggleableListTileState();
}

class _ToggleableListTileState extends ConsumerState<ToggleableListTile> {
  bool isLoading = false;
  bool currentState = false;

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
  }

  @override
  void didUpdateWidget(ToggleableListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.forceLoading) {
      currentState = widget.initialState;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
      child: Container(
        decoration: ShapeDecoration(
          color: themeColor.withOpacity(currentState ? 0.3 : 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.zero,
        child: ListTile(
          enableFeedback: true,
          enabled: widget.enabled,
          leading: widget.leading,
          title: Text(widget.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (widget.subtitle != null) Text(widget.subtitle!, style: Theme.of(context).textTheme.bodySmall),
              SizedBox(
                height: 48.0,
                width: 16.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: VerticalDivider(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                    thickness: 1.5,
                    indent: 8.0,
                    endIndent: 8.0,
                    width: 1.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                child: isLoading || widget.forceLoading
                    ? const CircularProgressIndicator()
                    : Icon(
                        currentState == true ? widget.positiveIcon : widget.negativeIcon,
                        size: 36.0,
                        color: themeColor,
                      ),
              ),
            ],
          ),
          onTap: widget.forceLoading || isLoading
              ? null
              : () async {
                  FeedbackHelper.feedback(FeedbackType.selection);
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    final result = await widget.onToggle(currentState);
                    if (widget.tapFeedback) {
                      FeedbackHelper.feedback(FeedbackType.heavy);
                    }
                    setState(() {
                      isLoading = false;
                      currentState = result;
                    });
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    GlobalSnackbar.error(e);
                  }
                },
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          // visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
        ),
      ),
    );
  }
}
