// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => '一个开源Jellyfin音乐播放器';

  @override
  String startupError(String error) {
    return '应用程序启动期间出现问题！ 错误是：$error\n\n请在 github.com/UnicornsOnLSD/finamp 上创建一个 Github 问题，并附上此页面的屏幕截图。 如果问题一直显示，请清除您的应用数据以重置应用。';
  }

  @override
  String get about => '关于 Finamp';

  @override
  String get aboutContributionPrompt => '许多无私的志愿者用自由时间共同打造。\n你也可以加入他们！';

  @override
  String get aboutContributionLink => '在GitHub上参与构建Finamp：';

  @override
  String get aboutReleaseNotes => '阅读最新发行版信息：';

  @override
  String get aboutTranslations => '帮助将Finamp翻译成你的语言：';

  @override
  String get aboutThanks => '感谢使用 Finamp！';

  @override
  String get loginFlowWelcomeHeading => '欢迎来到';

  @override
  String get loginFlowSlogan => '你的音乐，以你想要的样子。';

  @override
  String get loginFlowGetStarted => '开始使用！';

  @override
  String get viewLogs => '查看日志';

  @override
  String get changeLanguage => '切换语言';

  @override
  String get loginFlowServerSelectionHeading => '连接到 Jellyfin';

  @override
  String get back => '返回';

  @override
  String get serverUrl => '服务器 URL';

  @override
  String get internalExternalIpExplanation => '如果您希望能够远程访问您的 Jellyfin 服务器，则需要使用您的外部 IP。\n\n如果您的服务器位于 HTTP 端口 (80/443) 上，则不必指定端口。 \n\n如果URL正确，你应该能在输入框下方看到弹出的服务器信息。';

  @override
  String get serverUrlHint => '示例 demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => '服务器URL帮助';

  @override
  String get emptyServerUrl => '服务器 URL 不能为空';

  @override
  String get connectingToServer => '正在连接到服务器...';

  @override
  String get loginFlowLocalNetworkServers => '在您本地网络上的服务器：';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => '正在扫描服务器...';

  @override
  String get loginFlowAccountSelectionHeading => '选择你的账户';

  @override
  String get backToServerSelection => '返回到服务器选择';

  @override
  String get loginFlowNamelessUser => '未命名用户';

  @override
  String get loginFlowCustomUser => '自定义用户';

  @override
  String get loginFlowAuthenticationHeading => '登录到你的账户';

  @override
  String get backToAccountSelection => '返回到账户选择';

  @override
  String get loginFlowQuickConnectPrompt => '使用快速连接模式';

  @override
  String get loginFlowQuickConnectInstructions => '打开Jellyfin应用或网站，点击你的账户图标，选择快速连接。';

  @override
  String get loginFlowQuickConnectDisabled => '此服务器已禁用快速连接。';

  @override
  String get orDivider => '或';

  @override
  String get loginFlowSelectAUser => '选择用户';

  @override
  String get username => '用户名';

  @override
  String get usernameHint => '输入你的用户名';

  @override
  String get usernameValidationMissingUsername => '请输入用户名';

  @override
  String get password => '密码';

  @override
  String get passwordHint => '输入密码';

  @override
  String get login => '登录';

  @override
  String get logs => '日志';

  @override
  String get next => '下一个';

  @override
  String get selectMusicLibraries => '选择音乐库';

  @override
  String get couldNotFindLibraries => '找不到任何库。';

  @override
  String get unknownName => '未知名称';

  @override
  String get tracks => '歌曲';

  @override
  String get albums => '专辑';

  @override
  String get artists => '艺术家';

  @override
  String get genres => '流派';

  @override
  String get playlists => '播放列表';

  @override
  String get startMix => '生成合辑';

  @override
  String get startMixNoTracksArtist => '长按一个艺术家，可在开始生成合辑前将其从合辑生成器中添加或移除';

  @override
  String get startMixNoTracksAlbum => '长按一个专辑，可在开始生成合辑前将其从合辑生成器中添加或移除';

  @override
  String get startMixNoTracksGenre => '长按一个流派，可在开始生成合辑前将其从合辑生成器中添加或移除';

  @override
  String get music => '音乐';

  @override
  String get clear => '清除';

  @override
  String get favourites => '收藏夹';

  @override
  String get shuffleAll => '随机播放';

  @override
  String get downloads => '下载';

  @override
  String get settings => '设置';

  @override
  String get offlineMode => '离线模式';

  @override
  String get sortOrder => '排序';

  @override
  String get sortBy => '排序方式';

  @override
  String get title => '标题';

  @override
  String get album => '专辑';

  @override
  String get albumArtist => '专辑艺术家';

  @override
  String get artist => '艺术家';

  @override
  String get budget => '预算';

  @override
  String get communityRating => '社区评级';

  @override
  String get criticRating => '评论家评级';

  @override
  String get dateAdded => '添加日期';

  @override
  String get datePlayed => '播放日期';

  @override
  String get playCount => '播放计数';

  @override
  String get premiereDate => '首映日期';

  @override
  String get productionYear => '制作年份';

  @override
  String get name => '名称';

  @override
  String get random => '随机';

  @override
  String get revenue => '收入';

  @override
  String get runtime => '运行时';

  @override
  String get syncDownloadedPlaylists => '同步下载的播放列表';

  @override
  String get downloadMissingImages => '下载缺少的图片';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已下载 $count 张缺少的图片',
      one: '已下载 $count 张缺少的图片',
      zero: '未找到缺少的图片',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => '正在下载';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个下载',
      one: '$count 个下载',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount 首歌曲',
      one: '$trackCount 首歌曲',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount 张图片',
      one: '$imageCount 张图片',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount 个节点同步',
      one: '$syncCount 个节点同步',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nCurrently repairing',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count 完成';
  }

  @override
  String dlFailed(int count) {
    return '$count 失败';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 已入队';
  }

  @override
  String dlRunning(int count) {
    return '$count 运行中';
  }

  @override
  String get activeDownloadsTitle => '正在下载';

  @override
  String get noActiveDownloads => '无正在下载。';

  @override
  String get errorScreenError => '获取错误列表时出错！ 现在您可能应该在 GitHub 上创建一个问题并清除应用数据';

  @override
  String get failedToGetTrackFromDownloadId => '无法通过下载 ID 获取歌曲';

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
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => '错误';

  @override
  String discNumber(int number) {
    return '唱片 $number';
  }

  @override
  String get playButtonLabel => '播放';

  @override
  String get shuffleButtonLabel => '随机播放';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0，$downloads 首已下载';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0已下载';
  }

  @override
  String get editPlaylistNameTooltip => '编辑播放列表名称';

  @override
  String get editPlaylistNameTitle => '编辑播放列表名称';

  @override
  String get required => '必需的';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => '播放列表名称已更新。';

  @override
  String get favourite => '收藏夹';

  @override
  String get downloadsDeleted => '已删除下载。';

  @override
  String get addDownloads => '添加下载';

  @override
  String get location => '位置';

  @override
  String get confirmDownloadStarted => '已开始下载';

  @override
  String get downloadsQueued => '下载准备就绪，正在下载文件';

  @override
  String get addButtonLabel => '添加';

  @override
  String get shareLogs => '分享日志';

  @override
  String get logsCopied => '已复制日志。';

  @override
  String get message => '消息';

  @override
  String get stackTrace => '堆栈跟踪';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return '以 Mozilla Public License 2.0 协议许可。\n源代码位于：$sourceCodeLink。';
  }

  @override
  String get transcoding => '转码';

  @override
  String get downloadLocations => '下载位置';

  @override
  String get audioService => '音频服务';

  @override
  String get interactions => '交互';

  @override
  String get layoutAndTheme => '布局和主题';

  @override
  String get notAvailableInOfflineMode => '在离线模式下不可用';

  @override
  String get logOut => '登出';

  @override
  String get downloadedTracksWillNotBeDeleted => '已下载的歌曲不会被删除';

  @override
  String get areYouSure => '你确定吗？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin 使用 AAC 进行转码';

  @override
  String get enableTranscoding => '启用转码';

  @override
  String get enableTranscodingSubtitle => '音乐流将由服务器转码。';

  @override
  String get bitrate => '比特率';

  @override
  String get bitrateSubtitle => '更高的比特率以更高的带宽为代价提供更高质量的音频。';

  @override
  String get customLocation => '自定义位置';

  @override
  String get appDirectory => '应用目录';

  @override
  String get addDownloadLocation => '添加下载路径';

  @override
  String get selectDirectory => '选择目录';

  @override
  String get unknownError => '未知错误';

  @override
  String get pathReturnSlashErrorMessage => '不能使用返回“/”的路径';

  @override
  String get directoryMustBeEmpty => '目录必须为空';

  @override
  String get customLocationsBuggy => '自定义位置可能会有很多错误，在大多数情况下不建议使用。由于操作系统的限制，系统“Music”文件夹下无法保存专辑封面。';

  @override
  String get enterLowPriorityStateOnPause => '暂停时进入低优先级状态';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => '通知可以在暂停时滑动。 启用此功能还允许 Android 在暂停时终止服务。';

  @override
  String get shuffleAllTrackCount => '随机播放歌曲数量';

  @override
  String get shuffleAllTrackCountSubtitle => '使用随机播放按钮时要加载的歌曲数量。';

  @override
  String get viewType => '视图类型';

  @override
  String get viewTypeSubtitle => '音乐屏幕的视图类型';

  @override
  String get list => '列表';

  @override
  String get grid => '网格';

  @override
  String get customizationSettingsTitle => '个性化';

  @override
  String get playbackSpeedControlSetting => '播放速度可见性';

  @override
  String get playbackSpeedControlSettingSubtitle => '播放速度控制是否显示在播放界面中';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return '自动：\nFinamp 会尝试识别您正在播放的歌曲是播客还是有声读物（部分）。如果歌曲长度超过 $trackDuration 分钟，歌曲的专辑长度超过 $albumDuration 小时，或者歌曲至少分配了以下一种类型：$genreList\n则播放速度控件将显示在播放界面菜单中。\n\n显示：\n播放速度控件将始终显示在播放界面菜单中。\n\n隐藏：\n播放速度控件将始终隐藏在播放界面菜单中。';
  }

  @override
  String get automatic => '自动';

  @override
  String get shown => '显示';

  @override
  String get hidden => '隐藏';

  @override
  String get speed => '倍速';

  @override
  String get reset => '重置';

  @override
  String get apply => '应用';

  @override
  String get portrait => '纵向';

  @override
  String get landscape => '横向';

  @override
  String gridCrossAxisCount(String value) {
    return '$value 网格横轴数量';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '每行使用的网格图块数量 $value.';
  }

  @override
  String get showTextOnGridView => '在网格视图中显示文本';

  @override
  String get showTextOnGridViewSubtitle => '是否在网格音乐屏幕上显示文本（标题、艺术家等）。';

  @override
  String get useCoverAsBackground => '将模糊的封面应用为播放器背景';

  @override
  String get useCoverAsBackgroundSubtitle => '是否在播放器屏幕上使用模糊的封面作为背景。';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => '最小专辑封面内边距';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => '播放界面上专辑封面周围的最小内边距，以屏幕宽度的百分比表示。';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => '如果歌曲艺术家与专辑艺术家相同，则隐藏歌曲艺术家';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => '是否在专辑界面隐藏歌曲艺术家（如果他们与专辑艺术家没有区别）。';

  @override
  String get showArtistsTopTracks => '在艺术家视图中显示最热门歌曲';

  @override
  String get showArtistsTopTracksSubtitle => '显示该艺术家收听次数最多的前 5 首歌曲。';

  @override
  String get disableGesture => '禁用手势';

  @override
  String get disableGestureSubtitle => '是否禁用手势。';

  @override
  String get showFastScroller => '显示快速滚动条';

  @override
  String get theme => '主题';

  @override
  String get system => '系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get tabs => '选项卡';

  @override
  String get playerScreen => '播放界面';

  @override
  String get cancelSleepTimer => '取消睡眠定时器？';

  @override
  String get yesButtonLabel => '是';

  @override
  String get noButtonLabel => '否';

  @override
  String get setSleepTimer => '设置睡眠定时器';

  @override
  String get hours => '小时';

  @override
  String get seconds => '秒';

  @override
  String get minutes => '分钟';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime / $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return '$currentTrackIndex / $totalTrackCount';
  }

  @override
  String get invalidNumber => '无效数字';

  @override
  String get sleepTimerTooltip => '睡眠定时器';

  @override
  String sleepTimerRemainingTime(int time) {
    return '$time 分钟后睡眠';
  }

  @override
  String get addToPlaylistTooltip => '添加至播放列表';

  @override
  String get addToPlaylistTitle => '添加至播放列表';

  @override
  String get addToMorePlaylistsTooltip => '添加至更多播放列表';

  @override
  String get addToMorePlaylistsTitle => '添加至更多播放列表';

  @override
  String get removeFromPlaylistTooltip => '从此播放列表中移除';

  @override
  String get removeFromPlaylistTitle => '从此播放列表中移除';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return '从播放列表 \'$playlistName\'中移除';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return '从播放列表 \'$playlistName\'中移除';
  }

  @override
  String get newPlaylist => '新建播放列表';

  @override
  String get createButtonLabel => '创建';

  @override
  String get playlistCreated => '播放列表已创建。';

  @override
  String get playlistActionsMenuButtonTooltip => '点击可添加到播放列表。长按切换为收藏。';

  @override
  String get noAlbum => '没有专辑';

  @override
  String get noItem => '没有项目';

  @override
  String get noArtist => '没有艺术家';

  @override
  String get unknownArtist => '未知艺术家';

  @override
  String get unknownAlbum => '未知专辑';

  @override
  String get playbackModeDirectPlaying => '直通';

  @override
  String get playbackModeTranscoding => '转码';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => '本地播放';

  @override
  String get queue => '队列';

  @override
  String get addToQueue => '添加至队列';

  @override
  String get replaceQueue => '替换队列';

  @override
  String get instantMix => '即时混音';

  @override
  String get goToAlbum => '前往专辑';

  @override
  String get goToArtist => '前往艺术家';

  @override
  String get goToGenre => '前往流派';

  @override
  String get removeFavourite => '移出收藏夹';

  @override
  String get addFavourite => '加入收藏夹';

  @override
  String get confirmFavoriteAdded => '已加入收藏';

  @override
  String get confirmFavoriteRemoved => '已移出收藏';

  @override
  String get addedToQueue => '添加至队列。';

  @override
  String get insertedIntoQueue => '已插入队列。';

  @override
  String get queueReplaced => '队列已被替换。';

  @override
  String get confirmAddedToPlaylist => '已添加至播放列表。';

  @override
  String get removedFromPlaylist => '已从播放列表删除。';

  @override
  String get startingInstantMix => '生成速成合辑。';

  @override
  String get anErrorHasOccured => '发生了一个错误。';

  @override
  String responseError(String error, int statusCode) {
    return '$error 状态码 $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error 状态码 $statusCode。 这可能意味着您使用了错误的用户名/密码，或者您客户端的身份验证已失效。';
  }

  @override
  String get removeFromMix => '从混音中删除';

  @override
  String get addToMix => '添加到混音';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项重新下载的项目',
      one: '$count 项重新下载的项目',
      zero: '无需重新下载项目',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '媒体时长';

  @override
  String get bufferDurationSubtitle => '缓冲的最长时间（秒）。重启生效。';

  @override
  String get bufferDisableSizeConstraintsTitle => '不限制缓冲区大小';

  @override
  String get bufferDisableSizeConstraintsSubtitle => '禁用缓冲区大小限制（“缓冲区大小”）。缓冲区将始终按配置的持续时间（“缓冲区持续时间”）加载，即使是非常大的文件。可能会导致崩溃。重启生效。';

  @override
  String get bufferSizeTitle => '缓冲区大小';

  @override
  String get bufferSizeSubtitle => '缓冲区的最大容量（MB）。重启生效';

  @override
  String get language => '语言';

  @override
  String get skipToPreviousTrackButtonTooltip => '跳至开头或上一曲';

  @override
  String get skipToNextTrackButtonTooltip => '跳至下一曲';

  @override
  String get togglePlaybackButtonTooltip => '切换播放';

  @override
  String get previousTracks => '历史播放';

  @override
  String get nextUp => '接下来';

  @override
  String get clearNextUp => '清空接下来';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => '播放自';

  @override
  String get playNext => '下一个播放';

  @override
  String get addToNextUp => '添加至接下来';

  @override
  String get shuffleNext => '随机播放下一首';

  @override
  String get shuffleToNextUp => '随机添加至接下来队列';

  @override
  String get shuffleToQueue => '随机添加至队列';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '歌曲',
        'album': '专辑',
        'artist': '艺术家',
        'playlist': '播放列表',
        'genre': '流派',
        'other': '项目',
      },
    );
    return '$_temp0已添加到接下来队列队首';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '歌曲',
        'album': '专辑',
        'artist': '艺术家',
        'playlist': '播放列表',
        'genre': '流派',
        'other': '项目',
      },
    );
    return '$_temp0已添加到接下来队列队尾';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '歌曲',
        'album': '专辑',
        'artist': '艺术家',
        'playlist': '播放列表',
        'genre': '流派',
        'other': '项目',
      },
    );
    return '$_temp0已添加到队列队尾';
  }

  @override
  String get confirmShuffleNext => '已随机添加至下一首';

  @override
  String get confirmShuffleToNextUp => '已随机添加至接下来';

  @override
  String get confirmShuffleToQueue => '已随机添加至队列';

  @override
  String get placeholderSource => '未知';

  @override
  String get playbackHistory => '播放历史';

  @override
  String get shareOfflineListens => '分享离线收听';

  @override
  String get yourLikes => '你的喜欢';

  @override
  String mix(String mixSource) {
    return '$mixSource - 合辑';
  }

  @override
  String get tracksFormerNextUp => '歌曲已添加过接下来队列';

  @override
  String get savedQueue => '已保存的队列';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': '专辑',
        'playlist': '播放列表',
        'trackMix': '歌曲合辑',
        'artistMix': ' 艺术家合辑',
        'albumMix': '专辑合辑',
        'genreMix': '流派合辑',
        'favorites': '收藏夹',
        'allTracks': '全部歌曲',
        'filteredList': '歌曲',
        'genre': '流派',
        'artist': '艺术家',
        'track': '歌曲',
        'nextUpAlbum': '接下来专辑',
        'nextUpPlaylist': '接下来播放列表',
        'nextUpArtist': '接下来艺术家',
        'other': '',
      },
    );
    return '播放自$_temp0';
  }

  @override
  String get shuffleAllQueueSource => '随机播放';

  @override
  String get playbackOrderLinearButtonLabel => '顺序播放';

  @override
  String get playbackOrderLinearButtonTooltip => '顺序播放。点击切换至随机播放。';

  @override
  String get playbackOrderShuffledButtonLabel => '随机播放';

  @override
  String get playbackOrderShuffledButtonTooltip => '随机播放。点击切换至顺序播放。';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return '以 x$speed 倍速播放';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed 倍速';
  }

  @override
  String get playbackSpeedDecreaseLabel => '降低播放速度';

  @override
  String get playbackSpeedIncreaseLabel => '提高播放速度';

  @override
  String get loopModeNoneButtonLabel => '关闭循环';

  @override
  String get loopModeOneButtonLabel => '单曲循环';

  @override
  String get loopModeAllButtonLabel => '列表循环';

  @override
  String get queuesScreen => '恢复正在播放';

  @override
  String get queueRestoreButtonLabel => '恢复';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return '保存自 $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return '正在播放：$track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '1 首歌曲',
    );
    return '$_temp0，$remaining 首未播放';
  }

  @override
  String get queueLoadingMessage => '正在恢复队列...';

  @override
  String get queueRetryMessage => '无法恢复队列。是否重试？';

  @override
  String get autoloadLastQueueOnStartup => '自动恢复上次队列';

  @override
  String get autoloadLastQueueOnStartupSubtitle => '程序启动后，尝试恢复上次播放的队列。';

  @override
  String get reportQueueToServer => '向服务器报告当前队列';

  @override
  String get reportQueueToServerSubtitle => '启用后，Finamp 会将当前队列发送到服务器。目前看来这个功能用处不大，而且会增加网络流量。';

  @override
  String get periodicPlaybackSessionUpdateFrequency => '播放会话更新频率';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => '向服务器发送当前播放状态的频率，以秒为单位。应少于 5 分钟（300 秒），以防止会话超时。';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => '如果 Jellyfin 服务器在过去 5 分钟内没有收到来自客户端的任何更新，它会假定播放已结束。这意味着对于超过 5 分钟的歌曲，播放可能会被错误地报告为已结束，从而降低播放报告数据的质量。';

  @override
  String get topTracks => '最热门歌曲';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 张专辑',
      one: '$count 张专辑',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => '随机播放专辑';

  @override
  String get shuffleAlbumsNext => '随机选择专辑到下一首播放';

  @override
  String get shuffleAlbumsToNextUp => '随机选择所有专辑至接下来队列';

  @override
  String get shuffleAlbumsToQueue => '随机选择所有专辑至队列';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount 次播放',
      one: '$playCount 次播放',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': '专辑',
        'playlist': '播放列表',
        'trackMix': '歌曲合辑',
        'artistMix': ' 艺术家合辑',
        'albumMix': '专辑合辑',
        'genreMix': '流派合辑',
        'favorites': '最爱',
        'allTracks': '全部歌曲',
        'filteredList': '筛选列表',
        'genre': '流派',
        'artist': '艺术家',
        'track': '歌曲',
        'nextUpAlbum': '接下来专辑',
        'nextUpPlaylist': '接下来播放列表',
        'nextUpArtist': '接下来艺术家',
        'other': '',
      },
    );
    return '无法加载$_temp0';
  }

  @override
  String get confirm => '确认';

  @override
  String get close => '关闭';

  @override
  String get showUncensoredLogMessage => '该日志包含您的登录信息。显示？';

  @override
  String get resetTabs => '重置选项卡';

  @override
  String get resetToDefaults => '重置为默认值';

  @override
  String get noMusicLibrariesTitle => '没有音乐库';

  @override
  String get noMusicLibrariesBody => 'Finamp 找不到任何音乐库。请确保您的 Jellyfin 服务器至少包含一个内容类型设置为“音乐”的媒体库。';

  @override
  String get refresh => '刷新';

  @override
  String get moreInfo => '详细信息';

  @override
  String get volumeNormalizationSettingsTitle => '音量标准化';

  @override
  String get volumeNormalizationSwitchTitle => '启用音量标准化';

  @override
  String get volumeNormalizationSwitchSubtitle => '使用增益信息对歌曲的响度进行标准化处理（\"重放增益）';

  @override
  String get volumeNormalizationModeSelectorTitle => '音量标准化模式';

  @override
  String get volumeNormalizationModeSelectorSubtitle => '何时以及如何应用音量标准化';

  @override
  String get volumeNormalizationModeSelectorDescription => '混合（音轨 + 专辑）：\n音轨增益用于常规播放，但如果正在播放专辑（因为它是主要播放队列源，或者因为它在某个时刻被添加到队列中），则将使用专辑增益。\n\n基于音轨：\n无论专辑是否正在播放，始终使用音轨增益。\n\n仅限专辑：\n音量标准化仅在播放专辑时应用（使用专辑增益），但不适用于单个歌曲。';

  @override
  String get volumeNormalizationModeHybrid => '混合（音轨 + 专辑）';

  @override
  String get volumeNormalizationModeTrackBased => '基于音轨';

  @override
  String get volumeNormalizationModeAlbumBased => '基于专辑';

  @override
  String get volumeNormalizationModeAlbumOnly => '仅专辑';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => '基础增益';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => '目前，iOS 上的音量标准化需要改变播放音量来模拟增益变化。由于我们无法将音量提高到 100% 以上，因此我们需要降低默认音量，以便提高安静歌曲的音量。该值以分贝 (dB) 为单位，-10 dB 相当于 30% 的音量，-4.5 dB 相当于 60% 的音量，-2 dB 相当于 80% 的音量。';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => '播放滑动的下一首歌曲';

  @override
  String get swipeInsertQueueNextSubtitle => '在歌曲列表中滑动时，可以将歌曲作为队列中的下一个项目插入，而不是将其附加到末尾。';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => '为单个歌曲生成速成合辑';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => '启用后，点击歌曲选项卡上的歌曲将生成速成合辑，而不仅仅是播放单个歌曲。';

  @override
  String get downloadItem => '下载';

  @override
  String get repairComplete => '下载修复完成。';

  @override
  String get syncComplete => '所有下载已重新同步。';

  @override
  String get syncDownloads => '同步并下载缺失的项目。';

  @override
  String get repairDownloads => '修复下载文件或元数据的问题。';

  @override
  String get requireWifiForDownloads => '下载时需要 WiFi。';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '警告：$_temp0无法恢复至队列。';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': '运行',
        'failed': '失败',
        'syncFailed': '多次未同步',
        'enqueued': '已排队',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '下载',
      one: '下载',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return '您确定要下载库“$libraryName”的所有内容吗？';
  }

  @override
  String get onlyShowFullyDownloaded => '仅显示已完全下载的专辑';

  @override
  String get filesystemFull => '无法完成余下下载。文件系统已满。';

  @override
  String get connectionInterrupted => '连接中断，暂停下载。';

  @override
  String get connectionInterruptedBackground => '后台下载时连接中断。这可能是操作系统设置导致的。';

  @override
  String get connectionInterruptedBackgroundAndroid => '后台下载时连接中断。这可能是由于启用“暂停时进入低优先级状态”或操作系统设置导致的。';

  @override
  String get activeDownloadSize => '下载中…';

  @override
  String get missingDownloadSize => '删除中...';

  @override
  String get syncingDownloadSize => '同步中...';

  @override
  String get runRepairWarning => '无法联系服务器以完成下载迁移。恢复在线后请立即从下载屏幕运行 “修复下载”。';

  @override
  String get downloadSettings => '下载';

  @override
  String get showNullLibraryItemsTitle => '显示未知库的媒体。';

  @override
  String get showNullLibraryItemsSubtitle => '某些媒体可能通过未知库下载。关闭可将这些媒体隐藏在原始合集之外。';

  @override
  String get maxConcurrentDownloads => '最大并发下载量';

  @override
  String get maxConcurrentDownloadsSubtitle => '增加并发下载可能会增加后台下载量，但如果下载量很大，可能会导致某些下载失败，或在某些情况下造成过度延迟。';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count 个并发下载';
  }

  @override
  String get downloadsWorkersSetting => '下载工作进程数量';

  @override
  String get downloadsWorkersSettingSubtitle => '用于同步元数据和删除下载的工作进程数量。增加下载工作进程可能会加快下载同步和删除速度，尤其是在服务器延迟较高的情况下，但也可能会带来延迟。';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count 个下载工作进程';
  }

  @override
  String get syncOnStartupSwitch => '启动时自动同步下载';

  @override
  String get preferQuickSyncSwitch => '首选快速同步';

  @override
  String get preferQuickSyncSwitchSubtitle => '执行同步时，一些通常为静态的项目（如歌曲和专辑）将不会更新。下载修复将始终执行完全同步。';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '专辑',
        'playlist': '播放列表',
        'artist': '艺术家',
        'genre': '流派',
        'track': '歌曲',
        'library': '库',
        'unknown': '项目',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return '此项目必须由$parentName下载。';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': '收藏夹',
        'allPlaylists': '所有播放列表',
        'fiveLatestAlbums': '五张最新专辑',
        'allPlaylistsMetadata': '所有播放列表元数据',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return '\'$libraryName\'的缓存图片';
  }

  @override
  String get transcodingStreamingContainerTitle => '选择转码容器';

  @override
  String get transcodingStreamingContainerSubtitle => '选择流式传输转码音频时要使用的分段容器。已排队的歌曲不会受到影响。';

  @override
  String get downloadTranscodeEnableTitle => '启用转码下载';

  @override
  String get downloadTranscodeCodecTitle => '选择下载编码';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': '始终',
        'never': '从不',
        'ask': '询问',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => '下载比特率';

  @override
  String get downloadBitrateSubtitle => '比特率越高，音频质量越高，但存储空间也越大。';

  @override
  String get transcodeHint => '是否转码？';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return '下载 $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate 已转码',
      },
    );
    return '$size $codec$_temp0';
  }

  @override
  String collectionDownloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      codec,
      {
        'ORIGINAL': '',
        'other': '$codec @ $bitrate',
      },
    );
    return '$size$_temp0';
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
    return '下载原版$_temp0';
  }

  @override
  String get redownloadcomplete => '转码重下载已排队。';

  @override
  String get redownloadTitle => '自动重新下载转码';

  @override
  String get redownloadSubtitle => '自动重新下载因父合集变化而预计质量不同的歌曲。';

  @override
  String get defaultDownloadLocationButton => '设置为默认下载位置。禁用每次下载时的选择。';

  @override
  String get fixedGridSizeSwitchTitle => '使用固定大小的网格图块';

  @override
  String get fixedGridSizeSwitchSubtitle => '网格图块大小不会随窗口 / 屏幕大小而变化。';

  @override
  String get fixedGridSizeTitle => '网格图块大小';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': '小',
        'medium': '中',
        'large': '大',
        'veryLarge': '超大',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => '允许分屏模式';

  @override
  String get allowSplitScreenSubtitle => '播放界面将与其他界面一起显示在更宽的显示屏上。';

  @override
  String get enableVibration => '开启震动';

  @override
  String get enableVibrationSubtitle => '是否开启振动。';

  @override
  String get hideQueueButton => 'Hide queue button';

  @override
  String get hideQueueButtonSubtitle => 'Hide the queue button on the player screen. Swipe up to access the queue.';

  @override
  String get oneLineMarqueeTextButton => 'Auto-scroll Long Titles';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Automatically scroll track titles that are too long to display in two lines';

  @override
  String get marqueeOrTruncateButton => 'Use ellipsis for long titles';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Show ... at the end of long titles instead of scrolling text';

  @override
  String get hidePlayerBottomActions => '隐藏底部按钮';

  @override
  String get hidePlayerBottomActionsSubtitle => '隐藏播放界面上的队列和歌词按钮。向上滑动可访问队列，向左滑动（专辑封面下方）可查看歌词（如果有）。';

  @override
  String get prioritizePlayerCover => '优先显示专辑封面';

  @override
  String get prioritizePlayerCoverSubtitle => '在播放界面上优先显示更大的专辑封面。在小尺寸屏幕下，非关键控件将被更积极地隐藏。';

  @override
  String get suppressPlayerPadding => '抑制播放控件内边距';

  @override
  String get suppressPlayerPaddingSubtitle => '当专辑封面不是全尺寸时，最小化播放界面控件之间的内边距。';

  @override
  String get lockDownload => '始终保留在设备上';

  @override
  String get showArtistChipImage => '显示带有艺术家姓名的艺术家图片';

  @override
  String get showArtistChipImageSubtitle => '这会影响小尺寸艺术家图片预览，例如在播放界面上。';

  @override
  String get scrollToCurrentTrack => '滚动至当前歌曲';

  @override
  String get enableAutoScroll => '自动滚动';

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
    return '剩余 $duration';
  }

  @override
  String get removeFromPlaylistConfirm => '移除';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return '从播放列表\'$playlistName\'中移除\'$itemName\'？';
  }

  @override
  String get trackMenuButtonTooltip => '歌曲菜单';

  @override
  String get quickActions => '快捷操作';

  @override
  String get addRemoveFromPlaylist => '添加到播放列表 / 从播放列表中删除';

  @override
  String get addPlaylistSubheader => '将歌曲添加至播放列表';

  @override
  String get trackOfflineFavorites => '同步所有收藏状态';

  @override
  String get trackOfflineFavoritesSubtitle => '这样可以在离线时显示更多最新的收藏状态。 不下载任何其他文件。';

  @override
  String get allPlaylistsInfoSetting => '下载播放列表元数据';

  @override
  String get allPlaylistsInfoSettingSubtitle => '同步所有播放列表的元数据，改善播放列表体验';

  @override
  String get downloadFavoritesSetting => '下载所有收藏';

  @override
  String get downloadAllPlaylistsSetting => '下载所有播放列表';

  @override
  String get fiveLatestAlbumsSetting => '下载 5 张最新专辑';

  @override
  String get fiveLatestAlbumsSettingSubtitle => '下载内容过期后将被删除。锁定下载内容可防止专辑被删除。';

  @override
  String get cacheLibraryImagesSettings => '缓存当前库图片';

  @override
  String get cacheLibraryImagesSettingsSubtitle => '将下载当前活动音乐库中的所有专辑、艺术家、流派和播放列表封面。';

  @override
  String get showProgressOnNowPlayingBarTitle => '在应用内迷你播放器上显示歌曲播放进度';

  @override
  String get showProgressOnNowPlayingBarSubtitle => '控制音乐播放界面底部的应用内迷你播放器 / 正在播放栏是否用作进度条。';

  @override
  String get lyricsScreen => '歌词界面';

  @override
  String get showLyricsTimestampsTitle => '显示同步歌词的时间戳';

  @override
  String get showLyricsTimestampsSubtitle => '控制是否在歌词界面中显示每行歌词的时间戳（如果可用）。';

  @override
  String get showStopButtonOnMediaNotificationTitle => '在媒体通知上显示停止按钮';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => '控制媒体通知除了暂停按钮外是否还有停止按钮。这可以让你在不打开应用的情况下停止播放。';

  @override
  String get showSeekControlsOnMediaNotificationTitle => '在媒体通知上显示拖动控件';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => '控制媒体通知是否有拖动进度条。这样你就可以在不打开应用的情况下更改播放位置。';

  @override
  String get alignmentOptionStart => '左对齐';

  @override
  String get alignmentOptionCenter => '居中';

  @override
  String get alignmentOptionEnd => '右对齐';

  @override
  String get fontSizeOptionSmall => '小';

  @override
  String get fontSizeOptionMedium => '中';

  @override
  String get fontSizeOptionLarge => '大';

  @override
  String get lyricsAlignmentTitle => '歌词对齐方式';

  @override
  String get lyricsAlignmentSubtitle => '控制歌词界面中的歌词对齐方式。';

  @override
  String get lyricsFontSizeTitle => '歌词字体大小';

  @override
  String get lyricsFontSizeSubtitle => '控制歌词界面中歌词的字体大小。';

  @override
  String get showLyricsScreenAlbumPreludeTitle => '在歌词前显示专辑封面';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => '控制专辑封面在滚动之前是否显示在歌词上方。';

  @override
  String get keepScreenOn => '保持屏幕常亮';

  @override
  String get keepScreenOnSubtitle => '何时保持屏幕常亮';

  @override
  String get keepScreenOnDisabled => '禁用';

  @override
  String get keepScreenOnAlwaysOn => '始终常亮';

  @override
  String get keepScreenOnWhilePlaying => '播放音乐时常亮';

  @override
  String get keepScreenOnWhileLyrics => '显示歌词时常亮';

  @override
  String get keepScreenOnWhilePluggedIn => '仅在插入电源时保持屏幕常亮';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => '设备拔掉电源时忽略保持屏幕常亮设置';

  @override
  String get genericToggleButtonTooltip => '点击切换。';

  @override
  String get artwork => '作品';

  @override
  String artworkTooltip(String title) {
    return '$title的作品';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return '$title的作品。点击切换播放。左右滑动切换歌曲。';
  }

  @override
  String get nowPlayingBarTooltip => '打开播放界面';

  @override
  String get additionalPeople => '其他人员';

  @override
  String get playbackMode => '播放模式';

  @override
  String get codec => '编码';

  @override
  String get bitRate => '比特率';

  @override
  String get bitDepth => '位深';

  @override
  String get size => '大小';

  @override
  String get normalizationGain => '增益';

  @override
  String get sampleRate => '采样率';

  @override
  String get showFeatureChipsToggleTitle => '显示歌曲详情';

  @override
  String get showFeatureChipsToggleSubtitle => '在播放界面上显示编码，比特率等歌曲详细信息。';

  @override
  String get albumScreen => '专辑界面';

  @override
  String get showCoversOnAlbumScreenTitle => '显示歌曲的专辑封面';

  @override
  String get showCoversOnAlbumScreenSubtitle => '在专辑屏幕上分别显示每首歌曲的专辑封面。';

  @override
  String get emptyTopTracksList => '你还没有听过该艺术家的任何歌曲。';

  @override
  String get emptyFilteredListTitle => '未找到项目';

  @override
  String get emptyFilteredListSubtitle => '没有符合筛选条件的项目。请尝试关闭筛选条件或更改搜索词。';

  @override
  String get resetFiltersButton => '重置筛选条件';

  @override
  String get resetSettingsPromptGlobal => '你确定要将所有设置重置为默认值吗？';

  @override
  String get resetSettingsPromptGlobalConfirm => '重置全部设置';

  @override
  String get resetSettingsPromptLocal => '你想将这些设置重置为默认值吗？';

  @override
  String get genericCancel => '取消';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '专辑',
        'playlist': '播放列表',
        'artist': '艺术家',
        'genre': '流派',
        'track': '歌曲',
        'library': '库',
        'other': '项目',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': '设备',
        'server': '服务器',
        'other': 'unknown',
      },
    );
    return '$_temp0 被删除自 $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Allow deletion from server';

  @override
  String get allowDeleteFromServerSubtitle => 'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '专辑',
        'playlist': '播放列表',
        'artist': '艺术家',
        'genre': '流派',
        'track': '歌曲',
        'library': '库',
        'other': 'item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': '这也将从设备中删除此项目。',
        'cantDelete': '此项目将保留在此设备上，直到下次同步。',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': '此设备',
        'server': '此服务器文件系统和库。$_temp1\n该操作不可撤销',
        'other': '',
      },
    );
    return '你将删除此$_temp0自$_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': '从设备中',
        'server': '从服务器中',
        'other': '',
      },
    );
    return '$_temp0删除';
  }

  @override
  String largeDownloadWarning(int count) {
    return '警告： 您将下载 $count 首歌曲。';
  }

  @override
  String get downloadSizeWarningCutoff => '下载文件大小警告';

  @override
  String get downloadSizeWarningCutoffSubtitle => '如果一次下载的歌曲超过此数量，系统将显示警告信息。';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '专辑',
        'playlist': '播放列表',
        'artist': '艺术家',
        'genre': '流派',
        'other': 'item',
      },
    );
    return '您确定要将$_temp0 \'$itemName\'中的所有歌曲添加到此播放列表吗？  只能单独删除它们。';
  }

  @override
  String get publiclyVisiblePlaylist => '公开可见：';

  @override
  String get releaseDateFormatYear => 'Year';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Month & Year';

  @override
  String get releaseDateFormatMonthDayYear => 'Month, Day & Year';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Show Album Release Date on Player Screen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Show the release date of the album on the player screen, behind the album name.';

  @override
  String get releaseDateFormatTitle => 'Release Date Format';

  @override
  String get releaseDateFormatSubtitle => 'Controls the format of all release dates shown in the app.';

  @override
  String get librarySelectError => 'Error loading available libraries for user';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant(): super('zh_Hant');

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => '一個開源的 Jellyfin 音樂播放器';

  @override
  String startupError(String error) {
    return '應用程式啓動時出現問題！ 錯誤訊息：$error\n\n請在 github.com/UnicornsOnLSD/finamp 上提出一個 Github 問題，並附上此頁面的螢幕截圖。 如果此頁面一直顯示，請清除您的應用程式資料以重置應用程式。';
  }

  @override
  String get about => '關於 Finamp';

  @override
  String get aboutContributionPrompt => '由一群超棒的人在空閒時間完成。\n你也可以成為其中一員！';

  @override
  String get aboutContributionLink => '在 GitHub 上為 Finamp 做出貢獻：';

  @override
  String get aboutReleaseNotes => '閱讀最新的版本說明：';

  @override
  String get aboutTranslations => '協助將 Finamp 翻譯成您的語言：';

  @override
  String get aboutThanks => '感謝您使用 Finamp！';

  @override
  String get loginFlowWelcomeHeading => '歡迎來到';

  @override
  String get loginFlowSlogan => '你的音樂，由你決定。';

  @override
  String get loginFlowGetStarted => '開始使用！';

  @override
  String get viewLogs => '檢視 Logs';

  @override
  String get changeLanguage => '變更語言';

  @override
  String get loginFlowServerSelectionHeading => '連線至 Jellyfin';

  @override
  String get back => '返回';

  @override
  String get serverUrl => '伺服器 URL';

  @override
  String get internalExternalIpExplanation => '如果您希望能夠遠程訪問您的 Jellyfin 伺服器，則需要使用您的外部 IP。\n\n如果您的伺服器位於 HTTP 端口 (80/443) 上，則不必指定端口。 如果您的伺服器位於反向代理後面，則可能會出現這種情況。\n\n如果網址正確，輸入欄位下方應該會出現一些關於你的伺服器的相關資訊。';

  @override
  String get serverUrlHint => '例如：demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => '伺服器URL 說明';

  @override
  String get emptyServerUrl => '伺服器 URL 不能為空';

  @override
  String get connectingToServer => '正在連線至伺服器中...';

  @override
  String get loginFlowLocalNetworkServers => '區域網路上的伺服器：';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => '正在掃描伺服器...';

  @override
  String get loginFlowAccountSelectionHeading => '選擇您的帳號';

  @override
  String get backToServerSelection => '返回伺服器選擇';

  @override
  String get loginFlowNamelessUser => '未命名使用者';

  @override
  String get loginFlowCustomUser => '自訂使用者';

  @override
  String get loginFlowAuthenticationHeading => '登入您的帳號';

  @override
  String get backToAccountSelection => '返回帳號選擇';

  @override
  String get loginFlowQuickConnectPrompt => '使用快速連接代碼';

  @override
  String get loginFlowQuickConnectInstructions => '打開 Jellyfin 應用程式或網站，點擊你的用戶圖示，然後選擇「快速連線」。';

  @override
  String get loginFlowQuickConnectDisabled => '快速連接已在此伺服器上停用。';

  @override
  String get orDivider => '或';

  @override
  String get loginFlowSelectAUser => '選擇使用者';

  @override
  String get username => '使用者名稱';

  @override
  String get usernameHint => '請輸入您的使用者名稱';

  @override
  String get usernameValidationMissingUsername => '請輸入使用者名稱';

  @override
  String get password => '密碼';

  @override
  String get passwordHint => '請輸入您的密碼';

  @override
  String get login => '登入';

  @override
  String get logs => '紀錄檔';

  @override
  String get next => '下一個';

  @override
  String get selectMusicLibraries => '選擇音樂媒體庫';

  @override
  String get couldNotFindLibraries => '找不到任何媒體庫。';

  @override
  String get unknownName => '未知名稱';

  @override
  String get tracks => '歌曲';

  @override
  String get albums => '專輯';

  @override
  String get artists => '藝人';

  @override
  String get genres => '風格';

  @override
  String get playlists => '播放清單';

  @override
  String get startMix => '生成組合';

  @override
  String get startMixNoTracksArtist => '長按藝人可將其加入或移除組合清單，準備好後再開始組合';

  @override
  String get startMixNoTracksAlbum => '長按專輯可將其加入或移除組合清單，準備好後再開始組合';

  @override
  String get startMixNoTracksGenre => '長按一個曲風可將其加入或移除組合清單，準備好後再開始組合';

  @override
  String get music => '音樂';

  @override
  String get clear => '清除';

  @override
  String get favourites => '我的最愛';

  @override
  String get shuffleAll => '全部隨機播放';

  @override
  String get downloads => '下載';

  @override
  String get settings => '設置';

  @override
  String get offlineMode => '離線模式';

  @override
  String get sortOrder => '排序';

  @override
  String get sortBy => '排序方式';

  @override
  String get title => '標題';

  @override
  String get album => '專輯';

  @override
  String get albumArtist => '專輯藝人';

  @override
  String get artist => '歌手';

  @override
  String get budget => '預算';

  @override
  String get communityRating => '聽眾評級';

  @override
  String get criticRating => '評論家評級';

  @override
  String get dateAdded => '添加日期';

  @override
  String get datePlayed => '播放日期';

  @override
  String get playCount => '播放計數';

  @override
  String get premiereDate => '首播日期';

  @override
  String get productionYear => '製作年份';

  @override
  String get name => '名稱';

  @override
  String get random => '隨機';

  @override
  String get revenue => '收入';

  @override
  String get runtime => '運行時';

  @override
  String get syncDownloadedPlaylists => '同步已下載的播放清';

  @override
  String get downloadMissingImages => '下載缺少的圖片';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已下載 $count 張缺少的圖片',
      one: '已下載 $count 張缺少的圖片',
      zero: '未找到缺少的圖片',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => '正在下載中';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個下載',
      one: '$count 個下載',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount 首歌曲',
      one: '$trackCount 首歌曲',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount 張圖片',
      one: '$imageCount 張圖片',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount 個節點同步中',
      one: '$syncCount 個節點同步中',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\n目前正在修復',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count 完成';
  }

  @override
  String dlFailed(int count) {
    return '$count 失敗';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 已入隊';
  }

  @override
  String dlRunning(int count) {
    return '$count 運行中';
  }

  @override
  String get activeDownloadsTitle => '正在下載';

  @override
  String get noActiveDownloads => '目前沒有正在下載的項目。';

  @override
  String get errorScreenError => '獲取錯誤列表時出錯！您可以在 GitHub 上提出問題並清除應用程式資料';

  @override
  String get failedToGetTrackFromDownloadId => '從下載 ID 獲取歌曲失敗';

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
    return '你確定要將 $_temp0 「$itemName」從此裝置上刪除嗎？';
  }

  @override
  String get deleteDownloadsConfirmButtonText => '刪除';

  @override
  String get error => '錯誤';

  @override
  String discNumber(int number) {
    return '唱片 $number';
  }

  @override
  String get playButtonLabel => '播放';

  @override
  String get shuffleButtonLabel => '隨機播放';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0，$downloads 次下載';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '$_temp0 已下載';
  }

  @override
  String get editPlaylistNameTooltip => '編輯播放清單名稱';

  @override
  String get editPlaylistNameTitle => '編輯播放清單名稱';

  @override
  String get required => '必需的';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => '播放清單名稱已更新。';

  @override
  String get favourite => '我的最愛';

  @override
  String get downloadsDeleted => '已刪除下載。';

  @override
  String get addDownloads => '添加下載';

  @override
  String get location => '位置';

  @override
  String get confirmDownloadStarted => '下載已開始';

  @override
  String get downloadsQueued => '已準備好下載，正在下載檔案';

  @override
  String get addButtonLabel => '添加';

  @override
  String get shareLogs => '分享紀錄檔';

  @override
  String get logsCopied => '已複製紀錄檔。';

  @override
  String get message => '消息';

  @override
  String get stackTrace => '堆棧跟蹤';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return '依照 Mozilla 公開授權條款 2.0 授權。\n原始碼可於 $sourceCodeLink 獲得。';
  }

  @override
  String get transcoding => '轉碼';

  @override
  String get downloadLocations => '下載位置';

  @override
  String get audioService => '音頻服務';

  @override
  String get interactions => '互動';

  @override
  String get layoutAndTheme => '佈局和主題';

  @override
  String get notAvailableInOfflineMode => '在離線模式下不能使用';

  @override
  String get logOut => '登出';

  @override
  String get downloadedTracksWillNotBeDeleted => '下載的歌曲不會被刪除';

  @override
  String get areYouSure => '你確定嗎？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin 使用 AAC 進行轉碼';

  @override
  String get enableTranscoding => '啓用轉碼';

  @override
  String get enableTranscodingSubtitle => '如果啓用，音樂串流將由伺服器轉碼。';

  @override
  String get bitrate => '位元速率';

  @override
  String get bitrateSubtitle => '更高的位元速率可提升音訊品質，但也會消耗更多的頻寬。';

  @override
  String get customLocation => '自定義位置';

  @override
  String get appDirectory => '應用目錄';

  @override
  String get addDownloadLocation => '添加下載路徑';

  @override
  String get selectDirectory => '選擇目錄';

  @override
  String get unknownError => '未知錯誤';

  @override
  String get pathReturnSlashErrorMessage => '不能使用返回“/”的路徑';

  @override
  String get directoryMustBeEmpty => '目錄必須為空';

  @override
  String get customLocationsBuggy => '自訂位置可能會導致嚴重錯誤，通常不建議使用。存放於系統「音樂」資料夾內的位置，因作業系統的限制，無法儲存專輯封面。';

  @override
  String get enterLowPriorityStateOnPause => '暫停時進入低優先級狀態';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => '啓用後，通知可以在暫停時滑動。 啓用此功能還允許 Android 在暫停時終止服務。';

  @override
  String get shuffleAllTrackCount => '隨機播放所有歌曲次數';

  @override
  String get shuffleAllTrackCountSubtitle => '使用隨機播放按鈕時載入的歌曲數量。';

  @override
  String get viewType => '顯示類型';

  @override
  String get viewTypeSubtitle => '音樂螢幕的顯示類型';

  @override
  String get list => '列表';

  @override
  String get grid => '網格';

  @override
  String get customizationSettingsTitle => '客製化';

  @override
  String get playbackSpeedControlSetting => '播放速度可見性';

  @override
  String get playbackSpeedControlSettingSubtitle => '播放速度控制是否顯示在播放器介面的選單中';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return '自動：\nFinamp 會根據音軌是否符合以下條件，自動判斷其為podcast或有聲書的一部分：音軌時長超過 $trackDuration 分鐘、專輯總時長超過 $albumDuration 小時，或曲風包含以下任一項：$genreList。\n播放速度控制選單將會顯示於播放器介面中。\n\n顯示:\n播放介面選單中的播放速度控制功能將一律保持顯示。\n\n隱藏：\n播放介面選單中的播放速度控制功能將一律保持隱藏。';
  }

  @override
  String get automatic => '自動';

  @override
  String get shown => '顯示';

  @override
  String get hidden => '隱藏';

  @override
  String get speed => '速度';

  @override
  String get reset => '重置';

  @override
  String get apply => '套用';

  @override
  String get portrait => '縱向';

  @override
  String get landscape => '橫向';

  @override
  String gridCrossAxisCount(String value) {
    return '$value 網格橫軸數量';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '每行使用的網格圖塊數量 $value.';
  }

  @override
  String get showTextOnGridView => '在網格顯示上顯示文字';

  @override
  String get showTextOnGridViewSubtitle => '是否在網格音樂螢幕上顯示文字（標題、歌手等）。';

  @override
  String get useCoverAsBackground => '將模糊的封面應用為播放器背景';

  @override
  String get useCoverAsBackgroundSubtitle => '是否在 App 的各個介面使用模糊化的專輯封面作為背景。';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => '專輯封面最小邊距';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => '專輯封面在播放器介面上的最小間隔距離，以螢幕寬度的百分比計算。';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => '如果與專輯藝人相同，則隱藏歌曲藝人';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => '當歌曲藝人與專輯藝人相同時，是否在專輯介面顯示歌曲藝人。';

  @override
  String get showArtistsTopTracks => '在藝人介面顯示熱門歌曲';

  @override
  String get showArtistsTopTracksSubtitle => '是否顯示某位藝人最常收聽的前五首歌曲。';

  @override
  String get disableGesture => '禁用手勢';

  @override
  String get disableGestureSubtitle => '是否禁用「手勢」功能。';

  @override
  String get showFastScroller => '顯示快速滾動條';

  @override
  String get theme => '主題';

  @override
  String get system => '系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get tabs => '選項卡';

  @override
  String get playerScreen => '播放器介面';

  @override
  String get cancelSleepTimer => '取消睡眠定時器？';

  @override
  String get yesButtonLabel => '是';

  @override
  String get noButtonLabel => '否';

  @override
  String get setSleepTimer => '設置睡眠定時器';

  @override
  String get hours => '小時';

  @override
  String get seconds => '秒';

  @override
  String get minutes => '分鍾';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime / $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return '第 $currentTrackIndex 首，共 $totalTrackCount 首';
  }

  @override
  String get invalidNumber => '無效數字';

  @override
  String get sleepTimerTooltip => '睡眠定時器';

  @override
  String sleepTimerRemainingTime(int time) {
    return '$time 分鐘後進入睡眠';
  }

  @override
  String get addToPlaylistTooltip => '添加至播放清單';

  @override
  String get addToPlaylistTitle => '添加至播放清單';

  @override
  String get addToMorePlaylistsTooltip => '新增至更多播放清單';

  @override
  String get addToMorePlaylistsTitle => '新增至更多播放清單';

  @override
  String get removeFromPlaylistTooltip => '從播放清單中移除歌曲';

  @override
  String get removeFromPlaylistTitle => '從播放清單中移除';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return '從播放清單「 \'$playlistName\'」移除';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return '從播放清單「 \'$playlistName\'」移除';
  }

  @override
  String get newPlaylist => '建立播放清單';

  @override
  String get createButtonLabel => '建立';

  @override
  String get playlistCreated => '已建立播放清單。';

  @override
  String get playlistActionsMenuButtonTooltip => '點擊以新增到播放清單。長按以切換收藏狀態。';

  @override
  String get noAlbum => '無專輯';

  @override
  String get noItem => '無項目';

  @override
  String get noArtist => '無歌手';

  @override
  String get unknownArtist => '未知歌手';

  @override
  String get unknownAlbum => '未知專輯';

  @override
  String get playbackModeDirectPlaying => '原生播放';

  @override
  String get playbackModeTranscoding => '轉碼';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => '本地播放';

  @override
  String get queue => '播放佇列';

  @override
  String get addToQueue => '加入至播放佇列';

  @override
  String get replaceQueue => '更換佇列';

  @override
  String get instantMix => '即時組合';

  @override
  String get goToAlbum => '前往專輯';

  @override
  String get goToArtist => '前往藝人';

  @override
  String get goToGenre => '前往曲風';

  @override
  String get removeFavourite => '刪除我的最愛';

  @override
  String get addFavourite => '添加至我的最愛';

  @override
  String get confirmFavoriteAdded => '已收藏';

  @override
  String get confirmFavoriteRemoved => '已移除收藏';

  @override
  String get addedToQueue => '已加入至播放佇列。';

  @override
  String get insertedIntoQueue => '完成加入至待播清單。';

  @override
  String get queueReplaced => '佇列已被取代。';

  @override
  String get confirmAddedToPlaylist => '已新增至播放清單。';

  @override
  String get removedFromPlaylist => '已從播放清單中移除。';

  @override
  String get startingInstantMix => '開始即時組合。';

  @override
  String get anErrorHasOccured => '發生了一個錯誤。';

  @override
  String responseError(String error, int statusCode) {
    return '$error 狀態碼 $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error 狀態碼 $statusCode。 這可能意味著您使用了錯誤的用戶名/密碼，或者您客戶端的身份驗證已失效。';
  }

  @override
  String get removeFromMix => '從組合中刪除';

  @override
  String get addToMix => '添加到組合';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已重新下載$count個項目',
      one: '已重新下載$count個項目',
      zero: '沒有需要重新下載的項目。',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '緩衝時長';

  @override
  String get bufferDurationSubtitle => '最大緩衝持續時間（秒）。變更後需重新啟動。';

  @override
  String get bufferDisableSizeConstraintsTitle => '不要限制緩衝區大小';

  @override
  String get bufferDisableSizeConstraintsSubtitle => '關閉「緩衝區大小」的限制，無論檔案大小多大，緩衝區都會依照設定的「緩衝區持續時間」載入。不過，這可能會導致程式當機，並且需要重新啟動才能生效。';

  @override
  String get bufferSizeTitle => '緩衝區大小';

  @override
  String get bufferSizeSubtitle => '緩衝區最大值 (MB)，變更後請重新啟動系統';

  @override
  String get language => '語言';

  @override
  String get skipToPreviousTrackButtonTooltip => '從頭播放或切換至前一首';

  @override
  String get skipToNextTrackButtonTooltip => '切換到下一首';

  @override
  String get togglePlaybackButtonTooltip => '切換播放狀態';

  @override
  String get previousTracks => '先前歌曲';

  @override
  String get nextUp => '即將播放';

  @override
  String get clearNextUp => '取消播放下一首';

  @override
  String get playingFrom => '播放自';

  @override
  String get playNext => '下一首';

  @override
  String get addToNextUp => '添加至下一首';

  @override
  String get shuffleNext => '隨機播放下一首';

  @override
  String get shuffleToNextUp => '隨機加入「即將播放」佇列末端';

  @override
  String get shuffleToQueue => '隨機加入佇列末端';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '歌曲',
        'album': '專輯',
        'artist': '藝人',
        'playlist': '播放清單',
        'genre': '曲風',
        'other': '項目',
      },
    );
    return '已將$_temp0新增至播放佇列，將會在下一首播放';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '歌曲',
        'album': '專輯',
        'artist': '藝人',
        'playlist': '播放清單',
        'genre': '曲風',
        'other': '項目',
      },
    );
    return '已將 $_temp0 新增至「即將播放」';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '歌曲',
        'album': '專輯',
        'artist': '歌手',
        'playlist': '播放清單',
        'genre': '曲風',
        'other': '項目',
      },
    );
    return '已將$_temp0新增至播放佇列';
  }

  @override
  String get confirmShuffleNext => '已隨機排列至下一首';

  @override
  String get confirmShuffleToNextUp => '已隨機排列至即將播放';

  @override
  String get confirmShuffleToQueue => '已隨機排序並加入佇列';

  @override
  String get placeholderSource => '未知來源';

  @override
  String get playbackHistory => '播放記錄';

  @override
  String get shareOfflineListens => '分享離線收聽';

  @override
  String get yourLikes => '你的最愛';

  @override
  String mix(String mixSource) {
    return '$mixSource - 合輯';
  }

  @override
  String get tracksFormerNextUp => '已加入過即將播放佇列的歌曲';

  @override
  String get savedQueue => '已儲存的佇列';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': '專輯',
        'playlist': '播放清單',
        'trackMix': '單曲組合',
        'artistMix': '藝人組合',
        'albumMix': '專輯組合',
        'genreMix': '類型組合',
        'favorites': '我的最愛',
        'allTracks': '所有歌曲',
        'filteredList': '篩選歌曲',
        'genre': '曲風',
        'artist': '藝人',
        'track': '單曲',
        'nextUpAlbum': '即將播放的專輯',
        'nextUpPlaylist': '即將播放的播放清單',
        'nextUpArtist': '即將播放的藝人',
        'other': '',
      },
    );
    return '播放自 $_temp0';
  }

  @override
  String get shuffleAllQueueSource => '隨機播放';

  @override
  String get playbackOrderLinearButtonLabel => '依序播放';

  @override
  String get playbackOrderLinearButtonTooltip => '目前為依序播放。點擊切換隨機播放。';

  @override
  String get playbackOrderShuffledButtonLabel => '隨機播放';

  @override
  String get playbackOrderShuffledButtonTooltip => '目前為隨機播放，點擊切換依序播放。';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return '以 x$speed 倍速播放';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed 倍速';
  }

  @override
  String get playbackSpeedDecreaseLabel => '降低播放速度';

  @override
  String get playbackSpeedIncreaseLabel => '提升播放速度';

  @override
  String get loopModeNoneButtonLabel => '關閉循環';

  @override
  String get loopModeOneButtonLabel => '單曲循環';

  @override
  String get loopModeAllButtonLabel => '全部循環';

  @override
  String get queuesScreen => '恢復正在播放';

  @override
  String get queueRestoreButtonLabel => '恢復';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString 已儲存';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return '正在播放：$track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '1 首歌曲',
    );
    return '$_temp0，$remaining 首未播放';
  }

  @override
  String get queueLoadingMessage => '正在恢復播放佇列...';

  @override
  String get queueRetryMessage => '無法還原佇列。是否要重試？';

  @override
  String get autoloadLastQueueOnStartup => '自動恢復上次佇列';

  @override
  String get autoloadLastQueueOnStartupSubtitle => '應用程式啟動時，嘗試恢復上次播放佇列。';

  @override
  String get reportQueueToServer => '將當前佇列回報至伺服器？';

  @override
  String get reportQueueToServerSubtitle => '啟用後，Finamp 會將當前播放佇列回報至 Jellyfin 伺服器。目前此功能的實際用途有限，且可能增加網路流量。';

  @override
  String get periodicPlaybackSessionUpdateFrequency => '播放狀態更新頻率';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => '設定向 Jellyfin 伺服器回報當前播放狀態頻率（秒）的進階細節。設定向伺服器回報當前播放狀態的頻率（以秒計算）。此數值應小於 5 分鐘（300 秒），以防止會話逾時。';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => '調整目前播放狀態向 Jellyfin 伺服器回報頻率（秒數）的進階細節。若 Jellyfin 伺服器在過去 5 分鐘內未收到來自客戶端的更新，則會假設播放已結束。這表示對於長度超過 5 分鐘的歌曲，系統可能會錯誤地判定播放已結束，從而降低播放回報數據的準確性。';

  @override
  String get topTracks => '熱門歌曲';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 張專輯',
      one: '$count 張專輯',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => '隨機播放專輯';

  @override
  String get shuffleAlbumsNext => '隨機選擇專輯並設為下一首播放';

  @override
  String get shuffleAlbumsToNextUp => '隨機選擇專輯加入即將播放清單';

  @override
  String get shuffleAlbumsToQueue => '隨機播放專輯並優先加入播放佇列';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount 次播放',
      one: '$playCount 次播放',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': '專輯',
        'playlist': '播放清單',
        'trackMix': '歌曲組合',
        'artistMix': '藝人組合',
        'albumMix': '專輯組合',
        'genreMix': '類型組合',
        'favorites': '我的最愛',
        'allTracks': '所有歌曲',
        'filteredList': '篩選後的歌曲',
        'genre': '曲風',
        'artist': '藝人',
        'track': '歌曲',
        'nextUpAlbum': '即將播放的專輯',
        'nextUpPlaylist': '即將播放的播放清單',
        'nextUpArtist': '即將播放的藝人',
        'other': '',
      },
    );
    return '無法載入 $_temp0';
  }

  @override
  String get confirm => '確認';

  @override
  String get close => '關閉';

  @override
  String get showUncensoredLogMessage => '此記錄包含你的登入資訊。是否顯示？';

  @override
  String get resetTabs => '重置分頁';

  @override
  String get resetToDefaults => '恢復預設值';

  @override
  String get noMusicLibrariesTitle => '尚無音樂媒體庫';

  @override
  String get noMusicLibrariesBody => '找不到音樂媒體庫。請確保 Jellyfin 中至少有一個媒體庫的類別需設置成\"音樂\"。';

  @override
  String get refresh => '重新整理';

  @override
  String get moreInfo => '詳細資訊';

  @override
  String get volumeNormalizationSettingsTitle => '音量標準化';

  @override
  String get volumeNormalizationSwitchTitle => '啟用音量標準化';

  @override
  String get volumeNormalizationSwitchSubtitle => '使用增益資訊來標準化歌曲的音量（「重放增益」）';

  @override
  String get volumeNormalizationModeSelectorTitle => '音量標準化模式';

  @override
  String get volumeNormalizationModeSelectorSubtitle => '音量正規化的適用時機與方法';

  @override
  String get volumeNormalizationModeSelectorDescription => '混合模式（單曲 + 專輯）：\n平常播放單曲時會套用單曲音軌增益，確保每首歌曲音量適中。然而，當整張專輯作為播放來源（或是曾經被加入播放佇列）時，將優先使用專輯音軌增益，以維持專輯內歌曲的音量平衡。\n\n依音軌調整：\n不論當前播放的是單曲或是完整專輯，皆使用音軌增益調整音量。\n\n依專輯調整：\n僅在播放完整專輯時套用音軌增益（基於專輯增益），單獨播放歌曲時不會調整音量。';

  @override
  String get volumeNormalizationModeHybrid => '混合模式（單曲 + 專輯）';

  @override
  String get volumeNormalizationModeTrackBased => '基於歌曲';

  @override
  String get volumeNormalizationModeAlbumBased => '以專輯為基準';

  @override
  String get volumeNormalizationModeAlbumOnly => '僅用於專輯';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => '基礎增益';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => '在 iOS 上，音量標準化的實作方式是透過調整播放音量來模擬增益變化。由於無法將音量提高超過 100%，我們預設會先降低音量，使較安靜的音軌在需要時能夠獲得額外的音量提升。該數值以分貝（dB）為單位，-10 dB 對應約 30% 音量，-4.5 dB 對應約 60% 音量，而 -2 dB 對應約 80% 音量。';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => '滑動接續播放歌曲';

  @override
  String get swipeInsertQueueNextSubtitle => '開啟後滑動清單中的歌曲，可以將歌曲接著播放，而不是加到播放清單的最後一首。';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => '為單曲啟動即時組合';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => '開啟此功能後，在「歌曲」標籤頁點擊某首歌曲時，系統將會立即產生該歌曲的即時組合，而非僅播放該歌曲本身。';

  @override
  String get downloadItem => '下載';

  @override
  String get repairComplete => '下載修復完成。';

  @override
  String get syncComplete => '所有下載內容已重新同步完成。';

  @override
  String get syncDownloads => '同步並下載缺少的項目。';

  @override
  String get repairDownloads => '修復已下載檔案或中繼資料的問題。';

  @override
  String get requireWifiForDownloads => '僅在 Wi-Fi 環境下允許下載。';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      one: '$count 首歌曲',
    );
    return '警告：$_temp0 無法重新加入播放佇列。';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': '下載中',
        'failed': '下載失敗',
        'syncFailed': '同步異常',
        'enqueued': '排隊等待',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '下載項目',
      one: '下載項目',
    );
    return '$itemCount 個$_temp0的$_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return '您確定要下載整個媒體庫 $libraryName 的所有內容嗎？';
  }

  @override
  String get onlyShowFullyDownloaded => '僅顯示完全下載的專輯';

  @override
  String get filesystemFull => '剩餘的下載無法完成，檔案系統空間已用盡。';

  @override
  String get connectionInterrupted => '連線中斷，暫停下載。';

  @override
  String get connectionInterruptedBackground => '連線在背景下載時中斷，這可能是作業系統設定導致的，請確認您的系統允許背景下載。';

  @override
  String get connectionInterruptedBackgroundAndroid => '背景下載時發生連線中斷。這可能是由於您啟用了「暫停時進入低優先級狀態」或作業系統的設定限制了背景下載，請確認相關設定。';

  @override
  String get activeDownloadSize => '正在下載···';

  @override
  String get missingDownloadSize => '正在刪除···';

  @override
  String get syncingDownloadSize => '正在同步···';

  @override
  String get runRepairWarning => '無法聯繫伺服器以完成下載遷移。請在您恢復網路連線後，立即從下載畫面執行「修復下載」。';

  @override
  String get downloadSettings => '下載';

  @override
  String get showNullLibraryItemsTitle => '顯示未知媒體庫中的媒體。';

  @override
  String get showNullLibraryItemsSubtitle => '某些媒體可能來自未知媒體庫。關閉此選項可將這些媒體隱藏，使其僅顯示於原始收藏中。';

  @override
  String get maxConcurrentDownloads => '最大同時下載數量';

  @override
  String get maxConcurrentDownloadsSubtitle => '調高同時下載的數量可能增加背景下載的速度，但當下載檔案過大時，可能會導致部分下載失敗，或在特定情況下造成顯著的延遲。';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '最大同時下載數：$count';
  }

  @override
  String get downloadsWorkersSetting => '下載工作執行緒數量';

  @override
  String get downloadsWorkersSettingSubtitle => '設定同步下載中繼資料與刪除檔案時所使用的執行緒數量。當伺服器延遲較高時，提高此數值可提升下載同步與刪除的速度，但可能會導致系統運作延遲。';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count 個下載工作執行緒';
  }

  @override
  String get syncOnStartupSwitch => '啟動時自動同步下載';

  @override
  String get preferQuickSyncSwitch => '優先快速同步';

  @override
  String get preferQuickSyncSwitchSubtitle => '在進行同步時，某些靜態內容（例如歌曲與專輯）不會更新。若執行下載修復，則將強制進行完整同步。';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '專輯',
        'playlist': '播放清單',
        'artist': '藝人',
        'genre': '曲風',
        'track': '音軌',
        'library': '音樂媒體庫',
        'unknown': '項目',
        'other': '$itemType',
      },
    );
    return '$_temp0 - $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return '此項目必須由 $parentName 下載。';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': '我的最愛',
        'allPlaylists': '全部播放清單',
        'fiveLatestAlbums': '最新5張專輯',
        'allPlaylistsMetadata': '清單資訊',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return '\'$libraryName\'的快取影像';
  }

  @override
  String get transcodingStreamingContainerTitle => '選擇轉碼器格式';

  @override
  String get transcodingStreamingContainerSubtitle => '選擇串流轉碼音訊時要使用的區段容器。已排入佇列的歌曲將不受影響。';

  @override
  String get downloadTranscodeEnableTitle => '啟用轉碼下載';

  @override
  String get downloadTranscodeCodecTitle => '選擇下載用的轉碼器';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': '總是',
        'never': '從不',
        'ask': '詢問',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => '下載位元速率';

  @override
  String get downloadBitrateSubtitle => '提高位元速率可提升音訊品質，但同時會佔用更多儲存空間。';

  @override
  String get transcodeHint => '是否要轉碼？';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return '下載 格式：$codec，位元率：@$bitrate，大小：$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate 已轉碼',
      },
    );
    return '$size $codec$_temp0';
  }

  @override
  String collectionDownloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      codec,
      {
        'ORIGINAL': '',
        'other': ' $codec @ $bitrate',
      },
    );
    return '$size$_temp0';
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
    return '下載原始$_temp0';
  }

  @override
  String get redownloadcomplete => '已排程轉碼重新下載。';

  @override
  String get redownloadTitle => '自動重新下載轉碼';

  @override
  String get redownloadSubtitle => '自動重新下載因為上級改變而可能為更高品質的音軌。';

  @override
  String get defaultDownloadLocationButton => '設定為預設下載路徑。停用此選項以為每個下載分開指定。';

  @override
  String get fixedGridSizeSwitchTitle => '使用固定大小的網格';

  @override
  String get fixedGridSizeSwitchSubtitle => '網格大小不會隨著視窗/畫面大小改變。';

  @override
  String get fixedGridSizeTitle => '網格大小';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': '小',
        'medium': '中',
        'large': '大',
        'veryLarge': '非常大',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => '允許分割畫面';

  @override
  String get allowSplitScreenSubtitle => '在寬螢幕環境下，播放器將與其他介面一同顯示。';

  @override
  String get enableVibration => '啟用震動';

  @override
  String get enableVibrationSubtitle => '是否啟用震動。';

  @override
  String get hideQueueButton => '隱藏隊列按鈕';

  @override
  String get hideQueueButtonSubtitle => '隱藏播放器畫面的隊列按鈕。向上滑動以存取隊列。';

  @override
  String get oneLineMarqueeTextButton => '自動捲動較長的標題';

  @override
  String get oneLineMarqueeTextButtonSubtitle => '自動捲動長度超過兩行的標題';

  @override
  String get marqueeOrTruncateButton => '在較長的標題使用刪節號';

  @override
  String get marqueeOrTruncateButtonSubtitle => '在較長的標題盡頭顯示 ... 代替捲動文字';

  @override
  String get hidePlayerBottomActions => '隱藏底部按鈕';

  @override
  String get hidePlayerBottomActionsSubtitle => '隱藏播放器畫面的佇列與歌詞按鈕。欲查看播放佇列，請向上滑動；若該歌曲支援歌詞，請在專輯封面下方向左滑動以顯示。';

  @override
  String get prioritizePlayerCover => '優先顯示專輯封面';

  @override
  String get prioritizePlayerCoverSubtitle => '播放器介面將優先顯示較大的專輯封面顯示，而在較小螢幕上，非必要的操作介面將進一步隱藏，以提升視覺體驗。';

  @override
  String get suppressPlayerPadding => '抑制播放器控制元件之間的距離';

  @override
  String get suppressPlayerPaddingSubtitle => '在專輯封面未達全尺寸時，減少播放器介面控制項的內邊距。';

  @override
  String get lockDownload => '永遠保留在裝置上';

  @override
  String get showArtistChipImage => '和藝術家名字一起顯示藝術家圖片';

  @override
  String get showArtistChipImageSubtitle => '這會影響小尺寸的藝術家圖片預覽，例如在播放介面上。';

  @override
  String get scrollToCurrentTrack => '捲動至當前歌曲';

  @override
  String get enableAutoScroll => '自動捲動';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz kHz';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit 位元';
  }

  @override
  String remainingDuration(String duration) {
    return '剩餘 $duration';
  }

  @override
  String get removeFromPlaylistConfirm => '移除';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return '是否確定從播放清單「$playlistName」中移除「$itemName」？';
  }

  @override
  String get trackMenuButtonTooltip => '歌曲選單';

  @override
  String get quickActions => '快速動作';

  @override
  String get addRemoveFromPlaylist => '加入播放清單 / 從播放清單中刪除';

  @override
  String get addPlaylistSubheader => '講歌曲加入播放清單';

  @override
  String get trackOfflineFavorites => '同步最愛狀態';

  @override
  String get trackOfflineFavoritesSubtitle => '這樣可以在離線時顯示最新的最愛狀態。不會下載任何額外的檔案。';

  @override
  String get allPlaylistsInfoSetting => '下載播放清單詮釋資料';

  @override
  String get allPlaylistsInfoSettingSubtitle => '同步所有播放清單的詮釋資料以改善播放清單使用體驗';

  @override
  String get downloadFavoritesSetting => '下載所有最愛';

  @override
  String get downloadAllPlaylistsSetting => '下載所有播放清單';

  @override
  String get fiveLatestAlbumsSetting => '下載最新的 5 張專輯';

  @override
  String get fiveLatestAlbumsSettingSubtitle => '下載內容會在到期後自動移除。若要防止專輯被移除，請鎖定下載。';

  @override
  String get cacheLibraryImagesSettings => '快取現在的媒體庫圖片';

  @override
  String get cacheLibraryImagesSettingsSubtitle => '目前啟用的媒體庫內的專輯、藝人、曲風與播放清單封面將會下載。';

  @override
  String get showProgressOnNowPlayingBarTitle => '在應用程式內的迷你播放器上顯示歌曲播放進度';

  @override
  String get showProgressOnNowPlayingBarSubtitle => '控制應用程式內下方的迷你播放器 / 正在播放欄位是否同時作為進度條。';

  @override
  String get lyricsScreen => '歌詞介面';

  @override
  String get showLyricsTimestampsTitle => '顯示同步歌詞的時間戳';

  @override
  String get showLyricsTimestampsSubtitle => '控制是否在歌詞介面中於可用時顯示每行歌詞的時間戳。';

  @override
  String get showStopButtonOnMediaNotificationTitle => '在媒體通知上顯示停止按鈕';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => '控制媒體通知上除了暫停按鈕以外是否還有停止按鈕。這可以讓你在不打開應用程式的情況下停止播放。';

  @override
  String get showSeekControlsOnMediaNotificationTitle => '在媒體通知上顯示進度控制';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => '控制媒體通知上是否顯示可以調整播放進度的進度條。這可以讓你在不打開應用程式的情況下改變播放位置。';

  @override
  String get alignmentOptionStart => '靠左排列';

  @override
  String get alignmentOptionCenter => '置中';

  @override
  String get alignmentOptionEnd => '靠右對齊';

  @override
  String get fontSizeOptionSmall => '小';

  @override
  String get fontSizeOptionMedium => '中';

  @override
  String get fontSizeOptionLarge => '大';

  @override
  String get lyricsAlignmentTitle => '歌詞對齊方式';

  @override
  String get lyricsAlignmentSubtitle => '控制歌詞介面中的歌詞對齊方式。';

  @override
  String get lyricsFontSizeTitle => '歌詞字體大小';

  @override
  String get lyricsFontSizeSubtitle => '控制歌詞介面中的歌詞字體大小。';

  @override
  String get showLyricsScreenAlbumPreludeTitle => '顯示專輯封面於歌詞前';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => '控制是否在歌詞檢視畫面中，於滾動前顯示專輯封面。';

  @override
  String get keepScreenOn => '保持螢幕開啟';

  @override
  String get keepScreenOnSubtitle => '何時保持螢幕開啟';

  @override
  String get keepScreenOnDisabled => '停用';

  @override
  String get keepScreenOnAlwaysOn => '永遠開啟';

  @override
  String get keepScreenOnWhilePlaying => '播放音樂是保持開啟';

  @override
  String get keepScreenOnWhileLyrics => '顯示歌詞時保持開啟';

  @override
  String get keepScreenOnWhilePluggedIn => '僅在連接電源時保持螢幕開啟';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => '設備移除電源時忽略保持螢幕開啟的設定';

  @override
  String get genericToggleButtonTooltip => '點擊切換。';

  @override
  String get artwork => '圖片';

  @override
  String artworkTooltip(String title) {
    return '$title 的圖片';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return '$title 的作品。點擊可播放或暫停，左右滑動可切換歌曲。';
  }

  @override
  String get nowPlayingBarTooltip => '打開播放器介面';

  @override
  String get additionalPeople => '其他人員';

  @override
  String get playbackMode => '重播模式';

  @override
  String get codec => '編碼格式';

  @override
  String get bitRate => '位元率';

  @override
  String get bitDepth => '位深度';

  @override
  String get size => '檔案大小';

  @override
  String get normalizationGain => '增益';

  @override
  String get sampleRate => '取樣率';

  @override
  String get showFeatureChipsToggleTitle => '顯示歌曲詳情';

  @override
  String get showFeatureChipsToggleSubtitle => '在播放器介面上顯示包含編解碼器、位元率等進階音軌資料。';

  @override
  String get albumScreen => '專輯介面';

  @override
  String get showCoversOnAlbumScreenTitle => '顯示歌曲的專輯封面';

  @override
  String get showCoversOnAlbumScreenSubtitle => '在專輯介面中，為每首歌曲單獨顯示專輯封面。';

  @override
  String get emptyTopTracksList => '您還沒聆聽過這位藝人的任何音樂。';

  @override
  String get emptyFilteredListTitle => '找不到符合的項目';

  @override
  String get emptyFilteredListSubtitle => '找不到符合的項目。試著取消篩選條件或更改搜索詞。';

  @override
  String get resetFiltersButton => '重置篩選條件';

  @override
  String get resetSettingsPromptGlobal => '確定要將所有設定重置為預設值嗎？';

  @override
  String get resetSettingsPromptGlobalConfirm => '重置所有設定';

  @override
  String get resetSettingsPromptLocal => '您確定要將這些設定重置為預設值嗎？';

  @override
  String get genericCancel => '取消';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '專輯',
        'playlist': '播放清單',
        'artist': '藝人',
        'genre': '曲風',
        'track': '音軌',
        'library': '媒體庫',
        'other': '項目',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': '裝置',
        'server': '伺服器',
        'other': '未知來源',
      },
    );
    return '$_temp0 已從 $_temp1 刪除';
  }

  @override
  String get allowDeleteFromServerTitle => '允許從伺服器刪除';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '專輯',
        'playlist': '播放清單',
        'artist': '藝人',
        'genre': '曲風',
        'track': '音軌',
        'library': '音樂庫',
        'other': '項目',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' 此項目將從此裝置永久刪除。',
        'cantDelete': ' 此項目將暫時保留於此裝置，直至下次同步為止。',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': '裝置',
        'server': '伺服器的檔案系統與音樂庫。$_temp1 \n此操作無法還原。',
        'other': '',
      },
    );
    return '您即將從$_temp0刪除此$_temp2。';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': '裝置',
        'server': '伺服器',
        'other': '',
      },
    );
    return '從$_temp0上刪除';
  }

  @override
  String largeDownloadWarning(int count) {
    return '警告：即將下載 $count 首音軌。';
  }

  @override
  String get downloadSizeWarningCutoff => '下載檔案大小警告';

  @override
  String get downloadSizeWarningCutoffSubtitle => '在一次下載超過一首音軌時顯示的的警告。';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': '專輯',
        'playlist': '播放清單',
        'artist': '藝人',
        'genre': '曲風',
        'other': '項目',
      },
    );
    return '確定要將 $_temp0 \'$itemName\'的所有歌曲加入播放清單嗎？請注意，這些歌曲只能逐首刪除，無法一次移除所有內容。';
  }

  @override
  String get publiclyVisiblePlaylist => '公開可見：';

  @override
  String get releaseDateFormatYear => '年';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => '年和月';

  @override
  String get releaseDateFormatMonthDayYear => '月，日和年';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => '在播放器介面上顯示專輯發行日期';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => '在播放器介面中顯示專輯發行日期於專輯名稱之後。';

  @override
  String get releaseDateFormatTitle => '發行日期格式';

  @override
  String get releaseDateFormatSubtitle => '控制專輯發行日期於應用程式中顯示的格式。';
}

