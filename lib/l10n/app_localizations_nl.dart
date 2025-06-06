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
  String get startupErrorTitle =>
      'Er ging iets mis bij het opstarten van de app!\nSorry daarvoor...';

  @override
  String get startupErrorCallToAction =>
      'Maak aub een issue aan op github.com/jmshrv/finamp met de logs (!) (gebruik de knop hieronder) en een screenshot van deze pagina zodat we dit zo snel mogelijk kunnen oplossen.';

  @override
  String get startupErrorWorkaround =>
      'Als een alternatieve oplossing kan je de app data verwijderen om de app te resetten. Hierdoor verlies je wel al je instellingen en downloads.';

  @override
  String get about => 'Over Finamp';

  @override
  String get aboutContributionPrompt =>
      'Gemaakt door geweldige mensen in hun vrije tijd.\nJij zou er ook een van kunnen zijn!';

  @override
  String get aboutContributionLink => 'Draag bij aan Finamp op GitHub:';

  @override
  String get aboutReleaseNotes => 'Lees de notities over de laatste uitgave:';

  @override
  String get aboutTranslations => 'Help Finamp vertalen in jouw taal:';

  @override
  String get aboutThanks => 'Bedankt voor het gebruiken van Finamp!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Welkom bij';
  }

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
  String get internalExternalIpExplanation =>
      'Om toegang tot de Jellyfin server te krijgen op afstand, dien je een extern IP te gebruiken.\n\nWanneer de server een HTTP-standaardpoort (80 of 443) of Jellyfins standaardpoort (8096) gebruikt, hoef je deze niet in te vullen.\n\nAls de URL correct is, zou hieronder er wat informatie moeten verschijnen over jouw server.';

  @override
  String get serverUrlHint => 'bijv. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Server URL Help';

  @override
  String get emptyServerUrl => 'De URL van je server mag niet leeg zijn';

  @override
  String get connectingToServer => 'Verbinden met de server…';

  @override
  String get loginFlowLocalNetworkServers => 'Servers in jouw lokale netwerk:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Zoeken naar servers…';

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
  String get loginFlowQuickConnectInstructions =>
      'Open de Jellyfin app of website, klik op je gebruikersicoon, en selecteer Quick Connect.';

  @override
  String get loginFlowQuickConnectDisabled =>
      'Quick Connect staat uitgeschakeld op deze server.';

  @override
  String get orDivider => 'of';

  @override
  String get loginFlowSelectAUser => 'Selecteer een gebruiker';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get usernameHint => 'Vul je gebruikersnaam in';

  @override
  String get usernameValidationMissingUsername =>
      'Vul alsjeblieft een gebruikersnaam in';

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
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Onbekende Naam';

  @override
  String get tracks => 'Nummers';

  @override
  String get albums => 'Albums';

  @override
  String get appearsOnAlbums => 'Komt voor in';

  @override
  String get artists => 'Artiesten';

  @override
  String get genres => 'Genres';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Afspeellijsten';

  @override
  String get startMix => 'Mix starten';

  @override
  String get startMixNoTracksArtist =>
      'Druk lang op een artiest om deze toe te voegen of te verwijderen van de mix-bouwer alvorens de mix te starten';

  @override
  String get startMixNoTracksAlbum =>
      'Druk lang op een album om deze toe te voegen of te verwijderen van de mix-bouwer alvorens de mix te starten';

  @override
  String get startMixNoTracksGenre =>
      'Druk lang op een genre om deze toe te voegen of te verwijderen van de mix-bouwer alvorens een mix te starten';

  @override
  String get music => 'Muziek';

  @override
  String get clear => 'Opschonen';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Alles shufflen';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Instellingen';

  @override
  String get offlineMode => 'Offline Modus';

  @override
  String get onlineMode => 'Online Mode';

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
  String get albumArtists => 'Album Artiesten';

  @override
  String get performingArtists => 'Deelnemende Artiesten';

  @override
  String get artist => 'Artiest';

  @override
  String get performingArtist => 'Performing Artist';

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
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
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
  String get errorScreenError =>
      'Er is een fout opgetreden bij het opvragen van de lijst met foutmeldingen! Waarschijnlijk kun je het beste proberen een issue aan te maken op GitHub, en de app data te verwijderen';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Het nummer kon niet gevonden worden met deze download ID';

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
  String get specialDownloads => 'Speciale downloads';

  @override
  String get libraryDownloads => 'Bibliotheek downloads';

  @override
  String get noItemsDownloaded => 'Niets gedownload.';

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
  String get playlistUpdated => 'De naam van de playlist is aangepast.';

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
  String get exportLogs => 'Save logs';

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
  String get playbackReporting => 'Afspelen Rapporteren';

  @override
  String get interactions => 'Interacties';

  @override
  String get layoutAndTheme => 'Layout & Thema';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Niet beschikbaar in Offline Modus';

  @override
  String get logOut => 'Uitloggen';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Gedownloade nummers worden niet verwijderd';

  @override
  String get areYouSure => 'Bent u zeker?';

  @override
  String get enableTranscoding => 'Conversie inschakelen';

  @override
  String get enableTranscodingSubtitle =>
      'Converteert muziekstreams op de server.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Het gebruik van een hogere bitrate geeft betere audiokwaliteit, maar gebruikt meer netwerkbandbreedte. Wordt niet toegepast op lossless codecs zoals FLAC.';

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
  String get pathReturnSlashErrorMessage =>
      'Paden met \"/\" kunnen niet worden gebruikt';

  @override
  String get directoryMustBeEmpty => 'Folder moet leeg zijn';

  @override
  String get customLocationsBuggy =>
      'Persoonlijke locaties hebben veel bugs en worden over het algemeen niet aanbevolen. Locaties onder de \"Muziek\" folder van het systeem voorkomen het opslaan van albumhoezen door begrenzingen van het besturingssysteem.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Ga naar Lage-Prioriteit Staat tijdens Pauzeren';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'De notificatie kan weggeswiped worden wanneer gepauseerd. Hierdoor kan Android de service stoppen.';

  @override
  String get shuffleAllTrackCount => 'Aantal nummers in de shuffle';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Hoeveelheid nummers die geladen moeten worden bij gebruik van de shuffle knop.';

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
  String get playbackSpeedControlSettingSubtitle =>
      'Of de afspeelsnelheid-knoppen zichtbaar moeten zijn in het speler menu';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
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
  String get showTextOnGridViewSubtitle =>
      'Tekst (titel, artiest, etc.) laten zien op het muziekscherm.';

  @override
  String get useCoverAsBackground =>
      'Geblurde cover op spelerachtergrond tonen';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Geblurde coverafbeelding gebruiken als achtergrond van het afspeelscherm.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Minimale ruimte rond albumhoes';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Minimale ruimte rond albumhoes in het scherm van de muziekspeler, in % van breedte van het scherm.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Artiest van nummer verbergen wanneer deze hetzelfde is als de albumartiest';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Artiest van nummer tonen wanneer deze hetzelfde is als de albumartiest.';

  @override
  String get autoSwitchItemCurationTypeTitle =>
      'Auto-Switch Item Curation Type';

  @override
  String get autoSwitchItemCurationTypeSubtitle =>
      'When enabled, Item Sections on the Artist and Genre Screens automatically switch to a different curation type if no items are available (e.g., no favorites for a specific artist).';

  @override
  String get showArtistsTracksSection => 'Show Tracks Section';

  @override
  String get showArtistsTracksSectionSubtitle =>
      'Whether to show a section with up to five tracks. When enabled, you can choose between Most Played, Favorite, Random, Latest Releases, Recently Added and Recently Played Tracks.';

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
  String get playlistActionsMenuButtonTooltip =>
      'Tik om toe te voegen aan afspeellijst. Houd ingedrukt om toe te voegen aan favorieten.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Geen album';

  @override
  String get noItem => 'Geen element';

  @override
  String get noArtist => 'Geen artiest';

  @override
  String get unknownArtist => 'Onbekende Artiest';

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
  String get instantMix => 'Instantmix';

  @override
  String get goToAlbum => 'Ga naar album';

  @override
  String get goToArtist => 'Ga naar Artiest';

  @override
  String get goToGenre => 'Ga naar Genre';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

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
  String get bufferDurationSubtitle =>
      'De maximale duur van de buffer, in seconden. Dit vereist een herstart.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Beperk bufferlimiet niet';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Schakelt buffergrootte beperking uit (\'Buffergrootte\'). De buffer zal altijd ingeladen worden zoals geconfigureerd volgens de bufferlengte (\'Bufferlengte\'), zelfs voor grotere bestanden. Dit kan een crash veroorzaken. Vereist een herstart.';

  @override
  String get bufferSizeTitle => 'Buffergrootte';

  @override
  String get bufferSizeSubtitle =>
      'De maximale buffergrootte in MB. Vereist een herstart';

  @override
  String get language => 'Taal';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Ga naar begin of naar vorige nummer';

  @override
  String get skipToNextTrackButtonTooltip => 'Ga naar volgende nummer';

  @override
  String get togglePlaybackButtonTooltip => 'Afspeelmodus omschakelen';

  @override
  String get previousTracks => 'Vorige Nummers';

  @override
  String get nextUp => 'Volgende';

  @override
  String get clearNextUp => 'Verwijder Volgende';

  @override
  String get stopAndClearQueue => 'Stop playback and clear queue';

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
        'playlist': 'Afspeellijst',
        'trackMix': 'Nummermix',
        'artistMix': 'Artiestenmix',
        'albumMix': 'Albummix',
        'genreMix': 'Genremix',
        'favorites': 'Favorieten',
        'allTracks': 'Alle nummers',
        'filteredList': 'nummers',
        'genre': 'Genre',
        'artist': 'Artiest',
        'track': 'Nummer',
        'nextUpAlbum': 'Album Hierna',
        'nextUpPlaylist': 'Afspeellijst Hierna',
        'nextUpArtist': 'Artiest Hierna',
        'remoteClient': 'een Ander Apparaat',
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
  String get playbackOrderLinearButtonTooltip =>
      'Afspelen op volgorde. Tik om te shuffelen.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Shuffel nummers';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Shuffel nummers. Tik voor afspelen op volgorde.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Afspelen op x$speed snelheid';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed snelheid';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volume';
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
  String get queuesScreen => 'Herstel Afspeellijst';

  @override
  String get queueRestoreButtonLabel => 'Herstel';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Opgeslagen op $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Aan het spelen: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nummers',
      one: '1 Nummer',
    );
    return '$_temp0, $remaining Nog niet gespeeld';
  }

  @override
  String get queueLoadingMessage => 'Wachtrij herstellen…';

  @override
  String get queueRetryMessage =>
      'Wachtrij herstellen niet gelukt. Opnieuw proberen?';

  @override
  String get autoloadLastQueueOnStartup =>
      'Laatste Wachtrij Automatisch Herstellen';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Bij het opstarten van de app, probeer de laatst gespeelde wachtrij te herstellen.';

  @override
  String get reportQueueToServer => 'Huidige wachtrij naar de server sturen?';

  @override
  String get reportQueueToServerSubtitle =>
      'Als dit geactiveerd is stuurt Finamp de wachtrij naar de server. Dit kan besturing vanaf een ander apparaat verbeteren en zorgt dat de server de wachtrij kan herstellen. Staat altijd aan als \'Afspelen Op\' geactiveerd is.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Updatefrequentie Afspeelsessie';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'Hoe vaak de huidige afspeelstatus naar de server gestuurd word, in seconden. Dit moet minder dan 5 minuten (300 seconden) zijn om een time-out van de sessie te voorkomen.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'Als de Jellyfin server langer dan 5 minuten geen updates ontvangt van een apparaat neemt het aan dat het afspelen is gestopt. Dit betekent dat het rapporteren van afspeeldata incorrect kan zijn voor nummers langer dan 5 minuten.';

  @override
  String get playOnStaleDelay => 'Timeout \'Afspelen Op\'-sessie';

  @override
  String get playOnStaleDelaySubtitle =>
      'Hoe lang een \'Afspelen Op\'-sessie op als actief wordt beschouwd na het ontvangen van een commando. Als een sessie als actief is beschouwd wordt de afspeelstatus vaker doorgestuurd, wat voor meer datagebruik kan zorgen.';

  @override
  String get enablePlayonTitle => 'Activeer ondersteuning voor \'Afspelen Op\'';

  @override
  String get enablePlayonSubtitle =>
      'Activeert Jellyfins \'Afspelen Op\' functie (Finamp op afstand besturen vanaf een ander apparaat). Zet dit uit als je reverse proxy of server geen websockets ondersteunt.';

  @override
  String get playOnReconnectionDelay =>
      '\'Afspelen Op\'-sessie Herverbindingsvertraging';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Stelt de vertraging in tussen pogingen om te verbinden met de \'Afspelen Op\'-websocket als die verbroken is (in seconden). Een lagere vertraging zorgt voor meer datagebruik.';

  @override
  String get topTracks => 'Meest Gespeeld';

  @override
  String get topAlbums => 'Top Albums';

  @override
  String get topArtists => 'Top Artists';

  @override
  String get recentlyAddedTracks => 'Recently Added Tracks';

  @override
  String get recentlyAddedAlbums => 'Recently Added Albums';

  @override
  String get recentlyAddedArtists => 'Recently Added Artists';

  @override
  String get latestTracks => 'Latest Tracks';

  @override
  String get latestAlbums => 'Latest Albums';

  @override
  String get latestArtists => 'Latest Artists';

  @override
  String get recentlyPlayedTracks => 'Recently Played Tracks';

  @override
  String get recentlyPlayedAlbums => 'Recently Played Albums';

  @override
  String get recentlyPlayedArtists => 'Recently Played Artists';

  @override
  String get favoriteTracks => 'Favorite Tracks';

  @override
  String get favoriteAlbums => 'Favorite Albums';

  @override
  String get favoriteArtists => 'Favorite Artists';

  @override
  String get randomTracks => 'Tracks (Random Picks)';

  @override
  String get randomAlbums => 'Albums (Random Picks)';

  @override
  String get randomArtists => 'Artists (Random Picks)';

  @override
  String get mostPlayed => 'Most Played';

  @override
  String get randomFavoritesFirst => 'Random (Favorites First)';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get latestReleases => 'Latest Releases';

  @override
  String get itemSectionsOrder => 'Item Sections Order';

  @override
  String get unknown => 'Unknown';

  @override
  String get itemSectionsOrderSubtitle =>
      'Controls the order of Item Sections.';

  @override
  String get genreItemSectionFilterChipOrderTitle =>
      'Item Sections Filter Order';

  @override
  String get genreItemSectionFilterChipOrderSubtitle =>
      'Controls the order of available filters for item sections.';

  @override
  String get artistItemSectionFilterChipOrderTitle =>
      'Tracks Section Filter Order';

  @override
  String get artistItemSectionFilterChipOrderSubtitle =>
      'Controls the order of available filters for the tracks section.';

  @override
  String get genreFilterArtistScreens => 'Filter Artists';

  @override
  String get genreFilterArtistScreensSubtitle =>
      'When enabled, Artists (accessed through a genre) will only show tracks and albums that match the genre you\'re currently browsing. (It is always possible to manually remove the Genre Filter to reveal all tracks and albums.)';

  @override
  String get genreFilterPlaylistScreens => 'Filter Playlists';

  @override
  String get genreFilterPlaylistScreensSubtitle =>
      'When enabled, Playlists (accessed through a genre) will only show tracks that match the genre you\'re currently browsing. (It is always possible to manually remove the Genre Filter to reveal all tracks.)';

  @override
  String get genreListsInheritSorting => 'Full Lists Sorting Inheritance';

  @override
  String get genreListsInheritSortingSubtitle =>
      'When enabled, the \"See All\" lists will inherit the sorting and filtering from the Genre Screen. If disabled, settings from the corresponding library tab will be used instead. Tapping on the Counts on the top of the Genre Screen or the \"Browse Playlists\" button will always open a full list with the sorting settings from the library tab.';

  @override
  String get curatedItemsMostPlayedOfflineTooltip =>
      'Not available in Offline Mode.';

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
      other: '$count Albums',
      one: '$count Album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Shuffle Albums';

  @override
  String get shuffleAlbumsNext => 'Shuffle Albums Hierna';

  @override
  String get shuffleAlbumsToNextUp => 'Shuffle Albums naar Volgende';

  @override
  String get shuffleAlbumsToQueue => 'Shuffle Albums Naar de Wachtrij';

  @override
  String playCountValue(int playCount) {
    return '$playCount keer gespeeld';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'afspeellijst',
        'trackMix': 'nummermix',
        'artistMix': 'artiestenmix',
        'albumMix': 'albummix',
        'genreMix': 'genremix',
        'favorites': 'favorieten',
        'allTracks': 'alle nummers',
        'filteredList': 'nummers',
        'genre': 'genre',
        'artist': 'artiest',
        'track': 'nummer',
        'nextUpAlbum': 'album in \'\'Hierna\'\'',
        'nextUpPlaylist': 'playlist in \'\'Hierna\'\'',
        'nextUpArtist': 'artiest in \'\'Hierna\'\'',
        'other': '',
      },
    );
    return 'Kon $_temp0 niet laden';
  }

  @override
  String get confirm => 'Bevestigen';

  @override
  String get close => 'Sluiten';

  @override
  String get showUncensoredLogMessage =>
      'Dit logboek bevat uw inloggegevens. Tonen?';

  @override
  String get resetTabs => 'Tabbladen resetten';

  @override
  String get resetToDefaults => 'Terugzetten naar standaardinstellingen';

  @override
  String get noMusicLibrariesTitle => 'Geen Muziekbibliotheken';

  @override
  String get noMusicLibrariesBody =>
      'Finamp kon geen muziekbibliotheken vinden. Zorg ervoor dat je Jellyfin server minstens één bibliotheek heeft met het type \"Muziek\".';

  @override
  String get refresh => 'Ververs';

  @override
  String get moreInfo => 'Meer informatie';

  @override
  String get volumeNormalizationSettingsTitle => 'Volume-normalisatie';

  @override
  String get playbackReportingSettingsTitle =>
      'Afspelen Rapporteren & Afspelen Op';

  @override
  String get volumeNormalizationSwitchTitle => 'Volume-nomalisatie activeren';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Gebruik Gain-informatie om het volume van nummer te normaliseren (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Volume-normalisatiemodus';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'Wanneer en hoe Volume-normalisatie toegepast wordt';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Hybride (Nummer + Album):\nNummer-Gain wordt normaal gebruikt, maar als een album afgespeeld wordt (omdat het oorspronkelijk afgespeeld is, of omdat een album op een gegeven moment in de wachtrij gezet is) wordt de album-Gain gebruikt\n\nPer nummer:\nNummer-Gain wordt altijd gebruikt, ongeacht of er een album gespeeld wordt.\n\nAlleen Album-Gain:\nVolume-normalisatie wordt alleen toegepast bij het spelen van albums (met de album-gain), maar niet voor losse nummers.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybride (Nummer + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Per nummer';

  @override
  String get volumeNormalizationModeAlbumBased => 'Per album';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Alleen Album-Gain';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Basis-Gain';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Op dit moment werkt Volume-normalisatie op iOS door het afspeelvolume te veranderen om veranderingen in Gain te emuleren. Omdat we het volume niet boven 100% kunnen zetten moeten we het standaardvolume lager instellen om het volume van stillere nummers hoger te krijgen. De waarde is in decibel (dB). -10dB is ~30% volume, -4.5 dB is ~60% volume en -2 dB is ~80% volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Speel Geswipete Nummer Hierna';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Zet dit aan om een nummer als volgende in de wachtrij te zetten wanneer het gesleept wordt in een lijst van nummers in plaats van het aan het einde van de wachtrij toevoegen.';

  @override
  String get swipeLeftToRightAction => 'Swipe naar Rechts Actie';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Actie die uitgevoerd wordt wanneer een nummer in een lijst van links naar rechts wordt gesleept.';

  @override
  String get swipeRightToLeftAction => 'Swipe naar Links Actie';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Actie die uitgevoerd wordt wanneer een nummer in een lijst van rechts naar links wordt gesleept.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Begin Instantmixes voor Losse Nummers';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'When enabled, tapping a track on the tracks tab will start an instant mix of that track instead of just playing a single track.';

  @override
  String get downloadItem => 'Download';

  @override
  String get repairComplete => 'Downloads Repair complete.';

  @override
  String get syncComplete => 'All downloads re-synced.';

  @override
  String get syncDownloads => 'Sync and download missing items.';

  @override
  String get repairDownloads =>
      'Repair issues with downloaded files or metadata.';

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
  String get onlyShowFullyDownloaded =>
      'Laat alleen volledig gedownloade albums zien';

  @override
  String get filesystemFull =>
      'Overgebleven downloads kunnen niet worden afgewerkt. Het bestandssysteem zit vol.';

  @override
  String get connectionInterrupted =>
      'Connectie is onderbroken, pauzeren van downloads.';

  @override
  String get connectionInterruptedBackground =>
      'Connectie werd onderbroken terwijl downloads bezig waren. Dit kan veroorzaakt zijn door instellingen in het OS.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'Connectie werd onderbroken terwijl downloads bezig waren. Dit kan veroorzaakt zijn door aanzetten \'Ga naar Lage-Prioriteit Staat tijdens Pauzeren\' of OS instellingen.';

  @override
  String get activeDownloadSize => 'Downloaden...';

  @override
  String get missingDownloadSize => 'Verwijderen...';

  @override
  String get syncingDownloadSize => 'Synchroniseren...';

  @override
  String get runRepairWarning =>
      'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Show Media with Unknown Library.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => 'Max Gelijktijdige Downloads';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'Increasing concurrent downloads may allow increased downloading in the background but may cause some downloads to fail if very large, or cause excessive lag in some cases.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Concurrent Downloads';
  }

  @override
  String get downloadsWorkersSetting => 'Download Worker count';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Amount of workers for syncing metadata and deleting downloads. Increasing download workers may speed up download syncing and deleting, especially when server latency is high, but can introduce lag.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Download Workers';
  }

  @override
  String get syncOnStartupSwitch => 'Automatically Sync Downloads at Startup';

  @override
  String get preferQuickSyncSwitch => 'Prefer Quick Syncs';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'When performing syncs, some typically static items (like tracks and albums) will not be updated. Download repair will always perform a full sync.';

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
        'collectionWithLibraryFilter': 'Collection with Library Filter',
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
  String get transcodingStreamingFormatTitle => 'Select Transcoding Format';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Select the format to use when streaming transcoded audio. Already queued tracks will not be affected.';

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
  String get downloadBitrateSubtitle =>
      'A higher bitrate gives higher quality audio at the cost of larger storage requirements.';

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
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transcoded',
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
    return 'Download original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Transcode Redownload queued.';

  @override
  String get redownloadTitle => 'Automatically Redownload Transcodes';

  @override
  String get redownloadSubtitle =>
      'Automatically redownload tracks which are expected to be at a different quality due to parent collection changes.';

  @override
  String get defaultDownloadLocationButton =>
      'Set as default download location.  Disable to select per download.';

  @override
  String get fixedGridSizeSwitchTitle => 'Use fixed size grid tiles';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Grid tile sizes will not respond to window/screen size.';

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
  String get allowSplitScreenSubtitle =>
      'The player will be displayed alongside other views on wider displays.';

  @override
  String get enableVibration => 'Enable vibration';

  @override
  String get enableVibrationSubtitle => 'Whether to enable vibration.';

  @override
  String get hideQueueButton => 'Hide queue button';

  @override
  String get hideQueueButtonSubtitle =>
      'Hide the queue button on the player screen. Swipe up to access the queue.';

  @override
  String get oneLineMarqueeTextButton => 'Auto-scroll Long Titles';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Automatically scroll track titles that are too long to display in two lines';

  @override
  String get marqueeOrTruncateButton => 'Use ellipsis for long titles';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Show … at the end of long titles instead of scrolling text';

  @override
  String get hidePlayerBottomActions => 'Hide bottom actions';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Hide the queue and lyrics buttons on the player screen. Swipe up to access the queue, swipe left (below the album cover) to view lyrics if available.';

  @override
  String get prioritizePlayerCover => 'Prioritize album cover';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Prioritize showing a larger album cover on player screen. Non-critical controls will be hidden more aggressively at small screen sizes.';

  @override
  String get suppressPlayerPadding => 'Suppress player controls padding';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Fully minimizes padding between player screen controls when album cover is not at full size.';

  @override
  String get lockDownload => 'Always Keep on Device';

  @override
  String get showArtistChipImage => 'Toon foto naast artiestennaam';

  @override
  String get showArtistChipImageSubtitle =>
      'Dit beïnvloedt kleine weergaven van artiestenfoto\'s, zoals op het afspeelscherm.';

  @override
  String get scrollToCurrentTrack => 'Scroll naar huidige nummer';

  @override
  String get enableAutoScroll => 'Zet automatisch scrollen aan';

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
    return '$duration over';
  }

  @override
  String get removeFromPlaylistConfirm => 'Verwijderen';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Verwijder \'$itemName\' van de playlist \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Nummer-menu';

  @override
  String get quickActions => 'Snelle Acties';

  @override
  String get addRemoveFromPlaylist => 'Voeg toe/Verwijder van Playlist';

  @override
  String get addPlaylistSubheader => 'Voeg nummer to aan een playlist';

  @override
  String get trackOfflineFavorites => 'Synchroniseer status favorieten';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Hierdoor blijven favorieten up-to-date in Offline Modus. Downloadt geen extra bestanden.';

  @override
  String get allPlaylistsInfoSetting => 'Download Metadata van Playlists';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Synchroniseer metadata van alle playlists om je playlist-ervaring te verbeteren';

  @override
  String get downloadFavoritesSetting => 'Download alle favorieten';

  @override
  String get downloadAllPlaylistsSetting => 'Download alle playlists';

  @override
  String get fiveLatestAlbumsSetting => 'Download de 5 nieuwste albums';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Downloads worden verwijderd als ze te out zijn. Zet de download op slot om te voorkomen dat een album verwijderd wordt.';

  @override
  String get cacheLibraryImagesSettings =>
      'Houd covers van huidige bibliotheek in de cache';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Alle album-, artiesten-, genre- en playlistcovers in de actieve bibliotheek zal gedownload worden.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Toon nummer-voortgang in miniplayer';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Stelt in of de miniplayer/afspeelbalk onderaan het scherm ook als voortgangsbalk dient.';

  @override
  String get lyricsScreenButtonTitle => 'Songtekst';

  @override
  String get lyricsScreen => 'Songtekst-scherm';

  @override
  String get showLyricsTimestampsTitle =>
      'Toon tijden voor gesynchroniseerde songteksten';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Stelt in of de tijd van elke regel songtekst wordt laten zien op het songtekst-scherm (als het beschikbaar is).';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Toon stopknop in mediamelding';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Stelt in of de mediamelding een stopknop heeft naast een pauzeknop. Dit zorgt ervoor dat je een nummer kan stoppen zonder de app te openen.';

  @override
  String get showShuffleButtonOnMediaNotificationTitle =>
      'Show Shuffle Button on Media Notification';

  @override
  String get showShuffleButtonOnMediaNotificationSubtitle =>
      'Controls if the media notification has a shuffle button. This lets you shuffle/unshuffle playback without opening the app.';

  @override
  String get showFavoriteButtonOnMediaNotificationTitle =>
      'Show Favorite Button on Media Notification';

  @override
  String get showFavoriteButtonOnMediaNotificationSubtitle =>
      'Controls if the media notification has a favorite button. This lets you favorite/unfavorite the current track without opening the app.';

  @override
  String get showSeekControlsOnMediaNotificationTitle =>
      'Toon instelbare voortgangsbalk in mediamelding';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Stelt in of de mediamelding een instelbare voortgangsbalk heeft. Dit zorgt ervoor dat je de afspeelplek in het nummer kan veranderen zonder de app te openen.';

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
  String get lyricsAlignmentTitle => 'Uitlijning songtekst';

  @override
  String get lyricsAlignmentSubtitle =>
      'Stelt de uitlijning van de songtekst in op het songtekst-scherm.';

  @override
  String get lyricsFontSizeTitle => 'Songtekst lettergrootte';

  @override
  String get lyricsFontSizeSubtitle =>
      'Stelt de lettergrootte in van de songtekst op het songtekst-scherm.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Toon albumhoes voor de songtekst';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Stelt in of de albumhoes boven de songtekst laten zien wordt op het songtekst-scherm.';

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
  String get keepScreenOnWhileLyrics => 'Terwijl Songtekst Laten Zien Wordt';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Houd Scherm Aan alleen tijdens opladen';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Negeer de Houd Scherm Aan instelling als apparaat niet oplaad';

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
    return 'Albumhoes voor $title. Tik om afspelen te starten/stoppen. Swipe naar links of rechts om nummers te wisselen.';
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
  String get showFeatureChipsToggleTitle =>
      'Zichtbaarheid Geavanceerde Nummer Informatie';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Toon geavanceerde nummer informatie (codec, bitrate, etc.) op het Spelerscherm.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Albumscherm';

  @override
  String get showCoversOnAlbumScreenTitle =>
      'Laat Album Hoezen Zien Voor Nummers';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Laat voor ieder nummer de bijbehorende album hoes zien, waar nummers geselecteerd kunnen worden.';

  @override
  String get artistScreen => 'Artist Screen';

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
  String get genreScreen => 'Genre Screen';

  @override
  String get emptyTopTracksList =>
      'Je hebt nog niet naar muziek geluisterd van deze artiest.';

  @override
  String get emptyFilteredListTitle => 'Niets gevonden';

  @override
  String get emptyFilteredListSubtitle =>
      'Niets komt overeen met deze filter. Zet het filter uit, of probeer een andere zoekterm.';

  @override
  String get resetFiltersButton => 'Verwijder filters';

  @override
  String get resetSettingsPromptGlobal =>
      'Weet je zeker dat je ALLE instellingen wilt terugzetten naar de standaard waarden?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Reset ALLE instellingen';

  @override
  String get resetSettingsPromptLocal =>
      'Wil je deze instellingen terugzetten naar de standaard waarden?';

  @override
  String get genericCancel => 'Stoppen';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Artiest',
        'genre': 'Genre',
        'track': 'Nummer',
        'library': 'Bibliotheek',
        'other': 'Element',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'dit Apparaat',
        'server': 'de Server',
        'other': 'onbekend',
      },
    );
    return '$_temp0 verwijderd van $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Verwijderen van de server toestaan';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Zet deze optie aan of uit om permanent een nummer uit de bestanden van de server te verwijderen wanneer mogelijk.';

  @override
  String deleteFromTargetDialogText(
      String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'dit album',
        'playlist': 'deze playlist',
        'artist': 'deze artiest',
        'genre': 'deze genre',
        'track': 'dit nummer',
        'library': 'deze bibliotheek',
        'other': 'dit element',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Het zal ook van dit apparaat verwijderd worden.',
        'cantDelete':
            ' Het zal op dit apparaat blijven tot de volgende synchronisatie.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'van dit apparaat te verwijderen',
        'server':
            'uit de bestanden en van de bibliotheek op de server te verwijderen.$_temp1\nDit kan niet ongedaan worden',
        'other': '',
      },
    );
    return 'Je staat op het punt om $_temp0 $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' van Apparaat',
        'server': ' van de Server',
        'other': '',
      },
    );
    return 'Verwijder$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Pas op: je staat op het punt $count nummers te downloaden.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Grens Waarschuwing Downloadgrootte';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'Een waarschuwing wordt laten zien als er meer dan zo veel nummers tegelijk gedownload worden.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'het album',
        'playlist': 'de playlist',
        'artist': 'de artiest',
        'genre': 'de genre',
        'other': 'dit element',
      },
    );
    return 'Weet je zeker dat je alle nummers van $_temp0 \'$itemName\' aan deze playlist wilt toevoegen? Ze kunnen alleen één voor één verwijderd worden.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Openbaar:';

  @override
  String get releaseDateFormatYear => 'Jaar';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Maand & Jaar';

  @override
  String get releaseDateFormatMonthDayYear => 'Maand, Dag & Jaar';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Toon Album Releasedatum op Spelerscherm';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Toon de releasedatum van het album op het Spelerscherm, na de albumnaam.';

  @override
  String get releaseDateFormatTitle => 'Formaat Releasedatum';

  @override
  String get releaseDateFormatSubtitle =>
      'Stelt het formaat van alle releasedatums in in de app.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError =>
      'Error bij het laden van beschikbare bibliotheken voor de gebruiker';

  @override
  String get autoOfflineOptionOff => 'Uit';

  @override
  String get autoOfflineOptionNetwork => 'Netwerk';

  @override
  String get autoOfflineOptionDisconnected => 'Offline';

  @override
  String get autoOfflineSettingDescription =>
      'Automatisch Offline Modus aanzetten\nUit: Zal niet automatisch Offline Modus aanzetten. Kan batterij besparen.\nNetwerk: Zet Offline Modus aan als er geen wifi-verbinding is.\nOffline: Zet Offline Modus aan als er helemaal geen internetverbinding is.\nJe kan altijd handmatig Offline Modus aanzetten. Dit stopt het automatiseren totdat je Offline Modus weer uit zet';

  @override
  String get autoOfflineSettingTitle => 'Automatische Offline Modus';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'aangezet',
        'disabled': 'uitgezet',
        'other': 'in superpositie gezet',
      },
    );
    return 'Automatisch Offline Modus $_temp0';
  }

  @override
  String get audioFadeOutDurationSettingTitle => 'Geluid fade-out lengte';

  @override
  String get audioFadeOutDurationSettingSubtitle =>
      'De lengte van fade-out van geluid in milliseconden. Stel in op 0 om fade-out uit te zetten.';

  @override
  String get audioFadeInDurationSettingTitle => 'Geluid fade-in lengte';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'De lengte van fade-in van geluid in milliseconden. Stel in op 0 om fade-in uit te zetten.';

  @override
  String get outputMenuButtonTitle => 'Output';

  @override
  String get outputMenuTitle => 'Verander Output-apparaat';

  @override
  String get outputMenuVolumeSectionTitle => 'Volume';

  @override
  String get outputMenuDevicesSectionTitle => 'Beschikbare apparaten';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Verbind met een apparaat';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Speaker',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Onbekend',
      },
    );
    return '$_temp0';
  }

  @override
  String get desktopShuffleWarning =>
      'Shuffle is op dit moment niet beschikbaar op desktop.';

  @override
  String get preferHomeNetworkActiveAddressInfoText => 'Active Address';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingTitle =>
      'Home Network Address';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingDescription =>
      'Target address of the Jellyfin server inside your home network';

  @override
  String get preferHomeNetworkEnableSwitchTitle => 'Prefer Home Network';

  @override
  String get preferHomeNetworkEnableSwitchDescription =>
      'Whether or not to use a different address when you are at home';

  @override
  String get preferHomeNetworkPublicAddressSettingTitle => 'Public Address';

  @override
  String get preferHomeNetworkPublicAddressSettingDescription =>
      'The primary address used to connect to your Jellyfin server';

  @override
  String get preferHomeNetworkInfoBox =>
      'This Feature requires Location permissions (and location needs to be enabled) to read the network name.';

  @override
  String get networkSettingsTitle => 'Network';

  @override
  String get downloadPaused =>
      'Downloading paused because device is not connected to WiFi';

  @override
  String get missingSchemaError => 'Url needs to start with http(s)://';

  @override
  String get testConnectionButtonLabel => 'Test both connections';

  @override
  String ping(String status) {
    String _temp0 = intl.Intl.selectLogic(
      status,
      {
        'true_true': 'Both reachable',
        'true_false': 'FAILED to reach local address',
        'false_true': 'FAILED to reach public address',
        'false_false': 'FAILED to reach both',
        'other': 'unknown',
      },
    );
    return '$_temp0';
  }

  @override
  String get autoReloadQueueTitle => 'Automatically Reload Queue';

  @override
  String get autoReloadQueueSubtitle =>
      'Automatically reload the queue when the source changes (i.e. offline mode enabled or server address switch). If disabled, Finamp will prompt you instead.';

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
    return 'Reload queue to apply new $_temp0';
  }

  @override
  String autoReloadPromptMissingTracks(int amountUndownloadedTracks) {
    String _temp0 = intl.Intl.pluralLogic(
      amountUndownloadedTracks,
      locale: localeName,
      other: '$amountUndownloadedTracks tracks',
      one: '1 track',
    );
    return '$_temp0 will be removed from the queue because they aren\'t downloaded.';
  }

  @override
  String get autoReloadPromptReloadButton => 'Reload';
}
