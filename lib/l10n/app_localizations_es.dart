// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Un reproductor de música para Jellyfin de código abierto';

  @override
  String startupError(String error) {
    return '¡Algo ha salido mal en el arranque de la aplicación! El error es: $error\n\nPor favor crea una incidencia en github.com/UnicornsOnLSD/finamp con una captura de pantalla de esta página. Si el problema persiste, borra los datos de la aplicación para resetearla.';
  }

  @override
  String get about => 'Acerca de Finamp';

  @override
  String get aboutContributionPrompt => 'Hecho por gente increíble en su tiempo libre.\n¡Podrías ser uno de ellos!';

  @override
  String get aboutContributionLink => 'Contribuye a Finamp en GitHub:';

  @override
  String get aboutReleaseNotes => 'Lee los cambios de la ultima actualización:';

  @override
  String get aboutTranslations => 'Ayúdanos a traducir Finamp a tu idioma:';

  @override
  String get aboutThanks => '¡Muchas gracias por usar Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Bienvenido a';

  @override
  String get loginFlowSlogan => 'Tu música, en la manera que tu quieras.';

  @override
  String get loginFlowGetStarted => '¡Empieza!';

  @override
  String get viewLogs => 'Mostrar los Registros';

  @override
  String get changeLanguage => 'Cambiar el idioma';

  @override
  String get loginFlowServerSelectionHeading => 'Conectarse a Jellyfin';

  @override
  String get back => 'Atrás';

  @override
  String get serverUrl => 'URL del servidor';

  @override
  String get internalExternalIpExplanation => 'Si quieres acceder a tu servidor Jellyfin remotamente, tendrás que usar tu dirección IP externa.\n\nSi tu servidor está en un puerto predeterminado (80 o 443) o en un puerto predeterminado de Jellyfin (8096), no tienes que especificar el puerto.\n\nSi la dirección es correcta, deberías poder ver algunso datos sobre tu servidor en las casillas de abajo.';

  @override
  String get serverUrlHint => 'ej. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Ayuda sobre la URL del servidor';

  @override
  String get emptyServerUrl => 'La URL del servidor no puede estar vacia';

  @override
  String get connectingToServer => 'Conectándose al servidor...';

  @override
  String get loginFlowLocalNetworkServers => 'Servidores en tu red local:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Buscando servidores...';

  @override
  String get loginFlowAccountSelectionHeading => 'Selecciona tu cuenta';

  @override
  String get backToServerSelection => 'Volver a la selección del servidor';

  @override
  String get loginFlowNamelessUser => 'Usuario sin nombre';

  @override
  String get loginFlowCustomUser => 'Usuario personalizado';

  @override
  String get loginFlowAuthenticationHeading => 'Iniciar sesión en tu cuenta';

  @override
  String get backToAccountSelection => 'Volver a la selección de cuentas';

  @override
  String get loginFlowQuickConnectPrompt => 'Usar el código de conexión rápida';

  @override
  String get loginFlowQuickConnectInstructions => 'Abre la aplicación o la página web de Jellyfin, haz clic en el icono de tu usuario, y selecciona Conexión Rápida.';

  @override
  String get loginFlowQuickConnectDisabled => 'La Conexión Rápida esta deshabilitada en este servidor.';

  @override
  String get orDivider => 'o';

  @override
  String get loginFlowSelectAUser => 'Selecciona un usuario';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get usernameHint => 'Introduce tu nombre de usuario';

  @override
  String get usernameValidationMissingUsername => 'Por favor, introduce un nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Introduce tu contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logs => 'Registros';

  @override
  String get next => 'Siguiente';

  @override
  String get selectMusicLibraries => 'Seleccionar las bibliotecas de música';

  @override
  String get couldNotFindLibraries => 'No se pudo encontrar ninguna biblioteca.';

  @override
  String get unknownName => 'Nombre desconocido';

  @override
  String get tracks => 'Canciones';

  @override
  String get albums => 'Álbumes';

  @override
  String get artists => 'Artistas';

  @override
  String get genres => 'Géneros';

  @override
  String get playlists => 'Listas';

  @override
  String get startMix => 'Empezar mezcla';

  @override
  String get startMixNoTracksArtist => 'Mantén pulsado un artista para añadirlo o eliminarlo del creador de mezclas antes de empezar una mezcla';

  @override
  String get startMixNoTracksAlbum => 'Mantén pulsado un álbum para añadirlo o eliminarlo del creador de mezclas antes de empezar una mezcla';

  @override
  String get startMixNoTracksGenre => 'Mantén pulsado un género para añadirlo o eliminarlo del mezclador antes de empezar una mezcla';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Limpiar';

  @override
  String get favourites => 'Favoritos';

  @override
  String get shuffleAll => 'Reproducir aleatoriamente todas las canciones';

  @override
  String get downloads => 'Descargas';

  @override
  String get settings => 'Ajustes';

  @override
  String get offlineMode => 'Modo sin conexión';

  @override
  String get sortOrder => 'Ordenar';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get title => 'Título';

  @override
  String get album => 'Álbum';

  @override
  String get albumArtist => 'Artista del álbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Presupuesto';

  @override
  String get communityRating => 'Valoración de la comunidad';

  @override
  String get criticRating => 'Valoración de los críticos';

  @override
  String get dateAdded => 'Fecha de añadido';

  @override
  String get datePlayed => 'Fecha de reproducción';

  @override
  String get playCount => 'Reproducciones';

  @override
  String get premiereDate => 'Fecha de lanzamiento';

  @override
  String get productionYear => 'Año de producción';

  @override
  String get name => 'Nombre';

  @override
  String get random => 'Aleatorio';

  @override
  String get revenue => 'Ingresos';

  @override
  String get runtime => 'Duración';

  @override
  String get syncDownloadedPlaylists => 'Sincroniza las listas de reproducción descargadas';

  @override
  String get downloadMissingImages => 'Descargar las imágenes que faltan';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargadas $count que faltaban',
      one: 'Descargada $count imagen que faltaba',
      zero: 'No se han encontrado imágenes que faltan',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Activar Descargas';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descargas',
      one: '$count descarga',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount pistas',
      one: '$trackCount pista',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount imágenes',
      one: '$imageCount imágen',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount nodos sincronizando',
      one: '$syncCount nodo sincronizando',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nReparando',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count completadas';
  }

  @override
  String dlFailed(int count) {
    return '$count han fallado';
  }

  @override
  String dlEnqueued(int count) {
    return '$count en cola';
  }

  @override
  String dlRunning(int count) {
    return '$count en progreso';
  }

  @override
  String get activeDownloadsTitle => 'Descargas Activas';

  @override
  String get noActiveDownloads => 'No hay descargas activas.';

  @override
  String get errorScreenError => '¡Se ha producido un error al obtener la lista de errores! Llegados a este punto, probablemente deberías crear una incidencia en GitHub y eliminar los datos de la aplicación';

  @override
  String get failedToGetTrackFromDownloadId => 'No se ha podido obtener la canción desde el identificador de descarga';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'el álbum',
        'playlist': 'la lista de reproducción',
        'artist': 'el artista',
        'genre': 'el género',
        'track': 'la pista',
        'library': 'la biblioteca',
        'other': 'ítem',
      },
    );
    return '¿Estás seguro de que quieres eliminar $_temp0 \'$itemName\' de este dispositivo?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Eliminar';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Error';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'Reproducir';

  @override
  String get shuffleButtonLabel => 'Aleatorio';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Canciones',
      one: '$count Canción',
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
    return '$_temp0, $downloads Downloaded';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '$count Track',
    );
    return '$_temp0 Downloaded';
  }

  @override
  String get editPlaylistNameTooltip => 'Editar el nombre de la lista de reproducción';

  @override
  String get editPlaylistNameTitle => 'Modificar el nombre de la lista de reproducción';

  @override
  String get required => 'Requerido';

  @override
  String get updateButtonLabel => 'ACTUALIZAR';

  @override
  String get playlistNameUpdated => 'Se actualizó el nombre de la lista.';

  @override
  String get favourite => 'Favorito';

  @override
  String get downloadsDeleted => 'Se borraron las descargas.';

  @override
  String get addDownloads => 'Añadir descargas';

  @override
  String get location => 'Ubicación';

  @override
  String get confirmDownloadStarted => 'Descarga comenzada';

  @override
  String get downloadsQueued => 'Descarga preparada, descargando archivos';

  @override
  String get addButtonLabel => 'Añadir';

  @override
  String get shareLogs => 'Compartir registros';

  @override
  String get logsCopied => 'Se copiaron los registros.';

  @override
  String get message => 'Mensaje';

  @override
  String get stackTrace => 'Trazado de pila';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Licenciado con la Mozilla Public License 2.0.\nCódigo fuente disponible en $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transcodificar';

  @override
  String get downloadLocations => 'Ubicaciones de descarga';

  @override
  String get audioService => 'Servicio de audio';

  @override
  String get interactions => 'Interacciones';

  @override
  String get layoutAndTheme => 'Diseño y tema';

  @override
  String get notAvailableInOfflineMode => 'No está disponible en el modo sin conexión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Las canciones descargadas no serán eliminadas';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin usa AAC para transcodificar';

  @override
  String get enableTranscoding => 'Habilitar transcodificación';

  @override
  String get enableTranscodingSubtitle => 'Transcodifica los streams de música en el servidor.';

  @override
  String get bitrate => 'Tasa de bits';

  @override
  String get bitrateSubtitle => 'Una tasa de bits más alta da una mayor calidad de audio a costa de un mayor ancho de banda.';

  @override
  String get customLocation => 'Ubicación personalizada';

  @override
  String get appDirectory => 'Directorio de la aplicación';

  @override
  String get addDownloadLocation => 'Añadir ubicación de descarga';

  @override
  String get selectDirectory => 'Seleccionar directorio';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get pathReturnSlashErrorMessage => 'No se pueden utilizar ubicaciones que contengan \"/\"';

  @override
  String get directoryMustBeEmpty => 'El directorio debe estar vacío';

  @override
  String get customLocationsBuggy => 'Las ubicaciones personalizadas son extremadamente problemáticas por problemas con los permisos. Estoy pensando en maneras de arreglarlo, pero por ahora no recomiendo usarlas.';

  @override
  String get enterLowPriorityStateOnPause => 'Entrar en estado de baja prioridad al pausar';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Permite que la notificación se pueda deslizar cuando la música esté pausada. También permite a Android matar el servicio cuando la música esté pausada.';

  @override
  String get shuffleAllTrackCount => 'Cantidad de canciones al reproducir aleatoriamente';

  @override
  String get shuffleAllTrackCountSubtitle => 'Cantidad de canciones a cargar cuando se use el botón de reproducir todo aleatoriamente.';

  @override
  String get viewType => 'Tipo de vista';

  @override
  String get viewTypeSubtitle => 'Tipo de vista para la pantalla de música';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Cuadrícula';

  @override
  String get customizationSettingsTitle => 'Customization';

  @override
  String get playbackSpeedControlSetting => 'Playback Speed Visibility';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Whether the playback speed controls are shown in the player screen menu';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automatic:\nFinamp tries to identify whether the track you are playing is a podcast or (part of) an audiobook. This is considered to be the case if the track is longer than $trackDuration minutes, if the track\'\'s album is longer than $albumDuration hours, or if the track has at least one of these genres assigned: $genreList\nPlayback speed controls will then be shown in the player screen menu.\n\nShown:\nThe playback speed controls will always be shown in the player screen menu.\n\nHidden:\nThe playback speed controls in the player screen menu are always hidden.';
  }

  @override
  String get automatic => 'Automatic';

  @override
  String get shown => 'Shown';

  @override
  String get hidden => 'Hidden';

  @override
  String get speed => 'Speed';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get portrait => 'Vertical';

  @override
  String get landscape => 'Horizontal';

  @override
  String gridCrossAxisCount(String value) {
    return 'Columnas en vista de cuadrícula en $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Cantidad de columnas al usar por fila al estar el dispositivo en $value.';
  }

  @override
  String get showTextOnGridView => 'Mostrar texto en vista de cuadrícula';

  @override
  String get showTextOnGridViewSubtitle => 'Muestra el texto (título, artista, etc) en la pantalla de música al usar la vista de cuadrícula.';

  @override
  String get useCoverAsBackground => 'Mostrar la carátula con desenfoque como fondo del reproductor';

  @override
  String get useCoverAsBackgroundSubtitle => 'Usa la carátula del álbum desenfocada como fondo del reproductor.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimum album cover padding';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimum padding around the album cover on the player screen, in % of the screen width.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Ocultar los artistas de canciones si son los mismos que los artistas del álbum';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Oculta a los artistas de las canciones en la pantalla del álbum si no son diferentes de los artistas del álbum.';

  @override
  String get showArtistsTopTracks => 'Show top tracks in artist view';

  @override
  String get showArtistsTopTracksSubtitle => 'Whether to show the top 5 most listened to tracks of an artist.';

  @override
  String get disableGesture => 'Deshabilitar los gestos';

  @override
  String get disableGestureSubtitle => 'Si desea desactivar los gestos.';

  @override
  String get showFastScroller => 'Mostrar desplazamiento rápido';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get tabs => 'Pestañas';

  @override
  String get playerScreen => 'Player Screen';

  @override
  String get cancelSleepTimer => '¿Cancelar el temporizador de sueño?';

  @override
  String get yesButtonLabel => 'SÍ';

  @override
  String get noButtonLabel => 'NO';

  @override
  String get setSleepTimer => 'Ajustar temporizador de sueño';

  @override
  String get hours => 'Hours';

  @override
  String get seconds => 'Seconds';

  @override
  String get minutes => 'Minutos';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime of $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Track $currentTrackIndex of $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get sleepTimerTooltip => 'Temporizador de sueño';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Sleeping in $time minutes';
  }

  @override
  String get addToPlaylistTooltip => 'Añadir a lista de reproducción';

  @override
  String get addToPlaylistTitle => 'Agregar a lista de reproducción';

  @override
  String get addToMorePlaylistsTooltip => 'Add to more playlists';

  @override
  String get addToMorePlaylistsTitle => 'Add to More Playlists';

  @override
  String get removeFromPlaylistTooltip => 'Eliminar de la lista de reproducción';

  @override
  String get removeFromPlaylistTitle => 'Borrar de la lista de reproducción';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Remove from playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Remove from Playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nueva lista';

  @override
  String get createButtonLabel => 'CREAR';

  @override
  String get playlistCreated => 'Se creó la lista.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Tap to add to playlist. Long press to toggle favorite.';

  @override
  String get noAlbum => 'Sin álbum';

  @override
  String get noItem => 'Ningún elemento';

  @override
  String get noArtist => 'Sin artista';

  @override
  String get unknownArtist => 'Artista desconocido';

  @override
  String get unknownAlbum => 'Unknown Album';

  @override
  String get playbackModeDirectPlaying => 'Direct Playing';

  @override
  String get playbackModeTranscoding => 'Transcoding';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Locally Playing';

  @override
  String get queue => 'Cola';

  @override
  String get addToQueue => 'Añadir a la cola';

  @override
  String get replaceQueue => 'Reemplazar la cola';

  @override
  String get instantMix => 'Mezcla instantánea';

  @override
  String get goToAlbum => 'Ir al álbum';

  @override
  String get goToArtist => 'Go to Artist';

  @override
  String get goToGenre => 'Go to Genre';

  @override
  String get removeFavourite => 'Eliminar favorito';

  @override
  String get addFavourite => 'Añadir favorito';

  @override
  String get confirmFavoriteAdded => 'Added Favorite';

  @override
  String get confirmFavoriteRemoved => 'Removed Favorite';

  @override
  String get addedToQueue => 'Añadido a la cola.';

  @override
  String get insertedIntoQueue => 'Insertado en la cola.';

  @override
  String get queueReplaced => 'Se reemplazó la cola.';

  @override
  String get confirmAddedToPlaylist => 'Added to playlist.';

  @override
  String get removedFromPlaylist => 'Eliminado de la lista de reproducción.';

  @override
  String get startingInstantMix => 'Empezando mezcla instantánea.';

  @override
  String get anErrorHasOccured => 'Ha ocurrido un error.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Código de estado $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Código de estado $statusCode. Esto posiblemente significa que has usado el nombre de usuario o la contraseña incorrecta, o que tu cliente ya no está autenticado.';
  }

  @override
  String get removeFromMix => 'Eliminar de la mezcla';

  @override
  String get addToMix => 'Añadir a la mezcla';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redescargados $count elementos',
      one: 'Redescargado $count elemento',
      zero: 'No hace falta volver a descargar nada.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Duración del búfer';

  @override
  String get bufferDurationSubtitle => 'Cuánto debe almacenar en el búfer el reproductor, en segundos. Requiere un reinicio.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Don\'t limit buffer size';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.';

  @override
  String get bufferSizeTitle => 'Buffer Size';

  @override
  String get bufferSizeSubtitle => 'The maximum size of the buffer in MB. Requires a restart';

  @override
  String get language => 'Idioma';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Skip to beginning or to previous track';

  @override
  String get skipToNextTrackButtonTooltip => 'Skip to next track';

  @override
  String get togglePlaybackButtonTooltip => 'Toggle playback';

  @override
  String get previousTracks => 'Previous Tracks';

  @override
  String get nextUp => 'Next Up';

  @override
  String get clearNextUp => 'Clear Next Up';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Playing from';

  @override
  String get playNext => 'Reproducir la siguiente';

  @override
  String get addToNextUp => 'Add to Next Up';

  @override
  String get shuffleNext => 'Shuffle next';

  @override
  String get shuffleToNextUp => 'Shuffle to Next Up';

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
  String get placeholderSource => 'Somewhere';

  @override
  String get playbackHistory => 'Playback History';

  @override
  String get shareOfflineListens => 'Share offline listens';

  @override
  String get yourLikes => 'Your Likes';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
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
        'other': '',
      },
    );
    return 'Playing From $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Shuffle All';

  @override
  String get playbackOrderLinearButtonLabel => 'Playing in order';

  @override
  String get playbackOrderLinearButtonTooltip => 'Playing in order. Tap to shuffle.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Shuffling tracks';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Shuffling tracks. Tap to play in order.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Playing at x$speed speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'x$speed speed';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Decrease playback speed';

  @override
  String get playbackSpeedIncreaseLabel => 'Increase playback speed';

  @override
  String get loopModeNoneButtonLabel => 'Not looping';

  @override
  String get loopModeOneButtonLabel => 'Looping this track';

  @override
  String get loopModeAllButtonLabel => 'Looping all';

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
  String get confirm => 'Confirmar';

  @override
  String get close => 'Close';

  @override
  String get showUncensoredLogMessage => 'Este registro contiene tu información de acceso. ¿Mostrar?';

  @override
  String get resetTabs => 'Restablecer las pestañas';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get noMusicLibrariesTitle => 'Sin bibliotecas de música';

  @override
  String get noMusicLibrariesBody => 'Finamp no ha podido encontrar ninguna biblioteca de música. Asegúrate de que tu servidor Jellyfin contiene al menos una biblioteca con el tipo de \"Música\".';

  @override
  String get refresh => 'REFRESCAR';

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
  String get swipeInsertQueueNext => 'Reproducir la siguiente canción al deslizarla';

  @override
  String get swipeInsertQueueNextSubtitle => 'Permite insertar una canción como siguiente elemento en la cola cuando se desliza en la lista de reproducción en lugar de añadirla al final.';

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
  String get activeDownloadSize => 'Downloading...';

  @override
  String get missingDownloadSize => 'Deleting...';

  @override
  String get syncingDownloadSize => 'Syncing...';

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
  String get showLyricsScreenAlbumPreludeTitle => 'Show album before lyrics';

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
}