/// The translations for Chinese, as used in Hong Kong, using the Han script (`zh_Hant_HK`).
class AppLocalizationsZhHantHk extends AppLocalizationsZh {
  AppLocalizationsZhHantHk(): super('zh_Hant_HK');

  @override
  String get finamp => 'Finamp';

  @override
  String startupError(String error) {
    return '應用程式啟動時出錯（$error）\n\n您可以在 github.com/UnicornsOnLSD/finamp 回報有關問題並附上截圖。如果問題持續，您可以嘗試重設應用程式。';
  }

  @override
  String get about => '關於 Finamp';

  @override
  String get serverUrl => '伺服器 URL';

  @override
  String get internalExternalIpExplanation => '如果您需要在局部區域網絡（LAN）以外的地方連接 Jellyfin，請使用伺服器的區域網絡（WAN）IP。\n\n如果目標伺服器使用的連接埠（port）是 HTTP 的預設連接埠（80／433），則毋須填寫連接埠。';

  @override
  String get emptyServerUrl => '伺服器 URL 並不能漏空';

  @override
  String get username => '用戶名稱';

  @override
  String get password => '密碼';

  @override
  String get logs => '紀錄檔';

  @override
  String get next => '下一個';

  @override
  String get selectMusicLibraries => '選擇音樂媒體庫';

