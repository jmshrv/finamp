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
  String startupError(String error) {
    return 'Une erreur est survenue lors du démarrage de l\'application. L\'erreur est : $error\n\nVeuillez créer une issue sur Github à l\'adresse github.com/UnicornsOnLSD/finamp avec une capture d\'écran de cette page. Si le problème persiste, supprimez les données de l\'application pour la réinitialiser.';
  }

  @override
  String get about => 'À propos de Finamp';

  @override
  String get aboutContributionPrompt => 'Créé par des gens géniaux sur leur temps libre.\nVous pouvez les rejoindre !';

  @override
  String get aboutContributionLink => 'Contribuez à Finamp sur GitHub :';

  @override
  String get aboutReleaseNotes => 'Lisez les dernières notes de version :';

  @override
  String get aboutTranslations => 'Aidez à traduire Finamp dans votre langue :';

  @override
  String get aboutThanks => 'Merci d\'utiliser Finamp !';

  @override
  String get loginFlowWelcomeHeading => 'Bienvenue sur';

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
  String get internalExternalIpExplanation => 'Si vous souhaitez pouvoir accéder à votre serveur Jellyfin à distance, vous devez utiliser votre adresse IP externe.\n\nSi votre serveur utilise les ports HTTP par défaut (80/443) ou le port par défaut de Jellyfin (8096), vous n\'avez pas besoin de spécifier le port. \n\nSi l\'URL est correcte, vous devriez voir apparaître des informations sur votre serveur sous le champ de saisie.';

  @override
  String get serverUrlHint => 'e.g. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Aide sur l’URL du serveur';

  @override
  String get emptyServerUrl => 'Vous devez indiquez l\'adresse du serveur.';

  @override
  String get connectingToServer => 'Connexion au serveur…';

  @override
  String get loginFlowLocalNetworkServers => 'Serveurs sur votre réseau local :';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Recherche des serveurs…';

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
  String get loginFlowQuickConnectPrompt => 'Utiliser un code « Quick Connect »';

  @override
  String get loginFlowQuickConnectInstructions => 'Ouvrez l’application ou le site web Jellyfin, cliquez sur votre icône d’utilisateur et sélectionnez « Quick Connect ».';

  @override
  String get loginFlowQuickConnectDisabled => '« Quick Connect » n’est pas activé sur ce serveur.';

  @override
  String get orDivider => 'ou';

  @override
  String get loginFlowSelectAUser => 'Sélectionnez un utilisateur';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameHint => 'Entrez votre nom d’utilisateur';

  @override
  String get usernameValidationMissingUsername => 'S’il vous plaît, entrez un nom d’utilisateur';

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
  String get unknownName => 'Nom inconnu';

  @override
  String get tracks => 'Chansons';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artistes';

  @override
  String get genres => 'Genres';

  @override
  String get playlists => 'Listes de lectures';

  @override
  String get startMix => 'Commencer un Mix';

  @override
  String get startMixNoTracksArtist => 'Appuyer longuement sur un artiste pour l\'ajouter ou le retirer du mix avant de commencer';

  @override
  String get startMixNoTracksAlbum => 'Appuyer longuement sur un album pour l\'ajouter ou le retirer du mix avant de commencer';

  @override
  String get startMixNoTracksGenre => 'Avant de commencer à écouter un mix, appuyez longuement sur un genre pour l’ajouter ou le retirer du créateur de mix';

  @override
  String get music => 'Musique';

  @override
  String get clear => 'Effacer';

  @override
  String get favourites => 'Favoris';

  @override
  String get shuffleAll => 'Tout mélanger';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get settings => 'Réglages';

  @override
  String get offlineMode => 'Mode hors-ligne';

  @override
  String get sortOrder => 'Ordre de tri';

  @override
  String get sortBy => 'Trier par';

  @override
  String get title => 'Titre';

  @override
  String get album => 'Album';

  @override
  String get albumArtist => 'Artiste de l\'album';

  @override
  String get artist => 'Artiste';

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
  String get runtime => 'Durée d\'exécution';

  @override
  String get syncDownloadedPlaylists => 'Synchroniser les playlists téléchargées';

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
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
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
  String get errorScreenError => 'Une erreur est survenue lors de la récupération de la liste des erreurs ! À ce stade, il serait probablement préférable de créer une issue sur GitHub et de supprimer les données de l\'application.';

  @override
  String get failedToGetTrackFromDownloadId => 'La chanson n’a pas pu être récupérée à l’aide de l’ID de téléchargement';

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
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

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
  String get editPlaylistNameTooltip => 'Modifier le nom de la liste de lecture';

  @override
  String get editPlaylistNameTitle => 'Modifier le nom de la liste de lecture';

  @override
  String get required => 'Requis';

  @override
  String get updateButtonLabel => 'Mettre à jour';

  @override
  String get playlistNameUpdated => 'Nom de la liste de lecture mis à jour.';

  @override
  String get favourite => 'Favoris';

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
  String get interactions => 'Intéractions';

  @override
  String get layoutAndTheme => 'Disposition & Apparence';

  @override
  String get notAvailableInOfflineMode => 'Indisponible en mode hors-ligne';

  @override
  String get logOut => 'Déconnexion';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Les chansons téléchargées ne seront pas supprimées';

  @override
  String get areYouSure => 'Êtes-vous sûr ?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin utilise AAC lors du transcodage';

  @override
  String get enableTranscoding => 'Activer le transcodage';

  @override
  String get enableTranscodingSubtitle => 'Transcode les flux musicaux côté serveur.';

  @override
  String get bitrate => 'Débit binaire';

  @override
  String get bitrateSubtitle => 'Un débit binaire plus élevé offre une meilleure qualité audio au prix d\'une bande passante plus importante.';

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
  String get pathReturnSlashErrorMessage => 'Les chemins qui retournent \"/\" ne peuvent pas être utilisés';

  @override
  String get directoryMustBeEmpty => 'Le répertoire doit être vide';

  @override
  String get customLocationsBuggy => 'Les emplacements personnalisés peuvent être extrêmement problématiques et ne sont pas recommandés dans la plupart des cas. Les emplacements situés dans le dossier système \"Musique\" empêchent l\'enregistrement des pochettes d\'album en raison des limitations de l\'OS.';

  @override
  String get enterLowPriorityStateOnPause => 'Passage à l\'état de basse priorité en cas de pause';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Permet de supprimer la notification lorsque la lecture est en pause. Permet également à Android de fermer le service lorsqu\'il est en pause.';

  @override
  String get shuffleAllTrackCount => 'Nombre de titres à mélanger';

  @override
  String get shuffleAllTrackCountSubtitle => 'Nombre de chansons à charger lors de l\'utilisation du bouton \'Tout mélanger\'.';

  @override
  String get viewType => 'Disposition de l\'affichage';

  @override
  String get viewTypeSubtitle => 'Règle la manière dont les musiques sont diposées';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Mosaïque';

  @override
  String get customizationSettingsTitle => 'Personnalisation';

  @override
  String get playbackSpeedControlSetting => 'Afficher la vitesse de lecture';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Affichage, ou non, des contrôles de la vitesse de lecture dans le menu du lecteur';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
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
  String get showTextOnGridViewSubtitle => 'Afficher ou non le texte (titre, artiste, etc.) sur l\'écran de la grille musicale.';

  @override
  String get useCoverAsBackground => 'Afficher la couverture floutée en arrière-plan du lecteur';

  @override
  String get useCoverAsBackgroundSubtitle => 'Utiliser ou non une couverture floutée comme arrière-plan sur l\'écran du lecteur.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Remplissage minimum de la couverture de l\'album';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Remplissage minimum autour de l’image d’album sur l’écran du lecteur, en % de la largeur de l’écran.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Masquer les artistes des chansons si identiques aux artistes de l\'album';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Afficher ou non les artistes des chansons sur l\'écran de l\'album si différents des artistes de l\'album.';

  @override
  String get showArtistsTopTracks => 'Montrer les top titres sur la page de l’artiste';

  @override
  String get showArtistsTopTracksSubtitle => 'Afficher ou non le top 5 des titres les plus écoutés d’un artiste.';

  @override
  String get disableGesture => 'Désactiver les gestes';

  @override
  String get disableGestureSubtitle => 'Indique si les gestes doivent être désactivés.';

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
  String get playlistActionsMenuButtonTooltip => 'Appuyer pour ajouter à la playlist. Appuyer longuement pour ajouter aux favoris.';

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
  String get removeFavourite => 'Retirer des favoris';

  @override
  String get addFavourite => 'Ajouter aux favoris';

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
  String get bufferDurationSubtitle => 'Durée maximale de la mise en mémoire tampon, en secondes. Nécessite un redémarrage.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Ne pas limiter la taille de la mémoire tampon';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Désactive les contraintes de taille de la mémoire tampon (\"Taille de la mémoire tampon\"). La mémoire tampon sera toujours chargée pendant la durée configurée (\"Durée de la mémoire tampon\"), même pour les fichiers très volumineux. Peut provoquer des plantages. Nécessite un redémarrage.';

  @override
  String get bufferSizeTitle => 'Taille de la mémoire tampon';

  @override
  String get bufferSizeSubtitle => 'Taille maximale de la mémoire tampon en Mo. Nécessite un redémarrage';

  @override
  String get language => 'Langue';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Retourner au début ou au titre précédent';

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
  String get clearQueue => 'Clear Queue';

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
  String get confirmShuffleToNextUp => 'Shuffled to Next Up';

  @override
  String get confirmShuffleToQueue => 'Shuffled to queue';

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
    return 'Joué à partir de $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Tout mélanger';

  @override
  String get playbackOrderLinearButtonLabel => 'Jouer dans l\'ordre';

  @override
  String get playbackOrderLinearButtonTooltip => 'Lecture dans l\'ordre. Cliquez pour mélanger.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Mélange des musiques';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Mélange des musiques. Cliquez pour lire dans l\'ordre.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Lecture à vitesse x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'Vitesse x$speed';
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
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
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
  String get queueLoadingMessage => 'Restauration de la file d\'attente...';

  @override
  String get queueRetryMessage => 'Échec de restauration de la file d\'attente. Réessayer ?';

  @override
  String get autoloadLastQueueOnStartup => 'Restaurer automatiquement la dernière file d\'attente';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Au démarrage, essaie de restaurer la dernière file d\'attente.';

  @override
  String get reportQueueToServer => 'Report current queue to server?';

  @override
  String get reportQueueToServerSubtitle => 'Lorsque cette option est activée, Finamp envoie la file d\'attente actuelle au serveur. Il semble qu\'il n\'y ait actuellement que peu d\'utilité à cela, à part augmenter la bande passante utilisée.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Fréquence de mise à jour de la session';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Fréquence d\'envoi de l\'état actuel de la session de lecture au serveur, en secondes. Cette fréquence doit être inférieure à 5 minutes (300 secondes), afin d\'éviter que la session ne soit interrompue.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'If the Jellyfin server hasn\'\'t received any updates from a client in the last 5 minutes, it assumes that playback has ended. This means that for tracks longer than 5 minutes, that playback could be incorrectly reported as having ended, which reduced the quality of the playback reporting data.';

  @override
  String get topTracks => 'Musiques les plus jouées';

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
  String get shuffleAlbumsNext => 'Mélanger les albums au début de la file d\'attente';

  @override
  String get shuffleAlbumsToNextUp => 'Mélanger les albums en fin de file d\'attente';

  @override
  String get shuffleAlbumsToQueue => 'Shuffle Albums To Queue';

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
    return 'Couldn\'\'t load $_temp0';
  }

  @override
  String get confirm => 'Confirmé';

  @override
  String get close => 'Fermer';

  @override
  String get showUncensoredLogMessage => 'Ce journal contient vos informations de connexion. Afficher tout de même ?';

  @override
  String get resetTabs => 'Réinitialiser les onglets';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get noMusicLibrariesTitle => 'Aucune bibliothèque musicale';

  @override
  String get noMusicLibrariesBody => 'Finamp n\'a pas trouvé de bibliothèques musicales. Veuillez vous assurer que votre serveur Jellyfin contient au moins une bibliothèque avec le type de contenu défini sur \"Musique\".';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get moreInfo => 'Plus d\'informations';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalisation du volume';

  @override
  String get volumeNormalizationSwitchTitle => 'Activer la normalisation du volume';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Use gain information to normalize the loudness of tracks (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Volume Normalization Mode';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Quand et comment appliquer la normalisation du volume';

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
  String get swipeInsertQueueNext => 'Lire la chanson balayée en prochain';

  @override
  String get swipeInsertQueueNextSubtitle => 'Placer une chanson comme prochain élément de la file d\'attente lorsqu\'elle est balayée dans la liste des chansons, au lieu de l\'ajouter à la fin de la liste.';

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
  String get activeDownloadSize => 'Téléchargement...';

  @override
  String get missingDownloadSize => 'Suppression...';

  @override
  String get syncingDownloadSize => 'Synchronisation...';

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
  String get emptyFilteredListTitle => 'Aucun élément trouvé';

  @override
  String get emptyFilteredListSubtitle => 'Aucun élément ne correspond au filtre. Essayez de désactiver le filtre ou de modifier le terme de recherche.';

  @override
  String get resetFiltersButton => 'Réinitialiser les filtres';

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
