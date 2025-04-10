// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Un reproductor de música de codi obert per a Jellyfin';

  @override
  String startupError(String error) {
    return 'S\'ha produït un error durant l\'inici de l\'aplicació. L\'error es: $error\n\nCreeu un problema a github.com/UnicornsOnLSD/finamp amb una captura de pantalla d\'aquesta pàgina. Si aquest problema persisteix, podeu esborrar les dades de l\'aplicació per restablir-la.';
  }

  @override
  String get about => 'Sobre Finamp';

  @override
  String get aboutContributionPrompt => 'Feta per gent meravellosa en el seu temps lliure.\nTu podries ser un d\'ells!';

  @override
  String get aboutContributionLink => 'Contribueix a Finamp a Github:';

  @override
  String get aboutReleaseNotes => 'Llegeix les últimes notes de llançament:';

  @override
  String get aboutTranslations => 'Ajuda a traduir Finamp a la teva llengua:';

  @override
  String get aboutThanks => 'Moltes gràcies per fer servir Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Benvingut a';

  @override
  String get loginFlowSlogan => 'La teva música com la vols.';

  @override
  String get loginFlowGetStarted => 'Comença!';

  @override
  String get viewLogs => 'Visualitza els registres';

  @override
  String get changeLanguage => 'Canvia d\'idioma';

  @override
  String get loginFlowServerSelectionHeading => 'Connecta a Jellyfin';

  @override
  String get back => 'Enrere';

  @override
  String get serverUrl => 'URL del servidor';

  @override
  String get internalExternalIpExplanation => 'Si voleu poder accedir al vostre servidor Jellyfin de forma remota, heu d\'utilitzar la vostra IP externa.\n\nSi el vostre servidor està en un port HTTP per defecte (80 o 443) o al port per defecte de Jellyfin (8096), no cal que l\'especifiqueu.\n\nSi la URL és correcta, hauríeu de veure aparèixer informació del vostre servidor sota el camp d\'entrada.';

  @override
  String get serverUrlHint => 'p.ex.: demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Ajuda sobre la URL del servidor';

  @override
  String get emptyServerUrl => 'La URL del servidor no pot estar buida';

  @override
  String get connectingToServer => 'Connectant amb el servidor…';

  @override
  String get loginFlowLocalNetworkServers => 'Servidors a la teva xarxa local:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Buscant servidors…';

  @override
  String get loginFlowAccountSelectionHeading => 'Selecciona el teu compte';

  @override
  String get backToServerSelection => 'Enrere a la selecció de servidor';

  @override
  String get loginFlowNamelessUser => 'Usuari sense nom';

  @override
  String get loginFlowCustomUser => 'Usuari personalitzat';

  @override
  String get loginFlowAuthenticationHeading => 'Accedeix al teu compte';

  @override
  String get backToAccountSelection => 'Enrere a la selecció de compte';

  @override
  String get loginFlowQuickConnectPrompt => 'Utilitza el codi Quick Connect';

  @override
  String get loginFlowQuickConnectInstructions => 'Obriu l\'aplicació o el web de Jellyfin, feu clic sobre la icona del vostre usuari i seleccioni «Connexió ràpida».';

  @override
  String get loginFlowQuickConnectDisabled => 'Quick Connect es troba deshabilitat en aquest servidor.';

  @override
  String get orDivider => 'o';

  @override
  String get loginFlowSelectAUser => 'Selecciona un usuari';

  @override
  String get username => 'Nom d\'usuari';

  @override
  String get usernameHint => 'Introdueix el teu nom d\'usuari';

  @override
  String get usernameValidationMissingUsername => 'Si us plau, introdueix el teu nom d\'usuari';

  @override
  String get password => 'Contrasenya';

  @override
  String get passwordHint => 'Introdueix la teva contrasenya';

  @override
  String get login => 'Inici de sessió';

  @override
  String get logs => 'Registres';

  @override
  String get next => 'Següent';

  @override
  String get selectMusicLibraries => 'Selecciona les llibreries de música';

  @override
  String get couldNotFindLibraries => 'No s\'ha trobat cap llibreria.';

  @override
  String get unknownName => 'Nom desconegut';

  @override
  String get tracks => 'Pistes';

  @override
  String get albums => 'Àlbums';

  @override
  String get artists => 'Artistes';

  @override
  String get genres => 'Gèneres';

  @override
  String get playlists => 'Llistes de reproducció';

  @override
  String get startMix => 'Començar la mescla';

  @override
  String get startMixNoTracksArtist => 'Prém sostingudament per afegir o eliminar un artista de la llista de cançons abans de començar la llista';

  @override
  String get startMixNoTracksAlbum => 'Manté pres un àlbum per afegir o esborrar-lo del creador de barreges abans de començar una barreja';

  @override
  String get startMixNoTracksGenre => 'Manté pres un gènere per afegir o esborrar-lo del creador de barreges abans de començar una barreja';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Neteja';

  @override
  String get favourites => 'Preferits';

  @override
  String get shuffleAll => 'Reprodueix aleatòriament totes les cançons';

  @override
  String get downloads => 'Descàrregues';

  @override
  String get settings => 'Configuració';

  @override
  String get offlineMode => 'Mode sense connexió';

  @override
  String get sortOrder => 'Ordena';

  @override
  String get sortBy => 'Ordena per';

  @override
  String get title => 'Títol';

  @override
  String get album => 'Àlbum';

  @override
  String get albumArtist => 'Artista de l\'Àlbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Pressupost';

  @override
  String get communityRating => 'Nota de la Comunitat';

  @override
  String get criticRating => 'Nota de la Crítica';

  @override
  String get dateAdded => 'Data on s\'afegí';

  @override
  String get datePlayed => 'Data on es reproduí';

  @override
  String get playCount => 'Recompte de reproduccions';

  @override
  String get premiereDate => 'Data d\'estrena';

  @override
  String get productionYear => 'Any de Producció';

  @override
  String get name => 'Nom';

  @override
  String get random => 'Aleatori';

  @override
  String get revenue => 'Ingressos';

  @override
  String get runtime => 'Durada';

  @override
  String get syncDownloadedPlaylists => 'Sincronitza les llistes de reproducció descarregades';

  @override
  String get downloadMissingImages => 'Descarregar imatges mancants';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descarregades $count imatges mancants',
      one: 'Descarregades $count imatges mancants',
      zero: 'No s\'han trobat imatges mancants',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Descàrregues Actives';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descàrregues',
      one: '$count descàrrega',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount pistes',
      one: '$trackCount pista',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount imatges',
      one: '$imageCount imatge',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount nodes sincronitzats',
      one: '$syncCount node sincronitzat',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nReparant',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count completat';
  }

  @override
  String dlFailed(int count) {
    return '$count fallat';
  }

  @override
  String dlEnqueued(int count) {
    return '$count en cua';
  }

  @override
  String dlRunning(int count) {
    return '$count funcionant';
  }

  @override
  String get activeDownloadsTitle => 'Descàrregues Actives';

  @override
  String get noActiveDownloads => 'Cap descàrrega activa.';

  @override
  String get errorScreenError => 'Un error ha succeït mentre s\'intentava obtenir la llista d\'errors! En aquest punt, probablement hauries de crear una sol·licitud a GitHub i esborrar les dades de l\'aplicació';

  @override
  String get failedToGetTrackFromDownloadId => 'Error a l\'hora de trobar-lo pel seu ID de descàrrega';

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
    return 'Estàs segur que vols esborrar el $_temp0 \'$itemName\' d\'aquest dispositiu?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Esborrar';

  @override
  String get specialDownloads => 'Descàrregues especials';

  @override
  String get noItemsDownloaded => 'Cap ítem descarregat.';

  @override
  String get error => 'Error';

  @override
  String discNumber(int number) {
    return 'Disc $number';
  }

  @override
  String get playButtonLabel => 'Reprodueix';

  @override
  String get shuffleButtonLabel => 'Aleatori';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pistes',
      one: '$count Pista',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pistes',
      one: '$count Pista',
    );
    return '$_temp0, $downloads Descarregat/es';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pistes',
      one: '$count Pista',
    );
    return '$_temp0 Descarregat/es';
  }

  @override
  String get editPlaylistNameTooltip => 'Edita el nom de la llista de reproducció';

  @override
  String get editPlaylistNameTitle => 'Edita el nom de la llista de reproducció';

  @override
  String get required => 'Requerit';

  @override
  String get updateButtonLabel => 'Actualitzar';

  @override
  String get playlistNameUpdated => 'Nom de la llista de reproducció actualitzat.';

  @override
  String get favourite => 'Preferit';

  @override
  String get downloadsDeleted => 'Descàrregues esborrades.';

  @override
  String get addDownloads => 'Afegir Descàrregues';

  @override
  String get location => 'Localització';

  @override
  String get confirmDownloadStarted => 'Descàrrega començada';

  @override
  String get downloadsQueued => 'Descàrrega preparada, descarregant fitxers';

  @override
  String get addButtonLabel => 'Afegeix';

  @override
  String get shareLogs => 'Compartir registres';

  @override
  String get logsCopied => 'Registres copiats.';

  @override
  String get message => 'Missatge';

  @override
  String get stackTrace => 'Traç de pila';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Llicenciat amb Mozilla Public License 2.0.\nCodi font disponible a $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Codificació';

  @override
  String get downloadLocations => 'Ubicació de Descàrregues';

  @override
  String get audioService => 'Servei d\'Àudio';

  @override
  String get playbackReporting => 'Playback reporting & Play On';

  @override
  String get interactions => 'Interaccions';

  @override
  String get layoutAndTheme => 'Disseny i Tema';

  @override
  String get notAvailableInOfflineMode => 'No disponible en mode sense connexió';

  @override
  String get logOut => 'Tancar sessió';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Les pistes descarregades no s\'esborraran';

  @override
  String get areYouSure => 'Estàs segur?';

  @override
  String get enableTranscoding => 'Habilitar codificació';

  @override
  String get enableTranscodingSubtitle => 'Codifica la música en el costat del servidor.';

  @override
  String get bitrate => 'Taxa de bits';

  @override
  String get bitrateSubtitle => 'Una taxa de bits més alta dona una millor qualitat d\'àudio a canvi d\'una major amplada de banda.';

  @override
  String get customLocation => 'Ubicació Personalitzada';

  @override
  String get appDirectory => 'Directori de l\'aplicació';

  @override
  String get addDownloadLocation => 'Afegir una Ubicació de Descàrregues';

  @override
  String get selectDirectory => 'Selecciona un Directori';

  @override
  String get unknownError => 'Error desconegut';

  @override
  String get pathReturnSlashErrorMessage => 'Rutes que retornen \"/\" no poden ser utilitzades';

  @override
  String get directoryMustBeEmpty => 'El directori ha d\'estar buit';

  @override
  String get customLocationsBuggy => 'Ubicacions personalitzades poden ser extremadament inestables i no són recomanables en la majoria dels casos. Les ubicacions sota el sistema de carpeta \'Music\' prevenen la portada de l\'àlbum de poder guardar-se per limitacions del SO.';

  @override
  String get enterLowPriorityStateOnPause => 'Introdueix un Estat de Baixa Prioritat en la Pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Permet que la notificació sigui descartable quan estigui pausat. A més, permet a Android parar el servei quan està pausat.';

  @override
  String get shuffleAllTrackCount => 'Recompte Total de Pistes Barrejades';

  @override
  String get shuffleAllTrackCountSubtitle => 'Quantitat de cançons que es carreguen quan s\'utilitza el botó barrejador de cançons.';

  @override
  String get viewType => 'Tipus de Visualització';

  @override
  String get viewTypeSubtitle => 'Tipus de vista per a la pantalla de música';

  @override
  String get list => 'Llista';

  @override
  String get grid => 'Graella';

  @override
  String get customizationSettingsTitle => 'Personalització';

  @override
  String get playbackSpeedControlSetting => 'Visualització de la Velocitat de Reproducció';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Si es mostren els controls de velocitat de reproducció al menú de la pantalla del reproductor';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automàtic:  \nFinamp intenta identificar si la pista que estàs reproduint és un pòdcast o (part) d\'un audiollibre. Es considera que aquest és el cas si la pista dura més de $trackDuration minuts, si l\'àlbum de la pista dura més de $albumDuration hores o si la pista té assignat almenys un d’aquests gèneres: $genreList.\nEls controls de velocitat de reproducció es mostraran aleshores al menú de la pantalla del reproductor.\n\nMostrat:\nEls controls de velocitat de reproducció sempre es mostraran al menú de la pantalla del reproductor.\n\nAmagat:\nEls controls de velocitat de reproducció al menú de la pantalla del reproductor sempre estaran ocults.';
  }

  @override
  String get automatic => 'Automàtic';

  @override
  String get shown => 'Mostrat';

  @override
  String get hidden => 'Amagat';

  @override
  String get speed => 'Velocitat';

  @override
  String get reset => 'Reiniciar';

  @override
  String get apply => 'Aplicar';

  @override
  String get portrait => 'Vertical';

  @override
  String get landscape => 'Horitzontal';

  @override
  String gridCrossAxisCount(String value) {
    return 'Columnes en vista de quadrícula en $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Quantitat de columnes utilitzades per fila quan el dispositiu està en $value.';
  }

  @override
  String get showTextOnGridView => 'Veure text en mode graella';

  @override
  String get showTextOnGridViewSubtitle => 'Mostrar el text (títol, artista, etc.) a la pantalla de música en graella.';

  @override
  String get useCoverAsBackground => 'Utilitza una cobertura difuminada pel fons de pantalla';

  @override
  String get useCoverAsBackgroundSubtitle => 'Utilitzar una portada d\'àlbum difuminada com a fons de pantalla en diferents apartats de l\'aplicació.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Marge interior mínim per l\'àlbum';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Marge interior mínim al voltant de la portada de l\'àlbum en la pantalla del reproductor, en % en l\'amplada de la pantalla.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Amaga els artistes de la cançó si són els mateixos que els de l\'àlbum';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Amaga als artistes de les cançons en la pantalla de l\'àlbum si no difereixen dels de l\'àlbum.';

  @override
  String get showArtistsTopTracks => 'Mostra les cançons que estan al top en la vista d\'artistes';

  @override
  String get showArtistsTopTracksSubtitle => 'Mostrar el top 5 més sentit en les cançons d\'un artista.';

  @override
  String get disableGesture => 'Deshabilitar gesticulacions';

  @override
  String get disableGestureSubtitle => 'Deshabilitar o no les gesticulacions.';

  @override
  String get showFastScroller => 'Mostrar el desplaçament ràpid';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Clar';

  @override
  String get dark => 'Fosc';

  @override
  String get tabs => 'Capçaleres';

  @override
  String get playerScreen => 'Pantalla de reproducció';

  @override
  String get cancelSleepTimer => 'Cancel·lo el temporitzador per dormir?';

  @override
  String get yesButtonLabel => 'Sí';

  @override
  String get noButtonLabel => 'No';

  @override
  String get setSleepTimer => 'Estableix un temportitzador';

  @override
  String get hours => 'Hores';

  @override
  String get seconds => 'Segons';

  @override
  String get minutes => 'Minuts';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime de$totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Pista $currentTrackIndex de$totalTrackCount';
  }

  @override
  String get invalidNumber => 'Nombre invàlid';

  @override
  String get sleepTimerTooltip => 'Temporitzador';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Aturar en $time minuts';
  }

  @override
  String get addToPlaylistTooltip => 'Afegir a la llista';

  @override
  String get addToPlaylistTitle => 'Afegir a llista';

  @override
  String get addToMorePlaylistsTooltip => 'Afageix a més llistes de reproducció';

  @override
  String get addToMorePlaylistsTitle => 'Afegeix a més llistes de reproducció';

  @override
  String get removeFromPlaylistTooltip => 'Elimina d\'aquesta llista de reproducció';

  @override
  String get removeFromPlaylistTitle => 'Eliminar d\'aquesta llista de reproducció';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Elimina de la llista de reproducció \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Eliminar de la llista \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nova llista de reproducció';

  @override
  String get createButtonLabel => 'Crea';

  @override
  String get playlistCreated => 'Llista de reproducció creada.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Toca per afegir a la llista de reproducció. Premer sostingut per afegir un favorit.';

  @override
  String get noAlbum => 'Sense Àlbum';

  @override
  String get noItem => 'Sense Objecte';

  @override
  String get noArtist => 'Sense Artista';

  @override
  String get unknownArtist => 'Artista desconegut';

  @override
  String get unknownAlbum => 'Àlbum desconegut';

  @override
  String get playbackModeDirectPlaying => 'Reproducció directa';

  @override
  String get playbackModeTranscoding => 'Transcodificació';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Reproduccint localment';

  @override
  String get queue => 'Cua';

  @override
  String get addToQueue => 'Afegir a la cua';

  @override
  String get replaceQueue => 'Substitueix la cua';

  @override
  String get instantMix => 'Barreja instantània';

  @override
  String get goToAlbum => 'Vés a l\'àlbum';

  @override
  String get goToArtist => 'Ves a l\'artista';

  @override
  String get goToGenre => 'Ves a Gènere';

  @override
  String get removeFavourite => 'Suprimeix el favorit';

  @override
  String get addFavourite => 'Afegeix favorit';

  @override
  String get confirmFavoriteAdded => 'Favorit afegit';

  @override
  String get confirmFavoriteRemoved => 'Favorit eliminat';

  @override
  String get addedToQueue => 'S\'ha afegit a la cua.';

  @override
  String get insertedIntoQueue => 'Insertat a la cua.';

  @override
  String get queueReplaced => 'S\'ha substituït la cua.';

  @override
  String get confirmAddedToPlaylist => 'Afegit a la llista de reproducció.';

  @override
  String get removedFromPlaylist => 'S\'ha suprimit de la llista de reproducció.';

  @override
  String get startingInstantMix => 'Inici de la barreja instantània.';

  @override
  String get anErrorHasOccured => 'S\'ha produït un error.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Codi d\'estat $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Codi d\'estat $statusCode. Això probablement vol dir que heu utilitzat un nom d\'usuari/contrasenya incorrecte o que el vostre client ha tancat la sessió.';
  }

  @override
  String get removeFromMix => 'Eliminar de la barreja';

  @override
  String get addToMix => 'Afegir a la barreja';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redownloaded $count items',
      one: 'Redownloaded $count item',
      zero: 'No redownloads needed.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Durada de la memòria intermèdia';

  @override
  String get bufferDurationSubtitle => 'La durada màxima que s\'ha d\'amortitzar, en segons. Requereix reiniciar.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'No limitar la mida de la memòria intermèdia';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Desactiva les restriccions de mida de la memòria intermèdia (\'Mida del cursor\'). La memòria intermèdia sempre es carregarà a la durada configurada (\'Duració de la memòria intermèdia\'), fins i tot per a fitxers molt grans. Pot causar fallades. Requereix reiniciar.';

  @override
  String get bufferSizeTitle => 'Mida de la meòria intermèdia';

  @override
  String get bufferSizeSubtitle => 'Mida màxima de la memòria intermèdia en MB. Requereix reiniciar';

  @override
  String get language => 'Llenguatge';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Salta cap al principi o cap a la cançó prèvia';

  @override
  String get skipToNextTrackButtonTooltip => 'Salta a la següent cançó';

  @override
  String get togglePlaybackButtonTooltip => 'Commuta la reproducció';

  @override
  String get previousTracks => 'Cançons anteriors';

  @override
  String get nextUp => 'Pròxims';

  @override
  String get clearNextUp => 'Esborrar Pròximes';

  @override
  String get playingFrom => 'Reproduint des de';

  @override
  String get playNext => 'Reproduir següent';

  @override
  String get addToNextUp => 'Afegeix a Pròxims';

  @override
  String get shuffleNext => 'Barreja els Pròxims';

  @override
  String get shuffleToNextUp => 'Barreja a Pròxims';

  @override
  String get shuffleToQueue => 'Barreja a la cua';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Cançó',
        'album': 'Àlbum',
        'artist': 'Artista',
        'playlist': 'Llista de Reproducció',
        'genre': 'Gènere',
        'other': 'Element',
      },
    );
    return '$_temp0 es reproduirà a continuació';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Cançó',
        'album': 'Àlbum',
        'artist': 'Artista',
        'playlist': 'Llista de Reproducció',
        'genre': 'Gènere',
        'other': 'Element',
      },
    );
    return 'Afegit $_temp0 a Pròxims';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Cançó',
        'album': 'Àlbum',
        'artist': 'Artista',
        'playlist': 'Llista de Reproducció',
        'genre': 'Gènere',
        'other': 'Element',
      },
    );
    return 'Afegit $_temp0 a la cua';
  }

  @override
  String get confirmShuffleNext => 'Barrejarà el següent';

  @override
  String get confirmShuffleToNextUp => 'Barrejat a Pròxims';

  @override
  String get confirmShuffleToQueue => 'Barrejat a la cua';

  @override
  String get placeholderSource => 'En algun lloc';

  @override
  String get playbackHistory => 'Historial de Reproducció';

  @override
  String get shareOfflineListens => 'Compartir reproduccions fora de línia';

  @override
  String get yourLikes => 'Els teus m\'agrada';

  @override
  String mix(String mixSource) {
    return '$mixSource - Barreja';
  }

  @override
  String get tracksFormerNextUp => 'Cançons afegides des de Pròxims';

  @override
  String get savedQueue => 'Cua Guardada';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'l\'Àlbum',
        'playlist': 'la Llista de reproducció',
        'trackMix': 'la Barreja de pistes',
        'artistMix': 'la Barreja d\'artistes',
        'albumMix': 'la Barreja d\'àlbums',
        'genreMix': 'la Barreja de gèneres',
        'favorites': 'els Preferits',
        'allTracks': 'Totes les pistes',
        'filteredList': 'les Pistes',
        'genre': 'el Gènere',
        'artist': 'l\'Artista',
        'track': 'la Pista',
        'nextUpAlbum': 'l\'Àlbum a Pròxims',
        'nextUpPlaylist': 'la Llista de reproducció a Pròxims',
        'nextUpArtist': 'l\'Artista a Pròxims',
        'other': '',
      },
    );
    return 'Reproduint des de $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Barreja tot';

  @override
  String get playbackOrderLinearButtonLabel => 'Reproduint en ordre';

  @override
  String get playbackOrderLinearButtonTooltip => 'Reproduint en ordre. Clica per barrejar.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Barrejant pistes';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Barrejant pistes. Clica per reproduir en ordre.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Reproduint a x$speed velocitat';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed velocitat';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volume';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Reduir velocitat de reproducció';

  @override
  String get playbackSpeedIncreaseLabel => 'Incrementar velocitat de reproducció';

  @override
  String get loopModeNoneButtonLabel => 'No es repeteix';

  @override
  String get loopModeOneButtonLabel => 'Repetint aquesta pista';

  @override
  String get loopModeAllButtonLabel => 'Repetint tot';

  @override
  String get queuesScreen => 'Restaurar la reproducció actual';

  @override
  String get queueRestoreButtonLabel => 'Restaurar';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Guardat $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Reproduint: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pistes',
      one: '1 Pista',
    );
    return '$_temp0, $remaining per Reproduir';
  }

  @override
  String get queueLoadingMessage => 'Restoring queue…';

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
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get showUncensoredLogMessage => 'This log contains your login information. Show?';

  @override
  String get resetTabs => 'Reset tabs';

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
  String get playbackReportingSettingsTitle => 'Playback reporting & Play On';

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
  String get swipeLeftToRightAction => 'Swipe to Right Action';

  @override
  String get swipeLeftToRightActionSubtitle => 'Action triggered when swiping a track in the list from left to right.';

  @override
  String get swipeRightToLeftAction => 'Swipe to Left Action';

  @override
  String get swipeRightToLeftActionSubtitle => 'Action triggered when swiping a track in the list from right to left.';

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
  String get onlyShowFullyDownloaded => 'Only show fully downloaded albums';

  @override
  String get filesystemFull => 'Remaining downloads cannot be completed. The filesystem is full.';

  @override
  String get connectionInterrupted => 'Connection interrupted, pausing downloads.';

  @override
  String get connectionInterruptedBackground => 'Connection was interrupted while downloading in the background. This can be caused by OS settings.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Connection was interrupted while downloading in the background. This can be caused by enabling \'Enter Low-Priority State on Pause\' or OS settings.';

  @override
  String get activeDownloadSize => 'Downloading…';

  @override
  String get missingDownloadSize => 'Deleting…';

  @override
  String get syncingDownloadSize => 'Syncing…';

  @override
  String get runRepairWarning => 'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Show Media with Unknown Library.';

  @override
  String get showNullLibraryItemsSubtitle => 'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.';

  @override
  String get maxConcurrentDownloads => 'Max Concurrent Downloads';

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
  String get transcodingStreamingFormatTitle => 'Select Transcoding Format';

  @override
  String get transcodingStreamingFormatSubtitle => 'Select the format to use when streaming transcoded audio. Already queued tracks will not be affected.';

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
  String get marqueeOrTruncateButtonSubtitle => 'Show … at the end of long titles instead of scrolling text';

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
  String get alignmentOptionStart => 'Start';

  @override
  String get alignmentOptionCenter => 'Center';

  @override
  String get alignmentOptionEnd => 'End';

  @override
  String get fontSizeOptionSmall => 'Small';

  @override
  String get fontSizeOptionMedium => 'Medium';

  @override
  String get fontSizeOptionLarge => 'Large';

  @override
  String get lyricsAlignmentTitle => 'Lyrics alignment';

  @override
  String get lyricsAlignmentSubtitle => 'Controls the alignment of lyrics in the lyrics view.';

  @override
  String get lyricsFontSizeTitle => 'Lyrics font size';

  @override
  String get lyricsFontSizeSubtitle => 'Controls the font size of lyrics in the lyrics view.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Show album cover before lyrics';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Controls if the album cover is shown above the lyrics before being scrolled away.';

  @override
  String get keepScreenOn => 'Keep Screen On';

  @override
  String get keepScreenOnSubtitle => 'When to keep the screen on';

  @override
  String get keepScreenOnDisabled => 'Disabled';

  @override
  String get keepScreenOnAlwaysOn => 'Always On';

  @override
  String get keepScreenOnWhilePlaying => 'While Playing Music';

  @override
  String get keepScreenOnWhileLyrics => 'While Showing Lyrics';

  @override
  String get keepScreenOnWhilePluggedIn => 'Keep Screen On only while plugged in';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignore the Keep Screen On setting if device is unplugged';

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
  String get nowPlayingBarTooltip => 'Open Player Screen';

  @override
  String get additionalPeople => 'People';

  @override
  String get playbackMode => 'Playback Mode';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Bit Depth';

  @override
  String get size => 'Size';

  @override
  String get normalizationGain => 'Gain';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get showFeatureChipsToggleTitle => 'Show Advanced Track Info';

  @override
  String get showFeatureChipsToggleSubtitle => 'Show advanced track info like codec, bitrate, and more on the player screen.';

  @override
  String get albumScreen => 'Album Screen';

  @override
  String get showCoversOnAlbumScreenTitle => 'Show Album Covers For Tracks';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Show album covers for each track separately on the album screen.';

  @override
  String get emptyTopTracksList => 'You haven\'t listened to any track by this artist yet.';

  @override
  String get emptyFilteredListTitle => 'No items found';

  @override
  String get emptyFilteredListSubtitle => 'No items match the filter. Try turning off the filter or changing the search term.';

  @override
  String get resetFiltersButton => 'Reset filters';

  @override
  String get resetSettingsPromptGlobal => 'Are you sure you want to reset ALL settings to their defaults?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Reset ALL settings';

  @override
  String get resetSettingsPromptLocal => 'Do you want to reset these settings back to their defaults?';

  @override
  String get genericCancel => 'Cancel';

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
