// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get finamp => 'பொருள்';

  @override
  String get finampTagline => 'ஒரு திறந்த மூல செல்லிஃபின் மியூசிக் பிளேயர்';

  @override
  String startupError(String error) {
    return 'பயன்பாட்டு தொடக்கத்தின் போது ஏதோ தவறு ஏற்பட்டது. பிழை: $error\n\n இந்த பக்கத்தின் திரை சாட்டுடன் github.com/unicornsonlsd/finamp இல் ஒரு சிக்கலை உருவாக்கவும். இந்த சிக்கல் தொடர்ந்தால், பயன்பாட்டை மீட்டமைக்க உங்கள் பயன்பாட்டு தரவை அழிக்கலாம்.';
  }

  @override
  String get about => 'பொருள் பற்றி';

  @override
  String get aboutContributionPrompt => 'அற்புதமான நபர்களால் அவர்களின் ஓய்வு நேரத்தில் தயாரிக்கப்பட்டது.\n நீங்கள் அவர்களில் ஒருவராக இருக்கலாம்!';

  @override
  String get aboutContributionLink => 'கிட்அப்பில் ஃபினாம்பிற்கு பங்களிக்கவும்:';

  @override
  String get aboutReleaseNotes => 'அண்மைக் கால வெளியீட்டுக் குறிப்புகளைப் படியுங்கள்:';

  @override
  String get aboutTranslations => 'உங்கள் மொழியில் பொருள் மொழிபெயர்க்க உதவுங்கள்:';

  @override
  String get aboutThanks => 'ஃபினாம்பைப் பயன்படுத்தியதற்கு நன்றி!';

  @override
  String get loginFlowWelcomeHeading => 'வரவேற்கிறோம்';

  @override
  String get loginFlowSlogan => 'உங்கள் இசை, நீங்கள் விரும்பும் விதம்.';

  @override
  String get loginFlowGetStarted => 'தொடங்கவும்!';

  @override
  String get viewLogs => 'பதிவுகளைக் காண்க';

  @override
  String get changeLanguage => 'மொழியை மாற்றவும்';

  @override
  String get loginFlowServerSelectionHeading => 'செல்லிஃபினுடன் இணைக்கவும்';

  @override
  String get back => 'பின்';

  @override
  String get serverUrl => 'சேவையக முகவரி';

  @override
  String get internalExternalIpExplanation => 'உங்கள் செல்லிஃபின் சேவையகத்தை தொலைவிலிருந்து அணுக விரும்பினால், உங்கள் வெளிப்புற ஐபி பயன்படுத்த வேண்டும்.\n\n உங்கள் சேவையகம் HTTP இயல்புநிலை துறைமுகம் (80 அல்லது 443) அல்லது செல்லிஃபின் இயல்புநிலை துறைமுகம் (8096) இல் இருந்தால், நீங்கள் துறைமுகத்தை குறிப்பிட வேண்டியதில்லை.\n\n முகவரி சரியாக இருந்தால், உங்கள் சேவையகத்தைப் பற்றிய சில தகவல்களை உள்ளீட்டு புலத்திற்கு கீழே பாப் அப் பார்க்க வேண்டும்.';

  @override
  String get serverUrlHint => 'எ.கா. Dem.yelifi';

  @override
  String get serverUrlInfoButtonTooltip => 'சேவையக முகவரி உதவி';

  @override
  String get emptyServerUrl => 'சேவையக முகவரி காலியாக இருக்க முடியாது';

  @override
  String get connectingToServer => 'சேவையகத்துடன் இணைக்கிறது ...';

  @override
  String get loginFlowLocalNetworkServers => 'உங்கள் உள்ளக நெட்வொர்க்கில் சேவையகங்கள்:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'சேவையகங்களுக்கு ச்கேன் செய்வது ...';

  @override
  String get loginFlowAccountSelectionHeading => 'உங்கள் கணக்கைத் தேர்ந்தெடுக்கவும்';

  @override
  String get backToServerSelection => 'சேவையக தேர்வுக்குத் திரும்பு';

  @override
  String get loginFlowNamelessUser => 'பெயரிடப்படாத பயனர்';

  @override
  String get loginFlowCustomUser => 'தனிப்பயன் பயனர்';

  @override
  String get loginFlowAuthenticationHeading => 'உங்கள் கணக்கில் உள்நுழைக';

  @override
  String get backToAccountSelection => 'கணக்கு தேர்வுக்குத் திரும்பு';

  @override
  String get loginFlowQuickConnectPrompt => 'விரைவான இணைப்பு குறியீட்டைப் பயன்படுத்தவும்';

  @override
  String get loginFlowQuickConnectInstructions => 'செல்லிஃபின் பயன்பாடு அல்லது வலைத்தளத்தைத் திறந்து, உங்கள் பயனர் ஐகானைக் சொடுக்கு செய்து, விரைவான இணைப்பைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get loginFlowQuickConnectDisabled => 'இந்த சேவையகத்தில் விரைவான இணைப்பு முடக்கப்பட்டுள்ளது.';

  @override
  String get orDivider => 'அல்லது';

  @override
  String get loginFlowSelectAUser => 'ஒரு பயனரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get username => 'பயனர்பெயர்';

  @override
  String get usernameHint => 'உங்கள் பயனர்பெயரை உள்ளிடவும்';

  @override
  String get usernameValidationMissingUsername => 'பயனர்பெயரை உள்ளிடவும்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get passwordHint => 'உங்கள் கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get login => 'புகுபதிகை';

  @override
  String get logs => 'பதிவுகள்';

  @override
  String get next => 'அடுத்தது';

  @override
  String get selectMusicLibraries => 'இசை நூலகங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get couldNotFindLibraries => 'எந்த நூலகங்களையும் கண்டுபிடிக்க முடியவில்லை.';

  @override
  String get unknownName => 'தெரியாத பெயர்';

  @override
  String get tracks => 'தடங்கள்';

  @override
  String get albums => 'ஆல்பம்';

  @override
  String get artists => 'கலைஞர்கள்';

  @override
  String get genres => 'வகைகள்';

  @override
  String get playlists => 'பிளேலிச்ட்கள்';

  @override
  String get startMix => 'கலவையைத் தொடங்குங்கள்';

  @override
  String get startMixNoTracksArtist => 'கலவையைத் தொடங்குவதற்கு முன் அதை மிக்ச் பில்டரிலிருந்து சேர்க்க அல்லது அகற்ற ஒரு கலைஞரை நீண்ட அழுத்தவும்';

  @override
  String get startMixNoTracksAlbum => 'கலவையைத் தொடங்குவதற்கு முன் மிக்ச் பில்டரிடமிருந்து சேர்க்க அல்லது அகற்ற ஒரு ஆல்பத்தை நீண்ட அழுத்தவும்';

  @override
  String get startMixNoTracksGenre => 'கலவையைத் தொடங்குவதற்கு முன் அதை மிக்ச் பில்டரிலிருந்து சேர்க்க அல்லது அகற்ற ஒரு வகையை நீண்ட அழுத்தவும்';

  @override
  String get music => 'இசை';

  @override
  String get clear => 'தெளிவான';

  @override
  String get favourites => 'பிடித்தவை';

  @override
  String get shuffleAll => 'அனைத்தையும் மாற்றவும்';

  @override
  String get downloads => 'பதிவிறக்கங்கள்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get offlineMode => 'இணைப்பில்லாத பயன்முறை';

  @override
  String get sortOrder => 'வரிசைப்படுத்தும் முறை';

  @override
  String get sortBy => 'வரிசைப்படுத்தவும்';

  @override
  String get title => 'தலைப்பு';

  @override
  String get album => 'ஆல்பம்';

  @override
  String get albumArtist => 'ஆல்பம் கலைஞர்';

  @override
  String get artist => 'கலைஞர்';

  @override
  String get budget => 'பட்செட்';

  @override
  String get communityRating => 'சமூக மதிப்பீடு';

  @override
  String get criticRating => 'விமர்சகர் மதிப்பீடு';

  @override
  String get dateAdded => 'தேதி சேர்க்கப்பட்டது';

  @override
  String get datePlayed => 'விளையாடிய தேதி';

  @override
  String get playCount => 'விளையாட்டு எண்ணிக்கை';

  @override
  String get premiereDate => 'பிரீமியர் தேதி';

  @override
  String get productionYear => 'விளைவாக்கம் ஆண்டு';

  @override
  String get name => 'பெயர்';

  @override
  String get random => 'சீரற்ற';

  @override
  String get revenue => 'வருவாய்';

  @override
  String get runtime => 'இயக்க நேரம்';

  @override
  String get syncDownloadedPlaylists => 'பதிவிறக்கம் செய்யப்பட்ட பிளேலிச்ட்கள் ஒத்திசைவு';

  @override
  String get downloadMissingImages => 'காணாமல் போன படங்களை பதிவிறக்கவும்';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பதிவிறக்கம் $count காணாமல் போன படங்கள்',
      one: 'பதிவிறக்கம் செய்யப்பட்ட $count காணாமல் போன படம்',
      zero: 'No missing images found',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'செயலில் பதிவிறக்கங்கள்';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பதிவிறக்கங்கள்',
      one: '$count பதிவிறக்கம்',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount டிராக்குகள்',
      one: '$trackCount டிராக்',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount படங்கள்',
      one: '$imageCount படம்',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount முனைகள் ஒத்திசைத்தல்',
      one: '$syncCount முனை ஒத்திசைவு',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: 'நடப்பு பழுதுபார்ப்பு',
      zero: '',
    );
    return '$_temp0, $_temp1, $_temp2, $_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count முடிந்தது';
  }

  @override
  String dlFailed(int count) {
    return '$count தோல்வியுற்றது';
  }

  @override
  String dlEnqueued(int count) {
    return '$count enqueuted';
  }

  @override
  String dlRunning(int count) {
    return '$count இயங்குகிறது';
  }

  @override
  String get activeDownloadsTitle => 'செயலில் பதிவிறக்கங்கள்';

  @override
  String get noActiveDownloads => 'செயலில் பதிவிறக்கங்கள் இல்லை.';

  @override
  String get errorScreenError => 'பிழைகளின் பட்டியலைப் பெறும்போது பிழை ஏற்பட்டது! இந்த கட்டத்தில், நீங்கள் கிதுபில் ஒரு சிக்கலை உருவாக்கி பயன்பாட்டு தரவை நீக்க வேண்டும்';

  @override
  String get failedToGetTrackFromDownloadId => 'பதிவிறக்க ஐடியிலிருந்து கண்காணிப்பதில் தோல்வி';

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
  String get error => 'பிழை';

  @override
  String discNumber(int number) {
    return 'வட்டு $number';
  }

  @override
  String get playButtonLabel => 'விளையாடுங்கள்';

  @override
  String get shuffleButtonLabel => 'கலக்கு';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தடங்கள்',
      one: '$count டிராக்',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தடங்கள்',
      one: '$count டிராக்',
    );
    return '$_temp0, $downloads பதிவிறக்கம் செய்யப்பட்டன';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தடங்கள்',
      one: '$count டிராக்',
    );
    return '$_temp0 பதிவிறக்கம் செய்யப்பட்டன';
  }

  @override
  String get editPlaylistNameTooltip => 'பிளேலிச்ட் பெயரைத் திருத்து';

  @override
  String get editPlaylistNameTitle => 'பிளேலிச்ட் பெயரைத் திருத்து';

  @override
  String get required => 'தேவை';

  @override
  String get updateButtonLabel => 'புதுப்பிப்பு';

  @override
  String get playlistNameUpdated => 'பிளேலிச்ட் பெயர் புதுப்பிக்கப்பட்டது.';

  @override
  String get favourite => 'பிடித்த';

  @override
  String get downloadsDeleted => 'பதிவிறக்கங்கள் நீக்கப்பட்டன.';

  @override
  String get addDownloads => 'பதிவிறக்கங்களைச் சேர்க்கவும்';

  @override
  String get location => 'இடம்';

  @override
  String get confirmDownloadStarted => 'பதிவிறக்கம் தொடங்கியது';

  @override
  String get downloadsQueued => 'தயாரிக்கப்பட்ட, கோப்புகளைப் பதிவிறக்குங்கள்';

  @override
  String get addButtonLabel => 'கூட்டு';

  @override
  String get shareLogs => 'பதிவுகளைப் பகிரவும்';

  @override
  String get logsCopied => 'பதிவுகள் நகலெடுக்கப்பட்டன.';

  @override
  String get message => 'செய்தி';

  @override
  String get stackTrace => 'ச்டாக் சுவடு';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'மொசில்லா பொது உரிமம் 2.0 உடன் உரிமம் பெற்றது.\n மூலக் குறியீடு $sourceCodeLink இல் கிடைக்கிறது.';
  }

  @override
  String get transcoding => 'டிரான்ச்கோடிங்';

  @override
  String get downloadLocations => 'இருப்பிடங்களைப் பதிவிறக்கவும்';

  @override
  String get audioService => 'ஆடியோ பணி';

  @override
  String get interactions => 'இடைவினைகள்';

  @override
  String get layoutAndTheme => 'தளவமைப்பு மற்றும் கருப்பொருள்';

  @override
  String get notAvailableInOfflineMode => 'இணைப்பில்லாத பயன்முறையில் கிடைக்கவில்லை';

  @override
  String get logOut => 'விடுபதிகை';

  @override
  String get downloadedTracksWillNotBeDeleted => 'பதிவிறக்கம் செய்யப்பட்ட தடங்கள் நீக்கப்படாது';

  @override
  String get areYouSure => 'நீங்கள் உறுதியாக இருக்கிறீர்களா?';

  @override
  String get jellyfinUsesAACForTranscoding => 'செல்லிஃபின் டிரான்ச்கோடிங்கிற்கு AAC ஐப் பயன்படுத்துகிறது';

  @override
  String get enableTranscoding => 'டிரான்ச்கோடிங்கை இயக்கவும்';

  @override
  String get enableTranscodingSubtitle => 'சேவையக பக்கத்தில் இசை ச்ட்ரீம்களை டிரான்ச்கோட்ச்.';

  @override
  String get bitrate => 'பிட்ரேட்';

  @override
  String get bitrateSubtitle => 'அதிக பிட்ரேட் அதிக அலைவரிசை செலவில் உயர் தரமான ஆடியோவை வழங்குகிறது.';

  @override
  String get customLocation => 'தனிப்பயன் இடம்';

  @override
  String get appDirectory => 'பயன்பாட்டு அடைவு';

  @override
  String get addDownloadLocation => 'பதிவிறக்க இருப்பிடத்தைச் சேர்க்கவும்';

  @override
  String get selectDirectory => 'கோப்பகத்தைத் தேர்ந்தெடு';

  @override
  String get unknownError => 'தெரியாத பிழை';

  @override
  String get pathReturnSlashErrorMessage => '\"/\" திரும்பும் பாதைகள் பயன்படுத்தப்படாது';

  @override
  String get directoryMustBeEmpty => 'அடைவு காலியாக இருக்க வேண்டும்';

  @override
  String get customLocationsBuggy => 'அனுமதிகளுடன் சிக்கல்கள் காரணமாக தனிப்பயன் இருப்பிடங்கள் மிகவும் தரமற்றவை. இதை சரிசெய்வதற்கான வழிகளைப் பற்றி நான் யோசித்து வருகிறேன், ஆனால் இப்போது அவற்றைப் பயன்படுத்த பரிந்துரைக்க மாட்டேன்.';

  @override
  String get enterLowPriorityStateOnPause => 'இடைநிறுத்தத்தில் குறைந்த முன்னுரிமை நிலையை உள்ளிடவும்';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'இடைநிறுத்தப்படும்போது அறிவிப்பை ச்வைப் செய்ய அனுமதிக்கிறது. இடைநிறுத்தப்படும்போது சேவையை கொல்ல ஆண்ட்ராய்டு ஐ அனுமதிக்கிறது.';

  @override
  String get shuffleAllTrackCount => 'அனைத்து தட எண்ணிக்கையையும் மாற்றவும்';

  @override
  String get shuffleAllTrackCountSubtitle => 'மாற்ற வேண்டிய தடங்களின் அளவு சஃபிள் அனைத்து தடங்களையும் பயன்படுத்தும் போது.';

  @override
  String get viewType => 'பார்வை வகை';

  @override
  String get viewTypeSubtitle => 'இசை திரைக்கான வகை';

  @override
  String get list => 'பட்டியல்';

  @override
  String get grid => 'வலைவாய்';

  @override
  String get customizationSettingsTitle => 'தனிப்பயனாக்கம்';

  @override
  String get playbackSpeedControlSetting => 'பிளேபேக் வேகத் தெரிவுநிலை';

  @override
  String get playbackSpeedControlSettingSubtitle => 'பிளேயர் திரை பட்டியலில் பிளேபேக் வேகக் கட்டுப்பாடுகள் காட்டப்பட்டுள்ளனவா';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'தானியங்கி:\n நீங்கள் விளையாடும் பாடல் போட்காச்ட் அல்லது (ஒரு பகுதி) ஆடியோபுக்கா என்பதை அடையாளம் காண ஃபினாம்ப் முயற்சிக்கிறார். டிராக் $trackDuration நிமிடங்களை விட நீளமாக இருந்தால், டிராக்கின் ஆல்பம் $albumDuration மணிநேரங்களை விட நீளமாக இருந்தால், அல்லது பாதையில் இந்த வகைகளில் ஏதேனும் ஒன்று ஒதுக்கப்பட்டிருந்தால்: $genreList\n பிளேபேக் வேகக் கட்டுப்பாடுகள் பின்னர் பிளேயர் திரை பட்டியலில் காண்பிக்கப்படும்.\n\n காட்டப்பட்டுள்ளது:\n பிளேபேக் வேகக் கட்டுப்பாடுகள் எப்போதும் பிளேயர் திரை பட்டியலில் காண்பிக்கப்படும்.\n\n மறைக்கப்பட்ட:\n பிளேயர் திரை பட்டியலில் உள்ள பிளேபேக் வேகக் கட்டுப்பாடுகள் எப்போதும் மறைக்கப்படுகின்றன.';
  }

  @override
  String get automatic => 'தானியங்கி';

  @override
  String get shown => 'காட்டப்பட்டுள்ளது';

  @override
  String get hidden => 'மறைக்கப்பட்ட';

  @override
  String get speed => 'வேகம்';

  @override
  String get reset => 'மீட்டமை';

  @override
  String get apply => 'இடு';

  @override
  String get portrait => 'உருவப்படம்';

  @override
  String get landscape => 'நிலப்பரப்பு';

  @override
  String gridCrossAxisCount(String value) {
    return '$value கட்டம் குறுக்கு-அச்சு எண்ணிக்கை';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return '$value போது ஒவ்வொரு வரிசையையும் பயன்படுத்த கட்டம் ஓடுகளின் அளவு.';
  }

  @override
  String get showTextOnGridView => 'கட்டம் பார்வையில் உரையைக் காட்டு';

  @override
  String get showTextOnGridViewSubtitle => 'கட்டம் இசைத் திரையில் உரையை (தலைப்பு, கலைஞர் போன்றவை) காண்பிக்கலாமா வேண்டாமா.';

  @override
  String get useCoverAsBackground => 'மங்கலான அட்டையை பின்னணியாகப் பயன்படுத்தவும்';

  @override
  String get useCoverAsBackgroundSubtitle => 'பயன்பாட்டின் பல்வேறு பகுதிகளில் மங்கலான ஆல்பம் அட்டையை பின்னணியாகப் பயன்படுத்தலாமா இல்லையா.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'குறைந்தபட்ச ஆல்பம் கவர் திணிப்பு';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'திரை அகலத்தின் % இல், பிளேயர் திரையில் ஆல்பத்தை சுற்றி குறைந்தபட்ச திணிப்பு.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'ஆல்பம் கலைஞர்களைப் போலவே டிராக் கலைஞர்களையும் மறைக்கவும்';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'ஆல்பம் கலைஞர்களிடமிருந்து வேறுபடாவிட்டால் ஆல்பம் திரையில் டிராக் கலைஞர்களைக் காண்பிக்கலாமா?';

  @override
  String get showArtistsTopTracks => 'கலைஞர் பார்வையில் சிறந்த தடங்களைக் காட்டு';

  @override
  String get showArtistsTopTracksSubtitle => 'ஒரு கலைஞரின் தடங்களை அதிகம் கேட்கும் முதல் 5 இடங்களைக் காட்ட வேண்டுமா.';

  @override
  String get disableGesture => 'சைகைகளை முடக்கு';

  @override
  String get disableGestureSubtitle => 'சைகைகளை முடக்க வேண்டுமா.';

  @override
  String get showFastScroller => 'ஃபாச்ட் ச்க்ரோலரைக் காட்டு';

  @override
  String get theme => 'கருப்பொருள்';

  @override
  String get system => 'மண்டலம்';

  @override
  String get light => 'ஒளி';

  @override
  String get dark => 'இருண்ட';

  @override
  String get tabs => 'தாவல்கள்';

  @override
  String get playerScreen => 'பிளேயர் திரை';

  @override
  String get cancelSleepTimer => 'ச்லீப் டைமரை ரத்து செய்யவா?';

  @override
  String get yesButtonLabel => 'ஆம்';

  @override
  String get noButtonLabel => 'இல்லை';

  @override
  String get setSleepTimer => 'ச்லீப் டைமரை அமைக்கவும்';

  @override
  String get hours => 'மணி';

  @override
  String get seconds => 'நொடிகள்';

  @override
  String get minutes => 'நிமிடங்கள்';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return 'மொத்த $totalTime இல் $currentTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'மின்தடம் $currentTrackIndex of $totalTrackCount';
  }

  @override
  String get invalidNumber => 'செல்லாத எண்';

  @override
  String get sleepTimerTooltip => 'தூக்க நேரங்குறிகருவி';

  @override
  String sleepTimerRemainingTime(int time) {
    return '$time நிமிடங்களில் தூங்குகிறது';
  }

  @override
  String get addToPlaylistTooltip => 'பிளேலிச்ட்டில் சேர்க்கவும்';

  @override
  String get addToPlaylistTitle => 'பிளேலிச்ட்டில் சேர்க்கவும்';

  @override
  String get addToMorePlaylistsTooltip => 'மேலும் பிளேலிச்ட்களில் சேர்க்கவும்';

  @override
  String get addToMorePlaylistsTitle => 'மேலும் பிளேலிச்ட்களில் சேர்க்கவும்';

  @override
  String get removeFromPlaylistTooltip => 'இந்த பிளேலிச்ட்டிலிருந்து அகற்று';

  @override
  String get removeFromPlaylistTitle => 'இந்த பிளேலிச்ட்டிலிருந்து அகற்று';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'பிளேலிச்ட்டில் இருந்து அகற்று \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'பிளேலிச்ட்டில் இருந்து அகற்று \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'புதிய பிளேலிச்ட்';

  @override
  String get createButtonLabel => 'உருவாக்கு';

  @override
  String get playlistCreated => 'பிளேலிச்ட் உருவாக்கப்பட்டது.';

  @override
  String get playlistActionsMenuButtonTooltip => 'பிளேலிச்ட்டில் சேர்க்க தட்டவும். பிடித்ததை மாற்றுவதற்கு நீண்ட அழுத்தவும்.';

  @override
  String get noAlbum => 'ஆல்பம் இல்லை';

  @override
  String get noItem => 'உருப்படி இல்லை';

  @override
  String get noArtist => 'கலைஞர் இல்லை';

  @override
  String get unknownArtist => 'தெரியாத கலைஞர்';

  @override
  String get unknownAlbum => 'தெரியாத ஆல்பம்';

  @override
  String get playbackModeDirectPlaying => 'நேரடி விளையாட்டு';

  @override
  String get playbackModeTranscoding => 'டிரான்ச்கோடிங்';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'உள்ளூரில் விளையாடுகிறது';

  @override
  String get queue => 'வரிசை';

  @override
  String get addToQueue => 'வரிசையில் சேர்க்கவும்';

  @override
  String get replaceQueue => 'வரிசையை மாற்றவும்';

  @override
  String get instantMix => 'உடனடி கலவை';

  @override
  String get goToAlbum => 'ஆல்பத்திற்குச் செல்லுங்கள்';

  @override
  String get goToArtist => 'கலைஞரிடம் செல்லுங்கள்';

  @override
  String get goToGenre => 'வகைக்குச் செல்லுங்கள்';

  @override
  String get removeFavourite => 'பிடித்ததை அகற்று';

  @override
  String get addFavourite => 'பிடித்ததைச் சேர்க்கவும்';

  @override
  String get confirmFavoriteAdded => 'பிடித்தது சேர்க்கப்பட்டது';

  @override
  String get confirmFavoriteRemoved => 'பிடித்தது';

  @override
  String get addedToQueue => 'வரிசையில் சேர்க்கப்பட்டது.';

  @override
  String get insertedIntoQueue => 'வரிசையில் செருகப்பட்டது.';

  @override
  String get queueReplaced => 'வரிசை மாற்றப்பட்டது.';

  @override
  String get confirmAddedToPlaylist => 'பிளேலிச்ட்டில் சேர்க்கப்பட்டது.';

  @override
  String get removedFromPlaylist => 'பிளேலிச்ட்டில் இருந்து அகற்றப்பட்டது.';

  @override
  String get startingInstantMix => 'உடனடி கலவையைத் தொடங்குகிறது.';

  @override
  String get anErrorHasOccured => 'பிழை ஏற்பட்டுள்ளது.';

  @override
  String responseError(String error, int statusCode) {
    return '$error நிலை குறியீடு $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error நிலை குறியீடு $statusCode. இதன் பொருள் என்னவென்றால், நீங்கள் தவறான பயனர்பெயர்/கடவுச்சொல்லைப் பயன்படுத்தினீர்கள், அல்லது உங்கள் வாடிக்கையாளர் இனி உள்நுழையவில்லை.';
  }

  @override
  String get removeFromMix => 'கலவையிலிருந்து அகற்று';

  @override
  String get addToMix => 'கலக்க சேர்க்கவும்';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redownloads தேவை',
      zero: 'Redownloads தேவையில்லை',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'இடையக காலம்';

  @override
  String get bufferDurationSubtitle => 'நொடிகளில் வீரர் எவ்வளவு இடையக வேண்டும். மறுதொடக்கம் தேவை.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Don\'t limit buffer size';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.';

  @override
  String get bufferSizeTitle => 'Buffer Size';

  @override
  String get bufferSizeSubtitle => 'The maximum size of the buffer in MB. Requires a restart';

  @override
  String get language => 'மொழி';

  @override
  String get skipToPreviousTrackButtonTooltip => 'தொடக்கத்திற்கு அல்லது முந்தைய பாதையில் செல்லவும்';

  @override
  String get skipToNextTrackButtonTooltip => 'அடுத்த பாதையில் செல்லவும்';

  @override
  String get togglePlaybackButtonTooltip => 'பிளேபேக்கை மாற்றவும்';

  @override
  String get previousTracks => 'முந்தைய தடங்கள்';

  @override
  String get nextUp => 'அடுத்து';

  @override
  String get clearNextUp => 'அடுத்து அழிக்கவும்';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'இருந்து விளையாடுகிறது';

  @override
  String get playNext => 'அடுத்து விளையாடுங்கள்';

  @override
  String get addToNextUp => 'அடுத்ததாக சேர்க்கவும்';

  @override
  String get shuffleNext => 'அடுத்து கலக்கவும்';

  @override
  String get shuffleToNextUp => 'அடுத்ததாக கலக்கவும்';

  @override
  String get shuffleToQueue => 'வரிசையில் கலக்கவும்';

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
        'track': 'டிராக்',
        'album': 'ஆல்பம்',
        'artist': 'கலைஞர்',
        'playlist': 'பிளேலிச்ட்',
        'genre': 'வகை',
        'other': 'item',
      },
    );
    return 'சேர்க்கப்பட்டது $_temp0';
  }

  @override
  String confirmAddToQueue(String type) {
    return 'சேர்க்கப்பட்டது';
  }

  @override
  String get confirmShuffleNext => 'அடுத்து கலக்கும்';

  @override
  String get confirmShuffleToNextUp => 'அடுத்ததாக மாற்றப்பட்டது';

  @override
  String get confirmShuffleToQueue => 'வரிசையில் மாற்றப்பட்டது';

  @override
  String get placeholderSource => 'எங்கோ';

  @override
  String get playbackHistory => 'பின்னணி வரலாறு';

  @override
  String get shareOfflineListens => 'பகிர்வு இணைப்பில்லாத கேட்கிறது';

  @override
  String get yourLikes => 'உங்கள் விருப்பங்கள்';

  @override
  String mix(String mixSource) {
    return '$mixSource - கலவை';
  }

  @override
  String get tracksFormerNextUp => 'தடங்கள் அடுத்தது வழியாக சேர்க்கப்பட்டுள்ளன';

  @override
  String get savedQueue => 'சேமித்த வரிசை';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'ஆல்பம்',
        'playlist': 'பிளேலிச்ட்',
        'trackMix': 'பாடல்மிக்ச்',
        'artistMix': 'கலைஞர்மிக்ச்',
        'albumMix': 'ஆல்பமிக்ச்',
        'genreMix': 'வகைமிக்ச்',
        'favorites': 'பிடித்தவை',
        'allTracks': 'அனைத்து தடங்கள்',
        'tracks': 'தடங்கள்',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'அனைத்தையும் மாற்றவும்';

  @override
  String get playbackOrderLinearButtonLabel => 'வரிசையில் விளையாடுவது';

  @override
  String get playbackOrderLinearButtonTooltip => 'வரிசையில் விளையாடுவது. கலக்கத் தட்டவும்.';

  @override
  String get playbackOrderShuffledButtonLabel => 'மாற்றும் தடங்கள்';

  @override
  String get playbackOrderShuffledButtonTooltip => 'மாற்றும் தடங்கள். வரிசையில் விளையாட தட்டவும்.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'ஃச் $speed வேகத்தில் விளையாடுகிறது';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'ஃச் $speed விரைவு';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'பிளேபேக் வேகத்தைக் குறைக்கவும்';

  @override
  String get playbackSpeedIncreaseLabel => 'பிளேபேக் வேகத்தை அதிகரிக்கவும்';

  @override
  String get loopModeNoneButtonLabel => 'வளையவில்லை';

  @override
  String get loopModeOneButtonLabel => 'இந்த பாதையை சுழற்றுதல்';

  @override
  String get loopModeAllButtonLabel => 'அனைத்தையும் வளைய';

  @override
  String get queuesScreen => 'இப்போது விளையாடுவதை மீட்டெடுங்கள்';

  @override
  String get queueRestoreButtonLabel => 'மீட்டமை';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'சேமிக்கப்பட்டது $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'வாசித்தல்: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தடங்கள்',
      one: '1 Track',
    );
    return '$_temp0, $remaining திறக்கப்படாதது';
  }

  @override
  String get queueLoadingMessage => 'வரிசையை மீட்டமைத்தல் ...';

  @override
  String get queueRetryMessage => 'வரிசையை மீட்டெடுப்பதில் தோல்வி. மீண்டும் முயற்சிக்கிறீர்களா?';

  @override
  String get autoloadLastQueueOnStartup => 'ஆட்டோ-ரெச்டோர் கடைசி வரிசை';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'பயன்பாட்டு தொடக்கத்தில், கடைசியாக விளையாடிய வரிசையை மீட்டெடுக்க முயற்சிக்கவும்.';

  @override
  String get reportQueueToServer => 'சேவையகத்திற்கு தற்போதைய வரிசையைப் புகாரளிக்கவா?';

  @override
  String get reportQueueToServerSubtitle => 'இயக்கப்பட்டால், ஃபினாம்ப் தற்போதைய வரிசையை சேவையகத்திற்கு அனுப்பும். தற்போது இதற்கு சிறிதளவு பயன்பாடு இருப்பதாகத் தெரிகிறது, மேலும் இது பிணைய போக்குவரத்தை அதிகரிக்கிறது.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'பிளேபேக் அமர்வு புதுப்பிப்பு அதிர்வெண்';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'தற்போதைய பிளேபேக் நிலையை சேவையகத்திற்கு நொடிகளில் எவ்வளவு அடிக்கடி அனுப்ப வேண்டும். அமர்வு நேரம் வெளியேறுவதைத் தடுக்க, இது 5 நிமிடங்களுக்கும் குறைவாக (300 வினாடிகள்) இருக்க வேண்டும்.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'கடந்த 5 நிமிடங்களில் ஒரு வாடிக்கையாளரிடமிருந்து செல்லிஃபின் சேவையகம் எந்த புதுப்பிப்புகளையும் பெறவில்லை என்றால், பிளேபேக் முடிந்தது என்று கருதுகிறது. இதன் பொருள் 5 நிமிடங்களுக்கும் மேலான தடங்களுக்கு, அந்த பின்னணி முடிவடைந்ததாக தவறாக அறிவிக்கப்படலாம், இது பிளேபேக் அறிக்கையிடல் தரவின் தரத்தை குறைத்தது.';

  @override
  String get topTracks => 'மேல் தடங்கள்';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ஆல்பங்கள்',
      one: '$count ஆல்பம்',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'கலக்கு ஆல்பங்கள்';

  @override
  String get shuffleAlbumsNext => 'அடுத்து கலக்கு ஆல்பங்கள்';

  @override
  String get shuffleAlbumsToNextUp => 'ஆல்பங்களை அடுத்ததாக மாற்றவும்';

  @override
  String get shuffleAlbumsToQueue => 'வரிசையில் ஆல்பங்களை மாற்றவும்';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount விளையாட்டுகள்',
      one: '$playCount விளையாட்டு',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    return 'ஏற்ற முடியவில்லை $source';
  }

  @override
  String get confirm => 'உறுதிப்படுத்தவும்';

  @override
  String get close => 'மூடு';

  @override
  String get showUncensoredLogMessage => 'இந்த பதிவில் உங்கள் உள்நுழைவு செய்தி உள்ளது. காட்டு?';

  @override
  String get resetTabs => 'தாவல்களை மீட்டமைக்கவும்';

  @override
  String get resetToDefaults => 'இயல்புநிலைகளுக்கு மீட்டமைக்கவும்';

  @override
  String get noMusicLibrariesTitle => 'இசை நூலகங்கள் இல்லை';

  @override
  String get noMusicLibrariesBody => 'ஃபினாம்பால் எந்த இசை நூலகங்களையும் கண்டுபிடிக்க முடியவில்லை. உங்கள் செல்லிஃபின் சேவையகத்தில் \"இசை\" என அமைக்கப்பட்ட உள்ளடக்க வகையுடன் குறைந்தது ஒரு நூலகத்தையாவது இருப்பதை உறுதிப்படுத்தவும்.';

  @override
  String get refresh => 'புதுப்பிப்பு';

  @override
  String get moreInfo => 'மேலும் செய்தி';

  @override
  String get volumeNormalizationSettingsTitle => 'தொகுதி இயல்பாக்கம்';

  @override
  String get volumeNormalizationSwitchTitle => 'தொகுதி இயல்பாக்கத்தை இயக்கவும்';

  @override
  String get volumeNormalizationSwitchSubtitle => 'தடங்களின் சத்தத்தை இயல்பாக்க ஆதாய தகவலைப் பயன்படுத்தவும் (\"மறுபதிப்பு ஆதாயம்\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'தொகுதி இயல்பாக்குதல் பயன்முறை';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'தொகுதி இயல்பாக்கத்தை எப்போது, எப்படி பயன்படுத்துவது';

  @override
  String get volumeNormalizationModeSelectorDescription => 'கலப்பின (டிராக் + ஆல்பம்):\n ட்ராக் ஆதாயம் வழக்கமான பிளேபேக்கிற்குப் பயன்படுத்தப்படுகிறது, ஆனால் ஒரு ஆல்பம் இயங்குகிறது என்றால் (இது முக்கிய பின்னணி வரிசை மூலமாக இருப்பதால், அல்லது ஒரு கட்டத்தில் வரிசையில் சேர்க்கப்பட்டதால்), அதற்கு பதிலாக ஆல்பம் பயன்படுத்தப்படுகிறது.\n\n டிராக் அடிப்படையிலான:\n ஒரு ஆல்பம் விளையாடுகிறதா இல்லையா என்பதைப் பொருட்படுத்தாமல், ட்ராக் ஆதாயம் எப்போதும் பயன்படுத்தப்படுகிறது.\n\n ஆல்பங்கள் மட்டுமே:\n ஆல்பங்களை இயக்கும் போது மட்டுமே தொகுதி இயல்பாக்கம் பயன்படுத்தப்படுகிறது (ஆல்பத்தை ஆதாயத்தைப் பயன்படுத்தி), ஆனால் தனிப்பட்ட தடங்களுக்கு அல்ல.';

  @override
  String get volumeNormalizationModeHybrid => 'கலப்பின (டிராக் + ஆல்பம்)';

  @override
  String get volumeNormalizationModeTrackBased => 'டிராக் அடிப்படையிலான';

  @override
  String get volumeNormalizationModeAlbumBased => 'ஆல்பம் அடிப்படையிலான';

  @override
  String get volumeNormalizationModeAlbumOnly => 'ஆல்பங்களுக்கு மட்டுமே';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'அடிப்படை ஆதாயம்';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'தற்போது, IOS இல் தொகுதி இயல்பாக்கத்திற்கு ஆதாய மாற்றத்தைப் பின்பற்ற பிளேபேக் அளவை மாற்ற வேண்டும். 100%க்கு மேல் அளவை நாம் அதிகரிக்க முடியாது என்பதால், இயல்புநிலையாக அளவைக் குறைக்க வேண்டும், இதனால் அமைதியான தடங்களின் அளவை அதிகரிக்க முடியும். மதிப்பு டெசிபல்களில் (டி.பி.) உள்ளது, அங்கு -10 டிபி ~ 30% தொகுதி, -4.5 டி.பி. ~ 60% தொகுதி மற்றும் -2 டி.பி.';

  @override
  String numberAsDecibel(double value) {
    return '$value db';
  }

  @override
  String get swipeInsertQueueNext => 'அடுத்து ச்வைப் பாதையில் விளையாடுங்கள்';

  @override
  String get swipeInsertQueueNextSubtitle => 'ட்ராக் பட்டியலில் ச்வைப் செய்யும்போது அடுத்த உருப்படியாக வரிசையில் ஒரு பாதையைச் செருகவும்.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'தனிப்பட்ட தடங்களுக்கான உடனடி கலவைகளைத் தொடங்கவும்';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'இயக்கப்பட்டால், டிராக்குகள் தாவலில் ஒரு பாதையைத் தட்டுவது ஒரு தடத்தை விளையாடுவதற்குப் பதிலாக அந்த பாதையின் உடனடி கலவையைத் தொடங்கும்.';

  @override
  String get downloadItem => 'பதிவிறக்கம்';

  @override
  String get repairComplete => 'பதிவிறக்கம் பழுது முடிந்தது.';

  @override
  String get syncComplete => 'அனைத்து பதிவிறக்கங்களும் மீண்டும் ஒத்துப்போகின்றன.';

  @override
  String get syncDownloads => 'காணாமல் போன உருப்படிகளை ஒத்திசைத்து பதிவிறக்கவும்.';

  @override
  String get repairDownloads => 'பதிவிறக்கம் செய்யப்பட்ட கோப்புகள் அல்லது மெட்டாடேட்டாவுடன் சிக்கல்களை சரிசெய்யவும்.';

  @override
  String get requireWifiForDownloads => 'பதிவிறக்கும் போது வைஃபை தேவை.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தடங்கள்',
      one: '$count டிராக்',
    );
    return 'எச்சரிக்கை: $_temp0 வரிசையில் மீட்டெடுக்க முடியாது.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'பதிவிறக்கம்',
        'failed': 'தோல்வியுற்ற',
        'repeatedlyUnsynced': 'ஒத்திசைக்கப்படாத',
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
    return 'நூலகத்தின் அனைத்து உள்ளடக்கங்களையும் பதிவிறக்கம் செய்ய விரும்புகிறீர்களா?';
  }

  @override
  String get onlyShowFullyDownloaded => 'முழுமையாக பதிவிறக்கம் செய்யப்பட்ட ஆல்பங்களை மட்டுமே காட்டு';

  @override
  String get filesystemFull => 'மீதமுள்ள பதிவிறக்கங்களை முடிக்க முடியாது. கோப்பு முறைமை நிரம்பியுள்ளது.';

  @override
  String get connectionInterrupted => 'இணைப்பு குறுக்கிட்டது, பதிவிறக்கங்களை இடைநிறுத்துகிறது.';

  @override
  String get connectionInterruptedBackground => 'பின்னணியில் பதிவிறக்கும் போது இணைப்பு குறுக்கிடப்பட்டது. இது OS அமைப்புகளால் ஏற்படலாம்.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'பின்னணியில் பதிவிறக்கும் போது இணைப்பு குறுக்கிடப்பட்டது. \'இடைநிறுத்தத்தில் குறைந்த முன்னுரிமை நிலையை உள்ளிட\' அல்லது OS அமைப்புகளை இயக்குவதன் மூலம் இது ஏற்படலாம்.';

  @override
  String get activeDownloadSize => 'பதிவிறக்கம் ...';

  @override
  String get missingDownloadSize => 'நீக்குதல் ...';

  @override
  String get syncingDownloadSize => 'ஒத்திசைவு ...';

  @override
  String get runRepairWarning => 'பதிவிறக்கங்கள் இடம்பெயர்வுகளை இறுதி செய்ய சேவையகத்தைத் தொடர்பு கொள்ள முடியவில்லை. நீங்கள் ஆன்லைனில் திரும்பி வந்தவுடன் பதிவிறக்கத் திரையில் இருந்து \'பழுதுபார்க்கும் பதிவிறக்கங்களை\' இயக்கவும்.';

  @override
  String get downloadSettings => 'அமைப்புகளை பதிவிறக்கவும்';

  @override
  String get showNullLibraryItemsTitle => 'அறியப்படாத நூலகத்துடன் ஊடகத்தைக் காட்டு.';

  @override
  String get showNullLibraryItemsSubtitle => 'சில ஊடகங்கள் அறியப்படாத நூலகத்துடன் பதிவிறக்கம் செய்யப்படலாம். அவற்றின் அசல் சேகரிப்புக்கு வெளியே இவற்றை மறைக்க அணைக்கவும்.';

  @override
  String get maxConcurrentDownloads => 'அதிகபட்சம் ஒரே நேரத்தில் பதிவிறக்கங்கள்';

  @override
  String get maxConcurrentDownloadsSubtitle => 'ஒரே நேரத்தில் பதிவிறக்கங்களை அதிகரிப்பது பின்னணியில் பதிவிறக்குவதை அனுமதிக்கலாம், ஆனால் மிகப் பெரியதாக இருந்தால் சில பதிவிறக்கங்கள் தோல்வியடையக்கூடும், அல்லது சில சந்தர்ப்பங்களில் அதிகப்படியான பின்னடைவை ஏற்படுத்தக்கூடும்.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count ஒரே நேரத்தில் பதிவிறக்கங்கள்';
  }

  @override
  String get downloadsWorkersSetting => 'பணியாளர் எண்ணிக்கையைப் பதிவிறக்கவும்';

  @override
  String get downloadsWorkersSettingSubtitle => 'மெட்டாடேட்டாவை ஒத்திசைப்பதற்கும் பதிவிறக்கங்களை நீக்குவதற்கும் தொழிலாளர்களின் அளவு. பதிவிறக்கத் தொழிலாளர்கள் அதிகரிப்பது பதிவிறக்க ஒத்திசைவு மற்றும் நீக்குதல் ஆகியவற்றை விரைவுபடுத்தலாம், குறிப்பாக சேவையக நேரந்தவறுகை அதிகமாக இருக்கும்போது, ஆனால் பின்னடைவை அறிமுகப்படுத்தலாம்.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count தொழிலாளர்களைப் பதிவிறக்குக';
  }

  @override
  String get syncOnStartupSwitch => 'தொடக்கத்தில் பதிவிறக்கங்களை தானாக ஒத்திசைக்கவும்';

  @override
  String get preferQuickSyncSwitch => 'விரைவான ஒத்திசைவை விரும்புங்கள்';

  @override
  String get preferQuickSyncSwitchSubtitle => 'ஒத்திசைவுகளைச் செய்யும்போது, பொதுவாக சில நிலையான உருப்படிகள் (தடங்கள் மற்றும் ஆல்பங்கள் போன்றவை) புதுப்பிக்கப்படாது. பதிவிறக்கம் பழுதுபார்ப்பு எப்போதும் முழு ஒத்திசைவைச் செய்யும்.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'ஆல்பம்',
        'playlist': 'பிளேலிச்ட்',
        'artist': 'கலைஞர்',
        'genre': 'வகை',
        'track': 'நூலகம்',
        'library': 'அறியப்படாத',
        'unknown': 'Item',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'இந்த உருப்படியை $parentName ஆல் பதிவிறக்கம் செய்ய வேண்டும்.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'பிடித்தவை',
        'allplaylists': 'All Playlists',
        'fivelatestalbums': '5 Latest Albums',
        'allplaylistsmetadata': 'Playlist Metadata',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return '\'$libraryName\' க்கான தற்காலிக சேமிப்பு படங்கள்';
  }

  @override
  String get transcodingStreamingContainerTitle => 'டிரான்ச்கோடிங் கொள்கலனைத் தேர்ந்தெடுக்கவும்';

  @override
  String get transcodingStreamingContainerSubtitle => 'டிரான்ச்கோடட் ஆடியோவை ச்ட்ரீமிங் செய்யும் போது பயன்படுத்த பிரிவு கொள்கலனைத் தேர்ந்தெடுக்கவும். ஏற்கனவே வரிசைப்படுத்தப்பட்ட தடங்கள் பாதிக்கப்படாது.';

  @override
  String get downloadTranscodeEnableTitle => 'டிரான்ச்கோடட் பதிவிறக்கங்களை இயக்கவும்';

  @override
  String get downloadTranscodeCodecTitle => 'கோடெக் பதிவிறக்க என்பதைத் தேர்ந்தெடுக்கவும்';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'எப்போதும்',
        'never': 'ஒருபோதும்',
        'ask': 'கேளுங்கள்',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'பிட்ரேட்டைப் பதிவிறக்கவும்';

  @override
  String get downloadBitrateSubtitle => 'அதிக பிட்ரேட் பெரிய சேமிப்பக தேவைகளின் செலவில் உயர் தரமான ஆடியோவை வழங்குகிறது.';

  @override
  String get transcodeHint => 'டிரான்ச்கோட்?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~ $size',
      },
    );
    return '$codec @ $bitrate $_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate டிரான்ச்கோடட்',
      },
    );
    return '$size $codec $_temp0';
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
    return 'அசல் $_temp0';
  }

  @override
  String get redownloadcomplete => 'டிரான்ச்கோட் ரிடவுன் லோட் வரிசையில் உள்ளது.';

  @override
  String get redownloadTitle => 'டிரான்ச்கோட்களை தானாகவே ரத்துசெய்கிறது';

  @override
  String get redownloadSubtitle => 'பெற்றோர் சேகரிப்பு மாற்றங்கள் காரணமாக வேறுபட்ட தரத்தில் இருக்கும் என்று எதிர்பார்க்கப்படும் தடங்களை தானாகவே மாற்றியமைத்தல்.';

  @override
  String get defaultDownloadLocationButton => 'இயல்புநிலை பதிவிறக்க இருப்பிடமாக அமைக்கவும். பதிவிறக்கத்திற்கு தேர்ந்தெடுக்க முடக்கு.';

  @override
  String get fixedGridSizeSwitchTitle => 'நிலையான அளவு கட்டம் ஓடுகளைப் பயன்படுத்தவும்';

  @override
  String get fixedGridSizeSwitchSubtitle => 'கட்டம் ஓடு அளவுகள் சாளரம்/திரை அளவிற்கு பதிலளிக்காது.';

  @override
  String get fixedGridSizeTitle => 'கட்டம் ஓடு அளவு';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'சிறிய',
        'medium': 'நடுத்தர',
        'large': 'பெரிய',
        'veryLarge': 'மிகப் பெரிய',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'ச்ப்ளிட்ச்கிரீன் பயன்முறையை அனுமதிக்கவும்';

  @override
  String get allowSplitScreenSubtitle => 'பரந்த காட்சிகளில் மற்ற காட்சிகளுடன் பிளேயர் காண்பிக்கப்படும்.';

  @override
  String get enableVibration => 'அதிர்வுகளை இயக்கவும்';

  @override
  String get enableVibrationSubtitle => 'அதிர்வு இயக்க வேண்டுமா.';

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
  String get hidePlayerBottomActions => 'கீழே செயல்களை மறைக்கவும்';

  @override
  String get hidePlayerBottomActionsSubtitle => 'பிளேயர் திரையில் வரிசை மற்றும் பாடல் பொத்தான்களை மறைக்கவும். வரிசையை அணுக ச்வைப் செய்யுங்கள், கிடைத்தால் பாடல் வரிகளைக் காண இடதுபுறத்தை (ஆல்பம் அட்டைக்கு கீழே) ச்வைப் செய்யவும்.';

  @override
  String get prioritizePlayerCover => 'ஆல்பம் அட்டைக்கு முன்னுரிமை கொடுங்கள்';

  @override
  String get prioritizePlayerCoverSubtitle => 'பிளேயர் திரையில் ஒரு பெரிய ஆல்பம் அட்டையைக் காண்பிப்பதற்கு முன்னுரிமை அளிக்கவும். சிறிய திரை அளவுகளில் விமர்சனமற்ற கட்டுப்பாடுகள் மிகவும் ஆக்ரோசமாக மறைக்கப்படும்.';

  @override
  String get suppressPlayerPadding => 'பிளேயர் திணிப்பைக் கட்டுப்படுத்துகிறது';

  @override
  String get suppressPlayerPaddingSubtitle => 'ஆல்பம் கவர் முழு அளவில் இல்லாதபோது பிளேயர் திரை கட்டுப்பாடுகளுக்கு இடையில் திணிப்பை முழுமையாகக் குறைக்கிறது.';

  @override
  String get lockDownload => 'எப்போதும் சாதனத்தில் வைத்திருங்கள்';

  @override
  String get showArtistChipImage => 'கலைஞரின் பெயருடன் கலைஞர் படங்களைக் காட்டு';

  @override
  String get showArtistChipImageSubtitle => 'இது பிளேயர் திரை போன்ற சிறிய கலைஞர் பட மாதிரிக்காட்சிகளை பாதிக்கிறது.';

  @override
  String get scrollToCurrentTrack => 'தற்போதைய பாதையில் உருட்டவும்';

  @override
  String get enableAutoScroll => 'ஆட்டோ-ச்க்ரோலை இயக்கவும்';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz kHz';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit பிட்';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration மீதமுள்ள';
  }

  @override
  String get removeFromPlaylistConfirm => 'அகற்று';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'பிளேலிச்ட்டில் இருந்து \'$itemName\' ஐ அகற்று \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'ட்ராக் பட்டியல்';

  @override
  String get quickActions => 'விரைவான செயல்கள்';

  @override
  String get addRemoveFromPlaylist => 'பிளேலிச்ட்களிலிருந்து சேர்க்கவும் / அகற்று';

  @override
  String get addPlaylistSubheader => 'பிளேலிச்ட்டில் தடத்தைச் சேர்க்கவும்';

  @override
  String get trackOfflineFavorites => 'அனைத்து பிடித்த நிலைகளையும் ஒத்திசைக்கவும்';

  @override
  String get trackOfflineFavoritesSubtitle => 'இது ஆஃப்லைனில் இருக்கும்போது மிகவும் புதுப்பித்த பிடித்த நிலைகளைக் காட்ட அனுமதிக்கிறது. கூடுதல் கோப்புகளை பதிவிறக்கம் செய்யாது.';

  @override
  String get allPlaylistsInfoSetting => 'பிளேலிச்ட் மெட்டாடேட்டாவைப் பதிவிறக்கவும்';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'உங்கள் பிளேலிச்ட் அனுபவத்தை மேம்படுத்த அனைத்து பிளேலிச்ட்களுக்கும் மெட்டாடேட்டாவை ஒத்திசைக்கவும்';

  @override
  String get downloadFavoritesSetting => 'அனைத்து பிடித்தவைகளையும் பதிவிறக்கவும்';

  @override
  String get downloadAllPlaylistsSetting => 'அனைத்து பிளேலிச்ட்களையும் பதிவிறக்கவும்';

  @override
  String get fiveLatestAlbumsSetting => '5 அண்மைக் கால ஆல்பங்களைப் பதிவிறக்கவும்';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'பதிவிறக்கங்கள் வயதாகும்போது அகற்றப்படும். ஒரு ஆல்பம் அகற்றப்படுவதைத் தடுக்க பதிவிறக்கத்தை பூட்டுங்கள்.';

  @override
  String get cacheLibraryImagesSettings => 'தற்போதைய நூலக படங்களை கேச்';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'தற்போது செயலில் உள்ள நூலகத்தில் உள்ள அனைத்து ஆல்பம், கலைஞர், வகை மற்றும் பிளேலிச்ட் கவர்கள் பதிவிறக்கம் செய்யப்படும்.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'பயன்பாட்டில் உள்ள மினிப்ளேயரில் தட முன்னேற்றத்தைக் காட்டு';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'பயன்பாட்டு மினி பிளேயர் / இப்போது இசைத் திரையின் அடிப்பகுதியில் விளையாடும் பட்டியை முன்னேற்றப் பட்டியாக செயல்பட்டால் கட்டுப்படுத்துகிறது.';

  @override
  String get lyricsScreen => 'பாடல் பார்வை';

  @override
  String get showLyricsTimestampsTitle => 'ஒத்திசைக்கப்பட்ட பாடல்களுக்கான நேர முத்திரைகளைக் காட்டு';

  @override
  String get showLyricsTimestampsSubtitle => 'ஒவ்வொரு பாடல் வரியின் நேர முத்திரையும் கிடைத்தால், பாடல் பார்வையில் காட்டப்பட்டால் கட்டுப்படுத்துகிறது.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'ஊடக அறிவிப்பில் நிறுத்த பொத்தானைக் காட்டு';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'இடைநிறுத்த பொத்தானை கூடுதலாக ஊடக அறிவிப்பில் நிறுத்த பொத்தானை வைத்திருந்தால் கட்டுப்படுத்துகிறது. பயன்பாட்டைத் திறக்காமல் பிளேபேக்கை நிறுத்த இது உங்களை அனுமதிக்கிறது.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'ஊடக அறிவிப்பில் கட்டுப்பாடுகளைத் தேடுங்கள்';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'ஊடக அறிவிப்புக்கு தேடக்கூடிய முன்னேற்றப் பட்டி இருந்தால் கட்டுப்படுத்துகிறது. பயன்பாட்டைத் திறக்காமல் பிளேபேக் நிலையை மாற்ற இது உங்களை அனுமதிக்கிறது.';

  @override
  String get alignmentOptionStart => 'தொடங்கு';

  @override
  String get alignmentOptionCenter => 'நடுவண்';

  @override
  String get alignmentOptionEnd => 'முடிவு';

  @override
  String get fontSizeOptionSmall => 'சிறிய';

  @override
  String get fontSizeOptionMedium => 'சராசரி';

  @override
  String get fontSizeOptionLarge => 'பெரிய';

  @override
  String get lyricsAlignmentTitle => 'பாடல் சீரமைப்பு';

  @override
  String get lyricsAlignmentSubtitle => 'பாடல் பார்வையில் பாடல் வரிகளின் சீரமைப்பைக் கட்டுப்படுத்துகிறது.';

  @override
  String get lyricsFontSizeTitle => 'பாடல் எழுத்துரு அளவு';

  @override
  String get lyricsFontSizeSubtitle => 'பாடல் பார்வையில் பாடல் எழுத்து அளவைக் கட்டுப்படுத்துகிறது.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'பாடல் வரிக்கு முன் ஆல்பத்தைக் காட்டு';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'கட்டுப்பாடுகள் ஆல்பம் அட்டை உருட்டப்படுவதற்கு முன்பு பாடல் வரிகளுக்கு மேலே காட்டப்பட்டால்.';

  @override
  String get keepScreenOn => 'திரையை தொடர்ந்து வைத்திருங்கள்';

  @override
  String get keepScreenOnSubtitle => 'திரையை எப்போது வைத்திருக்க வேண்டும்';

  @override
  String get keepScreenOnDisabled => 'முடக்கப்பட்டது';

  @override
  String get keepScreenOnAlwaysOn => 'எப்போதும் இயக்கவும்';

  @override
  String get keepScreenOnWhilePlaying => 'இசை வாசிக்கும் போது';

  @override
  String get keepScreenOnWhileLyrics => 'பாடல் காண்பிக்கும் போது';

  @override
  String get keepScreenOnWhilePluggedIn => 'செருகும்போது மட்டுமே திரையை வைக்கவும்';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'சாதனம் அவிழ்க்கப்படுகிறதா என்று அமைப்பதில் வைத்திருக்கும் திரையை புறக்கணிக்கவும்';

  @override
  String get genericToggleButtonTooltip => 'மாற்றுவதைத் தட்டவும்.';

  @override
  String get artwork => 'ஒளிமறைப்பு';

  @override
  String artworkTooltip(String title) {
    return '$title க்கு க்கான கலைப்படைப்பு';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return '$title க்கு க்கான கலைப்படைப்பு. பிளேபேக்கை மாற்றுவதைத் தட்டவும். தடங்களை மாற்ற இடது அல்லது வலதுபுறமாக ச்வைப் செய்யவும்.';
  }

  @override
  String get nowPlayingBarTooltip => 'பிளேயர் திரை திறந்த';

  @override
  String get additionalPeople => 'மக்கள்';

  @override
  String get playbackMode => 'பிளேபேக் பயன்முறை';

  @override
  String get codec => 'புரிப்பு';

  @override
  String get bitRate => 'துகள் வீதம்';

  @override
  String get bitDepth => 'பிட் ஆழம்';

  @override
  String get size => 'அளவு';

  @override
  String get normalizationGain => 'பெருக்கம்';

  @override
  String get sampleRate => 'மாதிரி வீதம்';

  @override
  String get showFeatureChipsToggleTitle => 'மேம்பட்ட தட தகவலைக் காட்டு';

  @override
  String get showFeatureChipsToggleSubtitle => 'பிளேயர் திரையில் கோடெக், பிட் வீதம் மற்றும் பலவற்றைப் போன்ற மேம்பட்ட தட தகவல்களைக் காட்டு.';

  @override
  String get albumScreen => 'ஆல்பம் திரை';

  @override
  String get showCoversOnAlbumScreenTitle => 'தடங்களுக்கான ஆல்பம் அட்டைகளைக் காட்டு';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'ஆல்பம் திரையில் ஒவ்வொரு தடத்திற்கும் ஆல்பம் அட்டைகளைக் காட்டு.';

  @override
  String get emptyTopTracksList => 'இந்த கலைஞரால் நீங்கள் இதுவரை எந்த தடத்தையும் கேட்கவில்லை.';

  @override
  String get emptyFilteredListTitle => 'உருப்படிகள் எதுவும் கிடைக்கவில்லை';

  @override
  String get emptyFilteredListSubtitle => 'எந்த உருப்படிகளும் வடிகட்டியுடன் பொருந்தவில்லை. வடிகட்டியை அணைக்க அல்லது தேடல் காலத்தை மாற்ற முயற்சிக்கவும்.';

  @override
  String get resetFiltersButton => 'வடிப்பான்களை மீட்டமை';

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
