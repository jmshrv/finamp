import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_szl.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('sl'),
    Locale('sr'),
    Locale('sv'),
    Locale('sw'),
    Locale('szl'),
    Locale('ta'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK', scriptCode: 'Hant')
  ];

  /// App name, possibly translated
  ///
  /// In en, this message translates to:
  /// **'Finamp'**
  String get finamp;

  /// Tagline / short description for the app
  ///
  /// In en, this message translates to:
  /// **'An open source Jellyfin music player'**
  String get finampTagline;

  /// The error message that shows when startup fails.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during app startup. The error was: {error}\n\nPlease create an issue on github.com/UnicornsOnLSD/finamp with a screenshot of this page. If this problem persists you can clear your app data to reset the app.'**
  String startupError(String error);

  /// Label for the about/info button on the settings screen
  ///
  /// In en, this message translates to:
  /// **'About Finamp'**
  String get about;

  /// Text shown in the about screen, explaining that the app is made by volunteers and that the user could be one of them.
  ///
  /// In en, this message translates to:
  /// **'Made by awesome people in their free time.\nYou could be one of them!'**
  String get aboutContributionPrompt;

  /// Link to the Finamp GitHub repository, shown in the about screen.
  ///
  /// In en, this message translates to:
  /// **'Contribute to Finamp on GitHub:'**
  String get aboutContributionLink;

  /// Link to the release notes, shown in the about screen.
  ///
  /// In en, this message translates to:
  /// **'Read the latest release notes:'**
  String get aboutReleaseNotes;

  /// Link to the translation project, shown in the about screen.
  ///
  /// In en, this message translates to:
  /// **'Help translate Finamp into your language:'**
  String get aboutTranslations;

  /// Thank you message shown in the about screen.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Finamp!'**
  String get aboutThanks;

  /// Greeting shown on the login screen. The full message will be 'Welcome to Finamp'.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get loginFlowWelcomeHeading;

  /// Slogan shown on the login screen.
  ///
  /// In en, this message translates to:
  /// **'Your music, the way you want it.'**
  String get loginFlowSlogan;

  /// Button label for the login/splash screen.
  ///
  /// In en, this message translates to:
  /// **'Get Started!'**
  String get loginFlowGetStarted;

  /// Label for button shown during the login process that allows the user to view the app logs
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// Label for button shown during the login process that allows the user to change the app language
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Heading for the server selection step during the login flow.
  ///
  /// In en, this message translates to:
  /// **'Connect to Jellyfin'**
  String get loginFlowServerSelectionHeading;

  /// Label for the back button.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// Extra info for which IP to use for remote access, and info on whether or not the user needs to specify a port.
  ///
  /// In en, this message translates to:
  /// **'If you want to be able to access your Jellyfin server remotely, you need to use your external IP.\n\nIf your server is on a HTTP default port (80 or 443) or Jellyfin\'s default port (8096), you don\'t have to specify the port.\n\nIf the URL is correct, you should see some information about your server pop up below the input field.'**
  String get internalExternalIpExplanation;

  /// Hint text for the server URL input field. Should be the address to an actual, public Jellyfin server.
  ///
  /// In en, this message translates to:
  /// **'e.g. demo.jellyfin.org/stable'**
  String get serverUrlHint;

  /// Tooltip for the button that shows the extra info dialog for which IP to use for remote access, and info on whether or not the user needs to specify a port.
  ///
  /// In en, this message translates to:
  /// **'Server URL Help'**
  String get serverUrlInfoButtonTooltip;

  /// Error message that shows when the user submits a login without a server URL
  ///
  /// In en, this message translates to:
  /// **'Server URL cannot be empty'**
  String get emptyServerUrl;

  /// Text shown while the connection to the specified server is attempted
  ///
  /// In en, this message translates to:
  /// **'Connecting to server...'**
  String get connectingToServer;

  /// Heading for the list of servers on the local network, shown during the login flow. Should ideally have a colon at the end.
  ///
  /// In en, this message translates to:
  /// **'Servers on your local network:'**
  String get loginFlowLocalNetworkServers;

  /// Text shown while servers are being discovered via UDP broadcasts
  ///
  /// In en, this message translates to:
  /// **'Scanning for servers...'**
  String get loginFlowLocalNetworkServersScanningForServers;

  /// Heading for the account selection step during the login flow.
  ///
  /// In en, this message translates to:
  /// **'Select your account'**
  String get loginFlowAccountSelectionHeading;

  /// Label for the button that takes the user back to the server selection step during the login flow.
  ///
  /// In en, this message translates to:
  /// **'Back to Server Selection'**
  String get backToServerSelection;

  /// Name for a user that doesn't have a name set on the server.
  ///
  /// In en, this message translates to:
  /// **'Unnamed User'**
  String get loginFlowNamelessUser;

  /// Label for a button that allows the user to enter a custom username/password, for example if their user account is hidden.
  ///
  /// In en, this message translates to:
  /// **'Custom User'**
  String get loginFlowCustomUser;

  /// Heading for the authentication step during the login flow.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get loginFlowAuthenticationHeading;

  /// Label for the button that takes the user back to the account selection step during the login flow.
  ///
  /// In en, this message translates to:
  /// **'Back to Account Selection'**
  String get backToAccountSelection;

  /// Text shown above the quick connect code. The full message will be 'Use Quick Connect code {code}'. The code will be a 6-digit number. Ideally, 'Quick Connect' should be capitalized and translated exactly as it is in the Jellyfin web UI.
  ///
  /// In en, this message translates to:
  /// **'Use Quick Connect code'**
  String get loginFlowQuickConnectPrompt;

  /// Instructions for how and where to enter the Quick Connect code. Ideally, 'Quick Connect' should be capitalized and translated exactly as it is in the Jellyfin web UI.
  ///
  /// In en, this message translates to:
  /// **'Open the Jellyfin app or website, click on your user icon, and select Quick Connect.'**
  String get loginFlowQuickConnectInstructions;

  /// Warning that is shown during authentication if Quick Connect is disabled on the server.
  ///
  /// In en, this message translates to:
  /// **'Quick Connect is disabled on this server.'**
  String get loginFlowQuickConnectDisabled;

  /// Text that separates two different ways to log in. For example, after selecting a server during the login flow, the other can either use Quick Connect, *or* select an account from a list. The text is stylized by wrapping it in dashes: '- or -'.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// Heading for the list of users that the user can select from during the login flow.
  ///
  /// In en, this message translates to:
  /// **'Select a user'**
  String get loginFlowSelectAUser;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Hint text for the username input field.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// Error message that shows when the user submits a login without a username
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get usernameValidationMissingUsername;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Hint text for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Label for the login button.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// App bar title for library select screen
  ///
  /// In en, this message translates to:
  /// **'Select Music Libraries'**
  String get selectMusicLibraries;

  /// Error message when the user does not have any libraries
  ///
  /// In en, this message translates to:
  /// **'Could not find any libraries.'**
  String get couldNotFindLibraries;

  /// No description provided for @unknownName.
  ///
  /// In en, this message translates to:
  /// **'Unknown Name'**
  String get unknownName;

  /// No description provided for @tracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get tracks;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @startMix.
  ///
  /// In en, this message translates to:
  /// **'Start Mix'**
  String get startMix;

  /// Snackbar message that shows when the user presses the instant mix button with no artists selected
  ///
  /// In en, this message translates to:
  /// **'Long-press an artist to add or remove it from the mix builder before starting a mix'**
  String get startMixNoTracksArtist;

  /// Snackbar message that shows when the user presses the instant mix button with no albums selected
  ///
  /// In en, this message translates to:
  /// **'Long-press an album to add or remove it from the mix builder before starting a mix'**
  String get startMixNoTracksAlbum;

  /// Snackbar message that shows when the user presses the instant mix button with no genres selected
  ///
  /// In en, this message translates to:
  /// **'Long-press an genre to add or remove it from the mix builder before starting a mix'**
  String get startMixNoTracksGenre;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @shuffleAll.
  ///
  /// In en, this message translates to:
  /// **'Shuffle all'**
  String get shuffleAll;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @sortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order'**
  String get sortOrder;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @albumArtist.
  ///
  /// In en, this message translates to:
  /// **'Album Artist'**
  String get albumArtist;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @communityRating.
  ///
  /// In en, this message translates to:
  /// **'Community Rating'**
  String get communityRating;

  /// No description provided for @criticRating.
  ///
  /// In en, this message translates to:
  /// **'Critic Rating'**
  String get criticRating;

  /// No description provided for @dateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get dateAdded;

  /// No description provided for @datePlayed.
  ///
  /// In en, this message translates to:
  /// **'Date Played'**
  String get datePlayed;

  /// No description provided for @playCount.
  ///
  /// In en, this message translates to:
  /// **'Play Count'**
  String get playCount;

  /// No description provided for @premiereDate.
  ///
  /// In en, this message translates to:
  /// **'Premiere Date'**
  String get premiereDate;

  /// No description provided for @productionYear.
  ///
  /// In en, this message translates to:
  /// **'Production Year'**
  String get productionYear;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @runtime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get runtime;

  /// No description provided for @syncDownloadedPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Sync downloaded playlists'**
  String get syncDownloadedPlaylists;

  /// No description provided for @downloadMissingImages.
  ///
  /// In en, this message translates to:
  /// **'Download missing images'**
  String get downloadMissingImages;

  /// Message that shows when the user downloads missing images
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{No missing images found} =1{Downloaded {count} missing image} other{Downloaded {count} missing images}}'**
  String downloadedMissingImages(int count);

  /// No description provided for @activeDownloads.
  ///
  /// In en, this message translates to:
  /// **'Active Downloads'**
  String get activeDownloads;

  /// No description provided for @downloadCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} download} other{{count} downloads}}'**
  String downloadCount(int count);

  /// Display of downloaded track and image count on downloads screen.
  ///
  /// In en, this message translates to:
  /// **'{trackCount,plural,=1{{trackCount} track} other{{trackCount} tracks}}, {imageCount,plural,=1{{imageCount} image} other{{imageCount} images}}\n{syncCount,plural,=1{{syncCount} node syncing} other{{syncCount} nodes syncing}}{repairing, plural, =0{} other{\nCurrently repairing}}'**
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing);

  /// No description provided for @dlComplete.
  ///
  /// In en, this message translates to:
  /// **'{count} complete'**
  String dlComplete(int count);

  /// No description provided for @dlFailed.
  ///
  /// In en, this message translates to:
  /// **'{count} failed'**
  String dlFailed(int count);

  /// No description provided for @dlEnqueued.
  ///
  /// In en, this message translates to:
  /// **'{count} enqueued'**
  String dlEnqueued(int count);

  /// No description provided for @dlRunning.
  ///
  /// In en, this message translates to:
  /// **'{count} running'**
  String dlRunning(int count);

  /// No description provided for @activeDownloadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Downloads'**
  String get activeDownloadsTitle;

  /// No description provided for @noActiveDownloads.
  ///
  /// In en, this message translates to:
  /// **'No active downloads.'**
  String get noActiveDownloads;

  /// No description provided for @errorScreenError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while getting the list of errors! At this point, you should probably just create an issue on GitHub and delete app data'**
  String get errorScreenError;

  /// No description provided for @failedToGetTrackFromDownloadId.
  ///
  /// In en, this message translates to:
  /// **'Failed to get track from download ID'**
  String get failedToGetTrackFromDownloadId;

  /// Confirmation prompt shown before deleting downloaded media from the local device, destructive action, doesn't affect the media on the server.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the {itemType, select, album{album} playlist{playlist} artist{artist} genre{genre} track{track} library{library} other{item}} \'{itemName}\' from this device?'**
  String deleteDownloadsPrompt(String itemName, String itemType);

  /// Shown in the confirmation dialog for deleting downloaded media from the local device.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteDownloadsConfirmButtonText;

  /// Title for the special downloads section on the downloads screen.
  ///
  /// In en, this message translates to:
  /// **'Special downloads'**
  String get specialDownloads;

  /// Shown on the downloads screen for sections without any downloaded items.
  ///
  /// In en, this message translates to:
  /// **'No items downloaded.'**
  String get noItemsDownloaded;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @discNumber.
  ///
  /// In en, this message translates to:
  /// **'Disc {number}'**
  String discNumber(int number);

  /// No description provided for @playButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButtonLabel;

  /// No description provided for @shuffleButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffleButtonLabel;

  /// No description provided for @trackCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} Track} other{{count} Tracks}}'**
  String trackCount(int count);

  /// No description provided for @offlineTrackCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} Track} other{{count} Tracks}}, {downloads} Downloaded'**
  String offlineTrackCount(int count, int downloads);

  /// No description provided for @offlineTrackCountArtist.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} Track} other{{count} Tracks}} Downloaded'**
  String offlineTrackCountArtist(int count);

  /// No description provided for @editPlaylistNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit playlist name'**
  String get editPlaylistNameTooltip;

  /// No description provided for @editPlaylistNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Playlist Name'**
  String get editPlaylistNameTitle;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @updateButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButtonLabel;

  /// No description provided for @playlistNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Playlist name updated.'**
  String get playlistNameUpdated;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get favourite;

  /// No description provided for @downloadsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Downloads deleted.'**
  String get downloadsDeleted;

  /// No description provided for @addDownloads.
  ///
  /// In en, this message translates to:
  /// **'Add Downloads'**
  String get addDownloads;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// A confirmation message that is shown after successfully adding an item to the download queue, before it starts being processed and enqueued for download
  ///
  /// In en, this message translates to:
  /// **'Download started'**
  String get confirmDownloadStarted;

  /// No description provided for @downloadsQueued.
  ///
  /// In en, this message translates to:
  /// **'Download prepared, downloading files'**
  String get downloadsQueued;

  /// No description provided for @addButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButtonLabel;

  /// No description provided for @shareLogs.
  ///
  /// In en, this message translates to:
  /// **'Share logs'**
  String get shareLogs;

  /// No description provided for @logsCopied.
  ///
  /// In en, this message translates to:
  /// **'Logs copied.'**
  String get logsCopied;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @stackTrace.
  ///
  /// In en, this message translates to:
  /// **'Stack Trace'**
  String get stackTrace;

  /// No description provided for @applicationLegalese.
  ///
  /// In en, this message translates to:
  /// **'Licensed with the Mozilla Public License 2.0.\nSource code available at {sourceCodeLink}.'**
  String applicationLegalese(String sourceCodeLink);

  /// No description provided for @transcoding.
  ///
  /// In en, this message translates to:
  /// **'Transcoding'**
  String get transcoding;

  /// No description provided for @downloadLocations.
  ///
  /// In en, this message translates to:
  /// **'Download Locations'**
  String get downloadLocations;

  /// No description provided for @audioService.
  ///
  /// In en, this message translates to:
  /// **'Audio Service'**
  String get audioService;

  /// No description provided for @interactions.
  ///
  /// In en, this message translates to:
  /// **'Interactions'**
  String get interactions;

  /// No description provided for @layoutAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Layout & Theme'**
  String get layoutAndTheme;

  /// No description provided for @notAvailableInOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Not available in offline mode'**
  String get notAvailableInOfflineMode;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @downloadedTracksWillNotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Downloaded tracks will not be deleted'**
  String get downloadedTracksWillNotBeDeleted;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @jellyfinUsesAACForTranscoding.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin uses AAC for transcoding'**
  String get jellyfinUsesAACForTranscoding;

  /// No description provided for @enableTranscoding.
  ///
  /// In en, this message translates to:
  /// **'Enable Transcoding'**
  String get enableTranscoding;

  /// No description provided for @enableTranscodingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transcodes music streams on the server side.'**
  String get enableTranscodingSubtitle;

  /// No description provided for @bitrate.
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get bitrate;

  /// No description provided for @bitrateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A higher bitrate gives higher quality audio at the cost of higher bandwidth.'**
  String get bitrateSubtitle;

  /// No description provided for @customLocation.
  ///
  /// In en, this message translates to:
  /// **'Custom Location'**
  String get customLocation;

  /// No description provided for @appDirectory.
  ///
  /// In en, this message translates to:
  /// **'App Directory'**
  String get appDirectory;

  /// No description provided for @addDownloadLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Download Location'**
  String get addDownloadLocation;

  /// No description provided for @selectDirectory.
  ///
  /// In en, this message translates to:
  /// **'Select Directory'**
  String get selectDirectory;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// No description provided for @pathReturnSlashErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Paths that return \"/\" can\'\'t be used'**
  String get pathReturnSlashErrorMessage;

  /// No description provided for @directoryMustBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Directory must be empty'**
  String get directoryMustBeEmpty;

  /// No description provided for @customLocationsBuggy.
  ///
  /// In en, this message translates to:
  /// **'Custom locations can be extremely buggy and are not recommended in most cases. Locations under the system \'Music\' folder prevent saving album covers due to OS limitations.'**
  String get customLocationsBuggy;

  /// No description provided for @enterLowPriorityStateOnPause.
  ///
  /// In en, this message translates to:
  /// **'Enter Low-Priority State on Pause'**
  String get enterLowPriorityStateOnPause;

  /// No description provided for @enterLowPriorityStateOnPauseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lets the notification be swiped away when paused. Also allows Android to kill the service when paused.'**
  String get enterLowPriorityStateOnPauseSubtitle;

  /// No description provided for @shuffleAllTrackCount.
  ///
  /// In en, this message translates to:
  /// **'Shuffle All Track Count'**
  String get shuffleAllTrackCount;

  /// No description provided for @shuffleAllTrackCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amount of tracks to load when using the shuffle all tracks button.'**
  String get shuffleAllTrackCountSubtitle;

  /// No description provided for @viewType.
  ///
  /// In en, this message translates to:
  /// **'View Type'**
  String get viewType;

  /// No description provided for @viewTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View type for the music screen'**
  String get viewTypeSubtitle;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @grid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get grid;

  /// Title for the customization settings screen
  ///
  /// In en, this message translates to:
  /// **'Customization'**
  String get customizationSettingsTitle;

  /// Title of the visibility setting of the playback speed controls
  ///
  /// In en, this message translates to:
  /// **'Playback Speed Visibility'**
  String get playbackSpeedControlSetting;

  /// Subtitle for the playback speed visibility setting
  ///
  /// In en, this message translates to:
  /// **'Whether the playback speed controls are shown in the player screen menu'**
  String get playbackSpeedControlSettingSubtitle;

  /// Description for the dropdown that selects the replay gain mode, shown in a dialog that opens when the user presses the info icon next to the dropdown
  ///
  /// In en, this message translates to:
  /// **'Automatic:\nFinamp tries to identify whether the track you are playing is a podcast or (part of) an audiobook. This is considered to be the case if the track is longer than {trackDuration} minutes, if the track\'\'s album is longer than {albumDuration} hours, or if the track has at least one of these genres assigned: {genreList}\nPlayback speed controls will then be shown in the player screen menu.\n\nShown:\nThe playback speed controls will always be shown in the player screen menu.\n\nHidden:\nThe playback speed controls in the player screen menu are always hidden.'**
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList);

  /// Used as an option in the playback speed visibility settings
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// Used as an option in the playback speed visibility settings
  ///
  /// In en, this message translates to:
  /// **'Shown'**
  String get shown;

  /// Used as an option in the playback speed visibility settings
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// Used as a placeholder in the input of the playback speed menu
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// Used for buttons in the playback speed menu and the settings
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Used for a button in the playback speed menu
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// List tile title for grid cross axis count. Value will either be the portrait or landscape key.
  ///
  /// In en, this message translates to:
  /// **'{value} Grid Cross-Axis Count'**
  String gridCrossAxisCount(String value);

  /// List tile subtitle for grid cross axis count. Value will either be the portrait or landscape key.
  ///
  /// In en, this message translates to:
  /// **'Amount of grid tiles to use per-row when {value}.'**
  String gridCrossAxisCountSubtitle(String value);

  /// No description provided for @showTextOnGridView.
  ///
  /// In en, this message translates to:
  /// **'Show text in grid view'**
  String get showTextOnGridView;

  /// No description provided for @showTextOnGridViewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether or not to show the text (title, artist etc) on the grid music screen.'**
  String get showTextOnGridViewSubtitle;

  /// No description provided for @useCoverAsBackground.
  ///
  /// In en, this message translates to:
  /// **'Use blurred cover as background'**
  String get useCoverAsBackground;

  /// No description provided for @useCoverAsBackgroundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether or not to use a blurred album cover as background in various parts of the app.'**
  String get useCoverAsBackgroundSubtitle;

  /// Title for the editor that allows the user to set the minimum padding around the album cover on the player screen.
  ///
  /// In en, this message translates to:
  /// **'Minimum album cover padding'**
  String get playerScreenMinimumCoverPaddingEditorTitle;

  /// Subtitle for the editor that allows the user to set the minimum padding around the album cover on the player screen.
  ///
  /// In en, this message translates to:
  /// **'Minimum padding around the album cover on the player screen, in % of the screen width.'**
  String get playerScreenMinimumCoverPaddingEditorSubtitle;

  /// No description provided for @hideTrackArtistsIfSameAsAlbumArtists.
  ///
  /// In en, this message translates to:
  /// **'Hide track artists if same as album artists'**
  String get hideTrackArtistsIfSameAsAlbumArtists;

  /// No description provided for @hideTrackArtistsIfSameAsAlbumArtistsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether to show track artists on the album screen if not differing from album artists.'**
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle;

  /// No description provided for @showArtistsTopTracks.
  ///
  /// In en, this message translates to:
  /// **'Show top tracks in artist view'**
  String get showArtistsTopTracks;

  /// No description provided for @showArtistsTopTracksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether to show the top 5 most listened to tracks of an artist.'**
  String get showArtistsTopTracksSubtitle;

  /// No description provided for @disableGesture.
  ///
  /// In en, this message translates to:
  /// **'Disable gestures'**
  String get disableGesture;

  /// No description provided for @disableGestureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether to disables gestures.'**
  String get disableGestureSubtitle;

  /// No description provided for @showFastScroller.
  ///
  /// In en, this message translates to:
  /// **'Show fast scroller'**
  String get showFastScroller;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @tabs.
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get tabs;

  /// Name for the expanded player
  ///
  /// In en, this message translates to:
  /// **'Player Screen'**
  String get playerScreen;

  /// No description provided for @cancelSleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Sleep Timer?'**
  String get cancelSleepTimer;

  /// No description provided for @yesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesButtonLabel;

  /// No description provided for @noButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noButtonLabel;

  /// No description provided for @setSleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Set Sleep Timer'**
  String get setSleepTimer;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// Tooltip and accessibility label for the track progress. {currentTime} is the current position within the track, as a translated string like '2 minutes 40 seconds', and {totalTime} is the total duration of the track, also a translated string.
  ///
  /// In en, this message translates to:
  /// **'{currentTime} of {totalTime}'**
  String timeFractionTooltip(Object currentTime, Object totalTime);

  /// Tooltip and accessibility label for the queue progress. {currentTrackIndex} and {totalTrackCount} are both numbers
  ///
  /// In en, this message translates to:
  /// **'Track {currentTrackIndex} of {totalTrackCount}'**
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount);

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Number'**
  String get invalidNumber;

  /// No description provided for @sleepTimerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get sleepTimerTooltip;

  /// Button label for sleep timer. {time} is the amount of minutes left.
  ///
  /// In en, this message translates to:
  /// **'Sleeping in {time} minutes'**
  String sleepTimerRemainingTime(int time);

  /// No description provided for @addToPlaylistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylistTooltip;

  /// No description provided for @addToPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylistTitle;

  /// No description provided for @addToMorePlaylistsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to more playlists'**
  String get addToMorePlaylistsTooltip;

  /// No description provided for @addToMorePlaylistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to More Playlists'**
  String get addToMorePlaylistsTitle;

  /// No description provided for @removeFromPlaylistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from this playlist'**
  String get removeFromPlaylistTooltip;

  /// No description provided for @removeFromPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove From This Playlist'**
  String get removeFromPlaylistTitle;

  /// Tooltip for the action that removes a track from a specific playlist. The playlist name is a placeholder.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist \'{playlistName}\''**
  String removeFromPlaylistNamedTooltip(String playlistName);

  /// Tooltip for the action that removes a track from a specific playlist. The playlist name is a placeholder.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist \'{playlistName}\''**
  String removeFromPlaylistNamedTitle(String playlistName);

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get newPlaylist;

  /// No description provided for @createButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButtonLabel;

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created.'**
  String get playlistCreated;

  /// Tooltip for the (currently heart) button that opens the playlist actions menu / playlist picker by default and can toggle the favorite status on long press
  ///
  /// In en, this message translates to:
  /// **'Tap to add to playlist. Long press to toggle favorite.'**
  String get playlistActionsMenuButtonTooltip;

  /// No description provided for @noAlbum.
  ///
  /// In en, this message translates to:
  /// **'No Album'**
  String get noAlbum;

  /// No description provided for @noItem.
  ///
  /// In en, this message translates to:
  /// **'No Item'**
  String get noItem;

  /// No description provided for @noArtist.
  ///
  /// In en, this message translates to:
  /// **'No Artist'**
  String get noArtist;

  /// No description provided for @unknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get unknownArtist;

  /// No description provided for @unknownAlbum.
  ///
  /// In en, this message translates to:
  /// **'Unknown Album'**
  String get unknownAlbum;

  /// Feature chip that is shown when tracks are being played directly from the server, without transcoding
  ///
  /// In en, this message translates to:
  /// **'Direct Playing'**
  String get playbackModeDirectPlaying;

  /// Feature chip that is shown when tracks are being transcoded by the server
  ///
  /// In en, this message translates to:
  /// **'Transcoding'**
  String get playbackModeTranscoding;

  /// Label for the bitrate of a track or for transcoding. The value will be the bitrate in kilobits per second.
  ///
  /// In en, this message translates to:
  /// **'{bitrate} kbps'**
  String kiloBitsPerSecondLabel(int bitrate);

  /// Feature chip that is shown when tracks are being played from local downloads, without using the server
  ///
  /// In en, this message translates to:
  /// **'Locally Playing'**
  String get playbackModeLocal;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// Popup menu item title for adding an item to the end of the play queue.
  ///
  /// In en, this message translates to:
  /// **'Add to Queue'**
  String get addToQueue;

  /// No description provided for @replaceQueue.
  ///
  /// In en, this message translates to:
  /// **'Replace Queue'**
  String get replaceQueue;

  /// No description provided for @instantMix.
  ///
  /// In en, this message translates to:
  /// **'Instant Mix'**
  String get instantMix;

  /// No description provided for @goToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Go to Album'**
  String get goToAlbum;

  /// No description provided for @goToArtist.
  ///
  /// In en, this message translates to:
  /// **'Go to Artist'**
  String get goToArtist;

  /// No description provided for @goToGenre.
  ///
  /// In en, this message translates to:
  /// **'Go to Genre'**
  String get goToGenre;

  /// No description provided for @removeFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove Favourite'**
  String get removeFavourite;

  /// No description provided for @addFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add Favourite'**
  String get addFavourite;

  /// No description provided for @confirmFavoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added Favorite'**
  String get confirmFavoriteAdded;

  /// No description provided for @confirmFavoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed Favorite'**
  String get confirmFavoriteRemoved;

  /// Snackbar message that shows when the user successfully adds items to the end of the play queue.
  ///
  /// In en, this message translates to:
  /// **'Added to queue.'**
  String get addedToQueue;

  /// Snackbar message that shows when the user successfully inserts items into the play queue at a location that is not necessarily the end.
  ///
  /// In en, this message translates to:
  /// **'Inserted into queue.'**
  String get insertedIntoQueue;

  /// No description provided for @queueReplaced.
  ///
  /// In en, this message translates to:
  /// **'Queue replaced.'**
  String get queueReplaced;

  /// Snackbar message that shows when the user successfully adds items to a playlist.
  ///
  /// In en, this message translates to:
  /// **'Added to playlist.'**
  String get confirmAddedToPlaylist;

  /// No description provided for @removedFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Removed from playlist.'**
  String get removedFromPlaylist;

  /// No description provided for @startingInstantMix.
  ///
  /// In en, this message translates to:
  /// **'Starting instant mix.'**
  String get startingInstantMix;

  /// No description provided for @anErrorHasOccured.
  ///
  /// In en, this message translates to:
  /// **'An error has occured.'**
  String get anErrorHasOccured;

  /// No description provided for @responseError.
  ///
  /// In en, this message translates to:
  /// **'{error} Status code {statusCode}.'**
  String responseError(String error, int statusCode);

  /// No description provided for @responseError401.
  ///
  /// In en, this message translates to:
  /// **'{error} Status code {statusCode}. This probably means you used the wrong username/password, or your client is no longer logged in.'**
  String responseError401(String error, int statusCode);

  /// No description provided for @removeFromMix.
  ///
  /// In en, this message translates to:
  /// **'Remove From Mix'**
  String get removeFromMix;

  /// No description provided for @addToMix.
  ///
  /// In en, this message translates to:
  /// **'Add To Mix'**
  String get addToMix;

  /// No description provided for @redownloadedItems.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{No redownloads needed.} =1{Redownloaded {count} item} other{Redownloaded {count} items}}'**
  String redownloadedItems(int count);

  /// No description provided for @bufferDuration.
  ///
  /// In en, this message translates to:
  /// **'Buffer Duration'**
  String get bufferDuration;

  /// No description provided for @bufferDurationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The maximum duration that should be buffered, in seconds. Requires a restart.'**
  String get bufferDurationSubtitle;

  /// No description provided for @bufferDisableSizeConstraintsTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t limit buffer size'**
  String get bufferDisableSizeConstraintsTitle;

  /// No description provided for @bufferDisableSizeConstraintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disables the buffer size constraints (\'Buffer Size\'). The buffer will always be loaded to the configured duration (\'Buffer Duration\'), even for very large files. Can cause crashes. Requires a restart.'**
  String get bufferDisableSizeConstraintsSubtitle;

  /// No description provided for @bufferSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Buffer Size'**
  String get bufferSizeTitle;

  /// No description provided for @bufferSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The maximum size of the buffer in MB. Requires a restart'**
  String get bufferSizeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Tooltip for the button that skips to the beginning of the current track or to the previous track
  ///
  /// In en, this message translates to:
  /// **'Skip to beginning or to previous track'**
  String get skipToPreviousTrackButtonTooltip;

  /// Tooltip for the button that skips to the next track
  ///
  /// In en, this message translates to:
  /// **'Skip to next track'**
  String get skipToNextTrackButtonTooltip;

  /// Tooltip for the button that toggles playback
  ///
  /// In en, this message translates to:
  /// **'Toggle playback'**
  String get togglePlaybackButtonTooltip;

  /// Description in the queue panel for the list of tracks that come before the current track in the queue. The tracks might not actually have been played (e.g. if the user skipped ahead to a specific track).
  ///
  /// In en, this message translates to:
  /// **'Previous Tracks'**
  String get previousTracks;

  /// Description in the queue panel for the list of tracks were manually added to be played after the current track. This should be capitalized (if applicable) to be more recognizable throughout the UI
  ///
  /// In en, this message translates to:
  /// **'Next Up'**
  String get nextUp;

  /// Label for the action that deletes all tracks added to Next Up
  ///
  /// In en, this message translates to:
  /// **'Clear Next Up'**
  String get clearNextUp;

  /// Label for a button that stops playback and removes all tracks from the queue.
  ///
  /// In en, this message translates to:
  /// **'Clear Queue'**
  String get clearQueue;

  /// Prefix shown before the name of the main queue source, like the album or playlist that was used to start playback. Example: "Playing from {My Nice Playlist}"
  ///
  /// In en, this message translates to:
  /// **'Playing from'**
  String get playingFrom;

  /// Used for adding a track to the "Next Up" queue at the first position, to play right after the current track finishes playing
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get playNext;

  /// Used for adding a track to the "Next Up" queue at the end, to play after all prior tracks from Next Up have played
  ///
  /// In en, this message translates to:
  /// **'Add to Next Up'**
  String get addToNextUp;

  /// Used for shuffling a list (album, playlist, etc.) to the "Next Up" queue at the first position, to play right after the current track finishes playing
  ///
  /// In en, this message translates to:
  /// **'Shuffle next'**
  String get shuffleNext;

  /// Used for shuffling a list (album, playlist, etc.) to the end of the "Next Up" queue, to play after all prior tracks from Next Up have played
  ///
  /// In en, this message translates to:
  /// **'Shuffle to Next Up'**
  String get shuffleToNextUp;

  /// Used for shuffling a list (album, playlist, etc.) to the end of the regular queue, to play after all prior tracks from the queue have played
  ///
  /// In en, this message translates to:
  /// **'Shuffle to queue'**
  String get shuffleToQueue;

  /// A confirmation message that is shown after successfully adding a track to the front of the "Next Up" queue
  ///
  /// In en, this message translates to:
  /// **'{type, select, track{Track} album{Album} artist{Artist} playlist{Playlist} genre{Genre} other{Item}} will play next'**
  String confirmPlayNext(String type);

  /// A confirmation message that is shown after successfully adding a track to the end of the "Next Up" queue
  ///
  /// In en, this message translates to:
  /// **'Added {type, select, track{Track} album{album} artist{artist} playlist{playlist} genre{genre} other{item}} to Next Up'**
  String confirmAddToNextUp(String type);

  /// A confirmation message that is shown after successfully adding a track to the end of the regular queue
  ///
  /// In en, this message translates to:
  /// **'Added {type, select, track{track} album{album} artist{artist} playlist{playlist} genre{genre} other{item}} to queue'**
  String confirmAddToQueue(String type);

  /// A confirmation message that is shown after successfully shuffling a list (album, playlist, etc.) to the front of the "Next Up" queue
  ///
  /// In en, this message translates to:
  /// **'Will shuffle next'**
  String get confirmShuffleNext;

  /// A confirmation message that is shown after successfully shuffling a list (album, playlist, etc.) to the end of the "Next Up" queue
  ///
  /// In en, this message translates to:
  /// **'Shuffled to Next Up'**
  String get confirmShuffleToNextUp;

  /// A confirmation message that is shown after successfully shuffling a list (album, playlist, etc.) to the end of the regular queue
  ///
  /// In en, this message translates to:
  /// **'Shuffled to queue'**
  String get confirmShuffleToQueue;

  /// Placeholder text used when the source of the current track/queue is unknown
  ///
  /// In en, this message translates to:
  /// **'Somewhere'**
  String get placeholderSource;

  /// Title for the playback history screen, where the user can see a list of recently played tracks, sorted by
  ///
  /// In en, this message translates to:
  /// **'Playback History'**
  String get playbackHistory;

  /// Button for exporting the JSON file containing any playback events that couldn't be submitted to the server, either because offline mode was enabled or the connection failed
  ///
  /// In en, this message translates to:
  /// **'Share offline listens'**
  String get shareOfflineListens;

  /// Title for the queue source when the user is playing their liked tracks
  ///
  /// In en, this message translates to:
  /// **'Your Likes'**
  String get yourLikes;

  /// Suffix added to a queue source when playing a mix. Example: "Never Gonna Give You Up - Mix"
  ///
  /// In en, this message translates to:
  /// **'{mixSource} - Mix'**
  String mix(String mixSource);

  /// Title for the queue source for tracks that were once added to the queue via the "Next Up" feature, but have since been played
  ///
  /// In en, this message translates to:
  /// **'Tracks added via Next Up'**
  String get tracksFormerNextUp;

  /// Title for the queue source for tracks were previously in the queue before an app restart and have been reloaded
  ///
  /// In en, this message translates to:
  /// **'Saved Queue'**
  String get savedQueue;

  /// Prefix shown before the type of the main queue source at the top of the player screen. Example: "Playing From Album"
  ///
  /// In en, this message translates to:
  /// **'Playing From {source, select, album{Album} playlist{Playlist} trackMix{Track Mix} artistMix{Artist Mix} albumMix{Album Mix} genreMix{Genre Mix} favorites{Favorites} allTracks{All Tracks} filteredList{Tracks} genre{Genre} artist{Artist} track{Track} nextUpAlbum{Album in Next Up} nextUpPlaylist{Playlist in Next Up} nextUpArtist{Artist in Next Up} other{}}'**
  String playingFromType(String source);

  /// Title for the queue source when the user is shuffling all tracks. Should be capitalized (if applicable) to be more recognizable throughout the UI
  ///
  /// In en, this message translates to:
  /// **'Shuffle All'**
  String get shuffleAllQueueSource;

  /// Label for the button that toggles the playback order between linear/in-order and shuffle, while the queue is in linear/in-order mode
  ///
  /// In en, this message translates to:
  /// **'Playing in order'**
  String get playbackOrderLinearButtonLabel;

  /// Tooltip for the button that toggles the playback order between linear/in-order and shuffle, while the queue is in linear/in-order mode
  ///
  /// In en, this message translates to:
  /// **'Playing in order. Tap to shuffle.'**
  String get playbackOrderLinearButtonTooltip;

  /// Label for the button that toggles the playback order between linear/in-order and shuffle, while the queue is in shuffle mode
  ///
  /// In en, this message translates to:
  /// **'Shuffling tracks'**
  String get playbackOrderShuffledButtonLabel;

  /// Tooltip for the button that toggles the playback order between linear/in-order and shuffle, while the queue is in shuffle mode
  ///
  /// In en, this message translates to:
  /// **'Shuffling tracks. Tap to play in order.'**
  String get playbackOrderShuffledButtonTooltip;

  /// Label for the button that toggles visibility. of the playback speed menu, {speed} is the current playback speed.
  ///
  /// In en, this message translates to:
  /// **'Playing at x{speed} speed'**
  String playbackSpeedButtonLabel(double speed);

  /// Label for the feature chip that is shown if the playback speed is different from x1, {speed} is the current playback speed.
  ///
  /// In en, this message translates to:
  /// **'x{speed} speed'**
  String playbackSpeedFeatureText(double speed);

  /// Label for the button in the speed menu that decreases the playback speed.
  ///
  /// In en, this message translates to:
  /// **'Decrease playback speed'**
  String get playbackSpeedDecreaseLabel;

  /// Label for the button in the speed menu that increases the playback speed.
  ///
  /// In en, this message translates to:
  /// **'Increase playback speed'**
  String get playbackSpeedIncreaseLabel;

  /// Label for the button that toggles the loop mode between off, loop one, and loop all, while the queue is in loop off mode
  ///
  /// In en, this message translates to:
  /// **'Not looping'**
  String get loopModeNoneButtonLabel;

  /// Label for the button that toggles the loop mode between off, loop one, and loop all, while the queue is in loop one mode
  ///
  /// In en, this message translates to:
  /// **'Looping this track'**
  String get loopModeOneButtonLabel;

  /// Label for the button that toggles the loop mode between off, loop one, and loop all, while the queue is in loop all mode
  ///
  /// In en, this message translates to:
  /// **'Looping all'**
  String get loopModeAllButtonLabel;

  /// Title for the screen where older now playing queues can be restored
  ///
  /// In en, this message translates to:
  /// **'Restore Now Playing'**
  String get queuesScreen;

  /// Button to restore archived now playing queue, overwriting current queue
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get queueRestoreButtonLabel;

  /// Description of when a saved queue was saved
  ///
  /// In en, this message translates to:
  /// **'Saved {date}'**
  String queueRestoreTitle(DateTime date);

  /// Description of playing track in a saved queue
  ///
  /// In en, this message translates to:
  /// **'Playing: {track}'**
  String queueRestoreSubtitle1(String track);

  /// Description of length of a saved queue
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{1 Track} other{{count} Tracks}}, {remaining} Unplayed'**
  String queueRestoreSubtitle2(int count, int remaining);

  /// Message displayed on now-playing bar when a saved queue is loading.
  ///
  /// In en, this message translates to:
  /// **'Restoring queue...'**
  String get queueLoadingMessage;

  /// Message displayed on now-playing bar when all items in a saved queue fail to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore queue. Retry?'**
  String get queueRetryMessage;

  /// Setting to restore last queue on startup
  ///
  /// In en, this message translates to:
  /// **'Auto-Restore Last Queue'**
  String get autoloadLastQueueOnStartup;

  /// Description of the setting to restore last queue on startup
  ///
  /// In en, this message translates to:
  /// **'Upon app startup, attempt to restore the last played queue.'**
  String get autoloadLastQueueOnStartupSubtitle;

  /// Label for the setting that toggles reporting of the current queue to the Jellyfin server
  ///
  /// In en, this message translates to:
  /// **'Report current queue to server?'**
  String get reportQueueToServer;

  /// Description of the setting that toggles reporting of the current queue to the Jellyfin server
  ///
  /// In en, this message translates to:
  /// **'When enabled, Finamp will send the current queue to the server. There currently seems to be little use for this, and it increases network traffic.'**
  String get reportQueueToServerSubtitle;

  /// Label for the setting that controls how frequently (in seconds) the current playback session is reported to the Jellyfin server
  ///
  /// In en, this message translates to:
  /// **'Playback session update frequency'**
  String get periodicPlaybackSessionUpdateFrequency;

  /// Description of the setting that controls how frequently (in seconds) the current playback session is reported to the Jellyfin server
  ///
  /// In en, this message translates to:
  /// **'How often to send the current playback status to the server, in seconds. This should be less than 5 minutes (300 seconds), to prevent the session from timing out.'**
  String get periodicPlaybackSessionUpdateFrequencySubtitle;

  /// Additional details for the setting that controls how frequently (in seconds) the current playback session is reported to the Jellyfin server
  ///
  /// In en, this message translates to:
  /// **'If the Jellyfin server hasn\'\'t received any updates from a client in the last 5 minutes, it assumes that playback has ended. This means that for tracks longer than 5 minutes, that playback could be incorrectly reported as having ended, which reduced the quality of the playback reporting data.'**
  String get periodicPlaybackSessionUpdateFrequencyDetails;

  /// No description provided for @topTracks.
  ///
  /// In en, this message translates to:
  /// **'Top Tracks'**
  String get topTracks;

  /// No description provided for @albumCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=1{{count} Album} other{{count} Albums}}'**
  String albumCount(int count);

  /// Label for action that shuffles all albums of an artist or genre
  ///
  /// In en, this message translates to:
  /// **'Shuffle Albums'**
  String get shuffleAlbums;

  /// Label for action that shuffles all albums of an artist or genre and adds them at the start of Next Up
  ///
  /// In en, this message translates to:
  /// **'Shuffle Albums Next'**
  String get shuffleAlbumsNext;

  /// Label for action that shuffles all albums of an artist or genre and adds them at the end of Next Up
  ///
  /// In en, this message translates to:
  /// **'Shuffle Albums To Next Up'**
  String get shuffleAlbumsToNextUp;

  /// Label for action that shuffles all albums of an artist or genre and adds them at the end of the regular queue
  ///
  /// In en, this message translates to:
  /// **'Shuffle Albums To Queue'**
  String get shuffleAlbumsToQueue;

  /// No description provided for @playCountValue.
  ///
  /// In en, this message translates to:
  /// **'{playCount,plural,=1{{playCount} play} other{{playCount} plays}}'**
  String playCountValue(int playCount);

  /// No description provided for @couldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t load {source, select, album{album} playlist{playlist} trackMix{track mix} artistMix{artist mix} albumMix{album mix} genreMix{genre mix} favorites{favorites} allTracks{all tracks} filteredList{tracks} genre{genre} artist{artist} track{track} nextUpAlbum{album in next up} nextUpPlaylist{playlist in next up} nextUpArtist{artist in next up} other{}}'**
  String couldNotLoad(String source);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @showUncensoredLogMessage.
  ///
  /// In en, this message translates to:
  /// **'This log contains your login information. Show?'**
  String get showUncensoredLogMessage;

  /// No description provided for @resetTabs.
  ///
  /// In en, this message translates to:
  /// **'Reset tabs'**
  String get resetTabs;

  /// No description provided for @resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get resetToDefaults;

  /// Title for message that shows on the views screen when no music libraries could be found.
  ///
  /// In en, this message translates to:
  /// **'No Music Libraries'**
  String get noMusicLibrariesTitle;

  /// No description provided for @noMusicLibrariesBody.
  ///
  /// In en, this message translates to:
  /// **'Finamp could not find any music libraries. Please ensure that your Jellyfin server contains at least one library with the content type set to \"Music\".'**
  String get noMusicLibrariesBody;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @moreInfo.
  ///
  /// In en, this message translates to:
  /// **'More Info'**
  String get moreInfo;

  /// Title for the replay gain settings screen
  ///
  /// In en, this message translates to:
  /// **'Volume Normalization'**
  String get volumeNormalizationSettingsTitle;

  /// Title for the switch that toggles replay gain
  ///
  /// In en, this message translates to:
  /// **'Enable Volume Normalization'**
  String get volumeNormalizationSwitchTitle;

  /// Subtitle for the switch that toggles replay gain
  ///
  /// In en, this message translates to:
  /// **'Use gain information to normalize the loudness of tracks (\"Replay Gain\")'**
  String get volumeNormalizationSwitchSubtitle;

  /// Title for the dropdown that selects the replay gain mode
  ///
  /// In en, this message translates to:
  /// **'Volume Normalization Mode'**
  String get volumeNormalizationModeSelectorTitle;

  /// Subtitle for the dropdown that selects the replay gain mode
  ///
  /// In en, this message translates to:
  /// **'When and how to apply Volume Normalization'**
  String get volumeNormalizationModeSelectorSubtitle;

  /// Description for the dropdown that selects the replay gain mode, shown in a dialog that opens when the user presses the info icon next to the dropdown
  ///
  /// In en, this message translates to:
  /// **'Hybrid (Track + Album):\nTrack gain is used for regular playback, but if an album is playing (either because it\'\'s the main playback queue source, or because it was added to the queue at some point), the album gain is used instead.\n\nTrack-based:\nTrack gain is always used, regardless of whether an album is playing or not.\n\nAlbums Only:\nVolume Normalization is only applied while playing albums (using the album gain), but not for individual tracks.'**
  String get volumeNormalizationModeSelectorDescription;

  /// 'Hybrid' option for the replay gain mode dropdown. In hybrid mode, the track gain is used for regular playback, but if an album is playing (either because it's the main playback queue source, or because it was added to the queue at some point), the album gain is used instead.
  ///
  /// In en, this message translates to:
  /// **'Hybrid (Track + Album)'**
  String get volumeNormalizationModeHybrid;

  /// 'Track-based' option for the replay gain mode dropdown. In track-based mode, the track gain is always used, regardless of whether an album is playing or not.
  ///
  /// In en, this message translates to:
  /// **'Track-based'**
  String get volumeNormalizationModeTrackBased;

  /// 'Album-based' option for the replay gain mode dropdown. In album-based mode, the album gain is always used, regardless of whether an album is playing or not.
  ///
  /// In en, this message translates to:
  /// **'Album-based'**
  String get volumeNormalizationModeAlbumBased;

  /// 'Only for Albums' option for the replay gain mode dropdown. In albums-only mode, Volume Normalization is only applied while playing albums (using the album gain), but not for individual tracks.
  ///
  /// In en, this message translates to:
  /// **'Only for Albums'**
  String get volumeNormalizationModeAlbumOnly;

  /// Title for the input that sets the replay gain base gain on iOS and other non-Android platforms
  ///
  /// In en, this message translates to:
  /// **'Base Gain'**
  String get volumeNormalizationIOSBaseGainEditorTitle;

  /// Subtitle for the input that sets the replay gain base gain on iOS and other non-Android platforms
  ///
  /// In en, this message translates to:
  /// **'Currently, Volume Normalization on iOS requires changing the playback volume to emulate the gain change. Since we can\'\'t increase the volume above 100%, we need to decrease the volume by default so that we can boost the volume of quiet tracks. The value is in decibels (dB), where -10 dB is ~30% volume, -4.5 dB is ~60% volume and -2 dB is ~80% volume.'**
  String get volumeNormalizationIOSBaseGainEditorSubtitle;

  /// Label for a number that represents a decibel value. The value will be the decibel value.
  ///
  /// In en, this message translates to:
  /// **'{value} dB'**
  String numberAsDecibel(double value);

  /// No description provided for @swipeInsertQueueNext.
  ///
  /// In en, this message translates to:
  /// **'Play Swiped Track Next'**
  String get swipeInsertQueueNext;

  /// No description provided for @swipeInsertQueueNextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to insert a track as next item in queue when swiped in track list instead of appending it to the end.'**
  String get swipeInsertQueueNextSubtitle;

  /// Title for the switch that toggles if tapping a track on the tracks tab will start an instant mix of that track instead of just playing a single track.
  ///
  /// In en, this message translates to:
  /// **'Start Instant Mixes for Individual Tracks'**
  String get startInstantMixForIndividualTracksSwitchTitle;

  /// No description provided for @startInstantMixForIndividualTracksSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When enabled, tapping a track on the tracks tab will start an instant mix of that track instead of just playing a single track.'**
  String get startInstantMixForIndividualTracksSwitchSubtitle;

  /// Option to download item in long-press menu.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadItem;

  /// Message displayed after download repair completes.
  ///
  /// In en, this message translates to:
  /// **'Downloads Repair complete.'**
  String get repairComplete;

  /// Message displayed after download sync completes.
  ///
  /// In en, this message translates to:
  /// **'All downloads re-synced.'**
  String get syncComplete;

  /// Tooltip for downloads sync button.
  ///
  /// In en, this message translates to:
  /// **'Sync and download missing items.'**
  String get syncDownloads;

  /// Tooltip for downloads repair button.
  ///
  /// In en, this message translates to:
  /// **'Repair issues with downloaded files or metadata.'**
  String get repairDownloads;

  /// Description of setting for only performing downloads while on wifi
  ///
  /// In en, this message translates to:
  /// **'Require WiFi when downloading.'**
  String get requireWifiForDownloads;

  /// Message that shows when some, but not all, tracks in the Now-Playing queue from the previous session cannot be restored due to server issues or being offline.
  ///
  /// In en, this message translates to:
  /// **'Warning: {count,plural, =1{{count} track} other{{count} tracks}} could not be restored to the queue.'**
  String queueRestoreError(int count);

  /// Header text for lists of active downloads of a particular state.
  ///
  /// In en, this message translates to:
  /// **'{itemCount} {typeName, select, downloading{Running} failed{Failed} syncFailed{Repeatedly Unsynced} enqueued{Queued} other{}} {itemCount, plural, =1{Download} other{Downloads}}'**
  String activeDownloadsListHeader(String typeName, int itemCount);

  /// Confirmation prompt before downloading entire library, which may be large.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to download all contents of the library \'\'{libraryName}\'\'?'**
  String downloadLibraryPrompt(String libraryName);

  /// Tooltip for button that hides all partially downloaded albums
  ///
  /// In en, this message translates to:
  /// **'Only show fully downloaded albums'**
  String get onlyShowFullyDownloaded;

  /// Message shown when a download cannot complete due to the filesystem being full.
  ///
  /// In en, this message translates to:
  /// **'Remaining downloads cannot be completed. The filesystem is full.'**
  String get filesystemFull;

  /// Message shown when the connection is interrupted during a download.
  ///
  /// In en, this message translates to:
  /// **'Connection interrupted, pausing downloads.'**
  String get connectionInterrupted;

  /// Message shown when the connection is interrupted during a download while in the background. It advises checking OS settings, as they may cause background downloads to be blocked.
  ///
  /// In en, this message translates to:
  /// **'Connection was interrupted while downloading in the background. This can be caused by OS settings.'**
  String get connectionInterruptedBackground;

  /// Message shown when the connection is interrupted during a download while in the background on android. It advises checking OS settings, as they may cause background downloads to be blocked, or checking the  'Enter Low-Priority State on Pause' setting.
  ///
  /// In en, this message translates to:
  /// **'Connection was interrupted while downloading in the background. This can be caused by enabling \'Enter Low-Priority State on Pause\' or OS settings.'**
  String get connectionInterruptedBackgroundAndroid;

  /// Message shown for download size while item is still being downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get activeDownloadSize;

  /// Message shown for download size while item is being deleted but is not fully removed
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get missingDownloadSize;

  /// Message shown for download size while item is still syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncingDownloadSize;

  /// Message shown when an error occurs during the downloads repair step of the Isar downloads migration, which requires a server connection.
  ///
  /// In en, this message translates to:
  /// **'The server could not be contacted to finalize downloads migration. Please run \'Repair Downloads\' from the downloads screen as soon as you are back online.'**
  String get runRepairWarning;

  /// No description provided for @downloadSettings.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloadSettings;

  /// Title of setting that shows tracks/albums from an unknown library in all libraries when on, or in no libraries when off.
  ///
  /// In en, this message translates to:
  /// **'Show Media with Unknown Library.'**
  String get showNullLibraryItemsTitle;

  /// Description of setting that shows tracks/albums from an unknown library in all libraries when on, or in no libraries when off.
  ///
  /// In en, this message translates to:
  /// **'Some media may be downloaded with an unknown library. Turn off to hide these outside their original collection.'**
  String get showNullLibraryItemsSubtitle;

  /// Title of setting controlling max concurrent downloads.
  ///
  /// In en, this message translates to:
  /// **'Max Concurrent Downloads'**
  String get maxConcurrentDownloads;

  /// Description of setting controlling max concurrent downloads.
  ///
  /// In en, this message translates to:
  /// **'Increasing concurrent downloads may allow increased downloading in the background but may cause some downloads to fail if very large, or cause excessive lag in some cases.'**
  String get maxConcurrentDownloadsSubtitle;

  /// Label of values on max concurrent downloads slider
  ///
  /// In en, this message translates to:
  /// **'{count} Concurrent Downloads'**
  String maxConcurrentDownloadsLabel(String count);

  /// Title of setting controlling download worker count.
  ///
  /// In en, this message translates to:
  /// **'Download Worker count'**
  String get downloadsWorkersSetting;

  /// Description of setting controlling download worker count.
  ///
  /// In en, this message translates to:
  /// **'Amount of workers for syncing metadata and deleting downloads. Increasing download workers may speed up download syncing and deleting, especially when server latency is high, but can introduce lag.'**
  String get downloadsWorkersSettingSubtitle;

  /// Label of values on download worker count slider
  ///
  /// In en, this message translates to:
  /// **'{count} Download Workers'**
  String downloadsWorkersSettingLabel(String count);

  /// Title of setting for automatically triggering a throttled resync on app startup.
  ///
  /// In en, this message translates to:
  /// **'Automatically Sync Downloads at Startup'**
  String get syncOnStartupSwitch;

  /// Title of setting that skips completed albums while syncing.
  ///
  /// In en, this message translates to:
  /// **'Prefer Quick Syncs'**
  String get preferQuickSyncSwitch;

  /// Description of setting that skips completed albums while syncing.
  ///
  /// In en, this message translates to:
  /// **'When performing syncs, some typically static items (like tracks and albums) will not be updated. Download repair will always perform a full sync.'**
  String get preferQuickSyncSwitchSubtitle;

  /// Subtitle for the type of a downloaded item, shown when syncing fails and in DownloadButton tooltip.
  ///
  /// In en, this message translates to:
  /// **'{itemType, select, album{Album} playlist{Playlist} artist{Artist} genre{Genre} track{Track} library{Library} unknown{Item} other{{itemType}}} {itemName}'**
  String itemTypeSubtitle(String itemType, String itemName);

  /// Tooltip for downloadbutton on incidental downloads, which show a lock icon. It says one of the requiring downloads.
  ///
  /// In en, this message translates to:
  /// **'This item is required to be downloaded by {parentName}.'**
  String incidentalDownloadTooltip(String parentName);

  /// Localized names of special downloadable collections like favorites.
  ///
  /// In en, this message translates to:
  /// **'{itemType, select, favorites{Favorites} allPlaylists{All Playlists} fiveLatestAlbums{5 Latest Albums} allPlaylistsMetadata{Playlist Metadata} other{{itemType}} }'**
  String finampCollectionNames(String itemType);

  /// Localized names of special downloadable collection representing cached images for a certain library.
  ///
  /// In en, this message translates to:
  /// **'Cached Images for \'{libraryName}\''**
  String cacheLibraryImagesName(String libraryName);

  /// Title for the dropdown that selects the container format for transcoded streams
  ///
  /// In en, this message translates to:
  /// **'Select Transcoding Container'**
  String get transcodingStreamingContainerTitle;

  /// No description provided for @transcodingStreamingContainerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the segment container to use when streaming transcoded audio. Already queued tracks will not be affected.'**
  String get transcodingStreamingContainerSubtitle;

  /// Title for Enable Transcoded Downloads dropdown
  ///
  /// In en, this message translates to:
  /// **'Enable Transcoded Downloads'**
  String get downloadTranscodeEnableTitle;

  /// Title for Select Download Codec dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Download Codec'**
  String get downloadTranscodeCodecTitle;

  /// Options in Select Download Codec dropdown
  ///
  /// In en, this message translates to:
  /// **'{option, select, always{Always} never{Never} ask{Ask} other{{option}} }'**
  String downloadTranscodeEnableOption(String option);

  /// Title for Download Bitrate settings slider
  ///
  /// In en, this message translates to:
  /// **'Download Bitrate'**
  String get downloadBitrate;

  /// subtitle for Download Bitrate settings slider
  ///
  /// In en, this message translates to:
  /// **'A higher bitrate gives higher quality audio at the cost of larger storage requirements.'**
  String get downloadBitrateSubtitle;

  /// Initial text in downloads dropdown when 'Enable Transcoded Downloads' is set to ask.
  ///
  /// In en, this message translates to:
  /// **'Transcode?'**
  String get transcodeHint;

  /// Dropdown option to download transcoded version of tracks
  ///
  /// In en, this message translates to:
  /// **'Download as {codec} @ {bitrate}{size, select, null{} other{ - ~{size}}}'**
  String doTranscode(String bitrate, String codec, String size);

  /// Track info line in downloads screen lists
  ///
  /// In en, this message translates to:
  /// **'{size} {codec}{bitrate, select, null{} other{ @ {bitrate} Transcoded}}'**
  String downloadInfo(String bitrate, String codec, String size);

  /// Collection info line in downloads screen lists
  ///
  /// In en, this message translates to:
  /// **'{size}{codec, select, ORIGINAL{} other{ as {codec} @ {bitrate}}}'**
  String collectionDownloadInfo(String bitrate, String codec, String size);

  /// Dropdown option to download original version of tracks
  ///
  /// In en, this message translates to:
  /// **'Download original{description, select, null{} other{ - {description}}}'**
  String dontTranscode(String description);

  /// Mesage when Automatically Redownload Transcodes transcode setting completes operations.
  ///
  /// In en, this message translates to:
  /// **'Transcode Redownload queued.'**
  String get redownloadcomplete;

  /// Title for download transcode setting which redownloads tracks with higher allowed qualities
  ///
  /// In en, this message translates to:
  /// **'Automatically Redownload Transcodes'**
  String get redownloadTitle;

  /// subtitle for download transcode setting which redownloads tracks with higher allowed qualities
  ///
  /// In en, this message translates to:
  /// **'Automatically redownload tracks which are expected to be at a different quality due to parent collection changes.'**
  String get redownloadSubtitle;

  /// Tooltip for button that sets a download location as the default.
  ///
  /// In en, this message translates to:
  /// **'Set as default download location.  Disable to select per download.'**
  String get defaultDownloadLocationButton;

  /// No description provided for @fixedGridSizeSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Use fixed size grid tiles'**
  String get fixedGridSizeSwitchTitle;

  /// No description provided for @fixedGridSizeSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grid tile sizes will not respond to window/screen size.'**
  String get fixedGridSizeSwitchSubtitle;

  /// No description provided for @fixedGridSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Grid Tile Size'**
  String get fixedGridSizeTitle;

  /// Localized names of fixed size grid tile sizes.
  ///
  /// In en, this message translates to:
  /// **'{size, select, small{Small} medium{Medium} large{Large} veryLarge{Very Large} other{???}}'**
  String fixedGridTileSizeEnum(String size);

  /// No description provided for @allowSplitScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow SplitScreen Mode'**
  String get allowSplitScreenTitle;

  /// No description provided for @allowSplitScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The player will be displayed alongside other views on wider displays.'**
  String get allowSplitScreenSubtitle;

  /// No description provided for @enableVibration.
  ///
  /// In en, this message translates to:
  /// **'Enable vibration'**
  String get enableVibration;

  /// No description provided for @enableVibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether to enable vibration.'**
  String get enableVibrationSubtitle;

  /// No description provided for @hideQueueButton.
  ///
  /// In en, this message translates to:
  /// **'Hide queue button'**
  String get hideQueueButton;

  /// No description provided for @hideQueueButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide the queue button on the player screen. Swipe up to access the queue.'**
  String get hideQueueButtonSubtitle;

  /// No description provided for @oneLineMarqueeTextButton.
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll Long Titles'**
  String get oneLineMarqueeTextButton;

  /// No description provided for @oneLineMarqueeTextButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically scroll track titles that are too long to display in two lines'**
  String get oneLineMarqueeTextButtonSubtitle;

  /// No description provided for @marqueeOrTruncateButton.
  ///
  /// In en, this message translates to:
  /// **'Use ellipsis for long titles'**
  String get marqueeOrTruncateButton;

  /// No description provided for @marqueeOrTruncateButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show ... at the end of long titles instead of scrolling text'**
  String get marqueeOrTruncateButtonSubtitle;

  /// No description provided for @hidePlayerBottomActions.
  ///
  /// In en, this message translates to:
  /// **'Hide bottom actions'**
  String get hidePlayerBottomActions;

  /// No description provided for @hidePlayerBottomActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide the queue and lyrics buttons on the player screen. Swipe up to access the queue, swipe left (below the album cover) to view lyrics if available.'**
  String get hidePlayerBottomActionsSubtitle;

  /// No description provided for @prioritizePlayerCover.
  ///
  /// In en, this message translates to:
  /// **'Prioritize album cover'**
  String get prioritizePlayerCover;

  /// No description provided for @prioritizePlayerCoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prioritize showing a larger album cover on player screen. Non-critical controls will be hidden more aggressively at small screen sizes.'**
  String get prioritizePlayerCoverSubtitle;

  /// No description provided for @suppressPlayerPadding.
  ///
  /// In en, this message translates to:
  /// **'Suppress player controls padding'**
  String get suppressPlayerPadding;

  /// No description provided for @suppressPlayerPaddingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fully minimizes padding between player screen controls when album cover is not at full size.'**
  String get suppressPlayerPaddingSubtitle;

  /// Text shown on button to require an item which is already downloaded by a parent collection, preventing it from being deleted if the parent is removed.
  ///
  /// In en, this message translates to:
  /// **'Always Keep on Device'**
  String get lockDownload;

  /// No description provided for @showArtistChipImage.
  ///
  /// In en, this message translates to:
  /// **'Show artist images with artist name'**
  String get showArtistChipImage;

  /// No description provided for @showArtistChipImageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This affects small artist image previews, such as on the player screen.'**
  String get showArtistChipImageSubtitle;

  /// Tooltip for button that scrolls the queue list back to the current track
  ///
  /// In en, this message translates to:
  /// **'Scroll to current track'**
  String get scrollToCurrentTrack;

  /// Tooltip for button that can be used to re-enable auto scroll on the lyrics view after the user manually scrolled
  ///
  /// In en, this message translates to:
  /// **'Enable auto-scroll'**
  String get enableAutoScroll;

  /// Value for the sample rate of a track, in kilohertz
  ///
  /// In en, this message translates to:
  /// **'{kiloHertz} kHz'**
  String numberAsKiloHertz(double kiloHertz);

  /// Value for the bit depth of a track, as amount of bit used
  ///
  /// In en, this message translates to:
  /// **'{bit} bit'**
  String numberAsBit(int bit);

  /// Displays duration of unplayed tracks. {duration} is a pre-formatted string.
  ///
  /// In en, this message translates to:
  /// **'{duration} remaining'**
  String remainingDuration(String duration);

  /// No description provided for @removeFromPlaylistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeFromPlaylistConfirm;

  /// Prompt on dialog to confirm a removal from playlist
  ///
  /// In en, this message translates to:
  /// **'Remove \'{itemName}\' from playlist \'{playlistName}\'?'**
  String removeFromPlaylistPrompt(String itemName, String playlistName);

  /// Tooltip for the button that opens the track menu
  ///
  /// In en, this message translates to:
  /// **'Track Menu'**
  String get trackMenuButtonTooltip;

  /// Title for the short menu that can be shown when long-pressing on the menu button on the player screen. Currently only used for adding to and removing from playlists.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Header for add to/remove from playlist popup menu
  ///
  /// In en, this message translates to:
  /// **'Add To / Remove From Playlists'**
  String get addRemoveFromPlaylist;

  /// Subheader for adding to a playlist in the add to/remove from playlist popup menu
  ///
  /// In en, this message translates to:
  /// **'Add track to a playlist'**
  String get addPlaylistSubheader;

  /// No description provided for @trackOfflineFavorites.
  ///
  /// In en, this message translates to:
  /// **'Sync all favorite statuses'**
  String get trackOfflineFavorites;

  /// No description provided for @trackOfflineFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This allows showing more up-to-date favorite statuses while offline.  Does not download any additional files.'**
  String get trackOfflineFavoritesSubtitle;

  /// No description provided for @allPlaylistsInfoSetting.
  ///
  /// In en, this message translates to:
  /// **'Download Playlist Metadata'**
  String get allPlaylistsInfoSetting;

  /// No description provided for @allPlaylistsInfoSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync metadata for all playlists to improve your playlist experience'**
  String get allPlaylistsInfoSettingSubtitle;

  /// No description provided for @downloadFavoritesSetting.
  ///
  /// In en, this message translates to:
  /// **'Download all favorites'**
  String get downloadFavoritesSetting;

  /// No description provided for @downloadAllPlaylistsSetting.
  ///
  /// In en, this message translates to:
  /// **'Download all playlists'**
  String get downloadAllPlaylistsSetting;

  /// No description provided for @fiveLatestAlbumsSetting.
  ///
  /// In en, this message translates to:
  /// **'Download 5 latest albums'**
  String get fiveLatestAlbumsSetting;

  /// No description provided for @fiveLatestAlbumsSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads will be removed as they age out.  Lock the download to prevent an album from being removed.'**
  String get fiveLatestAlbumsSettingSubtitle;

  /// No description provided for @cacheLibraryImagesSettings.
  ///
  /// In en, this message translates to:
  /// **'Cache current library images'**
  String get cacheLibraryImagesSettings;

  /// No description provided for @cacheLibraryImagesSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All album, artist, genre, and playlist covers in the currently active library will be downloaded.'**
  String get cacheLibraryImagesSettingsSubtitle;

  /// Title for the setting that controls if the in-app miniplayer / now playing bar at the bottom of the music screen functions as a progress bar
  ///
  /// In en, this message translates to:
  /// **'Show track progress on in-app miniplayer'**
  String get showProgressOnNowPlayingBarTitle;

  /// Subtitle for the setting that controls if the now playing bar / miniplayer at the bottom of the music screen functions as a progress bar
  ///
  /// In en, this message translates to:
  /// **'Controls if the in-app miniplayer / now playing bar at the bottom of the music screen functions as a progress bar.'**
  String get showProgressOnNowPlayingBarSubtitle;

  /// Name for the view/screen that shows lyrics for the currently playing track
  ///
  /// In en, this message translates to:
  /// **'Lyrics View'**
  String get lyricsScreen;

  /// Title for the setting that controls if timestamps are shown for lyrics
  ///
  /// In en, this message translates to:
  /// **'Show timestamps for synchronized lyrics'**
  String get showLyricsTimestampsTitle;

  /// Subtitle for the setting that controls if timestamps are shown for lyrics
  ///
  /// In en, this message translates to:
  /// **'Controls if the timestamp of each lyric line is shown in the lyrics view, if available.'**
  String get showLyricsTimestampsSubtitle;

  /// Title for the setting that controls if the media notification has a stop button in addition to the pause button.
  ///
  /// In en, this message translates to:
  /// **'Show stop button on media notification'**
  String get showStopButtonOnMediaNotificationTitle;

  /// Subtitle for the setting that controls if the media notification has a stop button in addition to the pause button.
  ///
  /// In en, this message translates to:
  /// **'Controls if the media notification has a stop button in addition to the pause button. This lets you stop playback without opening the app.'**
  String get showStopButtonOnMediaNotificationSubtitle;

  /// Title for the setting that controls if the media notification has a seekable progress bar.
  ///
  /// In en, this message translates to:
  /// **'Show seek controls on media notification'**
  String get showSeekControlsOnMediaNotificationTitle;

  /// Subtitle for the setting that controls if the media notification has a seekable progress bar.
  ///
  /// In en, this message translates to:
  /// **'Controls if the media notification has a seekable progress bar. This lets you change the playback position without opening the app.'**
  String get showSeekControlsOnMediaNotificationSubtitle;

  /// Alignment option for things like the lyrics view. Start means left-aligned in LTR languages and right-aligned in RTL languages.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get alignmentOptionStart;

  /// Alignment option for things like the lyrics view. Center means centered.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get alignmentOptionCenter;

  /// Alignment option for things like the lyrics view. End means right-aligned in LTR languages and left-aligned in RTL languages.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get alignmentOptionEnd;

  /// Font size option for things like the lyrics view. Small means a smaller font size.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeOptionSmall;

  /// Font size option for things like the lyrics view. Medium means a medium font size.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontSizeOptionMedium;

  /// Font size option for things like the lyrics view. Large means a larger font size.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeOptionLarge;

  /// Title for the setting that controls the alignment of lyrics in the lyrics view
  ///
  /// In en, this message translates to:
  /// **'Lyrics alignment'**
  String get lyricsAlignmentTitle;

  /// Subtitle for the setting that controls the alignment of lyrics in the lyrics view
  ///
  /// In en, this message translates to:
  /// **'Controls the alignment of lyrics in the lyrics view.'**
  String get lyricsAlignmentSubtitle;

  /// Title for the setting that controls the font size of lyrics in the lyrics view
  ///
  /// In en, this message translates to:
  /// **'Lyrics font size'**
  String get lyricsFontSizeTitle;

  /// Subtitle for the setting that controls the font size of lyrics in the lyrics view
  ///
  /// In en, this message translates to:
  /// **'Controls the font size of lyrics in the lyrics view.'**
  String get lyricsFontSizeSubtitle;

  /// Title for the setting that controls if the album cover is shown before the lyrics in the lyrics view
  ///
  /// In en, this message translates to:
  /// **'Show album before lyrics'**
  String get showLyricsScreenAlbumPreludeTitle;

  /// Subtitle for the setting that controls if the album cover is shown before the lyrics in the lyrics view
  ///
  /// In en, this message translates to:
  /// **'Controls if the album cover is shown above the lyrics before being scrolled away.'**
  String get showLyricsScreenAlbumPreludeSubtitle;

  /// Option to keep the screen on while using the app
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get keepScreenOn;

  /// No description provided for @keepScreenOnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When to keep the screen on'**
  String get keepScreenOnSubtitle;

  /// No description provided for @keepScreenOnDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get keepScreenOnDisabled;

  /// No description provided for @keepScreenOnAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Always On'**
  String get keepScreenOnAlwaysOn;

  /// No description provided for @keepScreenOnWhilePlaying.
  ///
  /// In en, this message translates to:
  /// **'While Playing Music'**
  String get keepScreenOnWhilePlaying;

  /// No description provided for @keepScreenOnWhileLyrics.
  ///
  /// In en, this message translates to:
  /// **'While Showing Lyrics'**
  String get keepScreenOnWhileLyrics;

  /// No description provided for @keepScreenOnWhilePluggedIn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On only while plugged in'**
  String get keepScreenOnWhilePluggedIn;

  /// No description provided for @keepScreenOnWhilePluggedInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ignore the Keep Screen On setting if device is unplugged'**
  String get keepScreenOnWhilePluggedInSubtitle;

  /// Tooltip for toggle buttons that can be tapped to toggle their state
  ///
  /// In en, this message translates to:
  /// **'Tap to toggle.'**
  String get genericToggleButtonTooltip;

  /// No description provided for @artwork.
  ///
  /// In en, this message translates to:
  /// **'Artwork'**
  String get artwork;

  /// Tooltip for album artwork on track and album tiles as well as the album screen
  ///
  /// In en, this message translates to:
  /// **'Artwork for {title}'**
  String artworkTooltip(String title);

  /// Tooltip for the album artwork on the player screen
  ///
  /// In en, this message translates to:
  /// **'Artwork for {title}. Tap to toggle playback. Swipe left or right to switch tracks.'**
  String playerAlbumArtworkTooltip(String title);

  /// Tooltip for the now playing bar at the bottom of the screen
  ///
  /// In en, this message translates to:
  /// **'Open Player Screen'**
  String get nowPlayingBarTooltip;

  /// Label for the feature chips showing additional people in the credits of a track or album
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get additionalPeople;

  /// Label for the feature chips showing the playback mode of a track. See [playbackModeLocal], [playbackModeDirectPlaying], and [playbackModeTranscoding]
  ///
  /// In en, this message translates to:
  /// **'Playback Mode'**
  String get playbackMode;

  /// Label for the feature chips showing the codec of a track
  ///
  /// In en, this message translates to:
  /// **'Codec'**
  String get codec;

  /// Label for the feature chips showing the bit rate of a track
  ///
  /// In en, this message translates to:
  /// **'Bit Rate'**
  String get bitRate;

  /// Label for the feature chips showing the bit depth of a track
  ///
  /// In en, this message translates to:
  /// **'Bit Depth'**
  String get bitDepth;

  /// Label for the feature chips showing the size (original file size or transcoded size, if available) of a track
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Label for the feature chips showing the normalization gain / LUFS offset of a track
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get normalizationGain;

  /// Label for the feature chips showing the sample rate of a track
  ///
  /// In en, this message translates to:
  /// **'Sample Rate'**
  String get sampleRate;

  /// Title for the setting that controls if the feature chips showing advanced track info are shown on the player screen
  ///
  /// In en, this message translates to:
  /// **'Show Advanced Track Info'**
  String get showFeatureChipsToggleTitle;

  /// Subtitle for the setting that controls if the feature chips showing advanced track info are shown on the player screen
  ///
  /// In en, this message translates to:
  /// **'Show advanced track info like codec, bitrate, and more on the player screen.'**
  String get showFeatureChipsToggleSubtitle;

  /// Name for the view/screen that shows albums
  ///
  /// In en, this message translates to:
  /// **'Album Screen'**
  String get albumScreen;

  /// Title for the setting that controls if album covers are shown for each track separately on the album screen
  ///
  /// In en, this message translates to:
  /// **'Show Album Covers For Tracks'**
  String get showCoversOnAlbumScreenTitle;

  /// Subtitle for the setting that controls if album covers are shown for each track separately on the album screen
  ///
  /// In en, this message translates to:
  /// **'Show album covers for each track separately on the album screen.'**
  String get showCoversOnAlbumScreenSubtitle;

  /// Message shown as a placeholder when the top tracks list for an artist is empty
  ///
  /// In en, this message translates to:
  /// **'You haven\'t listened to any track by this artist yet.'**
  String get emptyTopTracksList;

  /// Message shown when a list of items is filtered and no items match the filter
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get emptyFilteredListTitle;

  /// Message shown when a list of items is filtered and no items match the filter
  ///
  /// In en, this message translates to:
  /// **'No items match the filter. Try turning off the filter or changing the search term.'**
  String get emptyFilteredListSubtitle;

  /// Button to reset filters on a list of items
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get resetFiltersButton;

  /// Prompt which gets shown when the user is about to reset all settings to their default values
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset ALL settings to their defaults?'**
  String get resetSettingsPromptGlobal;

  /// A differently worded Confirm button to prevent the user from instandly clicking confirm because they are about to reset all settings to their default value
  ///
  /// In en, this message translates to:
  /// **'Reset ALL settings'**
  String get resetSettingsPromptGlobalConfirm;

  /// Prompt which gets shown when the user is about to reset all settings in the current settings window to their default values
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset these settings back to their defaults?'**
  String get resetSettingsPromptLocal;

  /// Used when the user stops an action from taking place inside a popup dialog window
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get genericCancel;

  /// Used whenever item gets deleted from the device or server, message in snackbar
  ///
  /// In en, this message translates to:
  /// **'{itemType, select, album{Album} playlist{Playlist} artist{Artist} genre{Genre} track{Track} library{Library} other{Item}} got deleted from {deviceType, select, device{Device} server{Server} other{unknown}}'**
  String itemDeletedSnackbar(String deviceType, String itemType);

  /// Title for the setting that controls if items can be deleted from the server
  ///
  /// In en, this message translates to:
  /// **'Allow deletion from server'**
  String get allowDeleteFromServerTitle;

  /// Subtitle for the setting that controls if items can be deleted from the server
  ///
  /// In en, this message translates to:
  /// **'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.'**
  String get allowDeleteFromServerSubtitle;

  /// (Important: Note the space in front of some cases) A Confirm Prompt used whenever an item is about to be deleted from the device or server. The Server case should explain that this cannot be reverted, this information is not needed for the device since the user can just download the track again. The delete Type adapts the server text even more in can the user can or cant delete the item.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete this {itemType, select, album{album} playlist{playlist} artist{artist} genre{genre} track{track} library{library} other{item}} from {device, select, device{this device} server{the servers file system and library.{deleteType, select, canDelete{ This will also Delete this item from this Device.} cantDelete{ This item will stay on this device until the next sync.} notDownloaded{} other{}}\nThis action cannot be reverted} other{}}.'**
  String deleteFromTargetDialogText(String deleteType, String device, String itemType);

  /// (Important: Note the space in front of some cases) The button the user needs to press to execute the delete action. If no target is set, the text should just be a generic 'delete' text. This button is both visible before and after the delete confirm prompt.
  ///
  /// In en, this message translates to:
  /// **'Delete{target, select, device{ from Device} server{ from Server} other{}}'**
  String deleteFromTargetConfirmButton(String target);

  /// A line of warning text on the download dialog when large numbers of tracks are downloaded at once.
  ///
  /// In en, this message translates to:
  /// **'Warning: You are about to download {count} tracks.'**
  String largeDownloadWarning(int count);

  /// Title for the setting controlling when to warn about a large download
  ///
  /// In en, this message translates to:
  /// **'Download Size Warning Cutoff'**
  String get downloadSizeWarningCutoff;

  /// Subtitle for the setting controlling when to warn about a large download
  ///
  /// In en, this message translates to:
  /// **'A warning message will be displayed when downloading more than this many tracks at once.'**
  String get downloadSizeWarningCutoffSubtitle;

  /// Warning dialog for adding an album, artist, or similar to a playlist, clarifying that this cannot be undone without removing all tracks individually.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want add all tracks from {itemType, select, album{album} playlist{playlist} artist{artist} genre{genre} other{item}} \'{itemName}\' to this playlist?  They can only be removed individually.'**
  String confirmAddAlbumToPlaylist(String itemType, String itemName);

  /// Toggle for playlist creation where true means the playlist is publicly visible, false means only the creator can see it.
  ///
  /// In en, this message translates to:
  /// **'Publicly Visible:'**
  String get publiclyVisiblePlaylist;

  /// Date format option for the release date of an album, showing only the year
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get releaseDateFormatYear;

  /// Date format option for the release date of an album, showing the full ISO 8601 date
  ///
  /// In en, this message translates to:
  /// **'ISO 8601'**
  String get releaseDateFormatISO;

  /// Date format option for the release date of an album, showing the year and month. Example: March 2022
  ///
  /// In en, this message translates to:
  /// **'Month & Year'**
  String get releaseDateFormatMonthYear;

  /// Date format option for the release date of an album, showing the year and month and day/date. Example: March 2, 2022
  ///
  /// In en, this message translates to:
  /// **'Month, Day & Year'**
  String get releaseDateFormatMonthDayYear;

  /// Title for the setting that controls if the release date of an album is shown on the player screen
  ///
  /// In en, this message translates to:
  /// **'Show Album Release Date on Player Screen'**
  String get showAlbumReleaseDateOnPlayerScreenTitle;

  /// Subtitle for the setting that controls if the release date of an album is shown on the player screen
  ///
  /// In en, this message translates to:
  /// **'Show the release date of the album on the player screen, behind the album name.'**
  String get showAlbumReleaseDateOnPlayerScreenSubtitle;

  /// Title for the setting that controls the format release dates throughout the app.
  ///
  /// In en, this message translates to:
  /// **'Release Date Format'**
  String get releaseDateFormatTitle;

  /// Title for the setting that controls the format release dates throughout the app.
  ///
  /// In en, this message translates to:
  /// **'Controls the format of all release dates shown in the app.'**
  String get releaseDateFormatSubtitle;

  /// Error shown when the library select screen fails to load.
  ///
  /// In en, this message translates to:
  /// **'Error loading available libraries for user'**
  String get librarySelectError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'bg', 'ca', 'cs', 'da', 'de', 'el', 'en', 'es', 'et', 'fa', 'fi', 'fr', 'hi', 'hr', 'hu', 'it', 'ja', 'ko', 'nb', 'nl', 'pl', 'pt', 'ru', 'sl', 'sr', 'sv', 'sw', 'szl', 'ta', 'th', 'tr', 'uk', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
    // Lookup logic when language+script+country codes are specified.
  switch (locale.toString()) {
    case 'zh_Hant_HK': return AppLocalizationsZhHantHk();
  }

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return AppLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'bg': return AppLocalizationsBg();
    case 'ca': return AppLocalizationsCa();
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'fa': return AppLocalizationsFa();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'hr': return AppLocalizationsHr();
    case 'hu': return AppLocalizationsHu();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'nb': return AppLocalizationsNb();
    case 'nl': return AppLocalizationsNl();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'sl': return AppLocalizationsSl();
    case 'sr': return AppLocalizationsSr();
    case 'sv': return AppLocalizationsSv();
    case 'sw': return AppLocalizationsSw();
    case 'szl': return AppLocalizationsSzl();
    case 'ta': return AppLocalizationsTa();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