  @override
  String get couldNotFindLibraries => '沒有可用的媒體庫。';

  @override
  String get unknownName => '未知的名稱';

  @override
  String get tracks => '歌曲';

  @override
  String get albums => '專輯';

  @override
  String get artists => '歌手';

  @override
  String get genres => '曲風';

  @override
  String get playlists => '播放清單';

  @override
  String get startMix => '開始混音';

  @override
  String get startMixNoTracksArtist => '在開始混音之前，長按歌手以添加至混音器或從混音器移除';

  @override
  String get startMixNoTracksAlbum => '在開始混音之前，長按專輯以添加至混音器或從混音器移除';

  @override
  String get music => '音樂';

  @override
  String get clear => '清除';

  @override
  String get favourites => '我的最愛';

  @override
  String get shuffleAll => '隨機播放全部';

  @override
  String get downloads => '下載';

  @override
  String get settings => '設定';

  @override
  String get offlineMode => '離線模式';

  @override
  String get sortOrder => '順序';

  @override
  String get sortBy => '排序方式';

  @override
  String get album => '專輯';

  @override
  String get albumArtist => '專輯歌手';

  @override
  String get artist => '歌手';

  @override
  String get budget => '預算';

  @override
  String get communityRating => '聽眾評分';

  @override
  String get criticRating => '樂評人評分';

