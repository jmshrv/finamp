// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Otevřený hudební přehrávač pro Jellyfin';

  @override
  String startupError(String error) {
    return 'Při spouštění aplikace se něco pokazilo. Chyba: $error\n\nNahlaste prosím problém na stránce github.com/UnicornsOnLSD/finamp společně se snímkem obrazovky této stránky. Pokud tento problém přetrvává, můžete vymazat data aplikace pro její obnovení.';
  }

  @override
  String get about => 'O aplikaci Finamp';

  @override
  String get aboutContributionPrompt => 'Vytvořeno úžasnými lidmi v jejich volném čase.\nMůžete být jedním z nich!';

  @override
  String get aboutContributionLink => 'Přispějte do Finampu na GitHubu:';

  @override
  String get aboutReleaseNotes => 'Přečtěte si informace o posledním vydání:';

  @override
  String get aboutTranslations => 'Pomozte s překladem Finampu do vašeho jazyka:';

  @override
  String get aboutThanks => 'Děkujeme za používání Finampu!';

  @override
  String get loginFlowWelcomeHeading => 'Vítejte v aplikaci';

  @override
  String get loginFlowSlogan => 'Vaše hudba, tak, jak ji chcete.';

  @override
  String get loginFlowGetStarted => 'Začínáme!';

  @override
  String get viewLogs => 'Zobrazit protokoly';

  @override
  String get changeLanguage => 'Změnit jazyk';

  @override
  String get loginFlowServerSelectionHeading => 'Připojit k Jellyfinu';

  @override
  String get back => 'Zpět';

  @override
  String get serverUrl => 'Adresa URL serveru';

  @override
  String get internalExternalIpExplanation => 'Pokud budete chtít vzdáleně přistupovat k vašemu serveru Jellyfin, budete muset použít vaši externí IP.\n\nPokud je váš server na výchozím portu HTTP (80 nebo 443), nebo výchozím portu Jellyfinu (8096), nemusíte zadávat port.\n\nPokud je adresa URL správná, měly by se pod polem níže zobrazit informace o vašem serveru.';

  @override
  String get serverUrlHint => 'např. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Nápověda k adrese serveru';

  @override
  String get emptyServerUrl => 'Adresa URL serveru nemůže být prázdná';

  @override
  String get connectingToServer => 'Připojování k serveru…';

  @override
  String get loginFlowLocalNetworkServers => 'Servery na vaší lokální síti:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Vyhledávání serverů…';

  @override
  String get loginFlowAccountSelectionHeading => 'Vyberte svůj účet';

  @override
  String get backToServerSelection => 'Zpět na výběr serverů';

  @override
  String get loginFlowNamelessUser => 'Nepojmenovaný uživatel';

  @override
  String get loginFlowCustomUser => 'Vlastní uživatel';

  @override
  String get loginFlowAuthenticationHeading => 'Přihlaste se k vašemu účtu';

  @override
  String get backToAccountSelection => 'Zpět na výběr účtů';

  @override
  String get loginFlowQuickConnectPrompt => 'Použít kód Rychlého připojení';

  @override
  String get loginFlowQuickConnectInstructions => 'Otevřete aplikaci nebo web Jellyfinu, klepněte na vaši uživatelskou ikonu a vybere Rychlé připojení.';

  @override
  String get loginFlowQuickConnectDisabled => 'Rychlé připojení je na tomto serveru zakázáno.';

  @override
  String get orDivider => 'nebo';

  @override
  String get loginFlowSelectAUser => 'Vybrat uživatele';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get usernameHint => 'Zadejte své uživatelské jméno';

  @override
  String get usernameValidationMissingUsername => 'Zadejte prosím uživatelské jméno';

  @override
  String get password => 'Heslo';

  @override
  String get passwordHint => 'Zadejte své heslo';

  @override
  String get login => 'Přihlásit se';

  @override
  String get logs => 'Protokoly';

  @override
  String get next => 'Další';

  @override
  String get selectMusicLibraries => 'Vyberte hudební knihovny';

  @override
  String get couldNotFindLibraries => 'Nebyly nalezeny žádné knihovny.';

  @override
  String get unknownName => 'Neznámý název';

  @override
  String get tracks => 'Skladby';

  @override
  String get albums => 'Alba';

  @override
  String get artists => 'Umělci';

  @override
  String get genres => 'Žánry';

  @override
  String get playlists => 'Seznamy skladeb';

  @override
  String get startMix => 'Spustit mix';

  @override
  String get startMixNoTracksArtist => 'Dlouze podržte prst na umělci pro jeho přidání nebo odebrání z tvorby mixu před jeho spuštěním';

  @override
  String get startMixNoTracksAlbum => 'Dlouze podržte prst na albu pro jeho přidání nebo odebrání z tvorby mixu před jeho spuštěním';

  @override
  String get startMixNoTracksGenre => 'Dlouze podržte prst na žánru pro jeho přidání nebo odebrání z tvorby mixu před jeho spuštěním';

  @override
  String get music => 'Hudba';

  @override
  String get clear => 'Vymazat';

  @override
  String get favourites => 'Oblíbené';

  @override
  String get shuffleAll => 'Vše náhodně';

  @override
  String get downloads => 'Stažené';

  @override
  String get settings => 'Nastavení';

  @override
  String get offlineMode => 'Režim offline';

  @override
  String get sortOrder => 'Pořadí řazení';

  @override
  String get sortBy => 'Řadit podle';

  @override
  String get title => 'Název';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Umělec alba';

  @override
  String get artist => 'Umělec';

  @override
  String get budget => 'Rozpočet';

  @override
  String get communityRating => 'Komunitní hodnocení';

  @override
  String get criticRating => 'Hodnocení kritiků';

  @override
  String get dateAdded => 'Datum přidání';

  @override
  String get datePlayed => 'Datum přehrání';

  @override
  String get playCount => 'Počet přehrání';

  @override
  String get premiereDate => 'Datum premiéry';

  @override
  String get productionYear => 'Rok produkce';

  @override
  String get name => 'Název';

  @override
  String get random => 'Náhodně';

  @override
  String get revenue => 'Výnos';

  @override
  String get runtime => 'Doba běhu';

  @override
  String get syncDownloadedPlaylists => 'Synchronizovat stažené seznamy skladeb';

  @override
  String get downloadMissingImages => 'Stáhnout chybějící obrázky';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Staženo $count chybějících obrázků',
      few: 'Staženy $count chybějící obrázky',
      one: 'Stažen $count chybějící obrázek',
      zero: 'Nenalezeny žádné chybějící obrázky',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Aktivní stahování';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stahování',
      one: '$count stahování',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount skladeb',
      few: '$trackCount skladby',
      one: '$trackCount skladba',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount obrázků',
      few: '$imageCount obrázky',
      one: '$imageCount obrázek',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: 'Synchronizace $syncCount uzlů',
      few: 'Synchronizace $syncCount uzlů',
      one: 'Synchronizace $syncCount uzlu',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nProbíhá oprava',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count dokončeno';
  }

  @override
  String dlFailed(int count) {
    return '$count selhalo';
  }

  @override
  String dlEnqueued(int count) {
    return '$count ve frontě';
  }

  @override
  String dlRunning(int count) {
    return '$count běží';
  }

  @override
  String get activeDownloadsTitle => 'Aktivní stahování';

  @override
  String get noActiveDownloads => 'Žádná aktivní stahování.';

  @override
  String get errorScreenError => 'Při načítání seznamu chyb došlo k chybě! Vytvořte prosím problém na GitHubu a vymažte data aplikace';

  @override
  String get failedToGetTrackFromDownloadId => 'Nepodařilo se získat skladbu z ID stahování';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'seznam skladeb',
        'artist': 'umělce',
        'genre': 'žánr',
        'track': 'skladbu',
        'library': 'knihovnu',
        'other': 'položku',
      },
    );
    return 'Opravdu chcete odstranit $_temp0 \'$itemName\' z tohoto zařízení?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Odstranit';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Chyba';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'Přehrát';

  @override
  String get shuffleButtonLabel => 'Náhodně';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skladeb',
      few: '$count skladby',
      one: '$count skladba',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skladeb',
      few: '$count skladby',
      one: '$count skladba',
    );
    return '$_temp0, staženo $downloads';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Staženo $count skladeb',
      few: 'Staženy $count skladby',
      one: 'Stažena $count skladba',
    );
    return '$_temp0';
  }

  @override
  String get editPlaylistNameTooltip => 'Upravit název seznamu skladeb';

  @override
  String get editPlaylistNameTitle => 'Upravit název seznamu skladeb';

  @override
  String get required => 'Vyžadováno';

  @override
  String get updateButtonLabel => 'Upravit';

  @override
  String get playlistNameUpdated => 'Název seznamu skladeb upraven.';

  @override
  String get favourite => 'Oblíbené';

  @override
  String get downloadsDeleted => 'Stažené smazány.';

  @override
  String get addDownloads => 'Přidat stahování';

  @override
  String get location => 'Umístění';

  @override
  String get confirmDownloadStarted => 'Stahování zahájeno';

  @override
  String get downloadsQueued => 'Stahování připraveno, stahování souborů';

  @override
  String get addButtonLabel => 'Přidat';

  @override
  String get shareLogs => 'Sdílet protokoly';

  @override
  String get logsCopied => 'Protokoly zkopírovány.';

  @override
  String get message => 'Zpráva';

  @override
  String get stackTrace => 'Trasování';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Licencováno pod Mozilla Public License 2.0.\nZdrojový kód je dostupný na stránce $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Překódování';

  @override
  String get downloadLocations => 'Umístění stažených';

  @override
  String get audioService => 'Služba zvuku';

  @override
  String get interactions => 'Interakce';

  @override
  String get layoutAndTheme => 'Rozložení a motiv';

  @override
  String get notAvailableInOfflineMode => 'Není dostupné v režimu offline';

  @override
  String get logOut => 'Odhlásit se';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Stažené skladby nebudou odstraněny';

  @override
  String get areYouSure => 'Opravdu?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin používá pro překódování formát AAC';

  @override
  String get enableTranscoding => 'Zapnout překódování';

  @override
  String get enableTranscodingSubtitle => 'Překóduje hudební streamy na straně serveru.';

  @override
  String get bitrate => 'Datový tok';

  @override
  String get bitrateSubtitle => 'Vyšší datový tok poskytuje vyšší kvalitu zvuku, ale zvýší využití internetu.';

  @override
  String get customLocation => 'Vlastní umístění';

  @override
  String get appDirectory => 'Adresář aplikací';

  @override
  String get addDownloadLocation => 'Přidat umístění stažených';

  @override
  String get selectDirectory => 'Vybrat adresář';

  @override
  String get unknownError => 'Neznámá chyba';

  @override
  String get pathReturnSlashErrorMessage => 'Cesty, které vracejí „/“, nelze použít';

  @override
  String get directoryMustBeEmpty => 'Adresář musí být prázdný';

  @override
  String get customLocationsBuggy => 'Vlastní umístění mohou být extrémně chybové a ve většině případů nejsou doporučeny. Umístění v systémové složce „Music“ zabraňují ukládání obalů alb z důvodu omezení systému.';

  @override
  String get enterLowPriorityStateOnPause => 'Po pozastavení vstoupit do stavu nízké priority';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Umožní odstranění notifikace při pozastavení. Také umožní systému ukončit službu.';

  @override
  String get shuffleAllTrackCount => 'Počet skladeb pro náhodné přehrávání všeho';

  @override
  String get shuffleAllTrackCountSubtitle => 'Počet skladeb, které se mají načíst při použití tlačítka náhodného přehrávání všech skladeb.';

  @override
  String get viewType => 'Typ zobrazení';

  @override
  String get viewTypeSubtitle => 'Typ zobrazení pro hudební obrazovku';

  @override
  String get list => 'Seznam';

  @override
  String get grid => 'Mřížka';

  @override
  String get customizationSettingsTitle => 'Přizpůsobení';

  @override
  String get playbackSpeedControlSetting => 'Viditelnost rychlosti přehrávání';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Zda se v nabídce na obrazovce přehrávače mají zobrazit ovládací prvky rychlosti přehrávání';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automaticky:\nFinamp se pokusí rozpoznat, zda je přehrávaná skladba podcast nebo audiokniha (její část). Za takový případ se považuje, pokud je stopa delší než $trackDuration minut, pokud je album stopy delší než $albumDuration hodin nebo pokud má stopa přiřazen alespoň jeden z těchto žánrů: $genreList\nV nabídce na obrazovce přehrávače se pak zobrazí ovládací prvky rychlosti přehrávání.\n\nZobrazené:\nOvládací prvky rychlosti přehrávání v nabídce obrazovky přehrávače budou vždy zobrazeny.\n\nSkryté:\nOvládací prvky rychlosti přehrávání v nabídce obrazovky přehrávače budou vždy skryté.';
  }

  @override
  String get automatic => 'Automaticky';

  @override
  String get shown => 'Zobrazené';

  @override
  String get hidden => 'Skryté';

  @override
  String get speed => 'Rychlost';

  @override
  String get reset => 'Resetovat';

  @override
  String get apply => 'Použít';

  @override
  String get portrait => 'Na výšku';

  @override
  String get landscape => 'Na šířku';

  @override
  String gridCrossAxisCount(String value) {
    return 'Počet položek mřížky $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Počet položek mřížky na řádek $value.';
  }

  @override
  String get showTextOnGridView => 'Zobrazit text v zobrazení v mřížce';

  @override
  String get showTextOnGridViewSubtitle => 'Zda zobrazit text (název, umělce atd.) v mřížkovém zobrazení hudební obrazovky.';

  @override
  String get useCoverAsBackground => 'Zobrazit rozmazaný obal jako pozadí přehrávače';

  @override
  String get useCoverAsBackgroundSubtitle => 'Zda použít rozmazaný obal alba jako pozadí na obrazovce přehrávače.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimální odsazení obalu alba';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimální odsazení kolem obalu alba na obrazovce přehrávače, v % šířky obrazovky.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Nezobrazovat umělce skladby, pokud je totožný s umělcem alba';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Zda zobrazit umělce skladby na obrazovce alba, pokud se neliší od umělců alba.';

  @override
  String get showArtistsTopTracks => 'Zobrazit nejlepší skladby v zobrazení umělce';

  @override
  String get showArtistsTopTracksSubtitle => 'Zda zobrazit 5 nejposlouchanějších skladeb na stránce umělce.';

  @override
  String get disableGesture => 'Zakázat gesta';

  @override
  String get disableGestureSubtitle => 'Zda zakázat gesta.';

  @override
  String get showFastScroller => 'Zobrazit rychlý posuvník';

  @override
  String get theme => 'Motiv';

  @override
  String get system => 'Systémový';

  @override
  String get light => 'Světlý';

  @override
  String get dark => 'Tmavý';

  @override
  String get tabs => 'Karty';

  @override
  String get playerScreen => 'Obrazovka přehrávače';

  @override
  String get cancelSleepTimer => 'Zrušit časovač spánku?';

  @override
  String get yesButtonLabel => 'Ano';

  @override
  String get noButtonLabel => 'Ne';

  @override
  String get setSleepTimer => 'Nastavit časovač spánku';

  @override
  String get hours => 'Hodiny';

  @override
  String get seconds => 'Sekundy';

  @override
  String get minutes => 'Minuty';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime z $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Skladba $currentTrackIndex z $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Neplatné číslo';

  @override
  String get sleepTimerTooltip => 'Časovač spánku';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Uspání za $time minut';
  }

  @override
  String get addToPlaylistTooltip => 'Přidat do seznamu skladeb';

  @override
  String get addToPlaylistTitle => 'Přidat do seznamu skladeb';

  @override
  String get addToMorePlaylistsTooltip => 'Přidat do dalších seznamů skladeb';

  @override
  String get addToMorePlaylistsTitle => 'Přidat do dalších seznamů skladeb';

  @override
  String get removeFromPlaylistTooltip => 'Odebrat z tohoto seznamu skladeb';

  @override
  String get removeFromPlaylistTitle => 'Odebrat z tohoto seznamu skladeb';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Odebrat ze seznamu skladeb „$playlistName“';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Odebrat ze seznamu skladeb „$playlistName“';
  }

  @override
  String get newPlaylist => 'Nový seznam skladeb';

  @override
  String get createButtonLabel => 'Vytvořit';

  @override
  String get playlistCreated => 'Seznam skladeb vytvořen.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Klepněte pro přidání do seznamu skladeb. Podržte pro přepnutí oblíbení.';

  @override
  String get noAlbum => 'Žádné album';

  @override
  String get noItem => 'Žádná položka';

  @override
  String get noArtist => 'Žádný umělec';

  @override
  String get unknownArtist => 'Neznámý umělec';

  @override
  String get unknownAlbum => 'Neznámé album';

  @override
  String get playbackModeDirectPlaying => 'Přímé přehrávání';

  @override
  String get playbackModeTranscoding => 'Překódování';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Lokální přehrávání';

  @override
  String get queue => 'Fronta';

  @override
  String get addToQueue => 'Přidat do fronty';

  @override
  String get replaceQueue => 'Nahradit frontu';

  @override
  String get instantMix => 'Okamžitý mix';

  @override
  String get goToAlbum => 'Přejít na album';

  @override
  String get goToArtist => 'Přejít na umělce';

  @override
  String get goToGenre => 'Přejít na žánr';

  @override
  String get removeFavourite => 'Odebrat z oblíbených';

  @override
  String get addFavourite => 'Přidat do oblíbených';

  @override
  String get confirmFavoriteAdded => 'Přidáno do oblíbených';

  @override
  String get confirmFavoriteRemoved => 'Odebráno z oblíbených';

  @override
  String get addedToQueue => 'Přidáno do fronty.';

  @override
  String get insertedIntoQueue => 'Vloženo do fronty.';

  @override
  String get queueReplaced => 'Fronta nahrazena.';

  @override
  String get confirmAddedToPlaylist => 'Přidáno do seznamu skladeb.';

  @override
  String get removedFromPlaylist => 'Odebráno ze seznamu skladeb.';

  @override
  String get startingInstantMix => 'Spouštění okamžitého mixu.';

  @override
  String get anErrorHasOccured => 'Vyskytla se chyba.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Stavový kód $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Stavový kód $statusCode. Toto nejspíše znamená, že jste použili nesprávné uživatelské jméno / heslo, nebo váš klient již není přihlášen.';
  }

  @override
  String get removeFromMix => 'Odebrat z mixu';

  @override
  String get addToMix => 'Přidat do mixu';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znovu staženo $count položek',
      few: 'Znovu staženy$count položky',
      one: 'Znovu stažena$count položka',
      zero: 'Nejsou potřeba žádná opětovná stažení.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Trvání vyrovnávací paměti';

  @override
  String get bufferDurationSubtitle => 'Maximální doba trvání, která má být uložena do vyrovnávací paměti, v sekundách. Vyžaduje restart aplikace.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Neomezovat velikost vyrovnávací paměti';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Zakáže omezení velikosti vyrovnávací paměti. Vyrovnávací paměť bude vždy načtena na nastavené trvání, i pro velmi velké soubory. Může způsobit pády. Vyžaduje restart.';

  @override
  String get bufferSizeTitle => 'Velikost vyrovnávací paměti';

  @override
  String get bufferSizeSubtitle => 'Maximální velikost vyrovnávací paměti v MB. Vyžaduje restart';

  @override
  String get language => 'Jazyk';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Přeskočit na začátek nebo na předchozí skladbu';

  @override
  String get skipToNextTrackButtonTooltip => 'Přeskočit na další skladbu';

  @override
  String get togglePlaybackButtonTooltip => 'Přepnout přehrávání';

  @override
  String get previousTracks => 'Předchozí skladby';

  @override
  String get nextUp => 'Další na řadě';

  @override
  String get clearNextUp => 'Vymazat další na řadě';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Přehrávání z';

  @override
  String get playNext => 'Přehrát jako další';

  @override
  String get addToNextUp => 'Přidat do dalších na řadě';

  @override
  String get shuffleNext => 'Zamíchat další';

  @override
  String get shuffleToNextUp => 'Zamíchat do dalších na řadě';

  @override
  String get shuffleToQueue => 'Zamíchat do fronty';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Skladba bude přehrána',
        'album': 'Album bude přehráno',
        'artist': 'Umělec bude přehrán',
        'playlist': 'Seznam skladeb bude přehrán',
        'genre': 'Žánr bude přehrán',
        'other': 'Item',
      },
    );
    return '$_temp0 jako další';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Skladba přidána',
        'album': 'Album přidáno',
        'artist': 'Umělec přidán',
        'playlist': 'Seznam skladeb přidán',
        'genre': 'Žánr přidán',
        'other': 'Položka přidána',
      },
    );
    return '$_temp0 do dalších na řadě';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Skladba přidána',
        'album': 'Album přidáno',
        'artist': 'Umělec přidán',
        'playlist': 'Seznam skladeb přidán',
        'genre': 'Žánr přidán',
        'other': 'Položka přidána',
      },
    );
    return '$_temp0 do fronty';
  }

  @override
  String get confirmShuffleNext => 'Bude zamícháno jako další';

  @override
  String get confirmShuffleToNextUp => 'Zamícháno do dalších na řadě';

  @override
  String get confirmShuffleToQueue => 'Zamícháno do fronty';

  @override
  String get placeholderSource => 'Někde';

  @override
  String get playbackHistory => 'Historie přehrávání';

  @override
  String get shareOfflineListens => 'Sdílet offline posluchače';

  @override
  String get yourLikes => 'Vaše oblíbené';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Skladby přidány přes další na řadě';

  @override
  String get savedQueue => 'Fronta uložena';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'alba',
        'playlist': 'seznamu skladeb',
        'trackMix': 'mixu skladeb',
        'artistMix': 'mixu umělců',
        'albumMix': 'mixu alb',
        'genreMix': 'mixu žánrů',
        'favorites': 'oblíbených',
        'allTracks': 'všech skladeb',
        'filteredList': 'skladeb',
        'genre': 'žánru',
        'artist': 'umělce',
        'track': 'skladby',
        'nextUpAlbum': 'alba v dalších na řadě',
        'nextUpPlaylist': 'playlistu v dalších na řadě',
        'nextUpArtist': 'umělce v dalších na řadě',
        'other': '',
      },
    );
    return 'Přehrávání z $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Zamíchat vše';

  @override
  String get playbackOrderLinearButtonLabel => 'Přehrávání v pořadí';

  @override
  String get playbackOrderLinearButtonTooltip => 'Přehrávání v pořadí. Klepněte pro zamíchání.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Míchání skladeb';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Míchání skladeb. Klepněte pro přehrání v pořadí.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Přehrávání v rychlosti x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'Rychlost x$speed';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Snížit rychlost přehrávání';

  @override
  String get playbackSpeedIncreaseLabel => 'Zvýšit rychlost přehrávání';

  @override
  String get loopModeNoneButtonLabel => 'Neopakuje se';

  @override
  String get loopModeOneButtonLabel => 'Opakování této skladby';

  @override
  String get loopModeAllButtonLabel => 'Opakování všeho';

  @override
  String get queuesScreen => 'Obnovit právě hrající';

  @override
  String get queueRestoreButtonLabel => 'Obnovit';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Uloženo $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Přehrávání: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skladeb',
      few: '$count skladby',
      one: '1 skladba',
    );
    return '$_temp0, $remaining nepřehráno';
  }

  @override
  String get queueLoadingMessage => 'Obnovování fronty…';

  @override
  String get queueRetryMessage => 'Nepodařilo se obnovit frontu. Opakovat?';

  @override
  String get autoloadLastQueueOnStartup => 'Automaticky obnovit poslední frontu';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Po spuštění aplikace se pokusit obnovit naposledy přehrávanou frontu.';

  @override
  String get reportQueueToServer => 'Nahlásit aktuální frontu serveru?';

  @override
  String get reportQueueToServerSubtitle => 'Pokud je tato možnost povolena, odešle Finamp aktuální frontu na server. Tato funkce v současné době není přiliš užitečná a zvyšuje síťový provoz.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Frekvence aktualizace relace přehrávání';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Jak často posílat aktuální stav přehrávání na server, v sekundách. Mělo by být méně než 5 minut (300 sekund) pro zabránění vypršení relace.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Pokud server Jellyfin neobdrží od klienta za posledních 5 minut žádnou aktualizaci, předpokládá, že přehrávání skončilo. To znamená, že u skladeb delších než 5 minut by mohlo být toto přehrávání nesprávně hlášeno jako ukončené, což by snižovalo kvalitu dat hlášení přehrávání.';

  @override
  String get topTracks => 'Nejlepší skladby';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alb',
      few: '$count alba',
      one: '$count album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Zamíchat alba';

  @override
  String get shuffleAlbumsNext => 'Zamíchat alba jako další';

  @override
  String get shuffleAlbumsToNextUp => 'Zamíchat alba do dalších na řadě';

  @override
  String get shuffleAlbumsToQueue => 'Zamíchat alba do fronty';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount přehrání',
      one: '$playCount přehrání',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'seznam skladeb',
        'trackMix': 'mix skladby',
        'artistMix': 'mix umělce',
        'albumMix': 'mix alba',
        'genreMix': 'mix žánru',
        'favorites': 'oblíbené',
        'allTracks': 'všechny skladby',
        'filteredList': 'skladby',
        'genre': 'žánr',
        'artist': 'umělce',
        'track': 'skladbu',
        'nextUpAlbum': 'album v dalších na řadě',
        'nextUpPlaylist': 'seznam skladeb v dalších na řadě',
        'nextUpArtist': 'umělce v dalších na řadě',
        'other': '',
      },
    );
    return 'Nepodařilo se načíst $_temp0';
  }

  @override
  String get confirm => 'Potvrdit';

  @override
  String get close => 'Zavřít';

  @override
  String get showUncensoredLogMessage => 'Tento protokol zobrazuje vaše přihlašovací informace. Chcete jej zobrazit?';

  @override
  String get resetTabs => 'Obnovit karty';

  @override
  String get resetToDefaults => 'Resetovat na výchozí hodnoty';

  @override
  String get noMusicLibrariesTitle => 'Žádné hudební knihovny';

  @override
  String get noMusicLibrariesBody => 'Finamp nenalezl žádné hudební knihovny. Ujistěte se prosím, že váš server Jellyfin obsahuje alespoň jednu knihovnu s typem obsahu nastaveným na „Hudba“.';

  @override
  String get refresh => 'Obnovit';

  @override
  String get moreInfo => 'Další informace';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalizace hlasitosti';

  @override
  String get volumeNormalizationSwitchTitle => 'Povolit normalizaci hlasitosti';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Použít informace o zesílení k normalizaci hlasitosti skladeb („Replay Gain“)';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Režim normalizace hlasitosti';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Kdy a jak použít normalizaci hlasitosti';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Hybridní (skladba + album):\nZesílení skladby bude použito pro klasické přehrávání, pokud ale hraje album (buď protože je hlavním zdrojem fronty přehrávání, nebo protože bylo v určitém bodě přidáno do fronty), bude namísto toho použito zesílení alba.\n\nPodle skladby:\nVždy bude použito zesílení skladby, nezávisle na tom, zda hraje album.\n\nPouze alba:\nNormalizace hlasitosti bude použita pouze při přehrávání alb (použitím zesílení alba), ale ne pro jednotlivé skladby.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybridní (skladba + album)';

  @override
  String get volumeNormalizationModeTrackBased => 'Podle skladby';

  @override
  String get volumeNormalizationModeAlbumBased => 'Pouze alba';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Pouze pro alba';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Základní zesílení';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Normalizace hlasitosti v systému iOS v současné době vyžaduje změnu hlasitosti přehrávání, aby se napodobila změna zesílení. Protože nemůžeme zvýšit hlasitost nad 100 %, musíme ve výchozím nastavení hlasitost snížit, abychom mohli zvýšit hlasitost tichých skladeb. Hodnota je v decibelech (dB), kde -10 dB je ~30% hlasitost, -4,5 dB je ~60% hlasitost a -2 dB je ~80% hlasitost.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Přehrát posunutou skladbu jako další';

  @override
  String get swipeInsertQueueNextSubtitle => 'Zapněte pro vložení skladby jako další položku do fronty po posunutí prstem na skladbě v seznamu skladeb, namísto jejího přiřazení na konec.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Spustit okamžité mixy pro jednotlivé skladby';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Pokud je povoleno, klepnutím na skladbu na kartě skladeb spustíte okamžitý mix této skladby, namísto přehrání pouze té, na kterou jste klepli.';

  @override
  String get downloadItem => 'Stáhnout';

  @override
  String get repairComplete => 'Oprava stažených dokončena.';

  @override
  String get syncComplete => 'Všechny stažené byly znovu synchronizovány.';

  @override
  String get syncDownloads => 'Synchronizovat a stáhnout chybějící položky.';

  @override
  String get repairDownloads => 'Opravit chyby se staženými soubory nebo metadaty.';

  @override
  String get requireWifiForDownloads => 'Stahovat pouze na Wi-Fi.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skladeb',
      few: '$count skladby',
      one: '$count skladbu',
    );
    return 'Varování: nepodařilo se obnovit $_temp0 ve frontě.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Probíhající',
        'failed': 'Selhané',
        'syncFailed': 'Opakovaně nesynchronizované',
        'enqueued': 'Do fronty zařazené',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'stahování',
      one: 'stahování',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Opravdu chcete stáhnout celý obsah knihovny „$libraryName“?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Zobrazit pouze plně stažená alba';

  @override
  String get filesystemFull => 'Zbývající stahování nelze dokončit. Souborový systém je plný.';

  @override
  String get connectionInterrupted => 'Spojení přerušeno, pozastavuji stahování.';

  @override
  String get connectionInterruptedBackground => 'Během stahování na pozadí bylo přerušeno spojení. Může to být způsobeno nastavením operačního systému.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Během stahování na pozadí bylo přerušeno spojení. Může to být způsobeno povolením možnosti „Po pozastavení vstoupit do stavu nízké priority“ nebo nastavením operačního systému.';

  @override
  String get activeDownloadSize => 'Stahování…';

  @override
  String get missingDownloadSize => 'Mazání…';

  @override
  String get syncingDownloadSize => 'Synchronizace…';

  @override
  String get runRepairWarning => 'Server se nepodařilo kontaktovat za účelem dokončení migrace stahování. Jakmile budete opět online, spusťte z obrazovky stahování příkaz „Opravit stažené“.';

  @override
  String get downloadSettings => 'Stahování';

  @override
  String get showNullLibraryItemsTitle => 'Zobrazit média s neznámou knihovnou.';

  @override
  String get showNullLibraryItemsSubtitle => 'Některá média mohla být stažena s neznámou knihovnou. Jejich vypnutím je skryjete mimo jejich původní sbírku.';

  @override
  String get maxConcurrentDownloads => 'Maximální počet souběžných stahování';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Zvýšení počtu souběžných stahování může umožnit zvýšené stahování na pozadí, ale může způsobit, že některá stahování selžou, pokud jsou velmi velká, nebo v některých případech způsobit nadměrné zpoždění.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count souběžných stahování';
  }

  @override
  String get downloadsWorkersSetting => 'Počet workerů stahování';

  @override
  String get downloadsWorkersSettingSubtitle => 'Množství workerů pro synchronizaci metadat a mazání stažených souborů. Zvýšení počtu workerů pro stahování může urychlit synchronizaci stahování a mazání, zejména při vysoké latenci serveru, ale může způsobit záseky.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count workerů stahování';
  }

  @override
  String get syncOnStartupSwitch => 'Automaticky synchronizovat stažené po spuštění';

  @override
  String get preferQuickSyncSwitch => 'Preferovat rychlou synchronizaci';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Při synchronizaci nebudou aktualizovány některé obvykle statické položky (např. skladby a alba). Oprava stažených vždy provede úplnou synchronizaci.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Seznam skladeb',
        'artist': 'Umělec',
        'genre': 'Žánr',
        'track': 'Skladba',
        'library': 'Knihovna',
        'unknown': 'Položka',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return 'Stažení této položky je vyžadováno položkou $parentName.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Oblíbené',
        'allPlaylists': 'Všechny seznamy skladeb',
        'fiveLatestAlbums': '5 posledních alb',
        'allPlaylistsMetadata': 'Metadata seznamu skladeb',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Obrázky v mezipaměti pro „$libraryName“';
  }

  @override
  String get transcodingStreamingContainerTitle => 'Vyberte kontejner překódování';

  @override
  String get transcodingStreamingContainerSubtitle => 'Vyberte kontejner segmentů k použití při streamování překódovaného zvuku. Skladby, které jsou ve frontě, nebudou ovlivněny.';

  @override
  String get downloadTranscodeEnableTitle => 'Povolit překódovaná stahování';

  @override
  String get downloadTranscodeCodecTitle => 'Vyberte formát stahování';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Vždy',
        'never': 'Nikdy',
        'ask': 'Zeptat',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Datový tok stažených';

  @override
  String get downloadBitrateSubtitle => 'Vyšší datový tok umožní lepší kvalitu zvuku za cenu vyšších požadavků na úložiště.';

  @override
  String get transcodeHint => 'Překódovat?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Stáhnout jako $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate překódováno',
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
        'other': ' jako $codec @ $bitrate',
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
    return 'Stáhnout originál$_temp0';
  }

  @override
  String get redownloadcomplete => 'Opětovné stažení překódovaných ve frontě.';

  @override
  String get redownloadTitle => 'Automaticky znovu stáhnout překódované';

  @override
  String get redownloadSubtitle => 'Automaticky znovu stáhnout skladby, které jsou očekávány v jiné kvalitě z důvodu změny nadřazené sbírky.';

  @override
  String get defaultDownloadLocationButton => 'Nastavit jako výchozí umístění stahování.  Zakažte pro výběr u každého stahování zvlášť.';

  @override
  String get fixedGridSizeSwitchTitle => 'Použít pevnou velikost dlaždic mřížky';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Velikost dlaždic mřížky nebude reagovat na velikost okna/obrazovky.';

  @override
  String get fixedGridSizeTitle => 'Velikost dlaždic mřížky';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Malá',
        'medium': 'Střední',
        'large': 'Velká',
        'veryLarge': 'Velmi velká',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Povolit režim rozdělené obrazovky';

  @override
  String get allowSplitScreenSubtitle => 'Přehrávač bude zobrazen vedle dalších obrazovek na širších displejích.';

  @override
  String get enableVibration => 'Povolit vibrace';

  @override
  String get enableVibrationSubtitle => 'Zda povolit vibrace.';

  @override
  String get hideQueueButton => 'Skrýt tlačítko fronty';

  @override
  String get hideQueueButtonSubtitle => 'Skrýt tlačítko fronty na obrazovce přehrávače. Přejeďte nahoru pro zobrazení fronty.';

  @override
  String get oneLineMarqueeTextButton => 'Automaticky posouvat dlouhé názvy';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Automaticky posouvat názvy skladeb, které jsou příliš dlouhé na zobrazení ve dvou řádcích';

  @override
  String get marqueeOrTruncateButton => 'Použít výpustku pro dlouhé názvy';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Namísto posouvajícího se textu zobrazit … na konci dlouhých názvů';

  @override
  String get hidePlayerBottomActions => 'Skrýt spodní akce';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Skrýt tlačítka fronty a textu na obrazovce přehrávače. Přejetím prstem nahoru získáte přístup k frontě, přejetím prstem doleva (pod obalem alba) zobrazíte texty písní, pokud jsou k dispozici.';

  @override
  String get prioritizePlayerCover => 'Upřednostnit obal alba';

  @override
  String get prioritizePlayerCoverSubtitle => 'Upřednostnit zobrazení většího obalu alba na obrazovce přehrávače. Nekritické ovládací prvky budou při malých velikostech obrazovky agresivněji skryty.';

  @override
  String get suppressPlayerPadding => 'Potlačit odsazení ovládání přehrávače';

  @override
  String get suppressPlayerPaddingSubtitle => 'Zminimalizuje odsazení mezi ovládáním přehrávače, pokud není obal alba v plné velikosti.';

  @override
  String get lockDownload => 'Vždy ponechat na zařízení';

  @override
  String get showArtistChipImage => 'Zobrazit obrázky umělce vedle jeho jména';

  @override
  String get showArtistChipImageSubtitle => 'Ovlivní malé náhledy obrázků umělce, například na obrazovce přehrávače.';

  @override
  String get scrollToCurrentTrack => 'Posunout na aktuální skladbu';

  @override
  String get enableAutoScroll => 'Povolit automatické posouvání';

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
    return 'Zbývá $duration';
  }

  @override
  String get removeFromPlaylistConfirm => 'Odstranit';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Odstranit „$itemName“ ze seznamu skladeb „$playlistName“?';
  }

  @override
  String get trackMenuButtonTooltip => 'Nabídka skladby';

  @override
  String get quickActions => 'Rychlé akce';

  @override
  String get addRemoveFromPlaylist => 'Přidat do / odebrat ze seznamů skladeb';

  @override
  String get addPlaylistSubheader => 'Přidat skladbu do seznamu skladeb';

  @override
  String get trackOfflineFavorites => 'Synchronizovat všechny stavy oblíbených';

  @override
  String get trackOfflineFavoritesSubtitle => 'Umožňuje zobrazení aktuálnějších stavů oblíbených, když jste offline.  Nestahuje žádné další soubory.';

  @override
  String get allPlaylistsInfoSetting => 'Stáhnout metadata seznamu skladeb';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Synchronizovat metadata všech seznamů skladeb pro zlepšení zážitku ze seznamů skladeb';

  @override
  String get downloadFavoritesSetting => 'Stáhnout všechny oblíbené';

  @override
  String get downloadAllPlaylistsSetting => 'Stáhnout všechny seznamy skladeb';

  @override
  String get fiveLatestAlbumsSetting => 'Stáhnout 5 nejnovějších alb';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Stažené soubory budou po jejich vypršení smazány.  Uzamkněte stažený soubor pro zabránění smazání alba.';

  @override
  String get cacheLibraryImagesSettings => 'Uložit aktuální obrázky knihovny do mezipaměti';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Všechny obaly alb, umělců, žánrů a seznamů skladeb v aktivní knihovně budou staženy.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Zobrazit průběh skladby v minipřehrávači v aplikaci';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Ovládá, zda bude minipřehrávač v aplikaci / lišta právě hrající skladby v dolní částy obrazovky fungovat jako lišta průběhu skladby.';

  @override
  String get lyricsScreen => 'Zobrazení textů';

  @override
  String get showLyricsTimestampsTitle => 'Zobrazit časové značky u synchronizovaných textů';

  @override
  String get showLyricsTimestampsSubtitle => 'Ovládá, zda bude u každého řádku textu v zobrazení textů zobrazena časová značka, pokud je dostupná.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Zobrazit tlačítko zastavení v oznámení médií';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Určuje, zda má oznámení médií mít kromě tlačítka pro pozastavení také tlačítko pro zastavení. To umožňuje zastavit přehrávání bez otevření aplikace.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Zobrazit ovládání posunu v oznámení médií';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Ovládá, zda má oznámení médií mít posouvatelný ukazatel průběhu. To umožňuje změnit pozici přehrávání bez otevření aplikace.';

  @override
  String get alignmentOptionStart => 'Spustit';

  @override
  String get alignmentOptionCenter => 'Střed';

  @override
  String get alignmentOptionEnd => 'Konec';

  @override
  String get fontSizeOptionSmall => 'Malé';

  @override
  String get fontSizeOptionMedium => 'Střední';

  @override
  String get fontSizeOptionLarge => 'Velké';

  @override
  String get lyricsAlignmentTitle => 'Zarovnání textů';

  @override
  String get lyricsAlignmentSubtitle => 'Ovládá zarovnání textů v zobrazení textů.';

  @override
  String get lyricsFontSizeTitle => 'Velikost písma textů';

  @override
  String get lyricsFontSizeSubtitle => 'Ovládá velikost písma v zobrazení textů.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Zobrazit album před texty';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Ovládá, zda bude zobrazen obal alba nad texty před jeho odsunutím pryč.';

  @override
  String get keepScreenOn => 'Ponechat zapnutou obrazovku';

  @override
  String get keepScreenOnSubtitle => 'Zda ponechat obrazovku zapnutou';

  @override
  String get keepScreenOnDisabled => 'Zakázáno';

  @override
  String get keepScreenOnAlwaysOn => 'Vždy zapnuta';

  @override
  String get keepScreenOnWhilePlaying => 'Při přehrávání hudby';

  @override
  String get keepScreenOnWhileLyrics => 'Při zobrazování textů';

  @override
  String get keepScreenOnWhilePluggedIn => 'Ponechat obrazovku zapnutou pouze při nabíjení';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignorovat nastavení Ponechat zapnutou obrazovku, pokud je zařízení odpojeno';

  @override
  String get genericToggleButtonTooltip => 'Klepněte pro přepnutí.';

  @override
  String get artwork => 'Obal';

  @override
  String artworkTooltip(String title) {
    return 'Obal $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Obal $title. Klepněte pro přepnutí přehrávání. Přejeďte vlevo nebo vpravo pro přepnutí skladeb.';
  }

  @override
  String get nowPlayingBarTooltip => 'Otevřít obrazovku přehrávače';

  @override
  String get additionalPeople => 'Lidé';

  @override
  String get playbackMode => 'Režim přehrávání';

  @override
  String get codec => 'Kodek';

  @override
  String get bitRate => 'Datový tok';

  @override
  String get bitDepth => 'Bitová hloubka';

  @override
  String get size => 'Velikost';

  @override
  String get normalizationGain => 'Zesílení';

  @override
  String get sampleRate => 'Vzorkovací frekvence';

  @override
  String get showFeatureChipsToggleTitle => 'Zobrazit pokročilé informace o skladbě';

  @override
  String get showFeatureChipsToggleSubtitle => 'Zobrazit na obrazovce přehrávače pokročilé informace o skladbě, jako je kodek, přenosová rychlost a další.';

  @override
  String get albumScreen => 'Obrazovka alba';

  @override
  String get showCoversOnAlbumScreenTitle => 'Zobrazit obaly alba u skladeb';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Zobrazit obaly alb odděleně u každé skladby na obrazovce alba.';

  @override
  String get emptyTopTracksList => 'Od tohoto umělce jste zatím neposlouchali žádnou skladbu.';

  @override
  String get emptyFilteredListTitle => 'Nenalezeny žádné položky';

  @override
  String get emptyFilteredListSubtitle => 'Žádné položky neodpovídají filtru. Zkuste vypnout filtr nebo změnit hledaný výraz.';

  @override
  String get resetFiltersButton => 'Resetovat filtry';

  @override
  String get resetSettingsPromptGlobal => 'Opravdu chcete resetovat VŠECHNA nastavení na jejich výchozí hodnoty?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Resetovat VŠECHNA nastavení';

  @override
  String get resetSettingsPromptLocal => 'Opravdu chcete resetovat tato nastavení na jejich výchozí hodnoty?';

  @override
  String get genericCancel => 'Zrušit';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album bylo odstraněno',
        'playlist': 'Seznam skladeb byl odstraněn',
        'artist': 'Umělec byl odstraněn',
        'genre': 'Žánr byl odstraněn',
        'track': 'Skladba byla odstraněna',
        'library': 'Knihovna byla odstraněna',
        'other': 'Předmět byl odstraněn',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'zařízení',
        'server': 'serveru',
        'other': 'neznámého místa',
      },
    );
    return '$_temp0 ze $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Povolit smazání ze serveru';

  @override
  String get allowDeleteFromServerSubtitle => 'Zapnout nebo vypnout možnost trvalého smazání skladby ze souborového systému serveru, pokud je smazání možné.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'seznam skladeb',
        'artist': 'umělce',
        'genre': 'žánr',
        'track': 'skladbu',
        'library': 'knihovnu',
        'other': 'položku',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Tímto také odstraníte tuto položku z tohoto zařízení.',
        'cantDelete': ' Tato položka zůstane na tomto zařízení do příští synchronizace.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'z tohoto zařízení',
        'server': 'ze souborového systému a knihovny serveru.$_temp1\nTato akce je nevratná',
        'other': '',
      },
    );
    return 'Chystáte se odstranit $_temp0 $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' ze zařízení',
        'server': ' ze serveru',
        'other': '',
      },
    );
    return 'Odstranit$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Varování: chystáte se stáhnout $count skladeb.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Varování o useknutí velikosti stahování';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'Během stahování více než tohoto počtu skladeb bude zobrazeno varování.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'alba',
        'playlist': 'seznamu skladeb',
        'artist': 'umělce',
        'genre': 'žánru',
        'other': 'položky',
      },
    );
    return 'Opravdu chcete přidat všechny skladby z $_temp0 \'$itemName\' do tohoto seznamu skladeb?  Odstranit je lze pouze jednotlivě.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Veřejně viditelné:';

  @override
  String get releaseDateFormatYear => 'Rok';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Měsíc a rok';

  @override
  String get releaseDateFormatMonthDayYear => 'Měsíc, den a rok';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Zobrazit datum vydání alba na obrazovce přehrávače';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Zobrazit datum vydání alba na obrazovce přehrávače, za názvem alba.';

  @override
  String get releaseDateFormatTitle => 'Formát data vydání';

  @override
  String get releaseDateFormatSubtitle => 'Ovládá formát všech dat vydání zobrazených v aplikaci.';

  @override
  String get librarySelectError => 'Error loading available libraries for user';
}
