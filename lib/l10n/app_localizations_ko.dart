// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get finamp => '핀앰프(Finamp)';

  @override
  String get finampTagline => '오픈소스 Jellyfin 젤리핀 음악 플레이어';

  @override
  String startupError(String error) {
    return '앱 시작중에 문제가 발생했습니다. 오류 내용:$error\n\n\"github.com/UnicornsOnLSD/finamp\"에 이 페이지의 캡처 화면을 첨부하여 \'이슈\'를 등록 해주세요. 이 문제가 지속되면 당신은 앱 데이터를 삭제하여 앱을 초기화 할 수 있습니다.';
  }

  @override
  String get about => 'Finamp(핀앰프) 소개';

  @override
  String get aboutContributionPrompt => '대박 멋진 사람들이 여가 시간을 할애하여 만들었습니다.\n당신도 기여할 수 있습니다!';

  @override
  String get aboutContributionLink => 'Github의 핀앰프 Finamp에 기여하기:';

  @override
  String get aboutReleaseNotes => '최신 릴리즈 노트 읽어보기:';

  @override
  String get aboutTranslations => '핀앰프 Finamp를 당신의 언어로 번역해주세요:';

  @override
  String get aboutThanks => '핀앰프 Finamp와 함께 해주셔서 고맙습니다!';

  @override
  String get loginFlowWelcomeHeading => '환영해요, 핀앰프 Finamp 입니다';

  @override
  String get loginFlowSlogan => '당신의 음악을 원하는 방식으로 들어보세요.';

  @override
  String get loginFlowGetStarted => '시작합니다!';

  @override
  String get viewLogs => '로그 보기';

  @override
  String get changeLanguage => '언어 변경';

  @override
  String get loginFlowServerSelectionHeading => '젤리핀 Jellyfin에 연결하기';

  @override
  String get back => '뒤로가기';

  @override
  String get serverUrl => '서버 URL';

  @override
  String get internalExternalIpExplanation => '귀하의 Jellyfin 서버에 원격으로 접속하려면, 외부 IP 주소를 사용해야 합니다.\n\n귀하의 서버가 HTTP 기본 포트(80/443)에 있거나 젤리핀 Jellyfin 기본 포트(8096)에 있을 경우, 포트를 지정할 필요는 없습니다.\n\n주소가 정확하다면 입력란 아래에 서버 정보가 뜨는 것을 볼 수 있을 것입니다.';

  @override
  String get serverUrlHint => '(예시) demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => '서버 주소 도움말';

  @override
  String get emptyServerUrl => '서버 URL은 필수값 입니다';

  @override
  String get connectingToServer => '서버 접속중…';

  @override
  String get loginFlowLocalNetworkServers => '로컬 네트워크의 서버:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => '서버 검색중…';

  @override
  String get loginFlowAccountSelectionHeading => '계정을 선택하세요';

  @override
  String get backToServerSelection => '‘서버 선택’으로 돌아가기';

  @override
  String get loginFlowNamelessUser => '미등록된 사용자';

  @override
  String get loginFlowCustomUser => '계정 직접 입력하기';

  @override
  String get loginFlowAuthenticationHeading => '계정 로그인하기';

  @override
  String get backToAccountSelection => '‘계정 선택’으로 돌아가기';

  @override
  String get loginFlowQuickConnectPrompt => '‘퀵 커넥트’ 코드 사용하기';

  @override
  String get loginFlowQuickConnectInstructions => '젤리핀 Jellyfin을 앱이나 웹사이트로 여세요. 사용자 아이콘을 클릭하세요. ‘퀵 커넥트’를 선택하세요.';

  @override
  String get loginFlowQuickConnectDisabled => '이 서버는 퀵 커넥트 접속이 비활성화 되어있습니다.';

  @override
  String get orDivider => '또는';

  @override
  String get loginFlowSelectAUser => '사용자 선택';

  @override
  String get username => '사용자 이름(아이디)';

  @override
  String get usernameHint => '사용자 이름을 입력하세요';

  @override
  String get usernameValidationMissingUsername => '사용자 이름을 입력하세요';

  @override
  String get password => '암호';

  @override
  String get passwordHint => '암호를 입력하세요';

  @override
  String get login => '로그인';

  @override
  String get logs => '로그(사용기록)';

  @override
  String get next => '다음';

  @override
  String get selectMusicLibraries => '음악 라이브러리 선택';

  @override
  String get couldNotFindLibraries => '라이브러리를 찾을 수 없습니다.';

  @override
  String get unknownName => '알 수 없는 이름';

  @override
  String get tracks => '곡들';

  @override
  String get albums => '앨범';

  @override
  String get artists => '아티스트';

  @override
  String get genres => '장르';

  @override
  String get playlists => '플레이리스트';

  @override
  String get startMix => '믹스 시작하기';

  @override
  String get startMixNoTracksArtist => '믹스를 시작하기 전에 \'아티스트\'를 길게 탭하여 믹스 빌더에서 추가하거나 제거하세요';

  @override
  String get startMixNoTracksAlbum => '믹스를 시작하기 전에 \'앨범\'을 길게 탭하여 믹스 빌더에서 추가하거나 제거하세요';

  @override
  String get startMixNoTracksGenre => '믹스를 시작하기 전에 \'장르\'를 길게 탭하여 믹스 빌더에서 추가하거나 제거하세요';

  @override
  String get music => '음악';

  @override
  String get clear => '삭제(비우기)';

  @override
  String get favourites => '즐겨찾기';

  @override
  String get shuffleAll => '임의 재생(모두)';

  @override
  String get downloads => '다운로드';

  @override
  String get settings => '설정';

  @override
  String get offlineMode => '오프라인 모드';

  @override
  String get sortOrder => '정렬 순서';

  @override
  String get sortBy => '정렬 기준';

  @override
  String get title => '제목';

  @override
  String get album => '앨범';

  @override
  String get albumArtist => '앨범 아티스트';

  @override
  String get artist => '아티스트';

  @override
  String get budget => '예산';

  @override
  String get communityRating => '커뮤니티 평점';

  @override
  String get criticRating => '비평가 평점';

  @override
  String get dateAdded => '추가된 날짜';

  @override
  String get datePlayed => '재생한 날짜';

  @override
  String get playCount => '재생 횟수';

  @override
  String get premiereDate => '초연(프리미어) 날짜';

  @override
  String get productionYear => '제작년도';

  @override
  String get name => '이름';

  @override
  String get random => '랜덤';

  @override
  String get revenue => '수익';

  @override
  String get runtime => '런타임(상영 시간)';

  @override
  String get syncDownloadedPlaylists => '다운로드한 플레이리스트 동기화';

  @override
  String get downloadMissingImages => '누락된 이미지 다운로드';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '누락된 이미지 $count건 다운로드',
      one: '누락된 이미지 $count건 다운로드',
      zero: '누락된 이미지 없음',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => '진행중인 다운로드';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count건 다운로드',
      one: '$count건 다운로드',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount 곡',
      one: '$trackCount 곡',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount 이미지',
      one: '$imageCount 이미지',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount 동기화 노드',
      one: '$syncCount 동기화 노드',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\n현재 복구중',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count건 완료';
  }

  @override
  String dlFailed(int count) {
    return '$count건 실패';
  }

  @override
  String dlEnqueued(int count) {
    return '$count건 대기열에 추가됨';
  }

  @override
  String dlRunning(int count) {
    return '$count건 진행중';
  }

  @override
  String get activeDownloadsTitle => '진행중인 다운로드';

  @override
  String get noActiveDownloads => '진행중인 다운로드가 없음.';

  @override
  String get errorScreenError => '오류 목록을 가져오지 못했습니다! 이 시점에서는 GitHub에 문제를 등록하고 앱 데이터를 삭제해야 합니다';

  @override
  String get failedToGetTrackFromDownloadId => '다운로드 ID에서 곡을 가져오지 못했습니다';

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
  String get error => '오류';

  @override
  String discNumber(int number) {
    return '디스크 $number';
  }

  @override
  String get playButtonLabel => '재생';

  @override
  String get shuffleButtonLabel => '임의 재생';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 곡',
      one: '$count 곡',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 곡',
      one: '$count 곡',
    );
    return '$_temp0, $downloads 다운로드 됨';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 곡',
      one: '$count 곡',
    );
    return '$_temp0 다운로드 됨';
  }

  @override
  String get editPlaylistNameTooltip => '플레이리스트 이름 수정';

  @override
  String get editPlaylistNameTitle => '플레이리스트 이름 수정';

  @override
  String get required => '필수 항목';

  @override
  String get updateButtonLabel => '업데이트';

  @override
  String get playlistNameUpdated => '플레이리스트 이름을 갱신했습니다.';

  @override
  String get favourite => '즐겨찾기';

  @override
  String get downloadsDeleted => '다운로드 항목을 삭제했습니다.';

  @override
  String get addDownloads => '다운로드 추가';

  @override
  String get location => '위치';

  @override
  String get confirmDownloadStarted => '다운로드 시작함';

  @override
  String get downloadsQueued => '파일을 다운로드 합니다';

  @override
  String get addButtonLabel => '추가';

  @override
  String get shareLogs => '로그(사용기록) 공유';

  @override
  String get logsCopied => '로그(사용기록) 복사함.';

  @override
  String get message => '메시지';

  @override
  String get stackTrace => '스택 추적';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Mozilla Public License 2.0에 따라 라이선스가 부여됐습니다.\n소스 코드는 $sourceCodeLink에서 확인할 수 있습니다.';
  }

  @override
  String get transcoding => '트랜스코딩';

  @override
  String get downloadLocations => '다운로드 위치';

  @override
  String get audioService => '오디오 서비스';

  @override
  String get interactions => '상호작용';

  @override
  String get layoutAndTheme => '레이아웃 & 테마';

  @override
  String get notAvailableInOfflineMode => '오프라인 모드에서는 사용할 수 없습니다';

  @override
  String get logOut => '로그아웃';

  @override
  String get downloadedTracksWillNotBeDeleted => '다운로드한 곡들은 삭제되지 않습니다';

  @override
  String get areYouSure => '확실한가요?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin은 트랜스코딩에 AAC를 사용합니다';

  @override
  String get enableTranscoding => '트랜스코딩 활성화';

  @override
  String get enableTranscodingSubtitle => '서버 측에서 음악 스트리밍을 트랜스코딩 합니다.';

  @override
  String get bitrate => '비트레이트';

  @override
  String get bitrateSubtitle => '비트레이트가 높으면 고품질의 음악을 들을 수 있습니다. 데이터 사용량도 증가합니다.';

  @override
  String get customLocation => '사용자 지정 위치';

  @override
  String get appDirectory => '앱 디렉토리';

  @override
  String get addDownloadLocation => '다운로드 위치 추가';

  @override
  String get selectDirectory => '디렉토리 선택';

  @override
  String get unknownError => '알수 없는 오류';

  @override
  String get pathReturnSlashErrorMessage => '\"/(슬래시)\"로 끝나는 경로는 사용할 수 없습니다';

  @override
  String get directoryMustBeEmpty => '디렉토리는 비어 있어야 합니다';

  @override
  String get customLocationsBuggy => '사용자 지정 위치는 대부분의 상황에서 권장하지 않습니다(버그가 매우 많이 발생할 수 있습니다). 운영체제 \'음악\'폴더 위치의 경우 시스템 제한 때문에 앨범 커버를 저장할 수 없습니다.';

  @override
  String get enterLowPriorityStateOnPause => '일시 중지시 낮은 우선순위 상태로 전환합니다';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => '일시 중지시 알림창을 밀어서 사라지게 합니다. 안드로이드(OS)에서는 일시 중지시 서비스를 강제 종료할 수 있게 합니다.';

  @override
  String get shuffleAllTrackCount => '전곡 임의 재생시 곡 수';

  @override
  String get shuffleAllTrackCountSubtitle => '\'전곡 임의 재생\' 버튼을 사용할 때 불러올 곡의 개수입니다.';

  @override
  String get viewType => '보기 유형';

  @override
  String get viewTypeSubtitle => '음악 화면 보기 유형';

  @override
  String get list => '목록';

  @override
  String get grid => '그리드(격자)';

  @override
  String get customizationSettingsTitle => '사용자 정의';

  @override
  String get playbackSpeedControlSetting => '‘재생 속도 제어’ 표시 여부';

  @override
  String get playbackSpeedControlSettingSubtitle => '재생 화면에서 ‘재생 속도 제어’ 표시 여부를 정합니다';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return '자동:\n핀앰프 Finamp는 재생중인 곡이 팟캐스트나 오디오북인지 식별을 시도합니다. 곡이 $trackDuration 분보다 길거나, 앨범이 $albumDuration 시간보다 길거나, 곡에 장르가 $genreList중 하나라도 지정된 경우,\n‘재생 속도 제어’가 재생 화면 메뉴에 나타납니다.\n\n보이기:\n‘재생 속도 제어’가 항상 재생 화면 메뉴에 나타납니다.\n\n숨기기:\n‘재생 속도 제어’가 항상 재생 화면 메뉴에 나타나지 않습니다.';
  }

  @override
  String get automatic => '자동';

  @override
  String get shown => '보이기';

  @override
  String get hidden => '숨기기';

  @override
  String get speed => '속도';

  @override
  String get reset => '초기화';

  @override
  String get apply => '적용';

  @override
  String get portrait => '세로 보기';

  @override
  String get landscape => '가로 보기';

  @override
  String gridCrossAxisCount(String value) {
    return '$value 그리드 열 갯수';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '$value 일때 한 행당 그리드 타일의 개수.';
  }

  @override
  String get showTextOnGridView => '그리드 보기에서 텍스트를 보여줌';

  @override
  String get showTextOnGridViewSubtitle => '그리드 음악 화면에서 \'텍스트(곡목, 아티스트 등)\' 표시 여부를 설정합니다.';

  @override
  String get useCoverAsBackground => '흐릿한 앨범 커버를 배경화면으로 사용하기';

  @override
  String get useCoverAsBackgroundSubtitle => '앱 배경화면으로 흐릿한 앨범 커버를 사용할지 여부를 설정.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => '앨범 커버 여백 최소값';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => '재생 화면에서 앨범 커버 가장자리의 최소 여백 값을 설정 (화면 너비 기준 %단위).';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => '앨범 아티스트와 동일한 경우, 곡 아티스트를 숨김';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => '앨범 화면에서 앨범 아티스트와 동일한 \'곡 아티스트\' 표시 여부를 설정합니다.';

  @override
  String get showArtistsTopTracks => '아티스트 보기에서 주요 곡들을 보여줍니다';

  @override
  String get showArtistsTopTracksSubtitle => '아티스트의 최다 청취곡(5곡 까지) 표시 여부를 설정.';

  @override
  String get disableGesture => '제스처 비활성화';

  @override
  String get disableGestureSubtitle => '제스처 비활성화 여부를 설정합니다.';

  @override
  String get showFastScroller => '빠른 스크롤 표시';

  @override
  String get theme => '테마';

  @override
  String get system => '시스템';

  @override
  String get light => '밝은 테마';

  @override
  String get dark => '어두운 테마';

  @override
  String get tabs => '탭';

  @override
  String get playerScreen => '재생 화면';

  @override
  String get cancelSleepTimer => '취침 타이머를 취소할까요?';

  @override
  String get yesButtonLabel => '네';

  @override
  String get noButtonLabel => '아니오';

  @override
  String get setSleepTimer => '취침 타이머 설정';

  @override
  String get hours => '시간';

  @override
  String get seconds => '초';

  @override
  String get minutes => '분';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime / $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return '$currentTrackIndex / $totalTrackCount 곡';
  }

  @override
  String get invalidNumber => '잘못된 숫자';

  @override
  String get sleepTimerTooltip => '취침 타이머';

  @override
  String sleepTimerRemainingTime(int time) {
    return '취침 타이머 $time분 남음';
  }

  @override
  String get addToPlaylistTooltip => '플레이리스트에 추가';

  @override
  String get addToPlaylistTitle => '플레이리스트에 추가';

  @override
  String get addToMorePlaylistsTooltip => '더 많은 플레이리스트에 추가하기';

  @override
  String get addToMorePlaylistsTitle => '더 많은 플레이리스트에 추가하기';

  @override
  String get removeFromPlaylistTooltip => '이 플레이리스트에서 삭제';

  @override
  String get removeFromPlaylistTitle => '이 플레이리스트에서 삭제';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return '\'$playlistName\' 플레이리스트에서 삭제';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return '\'$playlistName\' 플레이리스트에서 삭제';
  }

  @override
  String get newPlaylist => '새 플레이리스트';

  @override
  String get createButtonLabel => '만들기';

  @override
  String get playlistCreated => '플레이리스트 생성됨.';

  @override
  String get playlistActionsMenuButtonTooltip => '탭하여 플레이리스트에 추가합니다. 길게 탭하여 즐겨찾기에 추가/삭제 합니다.';

  @override
  String get noAlbum => '앨범 없음';

  @override
  String get noItem => '곡 없음';

  @override
  String get noArtist => '아티스트 없음';

  @override
  String get unknownArtist => '알 수 없는 아티스트';

  @override
  String get unknownAlbum => '알 수 없는 앨범';

  @override
  String get playbackModeDirectPlaying => '직접 재생';

  @override
  String get playbackModeTranscoding => '트랜스코딩';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => '다운로드 재생';

  @override
  String get queue => '대기열';

  @override
  String get addToQueue => '대기열에 추가';

  @override
  String get replaceQueue => '대기열 교체';

  @override
  String get instantMix => '인스턴트 믹스';

  @override
  String get goToAlbum => '앨범으로 이동';

  @override
  String get goToArtist => '아티스트로 가기';

  @override
  String get goToGenre => '장르로 가기';

  @override
  String get removeFavourite => '즐겨찾기 삭제';

  @override
  String get addFavourite => '즐겨찾기 추가';

  @override
  String get confirmFavoriteAdded => '즐겨찾기에 추가됨';

  @override
  String get confirmFavoriteRemoved => '즐겨찾기에서 삭제됨';

  @override
  String get addedToQueue => '대기열 끝에 추가됨.';

  @override
  String get insertedIntoQueue => '대기열 사이에 추가됨.';

  @override
  String get queueReplaced => '대기열이 교체됨.';

  @override
  String get confirmAddedToPlaylist => '플레이리스트에 추가됨.';

  @override
  String get removedFromPlaylist => '플레이리스트에서 삭제됨.';

  @override
  String get startingInstantMix => '인스턴트 믹스 시작.';

  @override
  String get anErrorHasOccured => '오류가 발생했습니다.';

  @override
  String responseError(String error, int statusCode) {
    return '$error 상태 코드 $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error 상태 코드 $statusCode. 이것은 아마도 잘못된 로그인 정보를 사용했거나, 더 이상 로그인되어 있지 않음을 의미합니다.';
  }

  @override
  String get removeFromMix => '믹스에서 삭제';

  @override
  String get addToMix => '믹스에 추가';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 아이템 다시 다운로드함',
      one: '$count 아이템 다시 다운로드함',
      zero: '다시 다운로드할 필요가 없습니다.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => '버퍼 시간';

  @override
  String get bufferDurationSubtitle => '버퍼링 해야 하는 최대 시간(초) 입니다. 변경시 다시 시작해야 합니다.';

  @override
  String get bufferDisableSizeConstraintsTitle => '버퍼 크기를 제한하지 않습니다';

  @override
  String get bufferDisableSizeConstraintsSubtitle => '버퍼 크기 제한을 비활성화 합니다(버퍼 크기). 버퍼는 항상 설정한 시간만큼 로드되며(버퍼 시간), 용량이 아주 큰 파일에서는 충돌을 일으킬 수 있습니다. 옵션 적용을 위해 재시작이 필요합니다.';

  @override
  String get bufferSizeTitle => '버퍼 크기';

  @override
  String get bufferSizeSubtitle => '버퍼의 최대 크기(MB단위). 변경시 재시작이 필요합니다';

  @override
  String get language => '언어';

  @override
  String get skipToPreviousTrackButtonTooltip => '곡의 처음 또는 이전 곡으로 넘기기';

  @override
  String get skipToNextTrackButtonTooltip => '다음 곡으로 넘기기';

  @override
  String get togglePlaybackButtonTooltip => '재생 또는 일시정지';

  @override
  String get previousTracks => '이전 곡들';

  @override
  String get nextUp => '넥스트 업';

  @override
  String get clearNextUp => '넥스트 업 지우기';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => '다음에서 재생중';

  @override
  String get playNext => '다음 곡 재생';

  @override
  String get addToNextUp => '넥스트 업에 추가';

  @override
  String get shuffleNext => '다음에 임의 재생';

  @override
  String get shuffleToNextUp => '넥스트 업에 임의 재생 추가';

  @override
  String get shuffleToQueue => '대기열 끝에 임의 재생 추가';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '곡',
        'album': '앨범',
        'artist': '아티스트',
        'playlist': '플레이리스트',
        'genre': '장르',
        'other': '아이템',
      },
    );
    return '다음 재생 : $_temp0';
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
    return '넥스트 업에 추가됨 : $_temp0';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': '곡',
        'album': '앨범',
        'artist': '아티스트',
        'playlist': '플레이리스트',
        'genre': '장르',
        'other': '아이템',
      },
    );
    return '대기열에 $_temp0 추가됨';
  }

  @override
  String get confirmShuffleNext => '다음 곡은 임의 재생합니다';

  @override
  String get confirmShuffleToNextUp => '넥스트 업에 임의 재생으로 추가됨';

  @override
  String get confirmShuffleToQueue => '대기열에 임의 재생으로 추가됨';

  @override
  String get placeholderSource => '출처 미상';

  @override
  String get playbackHistory => '재생 이력';

  @override
  String get shareOfflineListens => '오프라인 청취(재생 이력) 공유(Export)';

  @override
  String get yourLikes => '내가 좋아하는 노래들';

  @override
  String mix(String mixSource) {
    return '$mixSource - 믹스';
  }

  @override
  String get tracksFormerNextUp => '넥스트 업으로 추가된 곡들';

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
  String get playbackSpeedIncreaseLabel => '재생 속도 빠르게';

  @override
  String get loopModeNoneButtonLabel => '반복 안 함';

  @override
  String get loopModeOneButtonLabel => '이 곡 반복';

  @override
  String get loopModeAllButtonLabel => '전체 반복';

  @override
  String get queuesScreen => '‘지금 재생중’ 복원';

  @override
  String get queueRestoreButtonLabel => '복원';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString에 저장됨';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return '재생중: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 곡',
      one: '1 곡',
    );
    return '$_temp0, $remaining 남음';
  }

  @override
  String get queueLoadingMessage => '대기열 복원중…';

  @override
  String get queueRetryMessage => '대기열 복원에 실패했습니다. 다시 시도할까요?';

  @override
  String get autoloadLastQueueOnStartup => '마지막 대기열 자동 복원';

  @override
  String get autoloadLastQueueOnStartupSubtitle => '앱 시작할 때, ‘마지막으로 재생한 대기열’ 복원을 시도합니다.';

  @override
  String get reportQueueToServer => '현재 대기열을 서버로 보고할까요?';

  @override
  String get reportQueueToServerSubtitle => '활성화시 핀앰프 Finamp는 현재 대기열을 서버로 보냅니다. 현재 거의 안쓰는 기능이며 네트워크 트래픽이 증가합니다.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => '재생 세션 갱신 빈도';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => '현재 재생 상태를 서버로 보내는 주기를 초단위로 설정합니다. 설정값은 세션 타임아웃을 방지하기 위해 300초(5분) 미만이어야 합니다.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => '젤리핀 Jellyfin서버가 최근 5분 동안 클라이언트로부터 어떠한 업데이트도 받지 못하면, 서버는 재생이 종료된 것으로 간주합니다. 이는 5분 이상의 곡의 경우 재생이 종료된 것으로 잘못 보고되어 재생 보고 데이터의 품질이 저하될 수 있음을 의미합니다.';

  @override
  String get topTracks => '주요 곡들';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 앨범',
      one: '$count 앨범',
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
  String get confirm => '확인';

  @override
  String get close => 'Close';

  @override
  String get showUncensoredLogMessage => '이 로그(사용기록)는 귀하의 로그인 정보를 포함합니다. 표시할까요?';

  @override
  String get resetTabs => '탭 초기화';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get noMusicLibrariesTitle => '음악 라이브러리 없음';

  @override
  String get noMusicLibrariesBody => '핀앰프 Finamp가 음악 라이브러리를 찾을 수 없습니다. 귀하의 젤리핀 Jellyfin 서버에 콘텐츠 유형이 \"음악\"으로 설정된 라이브러리가 하나 이상 있는지 확인하세요.';

  @override
  String get refresh => '새로고침';

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
  String get swipeInsertQueueNext => '스와이프한 곡 다음 재생';

  @override
  String get swipeInsertQueueNextSubtitle => '곡 목록에서 스와이프 했을 때, 곡을 대기열 끝에 추가하는 대신 바로 다음 곡으로 삽입할 수 있습니다.';

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
  String get runRepairWarning => '다운로드 마이그레이션을 완료하기 위한 서버 연결이 안됩니다. 다시 온라인에 접속하면 즉시 다운로드 화면에서 \'다운로드 복구\'를 실행하십시오.';

  @override
  String get downloadSettings => '다운로드';

  @override
  String get showNullLibraryItemsTitle => '알 수 없는 라이브러리의 미디어 보여주기.';

  @override
  String get showNullLibraryItemsSubtitle => 'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => '동시 다운로드 최대값';

  @override
  String get maxConcurrentDownloadsSubtitle => '동시 다운로드 최대값을 증가시킬 경우, 백드라운드 다운로드 작업이 증가할 수 있습니다. 하지만 용량이 매우 큰 경우 다운로드가 실패할 수 있으며 어떤 경우에는 과도한 지연이 발생할 수 있습니다.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count 동시 다운로드';
  }

  @override
  String get downloadsWorkersSetting => '다운로드 작업자 개수';

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
