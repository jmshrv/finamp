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
  String get finampTagline => 'Un reproductor de música de código abierto para Jellyfin';

  @override
  String startupError(String error) {
    return '¡Algo ha salido mal en el arranque de la aplicación! El error es: $error\n\nPor favor crea una incidencia en github.com/UnicornsOnLSD/finamp con una captura de pantalla de esta página. Si el problema persiste, borra los datos de la aplicación para resetearla.';
  }

  @override
  String get about => 'Acerca de Finamp';

  @override
  String get aboutContributionPrompt => 'Creado por gente increíble en su tiempo libre.\nTu podrías ser uno de ellos!';

  @override
  String get aboutContributionLink => 'Contribuye al repositorio de Finamp en GitHub:';

  @override
  String get aboutReleaseNotes => 'Lee los cambios de la ultima actualización:';

  @override
  String get aboutTranslations => 'Ayúdanos a traducir Finamp a tu idioma:';

  @override
  String get aboutThanks => 'Muchas gracias por usar Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Bienvenido a';

  @override
  String get loginFlowSlogan => 'Tu música, en la manera que tu quieras.';

  @override
  String get loginFlowGetStarted => 'Empieza!';

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
  String get internalExternalIpExplanation => 'Si quieres acceder a tu servidor Jellyfin de forma remota, tendrás que usar tu dirección IP externa.\n\nSi tu servidor está en un puerto HTTP predeterminado (80/443) o el predefinido de Jellyfin (8096), no tendrás que especificar el puerto.\n\nSi la dirección es correcta, deberías ver la información sobre el servidor resaltado debajo.';

  @override
  String get serverUrlHint => 'ej. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Ayuda sobre la URL del servidor';

  @override
  String get emptyServerUrl => 'La URL del servidor no puede estar vacia';

  @override
  String get connectingToServer => 'Conectándose al servidor…';

  @override
  String get loginFlowLocalNetworkServers => 'Servidores en tu red local:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Buscando servidores…';

  @override
  String get loginFlowAccountSelectionHeading => 'Selecciona tu cuenta';

  @override
  String get backToServerSelection => 'Volver a la selección de servidores';

  @override
  String get loginFlowNamelessUser => 'Usuario sin nombre';

  @override
  String get loginFlowCustomUser => 'Usuario personalizado';

  @override
  String get loginFlowAuthenticationHeading => 'Inicia sesión en tu cuenta';

  @override
  String get backToAccountSelection => 'Volver a la selección de cuentas';

  @override
  String get loginFlowQuickConnectPrompt => 'Usar código de Inicio de Sesión Rápido';

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
  String get appearsOnAlbums => 'Appears On';

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
  String get albumArtists => 'Album Artists';

  @override
  String get performingArtists => 'Performing Artists';

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
  String get activeDownloads => 'Descargas Activas';

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
  String get specialDownloads => 'Descargas especiales';

  @override
  String get libraryDownloads => 'Library downloads';

  @override
  String get noItemsDownloaded => 'Sin elementos descargados.';

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
      other: '$count Pistas',
      one: '$count Pista',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargadas',
      one: 'Descargada',
    );
    return '$_temp0, $downloads $_temp1';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pistas',
      one: '$count Pista',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargadas',
      one: 'Descargada',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get editPlaylistNameTooltip => 'Editar el nombre de la lista de reproducción';

  @override
  String get editPlaylistNameTitle => 'Modificar el nombre de la lista de reproducción';

  @override
  String get required => 'Requerido';

  @override
  String get updateButtonLabel => 'Actualizar';

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
  String get playbackReporting => 'Playback reporting & Play On';

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
  String get pathReturnSlashErrorMessage => 'No se pueden utilizar ubicaciones que devuelvan \"/\"';

  @override
  String get directoryMustBeEmpty => 'El directorio debe estar vacío';

  @override
  String get customLocationsBuggy => 'Las ubicaciones personalizadas pueden ser extremadamente problemáticas, y no son recomendadas para la mayoría de usos. Ubicaciones dentro de la carpeta del sistema \"Música\" podría impedir que las imágenes de los álbumes se guarden debido a limitaciones del sistema operativo.';

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
  String get customizationSettingsTitle => 'Personalización';

  @override
  String get playbackSpeedControlSetting => 'Visibilidad de la Velocidad de Reproducción';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Habilita o deshabilita que los controles de velocidad de reproducción se muestren en el menú de la pantalla del reproductor';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automático:\nFinamp intentara identificar si la pista que se esta reproduciendo es un podcast o (parte de) un audiolibro. Se considera que lo son si la duración de la pista es mayor a $trackDuration minutes, si la longitud del álbum de la pista es mayor a $albumDuration horas, o si la pista tiene al menor uno de estos géneros asignados: $genreList\nLos controles de velocidad de reproducción se mostraran en el menú del reproductor.\n\nVisible:\nLos controles de velocidad de reproducción siempre se mostraran en el menú del reproductor.\n\nOculto:\nLos controles de velocidad de reproducción siempre se ocultaran en el menú del reproductor.';
  }

  @override
  String get automatic => 'Automático';

  @override
  String get shown => 'Visible';

  @override
  String get hidden => 'Oculto';

  @override
  String get speed => 'Velocidad';

  @override
  String get reset => 'Restaurar';

  @override
  String get apply => 'Aplicar';

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
    return 'Cantidad de columnas usadas por fila cuando el dispositivo está en $value.';
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
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Margen mínimo en la portada del álbum';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'El margen mínimo alrededor de la portada del álbum en la pantalla del reproductor, en % del ancho de la pantalla.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Ocultar los artistas de canciones si son los mismos que los artistas del álbum';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Oculta a los artistas de las canciones en la pantalla del álbum si no son diferentes de los artistas del álbum.';

  @override
  String get showArtistsTopTracks => 'Mostrar las pistas más populares en la vista del artista';

  @override
  String get showArtistsTopTracksSubtitle => 'Muestra las 5 pistas más escuchadas de un artista.';

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
  String get playerScreen => 'Pantalla del Reproductor';

  @override
  String get cancelSleepTimer => '¿Cancelar el temporizador de sueño?';

  @override
  String get yesButtonLabel => 'Sí';

  @override
  String get noButtonLabel => 'No';

  @override
  String get setSleepTimer => 'Ajustar temporizador de sueño';

  @override
  String get hours => 'Horas';

  @override
  String get seconds => 'Segundos';

  @override
  String get minutes => 'Minutos';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime de $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Pista $currentTrackIndex de $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get sleepTimerTooltip => 'Temporizador de sueño';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Durmiendo en $time minutos';
  }

  @override
  String get addToPlaylistTooltip => 'Añadir a lista de reproducción';

  @override
  String get addToPlaylistTitle => 'Agregar a lista de reproducción';

  @override
  String get addToMorePlaylistsTooltip => 'Añadir a más listas de reproducción';

  @override
  String get addToMorePlaylistsTitle => 'Añadir a Más Listas de Reproducción';

  @override
  String get removeFromPlaylistTooltip => 'Eliminar de la lista de reproducción';

  @override
  String get removeFromPlaylistTitle => 'Borrar de la lista de reproducción';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Eliminar de la lista de reproducción \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Eliminar de la Lista de Reproducción \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nueva lista';

  @override
  String get createButtonLabel => 'Crear';

  @override
  String get playlistCreated => 'Se creó la lista.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Toque para añadir a lista de reproducción. Toque largo para alternar favorito.';

  @override
  String get noAlbum => 'Sin álbum';

  @override
  String get noItem => 'Ningún elemento';

  @override
  String get noArtist => 'Sin artista';

  @override
  String get unknownArtist => 'Artista desconocido';

  @override
  String get unknownAlbum => 'Álbum Desconocido';

  @override
  String get playbackModeDirectPlaying => 'Reproducción Directa';

  @override
  String get playbackModeTranscoding => 'Transcodificación';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Reproducción Local';

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
  String get goToArtist => 'Ir al artista';

  @override
  String get goToGenre => 'Ir al género';

  @override
  String get removeFavourite => 'Eliminar favorito';

  @override
  String get addFavourite => 'Añadir favorito';

  @override
  String get confirmFavoriteAdded => 'Favorito Añadido';

  @override
  String get confirmFavoriteRemoved => 'Favorito Eliminado';

  @override
  String get addedToQueue => 'Añadido a la cola.';

  @override
  String get insertedIntoQueue => 'Insertado en la cola.';

  @override
  String get queueReplaced => 'Se reemplazó la cola.';

  @override
  String get confirmAddedToPlaylist => 'Añadida a la lista de reproducción.';

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
  String get bufferDurationSubtitle => 'Máximo tiempo, en segundos, que el búfer puede almacenar. Requiere de un reinicio.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'No limitar el tamaño del búfer';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Deshabilita las limitantes del tamaño del búfer (\'Tamaño del Búfer\'). El búfer siempre sera cargado con la duración configurada (\'Duración del Búfer\'), incluso para archivos grandes. Puede causar fallos. Requiere reinicio.';

  @override
  String get bufferSizeTitle => 'Tamaño del Búfer';

  @override
  String get bufferSizeSubtitle => 'El tamaño máximo para el búfer en MB. Requiere reinicio';

  @override
  String get language => 'Idioma';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Saltar al inicio o a la pista anterior';

  @override
  String get skipToNextTrackButtonTooltip => 'Saltar a la siguiente pista';

  @override
  String get togglePlaybackButtonTooltip => 'Alternar reproducción';

  @override
  String get previousTracks => 'Pistas Anteriores';

  @override
  String get nextUp => 'A Continuación';

  @override
  String get clearNextUp => 'Limpiar \"A Continuación\"';

  @override
  String get playingFrom => 'Reproduciendo desde';

  @override
  String get playNext => 'Reproducir siguiente';

  @override
  String get addToNextUp => 'Añadir a \"A Continuación\"';

  @override
  String get shuffleNext => 'Mezclar en \"A Continuación\"';

  @override
  String get shuffleToNextUp => 'Mezclar al final de \"A Continuación\"';

  @override
  String get shuffleToQueue => 'Mezclar en cola';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Pista',
        'album': 'Álbum',
        'artist': 'Artista',
        'playlist': 'Lista de Reproducción',
        'genre': 'Género',
        'other': 'Elemento',
      },
    );
    return '$_temp0 se reproducirá a continuación';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Pista',
        'album': 'álbum',
        'artist': 'artista',
        'playlist': 'lista de reproducción',
        'genre': 'género',
        'other': 'elemento',
      },
    );
    return 'Añadida $_temp0 a \"A Continuación\"';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'pista',
        'album': 'álbum',
        'artist': 'artista',
        'playlist': 'lista de reproducción',
        'genre': 'género',
        'other': 'elemento',
      },
    );
    return 'Añadida $_temp0 a la cola';
  }

  @override
  String get confirmShuffleNext => 'Mezclara en \"A Continuación\"';

  @override
  String get confirmShuffleToNextUp => 'Mezclado en \"A Continuación\"';

  @override
  String get confirmShuffleToQueue => 'Mezclado en cola';

  @override
  String get placeholderSource => 'En algún lugar';

  @override
  String get playbackHistory => 'Historial de Reproducción';

  @override
  String get shareOfflineListens => 'Compartir escuchas sin conexión';

  @override
  String get yourLikes => 'Sus Me Gusta';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Pistas añadidas a través de \"A Continuación\"';

  @override
  String get savedQueue => 'Cola Guardada';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'Álbum',
        'playlist': 'Lista de Reproducción',
        'trackMix': 'Mix de Pista',
        'artistMix': 'Mix de Artista',
        'albumMix': 'Mix de Álbum',
        'genreMix': 'Mix de Género',
        'favorites': 'Favoritos',
        'allTracks': 'Todas las Pistas',
        'filteredList': 'Pistas',
        'genre': 'Género',
        'artist': 'Artista',
        'track': 'Pista',
        'nextUpAlbum': 'Álbum en \"A Continuación\"',
        'nextUpPlaylist': 'Lista de Reproducción en \"A Continuación\"',
        'nextUpArtist': 'Artista en \"A Continuación\"',
        'other': '',
      },
    );
    return 'Reproduciendo Desde $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Mezclar Todo';

  @override
  String get playbackOrderLinearButtonLabel => 'Reproduciendo en orden';

  @override
  String get playbackOrderLinearButtonTooltip => 'Reproduciendo en orden. Toque para mezclar.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Mezclando pistas';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Mezclando pistas, toque para reproducir en orden.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Reproduciendo a velocidad x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'velocidad x$speed';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volume';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Disminuir la velocidad de reproducción';

  @override
  String get playbackSpeedIncreaseLabel => 'Aumentar la velocidad de reproducción';

  @override
  String get loopModeNoneButtonLabel => 'Sin repetir';

  @override
  String get loopModeOneButtonLabel => 'Repitiendo esta pista';

  @override
  String get loopModeAllButtonLabel => 'Repitiendo todo';

  @override
  String get queuesScreen => 'Restaurar Reproduciendo Ahora';

  @override
  String get queueRestoreButtonLabel => 'Restaurar';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Guardada $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Reproduciendo: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pistas',
      one: '1 Pista',
    );
    return '$_temp0, $remaining Sin Reproducir';
  }

  @override
  String get queueLoadingMessage => 'Restaurando cola…';

  @override
  String get queueRetryMessage => 'Hubo un fallo al restaurar cola. ¿Reintentar?';

  @override
  String get autoloadLastQueueOnStartup => 'Restaurar Automáticamente Ultima Cola';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Al iniciar la aplicación, intentar restaurar la ultima cola reproducida.';

  @override
  String get reportQueueToServer => '¿Reportar la cola actual al servidor?';

  @override
  String get reportQueueToServerSubtitle => 'Mientras esté activo, Finamp enviará la cola del dispositivo al servidor. De momento esta funcionalidad no tiene mucho uso y aumenta el tráfico al servidor.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Frecuencia para actualizar la sesión de reproducción';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Cada cuantos segundo enviar el estado de la reproducción al servidor. Este tiene que ser menor que 5 minutos (300 segundos) para evitar que la sesión se acabe.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Si el servidor de Jellyfin no ha recibido no ha recibido ninguna actualización de estado del cliente en los últimos 5 minutos, este asume que la reproducción ha acabado. Esto significa que para canciones más largas de 5 minutos, la reproducción se puede dar como acabada, lo cual empeoraría la información sobra la calidad de reproducción.';

  @override
  String get playOnStaleDelay => '\'Play On\' Session Timeout';

  @override
  String get playOnStaleDelaySubtitle => 'How long a remote \'Play On\' session is considered active after receiving a command. When considered active, playback is reported more frequently, which can lead to increased bandwidth usage.';

  @override
  String get enablePlayonTitle => 'Enable \'Play On\' Support';

  @override
  String get enablePlayonSubtitle => 'Enables Jellyfin\'s \'Play On\' feature (remote-controlling Finamp from another client). Disable this if your reverse proxy or server doesn\'t support websockets.';

  @override
  String get playOnReconnectionDelay => '\'Play On\' Session Reconnection Delay';

  @override
  String get playOnReconnectionDelaySubtitle => 'Controls the delay between the attempts to reconnect to the PlayOn websocket when it gets disconnected (in seconds). A lower delay increases bandwidth usage.';

  @override
  String get topTracks => 'Canciones más reproducidas';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Álbumes',
      one: '$count Álbum',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Mezclar álbumes';

  @override
  String get shuffleAlbumsNext => 'Mezclar Álbumes en \"A Continuación\"';

  @override
  String get shuffleAlbumsToNextUp => 'Mezclar Álbumes al final de \"A Continuación\"';

  @override
  String get shuffleAlbumsToQueue => 'Mezclar Álbumes al final de la Cola';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount reproducciones',
      one: '$playCount reproducciones',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'álbum',
        'playlist': 'lista de reproducción',
        'trackMix': 'mix de pista',
        'artistMix': 'mix de artista',
        'albumMix': 'mix de álbum',
        'genreMix': 'mix de género',
        'favorites': 'favoritos',
        'allTracks': 'todas las pistas',
        'filteredList': 'pistas',
        'genre': 'género',
        'artist': 'artista',
        'track': 'pista',
        'nextUpAlbum': 'álbum en \"a continuación\"',
        'nextUpPlaylist': 'lista de reproducción en \"a continuación\"',
        'nextUpArtist': 'artista en \"a continuación\"',
        'other': '',
      },
    );
    return 'No fue posible cargar $_temp0';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Cerrar';

  @override
  String get showUncensoredLogMessage => 'Este registro contiene tu información de acceso. ¿Mostrar?';

  @override
  String get resetTabs => 'Restablecer las pestañas';

  @override
  String get resetToDefaults => 'Restaurar a lo predeterminado';

  @override
  String get noMusicLibrariesTitle => 'Sin bibliotecas de música';

  @override
  String get noMusicLibrariesBody => 'Finamp no ha podido encontrar ninguna biblioteca de música. Asegúrate de que tu servidor Jellyfin contiene al menos una biblioteca con el tipo de \"Música\".';

  @override
  String get refresh => 'Refrescar';

  @override
  String get moreInfo => 'Más información';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalización de volumen';

  @override
  String get playbackReportingSettingsTitle => 'Playback reporting & Play On';

  @override
  String get volumeNormalizationSwitchTitle => 'Activar normalización de volumen';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Usar la información de la ganancia para normalizar el volumen de las canciones (\"Ganancia de Reproducción\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Modo de normalización de volumen';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Cuando y como aplicar la Normalización de Volumen';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Híbrido (Canción + Álbum):\nGanancia de la canción usada para la reproducción normal, pero si un álbum esta siendo reproducido (ya este siendo la principal fuente de reproducción, o porque se ha añadido en algún momento a la cola de reproducción), la ganancia del álbum va a ser usada.\n\nBasado en la canción:\nGanancia de las canciones usada, independientemente de si se está reproduciendo de un álbum o no.\n\nSolo álbumes:\nNormalización del volumen aplicada solo cuando se están reproduciendo álbumes (usando la ganancia de dicho álbum), pero no para canciones individuales.';

  @override
  String get volumeNormalizationModeHybrid => 'Híbrido (Canción + Álbum)';

  @override
  String get volumeNormalizationModeTrackBased => 'Basado en la canción';

  @override
  String get volumeNormalizationModeAlbumBased => 'Solo álbumes';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Solo para álbumes';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Ganancia base';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Actualmente, La normalización de volumen en iOS requiere cambiar el volumen de reproducción para emular el cambio de ganancia. Ya que no podemos aumentar el volumen por encima del 100%, necesitamos disminuirlo por defecto para poder potenciar el volumen en pistas con bajo volumen. El valor es en decibelios (dB), donde -10 dB es el ~30% del volumen, -4.5 dB es el ~60% del volumen y -2 dB es el ~80% del volumen.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Reproducir la siguiente canción al deslizarla';

  @override
  String get swipeInsertQueueNextSubtitle => 'Permite insertar una canción como próxima en ser reproducida de la cola cuando se desliza a un lado en la lista de reproducción, en lugar de añadirla al final.';

  @override
  String get swipeLeftToRightAction => 'Swipe to Right Action';

  @override
  String get swipeLeftToRightActionSubtitle => 'Action triggered when swiping a track in the list from left to right.';

  @override
  String get swipeRightToLeftAction => 'Swipe to Left Action';

  @override
  String get swipeRightToLeftActionSubtitle => 'Action triggered when swiping a track in the list from right to left.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Iniciar Mixes Instantáneos para Pistas Individuales';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Al habilitarlo, tocar en una pista en la pestaña de canciones comenzara un mix instantáneo de esa pista en lugar de reproducir una sola pista.';

  @override
  String get downloadItem => 'Descargar';

  @override
  String get repairComplete => 'Reparación de Descargas completada.';

  @override
  String get syncComplete => 'Todas las descargas se han resincronizado.';

  @override
  String get syncDownloads => 'Sincronizar y descargar elementos faltantes.';

  @override
  String get repairDownloads => 'Reparar problemas con los archivos descargados o metadatos.';

  @override
  String get requireWifiForDownloads => 'Descargar solo con WiFi.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '$count pista',
    );
    return 'Advertencia: $_temp0 no pudieron ser restauradas a la cola.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Ejecutando',
        'failed': 'Fallida',
        'syncFailed': 'Repetidamente De-sincronizada',
        'enqueued': 'Añadida a la Cola',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Descargas',
      one: 'Descarga',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return '¿Esta seguro que quiere descargar todo el contenido de la biblioteca \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Mostrar solo álbumes completamente descargados';

  @override
  String get filesystemFull => 'El resto de descargas pendientes no han podido ser completadas. El almacenamiento está completo.';

  @override
  String get connectionInterrupted => 'Conexión interrumpida, pausando las descargas.';

  @override
  String get connectionInterruptedBackground => 'La conexión ha sido interrumpida mientras se continuaban de fondo las descargas. Esto puede haber sido causado por configuraciones del sistema.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'La conexión ha sido interrumpida mientras se continuaban de fondo las descargas. Esto puede haber sido causado por tener activado \'Comenzar Modo-de-Baja Prioridad mientras está Pausado\' en la configuración del sistema.';

  @override
  String get activeDownloadSize => 'Descargando…';

  @override
  String get missingDownloadSize => 'Borrando…';

  @override
  String get syncingDownloadSize => 'Sincronizando…';

  @override
  String get runRepairWarning => 'El servidor no pudo ser contactado para finalizar la migración de descargas. Por favor ejecute \'Reparar Descargas\' desde la pantalla de descargas tan pronto como este en linea.';

  @override
  String get downloadSettings => 'Descargas';

  @override
  String get showNullLibraryItemsTitle => 'Mostrar multimedia de una Biblioteca Desconocida.';

  @override
  String get showNullLibraryItemsSubtitle => 'Alguna multimedia se puede descargar desde una biblioteca desconocida. Desactive para ocultarla fuera de su colección original.';

  @override
  String get maxConcurrentDownloads => 'Descargas Concurrentes Máximas';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Aumentar las descargas concurrentes puede ocasionar que una mayor cantidad de descargas fallen si son demasiado grandes, o puede ocasionar retraso en algunas ocasiones.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Descargas Concurrentes';
  }

  @override
  String get downloadsWorkersSetting => 'Cantidad de Gestores de Descargas';

  @override
  String get downloadsWorkersSettingSubtitle => 'La cantidad de gestores para sincronizar los metadatos y eliminar descargas. Aumentar los gestores de sincronización y eliminación de descargas puede mejorar la velocidad, especialmente cuando la latencia del servidor es alta, pero también puede producir retraso.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Gestores de Descarga';
  }

  @override
  String get syncOnStartupSwitch => 'Automáticamente Sincronizar Descargas al Inicio';

  @override
  String get preferQuickSyncSwitch => 'Preferir Sincronizaciones Rápidas';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Al realizar sincronizaciones, algunos elementos usualmente estáticos (como pistas y álbumes) no serán actualizados. La reparación de descargas siempre realizara una sincronización completa.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Álbum',
        'playlist': 'Lista de Reproducción',
        'artist': 'Artista',
        'genre': 'Género',
        'track': 'Pista',
        'library': 'Biblioteca',
        'unknown': 'Elemento',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return '$parentName requiere que este elemento sea descargado.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Favoritos',
        'allPlaylists': 'Todas las Listas de Reproducción',
        'fiveLatestAlbums': 'Los Últimos 5 Álbumes',
        'allPlaylistsMetadata': 'Metadatos de la Lista de Reproducción',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Imágenes almacenadas en cache para \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle => 'Select Transcoding Format';

  @override
  String get transcodingStreamingFormatSubtitle => 'Select the format to use when streaming transcoded audio. Already queued tracks will not be affected.';

  @override
  String get downloadTranscodeEnableTitle => 'Habilitar Descargas Transcodificadas';

  @override
  String get downloadTranscodeCodecTitle => 'Selecciona el Códec de Descarga';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Siempre',
        'never': 'Nunca',
        'ask': 'Preguntar',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Tasa de bits al Descargar';

  @override
  String get downloadBitrateSubtitle => 'Una mayor tasa de bits da una mejor calidad de audio a costa de mayor requerimientos de almacenamiento.';

  @override
  String get transcodeHint => '¿Transcodificar?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Descargar como $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transcodificado',
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
        'other': ' como $codec @ $bitrate',
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
    return 'Descargar original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Cola de Transcodificaciones a Volver a Descargar.';

  @override
  String get redownloadTitle => 'Automáticamente Volver a Descargar Transcodificaciones';

  @override
  String get redownloadSubtitle => 'Automáticamente vuelve a descargar pistas que se esperan en una calidad diferente debido a cambios en su colección de origen.';

  @override
  String get defaultDownloadLocationButton => 'Seleccionar como ubicación de descarga por defecto  Desactive para elegirla al descargar.';

  @override
  String get fixedGridSizeSwitchTitle => 'Utilizar un tamaño fijo para las cuadriculas';

  @override
  String get fixedGridSizeSwitchSubtitle => 'El tamaño de las cuadriculas no reaccionara al tamaño de la ventana/pantalla.';

  @override
  String get fixedGridSizeTitle => 'Tamaño de las Cuadriculas';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Pequeña',
        'medium': 'Mediana',
        'large': 'Grande',
        'veryLarge': 'Muy Grande',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Permitir el Modo de Pantalla Dividida';

  @override
  String get allowSplitScreenSubtitle => 'El reproductor sera mostrado junto a otras ventanas en pantallas más grandes.';

  @override
  String get enableVibration => 'Habilitar vibración';

  @override
  String get enableVibrationSubtitle => 'Habilita o deshabilita la vibración.';

  @override
  String get hideQueueButton => 'Ocultar botón de cola';

  @override
  String get hideQueueButtonSubtitle => 'Oculte el botón de cola en la pantalla del reproductor. Deslice hacia arriba para acceder a la cola.';

  @override
  String get oneLineMarqueeTextButton => 'Auto Desplazar Títulos Largos';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Automáticamente desplaza los títulos de las pistas que sean demasiado largos para mostrar en dos lineas';

  @override
  String get marqueeOrTruncateButton => 'Utilizar puntos suspensivos para títulos largos';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Mostrar ... al final de los títulos largos en lugar de desplazar el texto';

  @override
  String get hidePlayerBottomActions => 'Ocultar acciones de la parte inferior';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Oculte los botones de cola y letras en la pantalla del reproductor. Deslice hacia arriba para acceder a la cola, deslice hacia la izquierda (debajo de la cáratula del álbum) para ver la letra si esta disponible.';

  @override
  String get prioritizePlayerCover => 'Darle prioridad a la carátula del álbum';

  @override
  String get prioritizePlayerCoverSubtitle => 'Priorizar mostrar una cáratula de álbum más grande en la pantalla del reproductor. Los controles que no sean esenciales serán ocultados de manera mas agresiva en pantallas pequeñas.';

  @override
  String get suppressPlayerPadding => 'Ignorar el margen de los controles del reproductor';

  @override
  String get suppressPlayerPaddingSubtitle => 'Completamente minimiza los margenes entre los controles de la pantalla del reproductor cuando la cáratula del álbum no esta en tamaño completo.';

  @override
  String get lockDownload => 'Siempre Mantener en el Dispositivo';

  @override
  String get showArtistChipImage => 'Mostrar imágenes del artista junto al nombre del artista';

  @override
  String get showArtistChipImageSubtitle => 'Esto afecta las pequeñas vistas previas de los artistas, como en la pantalla del reproductor.';

  @override
  String get scrollToCurrentTrack => 'Desplazar a la pista actual';

  @override
  String get enableAutoScroll => 'Activar desplazamiento automático';

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
    return '$duration restante';
  }

  @override
  String get removeFromPlaylistConfirm => 'Eliminar';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return '¿Quitar \'$itemName\' de la lista de reproducción \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Menú de la Pista';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get addRemoveFromPlaylist => 'Añadir / Quitar de Lista de Reproducción';

  @override
  String get addPlaylistSubheader => 'Añadir pista a lista de reproducción';

  @override
  String get trackOfflineFavorites => 'Sincronizar el estado de todos los favoritos';

  @override
  String get trackOfflineFavoritesSubtitle => 'Esto permite mostrar estados de favoritos mas actualizados cuando se este sin conexión.  No se descarga ningún archivo adicional.';

  @override
  String get allPlaylistsInfoSetting => 'Descargar Metadatos de la Lista de Reproducción';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Sincronizar los metadatos de todas las listas de reproducción para mejorar su experiencia al utilizarlas';

  @override
  String get downloadFavoritesSetting => 'Descargar todos los favoritos';

  @override
  String get downloadAllPlaylistsSetting => 'Descargar todas las listas de reproducción';

  @override
  String get fiveLatestAlbumsSetting => 'Descargar los últimos 5 álbumes';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Las descargas serán eliminadas conforme envejezcan.  Bloquee la descarga para prevenir que el álbum sea eliminado.';

  @override
  String get cacheLibraryImagesSettings => 'Guardar las imágenes de la biblioteca actual en el caché';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Todas las carátulas de álbumes, artistas, géneros, y listas de reproducción de la biblioteca activa serán descargadas.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Mostrar el progreso de la pista en el mini reproductor de la aplicación';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Controla que el mini reproductor de la aplicación / la barra de reproduciendo ahora en la parte inferior de la pantalla de musica funcionen como una barra de progreso.';

  @override
  String get lyricsScreenButtonTitle => 'Lyrics';

  @override
  String get lyricsScreen => 'Ventana de Letras';

  @override
  String get showLyricsTimestampsTitle => 'Muestra las marcas de tiempo para las letras sincronizadas';

  @override
  String get showLyricsTimestampsSubtitle => 'Controla que las marcas de tiempo sean mostradas en cada linea de las letras en la pantalla de letras, si están disponibles.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Mostrar el botón de detener en la notificación multimedia';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Controla que la notificación multimedia tenga un botón de detener además del botón de pausa. Esto detendrá la reproducción sin abrir la aplicación.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Muestra controles de posición en la notificación multimedia';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Controla que la notificación multimedia tenga una barra de progreso interactiva. Esto permitirá cambiar la posición de la reproducción sin abrir la aplicación.';

  @override
  String get alignmentOptionStart => 'Al inicio';

  @override
  String get alignmentOptionCenter => 'En medio';

  @override
  String get alignmentOptionEnd => 'Al final';

  @override
  String get fontSizeOptionSmall => 'Pequeña';

  @override
  String get fontSizeOptionMedium => 'Mediana';

  @override
  String get fontSizeOptionLarge => 'Grande';

  @override
  String get lyricsAlignmentTitle => 'Alineación de las Letras';

  @override
  String get lyricsAlignmentSubtitle => 'Controla la alineación de las letras en la pantalla de letras.';

  @override
  String get lyricsFontSizeTitle => 'Tamaño de la fuente para las letras';

  @override
  String get lyricsFontSizeSubtitle => 'Controla el tamaño de la fuente para las letras en la pantalla de letras.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Muestra la carátula antes de las letras';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Controla que la carátula se muestre encima de las letras antes de desplazarlas.';

  @override
  String get keepScreenOn => 'Mantener la Pantalla Encendida';

  @override
  String get keepScreenOnSubtitle => 'Cuando mantener la pantalla encendida';

  @override
  String get keepScreenOnDisabled => 'Desactivado';

  @override
  String get keepScreenOnAlwaysOn => 'Siempre Encendida';

  @override
  String get keepScreenOnWhilePlaying => 'Mientras se Reproduce Música';

  @override
  String get keepScreenOnWhileLyrics => 'Mientras se Muestran Letras';

  @override
  String get keepScreenOnWhilePluggedIn => 'Mantener la Pantalla Encendida solo mientras este enchufado';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignorar el ajuste de Mantener la Pantalla Encendida si el dispositivo esta desenchufado';

  @override
  String get genericToggleButtonTooltip => 'Toque para alternar.';

  @override
  String get artwork => 'Carátula';

  @override
  String artworkTooltip(String title) {
    return 'Arte de $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Carátula de $title. Toque para alternar reproducción. Deslice hacia la izquierda o derecha para cambiar pistas.';
  }

  @override
  String get nowPlayingBarTooltip => 'Abrir Ventana del Reproductor';

  @override
  String get additionalPeople => 'Personas';

  @override
  String get playbackMode => 'Modo de Reproducción';

  @override
  String get codec => 'Códec';

  @override
  String get bitRate => 'Tasa de Bits';

  @override
  String get bitDepth => 'Profundidad de Bits';

  @override
  String get size => 'Tamaño';

  @override
  String get normalizationGain => 'Ganancia';

  @override
  String get sampleRate => 'Tasa de Muestreo';

  @override
  String get showFeatureChipsToggleTitle => 'Mostrar Información Avanzada';

  @override
  String get showFeatureChipsToggleSubtitle => 'Mostrar información avanzada de la pista como el códec, tasa de bits y más en la pantalla del reproductor.';

  @override
  String get albumScreen => 'Ventana del Álbum';

  @override
  String get showCoversOnAlbumScreenTitle => 'Mostrar Arte de Álbumes en las Canciones';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Mostrar carátulas de álbumes por cada pista independientemente de la pantalla del álbum.';

  @override
  String get emptyTopTracksList => 'No has escuchado a ninguna pista de este artista aun.';

  @override
  String get emptyFilteredListTitle => 'Ningún elemento encontrado';

  @override
  String get emptyFilteredListSubtitle => 'Ningún elemento coincide con el filtro. Intente desactivar los filtros o cambiar el termino de búsqueda.';

  @override
  String get resetFiltersButton => 'Restaurar filtros';

  @override
  String get resetSettingsPromptGlobal => '¿Esta seguro que quiere restaurar TODOS los ajustes a sus valores predeterminados?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Restaurar TODOS los ajustes';

  @override
  String get resetSettingsPromptLocal => '¿Quieres restaurar estos ajustes a sus valores predeterminados?';

  @override
  String get genericCancel => 'Cancelar';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Álbum',
        'playlist': 'Lista de Reproducción',
        'artist': 'Artista',
        'genre': 'Género',
        'track': 'Pista',
        'library': 'Biblioteca',
        'other': 'Elemento',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'Dispositivo',
        'server': 'Servidor',
        'other': 'desconocido',
      },
    );
    return '$_temp0 fue eliminado del $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Permitir la eliminación del servidor';

  @override
  String get allowDeleteFromServerSubtitle => 'Habilita y deshabilita la opción de eliminar de forma permanente una pista del sistema de archivos del servidor cuando sea posible.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'álbum',
        'playlist': 'lista de reproducción',
        'artist': 'artista',
        'genre': 'género',
        'track': 'pista',
        'library': 'biblioteca',
        'other': 'elemento',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' Esto también eliminara este elemento de este Dispositivo.',
        'cantDelete': ' Este elemento se mantendrá en este dispositivo hasta la siguiente sincronización.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'este dispositivo',
        'server': 'el sistema de archivos del servidor y la biblioteca.$_temp1\nEsta acción no se puede revertir',
        'other': '',
      },
    );
    return 'Esta por eliminar este $_temp0 de $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' del Dispositivo',
        'server': ' del Servidor',
        'other': '',
      },
    );
    return 'Eliminar$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Advertencia: Esta a punto de descargar $count pistas.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Umbral de Advertencia para Descargas';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'Un mensaje de advertencia sera mostrado al descargar más pistas de las especificadas a la vez.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'álbum',
        'playlist': 'lista de reproducción',
        'artist': 'artista',
        'genre': 'género',
        'other': 'elemento',
      },
    );
    return '¿Esta seguro que quiere agregar todas las pistas desde $_temp0 \'$itemName\' a esta lista de reproducción?  Solo se pueden quitar de manera individual.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Visible Públicamente:';

  @override
  String get releaseDateFormatYear => 'Año';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Mes y Año';

  @override
  String get releaseDateFormatMonthDayYear => 'Mes, Día y Año';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Mostrar Fecha de Lanzamiento de un Álbum en la Pantalla del Reproductor';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Muestra la fecha de lanzamiento de un álbum en la pantalla del reproductor, después del nombre del álbum.';

  @override
  String get releaseDateFormatTitle => 'Formato de Fecha de Lanzamiento';

  @override
  String get releaseDateFormatSubtitle => 'Controla el formato en el que todas las fechas de lanzamiento son mostradas en la aplicación.';

  @override
  String get librarySelectError => 'Error al cargar las librerías disponibles para el usuario';

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

  @override
  String get desktopShuffleWarning => 'Shuffle is not currently available on desktop.';
}
