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
  String startupError(String error) {
    return 'Någonting gick fel under uppstarten. Felet var: $error\n\nSkapa gärna ett ärende på github.com/UnicornsOnLSD/finamp med en skärmdump av denna sida. Om problemet kvarstår så kan du rensa appdatan för att återställa appen.';
  }

  @override
  String get about => 'Om Finamp';

  @override
  String get aboutContributionPrompt => 'Skapad av eminenta människor på deras fritid.\nDu kan bli en av dem!';

  @override
  String get aboutContributionLink => 'Bidra till Finamp på GitHub:';

  @override
  String get aboutReleaseNotes => 'Läs den senaste versionsfaktan:';

  @override
  String get aboutTranslations => 'Hjälp till att översätta Finamp till ditt språk:';

  @override
  String get aboutThanks => 'Tack för att du använder Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Välkommen till';

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
  String get internalExternalIpExplanation => 'Om du vill kunna komma åt din Jellyfin-server utanför hemmet så måste du använda din externa IP-adress.\n\nOm din server är på en HTTP-standardport (80 eller 443) eller Jellyfins standardport (8096) så behöver du inte ange porten.\n\nOm webbadressen är korrekt bör du se viss information om din server dyka upp under inmatningsfältet.';

  @override
  String get serverUrlHint => 't.ex. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Hjälp med Server-URL';

  @override
  String get emptyServerUrl => 'Serverns URL får inte vara tom';

  @override
  String get connectingToServer => 'Ansluter till server…';

  @override
  String get loginFlowLocalNetworkServers => 'Servrar på ditt lokala nätverk:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Söker efter servrar…';

  @override
  String get loginFlowAccountSelectionHeading => 'Välj ditt konto';

  @override
  String get backToServerSelection => 'Tillbaka till Serverval';

  @override
  String get loginFlowNamelessUser => 'Namnlös Användare';

  @override
  String get loginFlowCustomUser => 'Anpassad Användare';

  @override
  String get loginFlowAuthenticationHeading => 'Logga in på ditt konto';

  @override
  String get backToAccountSelection => 'Tillbaka till Kontoval';

  @override
  String get loginFlowQuickConnectPrompt => 'Använd Snabbanslutningskod';

  @override
  String get loginFlowQuickConnectInstructions => 'Öppna Jellyfin-appen eller webbsidan, klicka på din användarikon, och välj Snabbanslutning.';

  @override
  String get loginFlowQuickConnectDisabled => 'Snabbanslutning är avstängd på den här servern.';

  @override
  String get orDivider => 'eller';

  @override
  String get loginFlowSelectAUser => 'Välj en användare';

  @override
  String get username => 'Användarnamn';

  @override
  String get usernameHint => 'Skriv in ditt användarnamn';

  @override
  String get usernameValidationMissingUsername => 'Vänligen skriv in ett användarnamn';

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
  String get selectMusicLibraries => 'Välj Musikbibliotek';

  @override
  String get couldNotFindLibraries => 'Kunde inte hitta några bibliotek.';

  @override
  String get unknownName => 'Okänt Namn';

  @override
  String get tracks => 'Spår';

  @override
  String get albums => 'Album';

  @override
  String get artists => 'Artister';

  @override
  String get genres => 'Genrer';

  @override
  String get playlists => 'Spellistor';

  @override
  String get startMix => 'Starta Mix';

  @override
  String get startMixNoTracksArtist => 'Tryck länge på en artist för att lägga till eller ta bort den från mix-byggaren innan du startar en mix';

  @override
  String get startMixNoTracksAlbum => 'Tryck länge på ett album för att lägga till eller ta bort det från mix-byggaren innan du startar en mix';

  @override
  String get startMixNoTracksGenre => 'Tryck länge på en genre för att lägga till eller ta bort den från mix-byggaren innan du startar en mix';

  @override
  String get music => 'Musik';

  @override
  String get clear => 'Rensa';

  @override
  String get favourites => 'Favoriter';

  @override
  String get shuffleAll => 'Blanda alla';

  @override
  String get downloads => 'Nedladdningar';

  @override
  String get settings => 'Inställningar';

  @override
  String get offlineMode => 'Offlineläge';

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
  String get artist => 'Artist';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Gemenskapsbetyg';

  @override
  String get criticRating => 'Kritikerbetyg';

  @override
  String get dateAdded => 'Datum Tillagd';

  @override
  String get datePlayed => 'Datum Uppspelad';

  @override
  String get playCount => 'Antal Uppspelningar';

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
  String get runtime => 'Speltid';

  @override
  String get syncDownloadedPlaylists => 'Synkronisera nedladdade spellistor';

  @override
  String get downloadMissingImages => 'Ladda ned saknade bilder';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Laddade ner $count saknade bilder',
      one: 'Laddade ner $count saknad bild',
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
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slutförda',
      one: '$count slutförd',
    );
    return '$_temp0';
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
  String get errorScreenError => 'Ett fel uppstod när listan över fel skulle hämtas! Vid det här laget bör du förmodligen bara skapa ett problem på GitHub och radera appdata';

  @override
  String get failedToGetTrackFromDownloadId => 'Kunde inte hämta spåret utifrån nedladdnings-ID';

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
        'other': 'föremålet',
      },
    );
    return 'Är du säker på att du vill radera $_temp0 \'$itemName\' från denna enhet?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Radera';

  @override
  String get specialDownloads => 'Särskilda nedladdningar';

  @override
  String get noItemsDownloaded => 'Inga föremål har laddats ned.';

  @override
  String get error => 'Fel';

  @override
  String discNumber(int number) {
    return 'Skiva $number';
  }

  @override
  String get playButtonLabel => 'Spela upp';

  @override
  String get shuffleButtonLabel => 'Blanda';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spår',
      one: '$count Spår',
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
  String get editPlaylistNameTitle => 'Ändra Namn På Spellista';

  @override
  String get required => 'Obligatoriskt';

  @override
  String get updateButtonLabel => 'Uppdatera';

  @override
  String get playlistNameUpdated => 'Spellistans namn uppdaterades.';

  @override
  String get favourite => 'Lägg till som favorit';

  @override
  String get downloadsDeleted => 'Nedladdningar raderades.';

  @override
  String get addDownloads => 'Lägg Till Nedladdningar';

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
  String get playbackReporting => 'Playback reporting & Play On';

  @override
  String get interactions => 'Interaktioner';

  @override
  String get layoutAndTheme => 'Layout & Tema';

  @override
  String get notAvailableInOfflineMode => 'Inte tillgänglig i offlineläge';

  @override
  String get logOut => 'Logga Ut';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Nedladdade låtar kommer inte att raderas';

  @override
  String get areYouSure => 'Är du säker?';

  @override
  String get enableTranscoding => 'Aktivera Transkodning';

  @override
  String get enableTranscodingSubtitle => 'Transkodar musikströmmar på serversidan.';

  @override
  String get bitrate => 'Bithastighet';

  @override
  String get bitrateSubtitle => 'Högre bithastighet ger bättre ljudkvalitet, men förbrukar också mer data.';

  @override
  String get customLocation => 'Anpassad Plats';

  @override
  String get appDirectory => 'Filmapp för App';

  @override
  String get addDownloadLocation => 'Lägg Till Nedladdningsplats';

  @override
  String get selectDirectory => 'Välj Filmapp';

  @override
  String get unknownError => 'Okänt Fel';

  @override
  String get pathReturnSlashErrorMessage => 'Sökvägar som returnerar ett \"/\" kan inte användas';

  @override
  String get directoryMustBeEmpty => 'Filmappen måste vara tom';

  @override
  String get customLocationsBuggy => 'Anpassade platser kan vara extremt buggade och rekommenderas inte i de flesta fall. Platser under systemets \'Musik\'-mapp förhindrar sparandet av albumomslag på grund av begränsningar i operativsystemet.';

  @override
  String get enterLowPriorityStateOnPause => 'Gå in i lågprioritetstillstånd vid paus';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Tillåter att aviseringen sveps bort vid paus. Tillåter även Android att döda tjänsten vid paus.';

  @override
  String get shuffleAllTrackCount => 'Antal ljudspår i Blanda Alla';

  @override
  String get shuffleAllTrackCountSubtitle => 'Antal ljudspår att ladda vid användning av blandningsknappen.';

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
  String get playbackSpeedControlSettingSubtitle => 'Huruvida reglage för uppspelningshastighet visas på uppspelningsskärmen';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automatisk:\nFinamp försöker att avgöra huruvida ljudspåret du spelar är en podcast eller (del av) en ljudbok. Detta anses vara fallet ifall ljudspåret är längre än $trackDuration minuter, ifall ljudspårets album är längre än $albumDuration timmar, eller ifal ljudspåret har tilldelats minst en av dessa genrer: $genreList\nReglage för uppspelningshastighet visas i så fall på uppspelningsskärmen.\n\nSynlig:\nReglage för uppspelningshastighet visas alltid på uppspelningsskärmen.\n\nDold:\nReglage för uppspelningshastighet är alltid dold på uppspelningsskärmen.';
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
    return '$value Antal rutnätskorsaxel';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Antal rutor som används per rad i $value.';
  }

  @override
  String get showTextOnGridView => 'Visa text i rutnätsvy';

  @override
  String get showTextOnGridViewSubtitle => 'Huruvida text (titel, artist etc.) ska visas på rutnäts-musikskärmen.';

  @override
  String get useCoverAsBackground => 'Visa suddigt omslag som spelarbakgrund';

  @override
  String get useCoverAsBackgroundSubtitle => 'Om du vill använda en suddig omslagsbild som bakgrund i vissa delar av appen.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minsta vaddering av albumomslag';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minsta vaddering runt albumomslaget på spelarskärmen, i % av skärmbredden.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Dölj ljudspårets artister om samma som albumartister';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Om ljudspårets artister ska visas på albumskärmen om de inte skiljer sig från albumartister.';

  @override
  String get showArtistsTopTracks => 'Visa mest lyssnade ljudspåren i artistvy';

  @override
  String get showArtistsTopTracksSubtitle => 'Huruvida de 5 mest lyssnade ljudspåren av en artist skall visas.';

  @override
  String get disableGesture => 'Inaktivera gester';

  @override
  String get disableGestureSubtitle => 'Huruvida gester skall inaktiveras.';

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
  String get playlistActionsMenuButtonTooltip => 'Tryck lätt för att lägga till i spellista. Tryck länge för att aktivera/avaktivera favorit.';

  @override
  String get noAlbum => 'Inget Album';

  @override
  String get noItem => 'Inget objekt';

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
  String get queue => 'Uppspelningskö';

  @override
  String get addToQueue => 'Lägg till i Uppspelningskö';

  @override
  String get replaceQueue => 'Ersätt Uppspelningskö';

  @override
  String get instantMix => 'Snabbmix';

  @override
  String get goToAlbum => 'Gå till Album';

  @override
  String get goToArtist => 'Gå till Artist';

  @override
  String get goToGenre => 'Gå till Genre';

  @override
  String get removeFavourite => 'Ta Bort Favorit';

  @override
  String get addFavourite => 'Lägg Till Favorit';

  @override
  String get confirmFavoriteAdded => 'Lade till Favorit';

  @override
  String get confirmFavoriteRemoved => 'Tog bort Favorit';

  @override
  String get addedToQueue => 'Tillagd i uppspelningskön.';

  @override
  String get insertedIntoQueue => 'Tillagd i kön.';

  @override
  String get queueReplaced => 'Uppspelningskö ersatt.';

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
      other: '$count föremål laddades ned igen',
      one: '$count föremål laddades ned igen',
      zero: 'Inga omnedladdningar behövs.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Buffertlängd';

  @override
  String get bufferDurationSubtitle => 'Den maximala tiden som ska buffras, i sekunder. Kräver omstart.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Begränsa inte buffertstorlek';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Avlägsnar buffertstorlekens begränsningar (\'Buffertstorlek\'). Bufferten laddas alltid till den angivna längden (\'Buffertlängd\'), även för väldigt stora filer. Kan orsaka krascher. Kräver en omstart.';

  @override
  String get bufferSizeTitle => 'Buffertstorlek';

  @override
  String get bufferSizeSubtitle => 'Maximal storlek på bufferten i MB. Kräver en omstart';

  @override
  String get language => 'Språk';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Hoppa till början eller till föregående ljudspår';

  @override
  String get skipToNextTrackButtonTooltip => 'Hoppa till nästa ljudspår';

  @override
  String get togglePlaybackButtonTooltip => 'Starta/pausa uppspelning';

  @override
  String get previousTracks => 'Föregående Ljudspår';

  @override
  String get nextUp => 'Nästa';

  @override
  String get clearNextUp => 'Rensa Nästa';

  @override
  String get playingFrom => 'Spelas upp från';

  @override
  String get playNext => 'Spela nästa';

  @override
  String get addToNextUp => 'Lägg till i Nästa';

  @override
  String get shuffleNext => 'Blanda följande';

  @override
  String get shuffleToNextUp => 'Blanda efter Nästa';

  @override
  String get shuffleToQueue => 'Blanda efter uppspelningskö';

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
    return 'Lade till $_temp0 i uppspelningskön';
  }

  @override
  String get confirmShuffleNext => 'Blandar nästa';

  @override
  String get confirmShuffleToNextUp => 'Blandade efter Nästa';

  @override
  String get confirmShuffleToQueue => 'Blandade efter uppspelningskön';

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
  String get tracksFormerNextUp => 'Ljudspår tillagda via Nästa';

  @override
  String get savedQueue => 'Sparad uppspelningskö';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'spellista',
        'trackMix': 'låtmix',
        'artistMix': 'artistmix',
        'albumMix': 'albummix',
        'genreMix': 'genremix',
        'favorites': 'favoriter',
        'allTracks': 'alla ljudspår',
        'filteredList': 'ljudspår',
        'genre': 'genre',
        'artist': 'artist',
        'track': 'ljudspår',
        'nextUpAlbum': 'album i Nästa',
        'nextUpPlaylist': 'spellista i Nästa',
        'nextUpArtist': 'artist i Nästa',
        'other': '',
      },
    );
    return 'Spelar ifrån $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Blanda allt';

  @override
  String get playbackOrderLinearButtonLabel => 'Spelar upp i ordning';

  @override
  String get playbackOrderLinearButtonTooltip => 'Spelar upp i ordning. Tryck för att blanda.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Blandar ljudspår';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Blandar ljudspår. Tryck för att spela upp i ordning.';

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
    return '$volume% volume';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Sänk uppspelningshastighet';

  @override
  String get playbackSpeedIncreaseLabel => 'Höj uppspelningshastighet';

  @override
  String get loopModeNoneButtonLabel => 'Loopar inte';

  @override
  String get loopModeOneButtonLabel => 'Loopar ljudspår';

  @override
  String get loopModeAllButtonLabel => 'Loopar alla';

  @override
  String get queuesScreen => 'Återställ Nu spelas';

  @override
  String get queueRestoreButtonLabel => 'Återställ';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
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
      other: '$count ljudspår',
      one: '1 ljudspår',
    );
    return '$_temp0, $remaining ej uppspelade';
  }

  @override
  String get queueLoadingMessage => 'Återställer uppspelningskö…';

  @override
  String get queueRetryMessage => 'Misslyckades med att återställa uppspelningskö. Försök igen?';

  @override
  String get autoloadLastQueueOnStartup => 'Återställ automatiskt senaste uppspelningskö';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Försök att återställa den senast spelade uppspelningskön när appen startas.';

  @override
  String get reportQueueToServer => 'Rapportera nuvarande uppspelningskö till servern?';

  @override
  String get reportQueueToServerSubtitle => 'När funktionen är aktiverad skickar Finamp den aktuella uppspelningskön till servern. Det verkar för närvarande inte finnas mycket nytta för detta, och det ökar nätverkstrafiken.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Uppdateringsfrekvens på uppspelningssession';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Hur ofta aktuell uppspelningsstatus skall skickas till servern, i sekunder. Detta borde vara lägre än 5 minuter (300 sekunder), för att motverka att sessionen löper ut.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Om Jellyfin-servern inte har mottagit några uppdateringar från en klient inom de senaste 5 minuterna, antar den att uppspelningen har avslutats. Det innebär att för ljudspår som är längre än 5 minuter, så kan uppspelningen felaktigt rapporteras att ha avslutats, vilket försämrar kvaliteten på uppspelningsrapport-datan.';

  @override
  String get playOnStaleDelay => 'PlayOn session as active delay';

  @override
  String get playOnStaleDelaySubtitle => 'How long a remote PlayOn session is considered active after receiving a command. When considered active, playback is reported more frequently and can lead to increased bandwidth usage.';

  @override
  String get disablePlayon => 'Disable PlayOn feature';

  @override
  String get disablePlayonSubtitle => 'Disables PlayOn (controlling your session from a remote client). This avoids unnecessary errors if your reverse proxy or server doesn\'t support websockets.';

  @override
  String get playOnReconnectionDelay => 'PlayOn session reconnection delay';

  @override
  String get playOnReconnectionDelaySubtitle => 'Controls the delay between the attempts to reconnect to the PlayOn websocket when it gets disconnected (in seconds). A lower delay increases bandwidth usage.';

  @override
  String get topTracks => 'Mest populära';

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
  String get shuffleAlbums => 'Blanda album';

  @override
  String get shuffleAlbumsNext => 'Blanda album innan Nästa';

  @override
  String get shuffleAlbumsToNextUp => 'Blanda album till Nästa';

  @override
  String get shuffleAlbumsToQueue => 'Blanda album efter uppspelningskö';

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
        'trackMix': 'låtmix',
        'artistMix': 'artistmix',
        'albumMix': 'albummix',
        'genreMix': 'genremix',
        'favorites': 'favoriter',
        'allTracks': 'alla ljudspår',
        'filteredList': 'ljudspår',
        'genre': 'genre',
        'artist': 'artist',
        'track': 'ljudspår',
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
  String get showUncensoredLogMessage => 'Denna logg innehåller din inloggningsinformation. Visa?';

  @override
  String get resetTabs => 'Återställ flikar';

  @override
  String get resetToDefaults => 'Återställ till standard';

  @override
  String get noMusicLibrariesTitle => 'Inga musikbibliotek';

  @override
  String get noMusicLibrariesBody => 'Finamp kunde inte hitta några musikbibliotek. Se till att din Jellyfin-server innehåller minst ett bibliotek med innehållstypen inställd på \"Musik\".';

  @override
  String get refresh => 'Uppdatera';

  @override
  String get moreInfo => 'Mer info';

  @override
  String get volumeNormalizationSettingsTitle => 'Volymnormalisering';

  @override
  String get playbackReportingSettingsTitle => 'Playback reporting & Play On';

  @override
  String get volumeNormalizationSwitchTitle => 'Aktivera volymnormalisering';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Använd förstärkningsinformation till att normalisera ljudstyrkan på ljudspår (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Volymnormaliseringsläge';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'När och hur volymnormalisering skall tillämpas';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Hybrid (Ljudspår + Album):\nLjudspårets ljudstyrka används för vanlig uppspelning, men ifall ett album spelas upp (antingen för att det är källan till den huvudsakliga uppspelningskön, eller för att det lades till i kön vid något tillfälle), så används albumets ljudstyrka istället.\n\nEnstaka spår:\nLjudspårets ljudstyrka används alltid, oavsett ifall ett album spelas eller inte.\n\nEndast album:\nVolymnormalisering tillämpas endast vid uppspelning av album (utifrån albumets ljudstyrka), men inte för individuella ljudspår.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybrid (Ljudspår + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Enstaka spår';

  @override
  String get volumeNormalizationModeAlbumBased => 'Endast album';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Endast för album';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Grundläggande ljudstyrka';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'För närvarande kräver volymnormalisering på iOS att uppspelningsvolymen ändras för att imitera förändringen i ljudstyrkan. Eftersom vi inte kan höja volymen över 100% behöver vi som standard sänka volymen, så att vi kan höja volymen på lågmälda ljudspår. Värdet är i decibel (dB), varav -10 dB är ~30% volym, -4.5 dB är ~60% volym och -2 dB är ~80% volym.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Spela svept ljudspår härnäst';

  @override
  String get swipeInsertQueueNextSubtitle => 'Aktivera för att lägga in ett ljudspår som nästa objekt i uppspelningskön när det sveps i låtlistan i stället för att lägga till det på slutet.';

  @override
  String get swipeLeftToRightAction => 'Swipe to Right Action';

  @override
  String get swipeLeftToRightActionSubtitle => 'Action triggered when swiping a track in the list from left to right.';

  @override
  String get swipeRightToLeftAction => 'Swipe to Left Action';

  @override
  String get swipeRightToLeftActionSubtitle => 'Action triggered when swiping a track in the list from right to left.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Starta snabbmixar för enstaka ljudspår';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Om du trycker på ett ljudspår i ljudspårsfliken när funktionen är aktiv så startas en snabbmix för ljudspåret i stället för att bara spela upp ett enstaka ljudspår.';

  @override
  String get downloadItem => 'Ladda ned';

  @override
  String get repairComplete => 'Reparation av nedladdningar slutförd.';

  @override
  String get syncComplete => 'Alla nedladdningar har synkats om.';

  @override
  String get syncDownloads => 'Synka och ladda ned saknade föremål.';

  @override
  String get repairDownloads => 'Reparera problem med nedladdade filer eller metadata.';

  @override
  String get requireWifiForDownloads => 'Kräv Wi-Fi vid nedladdning.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ljudspår',
      one: '$count ljudspår',
    );
    return 'Varning: $_temp0 kunde inte återställas till uppspelningskön.';
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
  String get filesystemFull => 'Återstående nedladdningar kan inte slutföras. Filsystemet är fullt.';

  @override
  String get connectionInterrupted => 'Anslutningen avbröts, pausar nedladdningar.';

  @override
  String get connectionInterruptedBackground => 'Anslutningen avbröts medan nedladdning gjordes i bakgrunden. Detta kan orsakas av inställningar i operativsystemet.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Anslutningen avbröts medan nedladdning gjordes i bakgrunden. Detta kan orsakas av att aktivera \'Gå in i lågprioritetsläge vid paus\' eller inställningar i operativsystemet.';

  @override
  String get activeDownloadSize => 'Laddar ned…';

  @override
  String get missingDownloadSize => 'Raderar…';

  @override
  String get syncingDownloadSize => 'Synkroniserar…';

  @override
  String get runRepairWarning => 'Servern kunde inte kontaktas för att fullborda migrationen av nedladdningar. Vänligen kör \'Reparera nedladdningar\' från nedladdningsskärmen så fort du är uppkopplad igen.';

  @override
  String get downloadSettings => 'Nedladdningar';

  @override
  String get showNullLibraryItemsTitle => 'Visa media med okänt bibliotek.';

  @override
  String get showNullLibraryItemsSubtitle => 'Vissa media kan laddas ned med ett okänt bibliotek. Stäng av för att dölja dessa utanför deras ursprungliga samling.';

  @override
  String get maxConcurrentDownloads => 'Max antal samtidiga nedladdningar';

  @override
  String get maxConcurrentDownloadsSubtitle => 'En ökning av antalet samtidiga nedladdningar kan medföra snabbare nedladdning i bakgrunden, men kan orsaka att vissa nedladdningar misslyckas ifall de är väldigt stora, och kan i vissa fall orsaka stora fördröjningar.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count samtidiga nedladdningar';
  }

  @override
  String get downloadsWorkersSetting => 'Antal arbetsprocesser för nedladdningar';

  @override
  String get downloadsWorkersSettingSubtitle => 'Antal arbetsprocesser för att synkronisera metadata och radera nedladdningar. Flera arbetsprocesser kan snabba upp synkronisering samt radering av nedladdningar, särskilt när servern har hög latens, men kan orsaka fördröjningar.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count nedladdningsprocesser';
  }

  @override
  String get syncOnStartupSwitch => 'Synkronisera automatiskt nedladdningar vid uppstart';

  @override
  String get preferQuickSyncSwitch => 'Föredra snabb synkronisering';

  @override
  String get preferQuickSyncSwitchSubtitle => 'När synkronisering uppdateras inte vissa vanligen statiska föremål (såsom ljudspår och album). Nedladdningsreparation genomför alltid en full synkronisering.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Spellista',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Ljudspår',
        'library': 'Bibliotek',
        'unknown': 'Objekt',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
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
  String get transcodingStreamingFormatTitle => 'Select Transcoding Format';

  @override
  String get transcodingStreamingFormatSubtitle => 'Select the format to use when streaming transcoded audio. Already queued tracks will not be affected.';

  @override
  String get downloadTranscodeEnableTitle => 'Aktivera transkodade nedladdningar';

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
  String get downloadBitrateSubtitle => 'En högre bithastighet ger bättre ljudkvalitet på bekostnad av större krav på lagringsutrymme.';

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
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate transkodad',
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
        'other': ' som $codec @ $bitrate',
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
    return 'Ladda ned original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Ny nedladdning av transkodning har kölagts.';

  @override
  String get redownloadTitle => 'Ladda automatiskt ned transkodningar igen';

  @override
  String get redownloadSubtitle => 'Ladda automatiskt ned igen ljudspår som förväntas vara av en annan kvalitet på grund av förändringar i överordnad samling.';

  @override
  String get defaultDownloadLocationButton => 'Välj som standardplats för nedladdning.  Stäng av för att välja per nedladdning.';

  @override
  String get fixedGridSizeSwitchTitle => 'Använd fast storlek på rutnätsblock';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Rutnätsblockens storlek påverkas inte av fönstrets/skärmens storlek.';

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
  String get allowSplitScreenSubtitle => 'Spelaren visas vid sidan av andra vyer på bredare skärmar.';

  @override
  String get enableVibration => 'Aktivera vibration';

  @override
  String get enableVibrationSubtitle => 'Huruvida vibration skall aktiveras.';

  @override
  String get hideQueueButton => 'Dölj knapp för uppspelningskö';

  @override
  String get hideQueueButtonSubtitle => 'Dölj knappen för uppspelningskön på spelarskärmen. Svep upp för att komma åt uppspelningskön.';

  @override
  String get oneLineMarqueeTextButton => 'Rulla automatiskt långa titlar';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Rulla automatiskt titlar som är för långa för att visas på två rader';

  @override
  String get marqueeOrTruncateButton => 'Använd ellips för långa titlar';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Visa … i slutet av långa titlar istället för att rulla texten';

  @override
  String get hidePlayerBottomActions => 'Dölj åtgärder längst ned';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Dölj knapparna för uppspelningskö och låttexter på spelarskärmen. Svep upp för att komma åt uppspelningskön, och svep vänster (under skivomslaget) för att visa låttexter om de finns tillgängliga.';

  @override
  String get prioritizePlayerCover => 'Prioritera skivomslag';

  @override
  String get prioritizePlayerCoverSubtitle => 'Priorisera visning av ett större skivomslag på spelarskärmen. Mindre viktiga kontroller döljs mer aggressivt vid små skärmstorlekar.';

  @override
  String get suppressPlayerPadding => 'Undertryck spelarkontrollernas utfyllnad';

  @override
  String get suppressPlayerPaddingSubtitle => 'Minimerar fullt utfyllnaden mellan spelarskärmens kontroller när skivomslaget inte är i full storlek.';

  @override
  String get lockDownload => 'Behåll alltid på enhet';

  @override
  String get showArtistChipImage => 'Visa artistbilder med artistnamn';

  @override
  String get showArtistChipImageSubtitle => 'Detta påverkar små förhandsvisningar av artistbilder, såsom på spelarskärmen.';

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
  String get trackMenuButtonTooltip => 'Ljudspårsmeny';

  @override
  String get quickActions => 'Snabbåtgärder';

  @override
  String get addRemoveFromPlaylist => 'Lägg till / ta bort från spellistor';

  @override
  String get addPlaylistSubheader => 'Lägg till ljudspår i spellista';

  @override
  String get trackOfflineFavorites => 'Synka alla favoritstatusar';

  @override
  String get trackOfflineFavoritesSubtitle => 'Detta tillåter visning av mer aktuella favoritstatusar i offlineläge.  Laddar inte ned några ytterligare filer.';

  @override
  String get allPlaylistsInfoSetting => 'Ladda ned metadata för spellista';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Synka metadata för alla spellistor för att förbättra din upplevelse med spellistor';

  @override
  String get downloadFavoritesSetting => 'Ladda ned alla favoriter';

  @override
  String get downloadAllPlaylistsSetting => 'Ladda ned alla spellistor';

  @override
  String get fiveLatestAlbumsSetting => 'Ladda ned de senaste 5 albumen';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Nedladdnigar tas bort när de åldras ut.  Lås nedladdningen för att förhindra att albumet tas bort.';

  @override
  String get cacheLibraryImagesSettings => 'Spara nuvarande biblioteksbilder i cachen';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Alla omslag för album, artister, genrer samt spellistor i det aktiva biblioteket kommer att laddas ned.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Visa spårets förlopp i appens minispelare';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Styr ifall appens minispelare / nu spelas-fält längst ned på musikskärmen fungerar som en förloppsindikator.';

  @override
  String get lyricsScreen => 'Låttextvy';

  @override
  String get showLyricsTimestampsTitle => 'Visa tidsstämplar för synkroniserade låttexter';

  @override
  String get showLyricsTimestampsSubtitle => 'Styr ifall tidsstämplar för varje textrad visas i låttextvyn, om de finns tillgängliga.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Visa stoppknapp på medianotisen';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Styr ifall medianotisen har en stoppknapp utöver pausknappen. Detta åter dig stoppa uppspelningen utan att öppna appen.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Visa sökkontroller på medianotis';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Styr ifall medianotisen har en sökbar förloppsindikator. Detta låter dig ändra uppspelningspositionen utan att öppna appen.';

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
  String get lyricsAlignmentTitle => 'Justering av låttexter';

  @override
  String get lyricsAlignmentSubtitle => 'Styr justeringen av låttexter i textvyn.';

  @override
  String get lyricsFontSizeTitle => 'Storlek på låttexter';

  @override
  String get lyricsFontSizeSubtitle => 'Styr textstorleken på låttexter i textvyn.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Visa skivomslag innan låttexter';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Styr ifall skivomslaget visas ovanför låttexten innan det rullas bort.';

  @override
  String get keepScreenOn => 'Håll skärmen igång';

  @override
  String get keepScreenOnSubtitle => 'När skärmen skall hållas igång';

  @override
  String get keepScreenOnDisabled => 'Avstängd';

  @override
  String get keepScreenOnAlwaysOn => 'Alltid på';

  @override
  String get keepScreenOnWhilePlaying => 'Medan musik spelas';

  @override
  String get keepScreenOnWhileLyrics => 'Medal låttexter visas';

  @override
  String get keepScreenOnWhilePluggedIn => 'Håll endast igång skärmen vid laddning';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignorera inställningen Håll igång skärmen ifall enheten inte laddas';

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
    return 'Konstverk för $title. Tryck för att starta/pausa uppspelning. Svep vänster eller höger för att byta spår.';
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
  String get showFeatureChipsToggleTitle => 'Visa avancerad info om ljudspår';

  @override
  String get showFeatureChipsToggleSubtitle => 'Visa avancerad information om ljudspår, såsom codec, bithastighet och mer, på spelarskärmen.';

  @override
  String get albumScreen => 'Albumskärm';

  @override
  String get showCoversOnAlbumScreenTitle => 'Visa skivomslag för ljudspår';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Visa skivomslag separat för varje ljudspår på albumskärmen.';

  @override
  String get emptyTopTracksList => 'Du har inte lyssnat på några spår från denna artist ännu.';

  @override
  String get emptyFilteredListTitle => 'Inga objekt hittades';

  @override
  String get emptyFilteredListSubtitle => 'Inga objekt matchade filtret. Försök att stänga av filtret eller ändra sökbeteckningen.';

  @override
  String get resetFiltersButton => 'Återställ filter';

  @override
  String get resetSettingsPromptGlobal => 'Vill du verkligen återställa ALLA inställningar till deras ursprungsvärden?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Återställ ALLA inställningar';

  @override
  String get resetSettingsPromptLocal => 'Vill du verkligen återställa dessa inställningar till deras ursprungsvärden?';

  @override
  String get genericCancel => 'Avbryt';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Spellista',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Ljudspår',
        'library': 'Bibliotek',
        'other': 'Artikel',
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
  String get allowDeleteFromServerSubtitle => 'Slå på och av förmågan att permanent radera ett spår från serverns filsystem när radering är möjlig.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'detta album',
        'playlist': 'denna spellista',
        'artist': 'denna artist',
        'genre': 'denna genre',
        'track': 'detta ljudspår',
        'library': 'detta bibliotek',
        'other': 'detta objekt',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Detta raderar också objektet från denna enhet.',
        'cantDelete': ' Objektet finns kvar på denna enhet tills nästa synkronisering.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'den här enheten',
        'server': 'serverns filsystem och bibliotek.$_temp1\nDenna åtgärd kan inte ångras',
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
    return 'Varning: Du är på väg att ladda ned $count ljudspår.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Varningsgräns för stora nedladdningar';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'Ett varningsmeddelande visas när fler än detta antal ljudspår laddas ned samtidigt.';

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
    return 'Vill du verkligen lägga till alla ljudspår från $_temp0 \'$itemName\' till den här spellistan?  De kan endast tas bort individuellt.';
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
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Visa albumets releasedatum på spelarskärmen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Visa albumets releasedatum på spelarskärmen, efter albumets namn.';

  @override
  String get releaseDateFormatTitle => 'Format på releasedatum';

  @override
  String get releaseDateFormatSubtitle => 'Styr formatet på alla releasedatum som visas i appen.';

  @override
  String get librarySelectError => 'Fel vid inläsning av tillgängliga bibliotek för användare';

  @override
  String get autoOfflineOptionOff => 'Disabled';

  @override
  String get autoOfflineOptionNetwork => 'Network';

  @override
  String get autoOfflineOptionDisconnected => 'Disconnected';

  @override
  String get autoOfflineSettingDescription => 'Automatically enable Offline Mode.\nDisabled: Wont Automatically turn on Offline Mode. May save battery.\nNetwork: Turn Offline Mode on when not being connected to wifi or ethernet.\nDisconnected: Turn Offline Mode on when not being connected to anything.\nYou can always manually turn on offline mode which pauses automation until you turn offline mode off again';

  @override
  String get autoOfflineSettingTitle => 'Automated Offline Mode';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'enabled',
        'disabled': 'disabled',
        'other': 'set quantum position for',
      },
    );
    return 'Automatically $_temp0 Offline Mode';
  }

  @override
  String get audioFadeOutDurationSettingTitle => 'Audio fade-out duration';

  @override
  String get audioFadeOutDurationSettingSubtitle => 'The duration of the audio fade out in milliseconds.';

  @override
  String get audioFadeInDurationSettingTitle => 'Audio fade-in duration';

  @override
  String get audioFadeInDurationSettingSubtitle => 'The duration of the audio fade-in in milliseconds. Set to 0 to disable fade-in.';

  @override
  String get outputMenuButtonTitle => 'Output';

  @override
  String get outputMenuTitle => 'Change Output';

  @override
  String get outputMenuVolumeSectionTitle => 'Volume';

  @override
  String get outputMenuDevicesSectionTitle => 'Available Devices';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle => 'Connect to a device';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Device Speaker',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Unknown',
      },
    );
    return '$_temp0';
  }
}
