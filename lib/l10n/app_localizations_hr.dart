// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Jellyfin player glezbe otvorenog koda';

  @override
  String get startupErrorTitle =>
      'Something went wrong during app startup!\nSorry about that...';

  @override
  String get startupErrorCallToAction =>
      'Please create an issue on github.com/jmshrv/finamp with the logs(!) (use the button below) and a screenshot of this page, so that we can fix it as quickly as possible.';

  @override
  String get startupErrorWorkaround =>
      'As a workaround you could clear your app data to reset the app. Keep in mind that in this case all your settings and downloads will be deleted.';

  @override
  String get about => 'O aplikaciji Finamp';

  @override
  String get aboutContributionPrompt =>
      'Stvoren od sjajnih ljudi u njihovo slobodno vrijeme.\nI ti možeš biti jedan od njih!';

  @override
  String get aboutContributionLink => 'Doprinesi Finampu na GitHubu:';

  @override
  String get aboutReleaseNotes => 'Pročitaj najnovije napomene o izdanju:';

  @override
  String get aboutTranslations => 'Pomogni prevesti Finamp na tvoj jezik:';

  @override
  String get aboutThanks => 'Hvala ti što koristiš Finamp!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Dobro došli u';
  }

  @override
  String get loginFlowSlogan => 'Tvoja glazba, onako kako je želiš.';

  @override
  String get loginFlowGetStarted => 'Započni!';

  @override
  String get viewLogs => 'Pogledaj zapise';

  @override
  String get changeLanguage => 'Promijeni jezik';

  @override
  String get loginFlowServerSelectionHeading => 'Poveži se na Jellyfin';

  @override
  String get back => 'Natrag';

  @override
  String get serverUrl => 'URL servera';

  @override
  String get internalExternalIpExplanation =>
      'Ako želiš pristupiti Jellyfin serveru na daljinski način moraš korisititi tvoju eksternu IP adresu.\n\nAko je tvoj server na standardnom HTTP priključku (80 ili 443) ili Jellyfinovom standardnom priključku (8096), ne moraš navesti priključak.\n\nAko je URL ispravan, ispod polja za unos trebale bi se prikazati neke informacije o tvom serveru.';

  @override
  String get serverUrlHint => 'npr. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Pomoć za URL servera';

  @override
  String get emptyServerUrl => 'URL servera ne smije biti prazan';

  @override
  String get connectingToServer => 'Povezivanje na server …';

  @override
  String get loginFlowLocalNetworkServers =>
      'Serveri na tvojoj lokalnoj mreži:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Pretraga za serverima …';

  @override
  String get loginFlowAccountSelectionHeading => 'Odaberi tvoj račun';

  @override
  String get backToServerSelection => 'Natrag na izbor servera';

  @override
  String get loginFlowNamelessUser => 'Neimenovani korisnik';

  @override
  String get loginFlowCustomUser => 'Prilagođeni korisnik';

  @override
  String get loginFlowAuthenticationHeading => 'Prijavi se na tvoj račun';

  @override
  String get backToAccountSelection => 'Natrag na izbor računa';

  @override
  String get loginFlowQuickConnectPrompt => 'Koristite kod za brzo povezivanje';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Open the Jellyfin app or website, click on your user icon, and select Quick Connect.';

  @override
  String get loginFlowQuickConnectDisabled =>
      'Brzo povezivanje je onemogućeno na ovom serveru.';

  @override
  String get orDivider => 'ili';

  @override
  String get loginFlowSelectAUser => 'Odaberi korisnika';

  @override
  String get username => 'Korisničko ime';

  @override
  String get usernameHint => 'Upiši tvoje korisničko ime';

  @override
  String get usernameValidationMissingUsername => 'Upiši jedno korisničko ime';

  @override
  String get password => 'Lozinka';

  @override
  String get passwordHint => 'Upiši tvoju lozinku';

  @override
  String get login => 'Prijava';

  @override
  String get logs => 'Zapisi';

  @override
  String get next => 'Dalje';

  @override
  String get selectMusicLibraries => 'Odaberi fonoteke';

  @override
  String get couldNotFindLibraries =>
      'Nije bilo moguće pronaći niti jednu fonoteku.';

  @override
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Nepoznato ime';

  @override
  String get tracks => 'Pjesme';

  @override
  String get albums => 'Albumi';

  @override
  String get appearsOnAlbums => 'Appears On';

  @override
  String get artists => 'Izvođači';

  @override
  String get genres => 'Žanrovi';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Playliste';

  @override
  String get startMix => 'Pokreni miks';

  @override
  String get startMixNoTracksArtist =>
      'Pritisni dugo na izvođača za dodavanje ili uklanjanje izvođača iz miksera prije pokretanja miksa';

  @override
  String get startMixNoTracksAlbum =>
      'Pritisni dugo na album za dodavanje ili uklanjanje albuma iz miksera prije pokretanja miksa';

  @override
  String get startMixNoTracksGenre =>
      'Pritisni dugo na žanr za dodavanje ili uklanjanje žanra iz miksera prije pokretanja miksa';

  @override
  String get music => 'Glazba';

  @override
  String get clear => 'Očisti';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Izmiješaj sve';

  @override
  String get downloads => 'Preuzimanja';

  @override
  String get settings => 'Postavke';

  @override
  String get offlineMode => 'Izvanmrežni način rada';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get sortOrder => 'Redoslijed razvrstavanja';

  @override
  String get sortBy => 'Razvrstaj po';

  @override
  String get title => 'Naslov';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Izvođač albuma';

  @override
  String get albumArtists => 'Album Artists';

  @override
  String get performingArtists => 'Performing Artists';

  @override
  String get artist => 'Izvođač';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Budžet';

  @override
  String get communityRating => 'Ocjena zajednice';

  @override
  String get criticRating => 'Ocjena kritičara';

  @override
  String get dateAdded => 'Datum dodavanja';

  @override
  String get datePlayed => 'Datum reprodukcije';

  @override
  String get playCount => 'Broj reprodukcija';

  @override
  String get premiereDate => 'Datum premijere';

  @override
  String get productionYear => 'Godina produkcije';

  @override
  String get name => 'Ime';

  @override
  String get random => 'Slučajno';

  @override
  String get revenue => 'Prihod';

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
  String get syncDownloadedPlaylists => 'Sinkroniziraj preuzete playliste';

  @override
  String get downloadMissingImages => 'Preuzmi nedostajuće slike';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Preuzeto je $count nedostajućih slika',
      few: 'Preuzete su $count nedostajuće slike',
      one: 'Preuzeta je $count nedostajuća slika',
      zero: 'Nema nedostajućih slika',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Aktivna preuzimanja';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preuzimanja',
      few: '$count preuzimanja',
      one: '$count preuzimanje',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount tracks',
      one: '$trackCount track',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount images',
      one: '$imageCount image',
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
    return '$count dovršeno';
  }

  @override
  String dlFailed(int count) {
    return '$count neuspjelo';
  }

  @override
  String dlEnqueued(int count) {
    return '$count dodano u red';
  }

  @override
  String dlRunning(int count) {
    return '$count u tijeku';
  }

  @override
  String get activeDownloadsTitle => 'Aktivna preuzimanja';

  @override
  String get noActiveDownloads => 'Nema aktivnih preuzimanja.';

  @override
  String get errorScreenError =>
      'Dogodila se greška prilikom dohvaćanja popisa grešaka! Prijavi problem na GitHubu i izbriši podatke aplikacije';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Neuspjelo dohvaćanje pjesme s ID-a preuzimanja';

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
  String get deleteDownloadsConfirmButtonText => 'Izbriši';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get libraryDownloads => 'Library downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Greška';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'Pokreni';

  @override
  String get shuffleButtonLabel => 'Izmiješaj';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pjesama',
      few: '$count pjesme',
      one: '$count pjesma',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pjesama',
      few: '$count pjesme',
      one: '$count pjesma',
    );
    return '$_temp0, $downloads preuzeto';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pjesama preuzeto',
      few: '$count pjesme preuzete',
      one: '$count pjesma preuzeta',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Uredi ime playliste';

  @override
  String get editPlaylistNameTitle => 'Uredi ime playliste';

  @override
  String get required => 'Obavezno';

  @override
  String get updateButtonLabel => 'Ažuriraj';

  @override
  String get playlistUpdated => 'Ime playliste je ažurirano.';

  @override
  String get downloadsDeleted => 'Preuzimanja izbrisana.';

  @override
  String get addDownloads => 'Dodaj preuzimanja';

  @override
  String get location => 'Lokacija';

  @override
  String get confirmDownloadStarted => 'Preuzimanje pokrenuto';

  @override
  String get downloadsQueued =>
      'Preuzimanje pripremljeno, datoteke se preuzimaju';

  @override
  String get addButtonLabel => 'Dodaj';

  @override
  String get shareLogs => 'Dijeli zapise';

  @override
  String get exportLogs => 'Save logs';

  @override
  String get logsCopied => 'Zapisi su kopirani.';

  @override
  String get message => 'Poruka';

  @override
  String get stackTrace => 'Trag Stacka';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Licenca: Mozilla Public License 2.0.\nIzvorni kod je dostupan na $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transkodiranje';

  @override
  String get downloadLocations => 'Lokacija preuzimanja';

  @override
  String get audioService => 'Usluga audioreprodukcije';

  @override
  String get playbackReporting => 'Playback Reporting';

  @override
  String get interactions => 'Interakcije';

  @override
  String get layoutAndTheme => 'Izgled i tema';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Nije dostupno u neumreženom modusu';

  @override
  String get logOut => 'Odjavi se';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Preuzete pjesme se neće izbrisati';

  @override
  String get areYouSure => 'Jeste li sigurni?';

  @override
  String get enableTranscoding => 'Omogući transkodiranje';

  @override
  String get enableTranscodingSubtitle =>
      'Transkodira stream glazbe na strani servera.';

  @override
  String get bitrate => 'Brzina prijenosa';

  @override
  String get bitrateSubtitle =>
      'Veća brzina prijenosa daje veću kvalitetu zvuka, ali troši veću količinu prometa.';

  @override
  String get customLocation => 'Prilagođena lokacija';

  @override
  String get appDirectory => 'Direktorij aplikacije';

  @override
  String get addDownloadLocation => 'Dodaj lokaciju preuzimanja';

  @override
  String get selectDirectory => 'Odaberi direktorij';

  @override
  String get unknownError => 'Nepoznata greška';

  @override
  String get pathReturnSlashErrorMessage =>
      'Staze sa znakom „/” se ne mogu koristiti';

  @override
  String get directoryMustBeEmpty => 'Direktorij mora biti prazan';

  @override
  String get customLocationsBuggy =>
      'Prilagođene lokacije su izrazito pune grešaka zbog problema oko dozvola. Razmišljam o načinima da ovo ispravim, ali za sada ne bih preporučio korištenje.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Prijeđi u stanje niskog prioriteta za vrijeme pauze';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Omogućuje brisanje obavijesti kada je pauzirano. Također omogućuje Androidu da prekine uslugu kada je pauzirana.';

  @override
  String get shuffleAllTrackCount => 'Broj svih izmiješanih pjesama';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Broj pjesama koje se učitavaju kada se koristi gumb „Izmiješaj sve pjesme”.';

  @override
  String get viewType => 'Vrsta prikaza';

  @override
  String get viewTypeSubtitle => 'Vrsta prikaza za ekran glazbe';

  @override
  String get list => 'Popis';

  @override
  String get grid => 'Rešetka';

  @override
  String get customizationSettingsTitle => 'Prilagođavanje';

  @override
  String get playbackSpeedControlSetting =>
      'Vidljivost kontrole za brzinu reprodukcije';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Da li prikazati kontrole za brzinu reprodukcije u izborniku ekrana playera';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Automatic:\nFinamp tries to identify whether the track you are playing is a podcast or (part of) an audiobook. This is considered to be the case if the track is longer than $trackDuration minutes, if the track\'\'s album is longer than $albumDuration hours, or if the track has at least one of these genres assigned: $genreList\nPlayback speed controls will then be shown in the player screen menu.\n\nShown:\nThe playback speed controls will always be shown in the player screen menu.\n\nHidden:\nThe playback speed controls in the player screen menu are always hidden.';
  }

  @override
  String get automatic => 'Automatski';

  @override
  String get shown => 'Prikazano';

  @override
  String get hidden => 'Skriveno';

  @override
  String get speed => 'Brzina';

  @override
  String get reset => 'Resetiraj';

  @override
  String get apply => 'Primijeni';

  @override
  String get portrait => 'Uspravno';

  @override
  String get landscape => 'Ležeće';

  @override
  String gridCrossAxisCount(String value) {
    return '$value – broj rešetkastih linija';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Količina rešetkastih polja po retku za $value.';
  }

  @override
  String get showTextOnGridView => 'Prikaži tekst u rešetkastom prikazu';

  @override
  String get showTextOnGridViewSubtitle =>
      'Da li prikazati tekst (naslov, izvođač itd.) u rešetkastom ekranu glazbe.';

  @override
  String get useCoverAsBackground =>
      'Prikaži mutnu sliku omota kao pozadinu playera';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Da li koristiti mutnu sliku omota kao pozadinu na ekranu playera.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Minimalni odmak omota albuma';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Minimalni prostor oko omota albuma na ekranu playera, u % širine ekrana.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Sakrij izvođače pjesama ako su isti kao izvođači albuma';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Da li prikazati izvođače pjesama na ekranu albuma ako se ne razlikuju od izvođača albuma.';

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
  String get disableGesture => 'Deaktiviraj geste';

  @override
  String get disableGestureSubtitle => 'Da li deaktivirati geste.';

  @override
  String get showFastScroller => 'Prikaži traku za brzo listanje';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sustav';

  @override
  String get light => 'Svijetla';

  @override
  String get dark => 'Tamna';

  @override
  String get tabs => 'Kartice';

  @override
  String get playerScreen => 'Ekran playera';

  @override
  String get cancelSleepTimer => 'Prekinuti odbrojavanje?';

  @override
  String get yesButtonLabel => 'Da';

  @override
  String get noButtonLabel => 'Ne';

  @override
  String get setSleepTimer => 'Postavi odbrojavanje';

  @override
  String get hours => 'Sati';

  @override
  String get seconds => 'Sekunde';

  @override
  String get minutes => 'Minute';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime od $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Pjesma $currentTrackIndex od $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Neispravan broj';

  @override
  String get sleepTimerTooltip => 'Odbrojavanje';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Gasi se za $time min';
  }

  @override
  String get addToPlaylistTooltip => 'Dodaj u playlistu';

  @override
  String get addToPlaylistTitle => 'Dodaj u playlistu';

  @override
  String get addToMorePlaylistsTooltip => 'Dodaj u još playlista';

  @override
  String get addToMorePlaylistsTitle => 'Dodaj u još playlista';

  @override
  String get removeFromPlaylistTooltip => 'Ukloni iz ove playliste';

  @override
  String get removeFromPlaylistTitle => 'Ukloni iz ove playliste';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Ukloni iz playliste „$playlistName”';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Ukloni iz playliste „$playlistName”';
  }

  @override
  String get newPlaylist => 'Nova playlista';

  @override
  String get createButtonLabel => 'Stvori';

  @override
  String get playlistCreated => 'Playlista je stvorena.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Dodirni za dodavanje u playlistu. Pritisni dugo za uključivanje u favorite.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Nema albuma';

  @override
  String get noItem => 'Nema stavki';

  @override
  String get noArtist => 'Nema izvođača';

  @override
  String get unknownArtist => 'Nepoznat izvođač';

  @override
  String get unknownAlbum => 'Nepoznat album';

  @override
  String get playbackModeDirectPlaying => 'Izravna reprodukcija';

  @override
  String get playbackModeTranscoding => 'Transkodiranje';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Lokalna reprodukcija';

  @override
  String get queue => 'Red čekanja';

  @override
  String get addToQueue => 'Dodaj u red čekanja';

  @override
  String get replaceQueue => 'Zamijeni red čekanja';

  @override
  String get instantMix => 'Instant miks';

  @override
  String get goToAlbum => 'Idi na album';

  @override
  String get goToArtist => 'Idi na izvođača';

  @override
  String get goToGenre => 'Idi na žanr';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Favorit dodan';

  @override
  String get confirmFavoriteRemoved => 'Favorit uklonjen';

  @override
  String get addedToQueue => 'Dodano u red čekanja.';

  @override
  String get insertedIntoQueue => 'Umetnuto u red čekanja.';

  @override
  String get queueReplaced => 'Red čekanja je zamijenjen.';

  @override
  String get confirmAddedToPlaylist => 'Dodano u playlistu.';

  @override
  String get removedFromPlaylist => 'Uklonjeno iz playliste.';

  @override
  String get startingInstantMix => 'Pokretanje instant miksa.';

  @override
  String get anErrorHasOccured => 'Dogodila se greška.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Kȏd stanja $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Kȏd stanja $statusCode. Ovo vjerojatno znači da si koristio/la pogrešno korisničko ime/lozinku ili da tvoj klijent više nije prijavljen.';
  }

  @override
  String get removeFromMix => 'Ukloni iz miksa';

  @override
  String get addToMix => 'Dodaj u miks';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ponovo je preuzeto $count stavki',
      few: 'Ponovo su preuzete $count stavke',
      one: 'Ponovo je preuzeta $count stavka',
      zero: 'Ponovna preuzimanja nisu potrebna.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Trajanje međuspremnika';

  @override
  String get bufferDurationSubtitle =>
      'Količina koju player treba spremiti u međuspremnik, u sekundama. Zahtijeva ponovno pokretanje.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Don\'t limit buffer size';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.';

  @override
  String get bufferSizeTitle => 'Veličina međuspreminka';

  @override
  String get bufferSizeSubtitle =>
      'Maksimalna veličina međuspremnika u MB. Zahtijeva ponovno pokretanje';

  @override
  String get language => 'Jezik';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Prijeđi na početak ili na prethodnu pjesmu';

  @override
  String get skipToNextTrackButtonTooltip => 'Prijeđi na sljedeću pjesmu';

  @override
  String get togglePlaybackButtonTooltip => 'Uključi/Isključi reprodukciju';

  @override
  String get previousTracks => 'Prethodne pjesme';

  @override
  String get nextUp => 'Sljedeće na redu';

  @override
  String get clearNextUp => 'Izbriši sljedeće na redu';

  @override
  String get stopAndClearQueue => 'Stop playback and clear queue';

  @override
  String get playingFrom => 'Reprodukcija iz';

  @override
  String get playNext => 'Pokreni sljedeću';

  @override
  String get addToNextUp => 'Dodaj u sljedeće na redu';

  @override
  String get shuffleNext => 'Izmiješaj sljedeće';

  @override
  String get shuffleToNextUp => 'Izmiješaj sljedeće na redu';

  @override
  String get shuffleToQueue => 'Shuffle to queue';

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
    return '$_temp0 will play next';
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
    return 'Added $_temp0 to Next Up';
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
    return 'Added $_temp0 to queue';
  }

  @override
  String get confirmShuffleNext => 'Will shuffle next';

  @override
  String get confirmShuffleToNextUp => 'Shuffled to Next Up';

  @override
  String get confirmShuffleToQueue => 'Shuffled to queue';

  @override
  String get placeholderSource => 'Negdje';

  @override
  String get playbackHistory => 'Povijest reprodukcija';

  @override
  String get shareOfflineListens => 'Dijeli offline slušanja';

  @override
  String get yourLikes => 'Your Likes';

  @override
  String mix(String mixSource) {
    return '$mixSource – miks';
  }

  @override
  String get tracksFormerNextUp => 'Tracks added via Next Up';

  @override
  String get savedQueue => 'Saved Queue';

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
        'remoteClient': 'a Remote Client',
        'other': '',
      },
    );
    return 'Playing From $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Izmiješaj sve';

  @override
  String get playbackOrderLinearButtonLabel => 'Playing in order';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Playing in order. Tap to shuffle.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Miješanje pjesama';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Shuffling tracks. Tap to play in order.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Reproduciraj na x$speed brzini';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed speed';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volume';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Smanji brzinu reprodukcije';

  @override
  String get playbackSpeedIncreaseLabel => 'Povećaj brzinu reprodukcije';

  @override
  String get loopModeNoneButtonLabel => 'Bez petlje';

  @override
  String get loopModeOneButtonLabel => 'Looping this track';

  @override
  String get loopModeAllButtonLabel => 'Ponovi sve';

  @override
  String get queuesScreen => 'Restore Now Playing';

  @override
  String get queueRestoreButtonLabel => 'Obnovi';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Spremljeno $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Reprodukcija: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pjesama',
      few: '$count pjesme',
      one: '1 pjesma',
    );
    return '$_temp0, preostalo: $remaining';
  }

  @override
  String get queueLoadingMessage => 'Restoring queue…';

  @override
  String get queueRetryMessage => 'Failed to restore queue. Retry?';

  @override
  String get autoloadLastQueueOnStartup => 'Auto-Restore Last Queue';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Upon app startup, attempt to restore the last played queue.';

  @override
  String get reportQueueToServer => 'Report current queue to server?';

  @override
  String get reportQueueToServerSubtitle =>
      'When enabled, Finamp will send the current queue to the server. This can improve remote control and allow server-side restoration of the queue. Always enabled if the \'Play On\' feature is enabled.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Playback Session Update Frequency';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'How often to send the current playback status to the server, in seconds. This should be less than 5 minutes (300 seconds), to prevent the session from timing out.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'If the Jellyfin server hasn\'\'t received any updates from a client in the last 5 minutes, it assumes that playback has ended. This means that for tracks longer than 5 minutes, that playback could be incorrectly reported as having ended, which reduced the quality of the playback reporting data.';

  @override
  String get playOnStaleDelay => '\'Play On\' Session Timeout';

  @override
  String get playOnStaleDelaySubtitle =>
      'How long a remote \'Play On\' session is considered active after receiving a command. When considered active, playback is reported more frequently, which can lead to increased bandwidth usage.';

  @override
  String get enablePlayonTitle => 'Enable \'Play On\' Support';

  @override
  String get enablePlayonSubtitle =>
      'Enables Jellyfin\'s \'Play On\' feature (remote-controlling Finamp from another client). Disable this if your reverse proxy or server doesn\'t support websockets.';

  @override
  String get playOnReconnectionDelay =>
      '\'Play On\' Session Reconnection Delay';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Controls the delay between the attempts to reconnect to the PlayOn websocket when it gets disconnected (in seconds). A lower delay increases bandwidth usage.';

  @override
  String get topTracks => 'Najslušanije pjesme';

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
      other: '$count albuma',
      few: '$count albuma',
      one: '$count album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Izmiješaj albume';

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
      other: '$playCount reprodukcija',
      few: '$playCount reprodukcije',
      one: '$playCount reprodukcija',
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
  String get confirm => 'Potvrdi';

  @override
  String get close => 'Zatvori';

  @override
  String get showUncensoredLogMessage =>
      'Ovaj zapis sadrži tvoje podatke za prijavu. Prikazati?';

  @override
  String get resetTabs => 'Resetiraj kartice';

  @override
  String get resetToDefaults => 'Resetiraj na zadane vrijednosti';

  @override
  String get noMusicLibrariesTitle => 'Nema fonoteka';

  @override
  String get noMusicLibrariesBody =>
      'Finamp nije mogao pronaći nijednu fonoteku. Provjeri sadrži li tvoj Jellyfin poslužitelj barem jednu biblioteku s vrstom sadržaja postavljenom na „Glazba”.';

  @override
  String get refresh => 'Osvježi';

  @override
  String get moreInfo => 'Više informacija';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalizacija glasnoće';

  @override
  String get playbackReportingSettingsTitle => 'Playback Reporting & Play On';

  @override
  String get volumeNormalizationSwitchTitle =>
      'Aktiviraj normalizaciju glasnoće';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Use gain information to normalize the loudness of tracks (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle =>
      'Modus normalizacija glasnoće';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'Kada i kako primijeniti normalizaciju glasnoće';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Hybrid (Track + Album):\nTrack gain is used for regular playback, but if an album is playing (either because it\'\'s the main playback queue source, or because it was added to the queue at some point), the album gain is used instead.\n\nTrack-based:\nTrack gain is always used, regardless of whether an album is playing or not.\n\nAlbums Only:\nVolume Normalization is only applied while playing albums (using the album gain), but not for individual tracks.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybrid (Track + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Track-based';

  @override
  String get volumeNormalizationModeAlbumBased => 'Album-based';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Samo za albume';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Base Gain';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Currently, Volume Normalization on iOS requires changing the playback volume to emulate the gain change. Since we can\'\'t increase the volume above 100%, we need to decrease the volume by default so that we can boost the volume of quiet tracks. The value is in decibels (dB), where -10 dB is ~30% volume, -4.5 dB is ~60% volume and -2 dB is ~80% volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext =>
      'Reproduciraj pjesmu kao sljedeću povlačenjem';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Omogući umetanje pjesme kao sljedeću pjesmu u redu reprodukcije povlačenjem pjesme iz popisa pjesama umjesto dodavanja pjesme na kraj popisa.';

  @override
  String get swipeLeftToRightAction => 'Swipe to Right Action';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Action triggered when swiping a track in the list from left to right.';

  @override
  String get swipeRightToLeftAction => 'Swipe to Left Action';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Action triggered when swiping a track in the list from right to left.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Start Instant Mixes for Individual Tracks';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'When enabled, tapping a track on the tracks tab will start an instant mix of that track instead of just playing a single track.';

  @override
  String get downloadItem => 'Preuzmi';

  @override
  String get repairComplete => 'Downloads Repair complete.';

  @override
  String get syncComplete => 'Sva preuzimanja su ponovo sinkronizirana.';

  @override
  String get syncDownloads => 'Sinkroniziraj i preuzmi stavke koje nedostaju.';

  @override
  String get repairDownloads =>
      'Repair issues with downloaded files or metadata.';

  @override
  String get requireWifiForDownloads => 'Zahtijevaj WiFi prilikom preuzimanja.';

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
  String get onlyShowFullyDownloaded => 'Prikaži samo potpuno preuzete albume';

  @override
  String get filesystemFull =>
      'Remaining downloads cannot be completed. The filesystem is full.';

  @override
  String get connectionInterrupted =>
      'Veza je prekinuta, preuzimanja se zaustavljaju.';

  @override
  String get connectionInterruptedBackground =>
      'Veza je prekinuta tijekom preuzimanja u pozadini. Provjeri postavke OS-a.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'Connection was interrupted while downloading in the background. This can be caused by enabling \'Enter Low-Priority State on Pause\' or OS settings.';

  @override
  String get activeDownloadSize => 'Preuzimanje …';

  @override
  String get missingDownloadSize => 'Brisanje …';

  @override
  String get syncingDownloadSize => 'Sinkroniziranje …';

  @override
  String get runRepairWarning =>
      'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.';

  @override
  String get downloadSettings => 'Preuzimanja';

  @override
  String get showNullLibraryItemsTitle => 'Show Media with Unknown Library.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => 'Maks. broj istovremenskih preuzimanja';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'Increasing concurrent downloads may allow increased downloading in the background but may cause some downloads to fail if very large, or cause excessive lag in some cases.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return 'Broj istovremenskih preuzimanja: $count';
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
  String get syncOnStartupSwitch =>
      'Automatski sinkroniziraj preuzimanja pri pokretanju aplikacije';

  @override
  String get preferQuickSyncSwitch => 'Koristi brzu sinkronizaciju';

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
    return 'Predmemorirane slike za \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle => 'Select Transcoding Format';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Select the format to use when streaming transcoded audio. Already queued tracks will not be affected.';

  @override
  String get downloadTranscodeEnableTitle =>
      'Omogući transkodirana preuzimanja';

  @override
  String get downloadTranscodeCodecTitle => 'Odaberi kodek preuzimanja';

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
  String get downloadBitrate => 'Brzina preuzimanja';

  @override
  String get downloadBitrateSubtitle =>
      'A higher bitrate gives higher quality audio at the cost of larger storage requirements.';

  @override
  String get transcodeHint => 'Transkodirati?';

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
  String get fixedGridSizeSwitchTitle =>
      'Koristi fiksnu veličinu rešetkastih polja';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Veličine rešetkastih polja neće reagirati na veličinu prozora/ekrana.';

  @override
  String get fixedGridSizeTitle => 'Veličine rešetkastih polja';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Mala',
        'medium': 'Srednja',
        'large': 'Velika',
        'veryLarge': 'Jako velika',
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
  String get enableVibration => 'Omogući vibraciju';

  @override
  String get enableVibrationSubtitle => 'Whether to enable vibration.';

  @override
  String get hideQueueButton => 'Sakrij gumb čekanja';

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
  String get suppressPlayerPadding => 'Poništi odmake kontrola playera';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Potpuno smanjuje razmake između kontrola ekrana playera kada omot albuma nije u punoj veličini.';

  @override
  String get lockDownload => 'Uvijek zadrži na uređaju';

  @override
  String get showArtistChipImage => 'Prikaži slike izvođača s imenom izvođača';

  @override
  String get showArtistChipImageSubtitle =>
      'To utječe na preglede malih slika izvođača, npr. na ekranu playera.';

  @override
  String get scrollToCurrentTrack => 'Klizni na trenutačnu pjesmu';

  @override
  String get enableAutoScroll => 'Aktiviraj automatsko klizanje';

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
    return '$duration preostalo';
  }

  @override
  String get removeFromPlaylistConfirm => 'Ukloni';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Ukloniti \'$itemName\' iz playliste \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Izbornik pjesama';

  @override
  String get quickActions => 'Brze radnje';

  @override
  String get addRemoveFromPlaylist => 'Dodaj u / Ukloni iz playlista';

  @override
  String get addPlaylistSubheader => 'Dodaj pjesmu u playlistu';

  @override
  String get trackOfflineFavorites => 'Sinkroniziraj sva stanja favorita';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Ovo omogućuje prikazivanje aktualnijih stanja favorita dok si offline. Ne preuzima dodatne datoteke.';

  @override
  String get allPlaylistsInfoSetting => 'Preuzmi metapodatke playliste';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Sync metadata for all playlists to improve your playlist experience';

  @override
  String get downloadFavoritesSetting => 'Preuzmi sve favorite';

  @override
  String get downloadAllPlaylistsSetting => 'Preuzmi sve playliste';

  @override
  String get fiveLatestAlbumsSetting => 'Preuzmi 5 najnovijih albuma';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Preuzimanja će se ukloniti kada zastare. Zaključaj preuzimanje za sprečavanje uklanjanja albuma.';

  @override
  String get cacheLibraryImagesSettings =>
      'Spremi trenutačne slike biblioteke u predmemoriju';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Svi omoti albuma, izvođača, žanra i playlista u trenutačno aktivnoj biblioteci će se preuzeti.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Prikaži napredak pjesme u ugrađenom miniplayeru';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Upravlja hoće li ugrađeni miniplayer / traka trenutačne reprodukcije na dnu ekrana glazbe funkcionirati kao traka napretka.';

  @override
  String get lyricsScreenButtonTitle => 'Lyrics';

  @override
  String get lyricsScreen => 'Prikaz teksta pjesme';

  @override
  String get showLyricsTimestampsTitle =>
      'Prikaži vremenske oznake za sinkronizirane tekstove pjesma';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Kontrolira hoće li se vremenska oznaka svakog retka teksta pjesme prikazati u prikazu teksta pjesme, ako je dostupna.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Prikaži gumb za prekidanje na medijskoj obavijesti';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Kontrolira ima li medijska obavijest gumb za prekidanje dodatno uz gumb za pauzu. To omogućuje prekidanje reprodukcije bez otvaranja aplikacije.';

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
      'Allow Seeking on Media Notification';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Controls if the media notification has a seekable progress bar. This lets you change the playback position without opening the app.';

  @override
  String get alignmentOptionStart => 'Lijevo';

  @override
  String get alignmentOptionCenter => 'Centrirano';

  @override
  String get alignmentOptionEnd => 'Desno';

  @override
  String get fontSizeOptionSmall => 'Mala';

  @override
  String get fontSizeOptionMedium => 'Srednja';

  @override
  String get fontSizeOptionLarge => 'Velika';

  @override
  String get lyricsAlignmentTitle => 'Poravnanje teksta pjesme';

  @override
  String get lyricsAlignmentSubtitle =>
      'Kontrolira poravnanje teksta pjesme u prikazu teksta pjesama.';

  @override
  String get lyricsFontSizeTitle => 'Veličina fonta za tekstove pjesama';

  @override
  String get lyricsFontSizeSubtitle =>
      'Kontrolira veličinu fonta za tekst pjesme u prikazu teksta pjesme.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Prikaži album prije teksta pjesme';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Kontrolira hoće li se omot albuma prikazati iznad teksta pjesme prije nego što se ukloni.';

  @override
  String get keepScreenOn => 'Ostavi ekran uključenim';

  @override
  String get keepScreenOnSubtitle => 'Kada ostaviti ekran uključenim';

  @override
  String get keepScreenOnDisabled => 'Deaktivirano';

  @override
  String get keepScreenOnAlwaysOn => 'Uvijek uključen';

  @override
  String get keepScreenOnWhilePlaying => 'Tijekom reprodukcije glazbe';

  @override
  String get keepScreenOnWhileLyrics => 'Tijekom prikazivanja teksta pjesme';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Ostavi ekran uključenim kada je uređaj priključen na struju';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Zanemari postavku za ostavljanje ekrana uključenim kada uređaj nije priključen na struju';

  @override
  String get genericToggleButtonTooltip => 'Tap to toggle.';

  @override
  String get artwork => 'Artwork';

  @override
  String artworkTooltip(String title) {
    return 'Artwork for $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Artwork for $title. Tap to toggle playback. Swipe left or right to switch tracks.';
  }

  @override
  String get nowPlayingBarTooltip => 'Otvori ekran playera';

  @override
  String get additionalPeople => 'People';

  @override
  String get playbackMode => 'Modus reprodukcije';

  @override
  String get codec => 'Kodek';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Bit Depth';

  @override
  String get size => 'Veličina';

  @override
  String get normalizationGain => 'Pojačanje';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get showFeatureChipsToggleTitle => 'Show Advanced Track Info';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Show advanced track info like codec, bitrate, and more on the player screen.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Ekran albuma';

  @override
  String get showCoversOnAlbumScreenTitle => 'Prikaži omote albuma za pjesme';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Prikaži omote albuma za svaku pjesmu pjedinačno na ekranu albuma.';

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
      'You haven\'t listened to any track by this artist yet.';

  @override
  String get emptyFilteredListTitle => 'No items found';

  @override
  String get emptyFilteredListSubtitle =>
      'No items match the filter. Try turning off the filter or changing the search term.';

  @override
  String get resetFiltersButton => 'Reset filters';

  @override
  String get resetSettingsPromptGlobal =>
      'Are you sure you want to reset ALL settings to their defaults?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Resetiraj SVE postavke';

  @override
  String get resetSettingsPromptLocal =>
      'Želiš li resetirati ove postavke na zadane vrijednosti?';

  @override
  String get genericCancel => 'Odustani';

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
  String get allowDeleteFromServerSubtitle =>
      'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.';

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
        'canDelete': ' This will also Delete this item from this Device.',
        'cantDelete':
            ' This item will stay on this device until the next sync.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'this device',
        'server':
            'the servers file system and library.$_temp1\nThis action cannot be reverted',
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
  String get downloadSizeWarningCutoffSubtitle =>
      'A warning message will be displayed when downloading more than this many tracks at once.';

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
  String get releaseDateFormatYear => 'Godina';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Month & Year';

  @override
  String get releaseDateFormatMonthDayYear => 'Month, Day & Year';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Show Album Release Date on Player Screen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Show the release date of the album on the player screen, behind the album name.';

  @override
  String get releaseDateFormatTitle => 'Release Date Format';

  @override
  String get releaseDateFormatSubtitle =>
      'Controls the format of all release dates shown in the app.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError => 'Error loading available libraries for user';

  @override
  String get autoOfflineOptionOff => 'Disabled';

  @override
  String get autoOfflineOptionNetwork => 'Local Network';

  @override
  String get autoOfflineOptionDisconnected => 'Disconnected';

  @override
  String get autoOfflineSettingDescription =>
      'Automatically enable Offline Mode.\nDisabled: Wont Automatically turn on Offline Mode. May save battery.\nLocal Network: Turn Offline Mode on when not being connected to wifi or ethernet.\nDisconnected: Turn Offline Mode on when not being connected to anything.\nYou can always manually turn on offline mode which pauses automation until you turn offline mode off again';

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
  String get audioFadeOutDurationSettingSubtitle =>
      'The duration of the audio fade out in milliseconds.';

  @override
  String get audioFadeInDurationSettingTitle => 'Audio fade-in duration';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'The duration of the audio fade-in in milliseconds. Set to 0 to disable fade-in.';

  @override
  String get outputMenuButtonTitle => 'Output';

  @override
  String get outputMenuTitle => 'Change Output';

  @override
  String get outputMenuVolumeSectionTitle => 'Volume';

  @override
  String get outputMenuDevicesSectionTitle => 'Available Devices';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Connect to a device';

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

  @override
  String get desktopShuffleWarning =>
      'Changing shuffle mode is not currently available on desktop.';

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