  @override
  String get dateAdded => '添加日期';

  @override
  String get datePlayed => '播放日期';

  @override
  String get playCount => '播放次數';

  @override
  String get premiereDate => '推出日期';

  @override
  String get productionYear => '製作年份';

  @override
  String get name => '名稱';

  @override
  String get random => '隨機';

  @override
  String get revenue => '收入';

  @override
  String get runtime => '執行時';

  @override
  String get syncDownloadedPlaylists => '同步已下載播放清單';

  @override
  String get downloadMissingImages => '下載缺失的圖片';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已下載$count張圖片',
      one: '已下載$count張圖片',
      zero: '沒有缺少的圖片',
    );
    return '$_temp0';
  }

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個下載',
      one: '$count個下載',
    );
    return '$_temp0';
  }

  @override
  String dlComplete(int count) {
    return '$count 完成';
  }

  @override
  String dlFailed(int count) {
    return '$count 失敗';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 等待中';
  }

  @override
  String dlRunning(int count) {
    return '$count 正在下載';
  }

  @override
  String get errorScreenError => '讀取錯誤資訊時發生錯誤！建議在 GitHub 上回報此問題及重設應用程式。';

  @override
  String get failedToGetTrackFromDownloadId => '無法從下載 ID 中取得歌曲';

  @override
  String get error => '錯誤';

  @override
  String discNumber(int number) {
    return 'CD $number';
  }

  @override
  String get playButtonLabel => '播放';

  @override
  String get shuffleButtonLabel => '隨機播放';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count首歌曲',
      one: '$count首歌曲',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => '編輯播放清單名稱';

  @override
  String get editPlaylistNameTitle => '編輯播放清單名稱';

  @override
  String get required => '必填';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => '已更新播放清單名稱。';

  @override
  String get favourite => '我的最愛';

  @override
  String get downloadsDeleted => '已刪除。';

  @override
  String get addDownloads => '添加至下載';

  @override
  String get location => '位置';

  @override
  String get downloadsQueued => '已添加至下載。';

  @override
  String get addButtonLabel => '加入';

  @override
  String get shareLogs => '分享所有紀錄檔';

  @override
  String get logsCopied => '已複製所有紀錄。';

  @override
  String get message => '訊息';

  @override
  String get stackTrace => '除錯資訊（Stack Trace）';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return '採用 Mozilla Public License 2.0 特許條款。原始碼：\n\ngithub.com/jmshrv/finamp';
  }

  @override
  String get transcoding => '轉碼（Transcoding）';

  @override
  String get downloadLocations => '下載位置';

  @override
  String get audioService => '播放設定';

  @override
  String get interactions => '互動';

  @override
  String get layoutAndTheme => '顯示及主題';

  @override
  String get notAvailableInOfflineMode => '不能在離線模式下使用';

  @override
  String get logOut => '登出';

  @override
  String get downloadedTracksWillNotBeDeleted => '已下載的歌曲並不會被刪除';

  @override
  String get areYouSure => '您確定嗎？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin 使用 ACC 進行轉碼';

  @override
  String get enableTranscoding => '啟用轉碼';

  @override
  String get enableTranscodingSubtitle => '啟用後，音訊會先在伺服器轉碼。';

  @override
  String get bitrate => '位元速率（Bitrate）';

  @override
  String get bitrateSubtitle => '越高的位元速率帶來越好的音質，但亦會使用更多的流量。';

  @override
  String get customLocation => '自訂位置';

  @override
  String get appDirectory => '應用程式資料夾';

  @override
  String get addDownloadLocation => '添加下載位置';

  @override
  String get selectDirectory => '選擇資料夾';

  @override
  String get unknownError => '未知的錯誤';

  @override
  String get pathReturnSlashErrorMessage => '不能使用「／」路徑';

  @override
  String get directoryMustBeEmpty => '所選的資料夾必須為空的';

  @override
  String get customLocationsBuggy => '現時，自訂位置功能因權限問題而未能完全正常運作。如非必要，建議不要使用。';

  @override
  String get enterLowPriorityStateOnPause => '暫停播放時會進入「低優先」狀態';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => '在停止播放時，允許本程式的「通知」能被掃走及關閉應用程式（適用於 Android 裝置）。';

  @override
  String get shuffleAllTrackCount => '隨機播放上限';

  @override
  String get shuffleAllTrackCountSubtitle => '使用「隨機播放全部」時，播放歌曲的數量上限。';

  @override
  String get viewType => '顯示模式';

  @override
  String get viewTypeSubtitle => '顯示資訊的方式';

  @override
  String get list => '清單';

  @override
  String get grid => '格狀';

  @override
  String get portrait => '直向';

  @override
  String get landscape => '橫向';

  @override
  String gridCrossAxisCount(String value) {
    return '$value顯示網格數量';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '屏幕在$value顯示時，每行顯示的資訊數量（例如歌曲、歌手等）。';
  }

  @override
  String get showTextOnGridView => '在網絡內顯示文字';

  @override
  String get showTextOnGridViewSubtitle => '使用格狀顯示時，在網格內顯示歌曲資訊（名稱、歌手等）。';

  @override
  String get useCoverAsBackground => '模糊化封面作為播放器的背景';

  @override
  String get useCoverAsBackgroundSubtitle => '以模糊化的專輯封面作為應用程式內的播放頁面的背景。';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => '隱藏與專輯歌手同名的歌手名稱';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => '當專輯的歌手與歌曲的歌手相同時，隱藏歌曲的歌手名稱。';

  @override
  String get disableGesture => '禁用「手勢」功能';

  @override
  String get disableGestureSubtitle => '是否禁用「手勢」功能。';

  @override
  String get showFastScroller => '顯示快速卷軸';

  @override
  String get theme => '色彩主題';

  @override
  String get system => '系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get tabs => '分頁';

  @override
  String get cancelSleepTimer => '取消睡眠定時器？';

  @override
  String get yesButtonLabel => '是';

  @override
  String get noButtonLabel => '否';

  @override
  String get setSleepTimer => '設定睡眠定時器';

  @override
  String get minutes => '分鐘';

  @override
  String get invalidNumber => '無效的數字';

  @override
  String get sleepTimerTooltip => '睡眠定時器';

  @override
  String get addToPlaylistTooltip => '將歌曲加入至播放清單';

  @override
  String get addToPlaylistTitle => '加入至播放清單';

  @override
  String get removeFromPlaylistTooltip => '從播放清單中移除歌曲';

  @override
  String get removeFromPlaylistTitle => '從播放清單中移除';

  @override
  String get newPlaylist => '建立播放清單';

  @override
  String get createButtonLabel => '建立';

  @override
  String get playlistCreated => '已建立播放清單。';

  @override
  String get noAlbum => '沒有任何專輯';

  @override
  String get noItem => '沒有任何項目';

  @override
  String get noArtist => '沒有任何歌手';

  @override
  String get unknownArtist => '未知的歌手';

  @override
  String get queue => '播放佇列';

  @override
  String get addToQueue => '加入至播放佇列';

  @override
  String get replaceQueue => '取代現時的播放佇列';

  @override
  String get instantMix => '即時混音';

  @override
  String get goToAlbum => '檢視專輯';

  @override
  String get removeFavourite => '從我的最愛中移除';

  @override
  String get addFavourite => '加入至我的最愛';

  @override
  String get addedToQueue => '已加入至播放佇列。';

  @override
  String get insertedIntoQueue => '已加入至播放佇列中。';

  @override
  String get queueReplaced => '已取代現有的播放佇列。';

  @override
  String get removedFromPlaylist => '已從播放清單中移除。';

  @override
  String get startingInstantMix => '開始即時混音中。';

  @override
  String get anErrorHasOccured => '出現錯誤。';

  @override
  String responseError(String error, int statusCode) {
    return '$error（代碼：$statusCode）。';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error（代碼：$statusCode）。此錯誤有可能因為用戶名稱／密碼輸入錯誤或您已被登出而導致。';
  }

  @override
  String get removeFromMix => '從混音中移除';

  @override
  String get addToMix => '加入至混音';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已重新下載$count個項目',
      one: '已重新下載$count個項目',
      zero: '沒有需要重新下載的項目。',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '緩衝時長';

  @override
  String get bufferDurationSubtitle => '播放器可以預先載入多少的音訊數據（秒）。重啟以套用設定。';

  @override
  String get language => '語言';

  @override
  String get playNext => '下一首';

  @override
  String get confirm => '確定';

  @override
  String get showUncensoredLogMessage => '紀錄檔內包含你的登入資訊。你是否確認要顯示？';

  @override
  String get resetTabs => '重設分頁';

  @override
  String get noMusicLibrariesTitle => '沒有音樂類媒體庫';

  @override
  String get noMusicLibrariesBody => 'Finamp 未有發現任何音樂媒體庫。請檢查 Jellyfin 伺服器上最少有一個屬於「音樂」類別的媒體庫。';

  @override
  String get refresh => '重新載入';

  @override
  String get swipeInsertQueueNext => '滑動插播';

  @override
  String get swipeInsertQueueNextSubtitle => '在歌曲列表中輕掃歌曲時，將其插入至播放佇列的最頭而不是最後。';
}
