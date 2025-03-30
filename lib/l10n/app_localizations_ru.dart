// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Музыкальный плеер для Jellyfin с открытым исходным кодом';

  @override
  String startupError(String error) {
    return 'Что-то пошло не так во время запуска приложения. Возникла ошибка: $error\n\nПожалуйста, создайте «issue» на github.com/UnicornsOnLSD/finamp и приложите скриншот этой страницы. Если проблема будет повторяться, вы можете очистить данные приложения, чтобы сбросить его настройки.';
  }

  @override
  String get about => 'О Finamp';

  @override
  String get aboutContributionPrompt => 'Создан замечательными людьми в свободное время.\nТы мог бы стать одним из них!';

  @override
  String get aboutContributionLink => 'Внесите свой вклад в Finamp на GitHub:';

  @override
  String get aboutReleaseNotes => 'Ознакомьтесь с последними примечаниями к выпуску:';

  @override
  String get aboutTranslations => 'Помогите перевести Finamp на ваш язык:';

  @override
  String get aboutThanks => 'Благодарим вас за использование Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Добро пожаловать';

  @override
  String get loginFlowSlogan => 'Ваша музыка, такая, как вам хочется.';

  @override
  String get loginFlowGetStarted => 'Приступаем!';

  @override
  String get viewLogs => 'Просмотр журналов';

  @override
  String get changeLanguage => 'Изменить язык';

  @override
  String get loginFlowServerSelectionHeading => 'Подключение к Jellyfin';

  @override
  String get back => 'Назад';

  @override
  String get serverUrl => 'URL сервера';

  @override
  String get internalExternalIpExplanation => 'Если вы хотите иметь возможность удалённого доступа к вашему серверу Jellyfin, необходимо использовать внешний IP-адрес.\n\nЕсли ваш сервер работает на стандартных портах HTTP (80 или 443), или на стандартном порту Jellyfin (8096), вам не нужно указывать порт.\n\nЕсли URL-адрес указан верно, вы должны увидеть информацию о вашем сервере под полем ввода.';

  @override
  String get serverUrlHint => 'напр. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Справка по URL-адресу сервера';

  @override
  String get emptyServerUrl => 'URL сервера не может быть пустым';

  @override
  String get connectingToServer => 'Подключение к серверу...';

  @override
  String get loginFlowLocalNetworkServers => 'Серверы в вашей локальной сети:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Поиск серверов...';

  @override
  String get loginFlowAccountSelectionHeading => 'Выберите свою учетную запись';

  @override
  String get backToServerSelection => 'Вернуться к выбору сервера';

  @override
  String get loginFlowNamelessUser => 'Безымянный пользователь';

  @override
  String get loginFlowCustomUser => 'Другой пользователь';

  @override
  String get loginFlowAuthenticationHeading => 'Войдите в свою учетную запись';

  @override
  String get backToAccountSelection => 'Вернуться к выбору учетной записи';

  @override
  String get loginFlowQuickConnectPrompt => 'Используйте код быстрого подключения';

  @override
  String get loginFlowQuickConnectInstructions => 'Откройте приложение или веб-сайт Jellyfin, нажмите на значок своего пользователя и выберите «Быстрое подключение».';

  @override
  String get loginFlowQuickConnectDisabled => 'Быстрое подключение на этом сервере отключено.';

  @override
  String get orDivider => 'или';

  @override
  String get loginFlowSelectAUser => 'Выберите пользователя';

  @override
  String get username => 'Имя пользователя';

  @override
  String get usernameHint => 'Введите имя пользователя';

  @override
  String get usernameValidationMissingUsername => 'Пожалуйста, введите имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHint => 'Введите пароль';

  @override
  String get login => 'Войти';

  @override
  String get logs => 'Журнал';

  @override
  String get next => 'Далее';

  @override
  String get selectMusicLibraries => 'Выбрать музыкальные библиотеки';

  @override
  String get couldNotFindLibraries => 'Библиотеки не найдены.';

  @override
  String get unknownName => 'Неизвестное имя';

  @override
  String get tracks => 'Композиции';

  @override
  String get albums => 'Альбомы';

  @override
  String get artists => 'Исполнители';

  @override
  String get genres => 'Жанры';

  @override
  String get playlists => 'Плейлисты';

  @override
  String get startMix => 'Начать микс';

  @override
  String get startMixNoTracksArtist => 'Чтобы добавить или удалить исполнителя из микса, нажмите и удерживайте его имя';

  @override
  String get startMixNoTracksAlbum => 'Чтобы добавить или удалить альбом из микса, нажмите и удерживайте его';

  @override
  String get startMixNoTracksGenre => 'Чтобы добавить или удалить жанр из микса, нажмите и удерживайте его';

  @override
  String get music => 'Музыка';

  @override
  String get clear => 'Очистить';

  @override
  String get favourites => 'Избранное';

  @override
  String get shuffleAll => 'Перемешать всё';

  @override
  String get downloads => 'Загрузки';

  @override
  String get settings => 'Настройки';

  @override
  String get offlineMode => 'Автономный режим';

  @override
  String get sortOrder => 'Порядок сортировки';

  @override
  String get sortBy => 'Критерий сортировки';

  @override
  String get title => 'Заголовок';

  @override
  String get album => 'Альбом';

  @override
  String get albumArtist => 'Исполнитель Альбома';

  @override
  String get artist => 'Исполнитель';

  @override
  String get budget => 'Бюджет';

  @override
  String get communityRating => 'Оценка Сообщества';

  @override
  String get criticRating => 'Оценка Критиков';

  @override
  String get dateAdded => 'Дата Добавления';

  @override
  String get datePlayed => 'Дата Последнего Проигрывания';

  @override
  String get playCount => 'Всего Проигрываний';

  @override
  String get premiereDate => 'Дата Премьеры';

  @override
  String get productionYear => 'Год Создания';

  @override
  String get name => 'Имя';

  @override
  String get random => 'Случайно';

  @override
  String get revenue => 'Доход';

  @override
  String get runtime => 'Длительность';

  @override
  String get syncDownloadedPlaylists => 'Синхронизировать загруженные плейлисты';

  @override
  String get downloadMissingImages => 'Загрузить отсутствующие изображения';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Загружено $count отсутствующих изображений',
      few: 'Загружено $count отсутствующих изображения',
      one: 'Загружено $count отсутствующее изображение',
      zero: 'Не найдено отсутствующих изображений',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Активные загрузки';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count загрузок',
      few: '$count загрузки',
      one: '$count загрузка',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount композиций',
      few: '$trackCount композиции',
      one: '$trackCount композиция',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount изображений',
      few: '$imageCount изображения',
      one: '$imageCount изображение',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount элементов синхронизируется',
      few: '$syncCount элемента синхронизируются',
      one: '$syncCount элемент синхронизируется',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nСейчас чинится',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count завершено';
  }

  @override
  String dlFailed(int count) {
    return '$count не удалось';
  }

  @override
  String dlEnqueued(int count) {
    return '$count в очереди';
  }

  @override
  String dlRunning(int count) {
    return '$count загружаются';
  }

  @override
  String get activeDownloadsTitle => 'Активные Загрузки';

  @override
  String get noActiveDownloads => 'Активных загрузок нет.';

  @override
  String get errorScreenError => 'Ошибка при получении списка ошибок! На данном этапе, вероятно, стоит создать сообщение об ошибке на GitHub и удалить данные приложения';

  @override
  String get failedToGetTrackFromDownloadId => 'Не удалось получить композицию по идентификатору загрузки';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'альбом',
        'playlist': 'плейлист',
        'artist': 'исполнителя',
        'genre': 'жанр',
        'track': 'композицию',
        'library': 'библиотеку',
        'other': 'элемент',
      },
    );
    return 'Вы уверены что хотите удалить $_temp0 \'$itemName\' с этого устройства?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Удалить';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Ошибка';

  @override
  String discNumber(int number) {
    return 'Диск $number';
  }

  @override
  String get playButtonLabel => 'Играть';

  @override
  String get shuffleButtonLabel => 'Перемешать';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиций',
      few: '$count Композиции',
      one: '$count Композиция',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиций',
      few: '$count Компоозиции',
      one: '$count Композиция',
    );
    return '$_temp0, $downloads загружено';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиций загружено',
      few: '$count Композиции загружено',
      one: '$count Композиция загружена',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Редактировать название плейлиста';

  @override
  String get editPlaylistNameTitle => 'Редактировать название плейлиста';

  @override
  String get required => 'Необходимо';

  @override
  String get updateButtonLabel => 'Обновить';

  @override
  String get playlistNameUpdated => 'Название плейлиста обновлено.';

  @override
  String get favourite => 'Избранное';

  @override
  String get downloadsDeleted => 'Загрузки удалены.';

  @override
  String get addDownloads => 'Добавить в загрузки';

  @override
  String get location => 'Расположение';

  @override
  String get confirmDownloadStarted => 'Загрузка началась';

  @override
  String get downloadsQueued => 'Загрузка подготовлена, загружаем файлы';

  @override
  String get addButtonLabel => 'Добавить';

  @override
  String get shareLogs => 'Поделиться журналом';

  @override
  String get logsCopied => 'Журнал скопирован.';

  @override
  String get message => 'Сообщение';

  @override
  String get stackTrace => 'Трассировка стека';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Лицензия Mozilla Public License 2.0.\nИсходный код доступен по адресу $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Транскодирование';

  @override
  String get downloadLocations => 'Расположение загрузок';

  @override
  String get audioService => 'Аудиосервис';

  @override
  String get interactions => 'Взаимодействие';

  @override
  String get layoutAndTheme => 'Компоновка и тема';

  @override
  String get notAvailableInOfflineMode => 'Недоступно в автономном режиме';

  @override
  String get logOut => 'Выйти';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Загруженные композиции не будут удалены';

  @override
  String get areYouSure => 'Вы уверены?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin использует AAC для транскодирования';

  @override
  String get enableTranscoding => 'Включить транскодирование';

  @override
  String get enableTranscodingSubtitle => 'Транскодирует музыкальные потоки на стороне сервера.';

  @override
  String get bitrate => 'Битрейт';

  @override
  String get bitrateSubtitle => 'Высокий битрейт обеспечивает лучшее качество звука за счет большего потребления трафика.';

  @override
  String get customLocation => 'Пользовательские папки';

  @override
  String get appDirectory => 'Папка приложения';

  @override
  String get addDownloadLocation => 'Добавить папку для загрузок';

  @override
  String get selectDirectory => 'Выбрать папку';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get pathReturnSlashErrorMessage => 'Пути ведущие к «/» нельзя использовать';

  @override
  String get directoryMustBeEmpty => 'Папка должна быть пустой';

  @override
  String get customLocationsBuggy => 'Пользовательские папки могут быть крайне нестабильны и не рекомендуются к использованию в подавляющем большинстве случаев. Расположение в пределах системной папки «Музыка» не позволяет сохранять обложки альбомов из-за ограничений операционной системы.';

  @override
  String get enterLowPriorityStateOnPause => 'Использовать режим низкого приоритета на паузе';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Позволяет смахнуть уведомление на паузе. Также позволяет Android остановить сервис на паузе.';

  @override
  String get shuffleAllTrackCount => 'Количество композиций случайного проигрывания';

  @override
  String get shuffleAllTrackCountSubtitle => 'Количество композиций для загрузки в режиме случайного проигрывания.';

  @override
  String get viewType => 'Способ отображения';

  @override
  String get viewTypeSubtitle => 'Способ отображения для экрана музыки';

  @override
  String get list => 'Список';

  @override
  String get grid => 'Сетка';

  @override
  String get customizationSettingsTitle => 'Персонализация';

  @override
  String get playbackSpeedControlSetting => 'Видимость скорости воспроизведения';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Показывать ли элементы управления скоростью воспроизведения в меню экрана плеера';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Автоматически:\nFinamp пытается определить, является ли воспроизводимая вами композиция подкастом или (частью) аудиокниги. Считается, что это так, если продолжительность композиции превышает $trackDuration минут, если продолжительность композиции альбома превышает $albumDuration часов, или если композиции присвоен хотя бы один из этих жанров: $genreList\nПосле этого элементы управления скоростью воспроизведения будут показаны в экранном меню проигрывателя.\n\nПоказывать:\nЭлементы управления скоростью воспроизведения всегда будут отображаться в экранном меню проигрывателя.\n\nСкрыть:\nЭлементы управления скоростью воспроизведения в экранном меню проигрывателя всегда скрыты.';
  }

  @override
  String get automatic => 'Автоматически';

  @override
  String get shown => 'Показывать';

  @override
  String get hidden => 'Скрыть';

  @override
  String get speed => 'Скорость';

  @override
  String get reset => 'Cбросить';

  @override
  String get apply => 'Применить';

  @override
  String get portrait => 'Портретный';

  @override
  String get landscape => 'Альбомный';

  @override
  String gridCrossAxisCount(String value) {
    return '$value, количество элементов сетки';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Количество отображаемых элементов сетки в строке, когда $value.';
  }

  @override
  String get showTextOnGridView => 'Показывать текст в режиме отображения сеткой';

  @override
  String get showTextOnGridViewSubtitle => 'Показывать ли текст (название, исполнитель и т.д.) на экране музыки в режиме отображения сеткой.';

  @override
  String get useCoverAsBackground => 'Показывать размытую обложку на фоне';

  @override
  String get useCoverAsBackgroundSubtitle => 'Использовать ли размытую обложку альбома в качестве фона в различных частях приложения.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Минимальный отступ для обложек альбомов';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Минимальный отступ вокруг обложки альбома на экране плеера, в % от ширины экрана.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Скрывать исполнителей композиций, если они совпадают с исполнителями альбома';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Показывать ли исполнителей композиций на экране альбома, если они не отличаются от исполнителей альбома.';

  @override
  String get showArtistsTopTracks => 'Показывать лучшие композиции в режиме просмотра исполнителя';

  @override
  String get showArtistsTopTracksSubtitle => 'Следует ли показывать топ-5 самых прослушиваемых композиций исполнителя.';

  @override
  String get disableGesture => 'Отключить жесты';

  @override
  String get disableGestureSubtitle => 'Стоит ли отключать жесты.';

  @override
  String get showFastScroller => 'Показать быструю прокрутку';

  @override
  String get theme => 'Тема';

  @override
  String get system => 'Системная';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get tabs => 'Вкладки';

  @override
  String get playerScreen => 'Экран проигрывателя';

  @override
  String get cancelSleepTimer => 'Сбросить таймер сна?';

  @override
  String get yesButtonLabel => 'Да';

  @override
  String get noButtonLabel => 'Нет';

  @override
  String get setSleepTimer => 'Установить таймер сна';

  @override
  String get hours => 'Часов';

  @override
  String get seconds => 'Секунд';

  @override
  String get minutes => 'Минуты';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime из $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Композиция $currentTrackIndex из $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Недопустимое число';

  @override
  String get sleepTimerTooltip => 'Таймер сна';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Заснёт через $time минут';
  }

  @override
  String get addToPlaylistTooltip => 'Добавить в плейлист';

  @override
  String get addToPlaylistTitle => 'Добавить в плейлист';

  @override
  String get addToMorePlaylistsTooltip => 'Добавить в другие плейлисты';

  @override
  String get addToMorePlaylistsTitle => 'Добавить в другие плейлисты';

  @override
  String get removeFromPlaylistTooltip => 'Удалить из плейлиста';

  @override
  String get removeFromPlaylistTitle => 'Удалить из плейлиста';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Удалить из плейлиста \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Удалить из плейлиста \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Новый плейлист';

  @override
  String get createButtonLabel => 'Создать';

  @override
  String get playlistCreated => 'Плейлист создан.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Нажмите, чтобы добавить в плейлист. Нажмите и удерживайте, чтобы добавить/убрать из избранного.';

  @override
  String get noAlbum => 'Нет альбома';

  @override
  String get noItem => 'Нет элемента';

  @override
  String get noArtist => 'Нет исполнителя';

  @override
  String get unknownArtist => 'Неизвестный исполнитель';

  @override
  String get unknownAlbum => 'Неизвестный альбом';

  @override
  String get playbackModeDirectPlaying => 'Прямое воспроизведение';

  @override
  String get playbackModeTranscoding => 'Транскодирование';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate Кбит/с';
  }

  @override
  String get playbackModeLocal => 'Локальное воспроизведение';

  @override
  String get queue => 'Очередь';

  @override
  String get addToQueue => 'Добавить в очередь';

  @override
  String get replaceQueue => 'Заменить очередь';

  @override
  String get instantMix => 'Мгновенный микс';

  @override
  String get goToAlbum => 'Перейти к альбому';

  @override
  String get goToArtist => 'Перейти к исполнителю';

  @override
  String get goToGenre => 'Перейти к жанру';

  @override
  String get removeFavourite => 'Удалить из избранного';

  @override
  String get addFavourite => 'Добавить в избранное';

  @override
  String get confirmFavoriteAdded => 'Добавлено в избранное';

  @override
  String get confirmFavoriteRemoved => 'Удалено из избранного';

  @override
  String get addedToQueue => 'Добавлено в очередь.';

  @override
  String get insertedIntoQueue => 'Вставлено в очередь.';

  @override
  String get queueReplaced => 'Очередь заменена.';

  @override
  String get confirmAddedToPlaylist => 'Добавлено в плейлист.';

  @override
  String get removedFromPlaylist => 'Удалено из плейлиста.';

  @override
  String get startingInstantMix => 'Запуск мгновенного микса.';

  @override
  String get anErrorHasOccured => 'Произошла ошибка.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Код состояния $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Код состояния $statusCode. Возможно, вы использовали неверное имя пользователя/пароль или ваш клиент больше не авторизован.';
  }

  @override
  String get removeFromMix => 'Удалить из микса';

  @override
  String get addToMix => 'Добавить в микс';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Повторно загружено $count элементов',
      few: 'Повторно загружены $count элемента',
      one: 'Повторно загружен $count элемент',
      zero: 'Не требуется повторная загрузка.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Длительность буфера';

  @override
  String get bufferDurationSubtitle => 'Максимальная длительность, которая должна быть буферизована, в секундах. Требует перезапуска.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Не ограничивать размер буфера';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Отключает ограничения размера буфера («Размер буфера»). Буфер всегда будет загружаться до заданной длительности («Длительность буфера»), даже для очень больших файлов. Может вызывать сбои. Требует перезапуска.';

  @override
  String get bufferSizeTitle => 'Размер буфера';

  @override
  String get bufferSizeSubtitle => '­Максимальный размер буфера в МБ. Требует перезапуска';

  @override
  String get language => 'Язык';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Перейти к началу или к предыдущей композиции';

  @override
  String get skipToNextTrackButtonTooltip => 'Перейти к следующей композиции';

  @override
  String get togglePlaybackButtonTooltip => 'Начать/Остановить воспроизведение';

  @override
  String get previousTracks => 'Предыдущие композиции';

  @override
  String get nextUp => 'Следующие';

  @override
  String get clearNextUp => 'Очистить следующие';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Играем с';

  @override
  String get playNext => 'Воспроизвести следующим';

  @override
  String get addToNextUp => 'Добавить следующим';

  @override
  String get shuffleNext => 'Воспроизвести следующим вперемешку';

  @override
  String get shuffleToNextUp => 'Добавить следующим вперемешку';

  @override
  String get shuffleToQueue => 'Добавить в очередь вперемешку';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Композиция',
        'album': 'Альбом',
        'artist': 'Исполнитель',
        'playlist': 'Плейлист',
        'genre': 'Жанр',
        'other': 'Элемент',
      },
    );
    return '$_temp0 будет играть дальше';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Композиция добавлена',
        'album': 'Альбом добавлен',
        'artist': 'Исполнитель добавлен',
        'playlist': 'Плейлист добавлен',
        'genre': 'Жанр добавлен',
        'other': 'Элемент добавлен',
      },
    );
    return '$_temp0 следующим';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Композиция добавлена',
        'album': 'Альбом добавлен',
        'artist': 'Исполнитель добавлен',
        'playlist': 'Плейлист добавлен',
        'genre': 'Жанр добавлен',
        'other': 'Элемент добавлен',
      },
    );
    return '$_temp0 в очередь';
  }

  @override
  String get confirmShuffleNext => 'Воспроизведется следующим вперемешку';

  @override
  String get confirmShuffleToNextUp => 'Добавлено следующим вперемешку';

  @override
  String get confirmShuffleToQueue => 'Добавлено в очередь вперемешку';

  @override
  String get placeholderSource => 'Где-то';

  @override
  String get playbackHistory => 'История воспроизведения';

  @override
  String get shareOfflineListens => 'Поделиться прослушиваниями в офлайн-режиме';

  @override
  String get yourLikes => 'Ваши избранные';

  @override
  String mix(String mixSource) {
    return '$mixSource - Микс';
  }

  @override
  String get tracksFormerNextUp => 'Композиции добавленные следующими';

  @override
  String get savedQueue => 'Сохраненная очередь';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'альбома',
        'playlist': 'плейлиста',
        'trackMix': 'микса композиций',
        'artistMix': 'микса исполнителей',
        'albumMix': 'микса альбомов',
        'genreMix': 'микса жанров',
        'favorites': 'избранного',
        'allTracks': 'всех композиций',
        'filteredList': 'композиций',
        'genre': 'жанра',
        'artist': 'исполнителя',
        'track': 'композиции',
        'nextUpAlbum': 'альбома в следующих',
        'nextUpPlaylist': 'плейлиста в следующих',
        'nextUpArtist': 'исполнителя в следующих',
        'other': '',
      },
    );
    return 'Воспроизведение из $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Все вперемешку';

  @override
  String get playbackOrderLinearButtonLabel => 'Играем по порядку';

  @override
  String get playbackOrderLinearButtonTooltip => 'Играем по порядку. Нажмите чтобы играть вперемешку.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Играем вперемешку';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Играем вперемешку. Нажмите чтобы играть по порядку.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Играем на скорости x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'Скорость x$speed';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Уменьшить скорость воспроизведения';

  @override
  String get playbackSpeedIncreaseLabel => 'Увеличить скорость воспроизведения';

  @override
  String get loopModeNoneButtonLabel => 'Без повторений';

  @override
  String get loopModeOneButtonLabel => 'Повторяем эту композицию';

  @override
  String get loopModeAllButtonLabel => 'Повторяем всё';

  @override
  String get queuesScreen => 'Восстановить очередь';

  @override
  String get queueRestoreButtonLabel => 'Восстановить';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Сохранено $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Воспроизводится: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Композиций',
      few: '$count Композиции',
      one: '1 Композиция',
    );
    return '$_temp0, $remaining Не проиграно';
  }

  @override
  String get queueLoadingMessage => 'Восстанавливаем очередь...';

  @override
  String get queueRetryMessage => 'Ошибка восстановления очереди. Попробовать еще раз?';

  @override
  String get autoloadLastQueueOnStartup => 'Восстанавливать последнюю очередь автоматически';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'При запуске приложения пытаться восстанавливать последнюю очередь воспроизведения.';

  @override
  String get reportQueueToServer => 'Отправлять текущую очередь на сервер?';

  @override
  String get reportQueueToServerSubtitle => 'Если включено, Finamp будет отправлять текущую очередь на сервер. В настоящее время от этого нет особой пользы и это увеличивает сетевой трафик.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Частота обновлений сессии воспроизведения';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Как часто отправлять текущий статус воспроизведения на сервер, в секундах. Это значение должно быть меньше 5 минут (300 секунд), чтобы предотвратить тайм-аут сессии.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Если сервер Jellyfin не получал никаких обновлений от клиента в течение последних 5 минут, он предполагает, что воспроизведение завершилось. Это означает, что для композиций длиннее 5 минут воспроизведение может быть неправильно зарегистрировано как завершенное, что снижает качество данных о воспроизведении.';

  @override
  String get topTracks => 'Лучшие композиции';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Альбомов',
      few: '$count Альбома',
      one: '$count Альбом',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Альбомы вперемешку';

  @override
  String get shuffleAlbumsNext => 'Воспроизвести альбомы следующими вперемешку';

  @override
  String get shuffleAlbumsToNextUp => 'Добавить альбомы следующими вперемешку';

  @override
  String get shuffleAlbumsToQueue => 'Добавить альбомы в очередь вперемешку';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount воспроизведений',
      few: '$playCount воспроизведения',
      one: '$playCount воспроизведение',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'альбом',
        'playlist': 'плейлист',
        'trackMix': 'микс композиций',
        'artistMix': 'микс исполнителей',
        'albumMix': 'микс альбомов',
        'genreMix': 'микс жанров',
        'favorites': 'избранное',
        'allTracks': 'все композиции',
        'filteredList': 'композиции',
        'genre': 'жанр',
        'artist': 'исполнителя',
        'track': 'композицию',
        'nextUpAlbum': 'альбом в следующих',
        'nextUpPlaylist': 'плейлист в следующих',
        'nextUpArtist': 'исполнителя в следующих',
        'other': '',
      },
    );
    return 'Не удалось загрузить $_temp0';
  }

  @override
  String get confirm => 'Подтвердить';

  @override
  String get close => 'Закрыть';

  @override
  String get showUncensoredLogMessage => 'Этот журнал содержит ваши данные для входа. Показать?';

  @override
  String get resetTabs => 'Сбросить вкладки';

  @override
  String get resetToDefaults => 'Сброс к настойкам по умолчанию';

  @override
  String get noMusicLibrariesTitle => 'Нет музыкальных библиотек';

  @override
  String get noMusicLibrariesBody => 'Finamp не обнаружил музыкальных библиотек. Убедитесь, что на вашем сервере Jellyfin есть хотя бы одна библиотека с типом контента «Музыка».';

  @override
  String get refresh => 'Обновить';

  @override
  String get moreInfo => 'Больше информации';

  @override
  String get volumeNormalizationSettingsTitle => 'Нормализация громкости';

  @override
  String get volumeNormalizationSwitchTitle => 'Включить нормализацию громкости';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Использовать информацию об усилении для нормализации громкости композиций («Replay Gain»)';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Режим нормализации громкости';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Когда и как применять нормализацию громкости';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Гибридный (Композиция + Альбом):\nУровень громкости композиции используется при обычном воспроизведении, но если воспроизводится альбом (либо потому, что он является основным источником очереди воспроизведения, либо потому, что был добавлен в очередь в какой-то момент), используется уровень громкости альбома.\n\nНа основе композиции:\nУровень громкости композиции используется всегда, независимо от того, воспроизводится альбом или нет.\n\nТолько для альбомов:\nНормализация громкости применяется только при воспроизведении альбомов (с использованием уровня громкости альбома), но не для отдельных композиций.';

  @override
  String get volumeNormalizationModeHybrid => 'Гибридный (Композиция + Альбом)';

  @override
  String get volumeNormalizationModeTrackBased => 'На основе композиции';

  @override
  String get volumeNormalizationModeAlbumBased => 'На основе альбома';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Только для альбомов';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Базовое усиление';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'В настоящее время нормализация громкости на iOS требует изменения громкости воспроизведения, чтобы эмулировать изменение усиления. Поскольку мы не можем увеличить громкость выше 100%, нам необходимо уменьшить громкость по умолчанию, чтобы мы могли увеличить громкость тихих композиций. Значение указывается в децибелах (дБ), где -10 дБ соответствует ~30% громкости, -4,5 дБ - ~60% громкости, а -2 дБ - ~80% громкости.';

  @override
  String numberAsDecibel(double value) {
    return '$value дБ';
  }

  @override
  String get swipeInsertQueueNext => 'Воспроизвести смахнутую композицию следующей';

  @override
  String get swipeInsertQueueNextSubtitle => 'Включите чтобы вставлять композицию следующей в очереди при смахивании в списке композиций вместо того чтобы добавлять ее в конец.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Запускать мгновенные миксы для отдельных композиций';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Если включено, нажатие на композицию во вкладке «Композиции» запустит мгновенный микс этой композиции, вместо того, чтобы просто воспроизвести одну композицию.';

  @override
  String get downloadItem => 'Загрузить';

  @override
  String get repairComplete => 'Починка загрузок завершена.';

  @override
  String get syncComplete => 'Все загрузки повторно синхронизированы.';

  @override
  String get syncDownloads => 'Синхронизировать и загрузить отсутствующие элементы.';

  @override
  String get repairDownloads => 'Исправить проблемы с загруженными файлами или метаданными.';

  @override
  String get requireWifiForDownloads => 'Требовать WiFi при загрузке.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count композиций не могут быть восстановлены в очередь',
      few: '$count композиции не могут быть восстановлены в очередь',
      one: '$count композиция не может быть восстановлена в очередь',
    );
    return 'Предупреждение: $_temp0.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Запущено',
        'failed': 'Не удалось',
        'syncFailed': 'Повторно не синхронизировано',
        'enqueued': 'В очереди',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Загрузок',
      few: 'Загрузки',
      one: 'Загрузка',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Вы уверены, что хотите загрузить все содержимое библиотеки \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Показывать только полностью загруженные альбомы';

  @override
  String get filesystemFull => 'Оставшиеся загрузки не могут быть завершены. Файловая система заполнена.';

  @override
  String get connectionInterrupted => 'Соединение прервано, загрузки приостановлены.';

  @override
  String get connectionInterruptedBackground => 'Соединение было прервано во время загрузки в фоновом режиме. Это может быть вызвано настройками операционной системы.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Соединение было прервано во время загрузки в фоновом режиме. Это может быть вызвано включением опции «Использовать режим низкого приоритета на паузе» или настройками операционной системы.';

  @override
  String get activeDownloadSize => 'Загружается...';

  @override
  String get missingDownloadSize => 'Удаляется...';

  @override
  String get syncingDownloadSize => 'Синхронизируется...';

  @override
  String get runRepairWarning => 'Не удалось связаться с сервером для завершения миграции загрузок. Пожалуйста, выполните «Починку загрузок» на экране загрузок, как только подключение восстановится.';

  @override
  String get downloadSettings => 'Загрузки';

  @override
  String get showNullLibraryItemsTitle => 'Показать медиа из неизвестной библиотеки.';

  @override
  String get showNullLibraryItemsSubtitle => 'Некоторые медиафайлы могут быть загружены из неизвестной библиотеки. Отключите эту опцию, чтобы скрыть их вне исходной коллекции.';

  @override
  String get maxConcurrentDownloads => 'Максимальное количество одновременных загрузок';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Увеличение количества одновременных загрузок может способствовать более эффективной загрузке в фоновом режиме, но может привести к сбоям некоторых загрузок, если они очень большие, или вызвать значительную задержку в некоторых случаях.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Одновременных загрузок';
  }

  @override
  String get downloadsWorkersSetting => 'Количество потоков-загрузчиков';

  @override
  String get downloadsWorkersSettingSubtitle => 'Количество рабочих потоков для синхронизации метаданных и удаления загрузок. Увеличение количества потоков-загрузчиков может ускорить синхронизацию загрузок и удаление, особенно при высокой задержке сервера, но может вызвать задержки.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Потоков-загрузчиков';
  }

  @override
  String get syncOnStartupSwitch => 'Автоматически синхронизировать загрузки при запуске';

  @override
  String get preferQuickSyncSwitch => 'Предпочитать быструю синхронизацию';

  @override
  String get preferQuickSyncSwitchSubtitle => 'При выполнении синхронизаций некоторые обычно статичные элементы (такие как композиции и альбомы) не будут обновляться. Починка загрузки всегда будет выполнять полную синхронизацию.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Альбом',
        'playlist': 'Плейлист',
        'artist': 'Артист',
        'genre': 'Жанр',
        'track': 'Композиция',
        'library': 'Библиотека',
        'unknown': 'Элемент',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'Этот элемент должен быть загружен через $parentName.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Избранные',
        'allPlaylists': 'Все плейлисты',
        'fiveLatestAlbums': '5 Последних альбомов',
        'allPlaylistsMetadata': 'Метаданные плейлиста',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Изображения в кэше для \'$libraryName\'';
  }

  @override
  String get transcodingStreamingContainerTitle => 'Выбор контейнера для транскодирования';

  @override
  String get transcodingStreamingContainerSubtitle => 'Выберите контейнер для сегментов при использовании потоковой передачи транскодированного аудио. Уже добавленные в очередь композиции не будут затронуты.';

  @override
  String get downloadTranscodeEnableTitle => 'Включить транскодированные загрузки';

  @override
  String get downloadTranscodeCodecTitle => 'Выбор кодека для загрузки';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Всегда',
        'never': 'Никогда',
        'ask': 'Спрашивать',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Битрейт загрузки';

  @override
  String get downloadBitrateSubtitle => 'Более высокий битрейт обеспечивает лучшее качество звука, но требует больше места для хранения.';

  @override
  String get transcodeHint => 'Транскодировать?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Загрузить как $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Транскодировано',
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
    return 'Загрузить оригинал$_temp0';
  }

  @override
  String get redownloadcomplete => 'Перезагрузка транскодируемых дорожек добавлена в очередь.';

  @override
  String get redownloadTitle => 'Автоматически перезагружать транскодируемые дорожки';

  @override
  String get redownloadSubtitle => 'Автоматически перезагружать композиции, которые, как ожидается, будут иметь другое качество из-за изменений в родительской коллекции.';

  @override
  String get defaultDownloadLocationButton => 'Установить как место загрузки по умолчанию.  Отключите, чтобы выбирать для каждой загрузки.';

  @override
  String get fixedGridSizeSwitchTitle => 'Использовать плитки фиксированного размера';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Размеры плиток в сетке не будут изменяться в зависимости от размера окна/экрана.';

  @override
  String get fixedGridSizeTitle => 'Размер плитки в сетке';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Маленький',
        'medium': 'Средний',
        'large': 'Большой',
        'veryLarge': 'Очень большой',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Разрешить режим разделения экрана';

  @override
  String get allowSplitScreenSubtitle => 'Плеер будет отображаться рядом с другими элементами на широких экранах.';

  @override
  String get enableVibration => 'Включить вибрацию';

  @override
  String get enableVibrationSubtitle => 'Включать ли вибрацию.';

  @override
  String get hideQueueButton => 'Спрятать кнопку очереди';

  @override
  String get hideQueueButtonSubtitle => 'Спрячьте кнопку очереди на экране проигрывателя. Проведите вверх, чтобы открыть очередь.';

  @override
  String get oneLineMarqueeTextButton => 'Автопрокрутка длинных заголовков';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Автоматическая прокрутка названий композиций, которые не помещаются в две строки';

  @override
  String get marqueeOrTruncateButton => 'Использовать многоточие в длинных заголовках';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Показывать «...» в конце длинных заголовков вместо прокрутки текста';

  @override
  String get hidePlayerBottomActions => 'Скрыть действия снизу';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Скрыть кнопки очереди и текста песен на экране плеера. Проведите вверх, чтобы получить доступ к очереди, проведите влево (под обложкой альбома), чтобы просмотреть текст песни, если он доступен.';

  @override
  String get prioritizePlayerCover => 'Приоритет обложки альбома';

  @override
  String get prioritizePlayerCoverSubtitle => 'Приоритизировать отображение большей обложки альбома на экране плеера. Некритические элементы управления будут скрываться более агрессивно на экранах меньшего размера.';

  @override
  String get suppressPlayerPadding => 'Минимизировать отступы элементов управления плеером';

  @override
  String get suppressPlayerPaddingSubtitle => 'Полностью минимизирует отступы между элементами управления на экране плеера, когда обложка альбома не занимает весь экран.';

  @override
  String get lockDownload => 'Всегда хранить на устройстве';

  @override
  String get showArtistChipImage => 'Показывать изображения исполнителя с именем исполнителя';

  @override
  String get showArtistChipImageSubtitle => 'Это влияет на превью небольших изображений исполнителя, например, на экране плеера.';

  @override
  String get scrollToCurrentTrack => 'Вернуться к текущей композиции';

  @override
  String get enableAutoScroll => 'Включить автоматическое прокручивание';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz кГц';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit бит';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration осталось';
  }

  @override
  String get removeFromPlaylistConfirm => 'Убрать';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Убрать \'$itemName\' из плейлиста \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Меню композиций';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get addRemoveFromPlaylist => 'Добавить в / Удалить из плейлистов';

  @override
  String get addPlaylistSubheader => 'Добавить композицию в плейлист';

  @override
  String get trackOfflineFavorites => 'Синхронизировать все статусы избранного';

  @override
  String get trackOfflineFavoritesSubtitle => 'Это позволяет отображать более актуальные статусы избранного в автономном режиме.  Не загружает никаких дополнительных файлов.';

  @override
  String get allPlaylistsInfoSetting => 'Загрузить метаданные плейлистов';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Синхронизируйте метаданные для всех плейлистов, чтобы улучшить работу с плейлистами';

  @override
  String get downloadFavoritesSetting => 'Загрузить все избранные';

  @override
  String get downloadAllPlaylistsSetting => 'Загрузить все плейлисты';

  @override
  String get fiveLatestAlbumsSetting => 'Загрузить 5 последних альбомов';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Загруженные файлы будут удаляться со временем.  Заблокируйте загрузку, чтобы предотвратить удаление альбома.';

  @override
  String get cacheLibraryImagesSettings => 'Кэшировать текущие изображения библиотеки';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Все обложки альбомов, исполнителей, жанров и плейлистов в текущей активной библиотеке будут загружены.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Показывать прогресс воспроизведения композиции в мини-плеере приложения';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Управляет тем, будет ли мини-плеер в приложении / панель «сейчас играет» в нижней части экрана музыки функционировать как индикатор прогресса.';

  @override
  String get lyricsScreen => 'Просмотр текста песни';

  @override
  String get showLyricsTimestampsTitle => 'Показывать метки времени для синхронизированных текстов песен';

  @override
  String get showLyricsTimestampsSubtitle => 'Управляет тем, будут ли показываться метки времени для каждой строки текста песни в просмотре текстов, если они доступны.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Показывать кнопку остановки в медиа-уведомлении';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Управляет тем, будет ли в медиа-уведомлении присутствовать кнопка остановки в дополнение к кнопке паузы. Это позволяет вам останавливать воспроизведение, не открывая приложение.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Показывать элементы управления перемоткой в медиа-уведомлении';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Управляет тем, будет ли в медиа-уведомлении присутствовать регулируемая полоса прогресса. Это даст вам возможность перемещаться по композиции, не открывая приложение.';

  @override
  String get alignmentOptionStart => 'Слева';

  @override
  String get alignmentOptionCenter => 'По центру';

  @override
  String get alignmentOptionEnd => 'Справа';

  @override
  String get fontSizeOptionSmall => 'Маленький';

  @override
  String get fontSizeOptionMedium => 'Средний';

  @override
  String get fontSizeOptionLarge => 'Большой';

  @override
  String get lyricsAlignmentTitle => 'Расположение текста песен';

  @override
  String get lyricsAlignmentSubtitle => 'Управляет расположением текста песен в просмотре текстов песен.';

  @override
  String get lyricsFontSizeTitle => 'Размер шрифта текстов песен';

  @override
  String get lyricsFontSizeSubtitle => 'Управляет размером шрифта текстов песен в просмотре текстов.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Показывать альбом перед текстом песни';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Управляет тем, будет ли показываться обложка альбома над текстом песни, прежде чем она будет прокручена.';

  @override
  String get keepScreenOn => 'Не отключать экран';

  @override
  String get keepScreenOnSubtitle => 'Когда держать экран включенным';

  @override
  String get keepScreenOnDisabled => 'Отключено';

  @override
  String get keepScreenOnAlwaysOn => 'Всегда включен';

  @override
  String get keepScreenOnWhilePlaying => 'Пока играет музыка';

  @override
  String get keepScreenOnWhileLyrics => 'Пока отображаются тексты песен';

  @override
  String get keepScreenOnWhilePluggedIn => 'Не отключать экран только на зарядке';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Игнорировать настройку «Не отключать экран», если устройство не подключено к сети';

  @override
  String get genericToggleButtonTooltip => 'Нажмите, чтобы переключить.';

  @override
  String get artwork => 'Обложка';

  @override
  String artworkTooltip(String title) {
    return 'Обложка для $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Обложка для $title. Нажмите, чтобы переключить воспроизведение. Проведите влево или вправо, чтобы переключить композиции.';
  }

  @override
  String get nowPlayingBarTooltip => 'Открыть экран плеера';

  @override
  String get additionalPeople => 'Люди';

  @override
  String get playbackMode => 'Режим воспроизведения';

  @override
  String get codec => 'Кодек';

  @override
  String get bitRate => 'Битрейт';

  @override
  String get bitDepth => 'Разрядность';

  @override
  String get size => 'Размер';

  @override
  String get normalizationGain => 'Усиление';

  @override
  String get sampleRate => 'Частота дискретизации';

  @override
  String get showFeatureChipsToggleTitle => 'Показать расширенную информацию о композиции';

  @override
  String get showFeatureChipsToggleSubtitle => 'Показывать расширенную информацию о композиции, такую как кодек, битрейт и другие данные, на экране плеера.';

  @override
  String get albumScreen => 'Экран альбома';

  @override
  String get showCoversOnAlbumScreenTitle => 'Показывать обложки альбомов для композиций';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Показывать обложки альбомов для каждой композиции отдельно на экране альбома.';

  @override
  String get emptyTopTracksList => 'Вы еще не прослушали ни одной композиции этого исполнителя.';

  @override
  String get emptyFilteredListTitle => 'Ничего не найдено';

  @override
  String get emptyFilteredListSubtitle => 'Ни один элемент не соответствует фильтру. Попробуйте отключить фильтр или изменить поисковый запрос.';

  @override
  String get resetFiltersButton => 'Сбросить фильтры';

  @override
  String get resetSettingsPromptGlobal => 'Вы уверены, что хотите сбросить ВСЕ настройки к значениям по умолчанию?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Сбросить ВСЕ настройки';

  @override
  String get resetSettingsPromptLocal => 'Вы хотите сбросить эти настройки к значениям по умолчанию?';

  @override
  String get genericCancel => 'Отмена';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Альбом был удален',
        'playlist': 'Плейлист был удален',
        'artist': 'Исполнитель был удален',
        'genre': 'Жанр был удален',
        'track': 'Композиция была удалена',
        'library': 'Библиотека была удалена',
        'other': 'Элемент был удален',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'устройства',
        'server': 'сервера',
        'other': 'неизвестно',
      },
    );
    return '$_temp0 с $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Разрешить удалять с сервера';

  @override
  String get allowDeleteFromServerSubtitle => 'Включить или отключить возможность перманентного удаления композиции с файловой системы сервера когда удаление возможно.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'этот альбом',
        'playlist': 'этот плейлист',
        'artist': 'этого исполнителя',
        'genre': 'этот жанр',
        'track': 'эту композицию',
        'library': 'эту библиотеку',
        'other': 'этот элемент',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Это также удалит этот элемент с вашего устройства.',
        'cantDelete': ' Этот элемент останется на вашем устройстве до следующей синхронизации.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'этого устройства',
        'server': 'файловой системы сервера и библиотеки.$_temp1\nЭто действие не может быть отменено',
        'other': '',
      },
    );
    return 'Вы собираетесь удалить $_temp0 с $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' с устройства',
        'server': ' с сервера',
        'other': '',
      },
    );
    return 'Удалить$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Внимание: Вы собираетесь загрузить $count композиций.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Порог предупреждения размера загрузки';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'При одновременной загрузке более чем этого количества композиций будет показано предупреждение.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'из альбома',
        'playlist': 'из плейлиста',
        'artist': 'исполнителя',
        'genre': 'жанра',
        'other': 'из элемента',
      },
    );
    return 'Вы уверены что хотите добавить все композиции $_temp0 \'$itemName\' в этот плейлист?  Их можно удалить только по отдельности.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Видно всем:';

  @override
  String get releaseDateFormatYear => 'Год';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Месяц и год';

  @override
  String get releaseDateFormatMonthDayYear => 'Месяц, день и год';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Отображать дату выхода альбома на экране проигрывателя';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Отображать дату выхода альбома на экране проигрывателя под названием альбома.';

  @override
  String get releaseDateFormatTitle => 'Формат даты выхода';

  @override
  String get releaseDateFormatSubtitle => 'Определяет формат всех дат выхода, отображаемых в приложении.';

  @override
  String get librarySelectError => 'Error loading available libraries for user';
}
