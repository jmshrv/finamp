// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Avoimen lähdekoodin Jellyfin-musiikkisoitin';

  @override
  String get startupErrorTitle =>
      'Jokin meni pieleen sovelluksen käynnistyksessä!\nPahoittelut siitä..';

  @override
  String get startupErrorCallToAction =>
      'Ole hyvä ja luo tiketti osoitteessa github.com/jmshrv/finamp , ja liitä mukaan lokitiedot(!) (Käytä nappia alla) Liitä myös näyttökuva tästä sivusta, jotta voimme korjata vian mahdollisimman nopeasti.';

  @override
  String get startupErrorWorkaround =>
      'Tilapäiskorjauksena voit yrittää tyhjentää sovelluksen datan nollataksesi sovelluksen. Ota huomioon, että tämä poistaa kaikki asetukset ja ladatut tiedostot.';

  @override
  String get about => 'Tietoa Finampista';

  @override
  String get aboutContributionPrompt =>
      'Pyyteettömien ja upeiden ihmisten vapaa-ajallaan tekemä sovellus.\nVoit olla yksi heistä!';

  @override
  String get aboutContributionLink =>
      'Osallistu Finampin kehittämiseen GitHubissa:';

  @override
  String get aboutReleaseNotes => 'Uusimmat päivitystiedot:';

  @override
  String get aboutTranslations => 'Auta kääntämään Finampia omalle kielellesi:';

  @override
  String get aboutThanks => 'Kiitos, että käytät Finampia!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Tervetuloa sovellukseen';
  }

  @override
  String get loginFlowSlogan => 'Oma musiikkisi, juuri haluamallasi tavalla.';

  @override
  String get loginFlowGetStarted => 'Aloita tästä!';

  @override
  String get viewLogs => 'Näytä lokitiedot';

  @override
  String get changeLanguage => 'Vaihda kieltä';

  @override
  String get loginFlowServerSelectionHeading => 'Yhdistä Jellyfiniin';

  @override
  String get back => 'Takaisin';

  @override
  String get serverUrl => 'Palvelimen URL';

  @override
  String get internalExternalIpExplanation =>
      'Jos haluat saada etäyhteyden Jellyfin-palvelimellesi, sinun on käytettävä ulkoista IP-osoitettasi.\n\nJos palvelimesi on HTTP-oletusportissa (80 tai 443) tai Jellyfinin oletusportissa (8096), sinun ei tarvitse määrittää porttia.\n\nJos URL-osoite on syötetty oikein, syöttökentän alla pitäisi näkyä tietoja palvelimestasi.';

  @override
  String get serverUrlHint => 'esim. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip =>
      'Apua palvelinosoitteen syöttämiseen';

  @override
  String get emptyServerUrl => 'Palvelimen URL ei voi olla tyhjä';

  @override
  String get connectingToServer => 'Yhdistetään palvelimeen…';

  @override
  String get loginFlowLocalNetworkServers => 'Palvelimet paikallisverkossasi:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Etsitään palvelimia…';

  @override
  String get loginFlowAccountSelectionHeading => 'Valitse tilisi';

  @override
  String get backToServerSelection => 'Takaisin palvelimen valintaan';

  @override
  String get loginFlowNamelessUser => 'Anonyymi käyttäjä';

  @override
  String get loginFlowCustomUser => 'Räätälöity käyttäjä';

  @override
  String get loginFlowAuthenticationHeading => 'Kirjaudu tilillesi';

  @override
  String get backToAccountSelection => 'Takaisin tilin valintaan';

  @override
  String get loginFlowQuickConnectPrompt => 'Käytä pikayhdistyskoodia';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Avaa Jellyfin-sovellus tai osoite, klikkaa käyttäjäkuvaketta, ja valitse Pikayhdistys.';

  @override
  String get loginFlowQuickConnectDisabled =>
      'Pikayhdistys poistettu käytöstä tällä palvelimella.';

  @override
  String get orDivider => 'tai';

  @override
  String get loginFlowSelectAUser => 'Valitse käyttäjä';

  @override
  String get username => 'Käyttäjätunnus';

  @override
  String get usernameHint => 'Syötä käyttäjätunnus';

  @override
  String get usernameValidationMissingUsername =>
      'Ole hyvä ja syötä käyttäjätunnus';

  @override
  String get password => 'Salasana';

  @override
  String get passwordHint => 'Syötä salasana';

  @override
  String get login => 'Kirjaudu sisään';

  @override
  String get logs => 'Lokit';

  @override
  String get next => 'Seuraava';

  @override
  String get selectMusicLibraries => 'Valitse musiikkikirjastot';

  @override
  String get couldNotFindLibraries => 'Yhtään kirjastoa ei löytynyt.';

  @override
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Tuntematon Nimi';

  @override
  String get tracks => 'Kappaleet';

  @override
  String get albums => 'Albumit';

  @override
  String get appearsOnAlbums => 'Esiintyy';

  @override
  String get artists => 'Artistit';

  @override
  String get genres => 'Tyylilajit';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Soittolistat';

  @override
  String get startMix => 'Aloita sekoitus';

  @override
  String get startMixNoTracksArtist =>
      'Paina artistin nimeä pitkään lisätäksesi tai poistaaksesi sen sekoituksesta ennen sen aloittamista';

  @override
  String get startMixNoTracksAlbum =>
      'Paina albumia pitkään lisätäksesi tai poistaaksesi sen sekoituksesta ennen sen aloittamista';

  @override
  String get startMixNoTracksGenre =>
      'Paina tyylilajia pitkään lisätäksesi tai poistaaksesi sen sekoituksesta ennen sen aloittamista';

  @override
  String get music => 'Musiikki';

  @override
  String get clear => 'Tyhjennä';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Sekoita kaikki';

  @override
  String get downloads => 'Lataukset';

  @override
  String get settings => 'Asetukset';

  @override
  String get offlineMode => 'Offline-tila';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get sortOrder => 'Lajittelujärjestys';

  @override
  String get sortBy => 'Järjestä';

  @override
  String get title => 'Kappaleen nimi';

  @override
  String get album => 'Albumi';

  @override
  String get albumArtist => 'Albumin artisti';

  @override
  String get albumArtists => 'Albumin artistit';

  @override
  String get performingArtists => 'Esiintyvät artistit';

  @override
  String get artist => 'Artisti';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Budjetti';

  @override
  String get communityRating => 'Yhteisön arvostelu';

  @override
  String get criticRating => 'Kriitikoiden arvostelu';

  @override
  String get dateAdded => 'Lisäämisen päivämäärä';

  @override
  String get datePlayed => 'Toistettu viimeksi';

  @override
  String get playCount => 'Toistolaskuri';

  @override
  String get premiereDate => 'Ensiesityspäivä';

  @override
  String get productionYear => 'Tuotantovuosi';

  @override
  String get name => 'Nimi';

  @override
  String get random => 'Satunnainen';

  @override
  String get revenue => 'Tulot';

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
  String get syncDownloadedPlaylists => 'Synkronoi ladatut soittolistat';

  @override
  String get downloadMissingImages => 'Lataa puuttuvat kuvat';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ladattu $count puuttuvaa kuvaa',
      one: 'Ladattu $count puuttuva kuva',
      zero: 'Puuttuvia kuvia ei löytynyt',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Aktiiviset lataukset';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lataukset',
      one: '$count lataus',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount kappaletta',
      one: '$trackCount kappale',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount kuvaa',
      one: '$imageCount kuva',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount yksikköä synkronoivat',
      one: '$syncCount yksikkö synkronoi',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nKorjataan parhaillaan',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count valmistunut';
  }

  @override
  String dlFailed(int count) {
    return '$count epäonnistui';
  }

  @override
  String dlEnqueued(int count) {
    return '$count jonossa';
  }

  @override
  String dlRunning(int count) {
    return '$count käynnissä';
  }

  @override
  String get activeDownloadsTitle => 'Aktiiviset lataukset';

  @override
  String get noActiveDownloads => 'Ei aktiivisia latauksia.';

  @override
  String get errorScreenError =>
      'Tapahtui virhe vikalistan haussa! Tässä vaiheessa sinun kannattaa luultavasti vain luoda virheilmoitus GitHubiin ja poistaa sovelluksen data';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Kappaleen nouto lataus-ID:llä epäonnistui';

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
    return 'Haluatko varmasti poistaa kohteen $_temp0 \'$itemName\' tältä laitteelta?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Poista';

  @override
  String get specialDownloads => 'Erityiset lataukset';

  @override
  String get libraryDownloads => 'Kirjaston lataukset';

  @override
  String get noItemsDownloaded => 'Ei ladattuja kohteita.';

  @override
  String get error => 'Virhe';

  @override
  String discNumber(int number) {
    return 'Levy $number';
  }

  @override
  String get playButtonLabel => 'Toista';

  @override
  String get shuffleButtonLabel => 'Sekoita';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kappaletta',
      one: '$count Kappale',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kappaletta',
      one: '$count Kappale',
    );
    return '$_temp0,$downloads Ladattu';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kappaletta',
      one: '$count Kappale',
    );
    return '$_temp0 Ladattu';
  }

  @override
  String get editPlaylistNameTooltip => 'Muokkaa soittolistan nimeä';

  @override
  String get editPlaylistNameTitle => 'Muokkaa soittolistan nimeä';

  @override
  String get required => 'Pakollinen';

  @override
  String get updateButtonLabel => 'Päivitä';

  @override
  String get playlistUpdated => 'Soittolistan nimi päivitetty.';

  @override
  String get downloadsDeleted => 'Lataukset poistettu.';

  @override
  String get addDownloads => 'Lisää lataukset';

  @override
  String get location => 'Sijainti';

  @override
  String get confirmDownloadStarted => 'Lataus aloitettu';

  @override
  String get downloadsQueued =>
      'Valmistauduttu poimuajoon, tiedostoja ladataan';

  @override
  String get addButtonLabel => 'Lisää';

  @override
  String get shareLogs => 'Jaa lokit';

  @override
  String get exportLogs => 'Tallenna lokit';

  @override
  String get logsCopied => 'Lokit kopioitu.';

  @override
  String get message => 'Viesti';

  @override
  String get stackTrace => 'Pinon jäljitys';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Lisensoitu Mozilla Public License 2.0 -lisenssillä.\nLähdekoodi saatavilla osoitteessa: $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transkoodaus';

  @override
  String get downloadLocations => 'Latausten sijainnit';

  @override
  String get audioService => 'Äänipalvelu';

  @override
  String get playbackReporting => 'Toiston raportointi';

  @override
  String get interactions => 'Vuorovaikutukset';

  @override
  String get layoutAndTheme => 'Asettelu ja teema';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Ei saatavilla offline-tilassa';

  @override
  String get logOut => 'Kirjaudu ulos';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Ladattuja kappaleita ei poisteta';

  @override
  String get areYouSure => 'Oletko varma?';

  @override
  String get enableTranscoding => 'Ota transkoodaus käyttöön';

  @override
  String get enableTranscodingSubtitle =>
      'Transkoodaa musiikin suoratoistoa varten palvelimen päässä.';

  @override
  String get bitrate => 'Bittinopeus';

  @override
  String get bitrateSubtitle =>
      'Korkeampi bittinopeus tuottaa laadukkaamman äänen, mutta sen käyttämä kaistanleveys on suurempi. Ei päde häviöttömiin koodekkeihin, kuten FLAC';

  @override
  String get customLocation => 'Mukautettu sijainti';

  @override
  String get appDirectory => 'Sovelluksen hakemisto';

  @override
  String get addDownloadLocation => 'Lisää latausten hakemisto';

  @override
  String get selectDirectory => 'Valitse hakemisto';

  @override
  String get unknownError => 'Tuntematon virhe';

  @override
  String get pathReturnSlashErrorMessage =>
      'Polkuja jotka palauttavat \"/\" ei voi käyttää';

  @override
  String get directoryMustBeEmpty => 'Hakemiston täytyy olla tyhjä';

  @override
  String get customLocationsBuggy =>
      'Mukautetut sijainnit ovat erittäin bugisia ja niiden käyttöä ei suositella useimmissa tapauksissa. Sijainnit järjestelmän Musiikki-hakemiston alla estävät albumin kansikuvien tallentamisen käyttöjärjestelmän rajoitusten vuoksi.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Siirtyminen matalan prioriteetin tilaan tauon aikana';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Sallii ilmoituksen pyyhkäisemisen pois, kun toisto on pysäytetty. Antaa myös Androidin lopettaa palvelun, kun toisto on keskeytetty.';

  @override
  String get shuffleAllTrackCount => 'Kaikkien sekoitettujen kappaleiden määrä';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Ladattavien kappaleiden määrä, kun käytät sekoita kaikki kappaleet-painiketta.';

  @override
  String get viewType => 'Näkymän Tyyppi';

  @override
  String get viewTypeSubtitle => 'Musiikkinäytön näkymätyyppi';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Ruudukko';

  @override
  String get customizationSettingsTitle => 'Räätälöinti';

  @override
  String get playbackSpeedControlSetting => 'Toistonopeuden näkyvyys';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Näytetäänkö toistonopeuden säätimet soittimen valikossa';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Automaattinen:\nFinamp yrittää tunnistaa, onko toistamasi kappale podcast tai äänikirja(n osa). Tämän katsotaan tapahtuvan, jos kappale on pidempi kuin $trackDuration minuutti(a), tai jos kappaleen albumi on pidempi kuin $albumDuration tunti(a), tai jos kappaleella on ainakin yksi näistä tyylilajeista: $genreList\nToistonopeuden säätimet ovat tällöin esillä soittimen valikossa.\n\nEsillä:\nToistonopeuden säätimet ovat aina esillä soittimen valikossa.\n\nPiilotettu:\nToistonopeuden säätimet ovat aina piilossa soittimen valikossa.';
  }

  @override
  String get automatic => 'Automaattinen';

  @override
  String get shown => 'Esillä';

  @override
  String get hidden => 'Piilossa';

  @override
  String get speed => 'Nopeus';

  @override
  String get reset => 'Nollaa';

  @override
  String get apply => 'Käytä';

  @override
  String get portrait => 'Pysty';

  @override
  String get landscape => 'Vaaka';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Ruudukon poikittaisakselien lukumäärä';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Rivikohtaisesti käytettävien ruudukkolaattojen määrä, kun $value.';
  }

  @override
  String get showTextOnGridView => 'Näytä teksti ruudukkonäkymässä';

  @override
  String get showTextOnGridViewSubtitle =>
      'Näytetäänkö teksti (nimi, artisti jne.) ruudukon musiikkinäytöllä vai ei.';

  @override
  String get useCoverAsBackground => 'Käytä sumennettua kansikuvaa taustana';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Käytetäänkö sumennettua albumin kansikuvaa sovelluksen eri osioiden taustakuvana.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Albumin kansikuvan minimimarginaalit';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Albumin kansikuvan minimimarginaalit soittimen reunoilla, prosenttiyksiköissä näytön leveydestä.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Piilota kappaleen artistit, jos samat kuin albumin artistit';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Näytetäänkö kappaleiden artistit albumin näytöllä, jos ne eivät poikkea albumin artisteista.';

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
  String get disableGesture => 'Poista eleet käytöstä';

  @override
  String get disableGestureSubtitle => 'Poistaa eleet käytöstä.';

  @override
  String get showFastScroller => 'Näytä nopea vieritin';

  @override
  String get theme => 'Teema';

  @override
  String get system => 'Järjestelmä';

  @override
  String get light => 'Vaalea';

  @override
  String get dark => 'Tumma';

  @override
  String get tabs => 'Välilehdet';

  @override
  String get playerScreen => 'Musiikkisoitin';

  @override
  String get cancelSleepTimer => 'Peruuta uniajastin?';

  @override
  String get yesButtonLabel => 'Kyllä';

  @override
  String get noButtonLabel => 'Ei';

  @override
  String get setSleepTimer => 'Aseta uniajastin';

  @override
  String get hours => 'Tuntia';

  @override
  String get seconds => 'Sekuntia';

  @override
  String get minutes => 'Minuuttia';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime kokonaisajasta $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return '$currentTrackIndex. kappale $totalTrackCount kappaleesta';
  }

  @override
  String get invalidNumber => 'Virheellinen numero';

  @override
  String get sleepTimerTooltip => 'Uniajastin';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Nukahtaa $time minuutissa';
  }

  @override
  String get addToPlaylistTooltip => 'Lisää soittolistalle';

  @override
  String get addToPlaylistTitle => 'Lisää soittolistalle';

  @override
  String get addToMorePlaylistsTooltip => 'Lisää muille soittolistoille';

  @override
  String get addToMorePlaylistsTitle => 'Lisää muille soittolistoille';

  @override
  String get removeFromPlaylistTooltip => 'Poista tältä soittolistalta';

  @override
  String get removeFromPlaylistTitle => 'Poista tältä soittolistalta';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Poista soittolistalta \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Poista Soittolistalta \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Uusi soittolista';

  @override
  String get createButtonLabel => 'Luo';

  @override
  String get playlistCreated => 'Soittolista on luotu.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Napauta lisätäksesi soittolistalle. Vaihda suosikkia painamalla pitkään.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Ei albumia';

  @override
  String get noItem => 'Ei kohdetta';

  @override
  String get noArtist => 'Ei Artistia';

  @override
  String get unknownArtist => 'Tuntematon artisti';

  @override
  String get unknownAlbum => 'Tuntematon albumi';

  @override
  String get playbackModeDirectPlaying => 'Suoratoisto';

  @override
  String get playbackModeTranscoding => 'Transkoodaus';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Toistaa paikallisesti';

  @override
  String get queue => 'Jono';

  @override
  String get addToQueue => 'Lisää jonoon';

  @override
  String get replaceQueue => 'Korvaa Jono';

  @override
  String get instantMix => 'Välitön sekoitus';

  @override
  String get goToAlbum => 'Mene albumiin';

  @override
  String get goToArtist => 'Mene artistiin';

  @override
  String get goToGenre => 'Mene tyylilajiin';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Lisätty suosikiksi';

  @override
  String get confirmFavoriteRemoved => 'Poistettu suosikeista';

  @override
  String get addedToQueue => 'Lisätty jonoon.';

  @override
  String get insertedIntoQueue => 'Asetettu jonoon.';

  @override
  String get queueReplaced => 'Jono korvattu.';

  @override
  String get confirmAddedToPlaylist => 'Lisätty soittolistaan.';

  @override
  String get removedFromPlaylist => 'Poistettu soittolistalta.';

  @override
  String get startingInstantMix => 'Käynnistetään välitön sekoitus.';

  @override
  String get anErrorHasOccured => 'Tapahtui virhe.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Tilakoodi $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Tilakoodi $statusCode. Tämä tarkoittaa todennäköisesti, että olet käyttänyt väärää käyttäjätunnusta/salasanaa tai että sovellus ei ole enää kirjautuneena sisään.';
  }

  @override
  String get removeFromMix => 'Poista Sekoituksesta';

  @override
  String get addToMix => 'Lisää Sekoitukseen';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uudelleenladattu $count kohdetta',
      one: 'Uudelleenladattu $count kohde',
      zero: 'Ei tarvitse ladata uudelleen.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Puskurin kesto';

  @override
  String get bufferDurationSubtitle =>
      'Maksimiaika, joka soittimen pitäisi puskuroida, sekunteina. Vaatii uudelleenkäynnistyksen.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Älä rajoita puskurin kokoa';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Poistaa käytöstä puskurin koon rajan. Puskuri ladataan aina määriteltyyn kokoonsa, myös erittäin suurilla tiedostoilla. Tämä voi aiheuttaa ohjelman epävakautta. Vaatii uudelleenkäynnistyksen.';

  @override
  String get bufferSizeTitle => 'Puskurin koko';

  @override
  String get bufferSizeSubtitle =>
      'Puskurin maksimikoko megatavuissa (Mt). Vaatii uudelleenkäynnistyksen';

  @override
  String get language => 'Kieli';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Siirry alkuun tai edelliseen kappaleeseen';

  @override
  String get skipToNextTrackButtonTooltip => 'Siirry seuraavaan kappaleeseen';

  @override
  String get togglePlaybackButtonTooltip => 'Toista / pysäytä';

  @override
  String get previousTracks => 'Edeltävät kappaleet';

  @override
  String get nextUp => 'Seuraavaksi';

  @override
  String get clearNextUp => 'Tyhjennä Seuraavaksi-jono';

  @override
  String get stopAndClearQueue => 'Stop playback and clear queue';

  @override
  String get playingFrom => 'Toistetaan';

  @override
  String get playNext => 'Toista seuraavaksi';

  @override
  String get addToNextUp => 'Lisää Seuraavaksi-jonoon';

  @override
  String get shuffleNext => 'Sekoita Seuraavaksi-jonoksi';

  @override
  String get shuffleToNextUp => 'Sekoita Seuraavaksi-jonoon';

  @override
  String get shuffleToQueue => 'Sekotia jonoon';

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
    return '$_temp0 toistetaan seuraavaksi';
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
    return 'Lisätty $_temp0 Seuraavaksi-jonoon';
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
    return 'Lisätty $_temp0 jonoon';
  }

  @override
  String get confirmShuffleNext => 'Sekoitetaan seuraavaksi';

  @override
  String get confirmShuffleToNextUp => 'Sekoitettu Seuraavaksi-jonoon';

  @override
  String get confirmShuffleToQueue => 'Sekoitettu jonoon';

  @override
  String get placeholderSource => 'Jostain';

  @override
  String get playbackHistory => 'Toistohistoria';

  @override
  String get shareOfflineListens => 'Jaa offline kuuntelut';

  @override
  String get yourLikes => 'Tykkäyksesi';

  @override
  String mix(String mixSource) {
    return '$mixSource - Sekoitus';
  }

  @override
  String get tracksFormerNextUp => 'Kappaleet lisätty Seuraavaksi-jonosta';

  @override
  String get savedQueue => 'Tallennettu jono';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'Albumi',
        'playlist': 'Soittolista',
        'trackMix': 'Kappalemix',
        'artistMix': 'Artistimix',
        'albumMix': 'Albumimix',
        'genreMix': 'Genre Mix',
        'favorites': 'Suosikit',
        'allTracks': 'Kaikki raidat',
        'filteredList': 'Kappaleet',
        'genre': 'Genre',
        'artist': 'Artisti',
        'track': 'Raita',
        'nextUpAlbum': 'Seuraavaksi-Albumi',
        'nextUpPlaylist': ' Seuraavaksi-Soittolista',
        'nextUpArtist': 'Seuraavaksi-Artisti',
        'remoteClient': 'Etäohjauslaite',
        'other': '',
      },
    );
    return 'Toistetaan lähteestä $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Sekoita Kaikki';

  @override
  String get playbackOrderLinearButtonLabel => 'Toistetaan järjestyksessä';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Toistetaan järjestyksessä. Napauta sekoittaaksesi.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Sekoitetaan kappaleita';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Sekoitetaan kappaleet. Napauta toistaaksesi järjestyksessä.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Toistetaan nopeudella ${speed}x';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return '${speed}x nopeus';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% äänenvoimakkuus';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Vähennä toistonopeutta';

  @override
  String get playbackSpeedIncreaseLabel => 'Lisää toistonopeutta';

  @override
  String get loopModeNoneButtonLabel => 'Ei jatkuvaa toistoa';

  @override
  String get loopModeOneButtonLabel => 'Kappale jatkuvalla toistolla';

  @override
  String get loopModeAllButtonLabel => 'Jatkuva toisto';

  @override
  String get queuesScreen => 'Palauta toistojono';

  @override
  String get queueRestoreButtonLabel => 'Palauta';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Tallennettu $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Toistetaan: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kappaletta',
      one: '1 Kappale',
    );
    return '$_temp0, $remaining Toistamatta';
  }

  @override
  String get queueLoadingMessage => 'Palautetaan jonoa…';

  @override
  String get queueRetryMessage =>
      'Jonon palautus epäonnistui. Yritä uudelleen?';

  @override
  String get autoloadLastQueueOnStartup =>
      'Palauta viimeisin jono automaattisesti';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Yritä palauttaa viimeisin jono automaattisesti ohjelman käynnistyessä.';

  @override
  String get reportQueueToServer => 'Raportoi nykyinen jono palvelimelle?';

  @override
  String get reportQueueToServerSubtitle =>
      'Kun valittu, Finamp lähettää nykyisen jonon palvelimelle. Tämä voi parantaa kauko-ohjausta ja sallii jonon palauttamisen palvelimen puolella. Aina päällä, kun \'Toista laitteella\'-ominaisuus on käytössä.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Toistoistunnon päivitystiheys';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'Kuinka usein palvelimelle lähetetään nykyisen toistoistunnon tila, sekunneissa. Tämän pitäisi olla vähemmän kuin 5 minuuttia (300 sekuntia), jotta sessiota ei aikakatkaista.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'Jos Jellyfin palvelin ei ole saanut yhtäkään päivitystä liitetyltä laitteelta viimeiseen 5 minuuttiin, palvelin olettaa toiston loppuneeksi. Tämä tarkoittaa, että kappaleille, jotka ovat yli 5 minuuttia pitkiä, toisto voidaan virheellisesti raportoida loppuneeksi, mikä vähentää toistoraporttien datan laatua.';

  @override
  String get playOnStaleDelay => '\'Toista laitteella\'-istunnon aikakatkaisu';

  @override
  String get playOnStaleDelaySubtitle =>
      'Kuinka kauan \'Toista laitteella\'-istunto katsotaan aktiiviseksi komennon vastaanottamisen jälkeen. Aktiivisessa tilassa toisto raportoidaan useammin, mikä voi johtaa suurempaan kaistan käyttöön.';

  @override
  String get enablePlayonTitle => 'Kytke \'Toista laitteella\'-tuki päälle';

  @override
  String get enablePlayonSubtitle =>
      'Kytkee Jellyfinin \'Toista laitteella\'-ominaisuuden päälle. (Finampin etäohjaus toisella laitteella). Poista käytöstä, jos käänteinen välityspalvelin tai palvelin ei tue WebSocketteja.';

  @override
  String get playOnReconnectionDelay =>
      '\'Toista laitteella\'-istunnon uudelleenyhdistämisen viive';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Säätää uudelleenyhdistämisyritysten välistä viivettä (sekunneissa), kun yhteys \'Toista laitteella\'- websocketiin katkeaa. Matalampi viive lisää kaistan käyttöä.';

  @override
  String get topTracks => 'Parhaat kappaleet';

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
      other: '$count Albumia',
      one: '$count Albumi',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Sekoita albumit';

  @override
  String get shuffleAlbumsNext => 'Sekoita albumit Seuraavaksi-jonoksi';

  @override
  String get shuffleAlbumsToNextUp => 'Sekoita albumit Seuraavaksi-jonoon';

  @override
  String get shuffleAlbumsToQueue => 'Sekoita albumit jonoon';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount toistoa',
      one: '$playCount toisto',
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
    return 'Kohteen lataus epäonnistui: $_temp0';
  }

  @override
  String get confirm => 'Vahvista';

  @override
  String get close => 'Sulje';

  @override
  String get showUncensoredLogMessage =>
      'Tämä loki sisältää kirjautumistietosi. Näytä?';

  @override
  String get resetTabs => 'Nollaa välilehdet';

  @override
  String get resetToDefaults => 'Nollaa oletukseen';

  @override
  String get noMusicLibrariesTitle => 'Ei musiikkikirjastoja';

  @override
  String get noMusicLibrariesBody =>
      'Finamp ei löytänyt musiikkikirjastoja. Varmista, että Jellyfin-palvelimellasi on vähintään yksi kirjasto, jonka sisältötyypiksi on asetettu \"Musiikki\".';

  @override
  String get refresh => 'Virkistä';

  @override
  String get moreInfo => 'Lisätietoja';

  @override
  String get volumeNormalizationSettingsTitle =>
      'Äänenvoimakkuuden normalisointi';

  @override
  String get playbackReportingSettingsTitle =>
      'Toiston raportointi & Toista laitteella';

  @override
  String get volumeNormalizationSwitchTitle =>
      'Ota volyymitason normalisointi käyttöön';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Käyttää kappaleen vahvistustietoja (gain) normalisoidakseen kappaleiden äänekkyystason';

  @override
  String get volumeNormalizationModeSelectorTitle =>
      'Volyymitason normalisoinnin tila';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'Miloin ja miten käytetään volyymitason normalisointia';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Hybridi (Kappale + Albumi):\nKappalevahvistusta käytetään normaalissa toistossa, mutta albumia toistaessa (jos jono on toison päälähde, tai albumi lisättiin jonoon jossain vaiheessa), albumivahvistusta käytetään.\n\nKappale-pohjainen:\nKappalevahvistusta käytetään aina, välittämättä soiko albumi vai ei.\n\nVain albumit:\nVolyymitason normalisointia käytetään vain, kun albumia toistetaan (käyttäen albumivahvistusta), mutta ei yksittäisten kappaleiden toistossa.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybridi (Kappale + Albumi)';

  @override
  String get volumeNormalizationModeTrackBased => 'Kappale-pohjainen';

  @override
  String get volumeNormalizationModeAlbumBased => 'Albumi-pohjainen';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Vain albumeille';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Perusvahvistus';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Tällä hetkellä, volyymitason normalisointi iOS-laitteilla vaatii toistovolyymin muutoksen emuloidakseen vahvistuksen muutosta. Koska ohjelma ei voi lisätä volyymiä yli 100 prosentin, täytyy volyymiä alentaa oletuksena, jotta tarvittaessa normalisointi voi vahvistaa hiljaisia kappaleita tarpeeksi. Arvot ovat desibeleissä (dB), missä -10 dB on noin ~30% volyymistä, -4.5 dB on noin ~60% volyymistä ja -2dB on noin ~80% täydestä volyymistä.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Toista pyyhkäisty kappale seuraavaksi';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Mahdollistaa kappaleluettelossa kappaleen lisäämisen pyyhkäisemällä jonon seuraavaksi kohteeksi sen sijaan, että se lisättäisiin johon hännille.';

  @override
  String get swipeLeftToRightAction => 'Oikealle pyyhkäisyn toiminto';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Toiminto joka suoritetaan pyyhkäistessä kappaletta luettelossa vasemmalta oikealle.';

  @override
  String get swipeRightToLeftAction => 'Vasemmalle pyyhkäisyn toiminto';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Toiminto joka suoritetaan pyyhkäistessä kappaletta luettelossa oikealta vasemmalle.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Aloita Välitön Sekoitus yksittäisille kappaleille';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'Kun käytössä, kappaleen napautus kappaleiden välilehdessä aloittaa välittömän sekoituksen napautetusta kappaleesta yksittäisen kappaleen toiston sijaan.';

  @override
  String get downloadItem => 'Lataa';

  @override
  String get repairComplete => 'Latausten korjaus valmis.';

  @override
  String get syncComplete => 'Kaikki latauksen uudelleen synkronoitu.';

  @override
  String get syncDownloads => 'Synkronoi ja lataa puuttuvat kohteet.';

  @override
  String get repairDownloads =>
      'Korjaa ongelmat ladatuissa tiedostoissa tai liitännästiedoissa.';

  @override
  String get requireWifiForDownloads => 'Vaadi WiFi-yhteys latauksiin.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kappaletta',
      one: '$count kappale',
    );
    return 'Varoitus: $_temp0 ei voitu palauttaa jonoon.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Suoritetaan',
        'failed': 'Epäonnistui',
        'syncFailed': 'Toistuvasti synkronoimaton',
        'enqueued': 'Jonossa',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Latauksia',
      one: 'Lataus',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Ladataanko varmasti kaikki kohteet kirjastosta \"$libraryName\"?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Näytä vain kokonaan ladatut albumit';

  @override
  String get filesystemFull =>
      'Jäljellä olevia latauksia ei voida viimeistellä. Tiedostojärjestelmä on täysi.';

  @override
  String get connectionInterrupted => 'Yhteys katkesi, lataukset keskeytetty.';

  @override
  String get connectionInterruptedBackground =>
      'Yhteys katkesi, kun lataukset olivat taustalla. Tämä voi johtua järjestelmän asetuksista.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'Yhteys katkesi, kun lataukset olivat taustalla. Tämä voi johtua käyttämällä asetusta \"Siirry matalan prioriteetin tilaan tauon aikana\" tai järjestelmän asetuksista.';

  @override
  String get activeDownloadSize => 'Ladataan…';

  @override
  String get missingDownloadSize => 'Poistetaan…';

  @override
  String get syncingDownloadSize => 'Synkronoidaan…';

  @override
  String get runRepairWarning =>
      'Palvelimeen ei saatu yhteyttä viimeistelläkseen latausten siirtoa. Suoritathan \"Korjaa lataukset\" valinnan latausnäytöstä heti, kun olet takaisin yhteydessä palvelimeen online-tilassa.';

  @override
  String get downloadSettings => 'Lataukset';

  @override
  String get showNullLibraryItemsTitle =>
      'Näytä media tuntemattomista kirjastoista.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Osa mediasta saatetaan ladata tuntemattomalla kirjastolla. Poista käytöstä piilottaaksesi nämä niiden alkuperäisen kokoelman ulkopuolelle.';

  @override
  String get maxConcurrentDownloads => 'Maksimimäärä samanaikaisia latauksia';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'Samanaikaisten latausten lisääminen voi mahdollistaa suuremman latausmäärän taustalla, mutta voi johtaa joidenkin latausten epäonnistumiseen, jos tiedostokoot ovat suuria, tai aiheuttaa aiheetonta viivästymistä ohjelmistossa.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count samanaikaista latausta';
  }

  @override
  String get downloadsWorkersSetting => 'Lataushallinnoijien määrä';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Lataushallinnoijien määrä liitännäistiedostojen ja latausten poiston synkronointiin. Lisäämällä hallinnoijien määrää voit nopeuttaa latausten synkronointia, etenkin jos palvelimen latenssi on suuri. Voi aiheuttaa viivettä toiminnoissa.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count lataushallinnoijaa';
  }

  @override
  String get syncOnStartupSwitch =>
      'Synkronoi lataukset automaattisesti ohjelman käynnistyessä';

  @override
  String get preferQuickSyncSwitch => 'Suosi pikasynkronointia';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'Kun synkronointia suoritetaan, osaa vakiona pysyvistä kohteista (kuten kappaleista tai albumeista) ei päivitetä. Latausten korjaus toteuttaa täyden synkronoinnin aina.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Albumi',
        'playlist': 'Soittolista',
        'artist': 'Artisti',
        'genre': 'Genre',
        'track': 'Kappale',
        'library': 'Kirjasto',
        'unknown': 'Kohde',
        'other': '$itemType',
      },
    );
    return '$_temp0$itemName';
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
    return 'Tämä kohde vaaditaan ladattavaksi kohteen $parentName vuoksi.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Suosikit',
        'allPlaylists': 'Kaikki soittolistat',
        'fiveLatestAlbums': '5 uusinta albumia',
        'allPlaylistsMetadata': 'Soittolistojen metatiedot',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Kuvat välimuistissa kirjastolle \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle => 'Valitse transkoodauksen muoto';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Valitse tiedostomuoto, jota käytetään suoratoistettaessa transkoodattua audiota. Ei vaikuta jonossa jo oleviin kappaleisiin.';

  @override
  String get downloadTranscodeEnableTitle => 'Käytä transkoodattuja latauksia';

  @override
  String get downloadTranscodeCodecTitle => 'Valitse latausten koodekki';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Aina',
        'never': 'Ei koskaan',
        'ask': 'Kysy',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Latausten bittinopeus';

  @override
  String get downloadBitrateSubtitle =>
      'Korkeampi bittinopeus tarjoaa paremman äänenlaadun, mutta vie enemmän tallennustilaa.';

  @override
  String get transcodeHint => 'Transkoodaa?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Lataa koodekkina $codec @$bitrate$_temp0';
  }

  @override
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transkoodattuna',
      },
    );
    return '$size $codec$_temp0';
  }

  @override
  String collectionDownloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      codec,
      {
        'ORIGINAL': '',
        'other': ' $codec @ $bitrate',
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
    return 'Lataa alkuperäinen$_temp0';
  }

  @override
  String get redownloadcomplete => 'Uudelleenlatausten transkoodaus jonossa.';

  @override
  String get redownloadTitle =>
      'Uudelleenlataa transkoodaukset automaattisesti';

  @override
  String get redownloadSubtitle =>
      'Uudelleenlataa automaattisesti kappaleet, joiden oletetaan olevan eri laadulla pääkokoelman muutosten takia.';

  @override
  String get defaultDownloadLocationButton =>
      'Aseta latausten oletussijainti. Poista käytöstä valitaksesi joka latauksella erikseen.';

  @override
  String get fixedGridSizeSwitchTitle => 'Käytä vakiokoon ruudukkolaattoja';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Ruudukkolaattojen koot eivät reagoi ikkunan tai näytön koon muutokseen.';

  @override
  String get fixedGridSizeTitle => 'Ruudukkolaattojen koko';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Pieni',
        'medium': 'Keskikokoinen',
        'large': 'Iso',
        'veryLarge': 'Todella iso',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Salli jaetun näytön tila';

  @override
  String get allowSplitScreenSubtitle =>
      'Soitin näytetään muiden ohjelmien kanssa isommilla näytöillä.';

  @override
  String get enableVibration => 'Käytä värinää';

  @override
  String get enableVibrationSubtitle => 'Käytetäänkö värinää.';

  @override
  String get hideQueueButton => 'Piilota jononäppäin';

  @override
  String get hideQueueButtonSubtitle =>
      'Piilota jononäppäin soittimen näytöltä. Pyyhkäise ylös päästäksesi jonoon.';

  @override
  String get oneLineMarqueeTextButton =>
      'Vieritä pitkät otsikot automaattisesti';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Vieritä automaattisesti pitkät kappalenimet, jotka eivät mahdu näytettäväksi kahdella rivillä';

  @override
  String get marqueeOrTruncateButton =>
      'Käytä kolmea pistettä pitkille nimille';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Näytä ... pitkän nimen lopussa vierivän tekstin sijaan';

  @override
  String get hidePlayerBottomActions => 'Piilota alavalinnat';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Piilota jono- ja lyriikkanäppäimet soittimen näytöstä. Pyyhkäise ylös päästäksesi jonoon, ja vasemmalle (albumikannen alta) päästäksesi lyriikoihin, jos saatavilla.';

  @override
  String get prioritizePlayerCover => 'Priorisoi albumin kansikuva';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Priorisoi näyttämään isompi albumin kansikuva soittimen näytöllä. Ei-kriittiset ohjaukset piilotetaan herkemmin pienillä näyttökooilla.';

  @override
  String get suppressPlayerPadding => 'Peitä soittimien ohjausten marginaali';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Täysin minimoi marginaalit soittimen ohjauksen ja albumin kansikuvan välillä jos kansikuva ei ole täysikokoinen.';

  @override
  String get lockDownload => 'Säilytä aina laitteella';

  @override
  String get showArtistChipImage =>
      'Näytä artistin kuvat artistin nimen kanssa';

  @override
  String get showArtistChipImageSubtitle =>
      'Tämä vaikuttaa pienten artistin kuvien esikatseluun, kuten soittimen näytöllä.';

  @override
  String get scrollToCurrentTrack => 'Vieritä nykyiseen kappaleeseen';

  @override
  String get enableAutoScroll => 'Ota käytöön automaattinen vieritys';

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
    return '$duration jäljellä';
  }

  @override
  String get removeFromPlaylistConfirm => 'Poista';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Poista \'$itemName\' soittolistalta \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Kappalevalikko';

  @override
  String get quickActions => 'Pikatoiminnot';

  @override
  String get addRemoveFromPlaylist => 'Lisää tai poista soittolistoilta';

  @override
  String get addPlaylistSubheader => 'Lisää kappale soittolistalle';

  @override
  String get trackOfflineFavorites => 'Synkronoi kaikki suosikit';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Tämä mahdollistaa ajantasaisempien suosikkitilojen näyttämisen offline-tilassa. Ei lataa ylimääräisiä tiedostoja.';

  @override
  String get allPlaylistsInfoSetting =>
      'Lataa soittolistan liitännäistiedostot (metadata)';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Synkronoi kaikkien soittolistojen metadata parantaaksesi soittolistojen kokemusta';

  @override
  String get downloadFavoritesSetting => 'Lataa kaikki suosikit';

  @override
  String get downloadAllPlaylistsSetting => 'Lataa kaikki soittolistat';

  @override
  String get fiveLatestAlbumsSetting => 'Lataa viimeisimmät viisi albumia';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Lataukset poistetaan kun ne ikääntyvät. Lukitse lataukset estääksesi albumi poistolta.';

  @override
  String get cacheLibraryImagesSettings =>
      'Tallenna nykyisen kirjaston kuvat välimuistiin';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Kaikkien albumien, artistien, tyylilajien ja soittolistojen kansikuvat tämänhetkisessä kirjastossa ladataan.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Näytä kappaleen edistyminen sovelluksen minisoittimessa';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Näytä toiston mukaan etenevä väripalkki sovelluksen sisäisen minisoittimen / musiikkinäytön alareunassa sijaitsevan tällä hetkellä toistettavan kappaleen palkissa.';

  @override
  String get lyricsScreenButtonTitle => 'Lyriikat';

  @override
  String get lyricsScreen => 'Sanoitusnäkymä';

  @override
  String get showLyricsTimestampsTitle =>
      'Näytä aikaleimat synkronoiduissa sanoituksissa';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Näytä aikaleimat jokaiselle sanoituksen riville sanoitusnäkymässä, mikäli saatavilla.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Näytä pysäytyspainike mediailmoituksessa';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Näytä stop-näppäin pause-näppäimen lisäksi mediailmoituksissa. Mahdollistaa toiston lopettamisen ilman ohjelman avaamista.';

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
      'Näytä hakusäätimet mediailmoituksessa';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Näytä hakupalkki mediailmoituksissa. Mahdollistaa toistokohdan valinnan ilman ohjelman avaamista.';

  @override
  String get alignmentOptionStart => 'Vasen';

  @override
  String get alignmentOptionCenter => 'Keskitä';

  @override
  String get alignmentOptionEnd => 'Oikea';

  @override
  String get fontSizeOptionSmall => 'Pieni';

  @override
  String get fontSizeOptionMedium => 'Keskikokoinen';

  @override
  String get fontSizeOptionLarge => 'Suuri';

  @override
  String get lyricsAlignmentTitle => 'Sanoitusten tasaus';

  @override
  String get lyricsAlignmentSubtitle =>
      'Säätää sanoitusten tasausta sanoitusnäkymässä.';

  @override
  String get lyricsFontSizeTitle => 'Sanoitusten kirjasinkoko';

  @override
  String get lyricsFontSizeSubtitle =>
      'Säätää sanoitusten kirjasinkokoa sanoitusnäkymässä.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Näytä albumikuvitus ennen sanoituksia';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Näytä albumin kansikuva sanoitusten yläpuolella, ennen kuin se vierii pois.';

  @override
  String get keepScreenOn => 'Pidä näyttö päällä';

  @override
  String get keepScreenOnSubtitle => 'Milloin näyttö pidetään päällä';

  @override
  String get keepScreenOnDisabled => 'Pois käytöstä';

  @override
  String get keepScreenOnAlwaysOn => 'Aina päällä';

  @override
  String get keepScreenOnWhilePlaying => 'Kun toistetaan musiikkia';

  @override
  String get keepScreenOnWhileLyrics => 'Kun näytetään sanoituksia';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Pidä näyttö päällä vain, kun laite on kytketty lataukseen';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Ohita pidä näyttö päällä-asetus, jos laite on irroitettu latauksesta';

  @override
  String get genericToggleButtonTooltip => 'Napauta vaihtaaksesi.';

  @override
  String get artwork => 'Kansikuva';

  @override
  String artworkTooltip(String title) {
    return 'Kansikuva albumille/kappaleelle $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Kansikuva albumille/kappaleelle $title. Napauta kuvaa aloittaaksesi / pysäyttääksesi toisto. Pyyhkäise vasemmalle tai oikealla vaihtaaksesi kappaletta.';
  }

  @override
  String get nowPlayingBarTooltip => 'Avaa soitinnäkymä';

  @override
  String get additionalPeople => 'Tekijät';

  @override
  String get playbackMode => 'Toistotila';

  @override
  String get codec => 'Koodekki';

  @override
  String get bitRate => 'Bittinopeus';

  @override
  String get bitDepth => 'Bittisyvyys';

  @override
  String get size => 'Koko';

  @override
  String get normalizationGain => 'Vahvistus';

  @override
  String get sampleRate => 'Näytetaajuus';

  @override
  String get showFeatureChipsToggleTitle => 'Näytä kappaleen lisätiedot';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Näytä kappaleen lisätiedot kuten koodekki, bittinopeus jne. soitinnäkymässä.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Albuminäkymä';

  @override
  String get showCoversOnAlbumScreenTitle =>
      'Näytä albumin kansikuva kappaleille';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Näytä albumin kansikuva jokaiselle kappaleelle erikseen albuminäkymässä.';

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
      'Et ole kuunnellut vielä yhtäkään kappaletta tältä artistilta.';

  @override
  String get emptyFilteredListTitle => 'Kohteita ei löytynyt';

  @override
  String get emptyFilteredListSubtitle =>
      'Yhtäkään suodatinta vastaavaa kohdetta ei löytynyt. Kokeile poistaa suodatin tai vaihtaa hakutermiä.';

  @override
  String get resetFiltersButton => 'Nollaa suodattimet';

  @override
  String get resetSettingsPromptGlobal =>
      'Haluatko varmasti nollata KAIKKI asetukset oletusasetuksiin?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Nollaa KAIKKI asetukset';

  @override
  String get resetSettingsPromptLocal =>
      'Haluatko nollata nämä asetukset niiden oletuksiin?';

  @override
  String get genericCancel => 'Peruuta';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Albumi',
        'playlist': 'Soittolista',
        'artist': 'Artisti',
        'genre': 'Tyylilaji',
        'track': 'Kappale',
        'library': 'Kirjasto',
        'other': 'kohde',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'Laite',
        'server': 'Palvelin',
        'other': 'tuntematon',
      },
    );
    return '$_temp0 poistettu kohteesta $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Salli poisto palvelimelta';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Ota käyttöön tai poista käytöstä mahdollisuus poistaa kappale palvelimen tiedostojärjestelmästä, kun poisto on palvelimen asetusten puolesta mahdollista.';

  @override
  String deleteFromTargetDialogText(
      String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'albumi',
        'playlist': 'soittolista',
        'artist': 'artisti',
        'genre': 'tyylilaji',
        'track': 'kappale',
        'library': 'kirjasto',
        'other': 'kohde',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Tämä myös poistaa kohteen tältä laitteelta.',
        'cantDelete':
            ' Tämä kohde pysyy laitteella seuraavaan synkronointiin saakka.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'tämä laite',
        'server':
            'palvelimen tiedostojärjestelmä ja kirjasto.$_temp1\nTätä ei voi peruuttaa',
        'other': '',
      },
    );
    return 'Olet poistamassa kohdetta $_temp0 kohteesta $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': 'laitteelta',
        'server': 'palvelimelta',
        'other': '',
      },
    );
    return 'Poista $_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Varoitus: Olet aloittamassa $count kappaleen lataamista.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Latauksen koon varoituksen raja';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'Varoitusviesti näytetään ladattaessa kerralla suurempaa määrää kappaleita kuin tässä asetettu raja.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'albumi',
        'playlist': 'soittolista',
        'artist': 'artisti',
        'genre': 'tyylilaji',
        'other': 'kohde',
      },
    );
    return 'Haluatko varmasti lisätä kaikki kappaleet kohteesta $_temp0 \'$itemName\' tähän soittolistaan? Kappaleet voidaan poistaa vain yksitellen.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Julkisesti esillä:';

  @override
  String get releaseDateFormatYear => 'Vuosi';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Kuukausi ja vuosi';

  @override
  String get releaseDateFormatMonthDayYear => 'Kuukausi, päivä ja vuosi';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Näytä albumin julkaisupäivä soitinnäkymässä';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Näyttää albumin julkaisupäivän soitinnäkymässä, albuminimen takana.';

  @override
  String get releaseDateFormatTitle => 'Julkaisupäivän muoto';

  @override
  String get releaseDateFormatSubtitle =>
      'Ohjaa kaikkia julkaisupäivämuotoja ohjelmassa.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError =>
      'Virhe ladattaessa saatavilla olevia kirjastoja käyttäjälle';

  @override
  String get autoOfflineOptionOff => 'Pois päältä';

  @override
  String get autoOfflineOptionNetwork => 'Ei lähiverkkoa';

  @override
  String get autoOfflineOptionDisconnected => 'Ei yhteyttä';

  @override
  String get autoOfflineSettingDescription =>
      'Kytke Offline-tila automaattisesti.\nPois päältä: Ei kytke offline-tilaa automaattisesti. Voi säästää akkua.\nEi lähiverkkoa: Kytke offline-tila päälle, kun ei yhteyttä wifin tai ethernetin kautta.\nEi yhteyttä: Kytke offline-tila päälle, kun ei yhteyttä mihinkään.\nVoit aina kytkeä offline-tilan päälle käsin. Tämä kytkee offline-automaation pois päältä, kunnes taas kytket offline-tilan pois päältä.';

  @override
  String get autoOfflineSettingTitle => 'Automaattinen Offline-tila';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'kytketty päälle',
        'disabled': 'kytketty pois päältä',
        'other': 'set quantum position for',
      },
    );
    return 'Automaattinen Offline-tila $_temp0';
  }

  @override
  String get audioFadeOutDurationSettingTitle => 'Äänen uloshäivytyksen kesto';

  @override
  String get audioFadeOutDurationSettingSubtitle =>
      'Äänen uloshäivytyksen kesto millisekunneissa.';

  @override
  String get audioFadeInDurationSettingTitle => 'Äänen sisäänhäivytyksen kesto';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'Äänen sisäänhäivytyksen kesto millisekunneissa. Aseta arvoon 0 poistaaksesi sisäänhäivytys käytöstä.';

  @override
  String get outputMenuButtonTitle => 'Ulostulo';

  @override
  String get outputMenuTitle => 'Vaihda äänen ulostuloa';

  @override
  String get outputMenuVolumeSectionTitle => 'Äänenvoimakkuus';

  @override
  String get outputMenuDevicesSectionTitle => 'Saatavilla olevat laitteet';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Yhdistä laitteeseen';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Laitteen kaiutin',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Tuntematon',
      },
    );
    return '$_temp0';
  }

  @override
  String get desktopShuffleWarning =>
      'Sekoitus ei ole tällä hetkellä saatavilla sovelluksen työpöytäversiossa.';

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
