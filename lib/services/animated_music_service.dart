import 'dart:async';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class AnimatedMusicService {
  final _logger = Logger("AnimatedMusicService");
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  // Cache to avoid repeated requests for failed tracks
  final Map<String, bool> _trackHasAnimatedCover = {};
  final Map<String, String> _animatedCoverUrlCache = {};

  /// Get animated cover URL for a track
  /// Returns null if no user is logged in
  Future<String?> getAnimatedCoverForTrack(BaseItemId trackId) async {
    final trackIdStr = trackId.raw;

    // Check if we've already determined this track has no animated cover
    if (_trackHasAnimatedCover[trackIdStr] == false) {
      return null;
    }

    // Return cached result if available
    if (_animatedCoverUrlCache.containsKey(trackIdStr)) {
      return _animatedCoverUrlCache[trackIdStr];
    }

    // Build URL
    final url = _buildAnimatedCoverUrlForTrack(trackId);
    if (url != null) {
      _logger.fine("Built animated cover URL for track $trackIdStr: $url");
      _trackHasAnimatedCover[trackIdStr] = true;
      _animatedCoverUrlCache[trackIdStr] = url;
      return url;
    }

    _logger.fine("Could not build animated cover URL for track $trackIdStr");
    _trackHasAnimatedCover[trackIdStr] = false;
    return null;
  }

  /// Get vertical background URL for a track
  /// Returns null if no user is logged in
  Future<String?> getVerticalBackgroundForTrack(BaseItemId trackId) async {
    final trackIdStr = trackId.raw;

    // Build URL
    final url = _buildVerticalBackgroundUrlForTrack(trackId);
    if (url != null) {
      _logger.fine("Built vertical background URL for track $trackIdStr: $url");
      return url;
    }

    _logger.fine("Could not build vertical background URL for track $trackIdStr");
    return null;
  }

  /// Check if a track has an animated cover (cached result)
  bool hasAnimatedCoverForTrack(BaseItemId trackId) {
    return _trackHasAnimatedCover[trackId.raw] == true;
  }

  /// Reset all caches (call when switching users/servers)
  void resetCache() {
    _trackHasAnimatedCover.clear();
    _animatedCoverUrlCache.clear();
  }

  /// Clear cache for a specific track
  void clearTrackCache(BaseItemId trackId) {
    final trackIdStr = trackId.raw;
    _trackHasAnimatedCover.remove(trackIdStr);
    _animatedCoverUrlCache.remove(trackIdStr);
  }

  /// Build animated cover URL for a track
  String? _buildAnimatedCoverUrlForTrack(BaseItemId trackId) {
    final currentUser = _finampUserHelper.currentUser;
    if (currentUser == null) {
      return null;
    }

    final parsedBaseUrl = Uri.parse(currentUser.baseURL);
    List<String> builtPath = List<String>.from(parsedBaseUrl.pathSegments);
    builtPath.addAll(["AnimatedMusic", "Track", trackId.raw, "AnimatedCover"]);

    return Uri(
      host: parsedBaseUrl.host,
      port: parsedBaseUrl.port,
      scheme: parsedBaseUrl.scheme,
      userInfo: parsedBaseUrl.userInfo,
      pathSegments: builtPath,
    ).toString();
  }

  /// Build vertical background URL for a track
  String? _buildVerticalBackgroundUrlForTrack(BaseItemId trackId) {
    final currentUser = _finampUserHelper.currentUser;
    if (currentUser == null) {
      return null;
    }

    final parsedBaseUrl = Uri.parse(currentUser.baseURL);
    List<String> builtPath = List<String>.from(parsedBaseUrl.pathSegments);
    builtPath.addAll(["AnimatedMusic", "Track", trackId.raw, "VerticalBackground"]);

    return Uri(
      host: parsedBaseUrl.host,
      port: parsedBaseUrl.port,
      scheme: parsedBaseUrl.scheme,
      userInfo: parsedBaseUrl.userInfo,
      pathSegments: builtPath,
    ).toString();
  }
}
