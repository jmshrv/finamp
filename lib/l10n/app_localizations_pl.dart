// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Otwartoźrodłowy odtwarzacz muzyki dla Jellyfin';

  @override
  String startupError(String error) {
    return 'Coś poszło nie tak podczas startu aplikacji. Wystąpił błąd : $error\n\nProszę utworzyć zgłoszenie (https://github.com/jmshrv/finamp) wraz ze zrzutem ekranu. Jeśli problem będzie się powtarzać, usuń dane aplikacji.';
  }

  @override
  String get about => 'O Finamp';

  @override
  String get aboutContributionPrompt => 'Stworzone przez niesamowitych ludzi w ich wolnym czasie.\nMożesz być jednym z nich!';

  @override
  String get aboutContributionLink => 'Wnieś swój wkład do Finamp na GitHub:';

  @override
  String get aboutReleaseNotes => 'Przeczytaj najnowsze informacje o wydaniu:';

  @override
  String get aboutTranslations => 'Pomóż przetłumaczyć Finamp na Twój język:';

  @override
  String get aboutThanks => 'Dziękujemy za korzystanie z Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Witamy w';

  @override
  String get loginFlowSlogan => 'Twoja muzyka, tak jak chcesz.';

  @override
  String get loginFlowGetStarted => 'Zaczynamy!';

  @override
  String get viewLogs => 'Zobacz Logi';

  @override
  String get changeLanguage => 'Zmień Język';

  @override
  String get loginFlowServerSelectionHeading => 'Połącz z Jellyfin';

  @override
  String get back => 'Powrót';

  @override
  String get serverUrl => 'Adres URL serwera';

  @override
  String get internalExternalIpExplanation => 'Aby uzyskać zdalny dostęp do serwera Jellyfin, należy użyć zewnętrznego adresu IP.\n\nJeśli twój serwer znajduje się na porcie HTTP (80/443) lub domyślnym porcie Jellyfin (8096), nie musisz określać portu. Będzie tak prawdopodobnie w przypadku, gdy serwer znajduje się za odwrotnym serwerem proxy\n\nJeśli adres URL jest poprawny, poniżej pola wprowadzania powinny pojawić się informacje o serwerze.';

  @override
  String get serverUrlHint => 'np. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Pomoc dot. adresu URL serwera';

  @override
  String get emptyServerUrl => 'Adres URL serwera nie może być pusty';

  @override
  String get connectingToServer => 'Łączenie z serwerem...';

  @override
  String get loginFlowLocalNetworkServers => 'Serwery w twojej sieci lokalnej:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Wyszukiwanie serwerów...';

  @override
  String get loginFlowAccountSelectionHeading => 'Wybierz konto';

  @override
  String get backToServerSelection => 'Wróć do wyboru serwera';

  @override
  String get loginFlowNamelessUser => 'Nienazwany Użytkownik';

  @override
  String get loginFlowCustomUser => 'Inny Użytkownik';

  @override
  String get loginFlowAuthenticationHeading => 'Zaloguj się na swoje konto';

  @override
  String get backToAccountSelection => 'Wróć do wyboru konta';

  @override
  String get loginFlowQuickConnectPrompt => 'Użyj kodu Szybkiego Łączenia';

  @override
  String get loginFlowQuickConnectInstructions => 'Otwórz aplikację Jellyfin lub stronę internetową, kliknij ikonę użytkownika i wybierz opcję Szybkie łączenie.';

  @override
  String get loginFlowQuickConnectDisabled => 'Szybkie łączenie jest wyłączone na tym serwerze.';

  @override
  String get orDivider => 'lub';

  @override
  String get loginFlowSelectAUser => 'Wybierz użytkownika';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get usernameHint => 'Wprowadź swoją nazwę użytkownika';

  @override
  String get usernameValidationMissingUsername => 'Proszę wprowadzić nazwę użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get passwordHint => 'Wprowadź hasło';

  @override
  String get login => 'Zaloguj się';

  @override
  String get logs => 'Logi';

  @override
  String get next => 'Dalej';

  @override
  String get selectMusicLibraries => 'Wybierz biblioteki z muzyką';

  @override
  String get couldNotFindLibraries => 'Nie znaleziono żadnych bibliotek.';

  @override
  String get unknownName => 'Bez nazwy';

  @override
  String get tracks => 'Utwory';

  @override
  String get albums => 'Albumy';

  @override
  String get artists => 'Wykonawcy';

  @override
  String get genres => 'Gatunki';

  @override
  String get playlists => 'Listy odtwarzania';

  @override
  String get startMix => 'Rozpocznij mix';

  @override
  String get startMixNoTracksArtist => 'Kliknij i przytrzymaj nazwę wykonawcy, aby dodać go do mix-u przed jego rozpoczęciem';

  @override
  String get startMixNoTracksAlbum => 'Kliknij i przytrzymaj nazwę albumu, aby dodać go do mix-u przed jego rozpoczęciem';

  @override
  String get startMixNoTracksGenre => 'Naciśnij i przytrzymaj gatunek, aby dodać lub usunąć go z kreatora miksów przed rozpoczęciem miksowania';

  @override
  String get music => 'Muzyka';

  @override
  String get clear => 'Wyczyść';

  @override
  String get favourites => 'Ulubione';

  @override
  String get shuffleAll => 'Losuj wszystko';

  @override
  String get downloads => 'Pobrane';

  @override
  String get settings => 'Ustawienia';

  @override
  String get offlineMode => 'Tryb offline';

  @override
  String get sortOrder => 'Porządek sortowania';

  @override
  String get sortBy => 'Sortuj według';

  @override
  String get title => 'Tytuł';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Wykonawca albumu';

  @override
  String get artist => 'Wykonawca';

  @override
  String get budget => 'Budżet';

  @override
  String get communityRating => 'Ocena społeczności';

  @override
  String get criticRating => 'Ocena krytyków';

  @override
  String get dateAdded => 'Data dodania';

  @override
  String get datePlayed => 'Data odtwarzania';

  @override
  String get playCount => 'Liczba odtworzeń';

  @override
  String get premiereDate => 'Data premiery';

  @override
  String get productionYear => 'Rok produkcji';

  @override
  String get name => 'Nazwa';

  @override
  String get random => 'Losowo';

  @override
  String get revenue => 'Dochód';

  @override
  String get runtime => 'Czas trwania';

  @override
  String get syncDownloadedPlaylists => 'Synchronizuj pobrane playlisty';

  @override
  String get downloadMissingImages => 'Pobierz brakujące obrazy';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pobrano $count brakujących obrazów',
      one: 'Pobrano $count brakujący obraz',
      zero: 'Nie brakuje żadnych obrazów',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Aktywne pobrania';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pobrań',
      one: '$count pobranie',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount utworów',
      few: '$trackCount utwory',
      one: '$trackCount utwór',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount obrazów',
      few: '$imageCount obrazy',
      one: '$imageCount obraz',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount nodes syncing',
      one: '$syncCount node syncing',
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
    return '$count ukończono pomyślnie';
  }

  @override
  String dlFailed(int count) {
    return '$count ukończono z błędami';
  }

  @override
  String dlEnqueued(int count) {
    return '$count oczekuje';
  }

  @override
  String dlRunning(int count) {
    return '$count w trakcie';
  }

  @override
  String get activeDownloadsTitle => 'Aktywne pobrania';

  @override
  String get noActiveDownloads => 'Brak aktywnych pobrań.';

  @override
  String get errorScreenError => 'Wystąpił błąd podczas pobierania listy błędów. Utwórz zgłoszenie na portalu GitHub i usuń dane aplikacji';

  @override
  String get failedToGetTrackFromDownloadId => 'Nie udało się pobrać utworu z ID pobierania';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'listę odtwarzania',
        'artist': 'artystę',
        'genre': 'gatunek',
        'track': 'utwór',
        'library': 'bibliotekę',
        'other': 'element',
      },
    );
    return 'Czy na pewno chcesz usunąć $_temp0 \'$itemName\' z tego urządzenia?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Usuń';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Błąd';

  @override
  String discNumber(int number) {
    return 'Dysk $number';
  }

  @override
  String get playButtonLabel => 'Odtwórz';

  @override
  String get shuffleButtonLabel => 'Losowo';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Utworów',
      few: '$count Utwory',
      one: '$count Utwór',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworów',
      one: '$count utwór',
    );
    return '$_temp0, $downloads Pobrano';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworów',
      one: '$count utwór',
    );
    return '$_temp0 Pobrano';
  }

  @override
  String get editPlaylistNameTooltip => 'Edytuj nazwę listy odtwarzania';

  @override
  String get editPlaylistNameTitle => 'Edytuj nazwę listy odtwarzania';

  @override
  String get required => 'Wymagane';

  @override
  String get updateButtonLabel => 'Aktualizuj';

  @override
  String get playlistNameUpdated => 'Zaktualizowano nazwę listy odtwarzania.';

  @override
  String get favourite => 'Ulubiony';

  @override
  String get downloadsDeleted => 'Usunięto pobrane.';

  @override
  String get addDownloads => 'Wszystkie pobrania';

  @override
  String get location => 'Lokalizacja';

  @override
  String get confirmDownloadStarted => 'Pobieranie rozpoczęte';

  @override
  String get downloadsQueued => 'Dodano do pobierania.';

  @override
  String get addButtonLabel => 'Dodaj';

  @override
  String get shareLogs => 'Udostępnij logi';

  @override
  String get logsCopied => 'Logi skopiowane.';

  @override
  String get message => 'Wiadomość';

  @override
  String get stackTrace => 'Stos błędu';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Na licencji Mozilla Public License 2.0.\nKod źródłowy dostępny pod adresem $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transkodowanie';

  @override
  String get downloadLocations => 'Lokalizacje pobierania';

  @override
  String get audioService => 'Usługa audio';

  @override
  String get interactions => 'Interakcje';

  @override
  String get layoutAndTheme => 'Układ i motyw';

  @override
  String get notAvailableInOfflineMode => 'Niedostępne w trybie offline';

  @override
  String get logOut => 'Wyloguj';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Pobrane utwory nie zostaną usunięte';

  @override
  String get areYouSure => 'Czy na pewno?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin używa AAC do transkodowania';

  @override
  String get enableTranscoding => 'Włącz transkodowanie';

  @override
  String get enableTranscodingSubtitle => 'Transkoduje strumienie muzyczne po stronie serwera.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle => 'Wyższy bitrate dostarcza lepszą jakość, ale kosztem większego zużycia transferu danych.';

  @override
  String get customLocation => 'Własna lokalizacja';

  @override
  String get appDirectory => 'Folder aplikacji';

  @override
  String get addDownloadLocation => 'Dodaj lokalizację pobierania';

  @override
  String get selectDirectory => 'Wybierz folder';

  @override
  String get unknownError => 'Nieznany błąd';

  @override
  String get pathReturnSlashErrorMessage => 'Ścieżki nie mogą wskazywać \"/\"';

  @override
  String get directoryMustBeEmpty => 'Folder musi być pusty';

  @override
  String get customLocationsBuggy => 'Niestandardowe lokalizacje są bardzo kłopotliwe ze względu na problemy z uprawnieniami. W chwili obecnej ich używanie nie jest zalecane.';

  @override
  String get enterLowPriorityStateOnPause => 'Przechodź w stan niskiego priorytetu w trakcie trwania pauzy';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Pozwala usunąć powiadomienie podczas pauzy. Pozwala również systemowi Android na zabicie usługi podczas pauzy.';

  @override
  String get shuffleAllTrackCount => 'Maksymalna ilość losowych utworów';

  @override
  String get shuffleAllTrackCountSubtitle => 'Ilość utworów do załadowania kiedy użyto przycisku \"Losowo\" na wszystkich utworach.';

  @override
  String get viewType => 'Widok';

  @override
  String get viewTypeSubtitle => 'Układ elementów';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Siatka';

  @override
  String get customizationSettingsTitle => 'Dostosowywanie';

  @override
  String get playbackSpeedControlSetting => 'Wyświetlanie prędkości odtwarzania';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Czy elementy sterujące prędkością odtwarzania mają być wyświetlane w menu ekranu odtwarzacza';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automatycznie:\nFinamp spróbuje zidentyfikować, czy odtwarzany utwór jest podcastem lub audiobookiem. Uznaje się, że tak jest, jeśli utwór jest dłuższy niż $trackDuration minut, jeśli album utworu jest dłuższy niż $albumDuration godzin lub jeśli utwór ma przypisany co najmniej jeden z tych gatunków: $genreList.\nElementy sterujące prędkością odtwarzania zostaną wyświetlone w menu ekranu odtwarzacza.\n\nPokazane:\nElementy sterujące prędkością odtwarzania będą zawsze wyświetlane w menu ekranu odtwarzacza.\n\nUkryte:\nElementy sterujące szybkością odtwarzania w menu ekranu odtwarzacza są zawsze ukryte.';
  }

  @override
  String get automatic => 'Automatyczne';

  @override
  String get shown => 'Pokazuj';

  @override
  String get hidden => 'Ukryte';

  @override
  String get speed => 'Prędkość';

  @override
  String get reset => 'Resetuj';

  @override
  String get apply => 'Zatwierdź';

  @override
  String get portrait => 'Widok pionowy';

  @override
  String get landscape => 'Widok poziomy';

  @override
  String gridCrossAxisCount(String value) {
    return 'Elementy siatki ($value)';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Ilość elementów w wierszu - $value.';
  }

  @override
  String get showTextOnGridView => 'Pokaż tekst w widoku siatki';

  @override
  String get showTextOnGridViewSubtitle => 'Określa czy wyświetlać tekst (tytuł, wykonawca itp.) na siatce elementów.';

  @override
  String get useCoverAsBackground => 'Pokazuj rozmyty obraz jako tło odtwarzacza';

  @override
  String get useCoverAsBackgroundSubtitle => 'Określa czy używać rozmytego obrazu na ekranie odtwarzacza.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimalna grubość okładki albumu';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimalna grubość wokół okładki albumu na ekranie odtwarzacza, w % szerokości ekranu.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Ukryj wykonawców utworu jeśli odpowiadają wykonawcom albumu';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Określa czy wyświetlać wykonawców utworów na ekranie albumu, jeśli nie różnią się one od wykonawców albumów.';

  @override
  String get showArtistsTopTracks => 'Pokaż najczęściej słuchane utwory w widoku wykonawcy';

  @override
  String get showArtistsTopTracksSubtitle => 'Czy wyświetlać 5 najczęściej słuchanych utworów artysty.';

  @override
  String get disableGesture => 'Wyłącz gesty';

  @override
  String get disableGestureSubtitle => 'Czy wyłączyć gesty.';

  @override
  String get showFastScroller => 'Pokaż szybkie przewijanie';

  @override
  String get theme => 'Motyw';

  @override
  String get system => 'Systemowy';

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciemny';

  @override
  String get tabs => 'Zakładki';

  @override
  String get playerScreen => 'Ekran odtwarzacza';

  @override
  String get cancelSleepTimer => 'Zatrzymać odliczanie?';

  @override
  String get yesButtonLabel => 'Tak';

  @override
  String get noButtonLabel => 'Nie';

  @override
  String get setSleepTimer => 'Ustaw wyłącznik czasowy';

  @override
  String get hours => 'Godzin';

  @override
  String get seconds => 'Sekund';

  @override
  String get minutes => 'Minuty';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime z $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Utwór $currentTrackIndex z $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Nieprawidłowa liczba';

  @override
  String get sleepTimerTooltip => 'Wyłącznik czasowy';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Usypiam za $time minut';
  }

  @override
  String get addToPlaylistTooltip => 'Dodaj do playlisty';

  @override
  String get addToPlaylistTitle => 'Dodaj do Playlisty';

  @override
  String get addToMorePlaylistsTooltip => 'Dodaj do więcej list odtwarzania';

  @override
  String get addToMorePlaylistsTitle => 'Dodaj do więcej list odtwarzania';

  @override
  String get removeFromPlaylistTooltip => 'Usuń z tej playlisty';

  @override
  String get removeFromPlaylistTitle => 'Usuń z Listy Odtwarzania';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Usuń z listy odtwarzania \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Usuń z Listy Odtwarzania \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nowa lista odtwarzania';

  @override
  String get createButtonLabel => 'Utwórz';

  @override
  String get playlistCreated => 'Utworzono listę odtwarzania.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Kliknij aby dodać do playlisty. Długie naciśnięcie powoduje dodanie do ulubionych.';

  @override
  String get noAlbum => 'Brak albumu';

  @override
  String get noItem => 'Brak elementu';

  @override
  String get noArtist => 'Brak artysty';

  @override
  String get unknownArtist => 'Nieznany artysta';

  @override
  String get unknownAlbum => 'Nieznany Album';

  @override
  String get playbackModeDirectPlaying => 'Odtwarzanie bezpośrednie';

  @override
  String get playbackModeTranscoding => 'Transkodowanie';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Odtwarzanie lokalne';

  @override
  String get queue => 'Kolejka';

  @override
  String get addToQueue => 'Dodaj do kolejki';

  @override
  String get replaceQueue => 'Zastąp kolejkę';

  @override
  String get instantMix => 'Szybki miks';

  @override
  String get goToAlbum => 'Idź do albumu';

  @override
  String get goToArtist => 'Idź do Artysty';

  @override
  String get goToGenre => 'Idź do Gatunku';

  @override
  String get removeFavourite => 'Usuń z ulubionych';

  @override
  String get addFavourite => 'Dodaj do ulubionych';

  @override
  String get confirmFavoriteAdded => 'Dodane Ulubione';

  @override
  String get confirmFavoriteRemoved => 'Usunięte Ulubione';

  @override
  String get addedToQueue => 'Dodano do kolejki.';

  @override
  String get insertedIntoQueue => 'Dodano do kolejki.';

  @override
  String get queueReplaced => 'Kolejka zastąpiona.';

  @override
  String get confirmAddedToPlaylist => 'Dodano do playlisty.';

  @override
  String get removedFromPlaylist => 'Usunięto z listy odtwarzania.';

  @override
  String get startingInstantMix => 'Rozpocznij szybki miks.';

  @override
  String get anErrorHasOccured => 'Wystąpił błąd.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Kod statusu $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Kod $statusCode. To najprawdopodobniej oznacza, że użyłeś/aś nieprawidłowej nazwy użytkownika lub hasła.';
  }

  @override
  String get removeFromMix => 'Usuń z miksu';

  @override
  String get addToMix => 'Dodaj do miksu';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ponownie pobrano $count elementów',
      one: 'Ponownie pobrano $count element',
      zero: 'Nie potrzeba ponownego pobierania.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Długość bufora';

  @override
  String get bufferDurationSubtitle => 'Ile odtwarzacz powinien buforować, w sekundach. Wymaga ponownego uruchomienia.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Nie ograniczaj rozmiaru bufora';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Wyłącza ograniczenia rozmiaru bufora („Buffer Size”). Bufor będzie zawsze ładowany do skonfigurowanego czasu trwania („Buffer Duration”), nawet w przypadku bardzo dużych plików. Może powodować awarie. Wymaga ponownego uruchomienia.';

  @override
  String get bufferSizeTitle => 'Rozmiar bufora';

  @override
  String get bufferSizeSubtitle => 'Maksymalny rozmiar bufora w MB. Wymaga ponownego uruchomienia';

  @override
  String get language => 'Język';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Przejście do początku lub poprzedniego utworu';

  @override
  String get skipToNextTrackButtonTooltip => 'Przejście do następnego utworu';

  @override
  String get togglePlaybackButtonTooltip => 'Przełącz odtwarzanie';

  @override
  String get previousTracks => 'Poprzednie Utwory';

  @override
  String get nextUp => 'Następne';

  @override
  String get clearNextUp => 'Wyczyść Następne';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Odtwarzam z';

  @override
  String get playNext => 'Następne';

  @override
  String get addToNextUp => 'Dodaj do Następne';

  @override
  String get shuffleNext => 'Losuj następne';

  @override
  String get shuffleToNextUp => 'Losuj do Następne';

  @override
  String get shuffleToQueue => 'Losuj kolejkę odtwarzania';

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
    return '$_temp0 będzie odtwarzany jako następny';
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
    return 'Dodano $_temp0 do Następne';
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
    return 'Dodano $_temp0 do kolejki';
  }

  @override
  String get confirmShuffleNext => 'Będzie odtwarzany losowo następnie';

  @override
  String get confirmShuffleToNextUp => 'Przemieszane do \"Następne\"';

  @override
  String get confirmShuffleToQueue => 'Przetasowane do kolejki';

  @override
  String get placeholderSource => 'Gdzieś';

  @override
  String get playbackHistory => 'Historia odtwarzania';

  @override
  String get shareOfflineListens => 'Udostępnij plik odsłuchów offline';

  @override
  String get yourLikes => 'Twoje ulubione';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Utwory dodane przez Następne';

  @override
  String get savedQueue => 'Zapisana kolejka odtwarzania';

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
    return 'Odtwarzanie z $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Losuj Wszystko';

  @override
  String get playbackOrderLinearButtonLabel => 'Odtwarzam w kolejności';

  @override
  String get playbackOrderLinearButtonTooltip => 'Odtwarzam w kolejności. Naciśnij, aby przetasować.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Wybieram utwory losowo';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Odtwarzam utwory losowo. Naciśnij, aby odtwarzać w kolejności.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Odtwarzam przy prędkości x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'Prędkość x$speed';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Zmniejsz prędkość odtwarzania';

  @override
  String get playbackSpeedIncreaseLabel => 'Zwiększ prędkość odtwarzania';

  @override
  String get loopModeNoneButtonLabel => 'Bez zapętlania';

  @override
  String get loopModeOneButtonLabel => 'Zapętlam ten utwór';

  @override
  String get loopModeAllButtonLabel => 'Zapętlaj wszystkie';

  @override
  String get queuesScreen => 'Przywróć Teraz odtwarzane';

  @override
  String get queueRestoreButtonLabel => 'Przywróć';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Zapisano $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Odtwarzam: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Utworów',
      few: '$count Utwory',
      one: '1 utwór',
    );
    return '$_temp0, $remaining nieodtworzonych';
  }

  @override
  String get queueLoadingMessage => 'Przywracanie kolejki...';

  @override
  String get queueRetryMessage => 'Nie udało się przywrócić kolejki. Spróbować ponownie?';

  @override
  String get autoloadLastQueueOnStartup => 'Automatycznie przywróć ostatnią kolejkę';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Po uruchomieniu aplikacji podjęta zostanie próba przywrócenia ostatnio odtwarzanej kolejki.';

  @override
  String get reportQueueToServer => 'Raportować bieżącą kolejkę do serwera?';

  @override
  String get reportQueueToServerSubtitle => 'Po włączeniu Finamp wyśle bieżącą kolejkę do serwera. Obecnie wydaje się to mało przydatne i zwiększa ruch sieciowy.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Częstotliwość aktualizacji sesji odtwarzania';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Częstotliwość wysyłania bieżącego stanu odtwarzania do serwera, w sekundach. Powinno to być mniej niż 5 minut (300 sekund), aby zapobiec przekroczeniu limitu czasu sesji.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Jeśli serwer Jellyfin nie otrzymał żadnych aktualizacji od klienta w ciągu ostatnich 5 minut, zakłada, że odtwarzanie zostało zakończone. Oznacza to, że w przypadku ścieżek dłuższych niż 5 minut, odtwarzanie mogło zostać nieprawidłowo zgłoszone jako zakończone, co obniżyło jakość danych raportowania odtwarzania.';

  @override
  String get topTracks => 'Najczęściej odtwarzane utwory';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Albumów',
      few: '$count Albumy',
      two: '$count Albumów',
      one: '$count Album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Odtwarzaj Albumy Losowo';

  @override
  String get shuffleAlbumsNext => 'Odtwarzaj Albumy Losowo (Następnie)';

  @override
  String get shuffleAlbumsToNextUp => 'Odtwarzaj Albumy Losowo do Odtwarzaj Następnie';

  @override
  String get shuffleAlbumsToQueue => 'Odtwarzaj Albumy Losowo do Kolejki';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount odtworzeń',
      few: '$playCount odtworzenia',
      one: '$playCount odtworzenie',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'playlista',
        'trackMix': 'miks utworów',
        'artistMix': 'miks artysty',
        'albumMix': 'miks albumu',
        'genreMix': 'miks gatunku',
        'favorites': 'ulubione',
        'allTracks': 'wszystkie utwory',
        'filteredList': 'utwory',
        'genre': 'gatunek',
        'artist': 'artysta',
        'track': 'utwór',
        'nextUpAlbum': 'album w następnej kolejności',
        'nextUpPlaylist': 'playlista w następnej kolejności',
        'nextUpArtist': 'artysta w następnej kolejności',
        'other': '',
      },
    );
    return 'Nie można załadować $_temp0';
  }

  @override
  String get confirm => 'Potwierdź';

  @override
  String get close => 'Zamknij';

  @override
  String get showUncensoredLogMessage => 'Ten log zawiera twoje dane logowania. Pokazać?';

  @override
  String get resetTabs => 'Resetowanie zakładek';

  @override
  String get resetToDefaults => 'Przywróć domyślne';

  @override
  String get noMusicLibrariesTitle => 'Brak bibliotek muzycznych';

  @override
  String get noMusicLibrariesBody => 'Finamp nie mógł znaleźć żadnych bibliotek muzycznych. Upewnij się, że serwer Jellyfin zawiera co najmniej jedną bibliotekę z typem zawartości ustawionym na \"Muzyka\".';

  @override
  String get refresh => 'Odśwież';

  @override
  String get moreInfo => 'Więcej informacji';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalizacja dźwięku';

  @override
  String get volumeNormalizationSwitchTitle => 'Włącz Normalizację Dźwięku';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Użyj informacji o wzmocnieniu, aby znormalizować głośność utworów („Replay Gain”)';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Tryb Normalizacji Dźwięku';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Kiedy i jak stosować Normalizację Dźwięku';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Hybrydowe (Utwór + Album):\nWzmocnienie utworu jest używane do zwykłego odtwarzania, ale jeśli odtwarzany jest album (ponieważ jest to główne źródło kolejki odtwarzania lub ponieważ został dodany do kolejki w pewnym momencie), zamiast tego używane jest wzmocnienie albumu.\n\nOparte na utworze:\nWzmocnienie utworu jest zawsze używane, niezależnie od tego, czy odtwarzany jest album.\n\nTylko albumy:\nNormalizacja głośności jest stosowana tylko podczas odtwarzania albumów (przy użyciu wzmocnienia albumu), ale nie dla poszczególnych utworów.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybrydowe (Utwór + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Oparte na utworze';

  @override
  String get volumeNormalizationModeAlbumBased => 'Oparte na albumach';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Tylko dla Albumów';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Wzmocnienie basów';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Obecnie normalizacja dźwięku w systemie iOS wymaga zmiany głośności odtwarzania w celu emulacji zmiany wzmocnienia. Ponieważ nie możemy zwiększyć głośności powyżej 100%, musimy domyślnie zmniejszyć głośność, abyśmy mogli zwiększyć głośność cichych utworów. Wartość jest wyrażona w decybelach (dB), gdzie -10 dB to ~30% głośności, -4,5 dB to ~60% głośności, a -2 dB to ~80% głośności.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Następny utwór do odtworzenia';

  @override
  String get swipeInsertQueueNextSubtitle => 'Włącz wstawianie utworu jako następnego elementu w kolejce po przesunięciu palcem na liście utworów zamiast dołączania go na końcu.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Rozpocznij natychmiastowe miksy dla poszczególnych utworów';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Po włączeniu, stuknięcie w utwór na karcie utworów rozpocznie natychmiastowy miks tego utworu zamiast odtwarzania pojedynczego utworu.';

  @override
  String get downloadItem => 'Pobierz';

  @override
  String get repairComplete => 'Naprawa pobranych utworów zakończona.';

  @override
  String get syncComplete => 'Wszystkie pobrania zostały ponownie zsynchronizowane.';

  @override
  String get syncDownloads => 'Synchronizuj i pobierz brakujące elementy.';

  @override
  String get repairDownloads => 'Napraw problemy z pobranymi plikami lub metadanymi.';

  @override
  String get requireWifiForDownloads => 'Wymagaj WiFi podczas pobierania.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworów',
      one: '$count utwór',
    );
    return 'Uwaga: $_temp0 nie mogło zostać przywrócone do kolejki.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'W trakcie',
        'failed': 'Niepowodzenie',
        'syncFailed': 'Błąd synchronizacji',
        'enqueued': 'W kolejce',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Pobrania',
      one: 'Pobieranie',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Czy na pewno chcesz pobrać całą zawartość biblioteki \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Wyświetlaj tylko w pełni pobrane albumy';

  @override
  String get filesystemFull => 'Nie można ukończyć pobierania pozostałych plików. System plików jest pełny.';

  @override
  String get connectionInterrupted => 'Połączenie przerwane, wstrzymano pobieranie.';

  @override
  String get connectionInterruptedBackground => 'Połączenie zostało przerwane podczas pobierania w tle. Może to być spowodowane ustawieniami systemu operacyjnego.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Połączenie zostało przerwane podczas pobierania w tle. Może to być spowodowane włączeniem opcji „Wejdź w stan niskiego priorytetu po pauzie” lub ustawieniami systemu operacyjnego.';

  @override
  String get activeDownloadSize => 'Pobieranie...';

  @override
  String get missingDownloadSize => 'Usuwam...';

  @override
  String get syncingDownloadSize => 'Synchronizuję...';

  @override
  String get runRepairWarning => 'Nie można było skontaktować się z serwerem w celu sfinalizowania migracji pobranych plików. Uruchom „Napraw pobieranie” z ekranu pobierania, gdy tylko powrócisz do trybu online.';

  @override
  String get downloadSettings => 'Pobrane';

  @override
  String get showNullLibraryItemsTitle => 'Pokaż multimedia z nieznaną biblioteką.';

  @override
  String get showNullLibraryItemsSubtitle => 'Niektóre multimedia mogą być pobierane z nieznanej biblioteki. Wyłącz, aby ukryć je poza oryginalną kolekcją.';

  @override
  String get maxConcurrentDownloads => 'Maksymalna liczba jednoczesnych pobrań';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Zwiększenie liczby jednoczesnych pobrań może pozwolić na zwiększone pobieranie w tle, ale może spowodować niepowodzenie niektórych pobrań, jeśli są one bardzo duże, lub spowodować nadmierne opóźnienia w niektórych przypadkach.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Jednoczesnych pobrań';
  }

  @override
  String get downloadsWorkersSetting => 'Liczba wątków pobierania';

  @override
  String get downloadsWorkersSettingSubtitle => 'Liczba wątków synchronizujących metadane i usuwających pobrane pliki. Zwiększenie liczby wątków pobierania może przyspieszyć synchronizację i usuwanie pobrań, zwłaszcza gdy opóźnienia serwera są wysokie, ale może wprowadzić opóźnienia.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count wątków pobierania';
  }

  @override
  String get syncOnStartupSwitch => 'Automatyczna synchronizacja pobranych plików podczas uruchamiania';

  @override
  String get preferQuickSyncSwitch => 'Preferuj szybką synchronizację';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Podczas synchronizacji niektóre typowo statyczne elementy (takie jak utwory i albumy) nie zostaną zaktualizowane. Funkcja Naprawa pobierania zawsze przeprowadza pełną synchronizację.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlista',
        'artist': 'Artysta',
        'genre': 'Gatunek',
        'track': 'Utwór',
        'library': 'Biblioteka',
        'unknown': 'Element',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'Ten element musi zostać pobrany przez $parentName.';
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
    return 'Download oryginalne$_temp0';
  }

  @override
  String get redownloadcomplete => 'Transcode Redownload queued.';

  @override
  String get redownloadTitle => 'Automatically Redownload Transcodes';

  @override
  String get redownloadSubtitle => 'Automatically redownload tracks which are expected to be at a different quality due to parent collection changes.';

  @override
  String get defaultDownloadLocationButton => 'Ustaw jako domyślną lokalizację pobierania.  Wyłącz, aby wybrać dla każdego pobrania.';

  @override
  String get fixedGridSizeSwitchTitle => 'Użyj kafelków siatki o stałym rozmiarze';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Rozmiary kafelków siatki nie będą reagować na rozmiar okna/ekranu.';

  @override
  String get fixedGridSizeTitle => 'Rozmiar kafelka siatki';

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
  String get allowSplitScreenTitle => 'Zezwalaj na tryb podzielonego ekranu';

  @override
  String get allowSplitScreenSubtitle => 'Odtwarzacz będzie wyświetlany obok innych widoków na szerszych ekranach.';

  @override
  String get enableVibration => 'Włącz wibracje';

  @override
  String get enableVibrationSubtitle => 'Określa, czy włączyć wibracje.';

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
  String get hidePlayerBottomActions => 'Ukryj dolne akcje';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Ukryj przyciski kolejki i tekstu na ekranie odtwarzacza. Przesuń palcem w górę, aby uzyskać dostęp do kolejki, przesuń palcem w lewo (poniżej okładki albumu), aby wyświetlić tekst, jeśli jest dostępny.';

  @override
  String get prioritizePlayerCover => 'Priorytet dla okładki albumu';

  @override
  String get prioritizePlayerCoverSubtitle => 'Ustaw większy priorytet dla wyświetlania większej okładki albumu na ekranie odtwarzacza. Niekrytyczne elementy sterujące będą bardziej agresywnie ukrywane na małych ekranach.';

  @override
  String get suppressPlayerPadding => 'Wyłączenie wypełnienia elementów sterujących odtwarzacza';

  @override
  String get suppressPlayerPaddingSubtitle => 'W pełni minimalizuje wypełnienie między elementami sterującymi na ekranie odtwarzacza, gdy okładka albumu nie jest w pełnym rozmiarze.';

  @override
  String get lockDownload => 'Zawsze trzymaj na urządzeniu';

  @override
  String get showArtistChipImage => 'Wyświetlaj obrazy artystów z ich nazwami';

  @override
  String get showArtistChipImageSubtitle => 'Ma to wpływ na małe podglądy obrazów artystów, takie jak na ekranie odtwarzacza.';

  @override
  String get scrollToCurrentTrack => 'Przewiń do bieżącego utworu';

  @override
  String get enableAutoScroll => 'Włącz autoprzewijanie';

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
    return '$duration pozostało';
  }

  @override
  String get removeFromPlaylistConfirm => 'Usuń';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Usunąć \'$itemName\' z playlisty \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Menu utworów';

  @override
  String get quickActions => 'Szybkie akcje';

  @override
  String get addRemoveFromPlaylist => 'Dodaj Do / Usuń Z Playlisty';

  @override
  String get addPlaylistSubheader => 'Dodaj utwór do playlisty';

  @override
  String get trackOfflineFavorites => 'Synchronizuj wszystkie ulubione statusy';

  @override
  String get trackOfflineFavoritesSubtitle => 'Pozwala to na wyświetlanie bardziej aktualnych statusów ulubionych w trybie offline.  Nie pobiera żadnych dodatkowych plików.';

  @override
  String get allPlaylistsInfoSetting => 'Pobierz metadane playlisty';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Synchronizuj metadane dla wszystkich playlist w celu poprawy jakości odtwarzania';

  @override
  String get downloadFavoritesSetting => 'Pobierz wszystkie ulubione';

  @override
  String get downloadAllPlaylistsSetting => 'Pobierz wszystkie playlisty';

  @override
  String get fiveLatestAlbumsSetting => 'Pobierz 5 ostatnich albumów';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Pobrane pliki będą usuwane po ich wygaśnięciu.  Zablokuj pobieranie, aby zapobiec usunięciu albumu.';

  @override
  String get cacheLibraryImagesSettings => 'Buforuj bieżące obrazy biblioteki';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Pobrane zostaną wszystkie okładki albumów, wykonawców, gatunków i playlist w aktualnie aktywnej bibliotece.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Wyświetlanie postępów w miniodtwarzaczu w aplikacji';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Kontroluje, czy pasek miniodtwarzacza / teraz odtwarzane na dole ekranu muzyki działa jako pasek postępu.';

  @override
  String get lyricsScreen => 'Widok Tekstu';

  @override
  String get showLyricsTimestampsTitle => 'Wyświetlaj znaczniki czasu dla zsynchronizowanych tekstów';

  @override
  String get showLyricsTimestampsSubtitle => 'Kontroluje, czy znacznik czasu każdej linii tekstu jest wyświetlany w widoku tekstu, jeśli jest dostępny.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Wyświetlanie przycisku Stop na powiadomieniu o multimediach';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Kontroluje, czy powiadomienie o multimediach ma przycisk Stop oprócz przycisku pauzy. Pozwala to zatrzymać odtwarzanie bez otwierania aplikacji.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Wyświetlaj elementy sterujące fast-forward w powiadomieniach o multimediach';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Kontroluje, czy powiadomienie o multimediach ma pasek postępu, którym można sterować. Umożliwia to zmianę pozycji odtwarzania bez otwierania aplikacji.';

  @override
  String get alignmentOptionStart => 'Start';

  @override
  String get alignmentOptionCenter => 'Wyśrodkuj';

  @override
  String get alignmentOptionEnd => 'Koniec';

  @override
  String get fontSizeOptionSmall => 'Mała';

  @override
  String get fontSizeOptionMedium => 'Średnia';

  @override
  String get fontSizeOptionLarge => 'Duża';

  @override
  String get lyricsAlignmentTitle => 'Wyrównanie tekstu';

  @override
  String get lyricsAlignmentSubtitle => 'Kontroluje wyrównanie tekstu w widoku tekstów.';

  @override
  String get lyricsFontSizeTitle => 'Rozmiar czcionki tekstu';

  @override
  String get lyricsFontSizeSubtitle => 'Kontroluje rozmiar czcionki tekstów w widoku tekstów.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Pokaż album przed tekstem';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Kontroluje, czy okładka albumu jest wyświetlana nad tekstem przed przewinięciem.';

  @override
  String get keepScreenOn => 'Pozostaw ekran włączony';

  @override
  String get keepScreenOnSubtitle => 'Czy pozostawić włączony ekran';

  @override
  String get keepScreenOnDisabled => 'Wyłączone';

  @override
  String get keepScreenOnAlwaysOn => 'Zawsze włączone';

  @override
  String get keepScreenOnWhilePlaying => 'Podczas odtwarzania muzyki';

  @override
  String get keepScreenOnWhileLyrics => 'Podczas wyświetlania tekstu utworu';

  @override
  String get keepScreenOnWhilePluggedIn => 'Ekran włączony tylko po podłączeniu do ładowania';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignorowanie ustawienia Pozostaw ekran włączony, jeśli urządzenie jest odłączone od zasilania';

  @override
  String get genericToggleButtonTooltip => 'Dotknij, aby przełączyć.';

  @override
  String get artwork => 'Okładka';

  @override
  String artworkTooltip(String title) {
    return 'Okładka dla $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Okładka dla $title. Dotknij, aby przełączyć odtwarzanie. Przesuń palcem w lewo lub w prawo, aby przełączać utwory.';
  }

  @override
  String get nowPlayingBarTooltip => 'Otwórz ekran odtwarzacza';

  @override
  String get additionalPeople => 'Osoby';

  @override
  String get playbackMode => 'Tryb odtwarzania';

  @override
  String get codec => 'Kodek';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Głębia bitowa';

  @override
  String get size => 'Rozmiar';

  @override
  String get normalizationGain => 'Wzmocnienie';

  @override
  String get sampleRate => 'Częstotliwość próbkowania';

  @override
  String get showFeatureChipsToggleTitle => 'Pokaż zaawansowane informacje o utworze';

  @override
  String get showFeatureChipsToggleSubtitle => 'Wyświetlanie zaawansowanych informacji o utworze, takich jak kodek, bitrate i inne, na ekranie odtwarzacza.';

  @override
  String get albumScreen => 'Ekran albumu';

  @override
  String get showCoversOnAlbumScreenTitle => 'Pokaż okładki albumów dla utworów';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Wyświetlaj okładki albumów dla każdego utworu osobno na ekranie albumu.';

  @override
  String get emptyTopTracksList => 'Nie słuchałeś jeszcze żadnego utworu tego artysty.';

  @override
  String get emptyFilteredListTitle => 'Nie znaleziono żadnych elementów';

  @override
  String get emptyFilteredListSubtitle => 'Żadne elementy nie pasują do filtra. Spróbuj wyłączyć filtr lub zmienić wyszukiwane hasło.';

  @override
  String get resetFiltersButton => 'Zresetuj filtry';

  @override
  String get resetSettingsPromptGlobal => 'Czy na pewno chcesz zresetować WSZYSTKIE ustawienia do wartości domyślnych?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Zresetuj WSZYSTKIE ustawienia';

  @override
  String get resetSettingsPromptLocal => 'Czy chcesz przywrócić te ustawienia do wartości domyślnych?';

  @override
  String get genericCancel => 'Anuluj';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Lista odtwarzania',
        'artist': 'Artysta',
        'genre': 'Gatunek',
        'track': 'Utwór',
        'library': 'Biblioteka',
        'other': 'Element',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'urządzenia',
        'server': 'serwera',
        'other': 'unknown',
      },
    );
    return '$_temp0 został usunięty z $_temp1';
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
