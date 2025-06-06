// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'En Jellyfin-musikspelare med öppen källkod';

  @override
  String get startupErrorTitle =>
      'Någonting gick fel vid appens uppstart!\nBer om ursäkt...';

  @override
  String get startupErrorCallToAction =>
      'Vänligen skapa en issue på github.com/jmshrv/finamp med loggarna (!) (använd knappen nedan) och en skärmdump av den här sidan, så att vi kan fixa det så snabbt som möjligt.';

  @override
  String get startupErrorWorkaround =>
      'Som en tillfällig lösning kan du rensa appdatan för att återställa appen. Tänk på att i detta fall så kommer alla dina inställningar och nedladdningar att raderas.';

  @override
  String get about => 'Om Finamp';

  @override
  String get aboutContributionPrompt =>
      'Skapad av eminenta människor på deras fritid.\nDu kan bli en av dem!';

  @override
  String get aboutContributionLink => 'Bidra till Finamp på GitHub:';

  @override
  String get aboutReleaseNotes => 'Läs den senaste versionsfaktan:';

  @override
  String get aboutTranslations =>
      'Hjälp till att översätta Finamp till ditt språk:';

  @override
  String get aboutThanks => 'Tack för att du använder Finamp!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Välkommen till $styledName';
  }

  @override
  String get loginFlowSlogan => 'Din musik, så som du vill ha den.';

  @override
  String get loginFlowGetStarted => 'Kom igång!';

  @override
  String get viewLogs => 'Visa loggar';

  @override
  String get changeLanguage => 'Ändra språk';

  @override
  String get loginFlowServerSelectionHeading => 'Anslut till Jellyfin';

  @override
  String get back => 'Tillbaka';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get internalExternalIpExplanation =>
      'Om du vill kunna komma åt din Jellyfin-server utanför hemmet så måste du använda din externa IP-adress.\n\nOm din server är på en HTTP-standardport (80 eller 443) eller Jellyfins standardport (8096) så behöver du inte ange porten.\n\nOm webbadressen är korrekt bör du se viss information om din server dyka upp under inmatningsfältet.';

  @override
  String get serverUrlHint => 't.ex. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Hjälp med Server-URL';

  @override
  String get emptyServerUrl => 'Server-URL får inte vara tom';

  @override
  String get connectingToServer => 'Ansluter till server…';

  @override
  String get loginFlowLocalNetworkServers => 'Servrar på ditt lokala nätverk:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Söker efter servrar…';

  @override
  String get loginFlowAccountSelectionHeading => 'Välj ditt konto';

  @override
  String get backToServerSelection => 'Tillbaka till Serverval';

  @override
  String get loginFlowNamelessUser => 'Namnlös användare';

  @override
  String get loginFlowCustomUser => 'Anpassad användare';

  @override
  String get loginFlowAuthenticationHeading => 'Logga in på ditt konto';

  @override
  String get backToAccountSelection => 'Tillbaka till Kontoval';

  @override
  String get loginFlowQuickConnectPrompt => 'Använd Snabbanslutningskod';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Öppna Jellyfin-appen eller webbsidan, klicka på din användarikon, och välj Snabbanslutning.';

  @override
  String get loginFlowQuickConnectDisabled =>
      'Snabbanslutning är avaktiverad på den här servern.';

  @override
  String get orDivider => 'eller';

  @override
  String get loginFlowSelectAUser => 'Välj en användare';

  @override
  String get username => 'Användarnamn';

  @override
  String get usernameHint => 'Skriv in ditt användarnamn';

  @override
  String get usernameValidationMissingUsername =>
      'Vänligen skriv in ett användarnamn';

  @override
  String get password => 'Lösenord';

  @override
  String get passwordHint => 'Skriv in ditt lösenord';

  @override
  String get login => 'Logga in';

  @override
  String get logs => 'Loggar';

  @override
  String get next => 'Nästa';

  @override
  String get selectMusicLibraries => 'Välj musikbibliotek';

  @override
  String get couldNotFindLibraries => 'Kunde inte hitta några bibliotek.';

  @override
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Okänt namn';

  @override
  String get tracks => 'Spår';

  @override
  String get albums => 'Album';

  @override
  String get appearsOnAlbums => 'Medverkar på';

  @override
  String get artists => 'Artister';

  @override
  String get genres => 'Genrer';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Spellistor';

  @override
  String get startMix => 'Starta mix';

  @override
  String get startMixNoTracksArtist =>
      'Tryck länge på en artist för att lägga till eller ta bort den från mix-byggaren innan du startar en mix';

  @override
  String get startMixNoTracksAlbum =>
      'Tryck länge på ett album för att lägga till eller ta bort det från mix-byggaren innan du startar en mix';

  @override
  String get startMixNoTracksGenre =>
      'Tryck länge på en genre för att lägga till eller ta bort den från mix-byggaren innan du startar en mix';

  @override
  String get music => 'Musik';

  @override
  String get clear => 'Rensa';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Shuffla alla';

  @override
  String get downloads => 'Nedladdningar';

  @override
  String get settings => 'Inställningar';

  @override
  String get offlineMode => 'Offlineläge';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get sortOrder => 'Sorteringsordning';

  @override
  String get sortBy => 'Sortera efter';

  @override
  String get title => 'Titel';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Albumartist';

  @override
  String get albumArtists => 'Albumartister';

  @override
  String get performingArtists => 'Medverkande artister';

  @override
  String get artist => 'Artist';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Gemenskapsbetyg';

  @override
  String get criticRating => 'Kritikerbetyg';

  @override
  String get dateAdded => 'Tillagd datum';

  @override
  String get datePlayed => 'Uppspelad datum';

  @override
  String get playCount => 'Antal uppspelningar';

  @override
  String get premiereDate => 'Premiärdatum';

  @override
  String get productionYear => 'Produktionsår';

  @override
  String get name => 'Namn';

  @override
  String get random => 'Slumpmässig';

  @override
  String get revenue => 'Intäkter';

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
  String get syncDownloadedPlaylists => 'Synkronisera nedladdade spellistor';

  @override
  String get downloadMissingImages => 'Ladda ned saknade bilder';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Laddade ned $count saknade bilder',
      one: 'Laddade ned $count saknad bild',
      zero: 'Inga saknade bilder hittades',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Aktiva nedladdningar';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedladdningar',
      one: '$count nedladdning',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount spår',
      one: '$trackCount spår',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount bilder',
      one: '$imageCount bild',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount noder synkroniseras',
      one: '$syncCount nod synkroniseras',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nRepareras för närvarande',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count slutfördes';
  }

  @override
  String dlFailed(int count) {
    return '$count misslyckades';
  }

  @override
  String dlEnqueued(int count) {
    return '$count i kö';
  }

  @override
  String dlRunning(int count) {
    return '$count pågående';
  }

  @override
  String get activeDownloadsTitle => 'Aktiva nedladdningar';

  @override
  String get noActiveDownloads => 'Inga aktiva nedladdningar.';

  @override
  String get errorScreenError =>
      'Ett fel uppstod när listan över fel skulle hämtas! Vid det här laget bör du förmodligen bara skapa ett problem på GitHub och radera appdata';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Kunde inte hämta spåret utifrån nedladdnings-ID';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'albumet',
        'playlist': 'spellistan',
        'artist': 'artisten',
        'genre': 'genren',
        'track': 'spåret',
        'library': 'biblioteket',
        'other': 'artikeln',
      },
    );
    return 'Är du säker på att du vill radera $_temp0 \'$itemName\' från denna enhet?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Radera';

  @override
  String get specialDownloads => 'Särskilda nedladdningar';

  @override
  String get libraryDownloads => 'Biblioteksnedladdningar';

  @override
  String get noItemsDownloaded => 'Inga artiklar har laddats ned.';

  @override
  String get error => 'Fel';

  @override
  String discNumber(int number) {
    return 'Skiva $number';
  }

  @override
  String get playButtonLabel => 'Spela upp';

  @override
  String get shuffleButtonLabel => 'Shuffla';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spår',
      one: '$count spår',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spår',
      one: '$count spår',
    );
    return '$_temp0, $downloads nedladdade';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spår',
      one: '$count spår',
    );
    return '$_temp0 nedladdade';
  }

  @override
  String get editPlaylistNameTooltip => 'Ändra namn på spellista';

  @override
  String get editPlaylistNameTitle => 'Ändra namn på Spellista';

  @override
  String get required => 'Obligatoriskt';

  @override
  String get updateButtonLabel => 'Uppdatera';

  @override
  String get playlistUpdated => 'Spellistans namn uppdaterades.';

  @override
  String get downloadsDeleted => 'Nedladdningar raderades.';

  @override
  String get addDownloads => 'Lägg till nedladdningar';

  @override
  String get location => 'Plats';

  @override
  String get confirmDownloadStarted => 'Nedladdning startad';

  @override
  String get downloadsQueued => 'Nedladdning förberedd, laddar ned filer';

  @override
  String get addButtonLabel => 'Lägg till';

  @override
  String get shareLogs => 'Dela loggar';

  @override
  String get exportLogs => 'Spara loggar';

  @override
  String get logsCopied => 'Loggar kopierade.';

  @override
  String get message => 'Meddelande';

  @override
  String get stackTrace => 'Stack-trace';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Licensierad med Mozilla Public License 2.0.\nKällkoden finns tillgänglig på $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transkodning';

  @override
  String get downloadLocations => 'Nedladdningsplatser';

  @override
  String get audioService => 'Ljudtjänst';

  @override
  String get playbackReporting => 'Uppspelningsrapportering';

  @override
  String get interactions => 'Interaktioner';

  @override
  String get layoutAndTheme => 'Layout & Tema';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Inte tillgänglig i offlineläge';

  @override
  String get logOut => 'Logga Ut';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Nedladdade spår kommer inte att raderas';

  @override
  String get areYouSure => 'Är du säker?';

  @override
  String get enableTranscoding => 'Aktivera Transkodning';

  @override
  String get enableTranscodingSubtitle =>
      'Transkodar musikströmmar på serversidan.';

  @override
  String get bitrate => 'Bithastighet';

  @override
  String get bitrateSubtitle =>
      'En högre bithastighet ger bättre ljudkvalitet, men förbrukar också mer data. Gäller ej förlustfria codecs, t.ex. FLAC';

  @override
  String get customLocation => 'Anpassad plats';

  @override
  String get appDirectory => 'Filmapp för App';

  @override
  String get addDownloadLocation => 'Lägg till nedladdningsplats';

  @override
  String get selectDirectory => 'Välj filmapp';

  @override
  String get unknownError => 'Okänt fel';

  @override
  String get pathReturnSlashErrorMessage =>
      'Sökvägar som returnerar ett \"/\" kan inte användas';

  @override
  String get directoryMustBeEmpty => 'Filmappen måste vara tom';

  @override
  String get customLocationsBuggy =>
      'Anpassade platser kan vara extremt buggade och rekommenderas inte i de flesta fall. Platser under systemets \'Musik\'-mapp förhindrar sparandet av albumomslag på grund av begränsningar i operativsystemet.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Gå in i lågprioritetstillstånd vid paus';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Tillåter att aviseringen sveps bort vid paus. Tillåter även Android att döda tjänsten vid paus.';

  @override
  String get shuffleAllTrackCount => 'Antal spår i Shufflingen';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Antal ljudspår att ladda vid användning av Shuffle-knappen.';

  @override
  String get viewType => 'Visningstyp';

  @override
  String get viewTypeSubtitle => 'Visningstyp för musikskärmen';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Rutnät';

  @override
  String get customizationSettingsTitle => 'Anpassning';

  @override
  String get playbackSpeedControlSetting => 'Visa uppspelningshastighet';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Huruvida reglage för uppspelningshastighet visas på uppspelningsskärmen';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Automatisk:\nFinamp försöker att avgöra huruvida spåret du spelar är en podcast eller (del av) en ljudbok. Detta anses vara fallet ifall spåret är längre än $trackDuration minuter, ifall spårets album är längre än $albumDuration timmar, eller ifall spåret har tilldelats minst en av dessa genrer: $genreList\nReglage för uppspelningshastighet visas i så fall på uppspelningsskärmen.\n\nSynlig:\nReglage för uppspelningshastighet visas alltid på uppspelningsskärmen.\n\nDold:\nReglage för uppspelningshastighet är alltid dolt på uppspelningsskärmen.';
  }

  @override
  String get automatic => 'Automatisk';

  @override
  String get shown => 'Visas';

  @override
  String get hidden => 'Dold';

  @override
  String get speed => 'Hastighet';

  @override
  String get reset => 'Återställ';

  @override
  String get apply => 'Verkställ';

  @override
  String get portrait => 'Porträttläge';

  @override
  String get landscape => 'Liggande läge';

  @override
  String gridCrossAxisCount(String value) {
    return 'Rutor per rad i $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Antal rutor som visas per rad i $value.';
  }

  @override
  String get showTextOnGridView => 'Visa text i rutnätsvy';

  @override
  String get showTextOnGridViewSubtitle =>
      'Huruvida text (titel, artist etc.) ska visas på rutnäts-musikskärmen.';

  @override
  String get useCoverAsBackground => 'Visa suddigt omslag som spelarbakgrund';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Huruvida du vill använda en suddig omslagsbild som bakgrund i vissa delar av appen eller inte.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Minsta vaddering av albumomslag';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Minsta vaddering runt albumomslaget på spelarskärmen, i % av skärmbredden.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Dölj spårets artister ifall samma som albumartister';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Huruvida spårets artister ska visas på albumskärmen om de inte skiljer sig från albumartister.';

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
  String get disableGesture => 'Inaktivera gester';

  @override
  String get disableGestureSubtitle => 'Huruvida gester ska inaktiveras.';

  @override
  String get showFastScroller => 'Visa snabb scroller';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'System';

  @override
  String get light => 'Ljust';

  @override
  String get dark => 'Mörkt';

  @override
  String get tabs => 'Flikar';

  @override
  String get playerScreen => 'Spelarskärm';

  @override
  String get cancelSleepTimer => 'Avbryt Sovtimer?';

  @override
  String get yesButtonLabel => 'Ja';

  @override
  String get noButtonLabel => 'Nej';

  @override
  String get setSleepTimer => 'Ställ In Sovtimer';

  @override
  String get hours => 'Timmar';

  @override
  String get seconds => 'Sekunder';

  @override
  String get minutes => 'Minuter';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime av $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Spår $currentTrackIndex av $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Ogiltigt Nummer';

  @override
  String get sleepTimerTooltip => 'Sovtimer';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Sover om $time minuter';
  }

  @override
  String get addToPlaylistTooltip => 'Lägg till i spellista';

  @override
  String get addToPlaylistTitle => 'Lägg till i Spellista';

  @override
  String get addToMorePlaylistsTooltip => 'Lägg till i flera spellistor';

  @override
  String get addToMorePlaylistsTitle => 'Lägg till i flera spellistor';

  @override
  String get removeFromPlaylistTooltip => 'Ta bort från den här spellistan';

  @override
  String get removeFromPlaylistTitle => 'Ta bort från den här spellistan';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Ta bort från spellista \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Ta bort från Spellista \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Ny Spellista';

  @override
  String get createButtonLabel => 'Skapa';

  @override
  String get playlistCreated => 'Spellista skapad.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Tryck lätt för att lägga till i spellista. Tryck länge för att aktivera/avaktivera favorit.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Inget Album';

  @override
  String get noItem => 'Ingen artikel';

  @override
  String get noArtist => 'Ingen Artist';

  @override
  String get unknownArtist => 'Okänd Artist';

  @override
  String get unknownAlbum => 'Okänt Album';

  @override
  String get playbackModeDirectPlaying => 'Direkt Uppspelning';

  @override
  String get playbackModeTranscoding => 'Transkodar';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Spelas Lokalt';

  @override
  String get queue => 'Spelkö';

  @override
  String get addToQueue => 'Lägg till i spelkö';

  @override
  String get replaceQueue => 'Ersätt spelkö';

  @override
  String get instantMix => 'Snabbmix';

  @override
  String get goToAlbum => 'Gå till Album';

  @override
  String get goToArtist => 'Gå till Artist';

  @override
  String get goToGenre => 'Gå till Genre';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Lade till Favorit';

  @override
  String get confirmFavoriteRemoved => 'Tog bort Favorit';

  @override
  String get addedToQueue => 'Tillagd i spelkön.';

  @override
  String get insertedIntoQueue => 'Tillagd i kön.';

  @override
  String get queueReplaced => 'Spelkön ersattes.';

  @override
  String get confirmAddedToPlaylist => 'Tillagd i spellista.';

  @override
  String get removedFromPlaylist => 'Borttagen från spellista.';

  @override
  String get startingInstantMix => 'Startar snabbmix.';

  @override
  String get anErrorHasOccured => 'Ett fel har inträffat.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Statuskod $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Statuskod $statusCode. Detta betyder troligtvis att du använt fel användarnamn/lösenord, eller att din klientapp inte längre är inloggad.';
  }

  @override
  String get removeFromMix => 'Ta bort från Mix';

  @override
  String get addToMix => 'Lägg till i Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artiklar laddades ned igen',
      one: 'En artikel laddades ned igen',
      zero: 'Inga omnedladdningar behövs.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Buffertlängd';

  @override
  String get bufferDurationSubtitle =>
      'Den maximala tiden som ska buffras, i sekunder. Kräver omstart.';

  @override
  String get bufferDisableSizeConstraintsTitle =>
      'Begränsa inte buffertstorlek';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Avlägsnar buffertstorlekens begränsningar (\'Buffertstorlek\'). Bufferten laddas alltid till den angivna längden (\'Buffertlängd\'), även för väldigt stora filer. Kan orsaka krascher. Kräver en omstart.';

  @override
  String get bufferSizeTitle => 'Buffertstorlek';

  @override
  String get bufferSizeSubtitle =>
      'Maximal storlek på bufferten i MB. Kräver en omstart';

  @override
  String get language => 'Språk';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Hoppa till början eller till föregående spår';

  @override
  String get skipToNextTrackButtonTooltip => 'Hoppa till nästa spår';

  @override
  String get togglePlaybackButtonTooltip => 'Starta/pausa uppspelning';

  @override
  String get previousTracks => 'Föregående spår';

  @override
  String get nextUp => 'Nästa';

  @override
  String get clearNextUp => 'Rensa Nästa';

  @override
  String get stopAndClearQueue => 'Stoppa uppspelning och rensa spelkön';

  @override
  String get playingFrom => 'Spelas upp från';

  @override
  String get playNext => 'Spela nästa';

  @override
  String get addToNextUp => 'Lägg till i Nästa';

  @override
  String get shuffleNext => 'Shuffla innan Nästa';

  @override
  String get shuffleToNextUp => 'Shuffla efter Nästa';

  @override
  String get shuffleToQueue => 'Shuffla efter spelkö';

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
    return '$_temp0 spelas härnäst';
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
    return 'Lade till $_temp0 i Nästa';
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
    return 'Lade till $_temp0 i spelkön';
  }

  @override
  String get confirmShuffleNext => 'Shufflade innan Nästa';

  @override
  String get confirmShuffleToNextUp => 'Shufflade efter Nästa';

  @override
  String get confirmShuffleToQueue => 'Shufflade efter spelkön';

  @override
  String get placeholderSource => 'Någonstans';

  @override
  String get playbackHistory => 'Uppspelningshistorik';

  @override
  String get shareOfflineListens => 'Dela offline-lyssningar';

  @override
  String get yourLikes => 'Dina Favoriter';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Spår tillagda via Nästa';

  @override
  String get savedQueue => 'Sparad spelkö';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'spellista',
        'trackMix': 'spårmix',
        'artistMix': 'artistmix',
        'albumMix': 'albummix',
        'genreMix': 'genremix',
        'favorites': 'favoriter',
        'allTracks': 'alla spår',
        'filteredList': 'spår',
        'genre': 'genre',
        'artist': 'artist',
        'track': 'spår',
        'nextUpAlbum': 'album i Nästa',
        'nextUpPlaylist': 'spellista i Nästa',
        'nextUpArtist': 'artist i Nästa',
        'remoteClient': 'en fjärrenhet',
        'other': '',
      },
    );
    return 'Spelar ifrån $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Shuffla alla';

  @override
  String get playbackOrderLinearButtonLabel => 'Spelar upp i ordning';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Spelar upp i ordning. Tryck för att shuffla.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Shufflar spår';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Shufflar spår. Tryck för att spela upp i ordning.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Spelar upp i x$speed hastighet';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed hastighet';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volym';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Sänk uppspelningshastighet';

  @override
  String get playbackSpeedIncreaseLabel => 'Höj uppspelningshastighet';

  @override
  String get loopModeNoneButtonLabel => 'Loopar inte';

  @override
  String get loopModeOneButtonLabel => 'Loopar spår';

  @override
  String get loopModeAllButtonLabel => 'Loopar alla';

  @override
  String get queuesScreen => 'Återställ Nu spelas';

  @override
  String get queueRestoreButtonLabel => 'Återställ';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sparad $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Spelar upp: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spår',
      one: 'Ett spår',
    );
    return '$_temp0, $remaining ej uppspelade';
  }

  @override
  String get queueLoadingMessage => 'Återställer spelkö…';

  @override
  String get queueRetryMessage =>
      'Misslyckades med att återställa spelkön. Försök igen?';

  @override
  String get autoloadLastQueueOnStartup =>
      'Återställ automatiskt senaste spelkö';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Försök att återställa den senast spelade spelkön när appen startas.';

  @override
  String get reportQueueToServer => 'Rapportera nuvarande spelkö till servern?';

  @override
  String get reportQueueToServerSubtitle =>
      'När funktionen är aktiverad skickar Finamp den aktuella spelkön till servern. Det kan förbättra fjärrstyrning och tillåter återställning av spelkö från serversidan. Alltid aktiv ifall \'Spela på\'-funktionen är aktiverad.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Uppdateringsfrekvens på uppspelningssession';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'Hur ofta aktuell uppspelningsstatus ska skickas till servern, i sekunder. Detta borde vara lägre än 5 minuter (300 sekunder), för att motverka att sessionen löper ut.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'Om Jellyfin-servern inte har mottagit några uppdateringar från en klient inom de senaste 5 minuterna, antar den att uppspelningen har avslutats. Det innebär att för spår som är längre än 5 minuter, så kan uppspelningen felaktigt rapporteras att ha avslutats, vilket försämrar kvaliteten på datan i uppspelningsrapporten.';

  @override
  String get playOnStaleDelay => 'Varaktighet \'Spela på\'-session';

  @override
  String get playOnStaleDelaySubtitle =>
      'Hur länge en \'Spela på\'-fjärrsession anses vara aktiv efter att ha mottagit ett kommando. Uppspelning rapporteras mer frekvent i en aktiv session, vilket kan leda till ökad dataanvändning.';

  @override
  String get enablePlayonTitle => 'Aktivera stöd för \'Spela på\'';

  @override
  String get enablePlayonSubtitle =>
      'Aktiverar Jellyfins \'Spela på\'-funktion (fjärrstyrning av Finamp från en annan klient). Stäng av ifall din reverse proxy eller server inte stödjer websockets.';

  @override
  String get playOnReconnectionDelay =>
      'Fördröjning av återanslutning till \'Spela på\'-session';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Styr över fördröjningen mellan försöken att återansluta till SpelaPå-websocketen när anslutningen avbryts (i sekunder). En lägre fördröjning ökar dataanvändningen.';

  @override
  String get topTracks => 'Mest populära';

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
      other: '$count album',
      one: '$count album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Shuffla album';

  @override
  String get shuffleAlbumsNext => 'Shuffla album innan Nästa';

  @override
  String get shuffleAlbumsToNextUp => 'Shuffla album efter Nästa';

  @override
  String get shuffleAlbumsToQueue => 'Shuffla album efter spelkö';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount uppspelningar',
      one: '$playCount uppspelning',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'spellista',
        'trackMix': 'spårmix',
        'artistMix': 'artistmix',
        'albumMix': 'albummix',
        'genreMix': 'genremix',
        'favorites': 'favoriter',
        'allTracks': 'alla spår',
        'filteredList': 'spår',
        'genre': 'genre',
        'artist': 'artist',
        'track': 'spår',
        'nextUpAlbum': 'album i Nästa',
        'nextUpPlaylist': 'spellista i Nästa',
        'nextUpArtist': 'artist i Nästa',
        'other': '',
      },
    );
    return 'Kunde inte läsa in $_temp0';
  }

  @override
  String get confirm => 'Bekräfta';

  @override
  String get close => 'Stäng';

  @override
  String get showUncensoredLogMessage =>
      'Denna logg innehåller din inloggningsinformation. Visa?';

  @override
  String get resetTabs => 'Återställ flikar';

  @override
  String get resetToDefaults => 'Återställ till standard';

  @override
  String get noMusicLibrariesTitle => 'Inga musikbibliotek';

  @override
  String get noMusicLibrariesBody =>
      'Finamp kunde inte hitta några musikbibliotek. Se till att din Jellyfin-server innehåller minst ett bibliotek med innehållstypen inställd på \"Musik\".';

  @override
  String get refresh => 'Uppdatera';

  @override
  String get moreInfo => 'Mer info';

  @override
  String get volumeNormalizationSettingsTitle => 'Volymnormalisering';

  @override
  String get playbackReportingSettingsTitle =>
      'Uppspelningsrapportering & Spela på';

  @override
  String get volumeNormalizationSwitchTitle => 'Aktivera volymnormalisering';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Använd förstärkningsinformation till att normalisera ljudstyrkan på spår (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Volymnormaliseringsläge';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'När och hur volymnormalisering ska tillämpas';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Hybrid (Spår + Album):\nSpårets förstärkning används för vanlig uppspelning, men ifall ett album spelas upp (antingen för att det är källan till den huvudsakliga spelkön, eller för att det lades till i kön vid något tillfälle), så används albumets förstärkning istället.\n\nEnstaka spår:\nSpårets förstärkning används alltid, oavsett ifall ett album spelas eller inte.\n\nEndast album:\nVolymnormalisering tillämpas endast vid uppspelning av album (utifrån albumets förstärkning), men inte för individuella spår.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybrid (Spår + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Enstaka spår';

  @override
  String get volumeNormalizationModeAlbumBased => 'Endast album';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Endast för album';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle =>
      'Grundläggande ljudstyrka';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'För närvarande kräver volymnormalisering på iOS att uppspelningsvolymen ändras för att imitera förändringen i förstärkningen. Eftersom vi inte kan höja volymen över 100% behöver vi som standard sänka volymen, så att vi kan höja volymen på lågmälda spår. Värdet är i decibel (dB), varav -10 dB är ~30% volym, -4.5 dB är ~60% volym och -2 dB är ~80% volym.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Spela svept ljudspår nästa';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Aktivera för att lägga in ett spår som nästa artikel i spelkön när det sveps i spårlistan i stället för att lägga till det på slutet.';

  @override
  String get swipeLeftToRightAction => 'Åtgärd högersvepning';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Åtgärd som utförs när du sveper ett spår i listan från vänster till höger.';

  @override
  String get swipeRightToLeftAction => 'Åtgärd vänstersvepning';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Åtgärd som utförs när du sveper ett spår i listan från höger till vänster.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Starta snabbmixar för enstaka spår';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'Om du trycker på ett spår i spårfliken när funktionen är aktiv, så startas en snabbmix för spåret i stället för att bara spela upp ett enstaka spår.';

  @override
  String get downloadItem => 'Ladda ned';

  @override
  String get repairComplete => 'Reparation av nedladdningar slutförd.';

  @override
  String get syncComplete => 'Alla nedladdningar har synkats om.';

  @override
  String get syncDownloads => 'Synka och ladda ned saknade artiklar.';

  @override
  String get repairDownloads =>
      'Reparera problem med nedladdade filer eller metadata.';

  @override
  String get requireWifiForDownloads => 'Kräv Wi-Fi vid nedladdning.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spår',
      one: '$count spår',
    );
    return 'Varning: $_temp0 kunde inte återställas till spelkön.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'körs',
        'failed': 'misslyckades',
        'syncFailed': 'ständigt avsynkade',
        'enqueued': 'i kö',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Nedladdningar',
      one: 'Nedladdning',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Vill du verkligen ladda ned allt innehåll i biblioteket \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Visa endast helt nedladdade album';

  @override
  String get filesystemFull =>
      'Återstående nedladdningar kan inte slutföras. Filsystemet är fullt.';

  @override
  String get connectionInterrupted =>
      'Anslutningen avbröts, pausar nedladdningar.';

  @override
  String get connectionInterruptedBackground =>
      'Anslutningen avbröts medan nedladdning gjordes i bakgrunden. Detta kan orsakas av inställningar i operativsystemet.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'Anslutningen avbröts medan nedladdning gjordes i bakgrunden. Detta kan orsakas av att aktivera \'Gå in i lågprioritetsläge vid paus\' eller inställningar i operativsystemet.';

  @override
  String get activeDownloadSize => 'Laddar ned…';

  @override
  String get missingDownloadSize => 'Raderar…';

  @override
  String get syncingDownloadSize => 'Synkroniserar…';

  @override
  String get runRepairWarning =>
      'Servern kunde inte kontaktas för att fullborda migrationen av nedladdningar. Vänligen kör \'Reparera nedladdningar\' från nedladdningsskärmen så fort du är uppkopplad igen.';

  @override
  String get downloadSettings => 'Nedladdningar';

  @override
  String get showNullLibraryItemsTitle => 'Visa media med okänt bibliotek.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Vissa media kan laddas ned med ett okänt bibliotek. Stäng av för att dölja dessa utanför deras ursprungliga samling.';

  @override
  String get maxConcurrentDownloads => 'Max antal samtidiga nedladdningar';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'En ökning av antalet samtidiga nedladdningar kan medföra snabbare nedladdning i bakgrunden, men kan orsaka att vissa nedladdningar misslyckas ifall de är väldigt stora, och kan i vissa fall orsaka stora fördröjningar.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count samtidiga nedladdningar';
  }

  @override
  String get downloadsWorkersSetting =>
      'Antal arbetsprocesser för nedladdningar';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Antal arbetsprocesser för att synkronisera metadata och radera nedladdningar. Flera arbetsprocesser kan snabba upp synkronisering samt radering av nedladdningar, särskilt när servern har hög latens, men kan orsaka fördröjningar.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count nedladdningsprocesser';
  }

  @override
  String get syncOnStartupSwitch =>
      'Synkronisera automatiskt nedladdningar vid uppstart';

  @override
  String get preferQuickSyncSwitch => 'Föredra snabb synkronisering';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'Vid synkronisering uppdateras inte vissa vanligen statiska artiklar (såsom spår och album). Nedladdningsreparation genomför alltid en full synkronisering.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Spellista',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Spår',
        'library': 'Bibliotek',
        'unknown': 'Artikel',
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
    return 'Dne här artikeln krävs för att laddas ned av $parentName.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Favoriter',
        'allPlaylists': 'Alla spellistor',
        'fiveLatestAlbums': 'De 5 senaste albumen',
        'allPlaylistsMetadata': 'Metadata för spellista',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Cachade bilder för \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle => 'Välj transkodningsformat';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Välj format som ska användas när du strömmar transkodat ljud. Redan kölagda spår kommer inte att påverkas.';

  @override
  String get downloadTranscodeEnableTitle =>
      'Aktivera transkodade nedladdningar';

  @override
  String get downloadTranscodeCodecTitle => 'Välj nedladdnings-codec';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Alltid',
        'never': 'Aldrig',
        'ask': 'Fråga',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Bithastighet på nedladdning';

  @override
  String get downloadBitrateSubtitle =>
      'En högre bithastighet ger bättre ljudkvalitet på bekostnad av större krav på lagringsutrymme.';

  @override
  String get transcodeHint => 'Transkoda?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Ladda ned som $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate transkodades',
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
        'other': ' som $codec @ $bitrate',
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
    return 'Ladda ned original$_temp0';
  }

  @override
  String get redownloadcomplete =>
      'Ny nedladdning av transkodning har kölagts.';

  @override
  String get redownloadTitle => 'Ladda automatiskt ned transkodningar igen';

  @override
  String get redownloadSubtitle =>
      'Utför automatiskt en ny nedladdning av spår som förväntas vara av en annan kvalitet på grund av förändringar i överordnad samling.';

  @override
  String get defaultDownloadLocationButton =>
      'Välj som standardplats för nedladdning.  Stäng av för att välja per nedladdning.';

  @override
  String get fixedGridSizeSwitchTitle => 'Använd fast storlek på rutnätsblock';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Rutnätsblockens storlek påverkas inte av fönstrets/skärmens storlek.';

  @override
  String get fixedGridSizeTitle => 'Storlek på rutnätsblock';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Liten',
        'medium': 'Medel',
        'large': 'Stor',
        'veryLarge': 'Väldigt stor',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Tillåt delad skärmvy';

  @override
  String get allowSplitScreenSubtitle =>
      'Spelaren visas vid sidan av andra vyer på bredare skärmar.';

  @override
  String get enableVibration => 'Aktivera vibration';

  @override
  String get enableVibrationSubtitle => 'Huruvida vibration ska aktiveras.';

  @override
  String get hideQueueButton => 'Dölj knapp för spelkö';

  @override
  String get hideQueueButtonSubtitle =>
      'Dölj knappen för spelkön på spelarskärmen. Svep upp för att komma åt spelkön.';

  @override
  String get oneLineMarqueeTextButton => 'Rulla automatiskt långa titlar';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Rulla automatiskt titlar som är för långa för att visas på två rader';

  @override
  String get marqueeOrTruncateButton => 'Använd ellips för långa titlar';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Visa … i slutet av långa titlar istället för att rulla texten';

  @override
  String get hidePlayerBottomActions => 'Dölj åtgärder längst ned';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Dölj knapparna för spelkö och sångexter på spelarskärmen. Svep upp för att komma åt spelkön, och svep vänster (under skivomslaget) för att visa sångtexter ifall de finns tillgängliga.';

  @override
  String get prioritizePlayerCover => 'Prioritera albumomslag';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Priorisera visning av ett större albumomslag på spelarskärmen. Mindre viktiga kontroller döljs mer aggressivt vid små skärmstorlekar.';

  @override
  String get suppressPlayerPadding =>
      'Undertryck spelarkontrollernas utfyllnad';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Minimerar fullt utfyllnaden mellan spelarskärmens kontroller när albumets omslag inte är i full storlek.';

  @override
  String get lockDownload => 'Behåll alltid på enhet';

  @override
  String get showArtistChipImage => 'Visa artistbilder med artistnamn';

  @override
  String get showArtistChipImageSubtitle =>
      'Detta påverkar små förhandsvisningar av artistbilder, såsom på spelarskärmen.';

  @override
  String get scrollToCurrentTrack => 'Återgå till nuvarande spår';

  @override
  String get enableAutoScroll => 'Aktivera auto-rullning';

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
    return '$duration återstår';
  }

  @override
  String get removeFromPlaylistConfirm => 'Ta bort';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Ta bort \'$itemName\' från spellistan \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Spårmeny';

  @override
  String get quickActions => 'Snabbåtgärder';

  @override
  String get addRemoveFromPlaylist => 'Lägg till / ta bort från spellistor';

  @override
  String get addPlaylistSubheader => 'Lägg till spår i spellista';

  @override
  String get trackOfflineFavorites => 'Synka alla favoritstatusar';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Detta tillåter visning av mer aktuella favoritstatusar i offlineläge.  Laddar inte ned några ytterligare filer.';

  @override
  String get allPlaylistsInfoSetting => 'Ladda ned metadata för spellista';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Synka metadata för alla spellistor för att förbättra din upplevelse med spellistor';

  @override
  String get downloadFavoritesSetting => 'Ladda ned alla favoriter';

  @override
  String get downloadAllPlaylistsSetting => 'Ladda ned alla spellistor';

  @override
  String get fiveLatestAlbumsSetting => 'Ladda ned de senaste 5 albumen';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Nedladdnigar tas bort när de åldras ut.  Lås nedladdningen för att förhindra att albumet tas bort.';

  @override
  String get cacheLibraryImagesSettings =>
      'Spara nuvarande biblioteksbilder i cachen';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Alla omslag för album, artister, genrer samt spellistor i det aktiva biblioteket kommer att laddas ned.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Visa spårets förlopp i appens minispelare';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Styr ifall appens minispelare / nu spelas-fält längst ned på musikskärmen fungerar som en förloppsindikator.';

  @override
  String get lyricsScreenButtonTitle => 'Sångtexter';

  @override
  String get lyricsScreen => 'Sångtextvy';

  @override
  String get showLyricsTimestampsTitle =>
      'Visa tidsstämplar för synkroniserade sångtexter';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Styr ifall tidsstämplar visas för varje textrad i sångtextvyn, ifall de finns tillgängliga.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Visa stoppknapp på medianotisen';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Styr ifall medianotisen har en stoppknapp. Detta låter dig stoppa uppspelningen utan att öppna appen.';

  @override
  String get showShuffleButtonOnMediaNotificationTitle =>
      'Visa shufflingsknapp på medianotis';

  @override
  String get showShuffleButtonOnMediaNotificationSubtitle =>
      'Styr ifall medianotisen har en shufflingsknapp. Detta låter dig shuffla/avshuffla uppspelningen utan att öppna appen.';

  @override
  String get showFavoriteButtonOnMediaNotificationTitle =>
      'Visa favoritknapp på medianotis';

  @override
  String get showFavoriteButtonOnMediaNotificationSubtitle =>
      'Styr ifall medianotisen har en favoritknapp. Detta låter dig lägga till/ta bort det nuvarande spåret från dina favoriter utan att öppna appen.';

  @override
  String get showSeekControlsOnMediaNotificationTitle =>
      'Tillåt sökning på medianotis';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Styr ifall medianotisen har en sökbar förloppsindikator. Detta låter dig ändra uppspelningspositionen utan att öppna appen.';

  @override
  String get alignmentOptionStart => 'Början';

  @override
  String get alignmentOptionCenter => 'Mitten';

  @override
  String get alignmentOptionEnd => 'Slutet';

  @override
  String get fontSizeOptionSmall => 'Liten';

  @override
  String get fontSizeOptionMedium => 'Mellan';

  @override
  String get fontSizeOptionLarge => 'Stor';

  @override
  String get lyricsAlignmentTitle => 'Justering av sångtexter';

  @override
  String get lyricsAlignmentSubtitle =>
      'Styr justeringen av sångtexter i textvyn.';

  @override
  String get lyricsFontSizeTitle => 'Textstorlek på sångtexter';

  @override
  String get lyricsFontSizeSubtitle =>
      'Styr textstorleken på sångtexter i textvyn.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Visa albumomslag innan sångtexter';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Styr ifall albumets omslag visas ovanför sångtexten innan det rullas bort.';

  @override
  String get keepScreenOn => 'Håll skärmen påslagen';

  @override
  String get keepScreenOnSubtitle => 'När skärmen ska hållas påslagen';

  @override
  String get keepScreenOnDisabled => 'Inaktiverat';

  @override
  String get keepScreenOnAlwaysOn => 'Alltid på';

  @override
  String get keepScreenOnWhilePlaying => 'Medan musik spelas';

  @override
  String get keepScreenOnWhileLyrics => 'Medan sångtexter visas';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Håll endast skärmen påslagen vid laddning';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Ignorera inställningen Håll skärmen påslagen ifall enheten inte laddas';

  @override
  String get genericToggleButtonTooltip => 'Tryck för att växla.';

  @override
  String get artwork => 'Konstverk';

  @override
  String artworkTooltip(String title) {
    return 'Konstverk för $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Konstverk för $title. Tryck för att starta/pausa uppspelning. Svep åt vänster/höger för att byta spår.';
  }

  @override
  String get nowPlayingBarTooltip => 'Öppna spelarskärmen';

  @override
  String get additionalPeople => 'Personer';

  @override
  String get playbackMode => 'Uppspelningsläge';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bithastighet';

  @override
  String get bitDepth => 'Bitdjup';

  @override
  String get size => 'Storlek';

  @override
  String get normalizationGain => 'Förstärkning';

  @override
  String get sampleRate => 'Samplingshastighet';

  @override
  String get showFeatureChipsToggleTitle => 'Visa avancerad info om spåret';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Visa avancerad information om spåret, såsom codec, bithastighet och mer, på spelarskärmen.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Albumskärm';

  @override
  String get showCoversOnAlbumScreenTitle => 'Visa albumomslag för spår';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Visa albumomslag separat för varje spår på albumskärmen.';

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
      'Du har inte lyssnat på några spår från denna artist ännu.';

  @override
  String get emptyFilteredListTitle => 'Inga artiklar hittades';

  @override
  String get emptyFilteredListSubtitle =>
      'Inga artiklar matchade filtret. Försök att stänga av filtret eller ändra sökbeteckningen.';

  @override
  String get resetFiltersButton => 'Återställ filter';

  @override
  String get resetSettingsPromptGlobal =>
      'Vill du verkligen återställa ALLA inställningar till deras ursprungsvärden?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Återställ ALLA inställningar';

  @override
  String get resetSettingsPromptLocal =>
      'Vill du verkligen återställa dessa inställningar till deras ursprungsvärden?';

  @override
  String get genericCancel => 'Avbryt';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Albumet',
        'playlist': 'Spellistan',
        'artist': 'Artisten',
        'genre': 'Genren',
        'track': 'Spåret',
        'library': 'Biblioteket',
        'other': 'Artikeln',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'enheten',
        'server': 'servern',
        'other': 'okänd plats',
      },
    );
    return '$_temp0 raderades från $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Tillåt radering från server';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Aktivera och inaktivera förmågan att permanent radera ett spår från serverns filsystem där radering är möjlig.';

  @override
  String deleteFromTargetDialogText(
      String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'albumet',
        'playlist': 'spellistan',
        'artist': 'artisten',
        'genre': 'genren',
        'track': 'spåret',
        'library': 'biblioteket',
        'other': 'artikeln',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Detta raderar också artikeln från denna enhet.',
        'cantDelete':
            ' Artikeln finns kvar på denna enhet tills nästa synkronisering.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'den här enheten',
        'server':
            'serverns filsystem och bibliotek.$_temp1\nDenna åtgärd kan inte ångras',
        'other': '',
      },
    );
    return 'Du är på väg att radera $_temp0 från $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' från enheten',
        'server': ' från servern',
        'other': '',
      },
    );
    return 'Radera$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Varning: Du är på väg att ladda ned $count spår.';
  }

  @override
  String get downloadSizeWarningCutoff =>
      'Varningsgräns för stora nedladdningar';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'Ett varningsmeddelande visas när fler än detta antal spår laddas ned samtidigt.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'albumet',
        'playlist': 'spellistan',
        'artist': 'artisten',
        'genre': 'genren',
        'other': 'artikeln',
      },
    );
    return 'Vill du verkligen lägga till alla spår från $_temp0 \'$itemName\' till den här spellistan?  De kan endast tas bort individuellt.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Allmänt synlig:';

  @override
  String get releaseDateFormatYear => 'År';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Månad & år';

  @override
  String get releaseDateFormatMonthDayYear => 'Månad, dag & år';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Visa albumets releasedatum på spelarskärmen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Visa albumets releasedatum på spelarskärmen, efter albumets namn.';

  @override
  String get releaseDateFormatTitle => 'Format på releasedatum';

  @override
  String get releaseDateFormatSubtitle =>
      'Styr formatet på alla releasedatum som visas i appen.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError =>
      'Fel vid inläsning av tillgängliga bibliotek för användare';

  @override
  String get autoOfflineOptionOff => 'Inaktiverad';

  @override
  String get autoOfflineOptionNetwork => 'Lokalt nätverk';

  @override
  String get autoOfflineOptionDisconnected => 'Frånkopplad';

  @override
  String get autoOfflineSettingDescription =>
      'Sätt automatiskt igång offline-läge.\nAvstängd: Kommer inte att sätta igång offline-läget. Kan spara på batteriet.\nLokalt nätverk: Sätt igång offline-läget när du inte är uppkopplad mot Wi-Fi eller fast anslutning.\nFrånkopplad: Sätt igång offline-läget när du inte är uppkopplad mot någonting.\nDu kan alltid sätta igång offline-läget manuellt, vilket pausar automatisering tills dess du stänger av offline-läget igen';

  @override
  String get autoOfflineSettingTitle => 'Automatiserat offlineläge';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'aktiverades',
        'disabled': 'avaktiverades',
        'other': 'parallalaxkompensationsmarkeringscentrerades',
      },
    );
    return 'Offlineläget $_temp0 automatiskt';
  }

  @override
  String get audioFadeOutDurationSettingTitle =>
      'Varaktighet på uttoning av ljud';

  @override
  String get audioFadeOutDurationSettingSubtitle =>
      'Varaktigheten på uttoningen av ljudet, i millisekunder.';

  @override
  String get audioFadeInDurationSettingTitle =>
      'Varaktighet på intoning av ljud';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'Varaktigheten på intoningen av ljudet, i millisekunder. Ställ till 0 för att avaktivera intoning.';

  @override
  String get outputMenuButtonTitle => 'Ljudkälla';

  @override
  String get outputMenuTitle => 'Ändra ljudkälla';

  @override
  String get outputMenuVolumeSectionTitle => 'Volym';

  @override
  String get outputMenuDevicesSectionTitle => 'Tillgängliga enheter';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Anslut till en enhet';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Enhetens högtalare',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Okänd',
      },
    );
    return '$_temp0';
  }

  @override
  String get desktopShuffleWarning =>
      'Shuffle är för närvarande inte tillgänglig på PC.';

  @override
  String get preferHomeNetworkActiveAddressInfoText => 'Aktiv adress';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingTitle =>
      'Hemmanätverksadress';

  @override
  String get preferHomeNetworkTargetAddressLocalSettingDescription =>
      'Måladress till Jellyfinservern inom ditt hemmanätverk';

  @override
  String get preferHomeNetworkEnableSwitchTitle => 'Föredra hemmanätverk';

  @override
  String get preferHomeNetworkEnableSwitchDescription =>
      'Huruvida du vill använda en annan adress när du befinner dig hemma';

  @override
  String get preferHomeNetworkPublicAddressSettingTitle => 'Publik adress';

  @override
  String get preferHomeNetworkPublicAddressSettingDescription =>
      'Den huvudsakliga adressen för att koppla upp sig mot din Jellyfin-server';

  @override
  String get preferHomeNetworkInfoBox =>
      'Den här funktionen kräver tillstånd för Plats (och plats måste vara aktiverat) för att läsa namnet på nätverket.';

  @override
  String get networkSettingsTitle => 'Nätverk';

  @override
  String get downloadPaused =>
      'Nedladdning pausades för att enheten inte är uppkopplad mot WiFi';

  @override
  String get missingSchemaError => 'URL måste börja med http(s)://';

  @override
  String get testConnectionButtonLabel => 'Testa båda uppkopplingar';

  @override
  String ping(String status) {
    String _temp0 = intl.Intl.selectLogic(
      status,
      {
        'true_true': 'Båda nåbara',
        'true_false': 'MISSLYCKADES med att nå lokal adress',
        'false_true': 'MISSLYCKADES med att nå publik adress',
        'false_false': 'MISSLYCKADES med att nå båda adresser',
        'other': 'Okänt',
      },
    );
    return '$_temp0';
  }

  @override
  String get autoReloadQueueTitle => 'Hämta om spelkön automatiskt';

  @override
  String get autoReloadQueueSubtitle =>
      'Återställ spelkön automatiskt när källan ändras (t ex när offlineläge aktiveras eller vid byte av serveradress). Om funktionen är avstängd så frågar Finamp dig istället.';

  @override
  String autoReloadPrompt(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'network': 'nätverksinställningar',
        'transcoding': 'transkodningsinställningar',
        'other': 'inställningar',
      },
    );
    return 'Hämta om spelkön för att verkställa nya $_temp0';
  }

  @override
  String autoReloadPromptMissingTracks(int amountUndownloadedTracks) {
    return '$amountUndownloadedTracks komer att avlägsnas från spelkön eftersom de inte har laddats ned.';
  }

  @override
  String get autoReloadPromptReloadButton => 'Hämta om';
}
