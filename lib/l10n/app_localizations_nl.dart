// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Een open source Jellyfin muziekspeler';

  @override
  String startupError(String error) {
    return 'Er ging iets mis bij het starten van de app. Dit was de foutmelding: $error\n\nCreëer een issue op github.com/UnicornsOnLSD/finamp met een schermafbeelding van deze pagina. Wanneer het probleem zich vaker voordoet, kan je de app-data verwijderen om de app te resetten.';
  }

  @override
  String get about => 'Over Finamp';

  @override
  String get aboutContributionPrompt => 'Gemaakt door geweldige mensen in hun vrije tijd.\nJij zou er ook een van kunnen zijn!';

  @override
  String get aboutContributionLink => 'Draag bij aan Finamp op GitHub:';

  @override
  String get aboutReleaseNotes => 'Lees de notities over de laatste uitgave:';

  @override
  String get aboutTranslations => 'Help Finamp vertalen in jouw taal:';

  @override
  String get aboutThanks => 'Bedankt voor het gebruiken van Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Welkom bij';

  @override
  String get loginFlowSlogan => 'Jouw muziek, zoals jij het wilt.';

  @override
  String get loginFlowGetStarted => 'Aan de slag!';

  @override
  String get viewLogs => 'Logboeken bekijken';

  @override
  String get changeLanguage => 'Verander Taal';

  @override
  String get loginFlowServerSelectionHeading => 'Verbinden met Jellyfin';

  @override
  String get back => 'Terug';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get internalExternalIpExplanation => 'Om toegang tot de Jellyfin server te krijgen op afstand, dien je een extern IP te gebruiken.\n\nWanneer de server een HTTP-standaardpoort (80 of 443) of Jellyfins standaardpoort (8096) gebruikt, hoef je deze niet in te vullen.\n\nAls de URL correct is, zou hieronder er wat informatie moeten verschijnen over jouw server.';

  @override
  String get serverUrlHint => 'bijv. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Server URL Help';

  @override
  String get emptyServerUrl => 'De URL van je server mag niet leeg zijn';

  @override
  String get connectingToServer => 'Verbindt met server…';

  @override
  String get loginFlowLocalNetworkServers => 'Servers in jouw lokale netwerk:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Zoeken naar servers…';

  @override
  String get loginFlowAccountSelectionHeading => 'Selecteer jouw account';

  @override
  String get backToServerSelection => 'Terug naar Server Selectie';

  @override
  String get loginFlowNamelessUser => 'Naamloze Gebruiker';

  @override
  String get loginFlowCustomUser => 'Eigen gebruiker';

  @override
  String get loginFlowAuthenticationHeading => 'Log in op je account';

  @override
  String get backToAccountSelection => 'Terug naar Account Selectie';

  @override
  String get loginFlowQuickConnectPrompt => 'Gebruik Quick Connect code';

  @override
  String get loginFlowQuickConnectInstructions => 'Open de Jellyfin app of website, klik op je gebruikersicoon, en selecteer Quick Connect.';

  @override
  String get loginFlowQuickConnectDisabled => 'Quick Connect staat uitgeschakeld op deze server.';

  @override
  String get orDivider => 'of';

  @override
  String get loginFlowSelectAUser => 'Selecteer een gebruiker';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get usernameHint => 'Vul je gebruikersnaam in';

  @override
  String get usernameValidationMissingUsername => 'Vul alsjeblieft een gebruikersnaam in';

  @override
  String get password => 'Wachtwoord';

  @override
  String get passwordHint => 'Vul je wachtwoord in';

  @override
  String get login => 'Log In';

  @override
  String get logs => 'Logbestanden';

  @override
  String get next => 'Volgende';

  @override
  String get selectMusicLibraries => 'Selecteer Muziekbibliotheken';

  @override
  String get couldNotFindLibraries => 'Kon geen bibliotheken vinden.';

  @override
  String get unknownName => 'Onbekende Naam';

  @override
  String get tracks => 'Nummers';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artiesten';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Afspeellijsten';

  @override
  String get startMix => 'Mix starten';

  @override
  String get startMixNoTracksArtist => 'Druk lang op een artiest om deze toe te voegen of te verwijderen van de mix-bouwer alvorens de mix te starten';

  @override
  String get startMixNoTracksAlbum => 'Druk lang op een album om deze toe te voegen of te verwijderen van de mix-bouwer alvorens de mix te starten';

  @override
  String get startMixNoTracksGenre => 'Druk lang op een genre om deze toe te voegen of te verwijderen van de mix-bouwer alvorens een mix te starten';

  @override
  String get music => 'Muziek';

  @override
  String get clear => 'Opschonen';

  @override
  String get favourites => 'Favorieten';

  @override
  String get shuffleAll => 'Alles shufflen';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Instellingen';

  @override
  String get offlineMode => 'Offline Modus';

  @override
  String get sortOrder => 'Sorteervolgorde';

  @override
  String get sortBy => 'Sorteer met';

  @override
  String get title => 'Titel';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Album Artiest';

  @override
  String get artist => 'Artiest';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Gemeenschapsbeoordeling';

  @override
  String get criticRating => 'Criticusbeoordeling';

  @override
  String get dateAdded => 'Datum toegevoegd';

  @override
  String get datePlayed => 'Datum afgespeeld';

  @override
  String get playCount => 'Aantal keren afgespeeld';

  @override
  String get premiereDate => 'Premieredatum';

  @override
  String get productionYear => 'Productiejaar';

  @override
  String get name => 'Naam';

  @override
  String get random => 'Willekeurig';

  @override
  String get revenue => 'Inkomsten';

  @override
  String get runtime => 'Duur';

  @override
  String get syncDownloadedPlaylists => 'Sync gedownloade afspeellijsten';

  @override
  String get downloadMissingImages => 'Download ontbrekende plaatjes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ontbrekende plaatjes gedownloaded',
      one: '$count ontbrekend plaatje gedownloaded',
      zero: 'Geen ontbrekende plaatjes gevonden',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Actieve Downloads';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads',
      one: '$count download',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount nummers',
      one: '$trackCount nummer',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount plaatjes',
      one: '$imageCount plaatje',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount synchroniseren',
      one: '$syncCount synchroniseert',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nCurrently repairing',
      zero: '',
    );
    return '$_temp0, $_temp1\n\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count volledig';
  }

  @override
  String dlFailed(int count) {
    return '$count mislukt';
  }

  @override
  String dlEnqueued(int count) {
    return '$count gepland';
  }

  @override
  String dlRunning(int count) {
    return '$count bezig';
  }

  @override
  String get activeDownloadsTitle => 'Actieve Downloads';

  @override
  String get noActiveDownloads => 'Geen actieve downloads.';

  @override
  String get errorScreenError => 'Er is een fout opgetreden bij het opvragen van de lijst met foutmeldingen! Waarschijnlijk kun je het beste proberen een issue aan te maken op GitHub, en de app data te verwijderen';

  @override
  String get failedToGetTrackFromDownloadId => 'Het nummer kon niet gevonden worden met deze download ID';

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
    return 'Weet je zeker dat je $_temp0 \'$itemName\' van dit apparaat wilt verwijderen?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Verwijder';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Fout';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'Afspelen';

  @override
  String get shuffleButtonLabel => 'Shuffle';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nummers',
      one: '$count Nummer',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '$count nummer',
    );
    return '$_temp0, $downloads gedownload';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '$count Track',
    );
    return '$_temp0 gedownload';
  }

  @override
  String get editPlaylistNameTooltip => 'Pas de naam van de playlist aan';

  @override
  String get editPlaylistNameTitle => 'Pas de naam van de Playlist aan';

  @override
  String get required => 'Verplicht';

  @override
  String get updateButtonLabel => 'Update';

  @override
  String get playlistNameUpdated => 'De naam van de playlist is aangepast.';

  @override
  String get favourite => 'Favoriet';

  @override
  String get downloadsDeleted => 'Downloads verwijderd.';

  @override
  String get addDownloads => 'Voeg downloads toe';

  @override
  String get location => 'Plaats';

  @override
  String get confirmDownloadStarted => 'Download gestart';

  @override
  String get downloadsQueued => 'Downloads toegevoegd.';

  @override
  String get addButtonLabel => 'Toevoegen';

  @override
  String get shareLogs => 'Deel de log';

  @override
  String get logsCopied => 'De log is gekopieerd.';

  @override
  String get message => 'Bericht';

  @override
  String get stackTrace => 'Strack-trace';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Uitgegeven onder de Mozilla Public License 2.0.\nBroncode beschikbaar op $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Converteren';

  @override
  String get downloadLocations => 'Downloadlocaties';

  @override
  String get audioService => 'Audiodienst';

  @override
  String get interactions => 'Interacties';

  @override
  String get layoutAndTheme => 'Layout & Thema';

  @override
  String get notAvailableInOfflineMode => 'Niet beschikbaar in offline-modus';

  @override
  String get logOut => 'Uitloggen';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Gedownloade nummers worden niet verwijderd';

  @override
  String get areYouSure => 'Bent u zeker?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin gebruikt AAC voor conversie';

  @override
  String get enableTranscoding => 'Conversie inschakelen';

  @override
  String get enableTranscodingSubtitle => 'Converteert muziekstreams op de server.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle => 'Het gebruik van een hogere bitrate geeft betere audiokwaliteit, maar gebruikt meer netwerkbandbreedte.';

  @override
  String get customLocation => 'Persoonlijke locatie';

  @override
  String get appDirectory => 'Applicatie folder';

  @override
  String get addDownloadLocation => 'Voeg een downloadlocatie toe';

  @override
  String get selectDirectory => 'Selecteer map';

  @override
  String get unknownError => 'Onbekende Fout';

  @override
  String get pathReturnSlashErrorMessage => 'Paden met \"/\" kunnen niet worden gebruikt';

  @override
  String get directoryMustBeEmpty => 'Folder moet leeg zijn';

  @override
  String get customLocationsBuggy => 'Persoonlijke locaties hebben veel bug door permissies. We denken over oplossingen hiervoor. Voor nu raden we aan deze niet te gebruiken.';

  @override
  String get enterLowPriorityStateOnPause => 'Ga naar Lage-Prioriteit Staat tijdens Pauzeren';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'De notificatie kan weggeswiped worden wanneer gepauseerd. Hierdoor kan Android de service stoppen.';

  @override
  String get shuffleAllTrackCount => 'Aantal nummers in de shuffle';

  @override
  String get shuffleAllTrackCountSubtitle => 'Hoeveelheid nummers die geladen moeten worden bij gebruik van de shuffle knop.';

  @override
  String get viewType => 'Type bekijken';

  @override
  String get viewTypeSubtitle => 'Type voor het muziekscherm bekijken';

  @override
  String get list => 'Lijst';

  @override
  String get grid => 'Raster';

  @override
  String get customizationSettingsTitle => 'Aanpassingen';

  @override
  String get playbackSpeedControlSetting => 'Zichtbaarheid Afspeelsnelheid';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Of de afspeelsnelheid-knoppen zichtbaar moeten zijn in het speler menu';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automatisch:\nFinamp probeert in te schatten of het nummer waar je momenteel naar luistert een podcast is, of het (een onderdeel van) een audioboek is. Dit wordt aangenomen als het nummer langer duurt dan $trackDuration minuten, of als het gehele album langer duurt dan $albumDuration uur, of als het nummer tot één van de volgende genres behoort: $genreList\nDe knoppen om de afspeelsnelheid te bedienen worden dan zichtbaar gemaakt in het muziekspeler scherm.\n\nZichtbaar:\nDe knoppen om de afspeelsnelheid te bedienen zullen altijd zichtbaar zijn in het muziekspeler scherm.\n\nVerborgen:\nDe knoppen om de afspeelsnelheid te bedienen zullen niet zichtbaar zijn in het muziekspeler scherm.';
  }

  @override
  String get automatic => 'Automatisch';

  @override
  String get shown => 'Zichtbaar';

  @override
  String get hidden => 'Verborgen';

  @override
  String get speed => 'Snelheid';

  @override
  String get reset => 'Herstel';

  @override
  String get apply => 'Toepassen';

  @override
  String get portrait => 'Portret';

  @override
  String get landscape => 'Landschap';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Aantal assen';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Hoeveelheid rijen te gebruiken in $value-modus.';
  }

  @override
  String get showTextOnGridView => 'Tekst in rooster tonen';

  @override
  String get showTextOnGridViewSubtitle => 'Tekst (titel, artiest, etc.) laten zien op het muziekscherm.';

  @override
  String get useCoverAsBackground => 'Geblurde cover op spelerachtergrond tonen';

  @override
  String get useCoverAsBackgroundSubtitle => 'Geblurde coverafbeelding gebruiken als achtergrond van het afspeelscherm.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimale ruimte rond albumhoes';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimale ruimte rond albumhoes in het scherm van de muziekspeler, in % van breedte van het scherm.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Artiest van nummer verbergen wanneer deze hetzelfde is als de albumartiest';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Artiest van nummer tonen wanneer deze hetzelfde is als de albumartiest.';

  @override
  String get showArtistsTopTracks => 'Laat meest beluisterde nummers zien in artiest scherm';

  @override
  String get showArtistsTopTracksSubtitle => 'Wel of niet laten zien van top 5 beluisterde nummers van een artiest.';

  @override
  String get disableGesture => 'Gebaren uitschakelen';

  @override
  String get disableGestureSubtitle => 'Gebaren in- of uitschakelen.';

  @override
  String get showFastScroller => 'Laat snelle scroller zien';

  @override
  String get theme => 'Thema';

  @override
  String get system => 'Systeem';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get tabs => 'Tabs';

  @override
  String get playerScreen => 'Speler Scherm';

  @override
  String get cancelSleepTimer => 'Annuleer sleep timer?';

  @override
  String get yesButtonLabel => 'Ja';

  @override
  String get noButtonLabel => 'Nee';

  @override
  String get setSleepTimer => 'Slaaptimer instellen';

  @override
  String get hours => 'Uren';

  @override
  String get seconds => 'Seconden';

  @override
  String get minutes => 'Minuten';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime van $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Nummer $currentTrackIndex van $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Ongeldig getal';

  @override
  String get sleepTimerTooltip => 'Slaaptimer';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Slapen over $time minuten';
  }

  @override
  String get addToPlaylistTooltip => 'Toevoegen aan afspeellijst';

  @override
  String get addToPlaylistTitle => 'Toevoegen aan afspeellijst';

  @override
  String get addToMorePlaylistsTooltip => 'Toevoegen aan meer afspeellijsten';

  @override
  String get addToMorePlaylistsTitle => 'Toevoegen aan Meer Afspeellijsten';

  @override
  String get removeFromPlaylistTooltip => 'Verwijder van deze afspeellijst';

  @override
  String get removeFromPlaylistTitle => 'Verwijder Van Deze Afspeellijst';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Verwijderen van afspeellijst \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Verwijderen van Afspeellijst \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nieuwe afspeellijst';

  @override
  String get createButtonLabel => 'Creëer';

  @override
  String get playlistCreated => 'Afspeellijst gecreëerd.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Tik om toe te voegen aan afspeellijst. Houd ingedrukt om toe te voegen aan favorieten.';

  @override
  String get noAlbum => 'Geen album';

  @override
  String get noItem => 'Geen element';

  @override
  String get noArtist => 'Geen artiest';

  @override
  String get unknownArtist => 'Onbekende artiest';

  @override
  String get unknownAlbum => 'Onbekend Album';

  @override
  String get playbackModeDirectPlaying => 'Direct Afspelen';

  @override
  String get playbackModeTranscoding => 'Transcoderen';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Lokaal Afspelen';

  @override
  String get queue => 'Afspeelrij';

  @override
  String get addToQueue => 'Voeg toe aan rij';

  @override
  String get replaceQueue => 'Afspeelrij vervangen';

  @override
  String get instantMix => 'Instant mix';

  @override
  String get goToAlbum => 'Ga naar album';

  @override
  String get goToArtist => 'Ga naar Artiest';

  @override
  String get goToGenre => 'Ga naar Genre';

  @override
  String get removeFavourite => 'Verwijder favoriet';

  @override
  String get addFavourite => 'Toevoegen aan favorieten';

  @override
  String get confirmFavoriteAdded => 'Toevoegen aan Favorieten';

  @override
  String get confirmFavoriteRemoved => 'Verwijderen uit Favorieten';

  @override
  String get addedToQueue => 'Toegevoegd aan rij.';

  @override
  String get insertedIntoQueue => 'Toegevoegd aan wachtrij.';

  @override
  String get queueReplaced => 'Rij vervangen.';

  @override
  String get confirmAddedToPlaylist => 'Toegevoegd aan afspeellijst.';

  @override
  String get removedFromPlaylist => 'Verwijderd van afspeellijst.';

  @override
  String get startingInstantMix => 'Instantmix starten.';

  @override
  String get anErrorHasOccured => 'Er is een fout opgetreden.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status code $statusCode. Dit betekenr waarschijnlijk dat u de verkeerde gebruikersnaam/wachtwoord hebt gebruikt, of uw apparaat niet langer geauthenticeerd is.';
  }

  @override
  String get removeFromMix => 'Uit mix verwijderen';

  @override
  String get addToMix => 'Aan mix toevoegen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count elementen opnieuw gedownload',
      one: '$count element opnieuw gedownload',
      zero: 'Geen downloads nodig.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Bufferlengte';

  @override
  String get bufferDurationSubtitle => 'De lengte van de buffer, in seconden. Dit vereist een herstart.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Beperk bufferlimiet niet';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Schakelt buffergrootte beperking uit (\'Buffergrootte\'). De buffer zal altijd ingeladen worden zoals geconfigureerd volgens de bufferlengte (\'Bufferlengte\'), zelfs voor grotere bestanden. Dit kan een crash veroorzaken. Vereist een herstart.';

  @override
  String get bufferSizeTitle => 'Buffergrootte';

  @override
  String get bufferSizeSubtitle => 'De maximale buffergrootte in MB. Vereist een herstart';

  @override
  String get language => 'Taal';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Ga naar begin of naar vorige nummer';

  @override
  String get skipToNextTrackButtonTooltip => 'Ga naar volgende nummer';

  @override
  String get togglePlaybackButtonTooltip => 'Toggle playback';

  @override
  String get previousTracks => 'Vorige Nummers';

  @override
  String get nextUp => 'Volgende';

  @override
  String get clearNextUp => 'Verwijder Volgende';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Afspelen van';

  @override
  String get playNext => 'Hierna afspelen';

  @override
  String get addToNextUp => 'Toevoegen aan Volgende';

  @override
  String get shuffleNext => 'Shuffle als volgende';

  @override
  String get shuffleToNextUp => 'Shuffle naar Volgende';

  @override
  String get shuffleToQueue => 'Shuffle naar Wachtrij';

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
    return '$_temp0 zal hierna afspelen';
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
    return '$_temp0 toegevoegd aan Volgende';
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
    return '$_temp0 toegevoegd aan wachtrij';
  }

  @override
  String get confirmShuffleNext => 'Zal hierna shuffelen';

  @override
  String get confirmShuffleToNextUp => 'Geshuffeld naar Volgende';

  @override
  String get confirmShuffleToQueue => 'Geshuffeld naar wachtrij';

  @override
  String get placeholderSource => 'Ergens';

  @override
  String get playbackHistory => 'Afspeel Geschiedenis';

  @override
  String get shareOfflineListens => 'Deel offline geluisterd';

  @override
  String get yourLikes => 'Mijn Favorieten';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Nummers toegevoegd aan Volgende';

  @override
  String get savedQueue => 'Opgeslagen Wachtrij';

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
    return 'Afspelen Van $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Shuffle Alles';

  @override
  String get playbackOrderLinearButtonLabel => 'Afspelen op volgorde';

  @override
  String get playbackOrderLinearButtonTooltip => 'Afspelen op volgorde. Tik om te shuffelen.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Shuffel nummers';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Shuffel nummers. Tik voor afspelen op volgorde.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Afspelen op x$speed snelheid';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed snelheid';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Verlaag afspeelsnelheid';

  @override
  String get playbackSpeedIncreaseLabel => 'Verhoog afspeelsnelheid';

  @override
  String get loopModeNoneButtonLabel => 'Niet herhalen';

  @override
  String get loopModeOneButtonLabel => 'Herhaal dit nummer';

  @override
  String get loopModeAllButtonLabel => 'Herhaal alles';

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
  String get confirm => 'Bevestigen';

  @override
  String get close => 'Close';

  @override
  String get showUncensoredLogMessage => 'Dit logboek bevat uw inloggegevens. Tonen?';

  @override
  String get resetTabs => 'Tabbladen resetten';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get noMusicLibrariesTitle => 'No Music Libraries';

  @override
  String get noMusicLibrariesBody => 'Finamp could not find any music libraries. Please ensure that your Jellyfin server contains at least one library with the content type set to \"Music\".';

  @override
  String get refresh => 'Refresh';

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
  String get swipeInsertQueueNext => 'Play Swiped Track Next';

  @override
  String get swipeInsertQueueNextSubtitle => 'Enable to insert a track as next item in queue when swiped in track list instead of appending it to the end.';

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
  String get onlyShowFullyDownloaded => 'Laat alleen volledig gedownloade albums zien';

  @override
  String get filesystemFull => 'Overgebleven downloads kunnen niet worden afgewerkt. Het bestandssysteem zit vol.';

  @override
  String get connectionInterrupted => 'Connectie is onderbroken, pauzeren van downloads.';

  @override
  String get connectionInterruptedBackground => 'Connectie werd onderbroken terwijl downloads bezig waren. Dit kan veroorzaakt zijn door instellingen in het OS.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Connectie werd onderbroken terwijl downloads bezig waren. Dit kan veroorzaakt zijn door aanzetten \'Ga naar Lage-Prioriteit Staat tijdens Pauzeren\' of OS instellingen.';

  @override
  String get activeDownloadSize => 'Downloaden...';

  @override
  String get missingDownloadSize => 'Verwijderen...';

  @override
  String get syncingDownloadSize => 'Synchroniseren...';

  @override
  String get runRepairWarning => 'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Show Media with Unknown Library.';

  @override
  String get showNullLibraryItemsSubtitle => 'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => 'Max Gelijktijdige Downloads';

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
  String get alignmentOptionStart => 'Begin';

  @override
  String get alignmentOptionCenter => 'Centrum';

  @override
  String get alignmentOptionEnd => 'Einde';

  @override
  String get fontSizeOptionSmall => 'Klein';

  @override
  String get fontSizeOptionMedium => 'Gemiddeld';

  @override
  String get fontSizeOptionLarge => 'Groot';

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
  String get keepScreenOn => 'Houd Scherm Aan';

  @override
  String get keepScreenOnSubtitle => 'Wanneer het scherm aan te houden';

  @override
  String get keepScreenOnDisabled => 'Uitgeschakeld';

  @override
  String get keepScreenOnAlwaysOn => 'Altijd Aan';

  @override
  String get keepScreenOnWhilePlaying => 'Tijdens Muziek Afspelen';

  @override
  String get keepScreenOnWhileLyrics => 'While Showing Lyrics';

  @override
  String get keepScreenOnWhilePluggedIn => 'Houd Scherm Aan alleen tijdens opladen';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Negeer de Houd Scherm Aan instelling als apparaat niet oplaad';

  @override
  String get genericToggleButtonTooltip => 'Tik om te schakelen.';

  @override
  String get artwork => 'Albumhoes';

  @override
  String artworkTooltip(String title) {
    return 'Albumhoes voor $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Artwork for $title. Tap to toggle playback. Swipe left or right to switch tracks.';
  }

  @override
  String get nowPlayingBarTooltip => 'Open Spelerscherm';

  @override
  String get additionalPeople => 'Mensen';

  @override
  String get playbackMode => 'Afspeelmodus';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bitrate';

  @override
  String get bitDepth => 'Bit Diepte';

  @override
  String get size => 'Grootte';

  @override
  String get normalizationGain => 'Gain';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get showFeatureChipsToggleTitle => 'Zichtbaarheid Geavanceerde Nummer Informatie';

  @override
  String get showFeatureChipsToggleSubtitle => 'Laat geavanceerde nummer informatie als codec, bitrate, en meer zien op het spelerscherm.';

  @override
  String get albumScreen => 'Albumscherm';

  @override
  String get showCoversOnAlbumScreenTitle => 'Laat Album Hoezen Zien Voor Nummers';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Laat voor ieder nummer de bijbehorende album hoes zien, waar nummers geselecteerd kunnen worden.';

  @override
  String get emptyTopTracksList => 'Je hebt nog niet naar muziek geluisterd van deze artiest.';

  @override
  String get emptyFilteredListTitle => 'Niets gevonden';

  @override
  String get emptyFilteredListSubtitle => 'Niets komt overeen met deze filter. Zet het filter uit, of probeer een andere zoekterm.';

  @override
  String get resetFiltersButton => 'Verwijder filters';

  @override
  String get resetSettingsPromptGlobal => 'Weet je zeker dat je ALLE instellingen wilt terugzetten naar de standaard waarden?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Reset ALLE instellingen';

  @override
  String get resetSettingsPromptLocal => 'Wil je deze instellingen terugzetten naar de standaard waarden?';

  @override
  String get genericCancel => 'Stoppen';

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
