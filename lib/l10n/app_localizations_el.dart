// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'An open source Jellyfin music player';

  @override
  String startupError(String error) {
    return 'Ωχ, κάτι δεν πήγε καλά κατά την έναρξη της εφαρμογής. Ο αριθμός σφάλματος είναι:$error\nΔημιούργησε ένα issue στο\ngithub.com/UnicornsOnLSD/finamp μαζί με ένα στιγμιότυπο οθόνης από αυτήν την σελίδα. Εάν το πρόβλημα παραμένει μπορείς να διαγράψεις τα δεδομένα της εφαρμογής με σκοπό την επαναφορά της.';
  }

  @override
  String get about => 'About Finamp';

  @override
  String get aboutContributionPrompt => 'Made by awesome people in their free time.\nYou could be one of them!';

  @override
  String get aboutContributionLink => 'Contribute to Finamp on GitHub:';

  @override
  String get aboutReleaseNotes => 'Read the latest release notes:';

  @override
  String get aboutTranslations => 'Help translate Finamp into your language:';

  @override
  String get aboutThanks => 'Thank you for using Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Welcome to';

  @override
  String get loginFlowSlogan => 'Your music, the way you want it.';

  @override
  String get loginFlowGetStarted => 'Get Started!';

  @override
  String get viewLogs => 'View Logs';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get loginFlowServerSelectionHeading => 'Connect to Jellyfin';

  @override
  String get back => 'Back';

  @override
  String get serverUrl => 'Διεύθυνση διακομιστή';

  @override
  String get internalExternalIpExplanation => 'Αν θέλεις να έχεις πρόσβαση στον jellyfin διακομιστή σου εξ-αποστασεως, πρέπει να χρησιμοποιήσεις την εξωτερική Διεύθυνση IP.\n\nΑν ο διακομιστής βρίσκεται σε πύλη HTTP(80/443), δεν είναι απαραίτητος ο ορισμός πύλης. Αυτό είναι πιθανόν εφόσον ο διακομιστής σου βρίσκεται πίσω από reverse proxy.';

  @override
  String get serverUrlHint => 'e.g. demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Server URL Help';

  @override
  String get emptyServerUrl => 'Η διεύθυνση διακομιστή δεν μπορεί να είναι κενή';

  @override
  String get connectingToServer => 'Connecting to server...';

  @override
  String get loginFlowLocalNetworkServers => 'Servers on your local network:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Scanning for servers...';

  @override
  String get loginFlowAccountSelectionHeading => 'Select your account';

  @override
  String get backToServerSelection => 'Back to Server Selection';

  @override
  String get loginFlowNamelessUser => 'Unnamed User';

  @override
  String get loginFlowCustomUser => 'Custom User';

  @override
  String get loginFlowAuthenticationHeading => 'Log in to your account';

  @override
  String get backToAccountSelection => 'Back to Account Selection';

  @override
  String get loginFlowQuickConnectPrompt => 'Use Quick Connect code';

  @override
  String get loginFlowQuickConnectInstructions => 'Open the Jellyfin app or website, click on your user icon, and select Quick Connect.';

  @override
  String get loginFlowQuickConnectDisabled => 'Quick Connect is disabled on this server.';

  @override
  String get orDivider => 'or';

  @override
  String get loginFlowSelectAUser => 'Select a user';

  @override
  String get username => 'Όνομα χρήστη';

  @override
  String get usernameHint => 'Enter your username';

  @override
  String get usernameValidationMissingUsername => 'Please enter a username';

  @override
  String get password => 'Συνθηματικό χρήστη';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get login => 'Log In';

  @override
  String get logs => 'Αρχείο καταγραφών';

  @override
  String get next => 'Επόμενο';

  @override
  String get selectMusicLibraries => 'Επέλεξε τις βιβλιοθήκες μουσικής σου';

  @override
  String get couldNotFindLibraries => 'Δεν βρέθηκαν συλλογές.';

  @override
  String get unknownName => 'Άγνωστη όνομα';

  @override
  String get tracks => 'Τραγούδια';

  @override
  String get albums => 'Άλμπουμ';

  @override
  String get artists => 'Καλλιτέχνες';

  @override
  String get genres => 'Είδη';

  @override
  String get playlists => 'Λίστες αναπαραγωγής';

  @override
  String get startMix => 'Έναρξη μίξης';

  @override
  String get startMixNoTracksArtist => 'Κράτησε πατημένο έναν καλλιτέχνη, προκειμένου να προστεθεί ή να αφαιρεθεί από τον κατασκευαστή μίξεων, προ-εκκινήσεως μίξης';

  @override
  String get startMixNoTracksAlbum => 'Κράτησε πατημένο ένα άλμπουμ, προκειμένου να προστεθεί ή να αφαιρεθεί από τον κατασκευαστή μίξεων, προ-εκκινήσεως μίξης';

  @override
  String get startMixNoTracksGenre => 'Long-press an genre to add or remove it from the mix builder before starting a mix';

  @override
  String get music => 'Μουσική';

  @override
  String get clear => 'Εκκαθάριση';

  @override
  String get favourites => 'Αγαπημένα';

  @override
  String get shuffleAll => 'Τυχαία αναπαραγωγή';

  @override
  String get downloads => 'Λήψεις';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get offlineMode => 'Λειτουργία εκτός σύνδεσης';

  @override
  String get sortOrder => 'Σειρά ταξινόμησης';

  @override
  String get sortBy => 'Ταξινόμηση κατά';

  @override
  String get title => 'Title';

  @override
  String get album => 'Άλμπουμ';

  @override
  String get albumArtist => 'Καλλιτέχνης άλμπουμ';

  @override
  String get artist => 'Καλλιτέχνης';

  @override
  String get budget => 'Προϋπολογισμός';

  @override
  String get communityRating => 'Βαθμολογία κοινότητας';

  @override
  String get criticRating => 'Βαθμολογία κριτών';

  @override
  String get dateAdded => 'Ημερομηνία προσθήκης';

  @override
  String get datePlayed => 'Ημερομηνία αναπαραγωγής';

  @override
  String get playCount => 'Πλήθος αναπαραγωγών';

  @override
  String get premiereDate => 'Ημερομηνία πρεμιέρας';

  @override
  String get productionYear => 'Χρονολογία παραγωγής';

  @override
  String get name => 'Όνομα';

  @override
  String get random => 'Τυχαίο';

  @override
  String get revenue => 'Έσοδα';

  @override
  String get runtime => 'Διάρκεια';

  @override
  String get syncDownloadedPlaylists => 'Sync downloaded playlists';

  @override
  String get downloadMissingImages => 'Λήψη ελλείποντων εικόνων';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ελήφθησαν $count ελλειπής εικόνες',
      one: 'ελήφθησαν $count ελλειπής εικόνες',
      zero: 'δεν βρέθηκαν ελλειπείς εικόνες',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Active Downloads';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λήψεις',
      one: '$count λήψη',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
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
    return '$count ολοκληρώθηκαν';
  }

  @override
  String dlFailed(int count) {
    return '$count απέτυχαν';
  }

  @override
  String dlEnqueued(int count) {
    return '$count στην σειρά';
  }

  @override
  String dlRunning(int count) {
    return '$count τρέχοντα';
  }

  @override
  String get activeDownloadsTitle => 'Active Downloads';

  @override
  String get noActiveDownloads => 'No active downloads.';

  @override
  String get errorScreenError => 'Προέκυψε σφάλμα κατά την λήψη λίστας σφαλμάτων! Σε αυτό το σημείο, καλό είναι να δημιουργήσεις issue στο GitHub και να διαγράψεις τα δεδομένα της εφαρμογής';

  @override
  String get failedToGetTrackFromDownloadId => 'Απέτυχε η λήψη τραγουδιού από το download ID';

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
  String get deleteDownloadsConfirmButtonText => 'Delete';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Σφάλμα';

  @override
  String discNumber(int number) {
    return 'Δίσκος $number';
  }

  @override
  String get playButtonLabel => 'Αναπαραγωγή';

  @override
  String get shuffleButtonLabel => 'Τυχαία αναπαραγωγή';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τίτλοι',
      one: '$count τίτλος',
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
  String get editPlaylistNameTooltip => 'Τροποποίηση λίστας αναπαραγωγής';

  @override
  String get editPlaylistNameTitle => 'Τροποποίηση ονόματος λίστας';

  @override
  String get required => 'Απαραίτητο';

  @override
  String get updateButtonLabel => 'Ανανέωση';

  @override
  String get playlistNameUpdated => 'Ανανεώθηκε το όνομα λίστας αναπαραγωγής.';

  @override
  String get favourite => 'Αγαπημένο';

  @override
  String get downloadsDeleted => 'Διαγράφτηκαν οι λήψεις.';

  @override
  String get addDownloads => 'Προσθήκη λήψεων';

  @override
  String get location => 'Τοποθεσία';

  @override
  String get confirmDownloadStarted => 'Download started';

  @override
  String get downloadsQueued => 'Προστέθηκαν λήψεις.';

  @override
  String get addButtonLabel => 'Προσθήκη';

  @override
  String get shareLogs => 'Μοιραστείτε τις καταγραφές';

  @override
  String get logsCopied => 'Αντιγράφηκαν οι καταγραφές.';

  @override
  String get message => 'Μύνημα';

  @override
  String get stackTrace => 'Stack Trace';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Αδειοδοτηθηκε με την Άδεια Δημόσιας Χρήσης της Mozilla Public License2.0. Ο κώδικας πηγής διαθέσιμος στο:\n\ngithub.com/jmshrv/finamp';
  }

  @override
  String get transcoding => 'Μετακωδικοποίηση';

  @override
  String get downloadLocations => 'Τοποθεσίες λήψεων';

  @override
  String get audioService => 'Audio Service';

  @override
  String get interactions => 'Interactions';

  @override
  String get layoutAndTheme => 'Διάταξη καί εμφάνιση';

  @override
  String get notAvailableInOfflineMode => 'Μη διαθέσιμο σε λειτουργία εκτός σύνδεσης';

  @override
  String get logOut => 'Έξοδος';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Κατεβασμένα τραγούδια δεν θα διαγραφούν';

  @override
  String get areYouSure => 'Είσαι σίγουρος?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Το Jellyfin χρησιμοποιεί AAC για την μετακωδικοποίηση';

  @override
  String get enableTranscoding => 'Ενεργοποίηση μετακωδικοποίησης';

  @override
  String get enableTranscodingSubtitle => 'μετακωδικοποιει την ροή μουσικής από την πλευρά του διακομιστή.';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get bitrateSubtitle => 'Ο ψηλότερος bitrate προσφέρει υψηλότερης ποιότητας ήχο σε βάρος εύρους ζώνης.';

  @override
  String get customLocation => 'Εξατομικευμένη τοποθεσία';

  @override
  String get appDirectory => 'Κατάλογος εφαρμογής';

  @override
  String get addDownloadLocation => 'Προσθήκη τοποθεσίας λήψεως';

  @override
  String get selectDirectory => 'Επέλεξε κατάλογο';

  @override
  String get unknownError => 'Άγνωστο σφάλμα';

  @override
  String get pathReturnSlashErrorMessage => 'Μονοπάτια που επιστρέφουν \"/\" δεν μπορούν να χρησιμοποιηθούν';

  @override
  String get directoryMustBeEmpty => 'Ο κατάλογος πρέπει να είναι άδειος';

  @override
  String get customLocationsBuggy => 'Οι εξατομικευμένες τοποθεσίες έχουν αρκετά bugs λόγω θεμάτων αδειών.\nΣκέφτομαι τρόπους να φτιάξω τα προβλήμματα, όμως για τώρα δεν προτείνω την χρήση τους.';

  @override
  String get enterLowPriorityStateOnPause => 'Ενεργοποίηση χαμηλής-προτεραιοτητας κατάσταση κατά την παύση';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Επιτρέπει την απόσβεση της ειδοποίησης κατά την παύση. Επίσης επιτρέπει στο σύστημα να \"σκοτώνει\" την υπηρεσία κατά την παύση.';

  @override
  String get shuffleAllTrackCount => 'Τυχαία αναπαραγωγή όλων των Πλήθων τραγουδιών';

  @override
  String get shuffleAllTrackCountSubtitle => 'Πλήθος τραγουδιών να φορτώσουν όταν χρησιμοποιείται το κουμπί τυχαίας αναπαραγωγής όλων.';

  @override
  String get viewType => 'Τύπος προβολής';

  @override
  String get viewTypeSubtitle => 'Τρόπος προβολής για την οθόνη μουσικής';

  @override
  String get list => 'Λίστα';

  @override
  String get grid => 'Πλέγμα';

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
  String get portrait => 'Κάθετο';

  @override
  String get landscape => 'Οριζόντιο';

  @override
  String gridCrossAxisCount(String value) {
    return '$value πλήθος τεμνοντων αξόνων πλέγματος';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Πλήθος τετραγώνων πλέγματος ανά Πλειάδες$value.';
  }

  @override
  String get showTextOnGridView => 'Εμφάνιση αναγραφων στην προβολή πλέγματος';

  @override
  String get showTextOnGridViewSubtitle => 'Whether or not to show the text (title, artist etc) on the grid music screen.';

  @override
  String get useCoverAsBackground => 'Use blurred cover as background';

  @override
  String get useCoverAsBackgroundSubtitle => 'Whether or not to use a blurred album cover as background in various parts of the app.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Minimum album cover padding';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Minimum padding around the album cover on the player screen, in % of the screen width.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Hide track artists if same as album artists';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Whether to show track artists on the album screen if not differing from album artists.';

  @override
  String get showArtistsTopTracks => 'Show top tracks in artist view';

  @override
  String get showArtistsTopTracksSubtitle => 'Whether to show the top 5 most listened to tracks of an artist.';

  @override
  String get disableGesture => 'Disable gestures';

  @override
  String get disableGestureSubtitle => 'Whether to disables gestures.';

  @override
  String get showFastScroller => 'Show fast scroller';

  @override
  String get theme => 'Θέμα';

  @override
  String get system => 'Σύστημα';

  @override
  String get light => 'Φωτεινό';

  @override
  String get dark => 'Σκοτεινό';

  @override
  String get tabs => 'Καρτέλες';

  @override
  String get playerScreen => 'Player Screen';

  @override
  String get cancelSleepTimer => 'Ακύρωση χρονοδιακόπτη ύπνου;';

  @override
  String get yesButtonLabel => 'ΝΑΙ';

  @override
  String get noButtonLabel => 'ΟΧΙ';

  @override
  String get setSleepTimer => 'Ρύθμιση Χρονοδιακόπτη Ύπνου';

  @override
  String get hours => 'Hours';

  @override
  String get seconds => 'Seconds';

  @override
  String get minutes => 'Λεπτά';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime of $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Track $currentTrackIndex of $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Μη Έγκυρος Αριθμός';

  @override
  String get sleepTimerTooltip => 'Χρονοδιακόπτης Ύπνου';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Sleeping in $time minutes';
  }

  @override
  String get addToPlaylistTooltip => 'Προσθήκη στην λίστα αναπαραγωγής';

  @override
  String get addToPlaylistTitle => 'Προσθήκη στην Λίστα Αναπαραγωγής';

  @override
  String get addToMorePlaylistsTooltip => 'Add to more playlists';

  @override
  String get addToMorePlaylistsTitle => 'Add to More Playlists';

  @override
  String get removeFromPlaylistTooltip => 'Αφαίρεση από την λίστα αναπαραγωγής';

  @override
  String get removeFromPlaylistTitle => 'Αφαίρεση από την Λίστα Αναπαραγωγής';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Remove from playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Remove from Playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Νέα Λίστα Αναπαραγωγής';

  @override
  String get createButtonLabel => 'ΔΗΜΙΟΥΡΓΙΑ';

  @override
  String get playlistCreated => 'Η Λίστα Αναπαραγωγής δημιουργήθηκε.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Tap to add to playlist. Long press to toggle favorite.';

  @override
  String get noAlbum => 'No Album';

  @override
  String get noItem => 'No Item';

  @override
  String get noArtist => 'No Artist';

  @override
  String get unknownArtist => 'Unknown Artist';

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
  String get queue => 'Queue';

  @override
  String get addToQueue => 'Add to Queue';

  @override
  String get replaceQueue => 'Replace Queue';

  @override
  String get instantMix => 'Instant Mix';

  @override
  String get goToAlbum => 'Go to Album';

  @override
  String get goToArtist => 'Go to Artist';

  @override
  String get goToGenre => 'Go to Genre';

  @override
  String get removeFavourite => 'Remove Favourite';

  @override
  String get addFavourite => 'Add Favourite';

  @override
  String get confirmFavoriteAdded => 'Added Favorite';

  @override
  String get confirmFavoriteRemoved => 'Removed Favorite';

  @override
  String get addedToQueue => 'Added to queue.';

  @override
  String get insertedIntoQueue => 'Inserted into queue.';

  @override
  String get queueReplaced => 'Queue replaced.';

  @override
  String get confirmAddedToPlaylist => 'Added to playlist.';

  @override
  String get removedFromPlaylist => 'Removed from playlist.';

  @override
  String get startingInstantMix => 'Starting instant mix.';

  @override
  String get anErrorHasOccured => 'An error has occured.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Status code $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Status code $statusCode. This probably means you used the wrong username/password, or your client is no longer logged in.';
  }

  @override
  String get removeFromMix => 'Remove From Mix';

  @override
  String get addToMix => 'Add To Mix';

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
  String get bufferDuration => 'Buffer Duration';

  @override
  String get bufferDurationSubtitle => 'The maximum duration that should be buffered, in seconds. Requires a restart.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Don\'t limit buffer size';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.';

  @override
  String get bufferSizeTitle => 'Buffer Size';

  @override
  String get bufferSizeSubtitle => 'The maximum size of the buffer in MB. Requires a restart';

  @override
  String get language => 'Language';

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
  String get playNext => 'Play next';

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
