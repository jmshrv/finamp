// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Ein quelloffener Jellyfin-Musikplayer';

  @override
  String startupError(String error) {
    return 'Während dem Starten der App ist etwas schiefgelaufen. Der Fehler war: $error\n\nBitte öffne einen Issue auf github.com/UnicornsOnLSD/finamp mit einem Screenshot von dieser Seite. Wenn dieses Problem weiterhin besteht, kannst du deine App-Daten löschen, um die App zurückzusetzen.';
  }

  @override
  String get about => 'Über Finamp';

  @override
  String get aboutContributionPrompt => 'Von wunderbaren Menschen in ihrer Freizeit gemacht.\nDu könntest eine(r) von ihnen sein!';

  @override
  String get aboutContributionLink => 'Zu Finamp auf GitHub beitragen:';

  @override
  String get aboutReleaseNotes => 'Lese die neusten Update-Informationen:';

  @override
  String get aboutTranslations => 'Hilf mit, Finamp in deine Sprache zu übersetzen:';

  @override
  String get aboutThanks => 'Danke, dass du Finamp nutzt!';

  @override
  String get loginFlowWelcomeHeading => 'Willkommen bei';

  @override
  String get loginFlowSlogan => 'Deine Musik, so wie du sie willst.';

  @override
  String get loginFlowGetStarted => 'Los geht’s!';

  @override
  String get viewLogs => 'Logs ansehen';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get loginFlowServerSelectionHeading => 'Mit Jellyfin verbinden';

  @override
  String get back => 'Zurück';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get internalExternalIpExplanation => 'Wenn du aus der Ferne auf deinen Jellyfin-Server zugreifen möchtest, musst du deine externe IP verwenden.\n\nWenn dein Server auf einem HTTP Standardport (80 oder 443) oder Jellyfins Standardport (8096) läuft, musst du den Port nicht angeben.\n\nWenn die URL korrekt ist, solltest du einige Informationen über deinen Server unterhalb des Eingabefeldes sehen.';

  @override
  String get serverUrlHint => 'z.B. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Server-URL-Hilfe';

  @override
  String get emptyServerUrl => 'Server-URL darf nicht leer sein';

  @override
  String get connectingToServer => 'Verbinde mit dem Server...';

  @override
  String get loginFlowLocalNetworkServers => 'Server in deinem lokalen Netzwerk:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Suche nach Servern...';

  @override
  String get loginFlowAccountSelectionHeading => 'Wähle dein Konto aus';

  @override
  String get backToServerSelection => 'Zurück zur Serverauswahl';

  @override
  String get loginFlowNamelessUser => 'Unbenannter Benutzer';

  @override
  String get loginFlowCustomUser => 'Manuelle Eingabe';

  @override
  String get loginFlowAuthenticationHeading => 'Mit deinem Konto anmelden';

  @override
  String get backToAccountSelection => 'Zurück zur Kontoauswahl';

  @override
  String get loginFlowQuickConnectPrompt => 'Quick Connect Code verwenden';

  @override
  String get loginFlowQuickConnectInstructions => 'Öffne die Jellyfin-App oder die Website, klicke auf dein Benutzersymbol und wähle Quick Connect.';

  @override
  String get loginFlowQuickConnectDisabled => 'Quick Connect ist auf diesem Server deaktiviert.';

  @override
  String get orDivider => 'oder';

  @override
  String get loginFlowSelectAUser => 'Benutzer auswählen';

  @override
  String get username => 'Benutzername';

  @override
  String get usernameHint => 'Gib deinen Benutzernamen ein';

  @override
  String get usernameValidationMissingUsername => 'Bitte gib einen Benutzernamen ein';

  @override
  String get password => 'Passwort';

  @override
  String get passwordHint => 'Gib dein Passwort ein';

  @override
  String get login => 'Anmelden';

  @override
  String get logs => 'Logs';

  @override
  String get next => 'Weiter';

  @override
  String get selectMusicLibraries => 'Musikbibliotheken auswählen';

  @override
  String get couldNotFindLibraries => 'Es konnten keine Bibliotheken gefunden werden.';

  @override
  String get unknownName => 'Unbekannter Name';

  @override
  String get tracks => 'Tracks';

  @override
  String get albums => 'Alben';

  @override
  String get artists => 'Künstler';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Playlists';

  @override
  String get startMix => 'Mix Starten';

  @override
  String get startMixNoTracksArtist => 'Halte einen Künstler gedrückt, um ihn zum Mix hinzuzufügen oder zu entfernen, bevor du einen Mix startest';

  @override
  String get startMixNoTracksAlbum => 'Halte ein Album gedrückt, um es zum Mix hinzuzufügen oder zu entfernen, bevor du einen Mix startest';

  @override
  String get startMixNoTracksGenre => 'Drücke lange auf ein Genre, um zum Mixes hinzuzufügen oder zu entfernen, bevor du einen Mix startest';

  @override
  String get music => 'Musik';

  @override
  String get clear => 'Löschen';

  @override
  String get favourites => 'Favoriten';

  @override
  String get shuffleAll => 'Alle zufällig wiedergeben';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Einstellungen';

  @override
  String get offlineMode => 'Offline-Modus';

  @override
  String get sortOrder => 'Sortierung';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get title => 'Titel';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Albumkünstler';

  @override
  String get artist => 'Künstler';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Community-Bewertung';

  @override
  String get criticRating => 'Kritikerbewertung';

  @override
  String get dateAdded => 'Datum hinzugefügt';

  @override
  String get datePlayed => 'Datum gespielt';

  @override
  String get playCount => 'Wiedergaben';

  @override
  String get premiereDate => 'Erscheinungsdatum';

  @override
  String get productionYear => 'Produktionsjahr';

  @override
  String get name => 'Name';

  @override
  String get random => 'Zufällig';

  @override
  String get revenue => 'Einspielergebnis';

  @override
  String get runtime => 'Dauer';

  @override
  String get syncDownloadedPlaylists => 'Heruntergeladene Playlisten synchronisieren';

  @override
  String get downloadMissingImages => 'Fehlende Bilder herunterladen';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fehlende Bilder heruntergeladen',
      one: '$count fehlendes Bild heruntergeladen',
      zero: 'Keine fehlenden Bilder gefunden',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Aktive Downloads';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Downloads',
      one: '$count Download',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount Tracks',
      one: '$trackCount Track',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount Bilder',
      one: '$imageCount Bild',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount synchronisieren',
      one: '$syncCount synchronisiert',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nreparieren',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count fertiggestellt';
  }

  @override
  String dlFailed(int count) {
    return '$count fehlgeschlagen';
  }

  @override
  String dlEnqueued(int count) {
    return '$count in der Warteschlange';
  }

  @override
  String dlRunning(int count) {
    return '$count laufend';
  }

  @override
  String get activeDownloadsTitle => 'Aktive Downloads';

  @override
  String get noActiveDownloads => 'Keine aktiven Downloads.';

  @override
  String get errorScreenError => 'Beim Abrufen der Fehlerliste ist ein Fehler aufgetreten! Jetzt ist es vermutlich am besten, einen Issue auf GitHub zu erstellen und die App-Daten zu löschen';

  @override
  String get failedToGetTrackFromDownloadId => 'Keinen Track für diese Download-ID gefunden';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'das Album',
        'playlist': 'die Playlist',
        'artist': 'den Künstler',
        'genre': 'das Genre',
        'track': 'den Track',
        'library': 'die Bibliothek',
        'other': 'das Item',
      },
    );
    return 'Bist du dir sicher, dass du $_temp0 \'$itemName\' von diesem Gerät löschen möchtest?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Löschen';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Fehler';

  @override
  String discNumber(int number) {
    return 'CD $number';
  }

  @override
  String get playButtonLabel => 'Wiedergeben';

  @override
  String get shuffleButtonLabel => 'Zufällig';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '$count Track',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '$count Track',
    );
    return '$_temp0, $downloads heruntergeladen';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '$count Track',
    );
    return '$_temp0 heruntergeladen';
  }

  @override
  String get editPlaylistNameTooltip => 'Playlist umbenennen';

  @override
  String get editPlaylistNameTitle => 'Playlist Umbenennen';

  @override
  String get required => 'Erforderlich';

  @override
  String get updateButtonLabel => 'Aktualisieren';

  @override
  String get playlistNameUpdated => 'Playlist-Name aktualisiert.';

  @override
  String get favourite => 'Favorit';

  @override
  String get downloadsDeleted => 'Downloads gelöscht.';

  @override
  String get addDownloads => 'Download hinzufügen';

  @override
  String get location => 'Ort';

  @override
  String get confirmDownloadStarted => 'Download gestartet';

  @override
  String get downloadsQueued => 'Downloads hinzugefügt';

  @override
  String get addButtonLabel => 'Hinzufügen';

  @override
  String get shareLogs => 'Logs teilen';

  @override
  String get logsCopied => 'Logs kopiert.';

  @override
  String get message => 'Nachricht';

  @override
  String get stackTrace => 'Stacktrace';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Lizenziert mit der Mozilla Public License 2.0.\nQuellcode verfügbar unter $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transkodierung';

  @override
  String get downloadLocations => 'Download Orte';

  @override
  String get audioService => 'Audio-Dienst';

  @override
  String get interactions => 'Interaktionen';

  @override
  String get layoutAndTheme => 'Layout & Aussehen';

  @override
  String get notAvailableInOfflineMode => 'Im Offline-Modus nicht verfügbar';

  @override
  String get logOut => 'Abmelden';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Heruntergeladene Titel werden nicht gelöscht';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin verwendet AAC zur Transkodierung';

  @override
  String get enableTranscoding => 'Transkodierung aktivieren';

  @override
  String get enableTranscodingSubtitle => 'Transkodiert Musikstreams serverseitig.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle => 'Eine höhere Bitrate verbessert die Audioqualität auf Kosten der benötigten Bandbreite.';

  @override
  String get customLocation => 'Benutzerdefinierter Ort';

  @override
  String get appDirectory => 'App-Verzeichnis';

  @override
  String get addDownloadLocation => 'Download-Ort hinzufügen';

  @override
  String get selectDirectory => 'Verzeichnis auswählen';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get pathReturnSlashErrorMessage => 'Pfade, die „/“ zurückgeben, können nicht verwendet werden';

  @override
  String get directoryMustBeEmpty => 'Verzeichnis muss leer sein';

  @override
  String get customLocationsBuggy => 'Benutzerdefinierte Speicherorte können zu Fehlern führen und werden in den meisten Fällen nicht empfohlen. Speicherorte unterhalb des \'Musik\'-Systemordners verhindern das Speichern von Albumcovern aufgrund von Betriebssystembeschränkungen.';

  @override
  String get enterLowPriorityStateOnPause => 'Niedrige-Priorität-Modus beim Pausieren aktivieren';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Ermöglicht, dass die Benachrichtigung im pausierten Zustand weggewischt werden kann. Dies erlaubt es Android ebenfalls, den Prozess im pausierten Zustand zu terminieren.';

  @override
  String get shuffleAllTrackCount => 'Anzahl zufälliger Tracks';

  @override
  String get shuffleAllTrackCountSubtitle => 'Die Anzahl der zu ladenden Tracks, wenn der Zufällig-Button benutzt wird.';

  @override
  String get viewType => 'Ansichtsart';

  @override
  String get viewTypeSubtitle => 'Ansichtsart für den Musik-Bildschirm';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Raster';

  @override
  String get customizationSettingsTitle => 'Personalisierung';

  @override
  String get playbackSpeedControlSetting => 'Sichtbarkeit der Abspielgeschwindigkeit';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Ob die Abspielgeschwindigkeits-Einstellungen in der Wiedergabe-Ansicht angezeigt werden';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automatisch:\nFinamp versucht zu erkennen, ob es sich bei dem abgespielten Titel um einen Podcast oder um ein Hörbuch handelt. Dies ist der Fall, wenn der Titel länger als $trackDuration Minuten ist, wenn das Album des Titels länger als $albumDuration Stunden ist oder wenn dem Titel mindestens eines dieser Genres zugeordnet ist: $genreList\nDie Steuerelemente für die Wiedergabegeschwindigkeit werden dann im Bildschirmmenü des Players angezeigt.\n\nAngezeigt:\nDie Steuerelemente für die Wiedergabegeschwindigkeit werden immer im Bildschirmmenü des Players angezeigt.\n\nAusgeblendet:\nDie Steuerelemente für die Wiedergabegeschwindigkeit im Player-Bildschirmmenü werden immer ausgeblendet.';
  }

  @override
  String get automatic => 'Automatisch';

  @override
  String get shown => 'Angezeigt';

  @override
  String get hidden => 'Ausgeblendet';

  @override
  String get speed => 'Wiedergabegeschwindigkeit';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get apply => 'Anwenden';

  @override
  String get portrait => 'Hochformat';

  @override
  String get landscape => 'Querformat';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Raster Querachsen-Anzahl';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Anzahl der zu benutzenden Rasterkacheln im $value.';
  }

  @override
  String get showTextOnGridView => 'Text in Rasteransicht anzeigen';

  @override
  String get showTextOnGridViewSubtitle => 'Ob Text (Titel, Künstler etc.) auf dem Raster des Musikbildschirms angezeigt werden soll.';

  @override
  String get useCoverAsBackground => 'Zeige verschwommene Cover als Player-Hintergrund';

  @override
  String get useCoverAsBackgroundSubtitle => 'Ob verschwommene Cover als Hintergrund in der Wiedergabe-Ansicht benutzt werden sollen.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimaler Abstand um das Album Cover';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimaler Abstand um das Album Cover in der Wiedergabe-Ansicht, in % der Bildschirmbreite.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Verstecke Track-Künstler, falls dieser dem Album-Künstler entspricht';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Ob Titel-Künstler in der Albenansicht angezeigt werden sollen, falls sie sich nicht von den Album-Künstlern unterscheiden.';

  @override
  String get showArtistsTopTracks => 'Meistgehörte Tracks von Künstlern anzeigen';

  @override
  String get showArtistsTopTracksSubtitle => 'Ob die meistgehörten Tracks eines Künstlers angezeigt werden sollen.';

  @override
  String get disableGesture => 'Gesten deaktivieren';

  @override
  String get disableGestureSubtitle => 'Ob Gesten deaktiviert werden sollen.';

  @override
  String get showFastScroller => 'Schnellen Scroller anzeigen';

  @override
  String get theme => 'Thema';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get tabs => 'Tabs';

  @override
  String get playerScreen => 'Wiedergabe-Ansicht';

  @override
  String get cancelSleepTimer => 'Schlaf-Timer abbrechen?';

  @override
  String get yesButtonLabel => 'Ja';

  @override
  String get noButtonLabel => 'Nein';

  @override
  String get setSleepTimer => 'Schlaf-Timer einstellen';

  @override
  String get hours => 'Stunden';

  @override
  String get seconds => 'Sekunden';

  @override
  String get minutes => 'Minuten';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime von $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Track $currentTrackIndex von $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Ungültige Zahl';

  @override
  String get sleepTimerTooltip => 'Schlaf-Timer';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Schlaftimer endet in $time Minuten';
  }

  @override
  String get addToPlaylistTooltip => 'Zur Playlist hinzufügen';

  @override
  String get addToPlaylistTitle => 'Zur Playlist hinzufügen';

  @override
  String get addToMorePlaylistsTooltip => 'Zu weiteren Playlists hinzufügen';

  @override
  String get addToMorePlaylistsTitle => 'Zu weiteren Playlists hinzufügen';

  @override
  String get removeFromPlaylistTooltip => 'Aus dieser Playlist entfernen';

  @override
  String get removeFromPlaylistTitle => 'Aus dieser Playlist entfernen';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Aus Playlist \'$playlistName\' entfernen';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Aus Playlist \'$playlistName\' entfernen';
  }

  @override
  String get newPlaylist => 'Neue Playlist';

  @override
  String get createButtonLabel => 'Erstellen';

  @override
  String get playlistCreated => 'Playlist erstellt.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Tippen, um zur Playlist hinzuzufügen. Lange Drücken, um Favoriten umzuschalten.';

  @override
  String get noAlbum => 'Kein Album';

  @override
  String get noItem => 'Kein Element';

  @override
  String get noArtist => 'Kein Künstler';

  @override
  String get unknownArtist => 'Unbekannter Künstler';

  @override
  String get unknownAlbum => 'Unbekanntes Album';

  @override
  String get playbackModeDirectPlaying => 'Direkte Wiedergabe';

  @override
  String get playbackModeTranscoding => 'Transkodierung';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Lokale Wiedergabe';

  @override
  String get queue => 'Warteschlange';

  @override
  String get addToQueue => 'Zur Warteschlange hinzufügen';

  @override
  String get replaceQueue => 'Warteschlange austauschen';

  @override
  String get instantMix => 'Sofort-Mix';

  @override
  String get goToAlbum => 'Gehe zu Album';

  @override
  String get goToArtist => 'Gehe zu Künstler';

  @override
  String get goToGenre => 'Gehe zu Genre';

  @override
  String get removeFavourite => 'Favorit entfernen';

  @override
  String get addFavourite => 'Favorit hinzufügen';

  @override
  String get confirmFavoriteAdded => 'Favorit hinzugefügt';

  @override
  String get confirmFavoriteRemoved => 'Favorit entfernt';

  @override
  String get addedToQueue => 'Zur Warteschlange hinzugefügt.';

  @override
  String get insertedIntoQueue => 'In Warteschlange eingefügt.';

  @override
  String get queueReplaced => 'Warteschlange ausgetauscht.';

  @override
  String get confirmAddedToPlaylist => 'Zur Playlist hinzugefügt.';

  @override
  String get removedFromPlaylist => 'Aus der Playlist entfernt.';

  @override
  String get startingInstantMix => 'Starte Sofort-Mix.';

  @override
  String get anErrorHasOccured => 'Ein Fehler ist aufgetreten.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status Code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status Code $statusCode. Dies bedeutet vermutlich, dass du den falschen Benutzernamen oder Passwort benutzt hast oder dass dein Client nicht länger authentifiziert ist.';
  }

  @override
  String get removeFromMix => 'Aus Mix entfernen';

  @override
  String get addToMix => 'Zu Mix hinzufügen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente erneut heruntergeladen',
      one: '$count Element erneut heruntergeladen',
      zero: 'Keine erneuten Downloads notwendig.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Pufferdauer';

  @override
  String get bufferDurationSubtitle => 'Die maximale Pufferdauer in Sekunden. Neustart erforderlich.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Puffergröße nicht limitieren';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Deaktiviert die Begrenzung der Puffergröße. Der Puffer wird immer bis zur eingestellten Pufferdauer gefüllt, selbst bei sehr großen Dateien. Kann zu Abstürzen führen. Neustart erforderlich.';

  @override
  String get bufferSizeTitle => 'Puffergröße';

  @override
  String get bufferSizeSubtitle => 'Die maximale Größe des Puffers in MB. Neustart erforderlich';

  @override
  String get language => 'Sprache';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Springe zum Anfang oder letzten Track';

  @override
  String get skipToNextTrackButtonTooltip => 'Zum nächsten Track springen';

  @override
  String get togglePlaybackButtonTooltip => 'Wiedergabe umschalten';

  @override
  String get previousTracks => 'Vorherige Tracks';

  @override
  String get nextUp => 'Als Nächstes';

  @override
  String get clearNextUp => '\"Als Nächstes\" leeren';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Wiedergabe von';

  @override
  String get playNext => 'Als Nächstes wiedergeben';

  @override
  String get addToNextUp => 'Zu \"Als Nächstes\" hinzufügen';

  @override
  String get shuffleNext => 'In zufälliger Reihenfolge als Nächstes wiedergeben';

  @override
  String get shuffleToNextUp => 'Zufällig an \"Als Nächstes\" anhängen';

  @override
  String get shuffleToQueue => 'Zufällig zur Warteschleife';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'Album',
        'artist': 'Künstler',
        'playlist': 'Playlist',
        'genre': 'Genre',
        'other': 'Element',
      },
    );
    return '$_temp0 wird als nächstes abgespielt';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'Album',
        'artist': 'Künstler',
        'playlist': 'Playlist',
        'genre': 'Genre',
        'other': 'Element',
      },
    );
    return '$_temp0 zu \"Als Nächstes\" hinzugefügt';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'Album',
        'artist': 'Künstler',
        'playlist': 'Playlist',
        'genre': 'Genre',
        'other': 'Element',
      },
    );
    return '$_temp0 zur Warteschlange hinzugefügt';
  }

  @override
  String get confirmShuffleNext => 'Wird zufällig als nächstes gespielt';

  @override
  String get confirmShuffleToNextUp => 'Zufällig zu \"Als Nächstes\" hinzugefügt';

  @override
  String get confirmShuffleToQueue => 'Zufällig zur Warteschlange hinzugefügt';

  @override
  String get placeholderSource => 'Irgendwo';

  @override
  String get playbackHistory => 'Wiedergabe-Verlauf';

  @override
  String get shareOfflineListens => 'Exportiere Offline-Wiedergaben';

  @override
  String get yourLikes => 'Deine Likes';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Über \"Als Nächstes\" hinzugefügte Tracks';

  @override
  String get savedQueue => 'Gespeicherte Warteschlange';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'trackMix': 'Track Mix',
        'artistMix': 'Künstler Mix',
        'albumMix': 'Album Mix',
        'genreMix': 'Genre Mix',
        'favorites': 'Favoriten',
        'allTracks': 'allen Tracks',
        'filteredList': 'Tracks',
        'genre': 'Genre',
        'artist': 'Künstler',
        'track': 'Track',
        'nextUpAlbum': 'Album in \"Als Nächstes\"',
        'nextUpPlaylist': 'Playlist in \"Als Nächstes\"',
        'nextUpArtist': 'Artist in \"Als Nächstes\"',
        'other': '',
      },
    );
    return 'Wiedergabe von $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Alles zufällig abspielen';

  @override
  String get playbackOrderLinearButtonLabel => 'Wiedergabe in Reihenfolge';

  @override
  String get playbackOrderLinearButtonTooltip => 'Wiedergabe in Reihenfolge. Tippe für zufällige Wiedergabe.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Zufallswiedergabe';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Zufallswiedergabe. Tippen, um der Reihe nach abzuspielen.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Wiedergabe auf $speed-facher Geschwindigkeit';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed-fache Geschwindigkeit';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Wiedergabegeschwindigkeit verringern';

  @override
  String get playbackSpeedIncreaseLabel => 'Wiedergabegeschwindigkeit erhöhen';

  @override
  String get loopModeNoneButtonLabel => 'Keine Wiederholung';

  @override
  String get loopModeOneButtonLabel => 'Diesen Track wiederholen';

  @override
  String get loopModeAllButtonLabel => 'Alles wiederholen';

  @override
  String get queuesScreen => 'Wiederherstellen der Warteschlange';

  @override
  String get queueRestoreButtonLabel => 'Wiederherstellen';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Gespeichert $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Wiedergabe: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '1 Track',
    );
    return '$_temp0, $remaining ungespielt';
  }

  @override
  String get queueLoadingMessage => 'Warteschlange wird wiederhergestellt…';

  @override
  String get queueRetryMessage => 'Wiederherstellen der Warteschlange fehlgeschlagen. Erneut versuchen?';

  @override
  String get autoloadLastQueueOnStartup => 'Automatisches Wiederherstellen der letzten Warteschlange';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Versuche, die letzte Warteschlange beim Sarten der App wiederherzustellen.';

  @override
  String get reportQueueToServer => 'Dem Server die aktuelle Warteschlange mitteilen?';

  @override
  String get reportQueueToServerSubtitle => 'Wenn aktiviert sendet Finamp die aktuelle Warteschlange an den Server. Aktuell scheint es wenig Nutzen dafür zu geben und es erhöht die Netzwerkbelastung.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Update-Frequenz der Wiedergabesitzung';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Wie oft (in Sekunden) der Wiedergabe-Status an den Server gesendet werden soll. Der Wert sollte unter 5 Minuten (300 Sekunden) liegen, um ein Time-out zu verhinden.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Nach 5 Minuten ohne Komunikation zwischen Client und Server wird der Server davon ausgehen, dass die Wiedergabe gestoppt wurde. Das heißt: für Tracks, die länger als 5 Minuten sind, könnte es zu fehlerhaften Wiedergabe-Meldungen führen, was die Qualität dieser Daten reduziert.';

  @override
  String get topTracks => 'Top Tracks';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alben',
      one: '$count Album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Alben zufällig wiedergeben';

  @override
  String get shuffleAlbumsNext => 'Zufallswiedergabe der Alben als nächstes';

  @override
  String get shuffleAlbumsToNextUp => 'Alben zufällig zu \"Als Nächstes\" hinzufügen';

  @override
  String get shuffleAlbumsToQueue => 'Alben zufällig zur Warteschlange hinzufügen';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount Wiedergaben',
      one: '$playCount Wiedergabe',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'des Albums',
        'playlist': 'der Wiedergabeliste',
        'trackMix': 'des Titelmixes',
        'artistMix': 'des Künstlermixes',
        'albumMix': 'des Albummixes',
        'favorites': 'der Favoriten',
        'allTracks': 'aller Titel',
        'filteredList': 'der Tracks',
        'genre': 'des Genre',
        'artist': 'des Künstlers',
        'nextUpAlbum': 'des Album in \\\"Als Nächstes\\\"',
        'nextUpPlaylist': 'der Playlist in \\\"Als Nächstes\\\"',
        'nextUpArtist': 'des Künstlers in \\\"Als Nächstes\\\"',
        'other': '',
      },
    );
    return 'Laden $_temp0 fehlgeschlagen';
  }

  @override
  String get confirm => 'Bestätigen';

  @override
  String get close => 'Schließen';

  @override
  String get showUncensoredLogMessage => 'Dieser Log enthält deine Anmeldedaten. Anzeigen?';

  @override
  String get resetTabs => 'Tabs zurücksetzen';

  @override
  String get resetToDefaults => 'Auf Standardeinstellungen zurücksetzen';

  @override
  String get noMusicLibrariesTitle => 'Keine Musik-Bibliotheken';

  @override
  String get noMusicLibrariesBody => 'Finamp konnte keine Musikbibliotheken finden. Bitte stelle sicher, dass dein Jellyfin-Server mindestens eine Bibliothek mit dem Medientyp \"Musik\" enthält.';

  @override
  String get refresh => 'Neu Laden';

  @override
  String get moreInfo => 'Weitere Infos';

  @override
  String get volumeNormalizationSettingsTitle => 'Lautstärke-Normalisierung';

  @override
  String get volumeNormalizationSwitchTitle => 'Lautstärke-Normalisierung aktivieren';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Verwende Gain-Informationen, um die Lautstärke von Tracks zu normalisieren (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Lautstärke-Normalisierungsmodus';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Wann und wie Lautstärke-Normalisierung angewendet werden soll';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Hybrid (Track + Album):\nFür normales Playback wird der Track Gain benutzt. Wenn ein Album gespielt wird (entweder direkt oder weil es irgendwann zur Warteschlange hinzugefügt wurde), wird stattdessen der Album-Gain verwendet.\n\nTrack-basiert:\nEs wird immer der Track Gain verwendet, selbst wenn ein ganzes Album gespielt wird.\n\nNur Alben:\nLautstärken-Normalisierung wird nur bei der Wiedergabe von Alben (mit dem Album Gain) angewendet, aber nicht für individuelle Tracks.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybrid (Track + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Trackbezogen';

  @override
  String get volumeNormalizationModeAlbumBased => 'Albumbezogen';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Nur für Alben';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Ausgangs-Gain';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Im Moment muss für Lautstärken-Normalisierung auf iOS der angepasste Gain-Wert über die normale Wiedergabelautstärke emuliert werden. Da die Wiedergabelautstärke nicht höher als 100% sein kann, muss sie standardmäßig etwas verringert werden, sodass leisere Tracks angehoben werden können. Der Wert wird in Dezibel (dB) angegeben. -10 dB entspricht ~30%, -4.5 dB entspricht ~60% und -2 dB entspricht ~80% der Lautstärke.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Den geswipten Track als Nächstes abspielen';

  @override
  String get swipeInsertQueueNextSubtitle => 'Aktivieren, um den in der Liste nach links/rechts geswipten Track als Nächstes abzuspielen, statt ihn am Ende der Warteschlange einzufügen.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Beginne Sofort-Mixe für individuelle Tracks';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Startet beim Tippen auf einen Track im \"Track\"-Tab einen Sofort-Mix, anstatt nur einen einzelnen Track abzuspielen.';

  @override
  String get downloadItem => 'Herunterladen';

  @override
  String get repairComplete => 'Download-Reparatur beendet.';

  @override
  String get syncComplete => 'Alle Downloads re-synchronisiert.';

  @override
  String get syncDownloads => 'Fehlende Elemente synchronisieren und herunterladen.';

  @override
  String get repairDownloads => 'Probleme mit heruntergeladenen Dateien oder Metadaten reparieren.';

  @override
  String get requireWifiForDownloads => 'Nur über WLAN herunterladen.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks konnten',
      one: '$count Track konnte',
    );
    return 'Warnung: $_temp0 nicht aus der Warteschlange wiederhergestellt werden.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '',
      one: 'r',
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '',
      one: 'r',
    );
    String _temp2 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '',
      one: 'r',
    );
    String _temp3 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '',
      one: 'r',
    );
    String _temp4 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'laufende$_temp0',
        'failed': 'fehlgeschlagene$_temp1',
        'syncFailed': 'wiederholt fehlgeschlagene$_temp2',
        'enqueued': 'eingereihte$_temp3',
        'other': '',
      },
    );
    String _temp5 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Downloads',
      one: 'Download',
    );
    return '$itemCount $_temp4 $_temp5';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Bist du sicher, dass du alle Inhalte der Bibliothek \"$libraryName\" herunterladen möchtest?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Nur vollständig heruntergeladene Alben anzeigen';

  @override
  String get filesystemFull => 'Verbleibende Downloads können nicht abgeschlossen werden. Der Speicherplatz ist voll.';

  @override
  String get connectionInterrupted => 'Verbindung unterbrochen, Downloads werden pausiert.';

  @override
  String get connectionInterruptedBackground => 'Während des Herunterladens im Hintergrund wurde die Verbindung unterbrochen. Dies kann durch Betriebssystem-Einstellungen verursacht werden.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Während des Downloads im Hintergrund wurde die Verbindung unterbrochen. Dies kann durch die Aktivierung von \'Bei Pause in den Niedrigprioritätszustand wechseln\' oder durch Betriebssystemeinstellungen verursacht werden.';

  @override
  String get activeDownloadSize => 'Wird heruntergeladen...';

  @override
  String get missingDownloadSize => 'Wird gelöscht...';

  @override
  String get syncingDownloadSize => 'Wird synchronisiert...';

  @override
  String get runRepairWarning => 'Der Server konnte nicht erreicht werden, um die Migration der Downloads abzuschließen. Bitte gehe zur Download-Ansicht und führe \"Downloads reparieren\" aus, sobald du wieder online bist.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Medien mit unbekannter Bibliothek anzeigen.';

  @override
  String get showNullLibraryItemsSubtitle => 'Manche Medien könnten aus einer unbekannten Bibliothek heruntergeladen worden sein. Deaktivieren, um diese außerhalb ihrer ursrpünglichen Bibliothek zu verstecken.';

  @override
  String get maxConcurrentDownloads => 'Max. gleichzeitige Downloads';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Eine Erhöhung der gleichzeitigen Downloads kann ein erhöhtes Herunterladen im Hintergrund erlauben, kann aber bei sehr großen Downloads zu Fehlern oder zu exzessiven Verzögerungen führen.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count gleichzeitige Downloads';
  }

  @override
  String get downloadsWorkersSetting => 'Anzahl der Download-Worker';

  @override
  String get downloadsWorkersSettingSubtitle => 'Anzahl der Download-Worker zur Synchronisierung von Metadaten und zur Löschung von Downloads. Erhöhung des Wertes kann die Download-Synchronisierung und das Löschen (vor allem wenn die Server-Verzögerung hoch ist) beschleunigen, kann allerdings auch Verzögerungen hervorrufen.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Download Workers';
  }

  @override
  String get syncOnStartupSwitch => 'Downloads automatisch beim Start synchronisieren';

  @override
  String get preferQuickSyncSwitch => 'Schnelle Synchronisationen bevorzugen';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Beim Synchronisieren werden typisch statische Elemente (z.B. Lieder und Alben) nicht aktualisiert. Eine Download-Reparatur wird immer eine vollständige Synchronisation durchführen.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Künstler',
        'genre': 'Genre',
        'track': 'Track',
        'library': 'Bibliothek',
        'unknown': 'Item',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'Dieses Element muss von $parentName heruntergeladen werden.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Favoriten',
        'allPlaylists': 'Alle Playlists',
        'fiveLatestAlbums': 'Die 5 neuesten Alben',
        'allPlaylistsMetadata': 'Playlist Metadaten',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Bilder im Cache für \'$libraryName\'';
  }

  @override
  String get transcodingStreamingContainerTitle => 'Transkodierungscontainer auswählen';

  @override
  String get transcodingStreamingContainerSubtitle => 'Wähle den Transkodierungscontainer, der beim Streamen von transkodiertem Audio verwendet wird. Tracks, die sich bereits in der Warteschlange befinden, werden nicht beeinflusst.';

  @override
  String get downloadTranscodeEnableTitle => 'Transkodierte Downloads aktivieren';

  @override
  String get downloadTranscodeCodecTitle => 'Download-Codec auswählen';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Immer',
        'never': 'Niemals',
        'ask': 'Fragen',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Download-Bitrate';

  @override
  String get downloadBitrateSubtitle => 'Eine höhere Bitrate führt zu besserer Audioqualität auf Kosten von höherem Speicherplatzverbrauch.';

  @override
  String get transcodeHint => 'Transkodieren?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Als $codec @ $bitrate$_temp0 herunterladen';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate transkodiert',
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
        'other': ' als $codec @ $bitrate',
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
    return 'Original herunterladen$_temp0';
  }

  @override
  String get redownloadcomplete => 'Transcode-Neudownload in die Warteschlange gestellt.';

  @override
  String get redownloadTitle => 'Automatisch Transcodes neu herunterladen';

  @override
  String get redownloadSubtitle => 'Automatisch Tracks erneut herunterladen, die aufgrund von Änderungen übergeordneter Elemente vermutlich eine andere Qualität haben.';

  @override
  String get defaultDownloadLocationButton => 'Als Standard Download-Ort festlegen.  Ausschalten, um den Ort per Download festzulegen.';

  @override
  String get fixedGridSizeSwitchTitle => 'Rasterkacheln fester Größe verwenden';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Die Größe der Rasterkacheln reagiert nicht auf die Fenster-/Bildschirmgröße.';

  @override
  String get fixedGridSizeTitle => 'Größe der Rasterkacheln';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Klein',
        'medium': 'Mittel',
        'large': 'Groß',
        'veryLarge': 'Sehr groß',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'SplitScreen-Modus erlauben';

  @override
  String get allowSplitScreenSubtitle => 'Die Wiedergabe-Ansicht wird auf breiteren Bildschirmen neben anderen Ansichten gezeigt.';

  @override
  String get enableVibration => 'Vibration aktivieren';

  @override
  String get enableVibrationSubtitle => 'Ob Vibration aktiviert werden soll.';

  @override
  String get hideQueueButton => 'Warteschlangen-Button verstecken';

  @override
  String get hideQueueButtonSubtitle => 'Verstecke den Warteschlangen-Button in der Wiedergabe-Ansicht. Swipe nach oben, um auf die Warteschlange zuzugreifen.';

  @override
  String get oneLineMarqueeTextButton => 'Auto-Scrollen bei langen Titeln';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Automatisch Titel scrollen, wenn sie länger als zwei Zeilen sind';

  @override
  String get marqueeOrTruncateButton => 'Ellipse für lange Titel verwenden';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Am Ende zu langer Tracktitel ... anzeigen, statt zu scrollen';

  @override
  String get hidePlayerBottomActions => 'Untere Aktionen verstecken';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Verstecke die Warteschlange- und Lyrics-Buttons in der Wiedergabe-Ansicht. Swipe nach oben, um die Warteschlange anzuzeigen, und swipe nach links (unterhalb des Album Covers), um verfügbare Lyrics anzuzeigen.';

  @override
  String get prioritizePlayerCover => 'Album Cover priorisieren';

  @override
  String get prioritizePlayerCoverSubtitle => 'Ein größeres Album Cover in der Wiedergabe-Ansicht bevorzugen. Unwichtigere Optionen werden auf kleineren Bildschirmen mit höherer Wahrscheinlichkeit versteckt.';

  @override
  String get suppressPlayerPadding => 'Abstand um die Player Controls unterdrücken';

  @override
  String get suppressPlayerPaddingSubtitle => 'Minimiert den Abstand zwischen Controls in der Wiedergabe-Ansicht, wenn das Album Cover nicht die volle Größe hat.';

  @override
  String get lockDownload => 'Immer auf dem Gerät belassen';

  @override
  String get showArtistChipImage => 'Künstlerbilder mit Künstlernamen anzeigen';

  @override
  String get showArtistChipImageSubtitle => 'Dies betrifft kleine Vorschaubilder von Künstlern, z.B. in der Wiedergabe-Ansicht.';

  @override
  String get scrollToCurrentTrack => 'Zum aktuellen Titel scrollen';

  @override
  String get enableAutoScroll => 'Automatisches Scrollen aktivieren';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz kHz';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit Bit';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration verbleibend';
  }

  @override
  String get removeFromPlaylistConfirm => 'Entfernen';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return '\'$itemName\' aus der Playlist \'$playlistName\' entfernen?';
  }

  @override
  String get trackMenuButtonTooltip => 'Track Menü';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get addRemoveFromPlaylist => 'Zu Playlist hinzufügen oder entfernen';

  @override
  String get addPlaylistSubheader => 'Track zu einer Playlist hinzufügen';

  @override
  String get trackOfflineFavorites => 'Alle Favoriten-Markierungen synchronisieren';

  @override
  String get trackOfflineFavoritesSubtitle => 'Hierdurch werden im Offline-Modus aktuellere Favoriten-Markierungen angezeigt. Es werden keine zusätzlichen Dateien heruntergeladen.';

  @override
  String get allPlaylistsInfoSetting => 'Playlists-Metadaten herunterladen';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Metadaten für alle Playlisten synchronisieren, um dein Playlist-Erlebnis zu verbessern';

  @override
  String get downloadFavoritesSetting => 'Alle Favoriten herunterladen';

  @override
  String get downloadAllPlaylistsSetting => 'Alle Playlisten herunterladen';

  @override
  String get fiveLatestAlbumsSetting => 'Die 5 neuesten Alben herunterladen';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Downloads werden entfernt, sobald sie nicht mehr aktuell sind. Sperre den Download, um zu verhindern, dass ein Album entfernt wird.';

  @override
  String get cacheLibraryImagesSettings => 'Bilder der aktiven Bibliothek zwischenspeichern';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Alle Album-, Künstler-, Genre- und Playlist-Cover der momentan aktiven Bibliothek werden heruntergeladen.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Playback-Fortschritt im In-App-Miniplayer anzeigen';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Steuert, ob der In-App-Miniplayer bzw. die aktuelle Wiedergabeleiste unten in der Wiedergabe-Ansicht als Fortschrittsbalken fungiert.';

  @override
  String get lyricsScreen => 'Lyrics-Ansicht';

  @override
  String get showLyricsTimestampsTitle => 'Timestamps für synchronisierte Lyrics anzeigen';

  @override
  String get showLyricsTimestampsSubtitle => 'Steuert, ob der Timestamp jeder Lyrics-Zeile in der Lyrics-Ansicht angezeigt wird, falls verfügbar.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Stopp-Button in der Medienbenachrichtigung anzeigen';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Legt fest, ob die Medienbenachrichtung einen Stopp-Button zusätzlich zum Pause-Button hat. Hierdurch kannst du die Wiedergabe stoppen, ohne die App zu öffnen.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Zeige die Suchleiste in der Medienbenachrichtigung an';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Legt fest, ob die Medienbenachrichtigung eine scrollbare Fortschrittsanzeige hat. Das lässt dich die Wiedergabeposition ändern, ohne die App öffnen zu müssen.';

  @override
  String get alignmentOptionStart => 'Start';

  @override
  String get alignmentOptionCenter => 'Zentriert';

  @override
  String get alignmentOptionEnd => 'Ende';

  @override
  String get fontSizeOptionSmall => 'Klein';

  @override
  String get fontSizeOptionMedium => 'Mittel';

  @override
  String get fontSizeOptionLarge => 'Groß';

  @override
  String get lyricsAlignmentTitle => 'Ausrichtung der Lyrics';

  @override
  String get lyricsAlignmentSubtitle => 'Legt die Ausrichtung von Lyrics in der Lyrics-Ansicht fest.';

  @override
  String get lyricsFontSizeTitle => 'Schriftgröße der Lyrics';

  @override
  String get lyricsFontSizeSubtitle => 'Legt die Schriftgröße von Lyrics in der Lyrics-Ansicht fest.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Album vor den Lyrics anzeigen';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Legt fest, ob das Album Cover über den Lyrics angezeigt wird, bevor es weggescrollt wird.';

  @override
  String get keepScreenOn => 'Bildschirm eingeschaltet lassen';

  @override
  String get keepScreenOnSubtitle => 'Wann der Bildschirm eingeschaltet bleiben soll';

  @override
  String get keepScreenOnDisabled => 'Deaktiviert';

  @override
  String get keepScreenOnAlwaysOn => 'Immer eingeschaltet';

  @override
  String get keepScreenOnWhilePlaying => 'Beim Abspielen von Musik';

  @override
  String get keepScreenOnWhileLyrics => 'Beim Anzeigen von Lyrics';

  @override
  String get keepScreenOnWhilePluggedIn => 'Bildschirm nur eingeschaltet lassen, während das Gerät geladen wird';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Die \"Bildschirm eingeschaltet lassen\" Einstellungen ignorieren, wenn das Gerät nicht aufgeladen wird';

  @override
  String get genericToggleButtonTooltip => 'Tippe, um umzuschalten.';

  @override
  String get artwork => 'Grafiken';

  @override
  String artworkTooltip(String title) {
    return 'Grafiken für $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Grafiken für $title. Tippe, um Wiedergabe umzuschalten. Swipe nach links oder rechts, um den Track zu wechseln.';
  }

  @override
  String get nowPlayingBarTooltip => 'Öffne die Wiedergabe-Ansicht';

  @override
  String get additionalPeople => 'Personen';

  @override
  String get playbackMode => 'Wiedergabe Modus';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Bittiefe';

  @override
  String get size => 'Größe';

  @override
  String get normalizationGain => 'Gain';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get showFeatureChipsToggleTitle => 'Zeige erweiterte Track-Informationen an';

  @override
  String get showFeatureChipsToggleSubtitle => 'Zeige erweiterte Track-Informationen wie Codec, Bit Rate und mehr in der Wiedergabe-Ansicht an.';

  @override
  String get albumScreen => 'Album-Ansicht';

  @override
  String get showCoversOnAlbumScreenTitle => 'Zeige Album Cover für Tracks';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Zeige Alben Cover in der Album-Ansicht separat für jeden einzelnen Track.';

  @override
  String get emptyTopTracksList => 'Du hast noch keinen Track von diesem Künstler gehört.';

  @override
  String get emptyFilteredListTitle => 'Keine Elemente gefunden';

  @override
  String get emptyFilteredListSubtitle => 'Keine Tracks treffen auf den Filter zu. Versuche, den Filter zu deaktivieren oder den Suchbegriff zu änden.';

  @override
  String get resetFiltersButton => 'Filter zurücksetzen';

  @override
  String get resetSettingsPromptGlobal => 'Bist du dir sicher, dass du ALLE Einstellungen auf die Standardwerte zurücksetzen willst?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'ALLE Einstellungen zurücksetzen';

  @override
  String get resetSettingsPromptLocal => 'Möchtest du diese Einstellungen auf die Standardwerte zurücksetzen?';

  @override
  String get genericCancel => 'Abbrechen';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Künstler',
        'genre': 'Genre',
        'track': 'Titel',
        'library': 'Bibliothek',
        'other': 'Item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'vom Gerät',
        'server': 'vom Server',
        'other': 'unknown',
      },
    );
    return '$_temp0 wurde $_temp1 gelöscht';
  }

  @override
  String get allowDeleteFromServerTitle => 'Serverseitiges Löschen von Medien erlauben';

  @override
  String get allowDeleteFromServerSubtitle => 'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'das Album',
        'playlist': 'die Playlist',
        'artist': 'den Künstler',
        'genre': 'das Genre',
        'track': 'den Track',
        'library': 'die Bibliothek',
        'other': 'das Item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Das Item wird dadurch auch von diesem Gerät gelöscht.',
        'cantDelete': ' Das Item wird bis zur nächsten Synchronisierung auf diesem Gerät bleiben.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'von diesem Gerät zu löschen',
        'server': 'von der Bibliothek und dem Dateisystem des Servers zu löschen.$_temp1\nDiese Aktion kann nicht rückgängig gemacht werden',
        'other': '',
      },
    );
    return 'Du bist dabei, $_temp0 $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': 'Vom Gerät löschen',
        'server': 'Vom Server löschen',
        'other': 'Löschen',
      },
    );
    return '$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Warnung: Du bist dabei, $count Tracks herunterzuladen.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Download-Größenbegrenzung für Warnung';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'Eine Warnung wird angezeigt, wenn du mehr als die hier angegebene Anzahl an Tracks herunterladen möchest.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'dem Album',
        'playlist': 'der Playlist',
        'artist': 'dem Künstler',
        'genre': 'dem Genre',
        'other': 'dem Item',
      },
    );
    return 'Bist du sicher, dass du alles Tracks von $_temp0 \'$itemName\' zu dieser Playlist hinzufügen möchtest? Du kannst sie nur einzeln wieder entfernen.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Öffentlich sichtbar:';

  @override
  String get releaseDateFormatYear => 'Jahr';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Monat & Jahr';

  @override
  String get releaseDateFormatMonthDayYear => 'Monat, Tag & Jahr';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Album Release-Datum in der Wiedergabe-Ansicht anzeigen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Zeigt das Release-Datum des Albums nach dem Albumnamen in der Wiedergabe-Ansicht an.';

  @override
  String get releaseDateFormatTitle => 'Release-Datum Format';

  @override
  String get releaseDateFormatSubtitle => 'Steuert das Format aller Release-Daten in der App.';

  @override
  String get librarySelectError => 'Error loading available libraries for user';
}
