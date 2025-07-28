// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Відкритий відтворювач музики Jellyfin';

  @override
  String get startupErrorTitle =>
      'Щось пішло не так під час запуску програми!\nВибачте за це...';

  @override
  String get startupErrorCallToAction =>
      'Будь ласка, створіть проблему на github.com/jmshrv/finamp із журналами (!) (скористайтеся кнопкою нижче) і знімком екрана цієї сторінки, щоб ми могли якнайшвидше її виправити.';

  @override
  String get startupErrorWorkaround =>
      'Як обхідний шлях ви можете очистити дані програми, щоб скинути налаштування програми. Майте на увазі, що в цьому випадку всі ваші налаштування та завантаження будуть видалені.';

  @override
  String get about => 'Про Finamp';

  @override
  String get aboutContributionPrompt =>
      'Створено чудовими людьми у вільний час.\nВи можете бути одним із них!';

  @override
  String get aboutContributionLink => 'Зробити внесок через GitHub:';

  @override
  String get aboutReleaseNotes => 'Читати примітки до випуску:';

  @override
  String get aboutTranslations => 'Допомогти перекласти Finmap на вашу мову:';

  @override
  String get aboutThanks => 'Дякуємо за використання Finamp!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Ласкаво просимо до $styledName';
  }

  @override
  String get loginFlowSlogan => 'Ваша музика, така, яку ви бажаєте.';

  @override
  String get loginFlowGetStarted => 'Почнімо!';

  @override
  String get viewLogs => 'Переглянути логи';

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get loginFlowServerSelectionHeading => 'Під\'єднати до Jellyfin';

  @override
  String get back => 'Назад';

  @override
  String get serverUrl => 'URL серверу';

  @override
  String get internalExternalIpExplanation =>
      'Якщо ви хочете мати віддалений доступ до свого сервера Jellyfin, вам потрібно використовувати зовнішню IP-адресу.\n\nЯкщо ваш сервер на типовому порті HTTP (80 чи 443), чи типовому порті Jellyfin (8096), вам не потрібно вказувати порт серверу.\n\nЯкщо посилання вказано правильно, під полем введення з\'явиться доступна інформація про ваш сервер.';

  @override
  String get serverUrlHint => 'напр., demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Допомога з посиланням на сервер';

  @override
  String get emptyServerUrl => 'URL серверу не може бути порожнім';

  @override
  String get connectingToServer => 'Підʼєднання до серверу…';

  @override
  String get loginFlowLocalNetworkServers =>
      'Сервери у вашій локальній мережі:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Сканування серверів…';

  @override
  String get loginFlowAccountSelectionHeading => 'Оберіть ваш обліковий запис';

  @override
  String get backToServerSelection => 'Повернутись до вибору серверу';

  @override
  String get loginFlowNamelessUser => 'Безіменний користувач';

  @override
  String get loginFlowCustomUser => 'Власний користувач';

  @override
  String get loginFlowAuthenticationHeading => 'Увійти у ваш обліковий запис';

  @override
  String get backToAccountSelection =>
      'Повернутись до вибору облікового запису';

  @override
  String get loginFlowQuickConnectPrompt =>
      'Використати код для Швидкого Під\'єднання';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Відкрийте застосунок чи сайт Jellyfin, натисніть на іконку користувача та оберіть \"Швидке Під\'єднання\".';

  @override
  String get loginFlowQuickConnectDisabled =>
      'Швидке Під\'єднання вимкнене на цьому сервері.';

  @override
  String get orDivider => 'або';

  @override
  String get loginFlowSelectAUser => 'Обрати користувача';

  @override
  String get username => 'Імʼя користувача';

  @override
  String get usernameHint => 'Введіть ім\'я користувача';

  @override
  String get usernameValidationMissingUsername =>
      'Будь ласка, введіть ім\'я користувача';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHint => 'Введіть пароль';

  @override
  String get login => 'Увійти';

  @override
  String get logs => 'Логи';

  @override
  String get next => 'Далі';

  @override
  String get selectMusicLibraries => 'Оберіть музичну бібліотеку';

  @override
  String get couldNotFindLibraries => 'Не вдається знайти жодної бібліотеки.';

  @override
  String get allLibraries => 'Усі бібліотеки';

  @override
  String get unknownName => 'Невідома назва';

  @override
  String get tracks => 'Композиції';

  @override
  String get albums => 'Альбоми';

  @override
  String get appearsOnAlbums => 'З\'являється на';

  @override
  String get artists => 'Виконавці';

  @override
  String get genres => 'Жанри';

  @override
  String get noGenres => 'Без жанрів';

  @override
  String get playlists => 'Списки відтворення';

  @override
  String get startMix => 'Почати перемішування';

  @override
  String get startMixNoTracksArtist =>
      'Затисніть на виконавцеві, щоб додати або видалити його з конструктора міксів перед початком мікшування';

  @override
  String get startMixNoTracksAlbum =>
      'Затисніть альбом, щоб додати або видалити його з конструктора міксів перед початком мікшування';

  @override
  String get startMixNoTracksGenre =>
      'Натисніть та утримуйте на жанрі для його додавання чи видалення із конструктора міксів перед початком мікшування';

  @override
  String get music => 'Музика';

  @override
  String get clear => 'Очистити';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Улюблені';

  @override
  String get shuffleAll => 'Перемішати все';

  @override
  String get downloads => 'Завантаження';

  @override
  String get settings => 'Налаштування';

  @override
  String get offlineMode => 'Офлайн режим';

  @override
  String get onlineMode => 'Онлайн-режим';

  @override
  String get sortOrder => 'Порядок сортування';

  @override
  String get sortBy => 'Сортування за';

  @override
  String get title => 'Заголовком';

  @override
  String get album => 'Альбомом';

  @override
  String get albumArtist => 'Виконавцем альбому';

  @override
  String get albumArtists => 'Виконавці альбому';

  @override
  String get performingArtists => 'Артисти-виконавці';

  @override
  String get artist => 'Виконавцем';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Бюджетом';

  @override
  String get communityRating => 'Оцінкою спільноти';

  @override
  String get criticRating => 'Оцінкою критиків';

  @override
  String get dateAdded => 'Датою додавання';

  @override
  String get datePlayed => 'Датою відтворення';

  @override
  String get playCount => 'Кількістю відтворень';

  @override
  String get premiereDate => 'Дата випуску';

  @override
  String get productionYear => 'Роком виходу';

  @override
  String get name => 'Ім\'ям';

  @override
  String get random => 'Випадково';

  @override
  String get revenue => 'Доходом';

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
  String get syncDownloadedPlaylists =>
      'Синхронізувати завантажені списки відтворення';

  @override
  String get downloadMissingImages => 'Завантажити відсутні зображення';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завантажено $count відсутніх зображень',
      one: 'Завантажено $count відсутнє зображення',
      zero: 'Відсутніх зображень не знайдено',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Активні завантаження';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Завантажень',
      one: '$count Завантажено',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount композиції',
      one: '$trackCount композиція',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount зображення',
      one: '$imageCount зображення',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount синхронізація вузлів',
      one: '$syncCount синхронізація вузла',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nНаразі виправляється',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count виконано';
  }

  @override
  String dlFailed(int count) {
    return '$count не вдалося';
  }

  @override
  String dlEnqueued(int count) {
    return '$count поставлено в чергу';
  }

  @override
  String dlRunning(int count) {
    return '$count запущено';
  }

  @override
  String get activeDownloadsTitle => 'Активні завантаження';

  @override
  String get noActiveDownloads => 'Немає активних завантажень.';

  @override
  String get errorScreenError =>
      'Під час отримання списку помилок сталася помилка! На цьому етапі вам, ймовірно, слід просто створити проблему на GitHub і видалити дані програми';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Не вдалося отримати композицію із ідентифікатора завантаження';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'альбом',
        'playlist': 'список відтворення',
        'artist': 'виконавця',
        'genre': 'жанр',
        'track': 'композицію',
        'library': 'бібліотеку',
        'other': 'елемент',
      },
    );
    return 'Ви впевнені, що хочете видалити $_temp0 \'$itemName\' з цього пристрою?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Видалити';

  @override
  String get specialDownloads => 'Спеціальні завантаження';

  @override
  String get libraryDownloads => 'Завантаження бібліотеки';

  @override
  String get noItemsDownloaded => 'Немає завантажених елементів.';

  @override
  String get error => 'Помилка';

  @override
  String discNumber(int number) {
    return 'Платівка $number';
  }

  @override
  String get playButtonLabel => 'Відтворити';

  @override
  String get shuffleButtonLabel => 'Перемішати';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиції',
      one: '$count Композиція',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиції',
      one: '$count Композицію',
    );
    return '$_temp0, $downloads завантажено';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиції',
      one: '$count Композиція',
    );
    return '$_temp0 завантажено';
  }

  @override
  String get editPlaylistNameTooltip => 'Редагувати список відтворення';

  @override
  String get editPlaylistNameTitle => 'Редагувати список відтворенні';

  @override
  String get required => 'Обов\'язково';

  @override
  String get updateButtonLabel => 'Оновити';

  @override
  String get playlistUpdated => 'Ім\'я плейлисту змінено.';

  @override
  String get downloadsDeleted => 'Завантаження видалено.';

  @override
  String get addDownloads => 'Додати завантаження';

  @override
  String get location => 'Збережено в';

  @override
  String get confirmDownloadStarted => 'Завантаження розпочато';

  @override
  String get downloadsQueued => 'Завантаження підготоване, завантажую файли';

  @override
  String get addButtonLabel => 'Додати';

  @override
  String get shareLogs => 'Поділитися логами';

  @override
  String get exportLogs => 'Зберегти журнали';

  @override
  String get logsCopied => 'Логи скопійовано.';

  @override
  String get message => 'Повідомлення';

  @override
  String get stackTrace => 'Трасування стека';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Ліцензовано на умовах Mozilla Public License 2.0.\nСирцевий код доступний за $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Транскодування';

  @override
  String get downloadLocations => 'Місце завантаження';

  @override
  String get audioService => 'Служба аудіовідтворення';

  @override
  String get playbackReporting => 'Звіт про відтворення';

  @override
  String get interactions => 'Взаємодії';

  @override
  String get layoutAndTheme => 'Вигляд і тема';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Недоступне в оффлайн режимі';

  @override
  String get logOut => 'Вийти';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Завантажені композиції не будуть видалені';

  @override
  String get areYouSure => 'Ви впевнені ?';

  @override
  String get enableTranscoding => 'Ввімкнути транскодування';

  @override
  String get enableTranscodingSubtitle =>
      'Перекодування музичного потоку відбувається зі сторони сервера.';

  @override
  String get bitrate => 'Бітрейт';

  @override
  String get bitrateSubtitle =>
      'Вищий бітрейт забезпечує вищу якість звуку за рахунок вищої пропускної здатності. Не застосовується на формати без втрат штибу FLAC';

  @override
  String get customLocation => 'Власна папка';

  @override
  String get appDirectory => 'Тека застосунку';

  @override
  String get addDownloadLocation => 'Додати теку завантаження';

  @override
  String get selectDirectory => 'Вибрати теку';

  @override
  String get unknownError => 'Невідома помилка';

  @override
  String get pathReturnSlashErrorMessage =>
      'Шляхи, які повертають \"/\", не можна використовувати';

  @override
  String get directoryMustBeEmpty => 'Тека повинна бути порожньою';

  @override
  String get customLocationsBuggy =>
      'Користувацькі розташування можуть бути дуже помилковими, тому в більшості випадків не рекомендуються. Розташування в системній папці «Музика» не дозволяють зберігати обкладинки альбомів через обмеження ОС.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Перейти у стан низького пріоритету під час паузи';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Дозволяє змахнути сповіщення під час паузи. Також дозволяє Android вимикати службу під час паузи.';

  @override
  String get shuffleAllTrackCount => 'Перемішати всі композиції';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Кількість композицій для завантаження при використанні кнопки перемішування всіх пісень.';

  @override
  String get viewType => 'Тип перегляду';

  @override
  String get viewTypeSubtitle => 'Тип перегляду для музичного екрану';

  @override
  String get list => 'Список';

  @override
  String get grid => 'Таблиця';

  @override
  String get customizationSettingsTitle => 'Персоналізація';

  @override
  String get playbackSpeedControlSetting => 'Видимість швидкості відтворення';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Чи відображаються елементи керування швидкістю відтворення в екранному меню відтворювача';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Автоматично:\nFinmap намагається ідентифікувати, чи є відтворювана композиція подкастом, чи аудіокнигою (її частиною). Це визначається у випадках коли композиція довша за $trackDuration хв., альбом композиції довший за $albumDuration год., чи композиція має хоча б один із перерахованих жанрів: $genreList\nРегулятори швидкості відтворення з\'являться в меню відтворювача.\n\nПоказувати:\nРегулятори швидкості відтворення завжди відображатимуться в меню відтворювача.\n\nПриховувати:\nРегулятори швидкості відтворення завжди приховані.';
  }

  @override
  String get automatic => 'Автоматично';

  @override
  String get shown => 'Показувати';

  @override
  String get hidden => 'Приховувати';

  @override
  String get speed => 'Швидкість';

  @override
  String get reset => 'Скинути';

  @override
  String get apply => 'Застосувати';

  @override
  String get portrait => 'Портретний';

  @override
  String get landscape => 'Альбомний';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Підрахунок поперечних осей сітки';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Кількість плиток сітки для використання в рядку, коли $value.';
  }

  @override
  String get showTextOnGridView => 'Показати текст при перегляді сіткою';

  @override
  String get showTextOnGridViewSubtitle =>
      'Показувати чи ні текст (назву, виконавця тощо) на музичному екрані сітки.';

  @override
  String get useCoverAsBackground =>
      'Показати розмиту обкладинку як фон гравця';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Використовувати або ні розмиту обкладинку як фон на екрані відтворювача.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Мінімальний відступ обкладинки альбому';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Мінімальний відступ навколо обкладинки альбому на екрані відтворювача, у % від довжини екрану.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Приховати виконавців композицій, якщо вони збігаються з виконавцями альбомів';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Чи показувати виконавців композицій на екрані альбому, якщо вони не відрізняються від виконавців альбому.';

  @override
  String get autoSwitchItemCurationTypeTitle =>
      'Тип кураторства товарів з автоматичним перемиканням';

  @override
  String get autoSwitchItemCurationTypeSubtitle =>
      'Якщо цю функцію ввімкнено, розділи елементів на екранах виконавців і жанрів автоматично перемикаються на інший тип кураторства, якщо елементи недоступні (наприклад, немає обраного для певного виконавця).';

  @override
  String get showArtistsTracksSection => 'Розділ «Показати треки»';

  @override
  String get showArtistsTracksSectionSubtitle =>
      'Чи показувати розділ із максимум п’ятьма треками. Якщо цю опцію ввімкнено, можна вибрати між Найчастіше відтворюваними, Улюбленими, Випадковими, Найновішими релізами та Нещодавно доданими треками.';

  @override
  String get disableGesture => 'Вимкнути жести';

  @override
  String get disableGestureSubtitle => 'Чи вимикати жести.';

  @override
  String get showFastScroller => 'Показувати швидку прокрутку';

  @override
  String get theme => 'Тема';

  @override
  String get system => 'Системна';

  @override
  String get light => 'Світла';

  @override
  String get dark => 'Темна';

  @override
  String get tabs => 'Закладки';

  @override
  String get playerScreen => 'Екран відтворювача';

  @override
  String get cancelSleepTimer => 'Скасувати таймер сну?';

  @override
  String get yesButtonLabel => 'Так';

  @override
  String get noButtonLabel => 'Ні';

  @override
  String get setSleepTimer => 'Встановити таймер сну';

  @override
  String get hours => 'Години';

  @override
  String get seconds => 'Секунди';

  @override
  String get minutes => 'Хвилини';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime з $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Композиція $currentTrackIndex з $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Некоректне число';

  @override
  String get sleepTimerTooltip => 'Таймер сну';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Сон через $time хвилин';
  }

  @override
  String get addToPlaylistTooltip => 'Додати до плейлисту';

  @override
  String get addToPlaylistTitle => 'Додати до плейлисту';

  @override
  String get addToMorePlaylistsTooltip => 'Додати до інших списків відтворення';

  @override
  String get addToMorePlaylistsTitle => 'Додати до \"Інші Списки Відтворення\"';

  @override
  String get removeFromPlaylistTooltip => 'Видалити зі списку відтворення';

  @override
  String get removeFromPlaylistTitle => 'Видалити з цього списку відтворення';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Видалити зі списку відтворення \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Видалити зі Списку Відтворення \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Новий список відтворення';

  @override
  String get createButtonLabel => 'Створити';

  @override
  String get playlistCreated => 'Плейлист створено.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Натиснути для додавання до списку відтворення. Утримувати для додавання до Обраного.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Альбом невідомий';

  @override
  String get noItem => 'Невідомий елемент';

  @override
  String get noArtist => 'Невідомий виконавець';

  @override
  String get unknownArtist => 'Невідомий виконавець';

  @override
  String get unknownAlbum => 'Невідомий альбом';

  @override
  String get playbackModeDirectPlaying => 'Пряме відтворення';

  @override
  String get playbackModeTranscoding => 'Транскодування';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate кб/с';
  }

  @override
  String get playbackModeLocal => 'Відтворюється локально';

  @override
  String get queue => 'Черга';

  @override
  String get addToQueue => 'Додати до черги';

  @override
  String get replaceQueue => 'Замінити чергу';

  @override
  String get instantMix => 'Швидкий мікс';

  @override
  String get goToAlbum => 'До альбому';

  @override
  String get goToArtist => 'До Виконавця';

  @override
  String get goToGenre => 'До жанру';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Додано Обране';

  @override
  String get confirmFavoriteRemoved => 'Вилучено Обране';

  @override
  String get addedToQueue => 'Додано в чергу.';

  @override
  String get insertedIntoQueue => 'Вставлено в чергу.';

  @override
  String get queueReplaced => 'Черга змінена.';

  @override
  String get confirmAddedToPlaylist => 'Додано до списку відтворення.';

  @override
  String get removedFromPlaylist => 'Видалено зі списку відтворення.';

  @override
  String get startingInstantMix => 'Початок миттєвого міксу.';

  @override
  String get anErrorHasOccured => 'Сталася помилка.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Код статусу $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Код статусу $statusCode. Можливо, це означає, що ви використали неправильне ім’я користувача/пароль або ваш клієнт не ввійшов в систему.';
  }

  @override
  String get removeFromMix => 'Видалити з міксу';

  @override
  String get addToMix => 'Додати до міксу';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Повторно завантажено $count елементів',
      one: 'Повторно завантажено $count елемент',
      zero: 'Повторне завантаження не потрібне.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Тривалість буферу';

  @override
  String get bufferDurationSubtitle =>
      'Максимальна тривалість, яка може бути буферизована, у секундах. Вимагає перезавантаження.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Не обмежувати розмір буферу';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Вимикає обмеження розміру буфера (\'Розмір буферу\'). Буфер завжди завантажуватиметься протягом заданої тривалості (\'Тривалість буферу\'), навіть для дуже великих файлів. Може спричиняти збої. Потребує перезапуску.';

  @override
  String get bufferSizeTitle => 'Розмір буферу';

  @override
  String get bufferSizeSubtitle =>
      'Максимальний розмір буферу в МБ. Вимагає перезапуску';

  @override
  String get language => 'Мова';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Перемотати на початок або до попередньої композиції';

  @override
  String get skipToNextTrackButtonTooltip =>
      'Перемотати до наступної композиції';

  @override
  String get togglePlaybackButtonTooltip => 'Перемкнути відтворення';

  @override
  String get previousTracks => 'Попередня композиція';

  @override
  String get nextUp => 'Наступне';

  @override
  String get clearNextUp => 'Очистити наступне';

  @override
  String get stopAndClearQueue => 'Зупинити відтворення та очистити чергу';

  @override
  String get playingFrom => 'Відтворюється з';

  @override
  String get playNext => 'Відтворити наступним';

  @override
  String get addToNextUp => 'Додати до наступного';

  @override
  String get shuffleNext => 'Перемішати наступне';

  @override
  String get shuffleToNextUp => 'Перемішати до наступного';

  @override
  String get shuffleToQueue => 'Перемішати до черги';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Композиція',
        'album': 'Альбом',
        'artist': 'Виконавець',
        'playlist': 'Список відтворення',
        'genre': 'Жанр',
        'other': 'Об\'єкт',
      },
    );
    return '$_temp0 відтворюватиметься наступним';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Композицію',
        'album': 'Альбом',
        'artist': 'Виконавця',
        'playlist': 'Список відтворення',
        'genre': 'Жанр',
        'other': 'Об\'єкт',
      },
    );
    return '$_temp0 додано до наступного';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'track',
        'album': 'Альбом',
        'artist': 'Виконавця',
        'playlist': 'Список відтворення',
        'genre': 'Жанр',
        'other': 'Об\'єкт',
      },
    );
    return '$_temp0 додано до черги';
  }

  @override
  String get confirmShuffleNext => 'Буде перемішано наступним';

  @override
  String get confirmShuffleToNextUp => 'Перемішано до наступного';

  @override
  String get confirmShuffleToQueue => 'Перемішано до черги';

  @override
  String get placeholderSource => 'Десь';

  @override
  String get playbackHistory => 'Історія відтворення';

  @override
  String get shareOfflineListens => 'Поділитись офлайн прослуховуваннями';

  @override
  String get yourLikes => 'Ваші вподобання';

  @override
  String mix(String mixSource) {
    return '$mixSource - Мікс';
  }

  @override
  String get tracksFormerNextUp => 'Композиції додано із наступного';

  @override
  String get savedQueue => 'Чергу збережено';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'Альбому',
        'playlist': 'Списку відтворення',
        'trackMix': 'Міксу композиції',
        'artistMix': 'Міксу виконавця',
        'albumMix': 'Міксу альбому',
        'genreMix': 'Міксу жанру',
        'favorites': 'Обраного',
        'allTracks': 'Усіх композицій',
        'filteredList': 'Композицій',
        'genre': 'Жанру',
        'artist': 'Виконавця',
        'track': 'Композиції',
        'nextUpAlbum': 'Альбому з Наступного',
        'nextUpPlaylist': 'Списку відтворення з Наступного',
        'nextUpArtist': 'Виконавця з наступного',
        'other': '',
      },
    );
    return 'Відтворення з $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Перемішати усе';

  @override
  String get playbackOrderLinearButtonLabel => 'Відтворення за порядком';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Відтворення за порядком. Натисніть щоб перемішати.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Перемішування композицій';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Перемішування треків. Натисніть, щоб відтворювати за порядком.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Відтворення на швидкості x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'швидкість x$speed';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% обсягу';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Зменшити швидкість відтворення';

  @override
  String get playbackSpeedIncreaseLabel => 'Збільшити швидкість відтворення';

  @override
  String get loopModeNoneButtonLabel => 'Не повторювати';

  @override
  String get loopModeOneButtonLabel => 'Повторювати цю композицію';

  @override
  String get loopModeAllButtonLabel => 'Повторювати усе';

  @override
  String get queuesScreen => 'Відновити \"Відтворюється зараз\"';

  @override
  String get queueRestoreButtonLabel => 'Відновити';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Збережено $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Відтворюється: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композицій',
      one: '1 Композиція',
    );
    return '$_temp0, $remaining не відтворено';
  }

  @override
  String get queueLoadingMessage => 'Відновлення черги…';

  @override
  String get queueRetryMessage =>
      'Не вдалось відновити чергу. Спробувати ще раз?';

  @override
  String get autoloadLastQueueOnStartup =>
      'Автоматично відновлювати останню чергу';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Після запуску застосунку намагається відновити відтворювану востаннє чергу.';

  @override
  String get reportQueueToServer => 'Звітувати про поточну чергу на сервер?';

  @override
  String get reportQueueToServerSubtitle =>
      'Якщо ввімкнено, Finamp надішле поточну чергу на сервер. Це може покращити дистанційне керування та дозволити відновлення черги на стороні сервера. Завжди ввімкнено, якщо ввімкнено функцію «Відтворити».';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Частота оновлення сеансу відтворення';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'Як часто надсилати поточний статус відтворення до серверу, у секундах. Повинно бути менше 5 хвилин (300 секунд) щоб уникнути передчасного завершення сесії.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'Якщо сервер Jellyfin не отримував ніяких оновлень статусу відтворення від клієнту останні 5 хвилин, сервер вирішить що відтворення було завершено. Тобто для композицій, які тривають довше 5 хвилин, можливе некоректне звітування про відтворення як про завершене, що зменшить якість даних звітів про відтворення.';

  @override
  String get playOnStaleDelay => '\'Час очікування сеансу відтворення';

  @override
  String get playOnStaleDelaySubtitle =>
      'Скільки часу віддалений сеанс «Відтворення» вважається активним після отримання команди. Коли відтворення вважається активним, повідомляється частіше, що може призвести до збільшення використання пропускної здатності.';

  @override
  String get enablePlayonTitle => 'Увімкніть підтримку «Відтворення»';

  @override
  String get enablePlayonSubtitle =>
      'Вмикає функцію Jellyfin «Play On» (дистанційне керування Finamp з іншого клієнта). Вимкніть це, якщо ваш зворотний проксі або сервер не підтримує веб-сокети.';

  @override
  String get playOnReconnectionDelay =>
      'Затримка повторного підключення сеансу «Відтворення»';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Контролює затримку між спробами повторного підключення до веб-сокета PlayOn після його відключення (у секундах). Менша затримка збільшує використання пропускної здатності.';

  @override
  String get topTracks => 'Найліпші композиції';

  @override
  String get topAlbums => 'Найкращі альбоми';

  @override
  String get topArtists => 'Найкращі виконавці';

  @override
  String get recentlyAddedTracks => 'Recently Added Tracks';

  @override
  String get recentlyAddedAlbums => 'Recently Added Albums';

  @override
  String get recentlyAddedArtists => 'Recently Added Artists';

  @override
  String get latestTracks => 'Найновіші треки';

  @override
  String get latestAlbums => 'Найновіші альбоми';

  @override
  String get latestArtists => 'Найновіші виконавці';

  @override
  String get recentlyPlayedTracks => 'Recently Played Tracks';

  @override
  String get recentlyPlayedAlbums => 'Recently Played Albums';

  @override
  String get recentlyPlayedArtists => 'Recently Played Artists';

  @override
  String get favoriteTracks => 'Улюблені треки';

  @override
  String get favoriteAlbums => 'Улюблені альбоми';

  @override
  String get favoriteArtists => 'Улюблені виконавці';

  @override
  String get randomTracks => 'Треки (випадковий вибір)';

  @override
  String get randomAlbums => 'Альбоми (випадковий вибір)';

  @override
  String get randomArtists => 'Виконавці (випадковий вибір)';

  @override
  String get mostPlayed => 'Найпопулярніші';

  @override
  String get randomFavoritesFirst => 'Випадково (спочатку уподобання)';

  @override
  String get recentlyAdded => 'Нещодавно додані';

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get latestReleases => 'Останні релізи';

  @override
  String get itemSectionsOrder => 'Порядок розділів елемента';

  @override
  String get unknown => 'Unknown';

  @override
  String get itemSectionsOrderSubtitle =>
      'Контролює порядок розділів елементів.';

  @override
  String get genreItemSectionFilterChipOrderTitle =>
      'Розділи елементів Порядок фільтра';

  @override
  String get genreItemSectionFilterChipOrderSubtitle =>
      'Керує порядком доступних фільтрів для розділів елементів.';

  @override
  String get artistItemSectionFilterChipOrderTitle =>
      'Порядок фільтрів розділів треків';

  @override
  String get artistItemSectionFilterChipOrderSubtitle =>
      'Керує порядком доступних фільтрів для розділу треків.';

  @override
  String get genreFilterArtistScreens => 'Фільтрувати екрани виконавців';

  @override
  String get genreFilterArtistScreensSubtitle =>
      'Якщо цю функцію ввімкнено, на екранах виконавців (доступних через жанр) відображатимуться лише треки та альбоми, що відповідають жанру, який ви зараз переглядаєте. (Завжди можна вручну видалити фільтр жанрів, щоб відобразити всі треки та альбоми.)';

  @override
  String get genreFilterPlaylistScreens => 'Filter Playlists';

  @override
  String get genreFilterPlaylistScreensSubtitle =>
      'When enabled, Playlists (accessed through a genre) will only show tracks that match the genre you\'re currently browsing. (It is always possible to manually remove the Genre Filter to reveal all tracks.)';

  @override
  String get genreListsInheritSorting => 'Повні списки Сортування Успадкування';

  @override
  String get genreListsInheritSortingSubtitle =>
      'Якщо цю опцію ввімкнено, списки «Переглянути всі» успадкують сортування та фільтрацію з екрана жанрів. Якщо вимкнено, замість цього будуть використані налаштування з відповідної вкладки бібліотеки. Натискання на кількість у верхній частині екрана жанру завжди відкриватиме повний список із налаштуваннями сортування з вкладки бібліотеки.';

  @override
  String get curatedItemsMostPlayedOfflineTooltip =>
      'Недоступно в автономному режимі.';

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
      other: '$count Альбоми',
      one: '$count Альбом',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Перемішати альбоми';

  @override
  String get shuffleAlbumsNext => 'Перемішати альбоми наступними';

  @override
  String get shuffleAlbumsToNextUp => 'Перемішати альбоми до Наступного';

  @override
  String get shuffleAlbumsToQueue => 'Перемішати альбоми до черги';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount відтворень',
      one: '$playCount відтворення',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'альбом',
        'playlist': 'список відтворення',
        'trackMix': 'мікс композицій',
        'artistMix': 'мікс виконавців',
        'albumMix': 'мікс альбомів',
        'genreMix': 'мікс жанрів',
        'favorites': 'обране',
        'allTracks': 'усі композиції',
        'filteredList': 'композиції',
        'genre': 'жанр',
        'artist': 'виконавця',
        'track': 'композицію',
        'nextUpAlbum': 'альбом у наступному',
        'nextUpPlaylist': 'список відтворення у наступному',
        'nextUpArtist': 'виконавця у наступному',
        'other': '',
      },
    );
    return 'Не вдалось завантажити $_temp0';
  }

  @override
  String get confirm => 'Підтвердити';

  @override
  String get close => 'Закрити';

  @override
  String get showUncensoredLogMessage =>
      'Цей журнал містить ваші дані для входу. Показати?';

  @override
  String get resetTabs => 'Скинути вкладки';

  @override
  String get resetToDefaults => 'Відновити за вмовчанням';

  @override
  String get noMusicLibrariesTitle => 'Музичні бібліотеки відсутні';

  @override
  String get noMusicLibrariesBody =>
      'Finamp не знайшов жодної музичної бібліотеки. Переконайтеся, що ваш сервер Jellyfin містить принаймні одну бібліотеку з типом вмісту \"Музика\".';

  @override
  String get refresh => 'Поновити';

  @override
  String get moreInfo => 'Більше про';

  @override
  String get volumeNormalizationSettingsTitle => 'Нормалізація гучності';

  @override
  String get playbackReportingSettingsTitle =>
      'Звіт про відтворення та відтворення';

  @override
  String get volumeNormalizationSwitchTitle =>
      'Увімкнути нормалізацію гучності';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Використовуйте інформацію про посилення для нормалізації гучності композицій (\"Посилення при відтворенні\")';

  @override
  String get volumeNormalizationModeSelectorTitle =>
      'Режим нормалізації гучності';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'Коли і як застосовувати нормалізацію гучності';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Гібридно (Композиція + Альбом):\nПосилення композицій застосовується для звичайного відтворення, але якщо відтворюється альбом (коли це головне джерело відтворення черги, чи його було додано до черги якимось чином), тоді буде застосовано посилення альбому.\n\nНа основі композицій:\nПосилення композицій застосовується завжди, незалежно від того чи відтворюється альбом, чи ні.\n\nНа основі альбому:\nНормалізація гучності застосовується лише при відтворені альбомів (застосування посилення альбомів), не для окремих композицій.';

  @override
  String get volumeNormalizationModeHybrid => 'Гібридно (Композиція + Альбом)';

  @override
  String get volumeNormalizationModeTrackBased => 'На основі композицій';

  @override
  String get volumeNormalizationModeAlbumBased => 'На основі альбомів';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Лише для альбомів';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Базове посилення';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Наразі нормалізація гучності на iOS вимагає змінення гучності відтворення щоб емулювати змінення посилення. Оскільки ми не можемо збільшити гучність більш ніж на 100%, ми маємо знизити гучність до типової щоб ми могли підвищувати гучність для тихих композицій. Значення у децибелах (дБ), де -10 дБ це ~30% гучності, -4.5 дБ - ~60%, а -2.0 дБ - ~80%.';

  @override
  String numberAsDecibel(double value) {
    return '$value дБ';
  }

  @override
  String get swipeInsertQueueNext => 'Відтворити додану композицію наступною';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Увімкнути можливість вставляти композицію як наступний об\'єкт у черзі, якщо вона була додана замість вставки у кінець черги.';

  @override
  String get swipeLeftToRightAction => 'Проведіть пальцем до дії вправо';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Дія запускається під час гортання треку в списку зліва направо.';

  @override
  String get swipeRightToLeftAction => 'Проведіть пальцем вліво';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Дія запускається під час гортання треку в списку справа наліво.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Почати миттєвий мікс для окремих композицій';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'Коли увімкнено, натискання на композицію у вкладці композицій почне миттєвий мікс цієї композиції замість відтворення власне композиції.';

  @override
  String get downloadItem => 'Завантажити';

  @override
  String get repairComplete => 'Відновлення завантажень завершено.';

  @override
  String get syncComplete => 'Усі завантаження повторно синхронізовано.';

  @override
  String get syncDownloads =>
      'Синхронізувати та завантажити відсутні елементи.';

  @override
  String get repairDownloads =>
      'Виправити проблеми із завантаженням файлів чи метаданих.';

  @override
  String get requireWifiForDownloads =>
      'Вимагає доступу до мережі під час завантаження.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count композиції',
      one: '$count композиція',
    );
    return 'Увага: $_temp0 не можна відновити у чергу.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Триває',
        'failed': 'Провалено',
        'syncFailed': 'Повторно не синхронізовано',
        'enqueued': 'У черзі',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Завантаження',
      one: 'Завантаження',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'ВИ впевнені що хочете завантажити увесь вміст бібліотеки \"$libraryName\"?';
  }

  @override
  String get onlyShowFullyDownloaded =>
      'Показувати лише повністю завантажені альбоми';

  @override
  String get filesystemFull =>
      'Решта завантажень не можуть бути завершені. Файлова система переповнена.';

  @override
  String get connectionInterrupted =>
      'З\'єднання було обірвано, призупинення завантажень.';

  @override
  String get connectionInterruptedBackground =>
      'Під час фонового завантаження було обірвано з\'єднання. Це може бути спричинено налаштуваннями системи.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'Під час фонового завантаження було обірвано з\'єднання. Це може бути спричинено увімкненням параметра \"Входити у стан низького пріоритету на паузі\" або налаштуваннями ОС.';

  @override
  String get activeDownloadSize => 'Завантаження…';

  @override
  String get missingDownloadSize => 'Видалення…';

  @override
  String get syncingDownloadSize => 'Синхронізація…';

  @override
  String get runRepairWarning =>
      'Не можна встановити з\'єднання з цим сервером задля завершення міграції завантаження. Будь ласка, запустіть \"Відновити Завантаження\" із екрану завантажень коли відновите з\'єднання.';

  @override
  String get downloadSettings => 'Завантаження';

  @override
  String get showNullLibraryItemsTitle =>
      'Показувати медіа з Невідомої Бібліотеки.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Деякі медіа-файли можуть бути завантажені з невідомої бібліотеки. Вимкніть щоб приховувати їх поза межами оригінальної колекції.';

  @override
  String get maxConcurrentDownloads => 'Максимум конкурентних завантажень';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'Збільшення конкурентних завантажень можуть дозволити зменшити фонові завантаження але може спричинити провал деяких великих завантажень, або надмірні лаги у деяких випадках.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Конкурентних завантажень';
  }

  @override
  String get downloadsWorkersSetting => 'Кількість Завантажувачів';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Кількість завантажувачів для синхронізації метаданих та видалення завантажень. Збільшення кількості завантажувачів може прискорити синхронізацію завантажень і видалення, особливо за високої затримки сервера, але може спричинити затримки.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Завантажувачів';
  }

  @override
  String get syncOnStartupSwitch =>
      'Автоматично синхронізувати завантаження при запуску';

  @override
  String get preferQuickSyncSwitch => 'Віддати перевагу швидкій синхронізації';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'При виконанні синхронізації, деякі, зазвичай статичні об\'єкти (штибу композицій чи альбомів), не будуть оновлені. Відновлення завантаження завжди виконує повну синхронізацію.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Альбом',
        'playlist': 'Список відтворення',
        'artist': 'Виконавець',
        'genre': 'Жанр',
        'track': 'Композиція',
        'library': 'Бібліотека',
        'unknown': 'Об\'єкт',
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
    return 'Цей об\'єкт має бути завантаженим з $parentName.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Улюблені',
        'allPlaylists': 'Усі списки відтворення',
        'fiveLatestAlbums': '5 Найновіші альбоми',
        'allPlaylistsMetadata': 'Метадані списку відтворення',
        'collectionWithLibraryFilter': 'Колекція з фільтром бібліотеки',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Зображення для \'$libraryName\' було кешовано';
  }

  @override
  String get transcodingStreamingFormatTitle => 'Оберіть формат транскодування';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Оберіть формат який використовуватиметься для транслювання транскодованого аудіо. Не буде застосовано до попередньо доданих композицій.';

  @override
  String get downloadTranscodeEnableTitle =>
      'Увімкнути транскодовані завантаження';

  @override
  String get downloadTranscodeCodecTitle => 'Обрати кодек для завантажень';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Завжди',
        'never': 'Ніколи',
        'ask': 'Запитувати',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Бітрейт завантаження';

  @override
  String get downloadBitrateSubtitle =>
      'Вищий бітрейт дає кращу якість аудіо за рахунок більших вимог до сховища.';

  @override
  String get transcodeHint => 'Транскодувати?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Завантажити як $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Перекодовано',
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
    return 'Завантажити оригінал$_temp0';
  }

  @override
  String get redownloadcomplete =>
      'Повторне завантаження транскодування у черзі.';

  @override
  String get redownloadTitle =>
      'Автоматично повторно завантажувати транскодування';

  @override
  String get redownloadSubtitle =>
      'Автоматично повторно завантажувати композиції, які мали б бути у іншій якості згідно змін батьківської колекції.';

  @override
  String get defaultDownloadLocationButton =>
      'Встановити як типову локацію для завантажень.  Вимкнути для вибору на одне завантаження.';

  @override
  String get fixedGridSizeSwitchTitle =>
      'Використовувати плитки з фіксованим розміром сітки';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Розмір плиток сітки не будуть адаптовані до розміру вікна/екрану.';

  @override
  String get fixedGridSizeTitle => 'Розмір плитки сітки';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Маленький',
        'medium': 'Середній',
        'large': 'Великий',
        'veryLarge': 'Дуже великий',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Дозволити режим SplitScreen';

  @override
  String get allowSplitScreenSubtitle =>
      'Відтворювач відображатиметься поряд з іншими поданнями на ширших дисплеях.';

  @override
  String get enableVibration => 'Увімкнути вібрацію';

  @override
  String get enableVibrationSubtitle => 'Чи вмикати вібрацію.';

  @override
  String get hideQueueButton => 'Кнопка приховати чергу';

  @override
  String get hideQueueButtonSubtitle =>
      'Приховати кнопку черги на екрані плеєра. Проведіть пальцем угору, щоб отримати доступ до черги.';

  @override
  String get oneLineMarqueeTextButton =>
      'Довгі заголовки з автоматичним прокручуванням';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Автоматично прокручуйте назви композицій, які занадто довгі для відображення в два рядки';

  @override
  String get marqueeOrTruncateButton =>
      'Використовуйте три крапки для довгих заголовків';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Показувати … у кінці довгих заголовків замість тексту, що прокручується';

  @override
  String get hidePlayerBottomActions => 'Приховати нижні дії';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Приховати кнопки черги та тексту на екрані відтворювача. Проведіть вгору для доступу до черги, вліво (під обкладинкою альбому) для показу тексту пісні, якщо така доступна.';

  @override
  String get prioritizePlayerCover => 'Пріоритезувати обкладинку альбому';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Пріоритезувати показ більшої обкладинки альбому на екрані відтворювача. Неважливі елементи керування будуть приховані більш агресивно при малих розмірах екрану.';

  @override
  String get suppressPlayerPadding =>
      'Прибрати відступи елементів керування відтворювача';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Повністю зменшує відступ між елементами керування екрану відтворювача коли обкладинка альбому не на весь розмір.';

  @override
  String get lockDownload => 'Завжди зберігати на девайсі';

  @override
  String get showArtistChipImage =>
      'Показувати зображення виконавців разом із їх ім\'ям';

  @override
  String get showArtistChipImageSubtitle =>
      'Це впливає на невеликі попередні перегляди зображень виконавців, наприклад, на екрані відтворювача.';

  @override
  String get scrollToCurrentTrack => 'Прокрутити до поточної композиції';

  @override
  String get enableAutoScroll => 'Увімкнути автоматичне прокручування';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz кГц';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit біт';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration залишилось';
  }

  @override
  String get removeFromPlaylistConfirm => 'Вилучити';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Вилучити \'$itemName\' зі списку відтворення \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Меню композицій';

  @override
  String get quickActions => 'Швидкі дії';

  @override
  String get addRemoveFromPlaylist => 'Додати / Вилучити зі списку відтворення';

  @override
  String get addPlaylistSubheader => 'Додати композицію до списку відтворення';

  @override
  String get trackOfflineFavorites => 'Синхронізувати усі обрані статуси';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Це дозволить показувати більш актуальні обрані статуси в режимі офлайн. Не завантажує ніяких додаткових файлів.';

  @override
  String get allPlaylistsInfoSetting =>
      'Завантажити метадані списку відтворення';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Синхронізувати метадані для усіх списків відтворення щоб покращити ваш досвід';

  @override
  String get downloadFavoritesSetting => 'Завантажити усі обрані';

  @override
  String get downloadAllPlaylistsSetting =>
      'Завантажити усі списки відтворення';

  @override
  String get fiveLatestAlbumsSetting => 'Завантажити 5 останніх альбомів';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Завантаження будуть видалені по мірі застарівання. Замкніть завантаження для запобігання видалення альбому.';

  @override
  String get cacheLibraryImagesSettings =>
      'Кешувати зображення поточної бібліотеки';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Обкладинки усіх альбомів, виконавців, жанрів, та списків відтворення у поточній активній бібліотеці будуть завантажені.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Показувати прогрес композиції у внутрішньому міні-відтворювачі';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Контролює, чи міні-програвач у програмі/панель зараз відтворюється внизу екрана музики функціонує як панель прогресу.';

  @override
  String get lyricsScreenButtonTitle => 'Тексти пісень';

  @override
  String get lyricsScreen => 'Текст пісні';

  @override
  String get showLyricsTimestampsTitle =>
      'Показувати часові мітки для синхронізованих текстів пісень';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Керує тим, чи показувати мітку часу для кожного рядка тексту у поданні тексту, якщо вона доступна.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Показувати кнопку «Зупинити» у сповіщенні про медіа';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Контролює, чи має медіасповіщення кнопку зупинки. Це дозволяє зупинити відтворення, не відкриваючи програму.';

  @override
  String get showShuffleButtonOnMediaNotificationTitle =>
      'Показувати кнопку випадкового відтворення в сповіщенні про медіафайли';

  @override
  String get showShuffleButtonOnMediaNotificationSubtitle =>
      'Контролює, чи має медіасповіщення кнопку перемішування. Це дозволяє перемішувати/відтворювати без відкривання програми.';

  @override
  String get showFavoriteButtonOnMediaNotificationTitle =>
      'Показувати кнопку «Улюблене» у сповіщенні про медіа';

  @override
  String get showFavoriteButtonOnMediaNotificationSubtitle =>
      'Контролює, чи має медіасповіщення кнопку обраного. Це дозволяє додавати/вилучати поточну композицію з обраного, не відкриваючи програму.';

  @override
  String get showSeekControlsOnMediaNotificationTitle =>
      'Дозволити пошук у сповіщенні про медіа';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Керує тим чи медіа сповіщення має індикатор прогресу. Він дозволить змінювати позицію відтворення без потреби відкривати застосунок.';

  @override
  String get alignmentOptionStart => 'Початок';

  @override
  String get alignmentOptionCenter => 'Центр';

  @override
  String get alignmentOptionEnd => 'Кінець';

  @override
  String get fontSizeOptionSmall => 'Маленький';

  @override
  String get fontSizeOptionMedium => 'Середній';

  @override
  String get fontSizeOptionLarge => 'Великий';

  @override
  String get lyricsAlignmentTitle => 'Вирівнювання тексту пісень';

  @override
  String get lyricsAlignmentSubtitle =>
      'Керує вирівнюванням текстів у поданні текстів пісень.';

  @override
  String get lyricsFontSizeTitle => 'Розмір шрифту тексту пісень';

  @override
  String get lyricsFontSizeSubtitle =>
      'Керує розміром шрифту тексту пісень у відповідному поданні.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Показати обкладинку альбому перед текстом';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Дозволяє контролювати, чи показувати обкладинку альбому над текстом пісень перед прокруткою.';

  @override
  String get keepScreenOn => 'Лишати екран увімененим';

  @override
  String get keepScreenOnSubtitle => 'Коли лишати екран увімкненим';

  @override
  String get keepScreenOnDisabled => 'Вимкнено';

  @override
  String get keepScreenOnAlwaysOn => 'Завжди увімкнено';

  @override
  String get keepScreenOnWhilePlaying => 'Коли відтворюється музика';

  @override
  String get keepScreenOnWhileLyrics => 'Коли показано текст пісні';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Лишати екран увімкненим лише якщо під\'єднано до мережі';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Ігнорувати \"Лишати екран увімкненим\" якщо девайс від\'єднано';

  @override
  String get genericToggleButtonTooltip => 'Натисніть щоб перемкнути.';

  @override
  String get artwork => 'Ілюстрація';

  @override
  String artworkTooltip(String title) {
    return 'Ілюстрація для $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Ілюстрація для $title. Торкніться, щоб перемкнути відтворення. Проведіть пальцем вліво або вправо, щоб перемикати треки.';
  }

  @override
  String get nowPlayingBarTooltip => 'Відкрити екран відтворювача';

  @override
  String get additionalPeople => 'Люди';

  @override
  String get playbackMode => 'Режим відтворення';

  @override
  String get codec => 'Кодек';

  @override
  String get bitRate => 'Швидкість передавання';

  @override
  String get bitDepth => 'Бітова глибина';

  @override
  String get size => 'Розмір';

  @override
  String get normalizationGain => 'Підсилення';

  @override
  String get sampleRate => 'Частота дискретизації';

  @override
  String get showFeatureChipsToggleTitle =>
      'Показувати розширену інформацію про композицію';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Показувати на екрані програвача розширену інформацію про композицію, як-от кодек, бітрейт тощо.';

  @override
  String get seeAll => 'Дивитися все';

  @override
  String get albumScreen => 'Екран альбому';

  @override
  String get showCoversOnAlbumScreenTitle =>
      'Показувати обкладинки альбомів для композицій';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Показувати обкладинки альбому для кожної композиції окремо на екрані альбому.';

  @override
  String get artistScreen => 'Екран виконавця';

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
  String get genreScreen => 'Екран жанру';

  @override
  String get emptyTopTracksList =>
      'Ви ще не слухали жодної композиції від цього виконавця.';

  @override
  String get emptyFilteredListTitle => 'Не знайдено об\'єктів';

  @override
  String get emptyFilteredListSubtitle =>
      'Не знайдено жодного об\'єкта за даними фільтрами. Спробуйте скинути їх чи змінити запит.';

  @override
  String get resetFiltersButton => 'Скинути фільтри';

  @override
  String get resetSettingsPromptGlobal =>
      'ВИ впевнені що хочете скинути УСІ налаштування до значень за вмовчанням?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Скинути УСІ налаштування';

  @override
  String get resetSettingsPromptLocal =>
      'Ви хочете скинути налаштування до значень за вмовчанням?';

  @override
  String get genericCancel => 'Скасувати';

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
        'server': 'сервера',
        'other': 'unknown',
      },
    );
    return '$_temp0 видалено з $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Дозволити видалення з сервера';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Увімкніть і вимкніть опцію остаточного видалення доріжки з файлової системи сервера, якщо видалення можливе.';

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
        'canDelete': ' Це також видалить цей елемент із цього пристрою.',
        'cantDelete':
            ' Цей елемент залишиться на цьому пристрої до наступної синхронізації.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'this device',
        'server':
            'файлової системи та бібліотеки сервера.$_temp1 \nЦю дію неможливо скасувати',
        'other': '',
      },
    );
    return 'Ви збираєтеся видалити цей $_temp0 із $_temp2.';
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
    return 'Видалити$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Попередження: ви збираєтеся завантажити $count треків.';
  }

  @override
  String get downloadSizeWarningCutoff =>
      'Завантажте обмеження попередження про розмір';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'У разі завантаження більшої кількості композицій одночасно з’явиться попередження.';

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
    return 'Ви впевнені, що хочете додати всі треки з $_temp0 \'$itemName\' до цього списку відтворення?  Їх можна видалити лише окремо.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Загальнодоступні:';

  @override
  String get releaseDateFormatYear => 'Рік';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Місяць і рік';

  @override
  String get releaseDateFormatMonthDayYear => 'Місяць, день і рік';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Показати дату випуску альбому на екрані програвача';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Показати дату випуску альбому на екрані плеєра за назвою альбому.';

  @override
  String get releaseDateFormatTitle => 'Формат дати випуску';

  @override
  String get releaseDateFormatSubtitle =>
      'Керує форматом усіх дат випуску, які відображаються в програмі.';

  @override
  String get noReleaseDate => 'Без дати випуску';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError =>
      'Помилка завантаження доступних бібліотек для користувача';

  @override
  String get autoOfflineOptionOff => 'Деактивовано';

  @override
  String get autoOfflineOptionNetwork => 'Локальна мережа';

  @override
  String get autoOfflineOptionDisconnected => 'Відʼєднано';

  @override
  String get autoOfflineSettingDescription =>
      'Автоматично перемикатись у режим офлайн.\nДеактивовано: Не перемикатиме автоматично у режим офлайн. Може зберігати заряд батареї.\nЛокальні Мережа: Вмикати режим офлайн при відсутності зʼєднання до Інтернету.\nВідʼєднано: Вмикати режим офлайн при відсутності зʼєднання з будь-чим.\nВи завжди можете вручну увімкнути режим офлайн, що призупинить автоматичне увімкнення до моменту поки ви не вийдете з режиму офлайн';

  @override
  String get autoOfflineSettingTitle => 'Автоматичний режим офлайн';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'встановлено',
        'disabled': 'не встановлено',
        'other': 'не все так однозначно',
      },
    );
    return 'Автоматично $_temp0 режим офлайн';
  }

  @override
  String get audioFadeOutDurationSettingTitle => 'Тривалість затухання звуку';

  @override
  String get audioFadeOutDurationSettingSubtitle =>
      'Тривалість затухання звуку в мілісекундах.';

  @override
  String get audioFadeInDurationSettingTitle => 'Тривалість затухання звуку';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'Тривалість затухання звуку в мілісекундах. Встановіть значення 0, щоб вимкнути плавне збільшення.';

  @override
  String get outputMenuButtonTitle => 'Вихід';

  @override
  String get outputMenuTitle => 'Змінити вихід';

  @override
  String get outputMenuVolumeSectionTitle => 'Обсяг';

  @override
  String get outputMenuDevicesSectionTitle => 'Доступні пристрої';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Підключіться до пристрою';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Динамік пристрою',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Unknown',
      },
    );
    return '$_temp0';
  }

  @override
  String get desktopShuffleWarning =>
      'Зміна режиму випадкового відтворення наразі недоступна на комп’ютері.';

  @override
  String get preferHomeNetworkActiveAddressInfoText => 'Активна адреса';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingTitle =>
      'Адреса домашньої мережі';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingDescription =>
      'Цільова адреса сервера Jellyfin у вашій домашній мережі';

  @override
  String get preferHomeNetworkEnableSwitchTitle =>
      'Віддати перевагу домашній мережі';

  @override
  String get preferHomeNetworkEnableSwitchDescription =>
      'Чи використовувати іншу адресу, коли ви вдома';

  @override
  String get preferHomeNetworkPublicAddressSettingTitle => 'Публічна адреса';

  @override
  String get preferHomeNetworkPublicAddressSettingDescription =>
      'Основна адреса, яка використовується для підключення до вашого сервера Jellyfin';

  @override
  String get preferHomeNetworkInfoBox =>
      'Ця функція вимагає дозволів на доступ до геоданих (і геодані мають бути ввімкнені), щоб зчитувати назву мережі.';

  @override
  String get networkSettingsTitle => 'Мережа';

  @override
  String get downloadPaused =>
      'Завантаження призупинено, оскільки пристрій не підключено до Wi-Fi';

  @override
  String get missingSchemaError => 'URL-адреса має починатися з http(s)://';

  @override
  String get testConnectionButtonLabel => 'Перевірте обидва з\'єднання';

  @override
  String ping(String status) {
    String _temp0 = intl.Intl.selectLogic(
      status,
      {
        'true_true': 'Обидва доступні',
        'true_false': 'НЕ ВДАЛОСЯ ЗВ’ЯЗАТИСЯ З МЕСТОВОЮ АДРЕСОЮ',
        'false_true': 'НЕ ВДАЛОСЯ ДОСТУПИТИ ДО ОБЩОЇ АДРЕСИ',
        'false_false': 'НЕ ВІДБУЛОСЯ зв\'язатися з обома',
        'other': 'невідомий',
      },
    );
    return '$_temp0';
  }

  @override
  String get autoReloadQueueTitle => 'Автоматичне перезавантаження черги';

  @override
  String get autoReloadQueueSubtitle =>
      'Автоматично перезавантажувати чергу, коли змінюється джерело (наприклад, увімкнено автономний режим або змінено адресу сервера). Якщо вимкнено, Finamp натомість запитуватиме вас.';

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
    return 'Перезавантажте чергу, щоб застосувати нове $_temp0';
  }

  @override
  String autoReloadPromptMissingTracks(int amountUndownloadedTracks) {
    String _temp0 = intl.Intl.pluralLogic(
      amountUndownloadedTracks,
      locale: localeName,
      other: '$amountUndownloadedTracks tracks',
      one: '1 track',
    );
    return '$_temp0 будуть видалені з черги, оскільки вони не завантажені.';
  }

  @override
  String get autoReloadPromptReloadButton => 'Перезавантажити';
}
