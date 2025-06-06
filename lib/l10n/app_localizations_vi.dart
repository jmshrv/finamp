// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Trình phát nhạc Jellyfin mã nguồn mở';

  @override
  String get startupErrorTitle =>
      'Something went wrong during app startup!\nSorry about that...';

  @override
  String get startupErrorCallToAction =>
      'Please create an issue on github.com/jmshrv/finamp with the logs(!) (use the button below) and a screenshot of this page, so that we can fix it as quickly as possible.';

  @override
  String get startupErrorWorkaround =>
      'As a workaround you could clear your app data to reset the app. Keep in mind that in this case all your settings and downloads will be deleted.';

  @override
  String get about => 'Giới thiệu về Finamp';

  @override
  String get aboutContributionPrompt =>
      'Được thực hiện bởi những người tuyệt vời trong thời gian rảnh rỗi của họ.\nBạn có thể trở thành một trong số họ!';

  @override
  String get aboutContributionLink => 'Đóng góp cho Finamp trên GitHub:';

  @override
  String get aboutReleaseNotes => 'Đọc ghi chú phát hành mới nhất:';

  @override
  String get aboutTranslations => 'Giúp dịch Finamp sang ngôn ngữ của bạn:';

  @override
  String get aboutThanks => 'Cảm ơn bạn đã sử dụng Finamp!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Chào mừng tới';
  }

  @override
  String get loginFlowSlogan => 'Âm nhạc của bạn, theo cách bạn muốn.';

  @override
  String get loginFlowGetStarted => 'Bắt đầu!';

  @override
  String get viewLogs => 'Xem nhật ký';

  @override
  String get changeLanguage => 'Thay đổi ngôn ngữ';

  @override
  String get loginFlowServerSelectionHeading => 'Kết nối với Jellyfin';

  @override
  String get back => 'Quay lại';

  @override
  String get serverUrl => 'URL của Máy chủ';

  @override
  String get internalExternalIpExplanation =>
      'Nếu bạn muốn có thể truy cập máy chủ Jellyfin của mình từ xa, bạn cần sử dụng IP bên ngoài của mình.\n\nNếu máy chủ của bạn sử dụng cổng HTTP (cổng mặc định 80/443 (80 hoặc 443) hoặc cổng mặc định của Jellyfin (8096), thì bạn không cần phải chỉ định cổng đó. Điều này có thể xảy ra nếu máy chủ của bạn sử dụng proxy ngược\n\nNếu URL chính xác, bạn sẽ thấy một số thông tin về máy chủ của mình bật lên bên dưới trường nhập.';

  @override
  String get serverUrlHint => 'VD: demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Trợ giúp URL máy chủ';

  @override
  String get emptyServerUrl => 'URL của máy chủ không thể để trống';

  @override
  String get connectingToServer => 'Đang kết nối đến máy chủ...';

  @override
  String get loginFlowLocalNetworkServers =>
      'Máy chủ trên mạng cục bộ của bạn:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Đang quét máy chủ...';

  @override
  String get loginFlowAccountSelectionHeading => 'Chọn tài khoản của bạn';

  @override
  String get backToServerSelection => 'Quay lại Lựa chọn máy chủ';

  @override
  String get loginFlowNamelessUser => 'Người dùng chưa đặt tên';

  @override
  String get loginFlowCustomUser => 'Người dùng tuỳ chỉnh';

  @override
  String get loginFlowAuthenticationHeading =>
      'Đăng nhập vào tài khoản của bạn';

  @override
  String get backToAccountSelection => 'Quay lại Lựa chọn tài khoản';

  @override
  String get loginFlowQuickConnectPrompt => 'Sử dụng mã Kết nối nhanh';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Mở ứng dụng hoặc trang web Jellyfin, nhấp vào biểu tượng người dùng của bạn và chọn Kết nối nhanh.';

  @override
  String get loginFlowQuickConnectDisabled =>
      'Kết nối nhanh bị tắt trên máy chủ này.';

  @override
  String get orDivider => 'hoặc';

  @override
  String get loginFlowSelectAUser => 'Chọn người dùng';

  @override
  String get username => 'Tên người dùng';

  @override
  String get usernameHint => 'Nhập tên tài khoản';

  @override
  String get usernameValidationMissingUsername => 'Hãy nhập tên tài khoản';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordHint => 'Nhập mật khẩu';

  @override
  String get login => 'Đăng Nhập';

  @override
  String get logs => 'Nhật kí hoạt động';

  @override
  String get next => 'Tiếp theo';

  @override
  String get selectMusicLibraries => 'Chọn Thư viện Nhạc';

  @override
  String get couldNotFindLibraries => 'Không thể tìm thấy bất kì thư viện nào.';

  @override
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Không có tên';

  @override
  String get tracks => 'Bản nhạc';

  @override
  String get albums => 'Albums';

  @override
  String get appearsOnAlbums => 'Appears On';

  @override
  String get artists => 'Nghệ sĩ';

  @override
  String get genres => 'Thể loại';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Danh sách phát';

  @override
  String get startMix => 'Bắt đầu Mix';

  @override
  String get startMixNoTracksArtist =>
      'Bấm giữ một nghệ sĩ để thêm hoặc loại bỏ ra khỏi bộ Mix trước khi bắt đầu một tuyển tập Mix';

  @override
  String get startMixNoTracksAlbum =>
      'Bấm giữ một Album để thêm hoặc loại bỏ ra khỏi bộ Mix trước khi bắt đầu một tuyển tập Mix';

  @override
  String get startMixNoTracksGenre =>
      'Nhấn và giữ một thể loại để thêm hoặc xóa nó khỏi trình tạo hỗn hợp trước khi bắt đầu kết hợp';

  @override
  String get music => 'Nhạc';

  @override
  String get clear => 'Loại bỏ';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Trộn hết';

  @override
  String get downloads => 'Tải xuống';

  @override
  String get settings => 'Cài đặt';

  @override
  String get offlineMode => 'Chế độ ngoại tuyến';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get sortOrder => 'Sắp thứ tự';

  @override
  String get sortBy => 'Sắp theo';

  @override
  String get title => 'Tiêu đề';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album Nghệ Sĩ';

  @override
  String get albumArtists => 'Album Artists';

  @override
  String get performingArtists => 'Performing Artists';

  @override
  String get artist => 'Nghệ sĩ';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Chi phí';

  @override
  String get communityRating => 'Đánh giá cộng đồng';

  @override
  String get criticRating => 'Đánh giá nhà phê bình';

  @override
  String get dateAdded => 'Ngày được thêm';

  @override
  String get datePlayed => 'Ngày phát';

  @override
  String get playCount => 'Số lần phát';

  @override
  String get premiereDate => 'Ngày phát hành';

  @override
  String get productionYear => 'Năm sản xuất';

  @override
  String get name => 'Tên';

  @override
  String get random => 'Ngẫu nhiên';

  @override
  String get revenue => 'Lợi nhuận';

  @override
  String get duration => 'Duration';

  @override
  String get serverOrder => 'Server Order';

  @override
  String formattedRelativeTime(String type, int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value days ago',
      one: '1 day ago',
    );
    String _temp1 = intl.Intl.selectLogic(
      type,
      {
        'just_now': 'just now',
        'minutes': '$value min ago',
        'hours': '$value h ago',
        'yesterday': 'yesterday',
        'days': '$_temp0',
        'other': 'value',
      },
    );
    return '$_temp1';
  }

  @override
  String get syncDownloadedPlaylists => 'Đồng bộ danh sách phát đã tải xuống';

  @override
  String get downloadMissingImages => 'Tải ảnh thiếu';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tải $count ảnh thiếu',
      one: 'Đã tải $count ảnh thiếu',
      zero: 'Không ảnh thiếu được tìm',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Hoạt động Tải xuống';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count đang tải xuống',
      one: '$count đang tải xuống',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount bản nhạc',
      one: '$trackCount bản nhạc',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount hình ảnh',
      one: '$imageCount hình ảnh',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount đồng bộ hóa nút',
      one: '$syncCount đồng bộ hóa nút',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nHiện đang sửa chữa',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count đã hoàn thành';
  }

  @override
  String dlFailed(int count) {
    return '$count thất bại';
  }

  @override
  String dlEnqueued(int count) {
    return '$count đang hàng đợi';
  }

  @override
  String dlRunning(int count) {
    return '$count đang chạy';
  }

  @override
  String get activeDownloadsTitle => 'Hoạt động Tải xuống';

  @override
  String get noActiveDownloads => 'Không có hoạt động tải xuống.';

  @override
  String get errorScreenError =>
      'Đã có lỗi xảy ra khi lấy danh sách lỗi! Tại thời điểm này, có lẽ bạn nên tạo một Issue trên trang GitHub và xoá dữ liệu ứng dụng';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Không thể tải bản nhạc từ ID tải xuống';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'track': 'track',
        'library': 'library',
        'other': 'item',
      },
    );
    return 'Are you sure you want to delete the $_temp0 \'$itemName\' from this device?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Delete';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get libraryDownloads => 'Library downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Lỗi';

  @override
  String discNumber(int number) {
    return 'Đĩa $number';
  }

  @override
  String get playButtonLabel => 'Phát';

  @override
  String get shuffleButtonLabel => 'Xáo trộn';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bài hát',
      one: '$count Bài hát',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bài hát',
      one: '$count Bài hát',
    );
    return '$_temp0, $downloads Đã tải xuống';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bài hát',
      one: '$count Bài hát',
    );
    return '$_temp0 Đã tải xuống';
  }

  @override
  String get editPlaylistNameTooltip => 'Chỉnh sửa tên danh sách phát';

  @override
  String get editPlaylistNameTitle => 'Chỉnh sửa Tên Danh sách phát';

  @override
  String get required => 'Được yêu cầu';

  @override
  String get updateButtonLabel => 'Cập nhật';

  @override
  String get playlistUpdated => 'Tên danh sách phát đã được cập nhật.';

  @override
  String get downloadsDeleted => 'Đã xóa tải xuống.';

  @override
  String get addDownloads => 'Thêm tải xuống';

  @override
  String get location => 'Vị trí';

  @override
  String get confirmDownloadStarted => 'Đã bắt đầu tải xuống';

  @override
  String get downloadsQueued => 'Tải xuống đã chuẩn bị, đang tải tệp';

  @override
  String get addButtonLabel => 'Thêm';

  @override
  String get shareLogs => 'Chia sẻ bản ghi';

  @override
  String get exportLogs => 'Save logs';

  @override
  String get logsCopied => 'Đã sao chép bản ghi.';

  @override
  String get message => 'Tin nhắn';

  @override
  String get stackTrace => 'Dấu vết Ngăn xếp';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Được cấp phép với Mozilla Public License 2.0.\nMã nguồn có sẵn tại $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Chuyển Mã';

  @override
  String get downloadLocations => 'Vị trí tải xuống';

  @override
  String get audioService => 'Dịch vụ âm thanh';

  @override
  String get playbackReporting => 'Playback Reporting';

  @override
  String get interactions => 'Tương tác';

  @override
  String get layoutAndTheme => 'Bố cục & Chủ đề';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Không khả dụng ở chế độ ngoại tuyến';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Các bài hát được tải xuống sẽ không bị xoá';

  @override
  String get areYouSure => 'Bạn chắc chứ?';

  @override
  String get enableTranscoding => 'Bật chuyển đổi';

  @override
  String get enableTranscodingSubtitle =>
      'Chuyển đổi các luồng truyền phát nhạc trên phía máy chủ.';

  @override
  String get bitrate => 'Tốc độ bit';

  @override
  String get bitrateSubtitle =>
      'Một tốc độ bit cao hơn mang lại âm thanh tốt hơn trong khi dùng băng thông lớn hơn.';

  @override
  String get customLocation => 'Vị trí tuỳ chỉnh';

  @override
  String get appDirectory => 'Đường dẫn ứng dụng';

  @override
  String get addDownloadLocation => 'Thêm đường dẫn tải xuống';

  @override
  String get selectDirectory => 'Chọn đường dẫn';

  @override
  String get unknownError => 'Lỗi không xác định';

  @override
  String get pathReturnSlashErrorMessage =>
      'Đường dẫn mà trả về \"/\" không dùng được';

  @override
  String get directoryMustBeEmpty => 'Đường dẫn phải trống';

  @override
  String get customLocationsBuggy =>
      'Vị trí tùy chỉnh khá nhiều lỗi do lỗi với việc cấp quyền. Tôi đang tìm biện pháp để sửa, hiện tại tôi không khuyến khích dùng chúng.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Vào trạng thái Ưu Tiên Thấp khi Dừng';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Để thông báo được gạt đi khi dừng. Ngoài ra cho phép Android tắt dịch vụ khi dừng.';

  @override
  String get shuffleAllTrackCount => 'Trộn tất cả bài hát';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Số lượng bài hát được tải khi dùng nút trộn tất cả bài hát.';

  @override
  String get viewType => 'Loại Xem';

  @override
  String get viewTypeSubtitle => 'Loại xem cho màn hình nhạc';

  @override
  String get list => 'Danh sách';

  @override
  String get grid => 'Lưới';

  @override
  String get customizationSettingsTitle => 'Tùy chỉnh';

  @override
  String get playbackSpeedControlSetting => 'Hiển thị Tốc độ Phát lại';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Các điều khiển tốc độ phát lại có được hiển thị trong menu màn hình trình phát hay không';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Tự động:\nFinamp cố gắng xác định xem bản nhạc bạn đang phát là podcast hay (một phần) sách nói. Điều này được coi là xảy ra nếu bản nhạc dài hơn $trackDuration phút, nếu album của bản nhạc dài hơn $albumDuration giờ hoặc nếu bản nhạc được chỉ định ít nhất một trong các thể loại sau: $genreList\nSau đó, điều khiển tốc độ phát lại sẽ được hiển thị trong menu màn hình trình phát.\n\nHiển thị:\nCác điều khiển tốc độ phát lại sẽ luôn được hiển thị trong menu màn hình trình phát.\n\nẨn:\nCác điều khiển tốc độ phát lại trong menu màn hình trình phát luôn bị ẩn.';
  }

  @override
  String get automatic => 'Tự động';

  @override
  String get shown => 'Hiển thị';

  @override
  String get hidden => 'Ẩn';

  @override
  String get speed => 'Tốc độ';

  @override
  String get reset => 'Đặt lại';

  @override
  String get apply => 'Áp dụng';

  @override
  String get portrait => 'Dọc';

  @override
  String get landscape => 'Ngang';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Số Lưới Trục-Chéo';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Số lượng lưới dùng mỗi hàng khi $value.';
  }

  @override
  String get showTextOnGridView => 'Hiện thông tin trong khung lưới';

  @override
  String get showTextOnGridViewSubtitle =>
      'Cho dù có hay không hiện thông tin (tiêu đề, nghệ sĩ,...) trên lưới nhạc.';

  @override
  String get useCoverAsBackground => 'Dùng ảnh bìa mờ làm nền trình phát';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Có hay không dùng ảnh bìa mờ làm nền trình phát trên phần phát nhạc.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Khoảng đệm bìa album tối thiểu';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Khoảng đệm tối thiểu xung quanh bìa album trên màn hình trình phát, tính bằng % chiều rộng màn hình.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Ẩn tên ca sĩ bài hát nếu giống ca sĩ album';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Có hay không hiện nghệ sĩ bài hát trên phần album nếu không khác ca sĩ album.';

  @override
  String get autoSwitchItemCurationTypeTitle =>
      'Auto-Switch Item Curation Type';

  @override
  String get autoSwitchItemCurationTypeSubtitle =>
      'When enabled, Item Sections on the Artist and Genre Screens automatically switch to a different curation type if no items are available (e.g., no favorites for a specific artist).';

  @override
  String get showArtistsTracksSection => 'Show Tracks Section';

  @override
  String get showArtistsTracksSectionSubtitle =>
      'Whether to show a section with up to five tracks. When enabled, you can choose between Most Played, Favorite, Random, Latest Releases, Recently Added and Recently Played Tracks.';

  @override
  String get disableGesture => 'Tắt cử chỉ';

  @override
  String get disableGestureSubtitle => 'Có nên tắt cử chỉ.';

  @override
  String get showFastScroller => 'Hiển thị thanh cuộn nhanh';

  @override
  String get theme => 'Chủ đề';

  @override
  String get system => 'Hệ thống';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get tabs => 'Trang';

  @override
  String get playerScreen => 'Player Screen';

  @override
  String get cancelSleepTimer => 'Tắt Đồng hồ Hẹn Giờ Ngủ?';

  @override
  String get yesButtonLabel => 'CÓ';

  @override
  String get noButtonLabel => 'KHÔNG';

  @override
  String get setSleepTimer => 'Đặt đồng hồ hẹn giờ ngủ';

  @override
  String get hours => 'Hours';

  @override
  String get seconds => 'Seconds';

  @override
  String get minutes => 'Phút';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime of $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Track $currentTrackIndex of $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Số không hợp lệ';

  @override
  String get sleepTimerTooltip => 'Đồng hồ hẹn giờ ngủ';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Sleeping in $time minutes';
  }

  @override
  String get addToPlaylistTooltip => 'Thêm vào danh sách phát';

  @override
  String get addToPlaylistTitle => 'Thêm vào Danh sách phát';

  @override
  String get addToMorePlaylistsTooltip => 'Add to more playlists';

  @override
  String get addToMorePlaylistsTitle => 'Add to More Playlists';

  @override
  String get removeFromPlaylistTooltip => 'Loại bỏ khỏi danh sách phát';

  @override
  String get removeFromPlaylistTitle => 'Loại bỏ khỏi Danh sách phát';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Remove from playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Remove from Playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Danh sách phát mới';

  @override
  String get createButtonLabel => 'TẠO';

  @override
  String get playlistCreated => 'Đã tạo danh sách phát.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Tap to add to playlist. Long press to toggle favorite.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Không có Album';

  @override
  String get noItem => 'Không có vật phẩm';

  @override
  String get noArtist => 'Không có Nghệ sĩ';

  @override
  String get unknownArtist => 'Nghệ sĩ không rõ';

  @override
  String get unknownAlbum => 'Unknown Album';

  @override
  String get playbackModeDirectPlaying => 'Direct Playing';

  @override
  String get playbackModeTranscoding => 'Transcoding';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Locally Playing';

  @override
  String get queue => 'Hàng chờ';

  @override
  String get addToQueue => 'Thêm vào Hàng chờ';

  @override
  String get replaceQueue => 'Thay thế Hàng chờ';

  @override
  String get instantMix => 'Instant Mix';

  @override
  String get goToAlbum => 'Đi tới Album';

  @override
  String get goToArtist => 'Go to Artist';

  @override
  String get goToGenre => 'Go to Genre';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Added Favorite';

  @override
  String get confirmFavoriteRemoved => 'Removed Favorite';

  @override
  String get addedToQueue => 'Đã thêm vào hàng chờ.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Đã thay thế hàng chờ.';

  @override
  String get confirmAddedToPlaylist => 'Added to playlist.';

  @override
  String get removedFromPlaylist => 'Đã loại bỏ khỏi danh sách.';

  @override
  String get startingInstantMix => 'Bắt đầu tuyển tập nhạc tức thời.';

  @override
  String get anErrorHasOccured => 'Đã có lỗi xảy ra.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Mã $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Mã $statusCode. Có thể bạn đã nhập sai tên người dùng/mật khẩu, hoặc client của bạn bị đăng xuất.';
  }

  @override
  String get removeFromMix => 'Loại bỏ khỏi Mix';

  @override
  String get addToMix => 'Thêm vào Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã tải lại $count bài',
      one: 'Đã tải lại $count bài',
      zero: 'Không cần tải lại.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Thời gian bộ đệm';

  @override
  String get bufferDurationSubtitle =>
      'Trình phát nên tạo bộ đệm trong bao lâu giây. Cần khởi động lại app.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Don\'t limit buffer size';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.';

  @override
  String get bufferSizeTitle => 'Buffer Size';

  @override
  String get bufferSizeSubtitle =>
      'The maximum size of the buffer in MB. Requires a restart';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Skip to beginning or to previous track';

  @override
  String get skipToNextTrackButtonTooltip => 'Skip to next track';

  @override
  String get togglePlaybackButtonTooltip => 'Toggle playback';

  @override
  String get previousTracks => 'Previous Tracks';

  @override
  String get nextUp => 'Next Up';

  @override
  String get clearNextUp => 'Clear Next Up';

  @override
  String get stopAndClearQueue => 'Stop playback and clear queue';

  @override
  String get playingFrom => 'Playing from';

  @override
  String get playNext => 'Play next';

  @override
  String get addToNextUp => 'Add to Next Up';

  @override
  String get shuffleNext => 'Shuffle next';

  @override
  String get shuffleToNextUp => 'Shuffle to Next Up';

  @override
  String get shuffleToQueue => 'Shuffle to queue';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'Album',
        'artist': 'Artist',
        'playlist': 'Playlist',
        'genre': 'Genre',
        'other': 'Item',
      },
    );
    return '$_temp0 will play next';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'album',
        'artist': 'artist',
        'playlist': 'playlist',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Added $_temp0 to Next Up';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'track',
        'album': 'album',
        'artist': 'artist',
        'playlist': 'playlist',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Added $_temp0 to queue';
  }

  @override
  String get confirmShuffleNext => 'Will shuffle next';

  @override
  String get confirmShuffleToNextUp => 'Shuffled to Next Up';

  @override
  String get confirmShuffleToQueue => 'Shuffled to queue';

  @override
  String get placeholderSource => 'Somewhere';

  @override
  String get playbackHistory => 'Playback History';

  @override
  String get shareOfflineListens => 'Share offline listens';

  @override
  String get yourLikes => 'Your Likes';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Tracks added via Next Up';

  @override
  String get savedQueue => 'Saved Queue';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'trackMix': 'Track Mix',
        'artistMix': 'Artist Mix',
        'albumMix': 'Album Mix',
        'genreMix': 'Genre Mix',
        'favorites': 'Favorites',
        'allTracks': 'All Tracks',
        'filteredList': 'Tracks',
        'genre': 'Genre',
        'artist': 'Artist',
        'track': 'Track',
        'nextUpAlbum': 'Album in Next Up',
        'nextUpPlaylist': 'Playlist in Next Up',
        'nextUpArtist': 'Artist in Next Up',
        'remoteClient': 'a Remote Client',
        'other': '',
      },
    );
    return 'Playing From $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Shuffle All';

  @override
  String get playbackOrderLinearButtonLabel => 'Playing in order';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Playing in order. Tap to shuffle.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Shuffling tracks';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Shuffling tracks. Tap to play in order.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Playing at x$speed speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed speed';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volume';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Decrease playback speed';

  @override
  String get playbackSpeedIncreaseLabel => 'Increase playback speed';

  @override
  String get loopModeNoneButtonLabel => 'Not looping';

  @override
  String get loopModeOneButtonLabel => 'Looping this track';

  @override
  String get loopModeAllButtonLabel => 'Looping all';

  @override
  String get queuesScreen => 'Restore Now Playing';

  @override
  String get queueRestoreButtonLabel => 'Restore';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Saved $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Playing: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '1 Track',
    );
    return '$_temp0, $remaining Unplayed';
  }

  @override
  String get queueLoadingMessage => 'Restoring queue…';

  @override
  String get queueRetryMessage => 'Failed to restore queue. Retry?';

  @override
  String get autoloadLastQueueOnStartup => 'Auto-Restore Last Queue';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Upon app startup, attempt to restore the last played queue.';

  @override
  String get reportQueueToServer => 'Report current queue to server?';

  @override
  String get reportQueueToServerSubtitle =>
      'When enabled, Finamp will send the current queue to the server. This can improve remote control and allow server-side restoration of the queue. Always enabled if the \'Play On\' feature is enabled.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Playback Session Update Frequency';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'How often to send the current playback status to the server, in seconds. This should be less than 5 minutes (300 seconds), to prevent the session from timing out.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'If the Jellyfin server hasn\'\'t received any updates from a client in the last 5 minutes, it assumes that playback has ended. This means that for tracks longer than 5 minutes, that playback could be incorrectly reported as having ended, which reduced the quality of the playback reporting data.';

  @override
  String get playOnStaleDelay => '\'Play On\' Session Timeout';

  @override
  String get playOnStaleDelaySubtitle =>
      'How long a remote \'Play On\' session is considered active after receiving a command. When considered active, playback is reported more frequently, which can lead to increased bandwidth usage.';

  @override
  String get enablePlayonTitle => 'Enable \'Play On\' Support';

  @override
  String get enablePlayonSubtitle =>
      'Enables Jellyfin\'s \'Play On\' feature (remote-controlling Finamp from another client). Disable this if your reverse proxy or server doesn\'t support websockets.';

  @override
  String get playOnReconnectionDelay =>
      '\'Play On\' Session Reconnection Delay';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Controls the delay between the attempts to reconnect to the PlayOn websocket when it gets disconnected (in seconds). A lower delay increases bandwidth usage.';

  @override
  String get topTracks => 'Top Tracks';

  @override
  String get topAlbums => 'Top Albums';

  @override
  String get topArtists => 'Top Artists';

  @override
  String get recentlyAddedTracks => 'Recently Added Tracks';

  @override
  String get recentlyAddedAlbums => 'Recently Added Albums';

  @override
  String get recentlyAddedArtists => 'Recently Added Artists';

  @override
  String get latestTracks => 'Latest Tracks';

  @override
  String get latestAlbums => 'Latest Albums';

  @override
  String get latestArtists => 'Latest Artists';

  @override
  String get recentlyPlayedTracks => 'Recently Played Tracks';

  @override
  String get recentlyPlayedAlbums => 'Recently Played Albums';

  @override
  String get recentlyPlayedArtists => 'Recently Played Artists';

  @override
  String get favoriteTracks => 'Favorite Tracks';

  @override
  String get favoriteAlbums => 'Favorite Albums';

  @override
  String get favoriteArtists => 'Favorite Artists';

  @override
  String get randomTracks => 'Tracks (Random Picks)';

  @override
  String get randomAlbums => 'Albums (Random Picks)';

  @override
  String get randomArtists => 'Artists (Random Picks)';

  @override
  String get mostPlayed => 'Most Played';

  @override
  String get randomFavoritesFirst => 'Random (Favorites First)';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get latestReleases => 'Latest Releases';

  @override
  String get itemSectionsOrder => 'Item Sections Order';

  @override
  String get unknown => 'Unknown';

  @override
  String get itemSectionsOrderSubtitle =>
      'Controls the order of Item Sections.';

  @override
  String get genreItemSectionFilterChipOrderTitle =>
      'Item Sections Filter Order';

  @override
  String get genreItemSectionFilterChipOrderSubtitle =>
      'Controls the order of available filters for item sections.';

  @override
  String get artistItemSectionFilterChipOrderTitle =>
      'Tracks Section Filter Order';

  @override
  String get artistItemSectionFilterChipOrderSubtitle =>
      'Controls the order of available filters for the tracks section.';

  @override
  String get genreFilterArtistScreens => 'Filter Artists';

  @override
  String get genreFilterArtistScreensSubtitle =>
      'When enabled, Artists (accessed through a genre) will only show tracks and albums that match the genre you\'re currently browsing. (It is always possible to manually remove the Genre Filter to reveal all tracks and albums.)';

  @override
  String get genreFilterPlaylistScreens => 'Filter Playlists';

  @override
  String get genreFilterPlaylistScreensSubtitle =>
      'When enabled, Playlists (accessed through a genre) will only show tracks that match the genre you\'re currently browsing. (It is always possible to manually remove the Genre Filter to reveal all tracks.)';

  @override
  String get genreListsInheritSorting => 'Full Lists Sorting Inheritance';

  @override
  String get genreListsInheritSortingSubtitle =>
      'When enabled, the \"See All\" lists will inherit the sorting and filtering from the Genre Screen. If disabled, settings from the corresponding library tab will be used instead. Tapping on the Counts on the top of the Genre Screen or the \"Browse Playlists\" button will always open a full list with the sorting settings from the library tab.';

  @override
  String get curatedItemsMostPlayedOfflineTooltip =>
      'Not available in Offline Mode.';

  @override
  String curatedItemsNotListenedYet(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'artistGenreFilter': ' by this artist in this genre',
        'artist': ' by this artist',
        'genre': ' in this genre',
        'other': '',
      },
    );
    return 'You haven\'t listened to any tracks$_temp0.';
  }

  @override
  String curatedItemsNoFavorites(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'artistGenreFilter': ' for this artist in this genre',
        'artist': ' for this artist',
        'genre': ' for this genre',
        'other': '',
      },
    );
    return 'You don\'t have any favorites$_temp0.';
  }

  @override
  String genreNoItems(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'playlists': 'playlists',
        'artists': 'artists',
        'albums': 'albums',
        'tracks': 'tracks',
        'other': 'items',
      },
    );
    return 'You don\'t have any $_temp0 for this genre.';
  }

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Albums',
      one: '$count Album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Shuffle Albums';

  @override
  String get shuffleAlbumsNext => 'Shuffle Albums Next';

  @override
  String get shuffleAlbumsToNextUp => 'Shuffle Albums To Next Up';

  @override
  String get shuffleAlbumsToQueue => 'Shuffle Albums To Queue';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount plays',
      one: '$playCount play',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'playlist',
        'trackMix': 'track mix',
        'artistMix': 'artist mix',
        'albumMix': 'album mix',
        'genreMix': 'genre mix',
        'favorites': 'favorites',
        'allTracks': 'all tracks',
        'filteredList': 'tracks',
        'genre': 'genre',
        'artist': 'artist',
        'track': 'track',
        'nextUpAlbum': 'album in next up',
        'nextUpPlaylist': 'playlist in next up',
        'nextUpArtist': 'artist in next up',
        'other': '',
      },
    );
    return 'Couldn\'\'t load $_temp0';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get showUncensoredLogMessage =>
      'This log contains your login information. Show?';

  @override
  String get resetTabs => 'Reset tabs';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get noMusicLibrariesTitle => 'No Music Libraries';

  @override
  String get noMusicLibrariesBody =>
      'Finamp could not find any music libraries. Please ensure that your Jellyfin server contains at least one library with the content type set to \"Music\".';

  @override
  String get refresh => 'Refresh';

  @override
  String get moreInfo => 'More Info';

  @override
  String get volumeNormalizationSettingsTitle => 'Volume Normalization';

  @override
  String get playbackReportingSettingsTitle => 'Playback Reporting & Play On';

  @override
  String get volumeNormalizationSwitchTitle => 'Enable Volume Normalization';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Use gain information to normalize the loudness of tracks (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle =>
      'Volume Normalization Mode';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'When and how to apply Volume Normalization';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Hybrid (Track + Album):\nTrack gain is used for regular playback, but if an album is playing (either because it\'\'s the main playback queue source, or because it was added to the queue at some point), the album gain is used instead.\n\nTrack-based:\nTrack gain is always used, regardless of whether an album is playing or not.\n\nAlbums Only:\nVolume Normalization is only applied while playing albums (using the album gain), but not for individual tracks.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybrid (Track + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Track-based';

  @override
  String get volumeNormalizationModeAlbumBased => 'Album-based';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Only for Albums';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Base Gain';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Currently, Volume Normalization on iOS requires changing the playback volume to emulate the gain change. Since we can\'\'t increase the volume above 100%, we need to decrease the volume by default so that we can boost the volume of quiet tracks. The value is in decibels (dB), where -10 dB is ~30% volume, -4.5 dB is ~60% volume and -2 dB is ~80% volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Play Swiped Track Next';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Enable to insert a track as next item in queue when swiped in track list instead of appending it to the end.';

  @override
  String get swipeLeftToRightAction => 'Swipe to Right Action';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Action triggered when swiping a track in the list from left to right.';

  @override
  String get swipeRightToLeftAction => 'Swipe to Left Action';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Action triggered when swiping a track in the list from right to left.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Start Instant Mixes for Individual Tracks';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'When enabled, tapping a track on the tracks tab will start an instant mix of that track instead of just playing a single track.';

  @override
  String get downloadItem => 'Download';

  @override
  String get repairComplete => 'Downloads Repair complete.';

  @override
  String get syncComplete => 'All downloads re-synced.';

  @override
  String get syncDownloads => 'Sync and download missing items.';

  @override
  String get repairDownloads =>
      'Repair issues with downloaded files or metadata.';

  @override
  String get requireWifiForDownloads => 'Require WiFi when downloading.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '$count track',
    );
    return 'Warning: $_temp0 could not be restored to the queue.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Running',
        'failed': 'Failed',
        'syncFailed': 'Repeatedly Unsynced',
        'enqueued': 'Queued',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Downloads',
      one: 'Download',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Are you sure you want to download all contents of the library \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Only show fully downloaded albums';

  @override
  String get filesystemFull =>
      'Remaining downloads cannot be completed. The filesystem is full.';

  @override
  String get connectionInterrupted =>
      'Connection interrupted, pausing downloads.';

  @override
  String get connectionInterruptedBackground =>
      'Connection was interrupted while downloading in the background. This can be caused by OS settings.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'Connection was interrupted while downloading in the background. This can be caused by enabling \'Enter Low-Priority State on Pause\' or OS settings.';

  @override
  String get activeDownloadSize => 'Downloading…';

  @override
  String get missingDownloadSize => 'Deleting…';

  @override
  String get syncingDownloadSize => 'Syncing…';

  @override
  String get runRepairWarning =>
      'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Show Media with Unknown Library.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => 'Max Concurrent Downloads';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'Increasing concurrent downloads may allow increased downloading in the background but may cause some downloads to fail if very large, or cause excessive lag in some cases.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Concurrent Downloads';
  }

  @override
  String get downloadsWorkersSetting => 'Download Worker count';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Amount of workers for syncing metadata and deleting downloads. Increasing download workers may speed up download syncing and deleting, especially when server latency is high, but can introduce lag.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Download Workers';
  }

  @override
  String get syncOnStartupSwitch => 'Automatically Sync Downloads at Startup';

  @override
  String get preferQuickSyncSwitch => 'Prefer Quick Syncs';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'When performing syncs, some typically static items (like tracks and albums) will not be updated. Download repair will always perform a full sync.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Track',
        'library': 'Library',
        'unknown': 'Item',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String get downloadButtonDisabledGenreFilterTooltip =>
      'Please remove the genre filter to enable the download actions.';

  @override
  String get genreFilterNotAvailableForAlbums =>
      'Genre Filters are not available for Albums.';

  @override
  String genreNotFound(String additionalInfo) {
    String _temp0 = intl.Intl.selectLogic(
      additionalInfo,
      {
        'offline':
            ' It might not be downloaded or may belong to a different library.',
        'other': ' It may belong to a different library.',
      },
    );
    return 'The genre could not be found.$_temp0';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'This item is required to be downloaded by $parentName.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Favorites',
        'allPlaylists': 'All Playlists',
        'fiveLatestAlbums': '5 Latest Albums',
        'allPlaylistsMetadata': 'Playlist Metadata',
        'collectionWithLibraryFilter': 'Collection with Library Filter',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Cached Images for \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle => 'Select Transcoding Format';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Select the format to use when streaming transcoded audio. Already queued tracks will not be affected.';

  @override
  String get downloadTranscodeEnableTitle => 'Enable Transcoded Downloads';

  @override
  String get downloadTranscodeCodecTitle => 'Select Download Codec';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Always',
        'never': 'Never',
        'ask': 'Ask',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Download Bitrate';

  @override
  String get downloadBitrateSubtitle =>
      'A higher bitrate gives higher quality audio at the cost of larger storage requirements.';

  @override
  String get transcodeHint => 'Transcode?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Download as $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transcoded',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      location,
      {
        'null': '',
        'other': ' ($location)',
      },
    );
    return '$size $codec$_temp0$_temp1';
  }

  @override
  String collectionDownloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      codec,
      {
        'ORIGINAL': '',
        'other': ' as $codec @ $bitrate',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      location,
      {
        'null': '',
        'other': ' ($location)',
      },
    );
    return '$size$_temp0$_temp1';
  }

  @override
  String dontTranscode(String description) {
    String _temp0 = intl.Intl.selectLogic(
      description,
      {
        'null': '',
        'other': ' - $description',
      },
    );
    return 'Download original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Transcode Redownload queued.';

  @override
  String get redownloadTitle => 'Automatically Redownload Transcodes';

  @override
  String get redownloadSubtitle =>
      'Automatically redownload tracks which are expected to be at a different quality due to parent collection changes.';

  @override
  String get defaultDownloadLocationButton =>
      'Set as default download location.  Disable to select per download.';

  @override
  String get fixedGridSizeSwitchTitle => 'Use fixed size grid tiles';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Grid tile sizes will not respond to window/screen size.';

  @override
  String get fixedGridSizeTitle => 'Grid Tile Size';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Small',
        'medium': 'Medium',
        'large': 'Large',
        'veryLarge': 'Very Large',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Allow SplitScreen Mode';

  @override
  String get allowSplitScreenSubtitle =>
      'The player will be displayed alongside other views on wider displays.';

  @override
  String get enableVibration => 'Enable vibration';

  @override
  String get enableVibrationSubtitle => 'Whether to enable vibration.';

  @override
  String get hideQueueButton => 'Hide queue button';

  @override
  String get hideQueueButtonSubtitle =>
      'Hide the queue button on the player screen. Swipe up to access the queue.';

  @override
  String get oneLineMarqueeTextButton => 'Auto-scroll Long Titles';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Automatically scroll track titles that are too long to display in two lines';

  @override
  String get marqueeOrTruncateButton => 'Use ellipsis for long titles';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Show … at the end of long titles instead of scrolling text';

  @override
  String get hidePlayerBottomActions => 'Hide bottom actions';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Hide the queue and lyrics buttons on the player screen. Swipe up to access the queue, swipe left (below the album cover) to view lyrics if available.';

  @override
  String get prioritizePlayerCover => 'Prioritize album cover';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Prioritize showing a larger album cover on player screen. Non-critical controls will be hidden more aggressively at small screen sizes.';

  @override
  String get suppressPlayerPadding => 'Suppress player controls padding';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Fully minimizes padding between player screen controls when album cover is not at full size.';

  @override
  String get lockDownload => 'Always Keep on Device';

  @override
  String get showArtistChipImage => 'Show artist images with artist name';

  @override
  String get showArtistChipImageSubtitle =>
      'This affects small artist image previews, such as on the player screen.';

  @override
  String get scrollToCurrentTrack => 'Scroll to current track';

  @override
  String get enableAutoScroll => 'Enable auto-scroll';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz kHz';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit bit';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration remaining';
  }

  @override
  String get removeFromPlaylistConfirm => 'Remove';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Remove \'$itemName\' from playlist \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Track Menu';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addRemoveFromPlaylist => 'Add To / Remove From Playlists';

  @override
  String get addPlaylistSubheader => 'Add track to a playlist';

  @override
  String get trackOfflineFavorites => 'Sync all favorite statuses';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'This allows showing more up-to-date favorite statuses while offline.  Does not download any additional files.';

  @override
  String get allPlaylistsInfoSetting => 'Download Playlist Metadata';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Sync metadata for all playlists to improve your playlist experience';

  @override
  String get downloadFavoritesSetting => 'Download all favorites';

  @override
  String get downloadAllPlaylistsSetting => 'Download all playlists';

  @override
  String get fiveLatestAlbumsSetting => 'Download 5 latest albums';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Downloads will be removed as they age out.  Lock the download to prevent an album from being removed.';

  @override
  String get cacheLibraryImagesSettings => 'Cache current library images';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'All album, artist, genre, and playlist covers in the currently active library will be downloaded.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Show track progress on in-app miniplayer';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Controls if the in-app miniplayer / now playing bar at the bottom of the music screen functions as a progress bar.';

  @override
  String get lyricsScreenButtonTitle => 'Lyrics';

  @override
  String get lyricsScreen => 'Lyrics View';

  @override
  String get showLyricsTimestampsTitle =>
      'Show timestamps for synchronized lyrics';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Controls if the timestamp of each lyric line is shown in the lyrics view, if available.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Show Stop Button on Media Notification';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Controls if the media notification has a stop button. This lets you stop playback without opening the app.';

  @override
  String get showShuffleButtonOnMediaNotificationTitle =>
      'Show Shuffle Button on Media Notification';

  @override
  String get showShuffleButtonOnMediaNotificationSubtitle =>
      'Controls if the media notification has a shuffle button. This lets you shuffle/unshuffle playback without opening the app.';

  @override
  String get showFavoriteButtonOnMediaNotificationTitle =>
      'Show Favorite Button on Media Notification';

  @override
  String get showFavoriteButtonOnMediaNotificationSubtitle =>
      'Controls if the media notification has a favorite button. This lets you favorite/unfavorite the current track without opening the app.';

  @override
  String get showSeekControlsOnMediaNotificationTitle =>
      'Allow Seeking on Media Notification';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Controls if the media notification has a seekable progress bar. This lets you change the playback position without opening the app.';

  @override
  String get alignmentOptionStart => 'Start';

  @override
  String get alignmentOptionCenter => 'Center';

  @override
  String get alignmentOptionEnd => 'End';

  @override
  String get fontSizeOptionSmall => 'Small';

  @override
  String get fontSizeOptionMedium => 'Medium';

  @override
  String get fontSizeOptionLarge => 'Large';

  @override
  String get lyricsAlignmentTitle => 'Lyrics alignment';

  @override
  String get lyricsAlignmentSubtitle =>
      'Controls the alignment of lyrics in the lyrics view.';

  @override
  String get lyricsFontSizeTitle => 'Lyrics font size';

  @override
  String get lyricsFontSizeSubtitle =>
      'Controls the font size of lyrics in the lyrics view.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Show album cover before lyrics';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Controls if the album cover is shown above the lyrics before being scrolled away.';

  @override
  String get keepScreenOn => 'Keep Screen On';

  @override
  String get keepScreenOnSubtitle => 'When to keep the screen on';

  @override
  String get keepScreenOnDisabled => 'Disabled';

  @override
  String get keepScreenOnAlwaysOn => 'Always On';

  @override
  String get keepScreenOnWhilePlaying => 'While Playing Music';

  @override
  String get keepScreenOnWhileLyrics => 'While Showing Lyrics';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Keep Screen On only while plugged in';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Ignore the Keep Screen On setting if device is unplugged';

  @override
  String get genericToggleButtonTooltip => 'Tap to toggle.';

  @override
  String get artwork => 'Artwork';

  @override
  String artworkTooltip(String title) {
    return 'Artwork for $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Artwork for $title. Tap to toggle playback. Swipe left or right to switch tracks.';
  }

  @override
  String get nowPlayingBarTooltip => 'Open Player Screen';

  @override
  String get additionalPeople => 'People';

  @override
  String get playbackMode => 'Playback Mode';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Bit Depth';

  @override
  String get size => 'Size';

  @override
  String get normalizationGain => 'Gain';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get showFeatureChipsToggleTitle => 'Show Advanced Track Info';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Show advanced track info like codec, bitrate, and more on the player screen.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Album Screen';

  @override
  String get showCoversOnAlbumScreenTitle => 'Show Album Covers For Tracks';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Show album covers for each track separately on the album screen.';

  @override
  String get artistScreen => 'Artist Screen';

  @override
  String get applyFilterOnGenreChipTapTitle => 'Apply Filter On Genre Tap';

  @override
  String get applyFilterOnGenreChipTapSubtitle =>
      'By default, tapping a genre opens it, while long-pressing filters the artist or playlist by that genre. When enabled, this behavior is inverted.';

  @override
  String get applyFilterOnGenreChipTapPrompt => 'Applied genre filter';

  @override
  String get applyFilterOnGenreChipTapPromptButton => 'Open Genre';

  @override
  String get genreScreen => 'Genre Screen';

  @override
  String get emptyTopTracksList =>
      'You haven\'t listened to any track by this artist yet.';

  @override
  String get emptyFilteredListTitle => 'No items found';

  @override
  String get emptyFilteredListSubtitle =>
      'No items match the filter. Try turning off the filter or changing the search term.';

  @override
  String get resetFiltersButton => 'Reset filters';

  @override
  String get resetSettingsPromptGlobal =>
      'Are you sure you want to reset ALL settings to their defaults?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Reset ALL settings';

  @override
  String get resetSettingsPromptLocal =>
      'Do you want to reset these settings back to their defaults?';

  @override
  String get genericCancel => 'Cancel';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Track',
        'library': 'Library',
        'other': 'Item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'Device',
        'server': 'Server',
        'other': 'unknown',
      },
    );
    return '$_temp0 got deleted from $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Allow deletion from server';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.';

  @override
  String deleteFromTargetDialogText(
      String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'track': 'track',
        'library': 'library',
        'other': 'item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' This will also Delete this item from this Device.',
        'cantDelete':
            ' This item will stay on this device until the next sync.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'this device',
        'server':
            'the servers file system and library.$_temp1\nThis action cannot be reverted',
        'other': '',
      },
    );
    return 'You are about to delete this $_temp0 from $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' from Device',
        'server': ' from Server',
        'other': '',
      },
    );
    return 'Delete$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Warning: You are about to download $count tracks.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Download Size Warning Cutoff';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'A warning message will be displayed when downloading more than this many tracks at once.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Are you sure you want add all tracks from $_temp0 \'$itemName\' to this playlist?  They can only be removed individually.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Publicly Visible:';

  @override
  String get releaseDateFormatYear => 'Year';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Month & Year';

  @override
  String get releaseDateFormatMonthDayYear => 'Month, Day & Year';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Show Album Release Date on Player Screen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Show the release date of the album on the player screen, behind the album name.';

  @override
  String get releaseDateFormatTitle => 'Release Date Format';

  @override
  String get releaseDateFormatSubtitle =>
      'Controls the format of all release dates shown in the app.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError => 'Error loading available libraries for user';

  @override
  String get autoOfflineOptionOff => 'Disabled';

  @override
  String get autoOfflineOptionNetwork => 'Local Network';

  @override
  String get autoOfflineOptionDisconnected => 'Disconnected';

  @override
  String get autoOfflineSettingDescription =>
      'Automatically enable Offline Mode.\nDisabled: Wont Automatically turn on Offline Mode. May save battery.\nLocal Network: Turn Offline Mode on when not being connected to wifi or ethernet.\nDisconnected: Turn Offline Mode on when not being connected to anything.\nYou can always manually turn on offline mode which pauses automation until you turn offline mode off again';

  @override
  String get autoOfflineSettingTitle => 'Automated Offline Mode';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'enabled',
        'disabled': 'disabled',
        'other': 'set quantum position for',
      },
    );
    return 'Automatically $_temp0 Offline Mode';
  }

  @override
  String get audioFadeOutDurationSettingTitle => 'Audio fade-out duration';

  @override
  String get audioFadeOutDurationSettingSubtitle =>
      'The duration of the audio fade out in milliseconds.';

  @override
  String get audioFadeInDurationSettingTitle => 'Audio fade-in duration';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'The duration of the audio fade-in in milliseconds. Set to 0 to disable fade-in.';

  @override
  String get outputMenuButtonTitle => 'Output';

  @override
  String get outputMenuTitle => 'Change Output';

  @override
  String get outputMenuVolumeSectionTitle => 'Volume';

  @override
  String get outputMenuDevicesSectionTitle => 'Available Devices';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Connect to a device';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Device Speaker',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Unknown',
      },
    );
    return '$_temp0';
  }

  @override
  String get desktopShuffleWarning =>
      'Changing shuffle mode is not currently available on desktop.';

  @override
  String get preferHomeNetworkActiveAddressInfoText => 'Active Address';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingTitle =>
      'Home Network Address';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingDescription =>
      'Target address of the Jellyfin server inside your home network';

  @override
  String get preferHomeNetworkEnableSwitchTitle => 'Prefer Home Network';

  @override
  String get preferHomeNetworkEnableSwitchDescription =>
      'Whether or not to use a different address when you are at home';

  @override
  String get preferHomeNetworkPublicAddressSettingTitle => 'Public Address';

  @override
  String get preferHomeNetworkPublicAddressSettingDescription =>
      'The primary address used to connect to your Jellyfin server';

  @override
  String get preferHomeNetworkInfoBox =>
      'This Feature requires Location permissions (and location needs to be enabled) to read the network name.';

  @override
  String get networkSettingsTitle => 'Network';

  @override
  String get downloadPaused =>
      'Downloading paused because device is not connected to WiFi';

  @override
  String get missingSchemaError => 'Url needs to start with http(s)://';

  @override
  String get testConnectionButtonLabel => 'Test both connections';

  @override
  String ping(String status) {
    String _temp0 = intl.Intl.selectLogic(
      status,
      {
        'true_true': 'Both reachable',
        'true_false': 'FAILED to reach local address',
        'false_true': 'FAILED to reach public address',
        'false_false': 'FAILED to reach both',
        'other': 'unknown',
      },
    );
    return '$_temp0';
  }

  @override
  String get autoReloadQueueTitle => 'Automatically Reload Queue';

  @override
  String get autoReloadQueueSubtitle =>
      'Automatically reload the queue when the source changes (i.e. offline mode enabled or server address switch). If disabled, Finamp will prompt you instead.';

  @override
  String autoReloadPrompt(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'network': 'network settings',
        'transcoding': 'transcoding settings',
        'other': 'settings',
      },
    );
    return 'Reload queue to apply new $_temp0';
  }

  @override
  String autoReloadPromptMissingTracks(int amountUndownloadedTracks) {
    String _temp0 = intl.Intl.pluralLogic(
      amountUndownloadedTracks,
      locale: localeName,
      other: '$amountUndownloadedTracks tracks',
      one: '1 track',
    );
    return '$_temp0 will be removed from the queue because they aren\'t downloaded.';
  }

  @override
  String get autoReloadPromptReloadButton => 'Reload';
}
