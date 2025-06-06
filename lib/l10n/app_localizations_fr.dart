// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Un lecteur de musique open source pour Jellyfin';

  @override
  String get startupErrorTitle =>
      'Une erreur s\'est produite au démarrage de l\'application\nDésole pour ça…';

  @override
  String get startupErrorCallToAction =>
      'Veuillez créer un problème sur github.com/jmshrv/finamp avec les logs (!) (utilisez le bouton ci-dessous) et une capture d\'écran de cette page, afin que nous puissions le résoudre le plus rapidement possible.';

  @override
  String get startupErrorWorkaround =>
      'Pour contourner ce problème, vous pouvez effacer les données de votre application pour la réinitialiser. Notez bien que dans ce cas, tous vos paramètres et téléchargements seront supprimés.';

  @override
  String get about => 'À propos de Finamp';

  @override
  String get aboutContributionPrompt =>
      'Créé par des gens géniaux sur leur temps libre.\nVous pouvez les rejoindre !';

  @override
  String get aboutContributionLink => 'Contribuez à Finamp sur GitHub :';

  @override
  String get aboutReleaseNotes => 'Lisez les dernières notes de version :';

  @override
  String get aboutTranslations => 'Aidez à traduire Finamp dans votre langue :';

  @override
  String get aboutThanks => 'Merci d\'utiliser Finamp !';

  @override
  String loginFlowWelcomeHeading(String styledName) {
    return 'Bienvenue sur';
  }

  @override
  String get loginFlowSlogan => 'Votre musique, comme vous la voulez.';

  @override
  String get loginFlowGetStarted => 'C’est parti !';

  @override
  String get viewLogs => 'Voir les logs';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get loginFlowServerSelectionHeading => 'Se connecter à Jellyfin';

  @override
  String get back => 'Retour';

  @override
  String get serverUrl => 'Adresse du serveur';

  @override
  String get internalExternalIpExplanation =>
      'Si vous souhaitez pouvoir accéder à votre serveur Jellyfin à distance, vous devez utiliser votre adresse IP externe.\n\nSi votre serveur utilise les ports HTTP par défaut (80/443) ou le port par défaut de Jellyfin (8096), vous n\'avez pas besoin de spécifier le port. \n\nSi l\'URL est correcte, vous devriez voir apparaître des informations sur votre serveur sous le champ de saisie.';

  @override
  String get serverUrlHint => 'e.g. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Aide sur l’URL du serveur';

  @override
  String get emptyServerUrl => 'Vous devez indiquez l\'adresse du serveur.';

  @override
  String get connectingToServer => 'Connexion au serveur…';

  @override
  String get loginFlowLocalNetworkServers =>
      'Serveurs sur votre réseau local :';

  @override
  String get loginFlowLocalNetworkServersScanningForServers =>
      'Recherche des serveurs…';

  @override
  String get loginFlowAccountSelectionHeading => 'Sélectionnez votre compte';

  @override
  String get backToServerSelection => 'Retour à la sélection du serveur';

  @override
  String get loginFlowNamelessUser => 'Utilisateur anonyme';

  @override
  String get loginFlowCustomUser => 'Utilisateur personnalisé';

  @override
  String get loginFlowAuthenticationHeading => 'Se connecter à votre compte';

  @override
  String get backToAccountSelection => 'Retour à la sélection du compte';

  @override
  String get loginFlowQuickConnectPrompt =>
      'Utiliser un code « Quick Connect »';

  @override
  String get loginFlowQuickConnectInstructions =>
      'Ouvrez l’application ou le site web Jellyfin, cliquez sur votre icône d’utilisateur et sélectionnez « Quick Connect ».';

  @override
  String get loginFlowQuickConnectDisabled =>
      '« Quick Connect » n’est pas activé sur ce serveur.';

  @override
  String get orDivider => 'ou';

  @override
  String get loginFlowSelectAUser => 'Sélectionnez un utilisateur';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameHint => 'Entrez votre nom d’utilisateur';

  @override
  String get usernameValidationMissingUsername =>
      'S’il vous plaît, entrez un nom d’utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Entrez votre mot de passe';

  @override
  String get login => 'Se connecter';

  @override
  String get logs => 'Journaux';

  @override
  String get next => 'Prochain';

  @override
  String get selectMusicLibraries => 'Selectionner des bibliothèques';

  @override
  String get couldNotFindLibraries => 'Aucune bibliothèque trouvée';

  @override
  String get allLibraries => 'All Libraries';

  @override
  String get unknownName => 'Nom inconnu';

  @override
  String get tracks => 'Chansons';

  @override
  String get albums => 'Albums';

  @override
  String get appearsOnAlbums => 'Apparaît dans';

  @override
  String get artists => 'Artistes';

  @override
  String get genres => 'Genres';

  @override
  String get noGenres => 'No Genres';

  @override
  String get playlists => 'Listes de lectures';

  @override
  String get startMix => 'Commencer un Mix';

  @override
  String get startMixNoTracksArtist =>
      'Appuyer longuement sur un artiste pour l\'ajouter ou le retirer du mix avant de commencer';

  @override
  String get startMixNoTracksAlbum =>
      'Appuyer longuement sur un album pour l\'ajouter ou le retirer du mix avant de commencer';

  @override
  String get startMixNoTracksGenre =>
      'Avant de commencer à écouter un mix, appuyez longuement sur un genre pour l’ajouter ou le retirer du créateur de mix';

  @override
  String get music => 'Musique';

  @override
  String get clear => 'Effacer';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get shuffleAll => 'Tout mélanger';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get settings => 'Réglages';

  @override
  String get offlineMode => 'Mode hors-ligne';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get sortOrder => 'Ordre de tri';

  @override
  String get sortBy => 'Trier par';

  @override
  String get title => 'Titre';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Artistes d\'albums';

  @override
  String get albumArtists => 'Artistes de l’album';

  @override
  String get performingArtists => 'Artistes';

  @override
  String get artist => 'Artiste';

  @override
  String get performingArtist => 'Performing Artist';

  @override
  String get budget => 'Budget';

  @override
  String get communityRating => 'Note de la communauté';

  @override
  String get criticRating => 'Note de la critique';

  @override
  String get dateAdded => 'Date d\'ajout';

  @override
  String get datePlayed => 'Date de lecture';

  @override
  String get playCount => 'nombre de lectures';

  @override
  String get premiereDate => 'Date de première';

  @override
  String get productionYear => 'Date de production';

  @override
  String get name => 'Nom';

  @override
  String get random => 'Aléatoire';

  @override
  String get revenue => 'Recettes';

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
  String get syncDownloadedPlaylists =>
      'Synchroniser les playlists téléchargées';

  @override
  String get downloadMissingImages => 'Télécharger les images manquantes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images téléchargées',
      one: '$count image téléchargée',
      zero: 'Pas d\'image manquante',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Téléchargements actifs';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléchargements',
      one: '$count téléchargement',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(
      int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount titres',
      one: '$trackCount titre',
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
      other: '$syncCount noeuds',
      one: '$syncCount noeud syncing',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nReparations en cours',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count achevés',
      one: '$count achevé',
    );
    return '$_temp0';
  }

  @override
  String dlFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count échecs',
      one: '$count échec',
    );
    return '$_temp0';
  }

  @override
  String dlEnqueued(int count) {
    return '$count en attente';
  }

  @override
  String dlRunning(int count) {
    return '$count en cours';
  }

  @override
  String get activeDownloadsTitle => 'Téléchargements actifs';

  @override
  String get noActiveDownloads => 'Pas de téléchargement en cours.';

  @override
  String get errorScreenError =>
      'Une erreur est survenue lors de la récupération de la liste des erreurs ! À ce stade, il serait probablement préférable de créer une issue sur GitHub et de supprimer les données de l\'application.';

  @override
  String get failedToGetTrackFromDownloadId =>
      'La chanson n’a pas pu être récupérée à l’aide de l’ID de téléchargement';

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
    return 'Êtes vous sûr de vouloir supprimer $_temp0 \'$itemName\' de votre appareil ?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Supprimer';

  @override
  String get specialDownloads => 'Téléchargements spéciaux';

  @override
  String get libraryDownloads => 'Téléchargements de la bibliothèque';

  @override
  String get noItemsDownloaded => 'Pas de téléchargements.';

  @override
  String get error => 'Erreur';

  @override
  String discNumber(int number) {
    return 'Disque $number';
  }

  @override
  String get playButtonLabel => 'Lire';

  @override
  String get shuffleButtonLabel => 'Aléatoire';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '$count titre',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '$count titre',
    );
    return '$_temp0, $downloads téléchargé(s)';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '$count titre',
    );
    return '$_temp0 telechargé(s)';
  }

  @override
  String get editPlaylistNameTooltip =>
      'Modifier le nom de la liste de lecture';

  @override
  String get editPlaylistNameTitle => 'Modifier le nom de la liste de lecture';

  @override
  String get required => 'Requis';

  @override
  String get updateButtonLabel => 'Mettre à jour';

  @override
  String get playlistUpdated => 'Nom de la liste de lecture mis à jour.';

  @override
  String get downloadsDeleted => 'Téléchargements supprimés.';

  @override
  String get addDownloads => 'Ajouter les téléchargements';

  @override
  String get location => 'Emplacement';

  @override
  String get confirmDownloadStarted => 'Téléchargement debuté';

  @override
  String get downloadsQueued => 'Téléchargements ajoutés.';

  @override
  String get addButtonLabel => 'Ajouter';

  @override
  String get shareLogs => 'Partager les journaux.';

  @override
  String get exportLogs => 'Enregistrer les journaux';

  @override
  String get logsCopied => 'Journaux copiés.';

  @override
  String get message => 'Message';

  @override
  String get stackTrace => 'Trace d\'appels';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Soumis à la licence Mozilla Public License 2.0.\nLe code source est disponible sur :$sourceCodeLink';
  }

  @override
  String get transcoding => 'Transcodage';

  @override
  String get downloadLocations => 'Emplacements des téléchargements';

  @override
  String get audioService => 'Service audio';

  @override
  String get playbackReporting => 'Rapport de lecture';

  @override
  String get interactions => 'Intéractions';

  @override
  String get layoutAndTheme => 'Disposition & Apparence';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableInOfflineMode => 'Indisponible en mode hors-ligne';

  @override
  String get logOut => 'Déconnexion';

  @override
  String get downloadedTracksWillNotBeDeleted =>
      'Les chansons téléchargées ne seront pas supprimées';

  @override
  String get areYouSure => 'Êtes-vous sûr ?';

  @override
  String get enableTranscoding => 'Activer le transcodage';

  @override
  String get enableTranscodingSubtitle =>
      'Transcode les flux musicaux côté serveur.';

  @override
  String get bitrate => 'Débit binaire';

  @override
  String get bitrateSubtitle =>
      'Un bitrate plus élevé offre une meilleure qualité audio au prix d\'une bande passante plus importante. Cela ne s\'applique pas aux codecs sans pertes, par exemple FLAC.';

  @override
  String get customLocation => 'Emplacement personnalisé';

  @override
  String get appDirectory => 'Répertoire de l\'application';

  @override
  String get addDownloadLocation => 'Ajouter un emplacement de téléchargement';

  @override
  String get selectDirectory => 'Sélectionner un répertoire';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get pathReturnSlashErrorMessage =>
      'Les chemins qui retournent \"/\" ne peuvent pas être utilisés';

  @override
  String get directoryMustBeEmpty => 'Le répertoire doit être vide';

  @override
  String get customLocationsBuggy =>
      'Les emplacements personnalisés peuvent être extrêmement problématiques et ne sont pas recommandés dans la plupart des cas. Les emplacements situés dans le dossier système \"Musique\" empêchent l\'enregistrement des pochettes d\'album en raison des limitations de l\'OS.';

  @override
  String get enterLowPriorityStateOnPause =>
      'Passage à l\'état de basse priorité en cas de pause';

  @override
  String get enterLowPriorityStateOnPauseSubtitle =>
      'Permet de supprimer la notification lorsque la lecture est en pause. Permet également à Android de fermer le service lorsqu\'il est en pause.';

  @override
  String get shuffleAllTrackCount => 'Nombre de titres à mélanger';

  @override
  String get shuffleAllTrackCountSubtitle =>
      'Nombre de chansons à charger lors de l\'utilisation du bouton \'Tout mélanger\'.';

  @override
  String get viewType => 'Disposition de l\'affichage';

  @override
  String get viewTypeSubtitle =>
      'Règle la manière dont les musiques sont diposées';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Mosaïque';

  @override
  String get customizationSettingsTitle => 'Personnalisation';

  @override
  String get playbackSpeedControlSetting => 'Afficher la vitesse de lecture';

  @override
  String get playbackSpeedControlSettingSubtitle =>
      'Affichage, ou non, des contrôles de la vitesse de lecture dans le menu du lecteur';

  @override
  String playbackSpeedControlSettingDescription(
      int trackDuration, int albumDuration, String genreList) {
    return 'Automatique:\nFinamp essaie d’identifier si le titre joué est un podcast ou un chapitre d’un livre audio. Finamp. Il est considéré que c’est le cas si le titre dure plus de $trackDuration minutes, si l’album dure plus de $albumDuration heures ou qu’au moins un de ces genres est assigné au titre : $genreList\nLes contrôles le vitesse de lecture seront alors affichés dans le menu du lecteur.\n\nAffichés :\nLes contrôles de vitesse de lecture seront toujours affichés dans le menu du lecteur.\n\nCachés :\nLes contrôles de vitesse de lecture seront toujours cachés dans le menu du lecteur.';
  }

  @override
  String get automatic => 'Automatique';

  @override
  String get shown => 'Affichés';

  @override
  String get hidden => 'Cachés';

  @override
  String get speed => 'Vitesse';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get apply => 'Appliquer';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Paysage';

  @override
  String gridCrossAxisCount(String value) {
    return 'Nombre de tuiles par ligne en orientation $value';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Le nombre de tuiles à utiliser par rangée en orientation $value lorsque l\'affichage est en mode mosaïque.';
  }

  @override
  String get showTextOnGridView => 'Afficher le texte dans la grille de vue';

  @override
  String get showTextOnGridViewSubtitle =>
      'Afficher ou non le texte (titre, artiste, etc.) sur l\'écran de la grille musicale.';

  @override
  String get useCoverAsBackground =>
      'Afficher la couverture floutée en arrière-plan du lecteur';

  @override
  String get useCoverAsBackgroundSubtitle =>
      'Utiliser ou non une couverture floutée comme arrière-plan sur l\'écran du lecteur.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle =>
      'Remplissage minimum de la couverture de l\'album';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle =>
      'Remplissage minimum autour de l’image d’album sur l’écran du lecteur, en % de la largeur de l’écran.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists =>
      'Masquer les artistes des chansons si identiques aux artistes de l\'album';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle =>
      'Afficher ou non les artistes des chansons sur l\'écran de l\'album si différents des artistes de l\'album.';

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
  String get disableGesture => 'Désactiver les gestes';

  @override
  String get disableGestureSubtitle =>
      'Indique si les gestes doivent être désactivés.';

  @override
  String get showFastScroller => 'Afficher le défileur rapide';

  @override
  String get theme => 'Thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Claire';

  @override
  String get dark => 'Sombre';

  @override
  String get tabs => 'Onglets';

  @override
  String get playerScreen => 'Écran du lecteur';

  @override
  String get cancelSleepTimer => 'Annuler le minuteur de sommeil ?';

  @override
  String get yesButtonLabel => 'Oui';

  @override
  String get noButtonLabel => 'Non';

  @override
  String get setSleepTimer => 'Configurer le minuteur de sommeil';

  @override
  String get hours => 'Heures';

  @override
  String get seconds => 'Secondes';

  @override
  String get minutes => 'Minutes';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime de $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Titre $currentTrackIndex sur $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get sleepTimerTooltip => 'Minuteur de sommeil';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Arrêt de la lecture dans $time minutes';
  }

  @override
  String get addToPlaylistTooltip => 'Ajouter à une playlist';

  @override
  String get addToPlaylistTitle => 'Ajouter à une playlist';

  @override
  String get addToMorePlaylistsTooltip => 'Ajouter à d’autres playlists';

  @override
  String get addToMorePlaylistsTitle => 'Ajouter à d’autres playlists';

  @override
  String get removeFromPlaylistTooltip => 'Retirer de cette liste de lecture';

  @override
  String get removeFromPlaylistTitle => 'Supprimer de cette liste de lecture';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Retirer de la playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Retirer de la playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nouvelle Playlist';

  @override
  String get createButtonLabel => 'Créer';

  @override
  String get playlistCreated => 'Playlist créée.';

  @override
  String get playlistActionsMenuButtonTooltip =>
      'Appuyer pour ajouter à la playlist. Appuyer longuement pour ajouter aux favoris.';

  @override
  String get browsePlaylists => 'Browse Playlists';

  @override
  String get noAlbum => 'Aucun album';

  @override
  String get noItem => 'Aucun élément';

  @override
  String get noArtist => 'Aucun artiste';

  @override
  String get unknownArtist => 'Artiste inconnu';

  @override
  String get unknownAlbum => 'Album inconnu';

  @override
  String get playbackModeDirectPlaying => 'Lecture directe';

  @override
  String get playbackModeTranscoding => 'Transcodage';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Lecture locale';

  @override
  String get queue => 'File d\'attente';

  @override
  String get addToQueue => 'Ajouter à la liste d\'attente';

  @override
  String get replaceQueue => 'Remplacer la file d\'attente';

  @override
  String get instantMix => 'Mix instantané';

  @override
  String get goToAlbum => 'Voir l\'album';

  @override
  String get goToArtist => 'Aller à l’artiste';

  @override
  String get goToGenre => 'Aller au genre';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String get addFavorite => 'Add Favorite';

  @override
  String get confirmFavoriteAdded => 'Ajouté aux favoris';

  @override
  String get confirmFavoriteRemoved => 'Retiré des favoris';

  @override
  String get addedToQueue => 'Ajouté à la file d\'attente';

  @override
  String get insertedIntoQueue => 'Ajouté à la file d\'attente.';

  @override
  String get queueReplaced => 'File d\'attente remplacée.';

  @override
  String get confirmAddedToPlaylist => 'Ajouté à la playlist.';

  @override
  String get removedFromPlaylist => 'Retiré de la playlist.';

  @override
  String get startingInstantMix => 'Mix instantané lancé.';

  @override
  String get anErrorHasOccured => 'Une erreur s\'est produite.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Code de statut $statusCode. Cela signifie probablement que vous avez utilisé un mauvais nom d\'utilisateur/mot de passe, ou que votre client n\'est plus connecté.';
  }

  @override
  String get removeFromMix => 'Retirer du Mix';

  @override
  String get addToMix => 'Ajouter au Mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments re-téléchargés',
      one: '$count élément re-téléchargé',
      zero: 'Aucun re-téléchargement nécessaire',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Taille du tampon';

  @override
  String get bufferDurationSubtitle =>
      'Durée maximale de la mise en mémoire tampon, en secondes. Nécessite un redémarrage.';

  @override
  String get bufferDisableSizeConstraintsTitle =>
      'Ne pas limiter la taille de la mémoire tampon';

  @override
  String get bufferDisableSizeConstraintsSubtitle =>
      'Désactive les contraintes de taille de la mémoire tampon (\"Taille de la mémoire tampon\"). La mémoire tampon sera toujours chargée pendant la durée configurée (\"Durée de la mémoire tampon\"), même pour les fichiers très volumineux. Peut provoquer des plantages. Nécessite un redémarrage.';

  @override
  String get bufferSizeTitle => 'Taille de la mémoire tampon';

  @override
  String get bufferSizeSubtitle =>
      'Taille maximale de la mémoire tampon en Mo. Nécessite un redémarrage';

  @override
  String get language => 'Langue';

  @override
  String get skipToPreviousTrackButtonTooltip =>
      'Retourner au début ou au titre précédent';

  @override
  String get skipToNextTrackButtonTooltip => 'Passer au titre suivant';

  @override
  String get togglePlaybackButtonTooltip => 'Reprendre / arrêter la lecture';

  @override
  String get previousTracks => 'Titre précédent';

  @override
  String get nextUp => 'Suivant';

  @override
  String get clearNextUp => 'Effacer les titres suivants';

  @override
  String get stopAndClearQueue => 'Stop playback and clear queue';

  @override
  String get playingFrom => 'Lecture de';

  @override
  String get playNext => 'Jouer ensuite';

  @override
  String get addToNextUp => 'Ajouter aux suivants';

  @override
  String get shuffleNext => 'Mix suivant';

  @override
  String get shuffleToNextUp => 'Queue';

  @override
  String get shuffleToQueue => 'Jouer aléatoirement dans la file d\'attente';

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
    return '$_temp0 sera joué ensuite';
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
    return '$_temp0 ajouté à Suivants';
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
    return '$_temp0 ajouté à la file de lecture';
  }

  @override
  String get confirmShuffleNext => 'Aléatoire dans la file d\'attente';

  @override
  String get confirmShuffleToNextUp => 'Aléatoire ensuite';

  @override
  String get confirmShuffleToQueue => 'Aléatoire en file d\'attente';

  @override
  String get placeholderSource => 'Quelque part';

  @override
  String get playbackHistory => 'Historique de lecture';

  @override
  String get shareOfflineListens => 'Partager les actions hors ligne';

  @override
  String get yourLikes => 'Vos Favoris';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Musiques ajoutées via À suivre';

  @override
  String get savedQueue => 'File enregistrée';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'd\'un Album',
        'playlist': 'd\'une Playlist',
        'trackMix': 'd\'une Track Mix',
        'artistMix': 'd\'un Artist Mix',
        'albumMix': 'd\'un Album Mix',
        'genreMix': 'd\'un Genre Mix',
        'favorites': 'vos favorites',
        'allTracks': 'toutes vos musiques',
        'filteredList': 'vos musiques',
        'genre': 'Genre',
        'artist': 'Artist',
        'track': 'Track',
        'nextUpAlbum': 'Album in Next Up',
        'nextUpPlaylist': 'Playlist in Next Up',
        'nextUpArtist': 'Artist in Next Up',
        'remoteClient': 'd\'un autre appareil',
        'other': '',
      },
    );
    return 'Joué à partir $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Tout mélanger';

  @override
  String get playbackOrderLinearButtonLabel => 'Jouer dans l\'ordre';

  @override
  String get playbackOrderLinearButtonTooltip =>
      'Lecture dans l\'ordre. Cliquez pour mélanger.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Mélange des musiques';

  @override
  String get playbackOrderShuffledButtonTooltip =>
      'Mélange des musiques. Cliquez pour lire dans l\'ordre.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Lecture à vitesse x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'Vitesse x$speed';
  }

  @override
  String currentVolumeFeatureText(int volume) {
    return '$volume% volume';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Réduire la vitesse de lecture';

  @override
  String get playbackSpeedIncreaseLabel => 'Augmenter la vitesse de lecture';

  @override
  String get loopModeNoneButtonLabel => 'Ne pas répéter';

  @override
  String get loopModeOneButtonLabel => 'Répétition de cette musique';

  @override
  String get loopModeAllButtonLabel => 'Répéter tout';

  @override
  String get queuesScreen => 'Récupérer des files d\'attente';

  @override
  String get queueRestoreButtonLabel => 'Restorer';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat =
        intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Enregistrée le $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Lecture: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '1 Track',
    );
    return '$_temp0, $remaining Non joués';
  }

  @override
  String get queueLoadingMessage => 'Restauration de la file d\'attente…';

  @override
  String get queueRetryMessage =>
      'Échec de restauration de la file d\'attente. Réessayer ?';

  @override
  String get autoloadLastQueueOnStartup =>
      'Restaurer automatiquement la dernière file d\'attente';

  @override
  String get autoloadLastQueueOnStartupSubtitle =>
      'Au démarrage de l\'application, restaurer la dernière file d\'attente.';

  @override
  String get reportQueueToServer => 'Envoyer la file d\'attente au serveur ?';

  @override
  String get reportQueueToServerSubtitle =>
      'Lorsque cette option est activée, Finamp envoie la file d\'attente actuelle au serveur. Il semble qu\'il n\'y ait actuellement que peu d\'utilité à cela, à part augmenter la bande passante utilisée.';

  @override
  String get periodicPlaybackSessionUpdateFrequency =>
      'Fréquence de mise à jour de la session';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle =>
      'Fréquence d\'envoi de l\'état actuel de la session de lecture au serveur, en secondes. Cette fréquence doit être inférieure à 5 minutes (300 secondes), afin d\'éviter que la session ne soit interrompue.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails =>
      'Si le serveur Jellyfin ne reçoit aucune mise à jour d’un client pendant plus de 5 minutes, il suppose que la lecture est terminée. Cela signifie que pour les morceaux durant plus de 5 minutes, la lecture peut être considérée comme terminée, ce qui peut fausser les données de rapport de lecture.';

  @override
  String get playOnStaleDelay => 'Expiration de la session \'Jouer sur\'';

  @override
  String get playOnStaleDelaySubtitle =>
      'Combien de temps une session \'Jouer sur\' à distance est considérée comme active après avoir reçu une commande. Lorsqu’elle est considérée comme active, la lecture est signalée plus fréquemment, ce qui peut entraîner une utilisation accrue de la bande passante.';

  @override
  String get enablePlayonTitle => 'Activer le support de \'Jouer sur\'';

  @override
  String get enablePlayonSubtitle =>
      'Activer la fonction \'Jouer sur\' de Jellyfin (contrôle à distance de Finamp depuis un autre client). Désactivez cette option si votre serveur ou proxy inverse ne prend pas en charge les websockets.';

  @override
  String get playOnReconnectionDelay =>
      'Délai de reconnexion de la session \'Jouer sur\'';

  @override
  String get playOnReconnectionDelaySubtitle =>
      'Contrôle le délai entre les tentatives de reconnexion au websocket \'Jouer sur\' lorsqu’il est déconnecté (en secondes). Un délai plus faible augmente l’utilisation de la bande passante.';

  @override
  String get topTracks => 'Morceaux les plus joués';

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
  String get shuffleAlbums => 'Mélanger les albums';

  @override
  String get shuffleAlbumsNext =>
      'Mélanger les albums au début de la file d\'attente';

  @override
  String get shuffleAlbumsToNextUp =>
      'Mélanger les albums en fin de file d\'attente';

  @override
  String get shuffleAlbumsToQueue =>
      'Mélanger les albums en de file d\'attente';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount lectures',
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
    return 'Impossible de charger $_temp0';
  }

  @override
  String get confirm => 'Confirmé';

  @override
  String get close => 'Fermer';

  @override
  String get showUncensoredLogMessage =>
      'Ce journal contient vos informations de connexion. Afficher tout de même ?';

  @override
  String get resetTabs => 'Réinitialiser les onglets';

  @override
  String get resetToDefaults => 'Restaurer les paramètres par défaut';

  @override
  String get noMusicLibrariesTitle => 'Aucune bibliothèque musicale';

  @override
  String get noMusicLibrariesBody =>
      'Finamp n\'a pas trouvé de bibliothèques musicales. Veuillez vous assurer que votre serveur Jellyfin contient au moins une bibliothèque avec le type de contenu défini sur \"Musique\".';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get moreInfo => 'Plus d\'informations';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalisation du volume';

  @override
  String get playbackReportingSettingsTitle => 'Rapport de lecture & Jouer sur';

  @override
  String get volumeNormalizationSwitchTitle =>
      'Activer la normalisation du volume';

  @override
  String get volumeNormalizationSwitchSubtitle =>
      'Normaliser le gain des musiques';

  @override
  String get volumeNormalizationModeSelectorTitle =>
      'Mode de normalisation du volume';

  @override
  String get volumeNormalizationModeSelectorSubtitle =>
      'Quand et comment appliquer la normalisation du volume';

  @override
  String get volumeNormalizationModeSelectorDescription =>
      'Hybride (musique + album) :\nLe gain de piste est utilisé pour la lecture normale, mais si un album est en cours de lecture (soit parce qu\'\'il s\'\'agit de la source principale de la file d\'\'attente de lecture, soit parce qu\'\'il a été ajouté à la file d\'\'attente à un moment donné), le gain de l\'\'album est utilisé à la place.\n\nBasé sur la piste :\nLe gain de piste est toujours utilisé, qu\'un album soit en cours de lecture ou non.\n\nAlbums uniquement :\nLa normalisation du volume n\'est appliquée que lors de la lecture d\'albums (en utilisant le gain de l\'album), mais pas pour les pistes individuelles.';

  @override
  String get volumeNormalizationModeHybrid => 'Hybride (Musique & Album)';

  @override
  String get volumeNormalizationModeTrackBased => 'En fonction de la musique';

  @override
  String get volumeNormalizationModeAlbumBased => 'En fonction de l\'album';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Seulement pour les albums';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Gain de base';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle =>
      'Actuellement, la normalisation du volume sur iOS nécessite de modifier le volume de lecture pour émuler le changement de gain. Comme nous ne pouvons pas augmenter le volume au-delà de 100 %, nous devons diminuer le volume par défaut afin de pouvoir augmenter le volume des pistes calmes. La valeur est exprimée en décibels (dB), où -10 dB correspond à un volume de ~30%, -4,5 dB à un volume de ~60% et -2 dB à un volume de ~80%.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Lire la chanson balayée en prochain';

  @override
  String get swipeInsertQueueNextSubtitle =>
      'Placer une chanson comme prochain élément de la file d\'attente lorsqu\'elle est balayée dans la liste des chansons, au lieu de l\'ajouter à la fin de la liste.';

  @override
  String get swipeLeftToRightAction => 'Balayage à droite';

  @override
  String get swipeLeftToRightActionSubtitle =>
      'Action déclenchée lors du glissement d\'un morceau de gauche à droite dans la liste.';

  @override
  String get swipeRightToLeftAction => 'Glissement à gauche';

  @override
  String get swipeRightToLeftActionSubtitle =>
      'Action déclenchée lors du glissement d\'un morceau de droite à gauche dans la liste.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle =>
      'Commencer le Mix instantané pour des musiques individuelles';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle =>
      'Lorsque activé, cliquer sur une musique dans l\'onglet musiques lance un mix instantané de cette musique au lieu de la jouer seule.';

  @override
  String get downloadItem => 'Télécharger';

  @override
  String get repairComplete => 'Réparation des téléchargements effectuée.';

  @override
  String get syncComplete => 'Tous les téléchargements ont été synchronisés.';

  @override
  String get syncDownloads =>
      'Synchroniser et télécharger les items manquants.';

  @override
  String get repairDownloads =>
      'Réparation des problèmes avec les fichiers téléchargés ou leurs métadonnées.';

  @override
  String get requireWifiForDownloads => 'Téléchargement en Wi-Fi uniquement.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '$count track',
    );
    return 'Avertissement: $_temp0 n\'a pas pu être ajouté à la queue.';
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
    return 'Êtes vous sûr de vouloir supprimer tous les téléchargements de la bibliothèque \'\'$libraryName\'\' ?';
  }

  @override
  String get onlyShowFullyDownloaded =>
      'Afficher seulement les albums téléchargés en intégralité';

  @override
  String get filesystemFull =>
      'Les téléchargements restant n\'ont pas pu être achevés. Manque d\'espace de stockage.';

  @override
  String get connectionInterrupted =>
      'Connexion interrompue, téléchargements mis en pause.';

  @override
  String get connectionInterruptedBackground =>
      'La connexion a été interrompue pendant le téléchargement en arrière plan. Cela est peut-être du à la configuration de votre système.';

  @override
  String get connectionInterruptedBackgroundAndroid =>
      'La connexion a été interrompue pendant le téléchargement en arrière plan. Cela est peut-être du à la configuration de votre système ou l\'option \'Basse priorité en pause\' est activée.';

  @override
  String get activeDownloadSize => 'Téléchargement...';

  @override
  String get missingDownloadSize => 'Suppression...';

  @override
  String get syncingDownloadSize => 'Synchronisation...';

  @override
  String get runRepairWarning =>
      'Le serveur n\'était pas atteignable pour finaliser la migration de vos téléchargements. Veuillez lancer \'Réparation des Téléchargements\' depuis l\'écran des téléchargements dès que vous serez à nouveau en ligne.';

  @override
  String get downloadSettings => 'Téléchargements';

  @override
  String get showNullLibraryItemsTitle =>
      'Afficher les médias dans les bibliothèques inconnues.';

  @override
  String get showNullLibraryItemsSubtitle =>
      'Certains médias peuvent ếtre téléchargés depuis une bibliothèque inconnue. Désactivez cette option pour les cacher.';

  @override
  String get maxConcurrentDownloads =>
      'Nombre maximum de téléchargements simultanés';

  @override
  String get maxConcurrentDownloadsSubtitle =>
      'L\'augmentation des téléchargements simultanés permet d\'accroître le téléchargement en arrière-plan, mais peut entraîner l\'échec de certains téléchargements s\'ils sont très volumineux, ou provoquer un décalage excessif dans certains cas.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Téléchargements simultanés';
  }

  @override
  String get downloadsWorkersSetting =>
      'Nombre de threads pour le téléchargement';

  @override
  String get downloadsWorkersSettingSubtitle =>
      'Nombre de threads qui synchronisent les métadonnées et suppriment les téléchargements. Augmenter ce nombre peut augmenter la vitesse de synchronisation, surtout lorsque la latence avec le serveur est élevée, mais risque de causer des ralentissements du client.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Threads pour le téléchargement';
  }

  @override
  String get syncOnStartupSwitch =>
      'Synchroniser automatiquement les téléchargements au démarrage';

  @override
  String get preferQuickSyncSwitch =>
      'Privilégier les synchronisations rapides';

  @override
  String get preferQuickSyncSwitchSubtitle =>
      'Lors des synchronisations, certains items spécifiques (comme les musiques ou albums) ne seront pas mis à jour. La réparation des téléchargement lance toujours une synchronisation complète.';

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
    return 'Cet item doit être téléchargé par $parentName.';
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
    return 'Images en cache pour \'$libraryName\'';
  }

  @override
  String get transcodingStreamingFormatTitle =>
      'Sélectionner le format de transcodage';

  @override
  String get transcodingStreamingFormatSubtitle =>
      'Sélectionnez le format à utiliser lors du streaming audio transcodé. Les morceaux déjà en file d\'attente ne seront pas affectés.';

  @override
  String get downloadTranscodeEnableTitle =>
      'Activer le transcodage pour le téléchargement';

  @override
  String get downloadTranscodeCodecTitle =>
      'Sélectionnez le format pour le téléchargement';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Toujours',
        'never': 'Jamais',
        'ask': 'Demander',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Débit binaire de téléchargement';

  @override
  String get downloadBitrateSubtitle =>
      'Un plus grand débit binaire résulte en audio de meilleur qualité, au prix d\'un fichier plus volumineux.';

  @override
  String get transcodeHint => 'Transcoder ?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Téléchargement en $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(
      String bitrate, String codec, String size, String location) {
    return '';
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
    return 'Télécharger la version originale $_temp0';
  }

  @override
  String get redownloadcomplete => 'Ré téléchargement en transcodé planifié.';

  @override
  String get redownloadTitle =>
      'Re-télécharger automatiquement les items transcodés';

  @override
  String get redownloadSubtitle =>
      'Relance automatiquement le téléchargements des titres qui sont censés être de qualité différente à cause d\'un changement de leur collection.';

  @override
  String get defaultDownloadLocationButton =>
      'Choisir cet emplacement pour le téléchargement. Désactiver pour choisir à chaque téléchargement.';

  @override
  String get fixedGridSizeSwitchTitle => 'Utiliser une taille de grille fixe';

  @override
  String get fixedGridSizeSwitchSubtitle =>
      'La taille de la grille ne changera pas en fonction de la taille de l\'écran/fenêtre.';

  @override
  String get fixedGridSizeTitle => 'Taille de la grille';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Petit',
        'medium': 'Moyen',
        'large': 'Grand',
        'veryLarge': 'Très Grand',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Autoriser le mode écran scindé';

  @override
  String get allowSplitScreenSubtitle =>
      'Le lecteur sera affiché à côté des autres pages sur les écrans larges.';

  @override
  String get enableVibration => 'Activer le vibreur';

  @override
  String get enableVibrationSubtitle => 'Activer ou non le mode vibreur.';

  @override
  String get hideQueueButton => 'Cacher le bouton de la file d\'attente';

  @override
  String get hideQueueButtonSubtitle =>
      'Cacher le bouton de la file d\'attente dans le lecteur. Balayez vers le haut pour accéder à la file d\'attente.';

  @override
  String get oneLineMarqueeTextButton =>
      'Défilement automatique des longs titres';

  @override
  String get oneLineMarqueeTextButtonSubtitle =>
      'Défiler automatiquement les titres des musiques trop longs pour être afficher sur deux lignes';

  @override
  String get marqueeOrTruncateButton =>
      'Utiliser des ellipses pour les longs titres';

  @override
  String get marqueeOrTruncateButtonSubtitle =>
      'Afficher ... à la fin des longs titres au lieu d\'un défilement';

  @override
  String get hidePlayerBottomActions =>
      'Cacher les boutons de la partie inférieure';

  @override
  String get hidePlayerBottomActionsSubtitle =>
      'Cacher le bouton de file d\'attente et des paroles sur le lecteur. Balayez vers le haut pour accéder à la file d\'attente, balayez à gauche (en dessous de la pochette) pour afficher les paroles.';

  @override
  String get prioritizePlayerCover => 'Prioriser la pochette de l\'album';

  @override
  String get prioritizePlayerCoverSubtitle =>
      'Favorise la taille de la pochette d\'album sur le lecteur. Les boutons moins importants seront cachés sur les écrans de petite taille.';

  @override
  String get suppressPlayerPadding =>
      'Désactive l\'espacement des contrôles du lecteur';

  @override
  String get suppressPlayerPaddingSubtitle =>
      'Rapproche les boutons de contrôle du lecteur quand la taille de la pochette n\'est pas maximale.';

  @override
  String get lockDownload => 'Toujours garder le téléchargement';

  @override
  String get showArtistChipImage =>
      'Afficher l\'image de l\'artiste à côté de son nom';

  @override
  String get showArtistChipImageSubtitle =>
      'Cela affecte les petits aperçus d\'images d\'artistes, par exemple, sur l\'écran du lecteur.';

  @override
  String get scrollToCurrentTrack => 'Défiler jusqu\'à la chanson en cours';

  @override
  String get enableAutoScroll => 'Activer le défilement automatique';

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
  String get removeFromPlaylistConfirm => 'Retirer';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Retirer \'$itemName\' de la liste de lecture \'$playlistName\' ?';
  }

  @override
  String get trackMenuButtonTooltip => 'Menu Chanson';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get addRemoveFromPlaylist =>
      'Ajouter aux / Retirer des listes de lecture';

  @override
  String get addPlaylistSubheader =>
      'Ajouter une chanson à une liste de lecture';

  @override
  String get trackOfflineFavorites =>
      'Synchroniser le statut de tous les favoris';

  @override
  String get trackOfflineFavoritesSubtitle =>
      'Cela permet d’afficher l\'état des favoris plus à jour lorsque vous êtes hors ligne.  Ne télécharge aucun fichier supplémentaire.';

  @override
  String get allPlaylistsInfoSetting =>
      'Télécharger les métadonnées des playlists';

  @override
  String get allPlaylistsInfoSettingSubtitle =>
      'Synchroniser les métadonnées pour toutes les playlists afin d\'améliorer votre expérience';

  @override
  String get downloadFavoritesSetting => 'Télécharger tous les favoris';

  @override
  String get downloadAllPlaylistsSetting => 'Télécharger toutes les playlists';

  @override
  String get fiveLatestAlbumsSetting => 'Télécharger les 5 derniers albums';

  @override
  String get fiveLatestAlbumsSettingSubtitle =>
      'Les téléchargements seront enlevés lorsqu\'ils deviennent trop vieux. Verrouillez le téléchargement pour empêcher la suppression.';

  @override
  String get cacheLibraryImagesSettings =>
      'Mettre les images actuelles de la bibliothèque en cache';

  @override
  String get cacheLibraryImagesSettingsSubtitle =>
      'Toutes les couvertures des albums, artistes, genres et playlists de la bibliothèque active seront téléchargées.';

  @override
  String get showProgressOnNowPlayingBarTitle =>
      'Montrer la progression du titre sur le \"mini lecteur\" de l\'application';

  @override
  String get showProgressOnNowPlayingBarSubtitle =>
      'Contrôle si le mini-lecteur / la barre de lecture dans l’application en bas de l’écran de musique fonctionne comme une barre de progression.';

  @override
  String get lyricsScreenButtonTitle => 'Paroles';

  @override
  String get lyricsScreen => 'Écran des paroles';

  @override
  String get showLyricsTimestampsTitle =>
      'Afficher les temps pour les paroles synchronisées';

  @override
  String get showLyricsTimestampsSubtitle =>
      'Contrôle si les temps de chaque parole sont affichées dans l\'écran des paroles, s\'ils sont disponibles.';

  @override
  String get showStopButtonOnMediaNotificationTitle =>
      'Afficher le bouton stop sur la notification du lecteur';

  @override
  String get showStopButtonOnMediaNotificationSubtitle =>
      'Contrôle si la notification du lecteur a un bouton stop en plus d\'un bouton pause. Cela vous permet d\'arrêter la lecture sans ouvrir l\'application.';

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
      'Afficher la barre de progression sur la notification du lecteur';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle =>
      'Contrôle si la notification de média comporte une barre de progression. Cela vous permet de modifier la position de lecture sans ouvrir l’application.';

  @override
  String get alignmentOptionStart => 'Début';

  @override
  String get alignmentOptionCenter => 'Milieu';

  @override
  String get alignmentOptionEnd => 'Fin';

  @override
  String get fontSizeOptionSmall => 'Petite';

  @override
  String get fontSizeOptionMedium => 'Moyenne';

  @override
  String get fontSizeOptionLarge => 'Grande';

  @override
  String get lyricsAlignmentTitle => 'Alignement des paroles';

  @override
  String get lyricsAlignmentSubtitle =>
      'Contrôle l’alignement des paroles dans la vue des paroles.';

  @override
  String get lyricsFontSizeTitle => 'Taille de la police des paroles';

  @override
  String get lyricsFontSizeSubtitle =>
      'Contrôle la taille de police des paroles dans la vue des paroles.';

  @override
  String get showLyricsScreenAlbumPreludeTitle =>
      'Afficher la pochette de l’album avant les paroles';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle =>
      'Contrôle si la pochette de l’album est affichée au-dessus des paroles avant le défilement de la page.';

  @override
  String get keepScreenOn => 'Maintenir l\'écran allumé';

  @override
  String get keepScreenOnSubtitle => 'Quand garder l\'écran allumé';

  @override
  String get keepScreenOnDisabled => 'Désactivé';

  @override
  String get keepScreenOnAlwaysOn => 'Toujours allumé';

  @override
  String get keepScreenOnWhilePlaying => 'Pendant l\'écoute de la musique';

  @override
  String get keepScreenOnWhileLyrics => 'Pendant l\'affichage des paroles';

  @override
  String get keepScreenOnWhilePluggedIn =>
      'L\'écran ne reste allumé que lorsqu\'il est branché';

  @override
  String get keepScreenOnWhilePluggedInSubtitle =>
      'Ignorer le paramètre de maintien de l\'écran allumé si l\'appareil est débranché';

  @override
  String get genericToggleButtonTooltip => 'Appuyez pour basculer.';

  @override
  String get artwork => 'Illustration';

  @override
  String artworkTooltip(String title) {
    return 'Illustration pour $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Illustration pour $title. Appuyez pour basculer la lecture. Balayez vers la gauche ou la droite pour changer de piste.';
  }

  @override
  String get nowPlayingBarTooltip => 'Ouvrir l’écran du lecteur';

  @override
  String get additionalPeople => 'People';

  @override
  String get playbackMode => 'Mode de lecture';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Débit binaire';

  @override
  String get bitDepth => 'Format d’échantillonnage';

  @override
  String get size => 'Taille';

  @override
  String get normalizationGain => 'Gain';

  @override
  String get sampleRate => 'Fréquence d\'échantillonnage';

  @override
  String get showFeatureChipsToggleTitle =>
      'Afficher les informations de piste avancées';

  @override
  String get showFeatureChipsToggleSubtitle =>
      'Afficher les informations de piste avancées telles que le codec, le débit et plus sur l’écran du lecteur.';

  @override
  String get seeAll => 'See All';

  @override
  String get albumScreen => 'Écran de l\'album';

  @override
  String get showCoversOnAlbumScreenTitle =>
      'Afficher les couvertures d\'album pour les pistes';

  @override
  String get showCoversOnAlbumScreenSubtitle =>
      'Afficher les couvertures d\'album pour chaque morceau séparément sur l\'écran de l\'album.';

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
      'Vous n\'avez pas encore écouté de chanson de cet artiste.';

  @override
  String get emptyFilteredListTitle => 'Aucun élément trouvé';

  @override
  String get emptyFilteredListSubtitle =>
      'Aucun élément ne correspond au filtre. Essayez de désactiver le filtre ou de modifier le terme de recherche.';

  @override
  String get resetFiltersButton => 'Réinitialiser les filtres';

  @override
  String get resetSettingsPromptGlobal =>
      'Êtes-vous sûr de vouloir réinitialiser TOUS les paramètres à leur état par défaut ?';

  @override
  String get resetSettingsPromptGlobalConfirm =>
      'Réinitialiser TOUS les paramètres';

  @override
  String get resetSettingsPromptLocal =>
      'Voulez-vous réinitialiser ces paramètres à leur état par défaut ?';

  @override
  String get genericCancel => 'Annuler';

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
  String get allowDeleteFromServerTitle => 'Permet la suppression du serveur';

  @override
  String get allowDeleteFromServerSubtitle =>
      'Activer et désactiver l\'option pour supprimer définitivement une piste du système de fichiers serveurs lorsque la suppression est possible.';

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
        'canDelete': ' Cela supprimera également cet élément de cet appareil.',
        'cantDelete':
            ' Cet élément restera sur cet appareil jusqu’à la prochaine synchronisation.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'de cet appareil',
        'server':
            'du système de fichiers et bibliothèque des serveurs.$_temp1\nCette action ne peut pas être annulée.',
        'other': '',
      },
    );
    return 'Vous allez supprimer ce $_temp0 $_temp2';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' de l\'appareil',
        'server': ' du serveur',
        'other': '',
      },
    );
    return 'Supprimer$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Avertissement : Vous êtes sur le point de télécharger $count pistes.';
  }

  @override
  String get downloadSizeWarningCutoff =>
      'Seuil d\'alerte de la taille du téléchargement';

  @override
  String get downloadSizeWarningCutoffSubtitle =>
      'Un message d’avertissement s’affiche lorsque vous téléchargez plus de pistes à la fois.';

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
    return 'Êtes-vous sûr que vous voulez ajouter toutes les pistes de $_temp0 \'$itemName\' à cette playlist ?  Elles ne pourront être enlevées qu’individuellement.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Publiquement visible :';

  @override
  String get releaseDateFormatYear => 'Année';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Mois & Année';

  @override
  String get releaseDateFormatMonthDayYear => 'Mois, Jour & Année';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle =>
      'Afficher la date de sortie de l\'album sur l\'écran du lecteur';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle =>
      'Afficher la date de sortie de l\'album sur l\'écran du lecteur, derrière le nom de l\'album.';

  @override
  String get releaseDateFormatTitle => 'Format de la date de sortie';

  @override
  String get releaseDateFormatSubtitle =>
      'Contrôle le format de toutes les dates de sortie affichées dans l’application.';

  @override
  String get noReleaseDate => 'No Release Date';

  @override
  String get noDateAdded => 'No Date Added';

  @override
  String get noDateLastPlayed => 'Not played yet';

  @override
  String get librarySelectError =>
      'Erreur de chargement des bibliothèques disponibles pour l’utilisateur';

  @override
  String get autoOfflineOptionOff => 'Désactivé';

  @override
  String get autoOfflineOptionNetwork => 'Réseau';

  @override
  String get autoOfflineOptionDisconnected => 'Déconnecté';

  @override
  String get autoOfflineSettingDescription =>
      'Activer automatiquement le mode hors ligne.\nDésactivé : Ne pas activer automatiquement le mode hors connexion. Peut économiser la batterie.\nRéseau : Activer le mode hors connexion lorsque vous n’êtes pas connecté au wifi ou à l’ethernet.\nDéconnecté : Activer le mode hors ligne lorsque vous n’êtes pas connecté à quoi que ce soit.\nVous pouvez toujours activer manuellement le mode hors connexion qui met en pause l’automatisation jusqu’à ce que vous désactiviez le mode hors connexion à nouveau';

  @override
  String get autoOfflineSettingTitle => 'Mode hors ligne automatisé';

  @override
  String autoOfflineNotification(String state) {
    String _temp0 = intl.Intl.selectLogic(
      state,
      {
        'enabled': 'activé',
        'disabled': 'désactivé',
        'other': 'basculé en position quantique',
      },
    );
    return 'Mode hors ligne automatiquement $_temp0';
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
  String get outputMenuButtonTitle => 'Sortie';

  @override
  String get outputMenuTitle => 'Changer la sortie';

  @override
  String get outputMenuVolumeSectionTitle => 'Volume';

  @override
  String get outputMenuDevicesSectionTitle => 'Appareils disponibles';

  @override
  String get outputMenuOpenConnectionSettingsButtonTitle =>
      'Connecter un appareil';

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
