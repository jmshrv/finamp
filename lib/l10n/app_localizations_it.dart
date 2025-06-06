// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Un player musicale open source per Jellyfin';

  @override
  String get startupErrorTitle =>
      'Qualcosa non ha funzionato durante l\'avvio dell\'app!\nDesolato per l\'inconveniente...';

  @override
  String get startupErrorCallToAction =>
      'Per favore crea una \"issue\" su github.com/jmshrv/finamp con i log(!) (usa i tasti qui sotto) e uno screenshot di questa pagina, in modo tale che possiamo sistemarla il prima possibile.';

  @override
  String get startupErrorWorkaround =>
      'Come soluzione alternativa puoi cancellare i tuoi dati dell\'app per resettare l\'app. Tieni presente che in tal caso tutte le tue impostazioni e i download saranno cancellati.';

  @override
  String get about => 'Riguardo Finamp';

  @override
  String get aboutContributionPrompt =>
      'Creato da persone fantastiche nel loro tempo libero.\nPotresti essere uno di loro!';

  @override
  String get aboutContributionLink => 'Contribuisci a Finamp su GitHub:';

  @override
  String get aboutReleaseNotes => 'Leggi le ultime note di rilascio:';

  @override
  String get aboutTranslations => 'Aiuta a tradurre Finamp nella tua lingua:';

  @override
  String get aboutThanks => 'Grazie per aver scelto di usare Finamp!';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Benvenuto su';
  }

  @override
  String get loginFlowSlogan => 'La tua musica, nel modo in cui la vuoi tu.';

  @override
  String get loginFlowGetStarted => 'Inizia da qui!';

  @override
  String get viewLogs => 'Visualizza i Log';

  @override
  String get changeLanguage => 'Cambia lingua';

  @override
  String get loginFlowServerSelectionHeading => 'Collegati a Jellyfin';

  @override
  String get back => 'Indietro';

  @override
  String get serverUrl => 'URL del Server';

  @override
  String get internalExternalIpExplanation =>
      'Se vuoi accedere al tuo server di Jellyfin da remoto devi usare il tuo IP pubblico.\n\nSe il tuo server usa una porta HTTP di default (80/443) o la porta di default di Jellyfin (8096) non è necessario specificare la porta.\n\nSe l\'URL è corretto dovresti vedere comparire qualche informazione riguardo il tuo server al di sotto della casella di testo.';

  @override
  String get serverUrlHint => 'per es.: demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Aiuto per l\'URL del Server';

  @override
  String get emptyServerUrl => 'l\'URL del Server non può essere vuoto';

  @override
  String get connectingToServer => 'Connessione al server…';

  @override
  String get loginFlowLocalNetworkServers =>
      'Server nella tua rete locale (LAN):';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Ricerca dei server…';

  @override
  String get loginFlowAccountSelectionHeading => 'Seleziona il tuo account';

  @override
  String get backToServerSelection => 'Torna alla selezione del Server';

  @override
  String get loginFlowNamelessUser => 'Utente senza nome';

  @override
  String get loginFlowCustomUser => 'Utente personalizzato';

  @override
  String get loginFlowAuthenticationHeading => 'Accedi al tuo account';

  @override
  String get backToAccountSelection => 'Indietro alla selezione dell\'account';

  @override
  String get loginFlowQuickConnectPrompt => 'Usa un codice Quick Connect';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Apri l\'app o il sito web di Jellyfin, premi sulla tua icona utente e seleziona \"Connessione Rapida\".';

  @override
  String get loginFlowQuickConnectDisabled =>
      'La Connessione Rapida è disabilitata su questo server.';

  @override
  String get orDivider => 'o';

  @override
  String get loginFlowSelectAUser => 'Seleziona un utente';

  @override
  String get username => 'Nome utente';

  @override
  String get usernameHint => 'Inserisci il tuo nome utente';

  @override
  String get usernameValidationMissingUsername =>
      'Prego inserire un nome utente';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Inserisci la tua password';

  @override
  String get login => 'Entra';

  @override
  String get logs => 'Log';

  @override
  String get next => 'Avanti';

  @override
  String get selectMusicLibraries => 'Seleziona le Librerie Musicali';

  @override
  String get couldNotFindLibraries =>
      'Non è possibile trovare alcuna libreria.';

  @override
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Nome Sconosciuto';

  @override
  String get tracks => 'Brani';

  @override
  String get albums => 'Album';

  @override
  String get appearsOnAlbums => 'Compare In';

  @override
  String get artists => 'Artisti';

  @override
  String get genres => 'Generi';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Playlist';

  @override
  String get startMix => 'Riproduco Mix';

  @override
  String get startMixNoTracksArtist =>
      'Effettua una pressione prolungata su un artista per aggiungerlo o rimuoverlo dal mix builder prima di far partire un mix';

  @override
  String get startMixNoTracksAlbum =>
      'Effettua una pressione prolungata su un album per aggiungerlo o rimuoverlo dal mix builder prima di far partire un mix';

  @override
  String get startMixNoTracksGenre =>
      'Premi a lungo su un genere per aggiungerlo o rimuoverlo dal mix builder prima di iniziare un mix';

  @override
  String get music => 'Musica';

  @override
  String get clear => 'Cancella';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Riproduci casualmente tutti';

  @override
  String get downloads => 'Download';

  @override
  String get settings => 'Impostazioni';

  @override
  String get offlineMode => 'Modailtà Offline';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get sortOrder => 'Ordinamento';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get title => 'Titolo';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Artista dell\'Album';

  @override
  String get albumArtists => 'Artisti dell\'album';

  @override
  String get performingArtists => 'Artisti interpreti';

  @override
  String get artist => 'Artista';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Valutazione della comunità';

  @override
  String get criticRating => 'Punteggio della critica';

  @override
  String get dateAdded => 'Data di Aggiunta';

  @override
  String get datePlayed => 'Data di Riproduzione';

  @override
  String get playCount => 'Conteggio Riproduzioni';

  @override
  String get premiereDate => 'Data di Rilascio';

  @override
  String get productionYear => 'Anno di Produzione';

  @override
  String get name => 'Nome';

  @override
  String get random => 'Casuale';

  @override
  String get revenue => 'Incassi';

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
  String get syncDownloadedPlaylists => 'Sincronizza playlists scaricate';

  @override
  String get downloadMissingImages => 'Scarica immagini mancanti';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scaricate $count immagini mancanti',
      one: 'Scaricata $count immagine mancante',
      zero: 'Non ho trovato alcuna immagine mancante',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Download attivi';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count download',
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
      other: '$trackCount brani',
      one: '$trackCount brano',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount immagini',
      one: '$imageCount immagine',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount nodi si stanno sincronizzando',
      one: '$syncCount nodo si sta sincronizzando',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nAl momento si sta riparando',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count finito';
  }

  @override
  String dlFailed(int count) {
    return '$count falliti';
  }

  @override
  String dlEnqueued(int count) {
    return '$count in coda';
  }

  @override
  String dlRunning(int count) {
    return '$count in riproduzione';
  }

  @override
  String get activeDownloadsTitle => 'Download attivi';

  @override
  String get noActiveDownloads => 'Nessun download attivo.';

  @override
  String get errorScreenError =>
      'Si è verificato un errore mentre tentavo di ottenere la lista degli errori! A questo punto probabilmente dovresti aprire una issue su GitHub e cancellare i dati dell\'app';

  @override
  String get failedToGetTrackFromDownloadId =>
      'Impossibile ottenere il brano dall\'ID di download';

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
    return 'Sei sicuro di voler eliminare $_temp0\'$itemName\' da questo dispositivo?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Elimina';

  @override
  String get specialDownloads => 'Download speciali';

  @override
  String get libraryDownloads => 'Download Libreria';

  @override
  String get noItemsDownloaded => 'Nessun elemento scaricato.';

  @override
  String get error => 'Errore';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'Riproduci';

  @override
  String get shuffleButtonLabel => 'Riproduci casualmente';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Brani',
      one: '$count Brano',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Brani',
      one: '$count Brano',
    );
    return '$_temp0, $downloads Scaricati';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Brani',
      one: '$count Brano',
    );
    return '$_temp0 Scaricati';
  }

  @override
  String get editPlaylistNameTooltip => 'Modifica il nome della playlist';

  @override
  String get editPlaylistNameTitle => 'Modifica il Nome della Playlist';

  @override
  String get required => 'Richiesto';

  @override
  String get updateButtonLabel => 'Aggiornamento';

  @override
  String get playlistUpdated => 'Playlist nome aggiornato.';

  @override
  String get downloadsDeleted => 'Download cancellati.';

  @override
  String get addDownloads => 'Aggiungi Download';

  @override
  String get location => 'Posizione';

  @override
  String get confirmDownloadStarted => 'Download iniziato';

  @override
  String get downloadsQueued => 'Download preparato, scarico i file';

  @override
  String get addButtonLabel => 'Aggiungi';

  @override
  String get shareLogs => 'Condividi i log';

  @override
  String get exportLogs => 'Salva i log';

  @override
  String get logsCopied => 'Log copiati.';

  @override
  String get message => 'Messaggio';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Concesso in licenza con \"Mozilla Public License 2.0\".\nCodice sorgente disponibile su: $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transcodifica';

  @override
  String get downloadLocations => 'Cartella di Download';

  @override
  String get audioService => 'Servizio Audio';

  @override
  String get playbackReporting => 'Report riproduzione';

  @override
  String get interactions => 'Interazioni';

  @override
  String get layoutAndTheme => 'Aspetto & Temi';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Non disponibile in modalità offline';

  @override
  String get logOut => 'Disconnetti';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'I brani scaricati non saranno cancellati';

  @override
  String get areYouSure => 'Sei sicuro?';

  @override
  String get enableTranscoding => 'Attiva Transcodifica';

  @override
  String get enableTranscodingSubtitle =>
      'Transcodifica I flussi di musica dal lato server.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle =>
      'Un bitrate più alto permette di avere una qualità audio più alta al costo di un più alto consumo della connessione dati. Non si applica ai codec lossless, es. FLAC';

  @override
  String get customLocation => 'Posizione Personalizzata';

  @override
  String get appDirectory => 'Cartella dell\'App';

  @override
  String get addDownloadLocation => 'Aggiungi la posizione per i Download';

  @override
  String get selectDirectory => 'Seleziona Cartella';

  @override
  String get unknownError => 'Errore Sconosciuto';

  @override
  String get pathReturnSlashErrorMessage =>
      'Non possono essere usati percorsi che terminano con \"/\"';

  @override
  String get directoryMustBeEmpty => 'La cartella deve essere vuota';

  @override
  String get customLocationsBuggy =>
      'Le posizioni personalizzate possono essere estremamente instabili e sono sconsigliate nella maggior parte dei casi. Posizioni all\'interno della cartella di sistema \"Musica\" impediscono il salvataggio delle cover degli album a causa delle limitazioni del sistema operativo.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Entra nello Stato a Bassa-Priorità quando in Pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permette di scartare una notifica quando la riproduzione è in pausa. Inoltre consente ad Android di terminare il servizio quando la riproduzione è in pausa.';

  @override
  String get shuffleAllTrackCount =>
      'Riproduci Casualmente Tutti i Brani Conteggiati';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Numero di brani da mettere in coda quando si usa il tasto per la riproduzione casuale di tutti i brani.';

  @override
  String get viewType => 'Modalità di Visualizzazione';

  @override
  String get viewTypeSubtitle =>
      'Modalità di visualizzazione per la schermata musica';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Griglia';

  @override
  String get customizationSettingsTitle => 'Personalizzazione';

  @override
  String get playbackSpeedControlSetting =>
      'Visibilità della Velocità di riproduzione';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Se i controlli della velocità di riproduzione vengono visualizzati nel menu della schermata del lettore';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Automatico:\nFinamp cerca di riconoscere se il brano che stai riproducendo è un podcast o un audiolibro (o parte di esso). Ciò si verifica se il brano è più lungo di $trackDuration minuti, se la durata totale dell\'album del brano è più lunga di $albumDuration ore, o se il brano rientra in almeno uno dei seguenti generi: $genreList\nI controlli della Velocità di riproduzione saranno allora mostrati nel menu della schermata del lettore.\n\nVisibile:\nI controlli della Velocità di riproduzione nel menu della schermata del lettore sono sempre visibili.\n\nNascosto:\nI controlli della Velocità di riproduzione nel menu della schermata del lettore sono sempre nascosti.';
  }

  @override
  String get automatic => 'Automatica';

  @override
  String get shown => 'Mostra sempre';

  @override
  String get hidden => 'Nascondi sempre';

  @override
  String get speed => 'Velocità';

  @override
  String get reset => 'Resetta';

  @override
  String get apply => 'Applica';

  @override
  String get portrait => 'Visualizzazione verticale';

  @override
  String get landscape => 'Visualizzazione orizzontale';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Numero di Colonne nella Vista a griglia';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Numero di colonne da usare per ciascuna riga quando $value.';
  }

  @override
  String get showTextOnGridView => 'Mostra testo nella vista a griglia';

  @override
  String get showTextOnGridViewSubtitle =>
      'Mostrare il testo (titolo, artista, etc.) nella Vista a griglia della schermata della musica.';

  @override
  String get useCoverAsBackground =>
      'Mostra le copertine sfocate quando il player è in background';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Usare o meno cover sfocate come sfondo nella schermata di riproduzione.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Spaziatura minima della cover dell\'album';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Spaziatura minima intorno alla cover dell\'album nella visualizzazione del player, in % della larghezza dello schermo.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Nascondi gli artisti del brano se uguali agli artisti dell\'album';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Se mostrare gli artisti del brano nella visualizzazione album nel caso coincidano con gli artisti dell\'album.';

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
  String get disableGesture => 'Disabilita gesti';

  @override
  String get disableGestureSubtitle => 'Se vuoi disabilitare i gesti.';

  @override
  String get showFastScroller => 'Mostra lo scorrimento veloce';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get tabs => 'Schede';

  @override
  String get playerScreen => 'Schermata di riproduzione';

  @override
  String get cancelSleepTimer => 'Cancellare il Timer di spegnimento?';

  @override
  String get yesButtonLabel => 'Si';

  @override
  String get noButtonLabel => 'No';

  @override
  String get setSleepTimer => 'Imposta Timer di Spegnimento';

  @override
  String get hours => 'Ore';

  @override
  String get seconds => 'Secondi';

  @override
  String get minutes => 'Minuti';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime di $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Brano $currentTrackIndex di $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Numero non valido';

  @override
  String get sleepTimerTooltip => 'Timer di spegnimento';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Spegnimento in $time minuti';
  }

  @override
  String get addToPlaylistTooltip => 'Aggiungi alla playlist';

  @override
  String get addToPlaylistTitle => 'Aggiungi alla Playlist';

  @override
  String get addToMorePlaylistsTooltip => 'Aggiungi a più playlist';

  @override
  String get addToMorePlaylistsTitle => 'Aggiungi a Più Playlist';

  @override
  String get removeFromPlaylistTooltip => 'Rimuovi da questa playlist';

  @override
  String get removeFromPlaylistTitle => 'Rimuovi da Questa Playlist';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Rimuovi dalla playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Rimuovi dalla Playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nuova Playlist';

  @override
  String get createButtonLabel => 'Crea';

  @override
  String get playlistCreated => 'Playlist creata.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Premi per aggiungere alla playlist. Premi a lungo per aggiungere/rimuovere dai favoriti.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Nessun Album';

  @override
  String get noItem => 'Nessun Oggetto';

  @override
  String get noArtist => 'Nessun Artista';

  @override
  String get unknownArtist => 'Artista Sconosciuto';

  @override
  String get unknownAlbum => 'Album Sconosciuto';

  @override
  String get playbackModeDirectPlaying => 'Riproduzione diretta';

  @override
  String get playbackModeTranscoding => 'Transcodifica';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Riproduzione locale';

  @override
  String get queue => 'Coda';

  @override
  String get addToQueue => 'Aggiungi alla Coda';

  @override
  String get replaceQueue => 'Sostituisci Coda';

  @override
  String get instantMix => 'Mix Istantaneo';

  @override
  String get goToAlbum => 'Vai all\'Album';

  @override
  String get goToArtist => 'Vai ad Artista';

  @override
  String get goToGenre => 'Vai a Genere';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Aggiunto ai Favoriti';

  @override
  String get confirmFavoriteRemoved => 'Rimosso dai Favoriti';

  @override
  String get addedToQueue => 'Aggiunto alla coda.';

  @override
  String get insertedIntoQueue => 'Inserito nella coda.';

  @override
  String get queueReplaced => 'Coda sostituita.';

  @override
  String get confirmAddedToPlaylist => 'Aggiunto alla playlist.';

  @override
  String get removedFromPlaylist => 'Rimosso dalla playlist.';

  @override
  String get startingInstantMix => 'Riproduco un mix istantaneo.';

  @override
  String get anErrorHasOccured => 'Si è verificato un errore.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Codice errore $statusCode. Questo probabilmente significa che hai usato username/password errati, o il tuo client non è più autenticato.';
  }

  @override
  String get removeFromMix => 'Rimuovi dal Mix';

  @override
  String get addToMix => 'Aggiungi al Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Riscaricati $count oggetti',
      one: 'Riscaricato $count oggetto',
      zero: 'Non è necessario riscaricare nulla.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Durata Buffer';

  @override
  String get bufferDurationSubtitle =>
      'La durata massima che deve essere bufferizzata. Richiede il riavvio.';

  @override
  String get bufferDisableSizeConstraintsTitle =>
      'Non limitare la dimensione del buffer';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Disattiva i vincoli sulla dimensione del buffer (\"Buffer Size\"). Il buffer verrà sempre caricato fino alla durata configurata (\"Buffer Duration\"), anche per file di grandi dimensioni. Può causare arresti anomali. Richiede un riavvio.';

  @override
  String get bufferSizeTitle => 'Dimensione del buffer';

  @override
  String get bufferSizeSubtitle =>
      'La dimensione massima del buffer, in MB. Richiede un riavvio';

  @override
  String get language => 'Lingua';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Torna all\'inizio o al brano precedente';

  @override
  String get skipToNextTrackButtonTooltip => 'Vai al brano successivo';

  @override
  String get togglePlaybackButtonTooltip => 'Avvia/Ferma la riproduzione';

  @override
  String get previousTracks => 'Brani precedenti';

  @override
  String get nextUp => 'In Coda';

  @override
  String get clearNextUp => 'Svuota la Coda';

  @override
  String get stopAndClearQueue => 'Stop playback and clear queue';

  @override
  String get playingFrom => 'In riproduzione da';

  @override
  String get playNext => 'Riproduci come successivo';

  @override
  String get addToNextUp => 'Aggiungi alla fine della coda A Seguire';

  @override
  String get shuffleNext =>
      'Riproduci casualmente come successivo nella coda A Seguire';

  @override
  String get shuffleToNextUp =>
      'Riproduci casualmente alla fine della coda A Seguire';

  @override
  String get shuffleToQueue => 'Riproduci casualmente alla fine della coda';

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
    return '$_temp0 sarà riprodotto subito dopo';
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
    return 'Aggiunto $_temp0 alla coda A Seguire';
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
    return 'Aggiunto $_temp0 alla coda';
  }

  @override
  String get confirmShuffleNext =>
      'Sarà riprodotto casualmente subito dopo nella coda A Seguire';

  @override
  String get confirmShuffleToNextUp =>
      'Sarà riprodotto casualmente alla fine della coda A Seguire';

  @override
  String get confirmShuffleToQueue =>
      'Sarà riprodotto casualmente alla fine della coda';

  @override
  String get placeholderSource => 'Da qualche parte';

  @override
  String get playbackHistory => 'Cronologia di riproduzione';

  @override
  String get shareOfflineListens =>
      'Condividi offline i conteggi di riproduzione';

  @override
  String get yourLikes => 'I tuoi Like';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Brani aggiunti nella coda A Seguire';

  @override
  String get savedQueue => 'Coda salvata';

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
    return 'Riproduzione da $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Riproduci casualmente Tutti';

  @override
  String get playbackOrderLinearButtonLabel => 'Riproduci in ordine';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Riproduco in ordine. Premi per riprodurre casualmente.';

  @override
  String get playbackOrderShuffledButtonLabel =>
      'Riproduco casualmente i brani';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Riproduco casualmente i brani. Premi per riprodurre in ordine.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Riproduco ad una velocità ${speed}x';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'velocità ${speed}x';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return 'volume $volume%';
  }

  @override
  String get playbackSpeedDecreaseLabel =>
      'Diminuisci velocità di riproduzione';

  @override
  String get playbackSpeedIncreaseLabel => 'Aumenta velocità di riproduzione';

  @override
  String get loopModeNoneButtonLabel => 'Riproduzione non in loop';

  @override
  String get loopModeOneButtonLabel => 'Riproduco questo brano in loop';

  @override
  String get loopModeAllButtonLabel => 'Riproduco in loop tutto';

  @override
  String get queuesScreen => 'Ripristina Ora in riproduzione';

  @override
  String get queueRestoreButtonLabel => 'Ripristina';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Salvato $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'In riproduzione: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Brani',
      one: '1 Brano',
    );
    return '$_temp0, $remaining Non riprodotti';
  }

  @override
  String get queueLoadingMessage => 'Ripristino la coda…';

  @override
  String get queueRetryMessage =>
      'Impossibile ripristinare la coda. Ritentare?';

  @override
  String get autoloadLastQueueOnStartup =>
      'Ripristino automaticamente l\'ultima coda';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'All\'avvio dell\'app, prova a ripristinare l\'ultima coda riprodotta.';

  @override
  String get reportQueueToServer => 'Inoltrare la coda corrente al server?';

  @override
  String get reportQueueToServerSubtitle =>
      'Se abilitato, Finamp invierà la coda corrente al server. Questo può migliorare il controllo remoto e permette la ripresa della coda via server. Sempre attivo se la funzione \'Play On\' è attiva.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Frequenza di aggiornamento della sessione di riproduzione';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'La frequenza con cui inviare lo stato di riproduzione corrente al server, in secondi. Deve essere inferiore a 5 minuti (300 secondi) per evitare il timeout della sessione.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'Se il server Jellyfin non ha ricevuto alcun aggiornamento da un client negli ultimi 5 minuti, presume che la riproduzione sia terminata. Ciò significa che per i brani più lunghi di 5 minuti la riproduzione potrebbe essere erroneamente segnalata come terminata, riducendo la qualità dei dati di segnalazione della riproduzione.';

  @override
  String get playOnStaleDelay => '\'Riproduci Su\' Timeout della Sessione';

  @override
  String get playOnStaleDelaySubtitle =>
      'Quanto a lungo una sessione remota \'Play On\' è considerata attiva dopo aver ricevuto un comando. Quando è considerata attiva, la riproduzione viene riportata più frequentemente, ciò può portare ad un aumento del consumo di dati.';

  @override
  String get enablePlayonTitle => 'Attiva il Supporto a \'Riproduci Su\'';

  @override
  String get enablePlayonSubtitle =>
      'Attiva la funzione \'Riproduci Su\' di Jellyfin (permette di controllare in remoto Finamp da un altro client). Disattiva questa funzione se il tuo reverse-proxy o il tuo server non supportano le connessioni websocket.';

  @override
  String get playOnReconnectionDelay =>
      '\'Riproduci Su\' Ritardo per Riconnessione della Sessione';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Controlla il ritardo fra i tentativi di riconnettersi al websocket \'Riproduci Su\' quando questo viene disconnesso (in secondi). Un ritardo più basso aumenta l\'uso dei dati.';

  @override
  String get topTracks => 'Brani più ascoltati';

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
      other: '$count Album',
      one: '$count Album',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Riproduci casualmente gli Album';

  @override
  String get shuffleAlbumsNext =>
      'Riproduci casualmente gli Album e aggiungi all\'inizio di A Seguire';

  @override
  String get shuffleAlbumsToNextUp =>
      'Riproduci casualmente gli Album e aggiungi alla fine di A Seguire';

  @override
  String get shuffleAlbumsToQueue =>
      'Riproduci casualmente gli Album e aggiungi alla fine della coda';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount riproduzioni',
      one: '$playCount riproduzione',
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
    return 'Non posso caricare $_temp0';
  }

  @override
  String get confirm => 'Conferma';

  @override
  String get close => 'Chiudi';

  @override
  String get showUncensoredLogMessage =>
      'Questo log contiene le tue credenziali di accesso. Vuoi vederlo?';

  @override
  String get resetTabs => 'Reimposta le schede';

  @override
  String get resetToDefaults => 'Reimposta valori di default';

  @override
  String get noMusicLibrariesTitle => 'Nessuna Libreria musicale';

  @override
  String get noMusicLibrariesBody =>
      'Finamp non è riuscito a trovare nessuna libreria musicale. Sei pregato di controllare che il tuo server Jellyfin contenga almeno una libreria con \"Tipo di contenuto\" impostato come \"Musica\".';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get moreInfo => 'Più informazioni';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalizzazione del volume';

  @override
  String get playbackReportingSettingsTitle =>
      'Report Riproduzione & Riproduci Su';

  @override
  String get volumeNormalizationSwitchTitle =>
      'Attiva Normalizzazione del volume';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Usa le informazioni di guadagno per normalizzare il volume dei brani (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle =>
      'Modalità di Normalizzazione del volume';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'Quando e come applicare la Normalizzazione del volume';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Ibrida (Brano + Album):\nPer la normale riproduzione sono usate le informazioni di guadagno del brano, ma se un album è in riproduzione (sia perché è la sorgente principale della coda di riproduzione o perché è stata aggiunta alla coda ad un certo punto), vengono invece usate le informazioni di guadagno dell\'album.\n\nbasata sul Brano:\nSono sempre usate le informazioni di guadagno del brano, indipendentemente dal fatto che un album sia o meno in riproduzione.\n\nbasata solo sull\'Album:\nLa Normalizzazione del volume viene applicata solo mentre si riproducono degli album (utilizzando le informazioni di guadagno dell\'album), ma non per i singoli brani.';

  @override
  String get volumeNormalizationModeHybrid => 'Ibrida (Brano + Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'basata sul Brano';

  @override
  String get volumeNormalizationModeAlbumBased => 'basata sull\'Album';

  @override
  String get volumeNormalizationModeAlbumOnly => 'basata solo sull\'Album';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle =>
      'Valore base del Guadagno';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Al momento la Normalizzazione del volume su iOS richiede di cambiare il volume di riproduzione per simulare il cambio di guadagno. Dato che non è possibile aumentare il volume oltre il 100%, dobbiamo diminuire il volume di default così che sia possibile aumentare il volume dei brani silenziosi. I valori sono in decibel (dB), dove -10 db corrispondono al ~30% di volume, -4.5 dB al ~60% di volume e -2 dB a ~80% di volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext =>
      'Striscia per riprodurre come prossimo brano';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Attiva per far si che quando si striscia il dito su un brano nella lista dei brani, questo venga aggiunto come prossimo elemento della coda invece di essere aggiunto alla fine della coda.';

  @override
  String get swipeLeftToRightAction => 'Azione Scorrimento a Destra';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Azione attivata facendo swipe su una traccia nella lista da sinistra verso destra.';

  @override
  String get swipeRightToLeftAction => 'Azione Scorrimento a Sinistra';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Azione attivata facendo swipe su una traccia nella lista da destra verso sinistra.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Fai partire un Mix Istantaneo per i singoli Brani';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'Quando attivo premere su un brano nella scheda dei brani farà partire un Mix Istantaneo di quel brano invece di riprodurre semplicemente il singolo brano.';

  @override
  String get downloadItem => 'Scarica';

  @override
  String get repairComplete => 'riparazione dei Download completata.';

  @override
  String get syncComplete => 'tutti i download sono stati ri-sincronizzati.';

  @override
  String get syncDownloads => 'Sincronizza e scarica gli elementi mancanti.';

  @override
  String get repairDownloads =>
      'Ripara i problemi con i file scaricati e con i metadati.';

  @override
  String get requireWifiForDownloads =>
      'Richiedi la connessione WiFi quando effettui il download.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '$count brano',
    );
    return 'Attenzione: $_temp0 non possono essere ripristinati nella coda.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'In corso',
        'failed': 'Fallito',
        'syncFailed': 'Non sincronizzato ripetutamente',
        'enqueued': 'Messo in coda',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Download',
      one: 'Download',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Sei sicuro di voler scaricare tutto il contenuto della libreria \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded =>
      'Mostra solo gli album completamente scaricati';

  @override
  String get filesystemFull =>
      'I download rimanenti non possono essere completati. La memoria di archiviazione del dispositivo è piena.';

  @override
  String get connectionInterrupted =>
      'Connessione interrotta, metto in pausa i download.';

  @override
  String get connectionInterruptedBackground =>
      'La connessione è stata interrotta mentre scaricavo in background. Ciò può essere avvenuto a causa di impostazioni dell\'OS.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'La connessione è stata interrotta mentre scaricavo in background. Ciò può essere avvenuto perché hai attivato l\'opzione \'Entra nello stato a bassa-priorità quando in pausa\' o a causa di impostazioni dell\'OS.';

  @override
  String get activeDownloadSize => 'Download…';

  @override
  String get missingDownloadSize => 'Eliminazione…';

  @override
  String get syncingDownloadSize => 'Sincronizzazione…';

  @override
  String get runRepairWarning =>
      'Non si è potuto contattare il server per finalizzare la migrazione dei download. Si prega di avviare \'Ripara i Download\' dalla schermata dei download appena sarai tornato online.';

  @override
  String get downloadSettings => 'Impostazioni di Download';

  @override
  String get showNullLibraryItemsTitle =>
      'Mostra i Media di una Libreria Sconosciuta.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Qualche media potrebbe essere scaricato con una libreria sconosciuta. Disattiva l\'opzione per nasconderli al di fuori della loro collezione originale.';

  @override
  String get maxConcurrentDownloads =>
      'numero massimo di download contemporanei';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'aumentare il numero di download contemporanei può permettere di aumentare il download in background, ma potrebbe causare l\'errore di qualche download se molto grandi o in alcuni casi causare un lag eccessivo.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Download contemporanei';
  }

  @override
  String get downloadsWorkersSetting => 'numero di processi di download';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Numero di processi per sincronizzare i metadati ed eliminare i download. Aumentare i processi di download può velocizzare la sincronizzazione e l\'eliminazione dei download, specialmente quando la latenza del server è alta, ma potrebbe introdurre del lag.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Processi di Download';
  }

  @override
  String get syncOnStartupSwitch =>
      'All\'avvio sincronizza automaticamente i Download';

  @override
  String get preferQuickSyncSwitch => 'Preferisci la sincronizzazione veloce';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'Quando si eseguono le sincronizzazioni alcuni elementi tipicamente statici (come brani e album) non verranno aggiornati. La riparazione del download eseguirà sempre una sincronizzazione completa.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Artista',
        'genre': 'Genere',
        'track': 'Brano',
        'library': 'Libreria',
        'unknown': 'Elemento',
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
    return 'Il download di questo elemento è richiesto da $parentName.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Preferiti',
        'allPlaylists': 'Tutte le Playlists',
        'fiveLatestAlbums': 'i 5 Ultimi Album',
        'allPlaylistsMetadata': 'Metadata delle Playlist',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Immagini in cache per \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle =>
      'Seleziona il formato di transcodifica';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Seleziona il formato da usare quando si riproduce in streaming dell\'audio transcodificato. Le tracce già in coda non saranno influenzate.';

  @override
  String get downloadTranscodeEnableTitle =>
      'Attiva i Download Transcodificati';

  @override
  String get downloadTranscodeCodecTitle => 'Seleziona il Codec per i Download';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Sempre',
        'never': 'Mai',
        'ask': 'Chiedi',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Bitrate per i download';

  @override
  String get downloadBitrateSubtitle =>
      'Un bitrate più alto garantisce una qualità audio più alta al costo di un maggiore consumo di spazio di archiviazione.';

  @override
  String get transcodeHint => 'Transcodificare?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Scarica come $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transcodificato',
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
        'other': ' come $codec @ $bitrate',
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
    return 'Scarica originali$_temp0';
  }

  @override
  String get redownloadcomplete =>
      'Download con Transcodifica messo nuovamente in coda.';

  @override
  String get redownloadTitle =>
      'Scarica nuovamente in modo automatico i file transcodificati';

  @override
  String get redownloadSubtitle =>
      'Scarica nuovamente in modo automatico i brani che si prevede abbiano una qualità diversa a causa delle modifiche alla raccolta principale.';

  @override
  String get defaultDownloadLocationButton =>
      'Imposta come percorso di download predefinito.  Disabilita per selezionare manualmente per ciascun download.';

  @override
  String get fixedGridSizeSwitchTitle =>
      'Usa riquadri della griglia di dimensioni fisse';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'Le dimensioni dei riquadri della griglia non rispondono alle dimensioni della finestra/schermo.';

  @override
  String get fixedGridSizeTitle => 'Dimensione del riquadro della griglia';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Piccolo',
        'medium': 'Medio',
        'large': 'Grande',
        'veryLarge': 'Molto Grande',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Abilita modalità \"Split Screen\"';

  @override
  String get allowSplitScreenSubtitle =>
      'Il lettore verrà visualizzato insieme ad altre viste su display più ampi.';

  @override
  String get enableVibration => 'Abilita vibrazione';

  @override
  String get enableVibrationSubtitle => 'Se vuoi abilitare la vibrazione.';

  @override
  String get hideQueueButton => 'Nascondi il pulsante della coda';

  @override
  String get hideQueueButtonSubtitle =>
      'Nascondi il pulsante della coda sulla schermata del player. Scorri verso l\'alto per accedere alla coda.';

  @override
  String get oneLineMarqueeTextButton =>
      'Scorri automaticamente i Titoli Lunghi';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Scorri automaticamente i titoli delle tracce che sono troppo lunghi per essere visualizzati in due linee';

  @override
  String get marqueeOrTruncateButton =>
      'Usa i puntini di sospensione per i titoli lunghi';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Mostra … alla fine dei titoli lunghi invece di far scorrere il testo';

  @override
  String get hidePlayerBottomActions => 'Nascondi le azioni in basso';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Nascondi i pulsanti della coda e dei testi nella schermata del lettore. Scorri verso l\'alto per accedere alla coda, scorri verso sinistra (sotto la copertina dell\'album) per visualizzare i testi, se disponibili.';

  @override
  String get prioritizePlayerCover => 'Dai priorità alla copertina dell\'album';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Dai la priorità alla visualizzazione di una copertina dell\'album più grande sullo schermo del lettore. I controlli non critici verranno nascosti in modo più aggressivo su schermi di piccole dimensioni.';

  @override
  String get suppressPlayerPadding =>
      'Sopprimere la spaziatura dei controlli del lettore';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Riduce completamente la spaziatura tra i controlli dello schermo del lettore quando la copertina dell\'album non è a grandezza naturale.';

  @override
  String get lockDownload => 'Tieni sempre sul dispositivo';

  @override
  String get showArtistChipImage =>
      'Mostra le immagini dell\'artista con il nome dell\'artista';

  @override
  String get showArtistChipImageSubtitle =>
      'Ciò influisce sulle piccole anteprime delle immagini degli artisti, come ad esempio sullo schermo del lettore.';

  @override
  String get scrollToCurrentTrack => 'Scorri fino al brano corrente';

  @override
  String get enableAutoScroll => 'Abilita lo scorrimento automatico';

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
    return '$duration rimasti';
  }

  @override
  String get removeFromPlaylistConfirm => 'Rimuovi';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Rimuovere \'$itemName\' dalla playlist \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Menu del Brano';

  @override
  String get quickActions => 'Azioni Veloci';

  @override
  String get addRemoveFromPlaylist => 'Aggiungi/Rimuovi dalle Playlist';

  @override
  String get addPlaylistSubheader => 'Aggiungi brano alla playlist';

  @override
  String get trackOfflineFavorites =>
      'Sincronizza tutti gli stati dei favoriti';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Ciò consente di mostrare gli stati dei preferiti più aggiornati mentre si è offline.  Non scarica alcun file aggiuntivo.';

  @override
  String get allPlaylistsInfoSetting => 'Scarica i Metadati della Playlist';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Sincronizza i metadati per tutte le playlist per migliorare la tua esperienza con le playlist';

  @override
  String get downloadFavoritesSetting => 'Scarica tutti i preferiti';

  @override
  String get downloadAllPlaylistsSetting => 'Scarica tutte le playlist';

  @override
  String get fiveLatestAlbumsSetting => 'Scarica gli ultimi 5 album';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'I download verranno rimossi man mano che invecchiano. Blocca il download per impedire che un album venga rimosso.';

  @override
  String get cacheLibraryImagesSettings =>
      'Memorizzare nella cache le immagini della libreria corrente';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Verranno scaricate tutte le copertine di album, artisti, generi e playlist della libreria attualmente attiva.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Mostra l\'avanzamento del brano sul miniplayer in-app';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Controlla se il miniplayer in-app / la barra in riproduzione nella parte inferiore della schermata musicale funzionano come una barra di avanzamento.';

  @override
  String get lyricsScreenButtonTitle => 'Testi';

  @override
  String get lyricsScreen => 'Visualizzazione dei testi';

  @override
  String get showLyricsTimestampsTitle =>
      'Mostra il timestamp per i testi sincronizzati';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Controlla se il timestamp di ogni riga del testo deve essere mostrato nel visualizzatore di testi, quando disponibile.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Mostra il pulsante stop nella notifica multimediale';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Controlla se la notifica multimediale deve disporre di un pulsante di stop oltre al pulsante di pausa. Ciò ti consente di interrompere la riproduzione senza aprire l\'app.';

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
      'Mostra i controlli di scorrimento nella notifica multimediale';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Controlla se la notifica multimediale deve avere un indicatore di stato scorrevole. Ciò ti consente di modificare la posizione di riproduzione senza aprire l\'app.';

  @override
  String get alignmentOptionStart => 'A sinistra';

  @override
  String get alignmentOptionCenter => 'Al centro';

  @override
  String get alignmentOptionEnd => 'A destra';

  @override
  String get fontSizeOptionSmall => 'Piccolo';

  @override
  String get fontSizeOptionMedium => 'Medio';

  @override
  String get fontSizeOptionLarge => 'Grande';

  @override
  String get lyricsAlignmentTitle => 'Giustificazione dei Testi';

  @override
  String get lyricsAlignmentSubtitle =>
      'Controlla l\'allineamento dei testi nel visualizzatore dei testi.';

  @override
  String get lyricsFontSizeTitle => 'Dimensione del carattere dei testi';

  @override
  String get lyricsFontSizeSubtitle =>
      'Controlla la dimensione del carattere dei testi nel visualizzatore dei testi.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Mostra la cover dell\'album prima dei testi';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Controlla se la copertina dell\'album deve essere mostrata sopra i testi prima di essere fatta scorrere via.';

  @override
  String get keepScreenOn => 'Mantieni lo Schermo Acceso';

  @override
  String get keepScreenOnSubtitle => 'Quando mantenere lo schermo acceso';

  @override
  String get keepScreenOnDisabled => 'Disattivo';

  @override
  String get keepScreenOnAlwaysOn => 'Sempre acceso';

  @override
  String get keepScreenOnWhilePlaying => 'Quando la musica è in riproduzione';

  @override
  String get keepScreenOnWhileLyrics => 'Quando sono visualizzati i Testi';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'Mantieni lo schermo acceso solo quando collegato in ricarica';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Ignora l\'impostazione Mantieni Schermo Acceso se il dispositivo non è in ricarica';

  @override
  String get genericToggleButtonTooltip => 'Premi per attivare/disattivare.';

  @override
  String get artwork => 'Copertina';

  @override
  String artworkTooltip(String title) {
    return 'Copertina di $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Copertina di $title. Premi per attivare/disattivare la riproduzione. Scorri verso sinistra o destra per cambiare traccia.';
  }

  @override
  String get nowPlayingBarTooltip => 'Apri la Schermata del Lettore';

  @override
  String get additionalPeople => 'Persone';

  @override
  String get playbackMode => 'Modalità di riproduzione';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Profondità di Bit';

  @override
  String get size => 'Dimensioni';

  @override
  String get normalizationGain => 'Guadagno';

  @override
  String get sampleRate => 'Frequenza di campionamento';

  @override
  String get showFeatureChipsToggleTitle =>
      'Mostra informazioni avanzate sul brano';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Mostra sullo schermo del lettore informazioni avanzate sul brano come codec, bitrate e altro.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Schermata dell\'Album';

  @override
  String get showCoversOnAlbumScreenTitle =>
      'Mostra le Copertine degli Album per ciascun Brano';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Mostra le copertine degli album per ciascun brano separatamente nella schermata dell\'album.';

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
      'Non hai ancora ascoltato nessun brano di questo artista.';

  @override
  String get emptyFilteredListTitle => 'Nessun elemento trovato';

  @override
  String get emptyFilteredListSubtitle =>
      'Nessun elemento corrisponde al filtro. Prova a disattivare il filtro o a modificare il termine di ricerca.';

  @override
  String get resetFiltersButton => 'Resetta il filtro';

  @override
  String get resetSettingsPromptGlobal =>
      'Sei sicuro di voler ripristinare TUTTE le impostazioni ai valori predefiniti?';

  @override
  String get resetSettingsPromptGlobalConfirm =>
      'Ripristina TUTTE le impostazioni';

  @override
  String get resetSettingsPromptLocal =>
      'Vuoi ripristinare queste impostazioni ai valori predefiniti?';

  @override
  String get genericCancel => 'Annulla';

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
    return '$_temp0 è stato cancellato da $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle =>
      'Permetti l\'eliminazione sul server';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Attiva e disattiva la possibilità di eliminare irreversibilmente una traccia dal disco del server quando l\'eliminazione è possibile.';

  @override
  String deleteFromTargetDialogText(
      String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artista',
        'genre': 'genre',
        'track': 'traccia',
        'library': 'library',
        'other': 'item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete':
            ' Questa azione eliminerà anche l\'elemento da questo Dispositivo.',
        'cantDelete':
            ' Questo elemento rimarrà su questo dispositivo fino alla prossima sincronizzazione.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'questo dispositivo',
        'server':
            'il disco del server e la libreria.$_temp1\nQuesta azione non può essere annullata',
        'other': '',
      },
    );
    return 'Stai per eliminare $_temp0 da $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' dal Dispositivo',
        'server': ' dal Server',
        'other': '',
      },
    );
    return 'Elimina$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Attenzione: stai per scaricare $count tracce.';
  }

  @override
  String get downloadSizeWarningCutoff =>
      'Limite per l\'avviso delle dimensioni del download';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'Un messaggio d\'avviso verrà mostrato quando si scarica in una volta sola un numero di tracce più grande di questo.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artista',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Sei sicuro di voler aggiungere tutte le tracce da $_temp0 \'$itemName\' a questa playlist?  Possono essere rimosse solo una per una.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Visibile a tutti:';

  @override
  String get releaseDateFormatYear => 'Anno';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Mese & Anno';

  @override
  String get releaseDateFormatMonthDayYear => 'Mese, Giorno & Anno';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Mostra la Data di Rilascio dell\'Album nella Schermata di Riproduzione';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Mostra la data di rilascio dell\'album nella schermata di riproduzione, dietro il nome dell\'album.';

  @override
  String get releaseDateFormatTitle => 'Formato della Data di Rilascio';

  @override
  String get releaseDateFormatSubtitle =>
      'Controlla il formato di tutte le date di rilascio mostrate nell\'app.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError =>
      'Errore nel caricare le librerie disponibili per l\'utente';

  @override
  String get autoOfflineOptionOff => 'Disattivo';

  @override
  String get autoOfflineOptionNetwork => 'Rete';

  @override
  String get autoOfflineOptionDisconnected => 'Non connesso';

  @override
  String get autoOfflineSettingDescription =>
      'Attiva automaticamente la modalità Offline.\nDisattivo: Non attiverà automaticamente la modalità Offline. Può far risparmiare la batteria.\nRete: Attiva la modalità Offline quando non si è connessi al wifi o ad un cavo ethernet.\nNon connesso: Attiva la modalità Offline quando non si è connessi a niente.\nPuoi sempre attivare manualmente la modalità offline, ciò metterà in pausa le automazioni fino a quando non disattiverai la modalità offline';

  @override
  String get autoOfflineSettingTitle => 'Modalità Offline Automatizzata';

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
    return '$_temp0 automaticamente la Modalità Offline';
  }

  @override
  String get audioFadeOutDurationSettingTitle =>
      'Durata della dissolvenza audio in chiusura';

  @override
  String get audioFadeOutDurationSettingSubtitle =>
      'La durata della dissolvenza audio in chiusura in millisecondi.';

  @override
  String get audioFadeInDurationSettingTitle =>
      'Durata della dissolvenza in apertura';

  @override
  String get audioFadeInDurationSettingSubtitle =>
      'La durata della dissolvenza audio in apertura in millisecondi. Imposta su 0 per disabilitare la dissolvenza in apertura.';

  @override
  String get outputMenuButtonTitle => 'Uscita Audio';

  @override
  String get outputMenuTitle => 'Cambia Uscita Audio';

  @override
  String get outputMenuVolumeSectionTitle => 'Volume';

  @override
  String get outputMenuDevicesSectionTitle => 'Dispositivi disponibili';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Connetti ad un dispositivo';

  @override
  String deviceType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'speaker': 'Altoparlante',
        'tv': 'TV',
        'bluetooth': 'Bluetooth',
        'other': 'Sconosciuto',
      },
    );
    return '$_temp0';
  }

  @override
  String get desktopShuffleWarning =>
      'La riproduzione casuale al momento non è disponibile sul desktop.';

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
