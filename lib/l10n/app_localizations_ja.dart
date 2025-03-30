// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'オープンソースのJellyfin音楽プレーヤー';

  @override
  String startupError(String error) {
    return '起動時に問題が起こりました。エラー内容: $error\n\ngithub.com/UnicornsOnLSD/finamp でイシューを作成し、このページのスクリーンショットを付けてください。問題が継続した場合はアプリデータをクリアしてアプリを初期化して下さい。';
  }

  @override
  String get about => 'Finamp について';

  @override
  String get aboutContributionPrompt => '素晴らしい人々が空き時間に作りました。\nあなたもその一員になれるかもしれません！';

  @override
  String get aboutContributionLink => 'GitHub で Finamp に貢献する:';

  @override
  String get aboutReleaseNotes => '最新のリリースノートを読む:';

  @override
  String get aboutTranslations => 'Finamp をあなたの言語に翻訳する手伝いをしてください:';

  @override
  String get aboutThanks => 'Finamp をご利用いただきありがとうございます！';

  @override
  String get loginFlowWelcomeHeading => 'Welcome to';

  @override
  String get loginFlowSlogan => 'あなたの音楽を、あなたの思い通りに。';

  @override
  String get loginFlowGetStarted => '始めましょう！';

  @override
  String get viewLogs => 'ログを表示';

  @override
  String get changeLanguage => '言語を変更';

  @override
  String get loginFlowServerSelectionHeading => 'Jellyfin に接続';

  @override
  String get back => '戻る';

  @override
  String get serverUrl => 'サーバー URL';

  @override
  String get internalExternalIpExplanation => 'リモートからJellyfinサーバーにアクセスするには外部IPを指定する必要があります。\n\nサーバーがHTTPポート(80/443)やJellyfinのデフォルトポート(8096)で動作している場合、ポートを指定する必要はありません。\n\nURLが正しい場合、入力フィールドの下にサーバーに関する情報が表示されるはずです。';

  @override
  String get serverUrlHint => '例: demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'サーバーURLのヘルプ';

  @override
  String get emptyServerUrl => 'サーバーURLを入力してください';

  @override
  String get connectingToServer => 'サーバーに接続中…';

  @override
  String get loginFlowLocalNetworkServers => 'ローカルネットワーク上のサーバー:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'サーバーをスキャン中…';

  @override
  String get loginFlowAccountSelectionHeading => 'アカウントを選択してください';

  @override
  String get backToServerSelection => 'サーバー選択に戻る';

  @override
  String get loginFlowNamelessUser => '名前なしユーザー';

  @override
  String get loginFlowCustomUser => 'カスタムユーザー';

  @override
  String get loginFlowAuthenticationHeading => 'アカウントにログインしてください';

  @override
  String get backToAccountSelection => 'アカウント選択に戻る';

  @override
  String get loginFlowQuickConnectPrompt => 'Quick Connect コードを使用する';

  @override
  String get loginFlowQuickConnectInstructions => 'Jellyfinアプリまたはウェブサイトを開き、ユーザーアイコンをクリックして「Quick Connect」を選択してください。';

  @override
  String get loginFlowQuickConnectDisabled => 'このサーバーでは、Quick Connect が無効になっています。';

  @override
  String get orDivider => 'または';

  @override
  String get loginFlowSelectAUser => 'ユーザーを選択';

  @override
  String get username => 'ユーザー名';

  @override
  String get usernameHint => 'ユーザー名を入力してください';

  @override
  String get usernameValidationMissingUsername => 'ユーザー名を入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get passwordHint => 'パスワードを入力してください';

  @override
  String get login => 'ログイン';

  @override
  String get logs => 'ログ';

  @override
  String get next => '次';

  @override
  String get selectMusicLibraries => 'ミュージック・ライブラリを選択';

  @override
  String get couldNotFindLibraries => 'ライブラリが見つかりません。';

  @override
  String get unknownName => 'タイトル不明';

  @override
  String get tracks => '曲';

  @override
  String get albums => 'アルバム';

  @override
  String get artists => 'アーティスト';

  @override
  String get genres => 'ジャンル';

  @override
  String get playlists => 'プレイリスト';

  @override
  String get startMix => 'ミックス開始';

  @override
  String get startMixNoTracksArtist => 'アーティスト名を長押しすることでミックス対象に追加または削除できます';

  @override
  String get startMixNoTracksAlbum => 'アルバムを長押しすることでミックス対象に追加または削除できます';

  @override
  String get startMixNoTracksGenre => 'ミックスを開始する前に、ジャンルを長押ししてミックスビルダーに追加または削除してください';

  @override
  String get music => 'ミュージック';

  @override
  String get clear => 'クリア';

  @override
  String get favourites => 'お気に入り';

  @override
  String get shuffleAll => '全てシャッフル';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get settings => '設定';

  @override
  String get offlineMode => 'オフライン・モード';

  @override
  String get sortOrder => '並び順';

  @override
  String get sortBy => '並び基準';

  @override
  String get title => 'タイトル';

  @override
  String get album => 'アルバム';

  @override
  String get albumArtist => 'アルバム・アーティスト';

  @override
  String get artist => 'アーティスト';

  @override
  String get budget => '予算';

  @override
  String get communityRating => 'コミュニティ評価';

  @override
  String get criticRating => '評論家評価';

  @override
  String get dateAdded => '追加日';

  @override
  String get datePlayed => '再生日';

  @override
  String get playCount => '再生回数';

  @override
  String get premiereDate => '公開日';

  @override
  String get productionYear => '作成年';

  @override
  String get name => '曲名';

  @override
  String get random => 'ランダム';

  @override
  String get revenue => '収入';

  @override
  String get runtime => '再生時間';

  @override
  String get syncDownloadedPlaylists => 'ダウンロードしたプレイリストの同期';

  @override
  String get downloadMissingImages => '欠けている画像をダウンロード';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '欠けている画像を $count 枚ダウンロード',
      one: '欠けている画像を $count 枚ダウンロード',
      zero: '欠けている画像が見つかりません',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'アクティブなダウンロード';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個ダウンロード',
      one: '$count 個ダウンロード',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount 曲',
      one: '$trackCount 曲',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount 画像',
      one: '$imageCount 画像',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount ノードを同期中',
      one: '$syncCount ノードを同期中',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\n現在修復中',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count 個完了';
  }

  @override
  String dlFailed(int count) {
    return '$count個失敗';
  }

  @override
  String dlEnqueued(int count) {
    return '$count 個キューに追加';
  }

  @override
  String dlRunning(int count) {
    return '$count 個再生中';
  }

  @override
  String get activeDownloadsTitle => 'アクティブなダウンロード';

  @override
  String get noActiveDownloads => 'アクティブなダウンロードはありません。';

  @override
  String get errorScreenError => 'エラーリスト取得時にエラーが発生しました！この時点では、GitHub で issue を作成し、アプリデータを削除することをお勧めします';

  @override
  String get failedToGetTrackFromDownloadId => 'ダウンロードIDから曲を取得できませんでした';

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
  String get error => 'エラー';

  @override
  String discNumber(int number) {
    return 'ディスク $number';
  }

  @override
  String get playButtonLabel => '再生';

  @override
  String get shuffleButtonLabel => 'シャッフル';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '$count曲',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲',
      one: '$count 曲',
    );
    return '$_temp0, $downloads ダウンロード済み';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲',
      one: '$count 曲',
    );
    return '$_temp0 ダウンロード済み';
  }

  @override
  String get editPlaylistNameTooltip => 'プレイリスト名を編集';

  @override
  String get editPlaylistNameTitle => 'プレイリスト名を編集';

  @override
  String get required => '必須';

  @override
  String get updateButtonLabel => '更新';

  @override
  String get playlistNameUpdated => 'プレイリスト名を更新しました。';

  @override
  String get favourite => 'お気に入り';

  @override
  String get downloadsDeleted => 'ダウンロードを削除しました。';

  @override
  String get addDownloads => 'ダウンロードを追加';

  @override
  String get location => '場所';

  @override
  String get confirmDownloadStarted => 'ダウンロードを開始しました';

  @override
  String get downloadsQueued => 'ダウンロードを追加しました。';

  @override
  String get addButtonLabel => '追加';

  @override
  String get shareLogs => 'ログ共有';

  @override
  String get logsCopied => 'ログをコピーしました。';

  @override
  String get message => 'メッセージ';

  @override
  String get stackTrace => 'スタックトレース';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Mozilla Public License 2.0 のもとでライセンスされています。\nソースコードは $sourceCodeLink で入手できます。';
  }

  @override
  String get transcoding => 'トランスコード';

  @override
  String get downloadLocations => 'ダウンロード場所';

  @override
  String get audioService => 'オーディオ・サービス';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'レイアウト&テーマ';

  @override
  String get notAvailableInOfflineMode => 'オフライン・モードでは無効';

  @override
  String get logOut => 'ログアウト';

  @override
  String get downloadedTracksWillNotBeDeleted => 'ダウロード済みの曲は削除されません';

  @override
  String get areYouSure => 'よろしいですか？';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin はトランスコードに AAC を利用します';

  @override
  String get enableTranscoding => 'トランスコード有効';

  @override
  String get enableTranscodingSubtitle => 'サーバー側の音楽ストリームをトランスコードします。';

  @override
  String get bitrate => 'ビットレート';

  @override
  String get bitrateSubtitle => '高いビットレートではオーディオの質が高くなりますが、転送容量も高くなります。';

  @override
  String get customLocation => '指定の場所';

  @override
  String get appDirectory => 'Appのディレクトリ';

  @override
  String get addDownloadLocation => 'ダウンロード場所を追加';

  @override
  String get selectDirectory => 'ディレクトリを選択';

  @override
  String get unknownError => '不明なエラー';

  @override
  String get pathReturnSlashErrorMessage => '\"/\" を返すパスは利用できません';

  @override
  String get directoryMustBeEmpty => 'ディレクトリは空でなければなりません';

  @override
  String get customLocationsBuggy => 'カスタムの場所は、権限の問題により、非常にバグが多くなります。これを修正する方法を考えていますが、今のところは使用しないことをお勧めします。';

  @override
  String get enterLowPriorityStateOnPause => '一時停止時は低優先度状態';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => '一時停止時に通知をスワイプで除去できます。また Android では一時停止時にサービスを停止できます。';

  @override
  String get shuffleAllTrackCount => '曲がシャッフル化される回数';

  @override
  String get shuffleAllTrackCountSubtitle => 'すべての曲をシャッフルする時、ここで指定した曲数をロードします。';

  @override
  String get viewType => 'ビューの形式';

  @override
  String get viewTypeSubtitle => 'ミュージック画面の表示形式';

  @override
  String get list => 'リスト';

  @override
  String get grid => 'グリッド';

  @override
  String get customizationSettingsTitle => 'カスタマイズ';

  @override
  String get playbackSpeedControlSetting => '再生速度の表示';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Whether the playback speed controls are shown in the player screen menu';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automatic:\nFinamp tries to identify whether the track you are playing is a podcast or (part of) an audiobook. This is considered to be the case if the track is longer than $trackDuration minutes, if the track\'\'s album is longer than $albumDuration hours, or if the track has at least one of these genres assigned: $genreList\nPlayback speed controls will then be shown in the player screen menu.\n\nShown:\nThe playback speed controls will always be shown in the player screen menu.\n\nHidden:\nThe playback speed controls in the player screen menu are always hidden.';
  }

  @override
  String get automatic => 'Automatic';

  @override
  String get shown => 'Shown';

  @override
  String get hidden => 'Hidden';

  @override
  String get speed => 'Speed';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get portrait => '縦表示';

  @override
  String get landscape => '横表示';

  @override
  String gridCrossAxisCount(String value) {
    return '$value のアイテム数';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '$valueの場合一行当たりのグリッドタイル数。';
  }

  @override
  String get showTextOnGridView => 'グリッド・ビューでテキストを表示する';

  @override
  String get showTextOnGridViewSubtitle => 'グリッド音楽画面でテキスト（タイトル、アーティスト等）を表示させるか。';

  @override
  String get useCoverAsBackground => 'プレイヤー背景にジャケット画像をぼかして表示する';

  @override
  String get useCoverAsBackgroundSubtitle => 'プレイヤー画面で背景にジャケット画像をぼかして表示させるか。';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimum album cover padding';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimum padding around the album cover on the player screen, in % of the screen width.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => '曲のアーティストがアルバム・アーティストと同じの場合、表示しない';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => '曲のアーティストがアルバムのアーティストと一致した場合、アルバム画面に表示させるか。';

  @override
  String get showArtistsTopTracks => 'Show top tracks in artist view';

  @override
  String get showArtistsTopTracksSubtitle => 'Whether to show the top 5 most listened to tracks of an artist.';

  @override
  String get disableGesture => 'ジェスチャーを無効';

  @override
  String get disableGestureSubtitle => 'ジェスチャーを無効にするか。';

  @override
  String get showFastScroller => '高速スクロールを表示';

  @override
  String get theme => 'テーマ';

  @override
  String get system => 'システム';

  @override
  String get light => '明るい';

  @override
  String get dark => '暗い';

  @override
  String get tabs => 'タブ';

  @override
  String get playerScreen => 'Player Screen';

  @override
  String get cancelSleepTimer => 'スリープ・タイマーをキャンセルしますか?';

  @override
  String get yesButtonLabel => 'はい';

  @override
  String get noButtonLabel => 'いいえ';

  @override
  String get setSleepTimer => 'スリープ・タイマーを設定';

  @override
  String get hours => 'Hours';

  @override
  String get seconds => 'Seconds';

  @override
  String get minutes => '分';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime of $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Track $currentTrackIndex of $totalTrackCount';
  }

  @override
  String get invalidNumber => '無効な数値';

  @override
  String get sleepTimerTooltip => 'スリープ・タイマー';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Sleeping in $time minutes';
  }

  @override
  String get addToPlaylistTooltip => 'プレイリストに追加';

  @override
  String get addToPlaylistTitle => 'プレイリストに追加';

  @override
  String get addToMorePlaylistsTooltip => 'Add to more playlists';

  @override
  String get addToMorePlaylistsTitle => 'Add to More Playlists';

  @override
  String get removeFromPlaylistTooltip => 'プレイリストから外す';

  @override
  String get removeFromPlaylistTitle => 'プレイリストから外す';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Remove from playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Remove from Playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => '新規プレイリスト';

  @override
  String get createButtonLabel => '作成';

  @override
  String get playlistCreated => 'プレイリストを作成しました。';

  @override
  String get playlistActionsMenuButtonTooltip => 'Tap to add to playlist. Long press to toggle favorite.';

  @override
  String get noAlbum => 'アルバム無し';

  @override
  String get noItem => 'アイテム無し';

  @override
  String get noArtist => 'アーティスト無し';

  @override
  String get unknownArtist => 'アーティスト不明';

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
  String get queue => 'キュー';

  @override
  String get addToQueue => 'キューに追加';

  @override
  String get replaceQueue => 'キューを置き換え';

  @override
  String get instantMix => 'インスタント・ミックス';

  @override
  String get goToAlbum => 'アルバムに行く';

  @override
  String get goToArtist => 'Go to Artist';

  @override
  String get goToGenre => 'Go to Genre';

  @override
  String get removeFavourite => 'お気に入りを削除';

  @override
  String get addFavourite => 'お気に入りを追加';

  @override
  String get confirmFavoriteAdded => 'Added Favorite';

  @override
  String get confirmFavoriteRemoved => 'Removed Favorite';

  @override
  String get addedToQueue => 'キューに追加。';

  @override
  String get insertedIntoQueue => 'キューに挿入されました。';

  @override
  String get queueReplaced => 'キューを置き換えました。';

  @override
  String get confirmAddedToPlaylist => 'Added to playlist.';

  @override
  String get removedFromPlaylist => 'プレイリストから外しました。';

  @override
  String get startingInstantMix => 'インスタント・ミックス開始。';

  @override
  String get anErrorHasOccured => 'エラーが発生しました。';

  @override
  String responseError(String error, int statusCode) {
    return '$error ステータスコード $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status code $statusCode. ユーザー名/パスワードが間違っているか、クライアントがログインしていません。';
  }

  @override
  String get removeFromMix => 'ミックスから外す';

  @override
  String get addToMix => 'ミックスに追加';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redownloaded $count items',
      one: 'Redownloaded $count item',
      zero: 'No redownloads needed.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'バッファ容量';

  @override
  String get bufferDurationSubtitle => 'プレイヤーがバッファする容量（秒単位）。リスタートが必要です。';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Don\'t limit buffer size';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.';

  @override
  String get bufferSizeTitle => 'Buffer Size';

  @override
  String get bufferSizeSubtitle => 'The maximum size of the buffer in MB. Requires a restart';

  @override
  String get language => '言語';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Skip to beginning or to previous track';

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
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Playing from';

  @override
  String get playNext => '再生次';

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
  String get playbackOrderLinearButtonTooltip => 'Playing in order. Tap to shuffle.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Shuffling tracks';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Shuffling tracks. Tap to play in order.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Playing at x$speed speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed speed';
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
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
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
  String get queueLoadingMessage => 'Restoring queue...';

  @override
  String get queueRetryMessage => 'Failed to restore queue. Retry?';

  @override
  String get autoloadLastQueueOnStartup => 'Auto-Restore Last Queue';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Upon app startup, attempt to restore the last played queue.';

  @override
  String get reportQueueToServer => 'Report current queue to server?';

  @override
  String get reportQueueToServerSubtitle => 'When enabled, Finamp will send the current queue to the server. There currently seems to be little use for this, and it increases network traffic.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Playback session update frequency';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'How often to send the current playback status to the server, in seconds. This should be less than 5 minutes (300 seconds), to prevent the session from timing out.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'If the Jellyfin server hasn\'\'t received any updates from a client in the last 5 minutes, it assumes that playback has ended. This means that for tracks longer than 5 minutes, that playback could be incorrectly reported as having ended, which reduced the quality of the playback reporting data.';

  @override
  String get topTracks => 'Top Tracks';

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
  String get confirm => '確認する';

  @override
  String get close => 'Close';

  @override
  String get showUncensoredLogMessage => 'このログはあなたのログイン情報を含みます。表示しますか？';

  @override
  String get resetTabs => 'タブリセット';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get noMusicLibrariesTitle => '音楽ライブラリなし';

  @override
  String get noMusicLibrariesBody => 'Finamp は音楽ライブラリを見つけることができませんでした。Jellyfin サーバーに、コンテンツ タイプが「音楽」に設定されているライブラリが少なくとも 1 つ含まれていることを確認してください。';

  @override
  String get refresh => 'リフレッシュ';

  @override
  String get moreInfo => 'More Info';

  @override
  String get volumeNormalizationSettingsTitle => 'Volume Normalization';

  @override
  String get volumeNormalizationSwitchTitle => 'Enable Volume Normalization';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Use gain information to normalize the loudness of tracks (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Volume Normalization Mode';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'When and how to apply Volume Normalization';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Hybrid (Track + Album):\nTrack gain is used for regular playback, but if an album is playing (either because it\'\'s the main playback queue source, or because it was added to the queue at some point), the album gain is used instead.\n\nTrack-based:\nTrack gain is always used, regardless of whether an album is playing or not.\n\nAlbums Only:\nVolume Normalization is only applied while playing albums (using the album gain), but not for individual tracks.';

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
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Currently, Volume Normalization on iOS requires changing the playback volume to emulate the gain change. Since we can\'\'t increase the volume above 100%, we need to decrease the volume by default so that we can boost the volume of quiet tracks. The value is in decibels (dB), where -10 dB is ~30% volume, -4.5 dB is ~60% volume and -2 dB is ~80% volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'スワイプした曲を再生する';

  @override
  String get swipeInsertQueueNextSubtitle => '曲リストでスワイプしたときに、曲を最後に追加するのではなく、キューの次の項目として挿入できるようにします。';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Start Instant Mixes for Individual Tracks';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'When enabled, tapping a track on the tracks tab will start an instant mix of that track instead of just playing a single track.';

  @override
  String get downloadItem => 'Download';

  @override
  String get repairComplete => 'Downloads Repair complete.';

  @override
  String get syncComplete => 'All downloads re-synced.';

  @override
  String get syncDownloads => 'Sync and download missing items.';

  @override
  String get repairDownloads => 'Repair issues with downloaded files or metadata.';

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
  String get filesystemFull => 'Remaining downloads cannot be completed. The filesystem is full.';

  @override
  String get connectionInterrupted => 'Connection interrupted, pausing downloads.';

  @override
  String get connectionInterruptedBackground => 'Connection was interrupted while downloading in the background. This can be caused by OS settings.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Connection was interrupted while downloading in the background. This can be caused by enabling \'Enter Low-Priority State on Pause\' or OS settings.';

  @override
  String get activeDownloadSize => 'Downloading...';

  @override
  String get missingDownloadSize => 'Deleting...';

  @override
  String get syncingDownloadSize => 'Syncing...';

  @override
  String get runRepairWarning => 'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Show Media with Unknown Library.';

  @override
  String get showNullLibraryItemsSubtitle => 'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => 'Max Concurrent Downloads';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Increasing concurrent downloads may allow increased downloading in the background but may cause some downloads to fail if very large, or cause excessive lag in some cases.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Concurrent Downloads';
  }

  @override
  String get downloadsWorkersSetting => 'Download Worker count';

  @override
  String get downloadsWorkersSettingSubtitle => 'Amount of workers for syncing metadata and deleting downloads. Increasing download workers may speed up download syncing and deleting, especially when server latency is high, but can introduce lag.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Download Workers';
  }

  @override
  String get syncOnStartupSwitch => 'Automatically Sync Downloads at Startup';

  @override
  String get preferQuickSyncSwitch => 'Prefer Quick Syncs';

  @override
  String get preferQuickSyncSwitchSubtitle => 'When performing syncs, some typically static items (like tracks and albums) will not be updated. Download repair will always perform a full sync.';

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
  String get transcodingStreamingContainerTitle => 'Select Transcoding Container';

  @override
  String get transcodingStreamingContainerSubtitle => 'Select the segment container to use when streaming transcoded audio. Already queued tracks will not be affected.';

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
  String get downloadBitrateSubtitle => 'A higher bitrate gives higher quality audio at the cost of larger storage requirements.';

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
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transcoded',
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
        'other': ' as $codec @ $bitrate',
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
    return 'Download original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Transcode Redownload queued.';

  @override
  String get redownloadTitle => 'Automatically Redownload Transcodes';

  @override
  String get redownloadSubtitle => 'Automatically redownload tracks which are expected to be at a different quality due to parent collection changes.';

  @override
  String get defaultDownloadLocationButton => 'Set as default download location.  Disable to select per download.';

  @override
  String get fixedGridSizeSwitchTitle => 'Use fixed size grid tiles';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Grid tile sizes will not respond to window/screen size.';

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
  String get allowSplitScreenSubtitle => 'The player will be displayed alongside other views on wider displays.';

  @override
  String get enableVibration => 'Enable vibration';

  @override
  String get enableVibrationSubtitle => 'Whether to enable vibration.';

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
  String get hidePlayerBottomActions => 'Hide bottom actions';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Hide the queue and lyrics buttons on the player screen. Swipe up to access the queue, swipe left (below the album cover) to view lyrics if available.';

  @override
  String get prioritizePlayerCover => 'Prioritize album cover';

  @override
  String get prioritizePlayerCoverSubtitle => 'Prioritize showing a larger album cover on player screen. Non-critical controls will be hidden more aggressively at small screen sizes.';

  @override
  String get suppressPlayerPadding => 'Suppress player controls padding';

  @override
  String get suppressPlayerPaddingSubtitle => 'Fully minimizes padding between player screen controls when album cover is not at full size.';

  @override
  String get lockDownload => 'Always Keep on Device';

  @override
  String get showArtistChipImage => 'Show artist images with artist name';

  @override
  String get showArtistChipImageSubtitle => 'This affects small artist image previews, such as on the player screen.';

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
  String get trackOfflineFavoritesSubtitle => 'This allows showing more up-to-date favorite statuses while offline.  Does not download any additional files.';

  @override
  String get allPlaylistsInfoSetting => 'Download Playlist Metadata';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Sync metadata for all playlists to improve your playlist experience';

  @override
  String get downloadFavoritesSetting => 'Download all favorites';

  @override
  String get downloadAllPlaylistsSetting => 'Download all playlists';

  @override
  String get fiveLatestAlbumsSetting => 'Download 5 latest albums';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Downloads will be removed as they age out.  Lock the download to prevent an album from being removed.';

  @override
  String get cacheLibraryImagesSettings => 'Cache current library images';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'All album, artist, genre, and playlist covers in the currently active library will be downloaded.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Show track progress on in-app miniplayer';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Controls if the in-app miniplayer / now playing bar at the bottom of the music screen functions as a progress bar.';

  @override
  String get lyricsScreen => 'Lyrics View';

  @override
  String get showLyricsTimestampsTitle => 'Show timestamps for synchronized lyrics';

  @override
  String get showLyricsTimestampsSubtitle => 'Controls if the timestamp of each lyric line is shown in the lyrics view, if available.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Show stop button on media notification';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Controls if the media notification has a stop button in addition to the pause button. This lets you stop playback without opening the app.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Show seek controls on media notification';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Controls if the media notification has a seekable progress bar. This lets you change the playback position without opening the app.';

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
  String get lyricsAlignmentSubtitle => 'Controls the alignment of lyrics in the lyrics view.';

  @override
  String get lyricsFontSizeTitle => 'Lyrics font size';

  @override
  String get lyricsFontSizeSubtitle => 'Controls the font size of lyrics in the lyrics view.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Show album before lyrics';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Controls if the album cover is shown above the lyrics before being scrolled away.';

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
  String get keepScreenOnWhilePluggedIn => 'Keep Screen On only while plugged in';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignore the Keep Screen On setting if device is unplugged';

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
  String get showFeatureChipsToggleSubtitle => 'Show advanced track info like codec, bitrate, and more on the player screen.';

  @override
  String get albumScreen => 'Album Screen';

  @override
  String get showCoversOnAlbumScreenTitle => 'Show Album Covers For Tracks';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Show album covers for each track separately on the album screen.';

  @override
  String get emptyTopTracksList => 'You haven\'t listened to any track by this artist yet.';

  @override
  String get emptyFilteredListTitle => 'No items found';

  @override
  String get emptyFilteredListSubtitle => 'No items match the filter. Try turning off the filter or changing the search term.';

  @override
  String get resetFiltersButton => 'Reset filters';

  @override
  String get resetSettingsPromptGlobal => 'Are you sure you want to reset ALL settings to their defaults?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Reset ALL settings';

  @override
  String get resetSettingsPromptLocal => 'Do you want to reset these settings back to their defaults?';

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
  String get allowDeleteFromServerSubtitle => 'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
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
        'cantDelete': ' This item will stay on this device until the next sync.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'this device',
        'server': 'the servers file system and library.$_temp1\nThis action cannot be reverted',
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
  String get downloadSizeWarningCutoffSubtitle => 'A warning message will be displayed when downloading more than this many tracks at once.';

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
