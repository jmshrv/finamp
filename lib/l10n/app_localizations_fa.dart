// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get finamp => 'فین‌امپ';

  @override
  String get finampTagline => 'یک پخش‌کننده آهنگ جلی‌فین متن‌باز';

  @override
  String startupError(String error) {
    return 'مشکلی حین راه اندازی نرم‌افزار رخ داد. مشکل رخ داده: $error\n\nلطفاً یک مسأله روی github.com/UnicornsOnLSD/finamp به همراه تصویری از صفحه ایجاد کنید. اگر این مشکل ادامه‌دار است، می‌توانید داده‌ی نرم‌افزارتان را پاک کنید تا نرم‌افزار را بازنشانی شود.';
  }

  @override
  String get about => 'درباره‌ی فین‌امپ';

  @override
  String get aboutContributionPrompt => 'ساخته‌ی افراد خفن و باحال در اوقات فراغتشان.\nشما هم می‌توانید یکی از آن‌ها باشید!';

  @override
  String get aboutContributionLink => 'در فین‌امپ روی گیت‌هاب مشارکت کنید:';

  @override
  String get aboutReleaseNotes => 'واپسین یادداشت عرضه را بخوانید:';

  @override
  String get aboutTranslations => 'فین‌امپ را در ترجمه به زبان خود یاری کنید:';

  @override
  String get aboutThanks => 'از این‌که از فین‌امپ استفاده می‌کنید، سپاسگزاریم!';

  @override
  String get loginFlowWelcomeHeading => 'خوش آمدید به';

  @override
  String get loginFlowSlogan => 'آهنگ شما، به همان شیوه که می‌خواهید.';

  @override
  String get loginFlowGetStarted => 'آغاز کنید!';

  @override
  String get viewLogs => 'دیدن رخدادها';

  @override
  String get changeLanguage => 'تغییر زبان';

  @override
  String get loginFlowServerSelectionHeading => 'به Jellyfin وصل شوید';

  @override
  String get back => 'برگشت';

  @override
  String get serverUrl => 'آدرس سرور';

  @override
  String get internalExternalIpExplanation => 'اگر می‌خواهید که از دور به سرور Jellyfin دسترسی داشته باشید، باید از IP خارجی خود استفاده کنید.\n\nاگر سرورتان روی درگاه پیش‌فرض HTTP (درگاه 80 یا 443) یا درگاه پیش‌فرض Jellyfin (درگاه 8096) روشن است، می‌توانید درگاه را مشخص نکنید.\n\nاگر آدرس درست است، باید اطلاعاتی از سرورتان زیر فیلد آشکار شود.';

  @override
  String get serverUrlHint => 'برای نمونه demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'راهنمای آدرس سرور';

  @override
  String get emptyServerUrl => 'آدرس سرور نمی‌تواند خالی باشد';

  @override
  String get connectingToServer => 'درحال اتصال به سرور...';

  @override
  String get loginFlowLocalNetworkServers => 'سرورهای شبکه محلی شما:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'پیمایش برای سرورها...';

  @override
  String get loginFlowAccountSelectionHeading => 'حساب کاربری خود را انتخاب کنید';

  @override
  String get backToServerSelection => 'برگشت به گزینش سرور';

  @override
  String get loginFlowNamelessUser => 'کاربر بی‌نام';

  @override
  String get loginFlowCustomUser => 'کاربر سفارشی';

  @override
  String get loginFlowAuthenticationHeading => 'به حساب کاربری خود وارد شوید';

  @override
  String get backToAccountSelection => 'برگشت به گزینش حساب کاربری';

  @override
  String get loginFlowQuickConnectPrompt => 'استفاده کردن از کد اتصال سریع';

  @override
  String get loginFlowQuickConnectInstructions => 'نرم‌افزار یا وبگاه Jellyfin را باز کنید، روی تصویر کاربرتان کلیک کنید و اتصال سریع را انتخاب کنید.';

  @override
  String get loginFlowQuickConnectDisabled => 'اتصال سریع روی این سرور غیرفعال است.';

  @override
  String get orDivider => 'یا';

  @override
  String get loginFlowSelectAUser => 'یک کاربر انتخاب کنید';

  @override
  String get username => 'نام کاربری';

  @override
  String get usernameHint => 'نام کاربری خود را وارد کنید';

  @override
  String get usernameValidationMissingUsername => 'لطفاً یک نام کاربری انتخاب کنید';

  @override
  String get password => 'رمزعبور';

  @override
  String get passwordHint => 'رمزعبور خود را وارد کنید';

  @override
  String get login => 'ورود';

  @override
  String get logs => 'رخدادها';

  @override
  String get next => 'بعدی';

  @override
  String get selectMusicLibraries => 'کتابخانه‌های موسیقی را انتخاب کنید';

  @override
  String get couldNotFindLibraries => 'کتابخانه‌ای یافت نشد.';

  @override
  String get unknownName => 'نام ناشناخته';

  @override
  String get tracks => 'قطعه‌ها';

  @override
  String get albums => 'آلبوم‌ها';

  @override
  String get artists => 'هنرمندان';

  @override
  String get genres => 'ژانرها';

  @override
  String get playlists => 'فهرست‌های پخش';

  @override
  String get startMix => 'آغاز میکس';

  @override
  String get startMixNoTracksArtist => 'روی یک هنرمند لمس خود را نگه دارید تا از میکس‌ساز قبل از آغاز کردن میکس اضافه یا حذف شود';

  @override
  String get startMixNoTracksAlbum => 'روی یک آلبوم لمس خود را نگه دارید تا از میکس‌ساز قبل از آغاز کردن میکس اضافه یا حذف شود';

  @override
  String get startMixNoTracksGenre => 'روی یک ژانر لمس خود را نگه دارید تا از میکس‌ساز قبل از آغاز کردن میکس اضافه یا حذف شود';

  @override
  String get music => 'آهنگ';

  @override
  String get clear => 'پاک کردن';

  @override
  String get favourites => 'مورد علاقه‌ها';

  @override
  String get shuffleAll => 'بُر زدن همه';

  @override
  String get downloads => 'بارگیری‌ها';

  @override
  String get settings => 'پیکربندی';

  @override
  String get offlineMode => 'حالت آفلاین';

  @override
  String get sortOrder => 'ترتیب مرتب سازی';

  @override
  String get sortBy => 'مرتب سازی بر اساس';

  @override
  String get title => 'عنوان';

  @override
  String get album => 'آلبوم';

  @override
  String get albumArtist => 'هنرمند آلبوم';

  @override
  String get artist => 'هنرمند';

  @override
  String get budget => 'بودجه';

  @override
  String get communityRating => 'امتیاز جامعه';

  @override
  String get criticRating => 'امتیاز منتقدین';

  @override
  String get dateAdded => 'تاریخ اضافه شدن';

  @override
  String get datePlayed => 'تاریخ پخش شده';

  @override
  String get playCount => 'تعداد پخش';

  @override
  String get premiereDate => 'تاریخ رونمایی';

  @override
  String get productionYear => 'تاریخ تولید';

  @override
  String get name => 'نام';

  @override
  String get random => 'تصادفی';

  @override
  String get revenue => 'درآمد';

  @override
  String get runtime => 'مدت زمان';

  @override
  String get syncDownloadedPlaylists => 'همگام‌سازی فهرست پخش بارگیری شده';

  @override
  String get downloadMissingImages => 'بارگیری نگاره‌های از قلم افتاده';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نگاره‌های از قلم افتاده بارگیری شد',
      one: '$count نگاره‌ی از قلم افتاده بارگیری شد',
      zero: 'نگاره‌ی مفقودی پیدا نشد',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'بارگیری‌های فعال';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بارگیری‌ها',
      one: '$count بارگیری',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount قطعه',
      one: '$trackCount قطعه',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount نگاره',
      one: '$imageCount نگاره',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount گره در حال همگام شدن',
      one: '$syncCount گره در حال همگام شدن',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nهم‌اکنون در حال تعمیر',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count پایان یافته';
  }

  @override
  String dlFailed(int count) {
    return '$count معیوب';
  }

  @override
  String dlEnqueued(int count) {
    return '$count به صف شده';
  }

  @override
  String dlRunning(int count) {
    return '$count جاری';
  }

  @override
  String get activeDownloadsTitle => 'بارگیری‌های فعال';

  @override
  String get noActiveDownloads => 'هیچ بارگیری‌ای فعال نیست.';

  @override
  String get errorScreenError => 'یک مشکل به هنگام دریافت فهرست مشکلات رخ داد! در این وضعیت، شاید که ساخت مسأله‌ای در گیت‌هاب و پاک کردن داده‌ی نرم‌افزار به صلاح باشد';

  @override
  String get failedToGetTrackFromDownloadId => 'در گرفتن قطعه از ID بارگیری ناکام ماندیم';

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
  String get deleteDownloadsConfirmButtonText => 'حذف';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'خطا';

  @override
  String discNumber(int number) {
    return 'دیسک $number';
  }

  @override
  String get playButtonLabel => 'پخش';

  @override
  String get shuffleButtonLabel => 'بُر زدن';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعه',
      one: '$count قطعه',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعه',
      one: '$count قطعه',
    );
    return '$_temp0, $downloads بارگیری شد';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعه',
      one: '$count قطعه',
    );
    return '$_temp0 بارگیری شد';
  }

  @override
  String get editPlaylistNameTooltip => 'ویرایش نام فهرست پخش';

  @override
  String get editPlaylistNameTitle => 'ویرایش نام فهرست پخش';

  @override
  String get required => 'الزامی';

  @override
  String get updateButtonLabel => 'بروزرسانی';

  @override
  String get playlistNameUpdated => 'نام فهرست پخش بروزرسانی شد.';

  @override
  String get favourite => 'مورد علاقه';

  @override
  String get downloadsDeleted => 'بارگیری‌ها پاک شدند.';

  @override
  String get addDownloads => 'افزودن بارگیری‌ها';

  @override
  String get location => 'مکان';

  @override
  String get confirmDownloadStarted => 'بارگیری آغاز شد';

  @override
  String get downloadsQueued => 'بارگیری آماده شد، در حال بارگیری فایل‌ها';

  @override
  String get addButtonLabel => 'افزودن';

  @override
  String get shareLogs => 'اشتراک گذاری رخدادها';

  @override
  String get logsCopied => 'رخدادها کپی شدند.';

  @override
  String get message => 'پیام';

  @override
  String get stackTrace => 'ردیابی پشته (Stack Trace)';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'پروانه شده با پروانه‌ی عمومی موزیلا 2.0.\nکد منبع در $sourceCodeLink در دسترس است.';
  }

  @override
  String get transcoding => 'رمزگردانی (transcoding)';

  @override
  String get downloadLocations => 'مکان‌های بارگیری';

  @override
  String get audioService => 'سرویس صدا';

  @override
  String get interactions => 'برهم کنش';

  @override
  String get layoutAndTheme => 'طرح‌بندی و تم';

  @override
  String get notAvailableInOfflineMode => 'در حالت آفلاین در دسترس نیست';

  @override
  String get logOut => 'خروج';

  @override
  String get downloadedTracksWillNotBeDeleted => 'قطعه‌های بارگیری شده پاک نخواهند شد';

  @override
  String get areYouSure => 'آیا مطمئن هستید؟';

  @override
  String get jellyfinUsesAACForTranscoding => 'جلی‌فین از AAC برای رمزگردانی (transcoding) استفاده می‌کند';

  @override
  String get enableTranscoding => 'فعال‌سازی رمزگردانی (transcoding)';

  @override
  String get enableTranscodingSubtitle => 'آهنگ را سمت سرور رمزگردانی می‌کند.';

  @override
  String get bitrate => 'نرخ انتقال';

  @override
  String get bitrateSubtitle => 'نرخ انتقال بالاتر کیفیت صدای بهتری در قبال پهنای باند بیشتر می‌دهد.';

  @override
  String get customLocation => 'مکان سفارشی';

  @override
  String get appDirectory => 'پوشه نرم‌افزار';

  @override
  String get addDownloadLocation => 'افزودن مکان بارگیری';

  @override
  String get selectDirectory => 'پوشه را انتخاب کنید';

  @override
  String get unknownError => 'مشکل ناشناخته';

  @override
  String get pathReturnSlashErrorMessage => 'آدرس‌هایی که \"/\" را برمی‌گردانند قابل استفاده نیستند';

  @override
  String get directoryMustBeEmpty => 'پوشه باید خالی باشد';

  @override
  String get customLocationsBuggy => 'مکان‌های سفارشی ممکن است بسیار مشکل آفرین باشند و در اکثر مواقع پیشنهاد نمی‌شوند. مکان‌های زیر پوشه‌ی \"موسیقی\" سیستم از ذخیره کردن نگاره‌های آلبوم به دلیل محدودیت‌های سیستم‌عامل جلوگیری می‌کند.';

  @override
  String get enterLowPriorityStateOnPause => 'ورود به حالت کم اهمیت به هنگام توقف';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'در توقف پخش به اعلان اجازه‌ی رد شدن می‌دهد. همچنین به اندروید اجازه می‌دهد تا در توقف پخش به سرویس پایان دهد.';

  @override
  String get shuffleAllTrackCount => 'بُر زدن همه‌ی تعداد قطعه';

  @override
  String get shuffleAllTrackCountSubtitle => 'تعداد قطعه‌ها برای بارگذاری زمانی که دکمه‌ی بُر زدن همه‌ی قطعه‌ها استفاده می‌شود.';

  @override
  String get viewType => 'نوع نما';

  @override
  String get viewTypeSubtitle => 'نوع نما برای صفحه‌ی آهنگ';

  @override
  String get list => 'فهرست';

  @override
  String get grid => 'جدول';

  @override
  String get customizationSettingsTitle => 'شخصی‌سازی';

  @override
  String get playbackSpeedControlSetting => 'نمایش تندی پخش';

  @override
  String get playbackSpeedControlSettingSubtitle => 'اینکه واپایش تندی پخش در منوی صفحه‌ی پخش نمایش داده شود یا نه';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'خودکار:\nفین‌امپ تلاش می‌کند تا مشخص کند قطعه‌ای که شما در حال پخش کردن هستید پادپخش (پادکست) است یا کتاب صوتی. این مورد زمانی در نظر گرفته می‌شود که قطعه از $trackDuration دقیقه بیشتر باشد، یا قطعه از $albumDuration ساعت بیشتر باشد، یا به قطعه دست کم یکی از این ژانرها اختصاص داده شده باشد:‌$genreList\nسپس واپایش‌های تندی پخش در منوی صفحه‌ی پخش نشان داده می‌شوند.\n\nنشان داده شده:\nواپایش‌های تندی پخش همیشه در منوی صفحه‌ی پخش نشان داده می‌شوند\n\nپنهان:\nواپایش‌های تندی پخش در منوی صفحه‌ی پخش همیشه پنهان باشند.';
  }

  @override
  String get automatic => 'خودکار';

  @override
  String get shown => 'نشان داده شده';

  @override
  String get hidden => 'پنهان';

  @override
  String get speed => 'تندی';

  @override
  String get reset => 'بازنشانی';

  @override
  String get apply => 'اعمال کردن';

  @override
  String get portrait => 'عمودی';

  @override
  String get landscape => 'افقی';

  @override
  String gridCrossAxisCount(String value) {
    return '$value تعداد محور افقی جدول';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'اندازه‌ای از کاشی‌های جدول که به ازای هر ردیف استفاده می‌شوند زمانی که $value باشد.';
  }

  @override
  String get showTextOnGridView => 'نشان دادن متن در نمایش جدولی';

  @override
  String get showTextOnGridViewSubtitle => 'اینکه متن (عنوان، هنرمند و ...) روی صفحه‌ی جدولی آهنگ نمایش داده شود یا نه.';

  @override
  String get useCoverAsBackground => 'از جلد مبهم شده به عنوان پس‌زمینه استفاده شود';

  @override
  String get useCoverAsBackgroundSubtitle => 'اینکه از جلد آلبوم مبهم شده به عنوان پس‌زمینه در بخش های مختلف نرم‌افزار استفاده شود یا نه.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'حداقل فاصله‌ی درونی جلد آلبوم';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'حداقل فاصله‌ی درونی دور جلد آلبوم روی صفحه‌ی پخش، درصد عرض صفحه.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'پنهان کردن هنرمندان قطعه اگر با هنرمندان آلبوم یکی بودند';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'اینکه هنرمندان قطعه روی صفحه‌ی آلبوم اگر با هنرمندان آلبوم تفاوتی نداشتند نمایش داده شوند یا نه.';

  @override
  String get showArtistsTopTracks => 'نشان دادن قطعه‌های برتر در نمایش هنرمند';

  @override
  String get showArtistsTopTracksSubtitle => 'اینکه ۵ قطعه‌ی برتر هنرمند نمایش داده شود یا نه.';

  @override
  String get disableGesture => 'غیرفعال کردن حرکات لمسی';

  @override
  String get disableGestureSubtitle => 'اینکه حرکت لمسی غیرفعال باشند یا نه.';

  @override
  String get showFastScroller => 'نشان دادن اسکرول کننده سریع';

  @override
  String get theme => 'تم';

  @override
  String get system => 'سیستم';

  @override
  String get light => 'روز';

  @override
  String get dark => 'شب';

  @override
  String get tabs => 'سربرگ‌ها';

  @override
  String get playerScreen => 'صفحه‌ی پخش';

  @override
  String get cancelSleepTimer => 'لغو زمان‌سنج خواب؟';

  @override
  String get yesButtonLabel => 'آره';

  @override
  String get noButtonLabel => 'نه';

  @override
  String get setSleepTimer => 'تنظیم زمان‌سنج خواب';

  @override
  String get hours => 'ساعت';

  @override
  String get seconds => 'ثانیه';

  @override
  String get minutes => 'دقیقه';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime از $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'قطعه‌ی $currentTrackIndex از $totalTrackCount';
  }

  @override
  String get invalidNumber => 'شماره‌ی غیر قابل قبول';

  @override
  String get sleepTimerTooltip => 'زمان‌سنج خواب';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'خوابیدن در $time دقیقه';
  }

  @override
  String get addToPlaylistTooltip => 'افزودن به فهرست پخش';

  @override
  String get addToPlaylistTitle => 'افزودن به فهرست پخش';

  @override
  String get addToMorePlaylistsTooltip => 'افزودن به فهرست‌های پخش بیشتر';

  @override
  String get addToMorePlaylistsTitle => 'افزودن به فهرست پخش‌های بیشتر';

  @override
  String get removeFromPlaylistTooltip => 'حذف از این فهرست پخش';

  @override
  String get removeFromPlaylistTitle => 'حذف از این فهرست پخش';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'حذف از فهرست پخش \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'حذف از فهرست پخش \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'فهرست پخش جدید';

  @override
  String get createButtonLabel => 'ساختن';

  @override
  String get playlistCreated => 'فهرست پخش ساخته شد.';

  @override
  String get playlistActionsMenuButtonTooltip => 'برای افزودن به فهرست پخش لمس کنید. برای تغییر وضعیت علاقه نگه دارید.';

  @override
  String get noAlbum => 'هیچ آلبومی نیست';

  @override
  String get noItem => 'هیچ آیتمی نیست';

  @override
  String get noArtist => 'هیچ هنرمندی نیست';

  @override
  String get unknownArtist => 'هنرمند ناشناخته';

  @override
  String get unknownAlbum => 'آلبوم ناشناخته';

  @override
  String get playbackModeDirectPlaying => 'پخش مستقیم';

  @override
  String get playbackModeTranscoding => 'درحال رمزگردانی';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate ک.بیت بر ثانیه';
  }

  @override
  String get playbackModeLocal => 'پخش محلی';

  @override
  String get queue => 'صف';

  @override
  String get addToQueue => 'افزودن به صف';

  @override
  String get replaceQueue => 'جایگزینی صف';

  @override
  String get instantMix => 'میکس آنی';

  @override
  String get goToAlbum => 'رفتن به آلبوم';

  @override
  String get goToArtist => 'رفتن به صفحه‌ی هنرمند';

  @override
  String get goToGenre => 'رفتن به ژانر';

  @override
  String get removeFavourite => 'حذف مورد علاقه';

  @override
  String get addFavourite => 'افزودن مورد علاقه';

  @override
  String get confirmFavoriteAdded => 'مورد علاقه افزوده شد';

  @override
  String get confirmFavoriteRemoved => 'مورد علاقه حذف شد';

  @override
  String get addedToQueue => 'به صف افزوده شد.';

  @override
  String get insertedIntoQueue => 'در صف قرار گرفت.';

  @override
  String get queueReplaced => 'صف جایگزین شد.';

  @override
  String get confirmAddedToPlaylist => 'به فهرست پخش اضافه شد.';

  @override
  String get removedFromPlaylist => 'از فهرست پخش حذف شد.';

  @override
  String get startingInstantMix => 'در حال آغاز میکس آنی.';

  @override
  String get anErrorHasOccured => 'خطایی رخ داد.';

  @override
  String responseError(String error, int statusCode) {
    return '$error کد وضعیت $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error کد وضعیت $statusCode. احتمالاً بدان معناست که شما نام کاربری/رمزعبور اشتباهی را وارد کرده‌اید یا سرویس گیرنده دیگر وارد نیست.';
  }

  @override
  String get removeFromMix => 'حذف از میکس';

  @override
  String get addToMix => 'افزودن به میکس';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آیتم مجدد بارگیری شد',
      one: '$count آیتم مجدد بارگیری شد',
      zero: '.بارگیری مجددی نیاز نیست',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'مدت زمان بافر';

  @override
  String get bufferDurationSubtitle => 'بیشینه‌ی زمانی که باید بافر شود، به ثانیه. راه‌اندازی مجدد نیاز دارد.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'اندازه‌ی بافر را محدود نکن';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'ثابت‌های اندازه‌ی بافر (\"‌اندازه‌ی بافر\") را غیرفعال می‌کند. بافر همیشه به اندازه‌ی بافر پیکربندی شده (\'اندازه‌ی بافر\') بارگذاری خواهد شد، حتی برای پرونده‌های بسیار بزرگ. می‌تواند موجب خرابی شود. نیازمند راه‌اندازی مجدد است.';

  @override
  String get bufferSizeTitle => 'اندازه‌ی بافر';

  @override
  String get bufferSizeSubtitle => 'بیشینه‌ی اندازه‌ی بافر به مگابایت. نیازمند راه‌اندازی مجدد است';

  @override
  String get language => 'زبان';

  @override
  String get skipToPreviousTrackButtonTooltip => 'پرش به آغاز یا به قطعه‌ی قبلی';

  @override
  String get skipToNextTrackButtonTooltip => 'پرش به قطعه‌ی بعدی';

  @override
  String get togglePlaybackButtonTooltip => 'تنظیم پخش';

  @override
  String get previousTracks => 'قطعه‌های قبلی';

  @override
  String get nextUp => 'مورد بعدی';

  @override
  String get clearNextUp => 'پاک کردن مورد بعدی';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'در حال پخش از';

  @override
  String get playNext => 'پخش کردن بعدی';

  @override
  String get addToNextUp => 'افزودن به مورد بعدی';

  @override
  String get shuffleNext => 'بُر زدن بعدی';

  @override
  String get shuffleToNextUp => 'بُر زدن و سپس افزودن به موارد بعدی';

  @override
  String get shuffleToQueue => 'بُر زدن و سپس افزودن به صف';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'قطعه',
        'album': 'آلبوم',
        'artist': 'هنرمند',
        'playlist': 'فهرست پخش',
        'genre': 'ژانر',
        'other': 'آیتم',
      },
    );
    return 'بعدی $_temp0 پخش خواهد شد';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'قطعه',
        'album': 'آلبوم',
        'artist': 'هنرمند',
        'playlist': 'فهرست پخش',
        'genre': 'ژانر',
        'other': 'آیتم',
      },
    );
    return '$_temp0 به موارد بعدی افزوده شد';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'قطعه',
        'album': 'آلبوم',
        'artist': 'هنرمند',
        'playlist': 'فهرست پخش',
        'genre': 'ژانر',
        'other': 'آیتم',
      },
    );
    return '$_temp0 به صف افزوده شد';
  }

  @override
  String get confirmShuffleNext => 'بعدی بُر زده خواهد شد';

  @override
  String get confirmShuffleToNextUp => 'بُر زده و به موارد بعدی افزوده شد';

  @override
  String get confirmShuffleToQueue => 'بُر زده و به صف افزوده شد';

  @override
  String get placeholderSource => 'یه جایی';

  @override
  String get playbackHistory => 'تاریخچه‌ی پخش';

  @override
  String get shareOfflineListens => 'اشتراک گذاری شنیده شده‌ها به صورت آفلاین';

  @override
  String get yourLikes => 'مورد علاقه‌های شما';

  @override
  String mix(String mixSource) {
    return '$mixSource - میکس';
  }

  @override
  String get tracksFormerNextUp => 'قطعه‌های افزوده شده با «موارد بعدی»';

  @override
  String get savedQueue => 'صف ذخیره شد';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'آلبوم',
        'playlist': 'فهرست پخش',
        'trackMix': 'میکس قطعه',
        'artistMix': 'میکس هنرمند',
        'albumMix': 'میکس آلبوم',
        'genreMix': 'میکس ژانر',
        'favorites': 'مورد علاقه‌ها',
        'allTracks': 'همه‌ی قطعه‌ها',
        'filteredList': 'قطعه‌ها',
        'genre': 'ژانر',
        'artist': 'هنرمند',
        'track': 'قطعه',
        'nextUpAlbum': 'آلبوم در «مورد بعدی»',
        'nextUpPlaylist': 'فهرست پخش در «مورد بعدی»',
        'nextUpArtist': 'هنرمند در «مورد بعدی»',
        'other': '',
      },
    );
    return 'در حال پخش از $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'بُر زدن همه';

  @override
  String get playbackOrderLinearButtonLabel => 'پخش به ترتیب';

  @override
  String get playbackOrderLinearButtonTooltip => 'در حال پخش به ترتیب. برای بُر زدن لمس کنید.';

  @override
  String get playbackOrderShuffledButtonLabel => 'در حال بُر زدن قطعه‌ها';

  @override
  String get playbackOrderShuffledButtonTooltip => 'در حال بُر زدن قطعه‌ها. برای پخش به ترتیب لمس کنید.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'در حال پخش با تندی ${speed}x';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'تندی ${speed}x';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'کاهش تندی پخش';

  @override
  String get playbackSpeedIncreaseLabel => 'افزایش تندی پخش';

  @override
  String get loopModeNoneButtonLabel => 'تکرار غیرفعال است';

  @override
  String get loopModeOneButtonLabel => 'در حال تکرار این قطعه';

  @override
  String get loopModeAllButtonLabel => 'در حال تکرار همه';

  @override
  String get queuesScreen => 'بازگردانی پخش کنونی';

  @override
  String get queueRestoreButtonLabel => 'بازگردانی';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString ذخیره شد';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'در حال پخش: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعه',
      one: '1 قطعه',
    );
    return '$_temp0, $remaining پخش نشده';
  }

  @override
  String get queueLoadingMessage => 'در حال بازگردانی صف...';

  @override
  String get queueRetryMessage => 'در بازگردانی صف ناکام ماندیم. دوباره تلاش کنیم؟';

  @override
  String get autoloadLastQueueOnStartup => 'بازگردانی خودکار واپسین صف';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'تلاش برای بازگردانی واپسین صف پخش شده پس از شروع برنامه.';

  @override
  String get reportQueueToServer => 'صف فعلی به سرور گزارش شود؟';

  @override
  String get reportQueueToServerSubtitle => 'اگر فعال شود، فین‌امپ صف کنونی را به سرور می‌فرستد. اکنون کاربرد خاصی برای این وجود ندارد و فقط شدآمد (traffic) شبکه را افزایش می‌دهد.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'فرکانس بروزرسانی نشست پخش';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'هر چند وقت وضعیت پخش کنونی به سرور فرستاده شود، به ثانیه. به خاطر اینکه از خروج نشست جلوگیری شود، این باید کمتر از ۵ دقیقه (۳۰۰ ثانیه) باشد.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'اگر سرور جلی‌فین (Jellyfin) بروزرسانی‌ای از سرویس گیرنده در ۵ دقیقه دریافت نکند، می‌پندارد که پخش پایان یافته‌است. این بدان معناست که برای قطعه‌های بلندتر از ۵ دقیقه، پخش آن می‌تواند اشتباهاً به عنوان پایان یافته گزارش شود، که منجر به کاهش کیفیت داده‌ی گزارش پخش (Playback Reporting Data) می‌شود.';

  @override
  String get topTracks => 'قطعه‌های برتر';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آلبوم',
      one: '$count آلبوم',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'بُر زدن آلبوم‌ها';

  @override
  String get shuffleAlbumsNext => 'بُر زدن آلبوم‌ها و افزودن آن به آغاز بعدی';

  @override
  String get shuffleAlbumsToNextUp => 'بُر زدن آلبوم‌ها و افزودن آن‌ها به پایان بعدی';

  @override
  String get shuffleAlbumsToQueue => 'بُر زدن آلبوم‌ها و افزودن آن‌ها به صف';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount بار پخش شده',
      one: '$playCount بار پخش شده',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'آلبوم',
        'playlist': 'فهرست پخش',
        'trackMix': 'میکس قطعه',
        'artistMix': 'میکس هنرمند',
        'albumMix': 'میکس آلبوم',
        'genreMix': 'میکس ژانر',
        'favorites': 'مورد علاقه‌ها',
        'allTracks': 'همه‌ی قطعه‌ها',
        'filteredList': 'قطعه‌ها',
        'genre': 'ژانر',
        'artist': 'هنرمند',
        'track': 'قطعه',
        'nextUpAlbum': 'آلبوم بعدی',
        'nextUpPlaylist': 'فهرست پخش بعدی',
        'nextUpArtist': 'هنرمند بعدی',
        'other': '',
      },
    );
    return '$_temp0 بارگذاری نشد';
  }

  @override
  String get confirm => 'پذیرش';

  @override
  String get close => 'بستن';

  @override
  String get showUncensoredLogMessage => 'این رخداد شامل اطلاعات ورود شماست. نمایش داده شود؟';

  @override
  String get resetTabs => 'بازنشانی سربرگ‌ها';

  @override
  String get resetToDefaults => 'بازنشانی به پیش‌فرض‌ها';

  @override
  String get noMusicLibrariesTitle => 'هیچ کتاب‌خانه‌ی آهنگی نیست';

  @override
  String get noMusicLibrariesBody => 'فین‌امپ هیچ کتاب‌خانه‌ی آهنگی پیدا نکرد. لطفاً مطمئن شوید که سرور Jellyfin شما دست کم یک کتاب‌خانه با نوع محتوای \"Music\" دارا باشد.';

  @override
  String get refresh => 'دوباره سازی';

  @override
  String get moreInfo => 'اطلاعات بیشتر';

  @override
  String get volumeNormalizationSettingsTitle => 'عادی‌سازی حجم صدا';

  @override
  String get volumeNormalizationSwitchTitle => 'فعال کردن عادی‌سازی حجم صدا';

  @override
  String get volumeNormalizationSwitchSubtitle => 'استفاده از اطلاعات گین (gain) برای عادی‌سازی بلندی صدای قطعه‌ها';

  @override
  String get volumeNormalizationModeSelectorTitle => 'حالت عادی‌سازی حجم صدا';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'چه زمان و چگونه عادی‌سازی حجم صدا به کار بسته شود';

  @override
  String get volumeNormalizationModeSelectorDescription => 'آمیخته (قطعه + آلبوم):\nگین قطعه برای بپخش معمولی به کار گرفته می‌شود. اما اگر آلبومی در حال پخش شدن باشد (شاید چون که خاستگاه صف آغازین است یا زمانی به صف افزوده شده)، از گین آلبوم استفاده می‌شود.\n\nبر پایه‌ی قطعه:\nگین قطعه همیشه به کار برده می‌شود، بدون توجه به این‌که آلبومی در حال پخش است یا نه.\n\nتنها برای آلبوم‌ها:\nعادی‌سازی بلندی صدا فقط برای پخش آلبوم‌ها به کار بسته می‌شود (با استفاده از گین آلبوم) و برای قطعه‌های منفرد نمی‌شود.';

  @override
  String get volumeNormalizationModeHybrid => 'آمیخته (قطعه + آلبوم)';

  @override
  String get volumeNormalizationModeTrackBased => 'بر پایه‌ی قطعه';

  @override
  String get volumeNormalizationModeAlbumBased => 'بر پایه‌ی آلبوم';

  @override
  String get volumeNormalizationModeAlbumOnly => 'تنها برای آلبوم‌ها';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'گین (gain) پایه';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'در حال حاضر، عادی‌سازی بلندی صدا روی iOS نیاز دارد که بلندی پخش را تغییر دهد تا تغییر گین (gain) را شبیه‌سازی کند. از آن‌جا که نمی‌توانیم صدا را بلندتر از ۱۰۰٪ کنیم، باید بلندی را به صورت پیش‌فرض کم کنیم تا بتوانیم صدای قطعه‌های ساکت را بلندتر کنیم. مقدار به دسی‌بل (dB) است که منفی ۱۰ دسی‌بل تقریباً ۳۰٪، منفی ۴.۵ دسی‌بل تقریباً ۶۰٪ و منفی ۲ دسی‌بل تقریباً ۸۰٪ است.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'پخش کردن قطعه‌ی کشیده شده (سوآیپ) به عنوان بعدی';

  @override
  String get swipeInsertQueueNextSubtitle => 'برای نشاندن یک قطعه به عنوان آیتم بعدی در صف زمانی که در لیست قطعه‌ها کشیده می‌شود به جای این‌که به آخر افزوده شود.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'آغاز میکس آنی برای قطعه‌های منفرد';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'زمانی که فعال است، میکس آنی آن قطعه به هنگام لمس پخش می‌شود به جای این‌که تنها یک قطعه تکی پخش شود.';

  @override
  String get downloadItem => 'بارگیری';

  @override
  String get repairComplete => 'تعمیر بارگیری‌ها پایان یافت.';

  @override
  String get syncComplete => 'همه‌ی بارگیری‌ها دوباره همگام شد.';

  @override
  String get syncDownloads => 'همگام‌سازی و بارگیری آیتم‌های از قلم افتاده.';

  @override
  String get repairDownloads => 'تعمیر مشکلات مربوط به فایل‌ها یا فراداده‌های بارگیری شده.';

  @override
  String get requireWifiForDownloads => 'الزام اتصال به WiFi هنگام بارگیری.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعه',
      one: '$count قطعه',
    );
    return 'هشدار: $_temp0 را نمی‌توان به صف بازگردانی کرد.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'بارگیری',
      one: 'بارگیری',
    );
    String _temp1 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'جاری',
        'failed': 'ناکام',
        'syncFailed': 'مکرراً همگام نشده',
        'enqueued': 'به صف شده',
        'other': '',
      },
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'آیا مطمئنید که می‌خواهید همه‌ی محتوای کتاب‌خانه‌ی «$libraryName» را بارگیری کنید؟';
  }

  @override
  String get onlyShowFullyDownloaded => 'تنها آلبوم‌های کامل بارگیری‌شده را نمایش بده';

  @override
  String get filesystemFull => 'بارگیری‌های جامانده را نمی‌توان کامل کرد. سیستم پر است و جا ندارد.';

  @override
  String get connectionInterrupted => 'اتصال بریده شد، درحال متوقف کردن بارگیری‌ها.';

  @override
  String get connectionInterruptedBackground => 'به هنگام بارگیری در پس‌زمینه، اتصال بریده شد. می‌تواند توسط تنظیمات سیستم‌عامل اتفاق افتاده باشد.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'به هنگام بارگیری در پس‌زمینه، اتصال بریده شد. این مشکل می‌تواند از فعال بودن تنظیم «ورود به حالت کم اهمیت به هنگام توقف» یا تنظیمات سیستم‌عامل باشد.';

  @override
  String get activeDownloadSize => 'در حال بارگیری...';

  @override
  String get missingDownloadSize => 'در حال حذف...';

  @override
  String get syncingDownloadSize => 'در حال همگام‌سازی...';

  @override
  String get runRepairWarning => 'ارتباط با سرور صورت نمی‌پذیرد تا انتقال داده‌ها پایان یابد. لطفاً «تعمیر بارگیری‌ها» از صفحه‌ی بارگیری‌ها را هر زمان که برخط شدید اجرا کنید.';

  @override
  String get downloadSettings => 'بارگیری‌ها';

  @override
  String get showNullLibraryItemsTitle => 'نمایش رسانه‌های دارای کتاب‌خانه‌ی ناشناخته.';

  @override
  String get showNullLibraryItemsSubtitle => 'برخی رسانه‌ها ممکن است با کتاب‌خانه‌ای ناشناخته بارگیری شوند. برای پنهان کردن این‌ها خارج از مجموعه اصلی این گزینه را غیرفعال کنید.';

  @override
  String get maxConcurrentDownloads => 'بیشینه بارگیری همزمان';

  @override
  String get maxConcurrentDownloadsSubtitle => 'افزایش بارگیری‌های همزمان ممکن است افزایش بارگیری در پس‌زمینه را اجازه دهد اما شاید برخی بارگیری‌ها را اگر بسیار سنگین باشند، ناکام بگذارد یا در برخی از موارد سبب کندی گزاف شود.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count بارگیری همزمان';
  }

  @override
  String get downloadsWorkersSetting => 'شمار کارکن‌های بارگیری';

  @override
  String get downloadsWorkersSettingSubtitle => 'شمار کارکن‌ها برای همگام‌سازی فراداده و پاک‌سازی بارگیری‌ها. افزایش کارکن‌های بارگیری ممکن است سرعت بارگیری همگام‌سازی یا پاک‌سازی را بالا ببرد، به ویژه زمانی که تأخیر سرور بالاست، اما می‌تواند کندی ایجاد کند.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count کارکن بارگیری';
  }

  @override
  String get syncOnStartupSwitch => 'همگام‌سازی بارگیری‌ها هنگام راه‌اندازی به طور خودکار';

  @override
  String get preferQuickSyncSwitch => 'همگام‌سازی‌های سریع را ترجیح دادن';

  @override
  String get preferQuickSyncSwitchSubtitle => 'زمانی که همگام‌سازی صورت می‌گیرد، بیشتر برخی آیتم‌های راکد (مانند قطعه‌ها و آلبوم‌ها) بروزرسانی نخواند شد. تعمیر بارگیری همواره همگام‌سازی کامل را اجرا می‌کند.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'آلبوم',
        'playlist': 'فهرست پخش',
        'artist': 'هنرمند',
        'genre': 'ژانر',
        'track': 'قطعه',
        'library': 'کتاب‌خانه',
        'unknown': 'آیتم',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'این آیتم نیاز دارد که به دست $parentName بارگیری شود.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'مورد علاقه‌ها',
        'allPlaylists': 'همه‌ی فهرست‌های پخش',
        'fiveLatestAlbums': '۵ آلبوم اخیر',
        'allPlaylistsMetadata': 'فراداده‌ی فهرست پخش',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'نگاره‌های کَش شده برای \'$libraryName\'';
  }

  @override
  String get transcodingStreamingContainerTitle => 'گزینش ظرف رمزگردانی (Transcoding Container)';

  @override
  String get transcodingStreamingContainerSubtitle => 'ظرف سگمنت را انتخاب کنید تا به هنگام پخش لحظه‌ای صدای رمزگردانی شده به کار بسته شود. قطعه‌های به صف شده کنونی تحت تأثیر قرار نمی‌گیرند.';

  @override
  String get downloadTranscodeEnableTitle => 'فعال کردن بارگیری‌های رمزگردانی شده';

  @override
  String get downloadTranscodeCodecTitle => 'گزینش کدک بارگیری';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'همیشه',
        'never': 'هرگز',
        'ask': 'پرسیده شود',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'نرخ انتقال بارگیری';

  @override
  String get downloadBitrateSubtitle => 'نرخ انتقال بالاتر کیفیت صدای بالاتری در قبال فضای ذخیره‌سازی بزرگت‌تر ارائه می‌کند.';

  @override
  String get transcodeHint => 'رمزگردانی؟';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'بارگیری به عنوان $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate رمزگردانی شد',
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
        'other': ' به عنوان $codec @ $bitrate',
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
    return 'بارگیری اصلی$_temp0';
  }

  @override
  String get redownloadcomplete => 'بارگیری دوباره رمزگردانی به صف شد.';

  @override
  String get redownloadTitle => 'بارگیری کردن دوباره خودکار رمزگردانی‌ها';

  @override
  String get redownloadSubtitle => 'به صورت خودکار قطعه‌هایی که انتظار می‌رود در کیفیت متفاوت به دلیل تغییرات مجموعه والد باشند، دوباره بارگیری می‌شوند.';

  @override
  String get defaultDownloadLocationButton => 'به عنوان مکان پیش‌فرض بارگیری قرار می‌گیرد.  غیرفعال کنید تا برای هر بارگیری انتخاب کنید.';

  @override
  String get fixedGridSizeSwitchTitle => 'استفاده از کاشی‌های جدول با اندازه‌های ثابت';

  @override
  String get fixedGridSizeSwitchSubtitle => 'اندازه‌ی کاشی‌های جدول تحت تاثیر اندازه‌ی پنجره/صفحه قرار نمی‌گیرند.';

  @override
  String get fixedGridSizeTitle => 'اندازه‌ی کاشی‌های جدول';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'کوچک',
        'medium': 'میانه',
        'large': 'بزرگ',
        'veryLarge': 'بسیار بزرگ',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'مجاز بودن حالت صفحه نمایش دو بخشی (SplitScreen)';

  @override
  String get allowSplitScreenSubtitle => 'پخش‌کننده کنار نماهای دیگر روی نمایشگرهای عریض نمایش داده می‌شود.';

  @override
  String get enableVibration => 'فعال کردن لرزش';

  @override
  String get enableVibrationSubtitle => 'این‌که لرزش فعال شود یا نه.';

  @override
  String get hideQueueButton => 'دکمه‌ی پنهان کردن صف';

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
  String get hidePlayerBottomActions => 'پنهان کردن عملیات‌های پایین';

  @override
  String get hidePlayerBottomActionsSubtitle => 'دکمه‌های صف و متن شعر روی صفحه‌ی پخش‌کننده را پنهان می‌کند. برای دسترسی به صف به بالا بکشید، برای دیدن متن شعر اگر در دسترس باشد به چپ بکشید (زیر نگاره‌ی آلبوم).';

  @override
  String get prioritizePlayerCover => 'در اولویت قرار دادن نگاره‌ی آلبوم';

  @override
  String get prioritizePlayerCoverSubtitle => 'نمایش نگاره‌ی آلبوم بزرگ‌تر روی صفحه‌ی پخش را در اولویت قرار می‌دهد. واپایش‌های غیر ضروری در صفحه‌های کوجک سهمگین‌تر پنهان می‌شوند.';

  @override
  String get suppressPlayerPadding => 'سرکوب کردن فاصله‌ی واپایش‌های پخش‌کننده';

  @override
  String get suppressPlayerPaddingSubtitle => 'زمانی که نگاره‌ی آلبوم در اندازه‌ی کامل نباشد، فاصله‌ی بین واپایش‌های صفحه پخش را به حداقل می‌رساند.';

  @override
  String get lockDownload => 'همیشه روی دستگاه نگهش دار';

  @override
  String get showArtistChipImage => 'نمایش نگاره‌ی هنرمند به همراه نام هنرمند';

  @override
  String get showArtistChipImageSubtitle => 'این پیش‌نمایش کوچک نگاره‌ی هنرمند را تحت تاثیر قرار می‌دهد،‌ مانند روی صفحه‌ی پخش.';

  @override
  String get scrollToCurrentTrack => 'اسکرول کردن به قطعه کنونی';

  @override
  String get enableAutoScroll => 'فعال کردن اسکرول خودکار';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz کیلوهرتز';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit بیت';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration مانده';
  }

  @override
  String get removeFromPlaylistConfirm => 'حذف';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return '\'$itemName\' از فهرست پخش \'$playlistName\' حذف شود؟';
  }

  @override
  String get trackMenuButtonTooltip => 'منوی قطعه';

  @override
  String get quickActions => 'عملیات‌های آنی';

  @override
  String get addRemoveFromPlaylist => 'افزودن به/حذف از فهرست‌های پخش';

  @override
  String get addPlaylistSubheader => 'افزودن قطعه به یک فهرست پخش';

  @override
  String get trackOfflineFavorites => 'همگام‌سازی وضعیت علایق';

  @override
  String get trackOfflineFavoritesSubtitle => 'اجازه می‌دهد وضعیت علایق بروزتری در حالت آفلاین نشان داده شود.  هیچ فایل اضافه‌ای بارگیری نمی‌کند.';

  @override
  String get allPlaylistsInfoSetting => 'بارگیری فراداده‌ی فهرست پخش';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'همگام‌سازی فراداده برای همه‌ی فهرست‌های پخش تا تجربه‌ی فهرست پخش شما بهبود یابد';

  @override
  String get downloadFavoritesSetting => 'بارگیری همه‌ی مورد علاقه‌ها';

  @override
  String get downloadAllPlaylistsSetting => 'بارگیری همه‌ی فهرست‌های پخش';

  @override
  String get fiveLatestAlbumsSetting => 'بارگیری ۵ آلبوم واپسین';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'بارگیری‌ها زمانی که کهنه شوند پاک خواهند شد.  برای اینکه از پاک شدن یک آلبوم جلوگیری کنید، آن را قفل کنید.';

  @override
  String get cacheLibraryImagesSettings => 'کَش کردن نگاره‌های کتاب‌خانه‌ی کنونی';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'همه‌ی نگاره‌های آلبوم، هنرمند، ژانر و فهرست پخش که در کتاب‌خانه‌ی فعال کنونی هستند، بارگیری خواهد شد.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'نمایش پیشروی قطعه روی پخش‌کننده‌ی کوچک درون برنامه';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'این‌که پخش‌کننده‌ی کوچک/میله‌ی پخش کنونی در پایین صفحه‌ی آهنگ مانند یک میله‌ی پیشروری رفتار کند را واپایش می‌کند.';

  @override
  String get lyricsScreen => 'نمای متن شعر';

  @override
  String get showLyricsTimestampsTitle => 'نمایش برچسب‌های زمانی برای متن شعرهای همگام شده';

  @override
  String get showLyricsTimestampsSubtitle => 'این‌که برچسب زمانی هر خطِ متن شعر در نمای متن شعرها نمایش داده شود را واپایش می‌کند، اگر در دسترس باشد.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'نمایش دکمه‌ی ایست روی اعلان رسانه';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'این‌که اعلان رسانه، یک دکمه‌ی ایست افزون بر دکمه‌ی وقفه داشته باشد را واپایش می‌کند. این به شما اجازه می‌دهد که پخش را بدون باز کردن نرم‌افزار قطع کنید.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'نمایش واپایش‌های پرش روی اعلان رسانه';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'این‌که اعلان رسانه یک میله‌ی پیشروی پرش‌پذیر داشته‌باشد را واپایش می‌کند. این به شما اجازه می‌دهد که مکان پخش را بدون باز کردن نرم‌افزار تغییر دهید.';

  @override
  String get alignmentOptionStart => 'آغاز';

  @override
  String get alignmentOptionCenter => 'میانه';

  @override
  String get alignmentOptionEnd => 'پایان';

  @override
  String get fontSizeOptionSmall => 'کوچک';

  @override
  String get fontSizeOptionMedium => 'میانه';

  @override
  String get fontSizeOptionLarge => 'بزرگ';

  @override
  String get lyricsAlignmentTitle => 'هم‌ترازی متن شعرها';

  @override
  String get lyricsAlignmentSubtitle => 'هم‌ترازی متن شعرها را در نمای متن شعر واپایش می‌کند.';

  @override
  String get lyricsFontSizeTitle => 'اندازه‌ی فونت متن شعرها';

  @override
  String get lyricsFontSizeSubtitle => 'اندازه‌ی فونت متن شعرها را در نمای متن شعر واپایش می‌کند.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'نمایش نگاره‌ی آلبوم پیش از متن شعر';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'این‌که نگاره‌ی آلبوم بالای متن شعر پیش از این‌که رد شود، نمایش داده شود را واپایش می‌کند.';

  @override
  String get keepScreenOn => 'صفحه را روشن نگهدار';

  @override
  String get keepScreenOnSubtitle => 'زمانی که صفحه روشن نگه داشته شود';

  @override
  String get keepScreenOnDisabled => 'غیرفعال';

  @override
  String get keepScreenOnAlwaysOn => 'همیشه روشن';

  @override
  String get keepScreenOnWhilePlaying => 'زمانی که آهنگ پخش می‌شود';

  @override
  String get keepScreenOnWhileLyrics => 'زمانی که متن شعر نمایش داده می‌شود';

  @override
  String get keepScreenOnWhilePluggedIn => 'فقط در حال شارژ صفحه را روشن نگه‌داشته شود';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'از روشن نگهداشتن صفحه چشم پوشی شود اگر دستگاه در حال شارژ نیست';

  @override
  String get genericToggleButtonTooltip => 'برای تغییر وضعیت بزنید.';

  @override
  String get artwork => 'نگاره';

  @override
  String artworkTooltip(String title) {
    return 'نگاره برای $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'نگاره برای $title. برای تغییر وضعیت پخش بزنید. برای تغییر قطعه‌ها به چپ یا راست بکشید.';
  }

  @override
  String get nowPlayingBarTooltip => 'باز کردن صفحه‌ی پخش';

  @override
  String get additionalPeople => 'افراد';

  @override
  String get playbackMode => 'حالت پخش';

  @override
  String get codec => 'کدک';

  @override
  String get bitRate => 'نرخ انتقال';

  @override
  String get bitDepth => 'ژرفای بیت';

  @override
  String get size => 'اندازه';

  @override
  String get normalizationGain => 'گین (gain)';

  @override
  String get sampleRate => 'نرخ نمونه';

  @override
  String get showFeatureChipsToggleTitle => 'نمایش داده‌های پیشرفته قطعه';

  @override
  String get showFeatureChipsToggleSubtitle => 'داده‌های پیشرفته قطعه مانند کدک، نرخ انتقال و ... را روی صفحه‌ی پخش نمایش می‌دهد.';

  @override
  String get albumScreen => 'صفحه‌ی آلبوم';

  @override
  String get showCoversOnAlbumScreenTitle => 'نمایش نگاره‌ی آلبوم برای قطعه‌ها';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'نگاره‌ی آلبوم را برای هر قطعه به صورت جداگانه روی صفحه‌ی آلبوم نمایش می‌دهد.';

  @override
  String get emptyTopTracksList => 'شما به هیچ‌کدام از قطعه‌های این هنرمند گوش نداده‌اید.';

  @override
  String get emptyFilteredListTitle => 'هیچ آیتمی پیدا نشد';

  @override
  String get emptyFilteredListSubtitle => 'هیج آیتمی که با پالایش شما همخوانی داشته باشد یافت نشد. پالایش‌گر را خاموش کنید یا شرایط جست‌وجو را تغییر دهید.';

  @override
  String get resetFiltersButton => 'بازنشانی پالایش';

  @override
  String get resetSettingsPromptGlobal => 'آیا مطمئنید که می‌خواهید همه‌ی پیکربندی‌ها را به حالت پیش‌فرض بازگردانید؟';

  @override
  String get resetSettingsPromptGlobalConfirm => 'همه‌ی پیکربندی‌ها را به حالت پیش‌فرض بازگردان';

  @override
  String get resetSettingsPromptLocal => 'آیا می‌خواهید که این پیکربندی‌ها را به حالت پیشٰ‌فرض بازگردانید؟';

  @override
  String get genericCancel => 'لغو';

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
