// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get finamp => 'फ़िनएम्प';

  @override
  String get finampTagline => 'एक खुला स्त्रोत जेलिफ़िन संगीत प्लेयर';

  @override
  String startupError(String error) {
    return 'शुरुआत के दौरान कुछ गड़बड़ी हुई। गड़बड़ थी: $error\n\nकृपया स्क्रीनशॉट के साथ github.com/UnicornsOnLSD/finamp पर यह मुद्दा बनाएं। अगर यह समस्या बनी रहती है तो अपना ऐप डाटा साफ़ कर ऐप को रीसेट करें।';
  }

  @override
  String get about => 'फ़िनएम्प के बारे में';

  @override
  String get aboutContributionPrompt => 'शानदार लोगों द्वारा उनके खाली समय में बनाया गया।\nआप भी उनमें से एक हो सकते है!';

  @override
  String get aboutContributionLink => 'GitHub पर फ़िनएम्प के लिए योगदान करें:';

  @override
  String get aboutReleaseNotes => 'नवीनतम रिलीज़ नोट्स पढ़ें:';

  @override
  String get aboutTranslations => 'अपनी भाषा में फ़िनएम्प को अनुवाद करें:';

  @override
  String get aboutThanks => 'फ़िनएम्प इस्तमाल करने के लिए धन्यवाद!';

  @override
  String get loginFlowWelcomeHeading => 'स्वागत है,';

  @override
  String get loginFlowSlogan => 'आपके संगीत, आपके हिसाब से।';

  @override
  String get loginFlowGetStarted => 'शुरू करें!';

  @override
  String get viewLogs => 'लॉग देखें';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get loginFlowServerSelectionHeading => 'जेलिफ़िन से जोड़ें';

  @override
  String get back => 'पीछे';

  @override
  String get serverUrl => 'सर्वर URL';

  @override
  String get internalExternalIpExplanation => 'अगर आप जेलिफ़िन सर्वर को दूर से (Remotely) पहुंचना चाहते है तो आपको अपने बाहरी (External) IP का इस्तमाल करना होगा।\n\nअगर आपका सर्वर HTTP के डिफॉल्ट पोर्ट (80 या 443) या जेलिफ़िन के डिफॉल्ट पोर्ट (8096) पर है तो आपको पोर्ट निर्दिष्ट करने की आवश्यकता नहीं है।\n\nअगर आपका URL सही है तो आपको इनपुट फ़ील्ड के नीचे अपने सर्वर के बारे में कुछ जानकारी दिखाई देगी।';

  @override
  String get serverUrlHint => 'e.g. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'सर्वर URL मदद';

  @override
  String get emptyServerUrl => 'सर्वर URL खाली नहीं रह सकता';

  @override
  String get connectingToServer => 'सर्वर से जोड़ा जा रहा…';

  @override
  String get loginFlowLocalNetworkServers => 'आपके स्थानीय नेटवर्क पर सर्वर:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'सर्वर को ढूंढ रहे…';

  @override
  String get loginFlowAccountSelectionHeading => 'अपना खाता चुनें';

  @override
  String get backToServerSelection => 'सर्वर चयन पर वापस जाएं';

  @override
  String get loginFlowNamelessUser => 'अनाम उपयोगकर्ता';

  @override
  String get loginFlowCustomUser => 'कस्टम उपयोगकर्ता';

  @override
  String get loginFlowAuthenticationHeading => 'अपने खाते में लॉगिन करें';

  @override
  String get backToAccountSelection => 'खाता चयन पर वापस जाएँ';

  @override
  String get loginFlowQuickConnectPrompt => 'Quick Connect कोड का इस्तेमाल करें';

  @override
  String get loginFlowQuickConnectInstructions => 'जेलिफ़िन ऐप या वेबसाइट खोलें, अपना खाता चुनें, और फिर Quick Connect चुनें।';

  @override
  String get loginFlowQuickConnectDisabled => 'इस सर्वर पर Quick Connect बंद है।';

  @override
  String get orDivider => 'या';

  @override
  String get loginFlowSelectAUser => 'उपयोगकर्ता चुनें';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get usernameHint => 'अपना उपयोगकर्ता नाम भरें';

  @override
  String get usernameValidationMissingUsername => 'कृपया उपयोगकर्ता नाम भरें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHint => 'अपना पासवर्ड भरें';

  @override
  String get login => 'लॉगिन';

  @override
  String get logs => 'लॉग';

  @override
  String get next => 'अगला';

  @override
  String get selectMusicLibraries => 'संगीत लाइब्रेरी चुनें';

  @override
  String get couldNotFindLibraries => 'कोई लाइब्रेरी नहीं मिली।';

  @override
  String get unknownName => 'अज्ञात नाम';

  @override
  String get tracks => 'ट्रैक';

  @override
  String get albums => 'एल्बम';

  @override
  String get artists => 'कलाकार';

  @override
  String get genres => 'शैली';

  @override
  String get playlists => 'प्लेलिस्ट';

  @override
  String get startMix => 'मिक्स शुरू करें';

  @override
  String get startMixNoTracksArtist => 'मिक्स शुरू करने से पहले मिक्स बिल्डर में किसी कलाकार को जोड़ने या हटाने के लिए उस पर देर तक दबाएं';

  @override
  String get startMixNoTracksAlbum => 'मिक्स शुरू करने से पहले मिक्स बिल्डर में किसी एल्बम को जोड़ने या हटाने के लिए उस पर देर तक दबाएं';

  @override
  String get startMixNoTracksGenre => 'मिक्स शुरू करने से पहले मिक्स बिल्डर में किसी शैली को जोड़ने या हटाने के लिए उस पर देर तक दबाएं';

  @override
  String get music => 'संगीत';

  @override
  String get clear => 'मिटाएं';

  @override
  String get favourites => 'पसंदीदा';

  @override
  String get shuffleAll => 'सभी शफ़ल';

  @override
  String get downloads => 'डाउनलोड्स';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get offlineMode => 'ऑफलाइन मोड';

  @override
  String get sortOrder => 'छांट अनुक्रम';

  @override
  String get sortBy => 'ऐसे छांटें';

  @override
  String get title => 'शीर्षक द्वारा';

  @override
  String get album => 'एल्बम द्वारा';

  @override
  String get albumArtist => 'एल्बम कलाकार द्वारा';

  @override
  String get artist => 'कलाकार द्वारा';

  @override
  String get budget => 'बजट द्वारा';

  @override
  String get communityRating => 'समुदाय रेटिंग द्वारा';

  @override
  String get criticRating => 'आलोचक रेटिंग द्वारा';

  @override
  String get dateAdded => 'जोड़े गए तिथि द्वारा';

  @override
  String get datePlayed => 'चलाए गए तिथि द्वारा';

  @override
  String get playCount => 'चलाए गए गिनती द्वारा';

  @override
  String get premiereDate => 'प्रीमियर तिथि द्वारा';

  @override
  String get productionYear => 'उत्पादन वर्ष द्वारा';

  @override
  String get name => 'नाम द्वारा';

  @override
  String get random => 'कैसे भी';

  @override
  String get revenue => 'आय द्वारा';

  @override
  String get runtime => 'रनटाइम द्वारा';

  @override
  String get syncDownloadedPlaylists => 'डाउनलोड की गई प्लेलिस्ट को सिंक करें';

  @override
  String get downloadMissingImages => 'गायब छवियाँ डाउनलोड करें';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छवियां डाउनलोड की गईं',
      one: '$count छवियां डाउनलोड की गईं',
      zero: 'कोई गायब छवि नहीं',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'सक्रिय डाउनलोड';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डाउनलोड',
      one: '$count डाउनलोड',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount ट्रैक',
      one: '$trackCount ट्रैक',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount छवियां',
      one: '$imageCount छवि',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount नोड सिंकिंग',
      one: '$syncCount नोड सिंकिंग',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nअभी मरम्मत हो रही',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count पूर्ण';
  }

  @override
  String dlFailed(int count) {
    return '$count असफल';
  }

  @override
  String dlEnqueued(int count) {
    return '$count कतार में';
  }

  @override
  String dlRunning(int count) {
    return '$count किए जा रहे';
  }

  @override
  String get activeDownloadsTitle => 'सक्रिय डाउनलोड';

  @override
  String get noActiveDownloads => 'कोई सक्रिय डाउनलोड नहीं।';

  @override
  String get errorScreenError => 'त्रुटियों की सूची प्राप्त करते समय त्रुटि हुई! आपको संभवतः GitHub पर एक मुद्दा बनाना चाहिए और ऐप डाटा को मिटाना चाहिए';

  @override
  String get failedToGetTrackFromDownloadId => 'डाउनलोड आईडी से गाना प्राप्त करने में असफल';

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
    return 'क्या आप वाकई इस डिवाइस से $_temp0 \'$itemName\' को हटाना चाहते हैं?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'मिटाएं';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'त्रुटि';

  @override
  String discNumber(int number) {
    return 'डिस्क $number';
  }

  @override
  String get playButtonLabel => 'चलाएं';

  @override
  String get shuffleButtonLabel => 'शफ़ल';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रैक',
      one: '$count ट्रैक',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रैक',
      one: '$count ट्रैक',
    );
    return '$_temp0, $downloads डाउनलोड किए गए';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रैक',
      one: '$count ट्रैक',
    );
    return '$_temp0 डाउनलोड किए गए';
  }

  @override
  String get editPlaylistNameTooltip => 'प्लेलिस्ट का नाम संपादित करें';

  @override
  String get editPlaylistNameTitle => 'प्लेलिस्ट नाम संपादन';

  @override
  String get required => 'आवश्यक';

  @override
  String get updateButtonLabel => 'लागू करें';

  @override
  String get playlistNameUpdated => 'प्लेलिस्ट का नाम बदला गया।';

  @override
  String get favourite => 'पसंद';

  @override
  String get downloadsDeleted => 'डाउनलोड्स मिटाए गए।';

  @override
  String get addDownloads => 'डाउनलोड्स जोड़ें';

  @override
  String get location => 'स्थान';

  @override
  String get confirmDownloadStarted => 'डाउनलोड शुरू किया गया';

  @override
  String get downloadsQueued => 'डाउनलोड तैयार है, फ़ाइलें डाउनलोड की जा रही हैं';

  @override
  String get addButtonLabel => 'जोड़ें';

  @override
  String get shareLogs => 'लॉग शेयर करें';

  @override
  String get logsCopied => 'लॉग कॉपी किए गए।';

  @override
  String get message => 'संदेश';

  @override
  String get stackTrace => 'स्टैक ट्रेस';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Mozilla Public License 2.0 के तहत लाइसेंस किया गया।\nस्त्रोत (Source) कोड यहाँ उपलब्ध है $sourceCodeLink।';
  }

  @override
  String get transcoding => 'ट्रांसकोडिंग';

  @override
  String get downloadLocations => 'डाउनलोड स्थान';

  @override
  String get audioService => 'ऑडियो सेवा';

  @override
  String get interactions => 'इंटरैक्शन';

  @override
  String get layoutAndTheme => 'लेआउट और थीम';

  @override
  String get notAvailableInOfflineMode => 'ऑफ़लाइन मोड में उपलब्ध नहीं है';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get downloadedTracksWillNotBeDeleted => 'डाउनलोड किए गए ट्रैक को मिटाया नहीं जाएगा';

  @override
  String get areYouSure => 'क्या आप निश्चित हैं?';

  @override
  String get jellyfinUsesAACForTranscoding => 'जेलीफ़िन ट्रांसकोडिंग के लिए AAC का उपयोग करता है';

  @override
  String get enableTranscoding => 'ट्रांसकोडिंग सक्षम करें';

  @override
  String get enableTranscodingSubtitle => 'संगीत स्ट्रीम को सर्वर पर ही ट्रांसकोड करता है।';

  @override
  String get bitrate => 'बिटरेट';

  @override
  String get bitrateSubtitle => 'उच्चतर बिटरेट, उच्चतर बैंडविड्थ की कीमत पर उच्चतर गुणवत्ता वाला ऑडियो देता है।';

  @override
  String get customLocation => 'कस्टम स्थान';

  @override
  String get appDirectory => 'ऐप डायरेक्टरी';

  @override
  String get addDownloadLocation => 'डाउनलोड स्थान जोड़ें';

  @override
  String get selectDirectory => 'डायरेक्टरी चुनें';

  @override
  String get unknownError => 'अज्ञात त्रुटि';

  @override
  String get pathReturnSlashErrorMessage => '\"/\" लौटने वाले पथ का उपयोग नहीं किया जा सकता';

  @override
  String get directoryMustBeEmpty => 'डायरेक्टरी खाली होना चाहिए';

  @override
  String get customLocationsBuggy => 'कस्टम लोकेशन में बहुत अधिक खामियां हो सकती हैं और अधिकांश मामलों में इसको रिकमेंड नहीं किया जाता। सिस्टम \'Music\' फ़ोल्डर के अंतर्गत स्थान, ऑपरेटिंग सिस्टम की सीमाओं के कारण एल्बम कवर को सहेजने से रोकते हैं।';

  @override
  String get enterLowPriorityStateOnPause => 'रोकने के दौरान Low-Priority State में जाएं';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'यह नोटिफिकेशन को रोके जाने पर स्वाइप करके हटा देता है। साथ ही, यह एंड्रॉयड को रोके जाने पर सेवा को बंद करने की अनुमति भी देता है।';

  @override
  String get shuffleAllTrackCount => 'सभी ट्रैक को शफ़ल करने की संख्या';

  @override
  String get shuffleAllTrackCountSubtitle => 'सभी ट्रैक शफ़ल करने वाले बटन का उपयोग करते समय लोड किए जाने वाले ट्रैकों की मात्रा।';

  @override
  String get viewType => 'दृश्य प्रकार';

  @override
  String get viewTypeSubtitle => 'संगीत स्क्रीन के लिए दृश्य प्रकार';

  @override
  String get list => 'लिस्ट';

  @override
  String get grid => 'ग्रिड';

  @override
  String get customizationSettingsTitle => 'कस्टमाइजेशन';

  @override
  String get playbackSpeedControlSetting => 'प्लेबैक गति दृश्यता';

  @override
  String get playbackSpeedControlSettingSubtitle => 'प्लेबैक गति के नियंत्रण प्लेयर स्क्रीन मेनू में दिखाए';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'ऑटोमैटिक:\nफ़िनएम्प यह पहचानने का प्रयास करता है कि आप जो ट्रैक चला रहे हैं वह पॉडकास्ट है या ऑडियोबुक (का हिस्सा) है। ऐसा तब माना जाता है जब ट्रैक $trackDuration मिनट से अधिक लंबा हो, यदि ट्रैक का एल्बम $albumDuration घंटे से अधिक लंबा है, या यदि ट्रैक में इनमें से कम से कम एक शैली निर्दिष्ट है: $genreList\nतब प्लेबैक गति के नियंत्रण प्लेयर स्क्रीन में दिखाए जाएंगे।\n\nदिखाएं:\nप्लेबैक गति के नियंत्रण प्लेयर स्क्रीन में हमेशा दिखाए जाएंगे।\n\nछिपाएं:\nप्लेबैक गति के नियंत्रण प्लेयर स्क्रीन में नहीं दिखाए जाएंगे।';
  }

  @override
  String get automatic => 'ऑटोमैटिक';

  @override
  String get shown => 'दिखाएं';

  @override
  String get hidden => 'छिपाएं';

  @override
  String get speed => 'गति';

  @override
  String get reset => 'रीसेट';

  @override
  String get apply => 'लागू';

  @override
  String get portrait => 'पोर्ट्रेट';

  @override
  String get landscape => 'लैंडस्केप';

  @override
  String gridCrossAxisCount(String value) {
    return '$value ग्रिड क्रॉस-एक्सिस मात्रा';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'प्रति पंक्ति उपयोग की जाने वाली ग्रिड टाइल्स की मात्रा जब $value।';
  }

  @override
  String get showTextOnGridView => 'ग्रिड व्यू में टेक्स्ट दिखाएं';

  @override
  String get showTextOnGridViewSubtitle => 'ग्रिड संगीत स्क्रीन पर टैक्स्ट (शीर्षक, कलाकार आदि) को दिखाएं या नहीं।';

  @override
  String get useCoverAsBackground => 'धुंधले कवर को पृष्ठभूमि के रूप में उपयोग करें';

  @override
  String get useCoverAsBackgroundSubtitle => 'ऐप के विभिन्न भागों में पृष्ठभूमि के रूप में धुंधले एल्बम कवर का उपयोग करें या नहीं।';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'न्यूनतम एल्बम कवर पैडिंग';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'प्लेयर स्क्रीन पर एल्बम कवर के आसपास न्यूनतम पैडिंग, स्क्रीन चौड़ाई के % में।';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'यदि एल्बम कलाकारों के समान हो तो ट्रैक के कलाकारों को छिपाएं';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'एल्बम स्क्रीन पर ट्रैक कलाकारों को दिखाएं या नहीं, यदि वे एल्बम कलाकारों से भिन्न न हों।';

  @override
  String get showArtistsTopTracks => 'कलाकार दृश्य में शीर्ष ट्रैक दिखाएं';

  @override
  String get showArtistsTopTracksSubtitle => 'किसी कलाकार के सर्वाधिक सुने गए शीर्ष 5 ट्रैक दिखाए जाएं या नहीं।';

  @override
  String get disableGesture => 'जेस्चर को बंद करना';

  @override
  String get disableGestureSubtitle => 'जेस्चर को बंद करें या नहीं।';

  @override
  String get showFastScroller => 'फास्ट स्क्रॉलर दिखाएं';

  @override
  String get theme => 'थीम';

  @override
  String get system => 'सिस्टम';

  @override
  String get light => 'लाइट';

  @override
  String get dark => 'डार्क';

  @override
  String get tabs => 'टैब';

  @override
  String get playerScreen => 'प्लेयर स्क्रीन';

  @override
  String get cancelSleepTimer => 'क्या स्लीप टाइमर को रद्द करें?';

  @override
  String get yesButtonLabel => 'हाँ';

  @override
  String get noButtonLabel => 'नहीं';

  @override
  String get setSleepTimer => 'स्लीप टाइमर सेट करें';

  @override
  String get hours => 'घंटे';

  @override
  String get seconds => 'सेकंड';

  @override
  String get minutes => 'मिनट';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$totalTime का $currentTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return '$totalTrackCount ट्रैक में से $currentTrackIndex';
  }

  @override
  String get invalidNumber => 'अमान्य संख्या';

  @override
  String get sleepTimerTooltip => 'स्लीप टाइमर';

  @override
  String sleepTimerRemainingTime(int time) {
    return '$time मिनट में सोना';
  }

  @override
  String get addToPlaylistTooltip => 'प्लेलिस्ट में जोड़ें';

  @override
  String get addToPlaylistTitle => 'प्लेलिस्ट में जोड़ें';

  @override
  String get addToMorePlaylistsTooltip => 'और अधिक प्लेलिस्ट में जोड़ें';

  @override
  String get addToMorePlaylistsTitle => 'और अधिक प्लेलिस्ट में जोड़ें';

  @override
  String get removeFromPlaylistTooltip => 'इस प्लेलिस्ट से निकालें';

  @override
  String get removeFromPlaylistTitle => 'इस प्लेलिस्ट से निकालें';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'प्लेलिस्ट \'$playlistName\' से निकालें';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'प्लेलिस्ट \'$playlistName\' से निकालें';
  }

  @override
  String get newPlaylist => 'नई प्लेलिस्ट';

  @override
  String get createButtonLabel => 'बनाएं';

  @override
  String get playlistCreated => 'प्लेलिस्ट बनाई गई।';

  @override
  String get playlistActionsMenuButtonTooltip => 'प्लेलिस्ट में जोड़ने के लिए टैप करें। पसंदीदा टॉगल करने के लिए लंबे समय तक दबाएं।';

  @override
  String get noAlbum => 'कोई एल्बम नहीं';

  @override
  String get noItem => 'कोई आइटम नहीं';

  @override
  String get noArtist => 'कोई कलाकार नहीं';

  @override
  String get unknownArtist => 'अज्ञात कलाकार';

  @override
  String get unknownAlbum => 'अज्ञात एल्बम';

  @override
  String get playbackModeDirectPlaying => 'Direct Playing';

  @override
  String get playbackModeTranscoding => 'ट्रांसकोडिंग';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Locally Playing';

  @override
  String get queue => 'कतार';

  @override
  String get addToQueue => 'कतार में जोड़ें';

  @override
  String get replaceQueue => 'कतार बदलें';

  @override
  String get instantMix => 'इंस्टेंट मिक्स';

  @override
  String get goToAlbum => 'एल्बम पर जाएं';

  @override
  String get goToArtist => 'कलाकार पर जाएं';

  @override
  String get goToGenre => 'शैली पर जाएं';

  @override
  String get removeFavourite => 'पसंदीदा से निकलें';

  @override
  String get addFavourite => 'पसंदीदा बनाएं';

  @override
  String get confirmFavoriteAdded => 'पसंदीदा बनाया गया';

  @override
  String get confirmFavoriteRemoved => 'पसंदीदा से निकाला गया';

  @override
  String get addedToQueue => 'कतार में जोड़ा गया।';

  @override
  String get insertedIntoQueue => 'कतार के बीच में जोड़ा गया।';

  @override
  String get queueReplaced => 'कतार बदली गई।';

  @override
  String get confirmAddedToPlaylist => 'प्लेलिस्ट में जोड़ा गया।';

  @override
  String get removedFromPlaylist => 'प्लेलिस्ट से निकाला गया।';

  @override
  String get startingInstantMix => 'इंस्टेंट मिक्स शुरू किया जा रहा है।';

  @override
  String get anErrorHasOccured => 'कोई त्रुटि हुई।';

  @override
  String responseError(String error, int statusCode) {
    return '$error स्टेटस कोड $statusCode।';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error स्टेटस कोड $statusCode. शायद आपने गलत उपयोगकर्ता नाम/पासवर्ड का उपयोग किया है, या आपका क्लाइंट अब लॉगिन नहीं है।';
  }

  @override
  String get removeFromMix => 'मिक्स से निकालें';

  @override
  String get addToMix => 'मिक्स में जोड़ें';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम दोबारा डाउनलोड किया गया',
      one: '$count आइटम दोबारा डाउनलोड किया गया',
      zero: 'दोबारा डाउनलोड करने की आवश्यकता नहीं',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'बफ़र अवधि';

  @override
  String get bufferDurationSubtitle => 'बफ़र करने की अधिकतम अवधि, सेकंड में। रिस्टार्ट की आवश्यकता पड़ेगी।';

  @override
  String get bufferDisableSizeConstraintsTitle => 'बफ़र साइज को सीमित न करें';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'बफ़र साइज बाधाओं (\'Buffer Size\') को अक्षम करता है। बफ़र हमेशा कॉन्फ़िगर की गई अवधि (\'Buffer Duration\') तक लोड किया जाएगा, यहां तक कि बहुत बड़ी फ़ाइलों के लिए भी। क्रैश का कारण बन सकता है। रिस्टार्ट करने की आवश्यकता पड़ेगी।';

  @override
  String get bufferSizeTitle => 'बफ़र साइज';

  @override
  String get bufferSizeSubtitle => 'बफ़र करने की अधिकतम साइज MB में। रिस्टार्ट करने की आवश्यकता पड़ेगी';

  @override
  String get language => 'भाषा';

  @override
  String get skipToPreviousTrackButtonTooltip => 'पहले या पिछले ट्रैक पर जाएं';

  @override
  String get skipToNextTrackButtonTooltip => 'अगले ट्रैक पर जाएं';

  @override
  String get togglePlaybackButtonTooltip => 'टॉगल प्लेबैक';

  @override
  String get previousTracks => 'पिछला ट्रैक';

  @override
  String get nextUp => 'Next Up';

  @override
  String get clearNextUp => 'Next Up मिटाएं';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'चलाया जा रहा';

  @override
  String get playNext => 'अगला चलाएं';

  @override
  String get addToNextUp => 'Next Up में जोड़ें';

  @override
  String get shuffleNext => 'अगला शफ़ल करें';

  @override
  String get shuffleToNextUp => 'Next Up तक शफ़ल करें';

  @override
  String get shuffleToQueue => 'कतार तक शफ़ल करें';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'ट्रैक',
        'album': 'एल्बम',
        'artist': 'कलाकार',
        'playlist': 'प्लेलिस्ट',
        'genre': 'शैली',
        'other': 'आइटम',
      },
    );
    return '$_temp0 अगला चलेगा';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'ट्रैक',
        'album': 'एल्बम',
        'artist': 'कलाकार',
        'playlist': 'प्लेलिस्ट',
        'genre': 'शैली',
        'other': 'आइटम',
      },
    );
    return '$_temp0 Next Up में जोड़ा गया';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'ट्रैक',
        'album': 'एल्बम',
        'artist': 'कलाकार',
        'playlist': 'प्लेलिस्ट',
        'genre': 'शैली',
        'other': 'आइटम',
      },
    );
    return '$_temp0 कतार में जोड़ा गया';
  }

  @override
  String get confirmShuffleNext => 'आगे शफ़ल किया जाएगा';

  @override
  String get confirmShuffleToNextUp => 'Next Up तक शफ़ल किया गया';

  @override
  String get confirmShuffleToQueue => 'कतार तक शफ़ल किया गया';

  @override
  String get placeholderSource => 'कहीं';

  @override
  String get playbackHistory => 'प्लेबैक इतिहास';

  @override
  String get shareOfflineListens => 'ऑफलाइन दौरान सुने गए को साझा करें';

  @override
  String get yourLikes => 'आपके लाइक';

  @override
  String mix(String mixSource) {
    return '$mixSource - मिक्स';
  }

  @override
  String get tracksFormerNextUp => 'Next Up द्वारा जोड़े गए ट्रैक';

  @override
  String get savedQueue => 'सहेजी गई कतार';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'एल्बम',
        'playlist': 'प्लेलिस्ट',
        'trackMix': 'ट्रैक मिक्स',
        'artistMix': 'कलाकार मिक्स',
        'albumMix': 'एल्बम मिक्स',
        'genreMix': 'शैली मिक्स',
        'favorites': 'पसंदीदा',
        'allTracks': 'सभी ट्रैक',
        'filteredList': 'ट्रैक',
        'genre': 'शैली',
        'artist': 'कलाकार',
        'track': 'ट्रैक',
        'nextUpAlbum': 'Next Up में एल्बम',
        'nextUpPlaylist': 'Next Up में प्लेलिस्ट',
        'nextUpArtist': 'Next Up में कलाकार',
        'other': '',
      },
    );
    return 'यहां से चला रहे $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'सभी शफ़ल करें';

  @override
  String get playbackOrderLinearButtonLabel => 'एक कतार में चला रहे';

  @override
  String get playbackOrderLinearButtonTooltip => 'एक कतार में चला रहे। शफ़ल करने के लिए टैप करें।';

  @override
  String get playbackOrderShuffledButtonLabel => 'ट्रैक को शफ़ल किया जा रहा है';

  @override
  String get playbackOrderShuffledButtonTooltip => 'ट्रैक को शफ़ल किया जा रहा है। एक कतार में चलाने के लिए टैप करें।';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'x$speed कि गति से चल रहा';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed गति';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'प्लेबैक गति घटाएं';

  @override
  String get playbackSpeedIncreaseLabel => 'प्लेबैक गति बढ़ाएं';

  @override
  String get loopModeNoneButtonLabel => 'लूप नहीं किया जा रहा';

  @override
  String get loopModeOneButtonLabel => 'इस ट्रैक को लूप किया जा रहा';

  @override
  String get loopModeAllButtonLabel => 'सभी को लूप किया जा रहा';

  @override
  String get queuesScreen => 'Now Playing पुनर्स्थापित करें';

  @override
  String get queueRestoreButtonLabel => 'पुनर्स्थापित करें';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString को सहेजा गया';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'चल रहा: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रैक',
      one: '1 ट्रैक',
    );
    return '$_temp0, $remaining Unplayed';
  }

  @override
  String get queueLoadingMessage => 'कतार को पुनर्स्थापित किया जा रहा…';

  @override
  String get queueRetryMessage => 'कतार को पुनर्स्थापित करने में असफल। दोबारा प्रयास करें?';

  @override
  String get autoloadLastQueueOnStartup => 'आखिरी कतार को अपने-आप पुनर्स्थापित करें';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'ऐप शुरू होने पर, अंतिम बार चलाए गए कतार को पुनर्स्थापित करने का प्रयास करें।';

  @override
  String get reportQueueToServer => 'सर्वर को वर्तमान कतार की रिपोर्ट करें?';

  @override
  String get reportQueueToServerSubtitle => 'सक्षम होने पर, फ़िनएम्प वर्तमान कतार को सर्वर पर भेजेगा। वर्तमान में इसका बहुत कम उपयोग है, और इससे नेटवर्क ट्रैफ़िक बढ़ता है।';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'प्लेबैक सत्र अपडेट होने की फ्रिक्वेंसी';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'सर्वर को वर्तमान प्लेबैक स्थिति कितने समय में भेजी जाए, सेकंड में। सत्र का समय समाप्त होने से रोकने के लिए यह 5 मिनट (300 सेकंड) से कम होना चाहिए।';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'यदि जेलिफ़िन सर्वर को पिछले 5 मिनट में क्लाइंट से कोई अपडेट नहीं मिलता है, तो वह मान लेता है कि प्लेबैक समाप्त हो गया है। इसका मतलब है कि 5 मिनट से ज़्यादा लंबे ट्रैक के लिए, गलत प्लेबैक रिपोर्ट की जा सकती है, जिससे प्लेबैक रिपोर्टिंग डाटा की गुणवत्ता कम हो जाती है।';

  @override
  String get topTracks => 'शीर्ष ट्रैक';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count एल्बम',
      one: '$count एल्बम',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'एल्बम शफ़ल करें';

  @override
  String get shuffleAlbumsNext => 'एल्बम शफ़ल करें अगला';

  @override
  String get shuffleAlbumsToNextUp => 'Next Up तक एल्बम शफ़ल करें';

  @override
  String get shuffleAlbumsToQueue => 'कतार तक एल्बम शफ़ल करें';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount चलाए गए',
      one: '$playCount चलाए गए',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'प्लेलिस्ट',
        'trackMix': 'ट्रैक मिक्स',
        'artistMix': 'कलाकार मिक्स',
        'albumMix': 'एल्बम मिक्स',
        'genreMix': 'शैली मिक्स',
        'favorites': 'पसंदीदा',
        'allTracks': 'सभी ट्रैक',
        'filteredList': 'ट्रैक',
        'genre': 'शैली',
        'artist': 'कलाकार',
        'track': 'ट्रैक',
        'nextUpAlbum': 'next up में एल्बम',
        'nextUpPlaylist': 'next up में प्लेलिस्ट',
        'nextUpArtist': 'next up में कलाकार',
        'other': '',
      },
    );
    return '$_temp0 को लोड नहीं किया जा सका';
  }

  @override
  String get confirm => 'पुष्टि';

  @override
  String get close => 'बंद';

  @override
  String get showUncensoredLogMessage => 'इस लॉग में आपकी लॉगिन जानकारी शामिल है। दिखाएं?';

  @override
  String get resetTabs => 'टैब रीसेट करें';

  @override
  String get resetToDefaults => 'डिफ़ॉल्ट के लिए रीसेट करें';

  @override
  String get noMusicLibrariesTitle => 'कोई संगीत लाइब्रेरी नहीं';

  @override
  String get noMusicLibrariesBody => 'फ़िनएम्प को कोई संगीत लाइब्रेरी नहीं मिली। कृपया सुनिश्चित करें कि आपके जेलिफ़िन सर्वर में कम से कम एक लाइब्रेरी हो, जिसका कंटेंट टाइप \"संगीत\" पर सेट हो।';

  @override
  String get refresh => 'रिफ्रेश';

  @override
  String get moreInfo => 'अधिक जानकारी';

  @override
  String get volumeNormalizationSettingsTitle => 'वॉल्यूम सामान्यीकरण';

  @override
  String get volumeNormalizationSwitchTitle => 'वॉल्यूम सामान्यीकरण सक्षम करें';

  @override
  String get volumeNormalizationSwitchSubtitle => 'ट्रैक की लाउडनेस को सामान्य करने के लिए गेन जानकारी का उपयोग करें (\"रिप्ले गेन\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'वॉल्यूम सामान्यीकरण मोड';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'वॉल्यूम सामान्यीकरण कब और कैसे लागू करें';

  @override
  String get volumeNormalizationModeSelectorDescription => 'हाइब्रिड (ट्रैक + एल्बम):\nट्रैक गेन का उपयोग नियमित प्लेबैक के लिए किया जाता है, लेकिन यदि कोई एल्बम चल रहा है (या तो इसलिए कि यह मुख्य प्लेबैक कतार स्रोत है, या क्योंकि इसे किसी समय पर कतार में जोड़ा गया था), तो इसके बजाय एल्बम गेन का उपयोग किया जाएगा।\n\nट्रैक-आधारित:\nट्रैक गेन का उपयोग हमेशा किया जाएगा, चाहे कोई एल्बम चल रहा हो या नहीं।\n\nकेवल एल्बम:\nवॉल्यूम सामान्यीकरण केवल एल्बम चलाते समय लागू होगा (एल्बम गेन का उपयोग करके), लेकिन व्यक्तिगत ट्रैक के लिए नहीं।';

  @override
  String get volumeNormalizationModeHybrid => 'हाइब्रिड (ट्रैक + एल्बम)';

  @override
  String get volumeNormalizationModeTrackBased => 'ट्रैक-आधारित';

  @override
  String get volumeNormalizationModeAlbumBased => 'एल्बम-आधारित';

  @override
  String get volumeNormalizationModeAlbumOnly => 'केवल एल्बम के लिए';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'बेस गेन';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'वर्तमान में, iOS पर वॉल्यूम सामान्यीकरण के लिए प्लेबैक वॉल्यूम को इस तरह बदलने की आवश्यकता है जिससे वह गेन में बदलाव को इमूलेट कर सके। चूँकि हम वॉल्यूम को 100% से अधिक नहीं बढ़ा सकते हैं, इसलिए हमें डिफ़ॉल्ट रूप से वॉल्यूम कम करना होगा ताकि हम शांत ट्रैक का वॉल्यूम बढ़ा सकें। मान डेसिबल (dB) में है, जहाँ -10 dB ~30% वॉल्यूम है, -4.5 dB ~60% वॉल्यूम है और -2 dB ~80% वॉल्यूम है।';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'स्वाइप किया गया ट्रैक अगला चलाएं';

  @override
  String get swipeInsertQueueNextSubtitle => 'ट्रैक सूची में स्वाइप करने पर उसे अंत में जोड़ने के बजाय कतार में अगले आइटम के रूप में सम्मिलित करने को सक्षम करें।';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'व्यक्तिगत ट्रैक के लिए इंस्टेंट मिक्स शुरू करें';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'सक्षम होने पर, ट्रैक टैब पर किसी ट्रैक को टैप करने से केवल एक ट्रैक चलाने के बजाय उस ट्रैक का इंस्टेंट मिक्स शुरू हो जाएगा।';

  @override
  String get downloadItem => 'डाउनलोड';

  @override
  String get repairComplete => 'डाउनलोड मरम्मत पूरा हुआ।';

  @override
  String get syncComplete => 'सभी डाउनलोड दोबारा सिंक्रोनाइज किए गए।';

  @override
  String get syncDownloads => 'गुम आइटम को सिंक करें और डाउनलोड करें।';

  @override
  String get repairDownloads => 'डाउनलोड की गई फ़ाइलों या मेटाडाटा से संबंधित समस्याओं को सुधारें।';

  @override
  String get requireWifiForDownloads => 'WiFi पर ही डाउनलोड करें।';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रैक',
      one: '$count ट्रैक',
    );
    return 'चेतावनी: $_temp0 कतार में पुनर्स्थापित नहीं किए जा सके।';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'डाउनलोड हो रहे',
        'failed': 'डाउनलोड असफल',
        'syncFailed': 'सिंक असफल',
        'enqueued': 'डाउनलोड कतार में',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'डाउनलोड',
      one: 'डाउनलोड',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'क्या आप वाकई लाइब्रेरी \'\'$libraryName\'\' की सभी सामग्री डाउनलोड करना चाहते हैं?';
  }

  @override
  String get onlyShowFullyDownloaded => 'केवल पूरी तरह से डाउनलोड किए गए एल्बम दिखाएं';

  @override
  String get filesystemFull => 'शेष डाउनलोड पूरे नहीं किए जा सकते। फ़ाइल सिस्टम भरा हुआ है।';

  @override
  String get connectionInterrupted => 'कनेक्शन बाधित, डाउनलोड रोका जा रहा है।';

  @override
  String get connectionInterruptedBackground => 'बैकग्राउंड में डाउनलोड करते समय कनेक्शन बाधित हुआ। यह OS की सेटिंग के कारण हो सकता है।';

  @override
  String get connectionInterruptedBackgroundAndroid => 'बैकग्राउंड में डाउनलोड करते समय कनेक्शन बाधित हुआ। ऐसा \'रोकने के दौरान Low-Priority State में जाएं\' सक्षम करने या OS की सेटिंग के कारण हो सकता है।';

  @override
  String get activeDownloadSize => 'डाउनलोड किया जा रहा…';

  @override
  String get missingDownloadSize => 'मिटाया जा रहा…';

  @override
  String get syncingDownloadSize => 'सिंक्रोनाइज किया जा रहा…';

  @override
  String get runRepairWarning => 'डाउनलोड माइग्रेशन को अंतिम रूप देने के लिए सर्वर से संपर्क नहीं किया जा सका। कृपया जैसे ही आप ऑनलाइन वापस आएँ, डाउनलोड स्क्रीन से \'रिपेयर डाउनलोड\' चलाएं।';

  @override
  String get downloadSettings => 'डाउनलोड';

  @override
  String get showNullLibraryItemsTitle => 'अज्ञात लाइब्रेरी वाली मीडिया दिखाएं।';

  @override
  String get showNullLibraryItemsSubtitle => 'कुछ मीडिया को किसी अज्ञात लाइब्रेरी से डाउनलोड किया जा सकता है। इन्हें उनके मूल संग्रह से बाहर छिपाने के लिए इसे बंद करें।';

  @override
  String get maxConcurrentDownloads => 'अधिकतम इकट्ठे डाउनलोड';

  @override
  String get maxConcurrentDownloadsSubtitle => 'इकट्ठे डाउनलोड की संख्या बढ़ाने से पृष्ठभूमि में डाउनलोड की गति बढ़ सकती है, लेकिन यदि डाउनलोड बहुत बड़े हों तो कुछ डाउनलोड असफल हो सकते हैं, या कुछ मामलों में अत्यधिक विलंब हो सकता है।';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count इकट्ठे डाउनलोड';
  }

  @override
  String get downloadsWorkersSetting => 'डाउनलोड वर्कर मात्रा';

  @override
  String get downloadsWorkersSettingSubtitle => 'मेटाडाटा को सिंक करने और डाउनलोड को हटाने के लिए वर्कर्स की मात्रा। डाउनलोड वर्कर्स को बढ़ाने से डाउनलोड सिंकिंग और डिलीट करने की गति बढ़ सकती है, खासकर जब सर्वर लेटेंसी अधिक हो, लेकिन इससे लैग भी हो सकता है।';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count डाउनलोड वर्कर';
  }

  @override
  String get syncOnStartupSwitch => 'स्टार्टअप पर डाउनलोड को अपने-आप सिंक करें';

  @override
  String get preferQuickSyncSwitch => 'क्विक सिंक को प्राथमिकता दें';

  @override
  String get preferQuickSyncSwitchSubtitle => 'सिंक करते समय, कुछ सामान्यतः स्थिर आइटम (जैसे ट्रैक और एल्बम) अपडेट नहीं किए जाएँगे। डाउनलोड रिपेयर हमेशा पूर्ण सिंक करेगा।';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'एल्बम',
        'playlist': 'प्लेलिस्ट',
        'artist': 'कलाकार',
        'genre': 'शैली',
        'track': 'ट्रैक',
        'library': 'लाइब्रेरी',
        'unknown': 'आइटम',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'इस आइटम को $parentName द्वारा डाउनलोड किया जाना आवश्यक है।';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'पसंदीदा',
        'allPlaylists': 'सभी प्लेलिस्ट',
        'fiveLatestAlbums': '5 नवीनतम एल्बम',
        'allPlaylistsMetadata': 'प्लेलिस्ट मेटाडाटा',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return '\'$libraryName\' के लिए कैश की गई छवियां';
  }

  @override
  String get transcodingStreamingContainerTitle => 'ट्रांसकोडिंग कंटेनर चुनें';

  @override
  String get transcodingStreamingContainerSubtitle => 'ट्रांसकोडेड ऑडियो स्ट्रीम करते समय उपयोग करने के लिए सेगमेंट कंटेनर चुनें। पहले से कतारबद्ध ट्रैक प्रभावित नहीं होंगे।';

  @override
  String get downloadTranscodeEnableTitle => 'ट्रांसकोडेड डाउनलोड सक्षम करें';

  @override
  String get downloadTranscodeCodecTitle => 'डाउनलोड Codec चुनें';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'हमेशा',
        'never': 'कभी नहीं',
        'ask': 'पूछें',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'डाउनलोड का बिटरेट';

  @override
  String get downloadBitrateSubtitle => 'उच्चतर बिटरेट, अधिक भंडारण आवश्यकताओं की कीमत पर उच्चतर गुणवत्ता वाला ऑडियो प्रदान करता है।';

  @override
  String get transcodeHint => 'ट्रांसकोड?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'ऐसे डाउनलोड करें $codec @ $bitrate$_temp0';
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
    return 'ओरिजिनल डाउनलोड करें $_temp0';
  }

  @override
  String get redownloadcomplete => 'ट्रांसकोड पुनःडाउनलोड कतारबद्ध।';

  @override
  String get redownloadTitle => 'ट्रांसकोड को अपने-आप पुनः डाउनलोड करें';

  @override
  String get redownloadSubtitle => 'उन ट्रैक्स को अपने-आप पुनः डाउनलोड करें जिनकी मूल संग्रह में परिवर्तन के कारण भिन्न गुणवत्ता होने की संभावना है।';

  @override
  String get defaultDownloadLocationButton => 'डिफ़ॉल्ट डाउनलोड स्थान के रूप में सेट करें।  प्रति डाउनलोड के लिए अक्षम करें।';

  @override
  String get fixedGridSizeSwitchTitle => 'निश्चित आकार की ग्रिड टाइलों का उपयोग करें';

  @override
  String get fixedGridSizeSwitchSubtitle => 'ग्रिड टाइल का आकार विंडो/स्क्रीन के आकार के अनुरूप नहीं होगा।';

  @override
  String get fixedGridSizeTitle => 'ग्रिड टाइल का आकार';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'छोटा',
        'medium': 'मीडियम',
        'large': 'बड़ा',
        'veryLarge': 'बहुत बड़ा',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'स्प्लिटस्क्रीन मोड की अनुमति दें';

  @override
  String get allowSplitScreenSubtitle => 'प्लेयर को अन्य दृश्यों के साथ व्यापक डिस्प्ले पर प्रदर्शित किया जाएगा।';

  @override
  String get enableVibration => 'वाइब्रेशन सक्षम करें';

  @override
  String get enableVibrationSubtitle => 'वाइब्रेशन सक्षम करें या नहीं।';

  @override
  String get hideQueueButton => 'कतार बटन छिपाएं';

  @override
  String get hideQueueButtonSubtitle => 'प्लेयर स्क्रीन पर कतार बटन छिपाएँ। कतार तक पहुँचने के लिए ऊपर की ओर स्वाइप करें।';

  @override
  String get oneLineMarqueeTextButton => 'लंबे शीर्षकों को ऑटो-स्क्रॉल करें';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'उन ट्रैक शीर्षकों को स्वचालित रूप से स्क्रॉल करें जो दो पंक्तियों में प्रदर्शित करने के लिए बहुत लंबे हैं';

  @override
  String get marqueeOrTruncateButton => 'लंबे शीर्षकों के लिए एलिप्सिस का उपयोग करें';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'स्क्रॉलिंग टेक्स्ट के बजाय लंबे शीर्षकों के अंत में ... दिखाएँ';

  @override
  String get hidePlayerBottomActions => 'नीचे की क्रियाएं छिपाएं';

  @override
  String get hidePlayerBottomActionsSubtitle => 'प्लेयर स्क्रीन पर कतार और बोल बटन छिपाएँ। कतार तक पहुँचने के लिए ऊपर की ओर स्वाइप करें, यदि उपलब्ध हो तो बोल देखने के लिए बाईं ओर (एल्बम कवर के नीचे) स्वाइप करें।';

  @override
  String get prioritizePlayerCover => 'एल्बम कवर को प्राथमिकता दें';

  @override
  String get prioritizePlayerCoverSubtitle => 'प्लेयर स्क्रीन पर बड़े एल्बम कवर को दिखाने को प्राथमिकता दें। छोटे स्क्रीन साइज़ पर गैर-महत्वपूर्ण नियंत्रण अधिक आक्रामक तरीके से छिपाए जाएंगे।';

  @override
  String get suppressPlayerPadding => 'प्लेयर नियंत्रण पैडिंग को सप्रेस करें';

  @override
  String get suppressPlayerPaddingSubtitle => 'जब एल्बम कवर पूर्ण आकार में नहीं हो, तो प्लेयर स्क्रीन नियंत्रणों के बीच पैडिंग को पूरी तरह से न्यूनतम कर दिया जाएगा।';

  @override
  String get lockDownload => 'हमेशा डिवाइस पर रखें';

  @override
  String get showArtistChipImage => 'कलाकार के नाम के साथ कलाकार का चित्र भी दिखाएं';

  @override
  String get showArtistChipImageSubtitle => 'इससे छोटी कलाकार छवि प्रिव्यू प्रभावित होती है, जैसे कि प्लेयर स्क्रीन पर।';

  @override
  String get scrollToCurrentTrack => 'वर्तमान ट्रैक पर स्क्रॉल करें';

  @override
  String get enableAutoScroll => 'ऑटो-स्क्रॉल सक्षम करें';

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
    return '$duration बचा हुआ';
  }

  @override
  String get removeFromPlaylistConfirm => 'निकालें';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'प्लेलिस्ट \'$playlistName\' में से \'$itemName\' निकलें?';
  }

  @override
  String get trackMenuButtonTooltip => 'ट्रैक मेनू';

  @override
  String get quickActions => 'क्विक एक्शन्स';

  @override
  String get addRemoveFromPlaylist => 'प्लेलिस्ट से जोड़ें/निकालें';

  @override
  String get addPlaylistSubheader => 'प्लेलिस्ट में ट्रैक जोड़ें';

  @override
  String get trackOfflineFavorites => 'सभी पसंदीदा स्थितियों को सिंक करें';

  @override
  String get trackOfflineFavoritesSubtitle => 'इससे ऑफ़लाइन रहते हुए भी अधिक अप-टू-डेट पसंदीदा स्थितियां दिखाई जा सकती हैं। कोई अतिरिक्त फ़ाइल डाउनलोड नहीं होती।';

  @override
  String get allPlaylistsInfoSetting => 'प्लेलिस्ट मेटाडाटा डाउनलोड करें';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'अपने प्लेलिस्ट अनुभव को बेहतर बनाने के लिए सभी प्लेलिस्ट के मेटाडाटा को सिंक करें';

  @override
  String get downloadFavoritesSetting => 'सभी पसंदीदा डाउनलोड करें';

  @override
  String get downloadAllPlaylistsSetting => 'सभी प्लेलिस्ट डाउनलोड करें';

  @override
  String get fiveLatestAlbumsSetting => '5 नवीनतम एल्बम डाउनलोड करें';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'डाउनलोड पुराने हो जाने पर उन्हें हटा दिया जाएगा। किसी एल्बम को हटाए जाने से रोकने के लिए डाउनलोड को लॉक करें।';

  @override
  String get cacheLibraryImagesSettings => 'वर्तमान लाइब्रेरी छवियों को कैश करें';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'वर्तमान में सक्रिय लाइब्रेरी में सभी एल्बम, कलाकार, शैली और प्लेलिस्ट कवर डाउनलोड किए जाएंगे।';

  @override
  String get showProgressOnNowPlayingBarTitle => 'इन-ऐप मिनीप्लेयर पर ट्रैक प्रगति दिखाएं';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'यह नियंत्रित करता है कि संगीत स्क्रीन के नीचे स्थित इन-ऐप मिनी प्लेयर / Now Playing बार प्रगति बार के रूप में कार्य करता है या नहीं।';

  @override
  String get lyricsScreen => 'बोल दृश्यता';

  @override
  String get showLyricsTimestampsTitle => 'सिंक्रोनाइज्ड बोल के लिए टाइमस्टैम्प दिखाएं';

  @override
  String get showLyricsTimestampsSubtitle => 'यदि उपलब्ध हो तो यह नियंत्रित करता है कि प्रत्येक बोल पंक्ति का टाइमस्टैम्प बोल दृश्य में दिखाया जाए या नहीं।';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'मीडिया नोटिफिकेशन पर स्टॉप बटन दिखाएं';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'यह नियंत्रित करता है कि मीडिया नोटिफिकेशन में पॉज़ बटन के अलावा स्टॉप बटन है या नहीं। इससे आप ऐप खोले बिना प्लेबैक रोक सकते हैं।';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'मीडिया नोटिफिकेशन पर सीक नियंत्रण (Seek Control) दिखाएं';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'यह नियंत्रित करता है कि मीडिया नोटिफिकेशन में सीक किए जाने योग्य प्रगति बार है या नहीं। यह आपको ऐप खोले बिना प्लेबैक स्थिति बदलने देता है।';

  @override
  String get alignmentOptionStart => 'बाएं';

  @override
  String get alignmentOptionCenter => 'बीच में';

  @override
  String get alignmentOptionEnd => 'दाएं';

  @override
  String get fontSizeOptionSmall => 'छोटा';

  @override
  String get fontSizeOptionMedium => 'मीडियम';

  @override
  String get fontSizeOptionLarge => 'बड़ा';

  @override
  String get lyricsAlignmentTitle => 'बोल एलाइनमेंट';

  @override
  String get lyricsAlignmentSubtitle => 'बोल दृश्य में बोल एलाइनमेंट को नियंत्रित करता है।';

  @override
  String get lyricsFontSizeTitle => 'बोल फ़ॉन्ट आकार';

  @override
  String get lyricsFontSizeSubtitle => 'बोल दृश्य में बोल के फ़ॉन्ट आकार को नियंत्रित करता है।';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'बोल से पहले एल्बम दिखाएं';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'यह नियंत्रित करता है कि एल्बम कवर को स्क्रॉल किए जाने से पहले बोल के ऊपर दिखाया जाए या नहीं।';

  @override
  String get keepScreenOn => 'स्क्रीन सक्रिय रखें';

  @override
  String get keepScreenOnSubtitle => 'स्क्रीन कब चालू रखें';

  @override
  String get keepScreenOnDisabled => 'असक्षम';

  @override
  String get keepScreenOnAlwaysOn => 'हमेशा सक्रिय';

  @override
  String get keepScreenOnWhilePlaying => 'संगीत चलने के दौरान';

  @override
  String get keepScreenOnWhileLyrics => 'बोल दिखाने के दौरान';

  @override
  String get keepScreenOnWhilePluggedIn => 'स्क्रीन को केवल प्लग इन होने पर ही सक्रिय रखें';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'यदि डिवाइस अनप्लग है तो स्क्रीन सक्रिय रखें सेटिंग को अनदेखा करें';

  @override
  String get genericToggleButtonTooltip => 'टॉगल करने के लिए टैप करें।';

  @override
  String get artwork => 'कलाकृति';

  @override
  String artworkTooltip(String title) {
    return '$title के लिए कलाकृति';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return '$title के लिए कलाकृति। प्लेबैक टॉगल करने के लिए टैप करें। ट्रैक स्विच करने के लिए बाएं या दाएं स्वाइप करें।';
  }

  @override
  String get nowPlayingBarTooltip => 'प्लेयर स्क्रीन खोलें';

  @override
  String get additionalPeople => 'लोग';

  @override
  String get playbackMode => 'प्लेबैक मोड';

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
  String get showFeatureChipsToggleTitle => 'एडवांस्ड ट्रैक जानकारी दिखाएं';

  @override
  String get showFeatureChipsToggleSubtitle => 'प्लेयर स्क्रीन पर codec, bitrate, आदि जैसी एडवांस्ड ट्रैक जानकारी दिखाएं।';

  @override
  String get albumScreen => 'एल्बम स्क्रीन';

  @override
  String get showCoversOnAlbumScreenTitle => 'ट्रैक पर एल्बम कवर दिखाएं';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'एल्बम स्क्रीन पर प्रत्येक ट्रैक के लिए अलग से एल्बम कवर दिखाएं।';

  @override
  String get emptyTopTracksList => 'आपने अभी तक इस कलाकार का कोई ट्रैक नहीं सुना है।';

  @override
  String get emptyFilteredListTitle => 'कोई आइटम नहीं मिला';

  @override
  String get emptyFilteredListSubtitle => 'कोई भी आइटम फ़िल्टर से मेल नहीं खाता। फ़िल्टर बंद करें या खोज शब्द बदलें।';

  @override
  String get resetFiltersButton => 'रीसेट फ़िल्टर';

  @override
  String get resetSettingsPromptGlobal => 'क्या आपको यकीन है कि आप सभी सेटिंग्स को उनके डिफ़ॉल्ट रूप में रीसेट करना चाहते हैं?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'सभी सेटिंग्स रीसेट करें';

  @override
  String get resetSettingsPromptLocal => 'क्या आप इन सेटिंग्स को वापस अपने डिफ़ॉल्ट रूप में बदलना चाहते हैं?';

  @override
  String get genericCancel => 'रद्द करें';

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
  String get allowDeleteFromServerTitle => 'सर्वर से मिटाने की अनुमति दें';

  @override
  String get allowDeleteFromServerSubtitle => 'जब मिटाना संभव हो तो सर्वर फ़ाइल सिस्टम से ट्रैक को स्थायी रूप से मिटाने के विकल्प को सक्षम और अक्षम करें।';

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
    return 'मिटाएं $_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'चेतावनी: आप $count ट्रैक डाउनलोड करने वाले हैं।';
  }

  @override
  String get downloadSizeWarningCutoff => 'डाउनलोड साइज़ चेतावनी कटऑफ';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'एक बार में इससे अधिक ट्रैक डाउनलोड करने पर एक चेतावनी संदेश प्रदर्शित होगा।';

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
    return 'क्या आप वाकई $_temp0 \'$itemName\' से सभी ट्रैक इस प्लेलिस्ट में जोड़ना चाहते हैं? उन्हें केवल एक-एक करके ही हटाया जा सकता है।';
  }

  @override
  String get publiclyVisiblePlaylist => 'सार्वजनिक रूप से दृश्यमान:';

  @override
  String get releaseDateFormatYear => 'साल';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'महीना और साल';

  @override
  String get releaseDateFormatMonthDayYear => 'महीना, तिथि और साल';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'प्लेयर स्क्रीन पर एल्बम रिलीज़ की तिथि दिखाएँ';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'एल्बम के नाम के पीछे, प्लेयर स्क्रीन पर एल्बम की रिलीज़ तिथि दिखाएँ।';

  @override
  String get releaseDateFormatTitle => 'रिलीज दिनांक फॉर्मेट';

  @override
  String get releaseDateFormatSubtitle => 'ऐप में दिखाए गए सभी रिलीज़ दिनांकों के फॉर्मेट को नियंत्रित करता है।';

  @override
  String get librarySelectError => 'Error loading available libraries for user';
}
