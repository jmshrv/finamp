// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Açık kaynaklı Jellyfin ses oynatıcı';

  @override
  String startupError(String error) {
    return 'Uygulama başlarken bir hata meydana geldi. Hata: $error\n\nLütfen bu sayfanın ekran görüntüsüyle github.com/UnicornsOnLSD/finamp adresinde bir issue oluşturun. Eğer bu sorun devam ederse uygulamayı sıfırlamak için uygulama verisini sıfırlayabilirsiniz.';
  }

  @override
  String get about => 'Finamp Hakkında';

  @override
  String get aboutContributionPrompt => 'Harika insanlar tarafından boş zamanlarında yapıldı.\nSen de onlardan biri olabilirsin!';

  @override
  String get aboutContributionLink => 'GitHub\'da Finamp\'a katkıda bulunun:';

  @override
  String get aboutReleaseNotes => 'En son sürüm notlarını okuyun:';

  @override
  String get aboutTranslations => 'Finamp\'ın dilinize çevrilmesine yardımcı olun:';

  @override
  String get aboutThanks => 'Finamp\'ı kullandığınız için teşekkürler!';

  @override
  String get loginFlowWelcomeHeading => 'Hoş geldiniz,';

  @override
  String get loginFlowSlogan => 'Senin müziğin, senin istediğin şekilde.';

  @override
  String get loginFlowGetStarted => 'Başlayın!';

  @override
  String get viewLogs => 'Günlükleri göster';

  @override
  String get changeLanguage => 'Dili değiştir';

  @override
  String get loginFlowServerSelectionHeading => 'Jellyfin\'e Bağlan';

  @override
  String get back => 'Geri';

  @override
  String get serverUrl => 'Sunucu URL\'si';

  @override
  String get internalExternalIpExplanation => 'Jellyfin sunucunuza uzaktan erişmek istiyorsanız dış IP adresinizi kullanmalısınız.\n\nSunucunuz bir HTTP varsayılan bağlantı noktasında (80 veya 443) veya Jellyfin\'in varsayılan bağlantı noktasında (8096) bulunuyorsa, bağlantı noktasını belirtmeniz gerekmez.\n\nURL doğruysa, giriş alanının altında sunucunuzla ilgili bazı bilgilerin açıldığını görmelisiniz.';

  @override
  String get serverUrlHint => 'örneğin demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Sunucu URL\'si yardımı';

  @override
  String get emptyServerUrl => 'Sunucu URL\'si boş bırakılamaz';

  @override
  String get connectingToServer => 'Sunucuya bağlanılıyor...';

  @override
  String get loginFlowLocalNetworkServers => 'Yerel ağınızdaki sunucular:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Sunucular taranıyor...';

  @override
  String get loginFlowAccountSelectionHeading => 'Hesabınızı seçin';

  @override
  String get backToServerSelection => 'Sunucu seçimine geri dön';

  @override
  String get loginFlowNamelessUser => 'Adsız kullanıcı';

  @override
  String get loginFlowCustomUser => 'Özel kullanıcı';

  @override
  String get loginFlowAuthenticationHeading => 'Hesabınıza giriş yapın';

  @override
  String get backToAccountSelection => 'Hesap seçimine geri dön';

  @override
  String get loginFlowQuickConnectPrompt => 'Hızlı bağlantı kodunu kullan';

  @override
  String get loginFlowQuickConnectInstructions => 'Jellyfin uygulamasını veya internet sitesini açın, kullanıcı simgenize tıklayın ve \"Hızlı Bağlan\"ı seçin.';

  @override
  String get loginFlowQuickConnectDisabled => '\"Hızlı Bağlan\" bu sunucuda devre dışı bırakıldı.';

  @override
  String get orDivider => 'veya';

  @override
  String get loginFlowSelectAUser => 'Kullanıcı seçin';

  @override
  String get username => 'Kullanıcı adı';

  @override
  String get usernameHint => 'Kullanıcı adınızı girin';

  @override
  String get usernameValidationMissingUsername => 'Lütfen bir kullanıcı adı girin';

  @override
  String get password => 'Şifre';

  @override
  String get passwordHint => 'Şifrenizi girin';

  @override
  String get login => 'Giriş';

  @override
  String get logs => 'Günlükler';

  @override
  String get next => 'Sıradaki';

  @override
  String get selectMusicLibraries => 'Müzik Kütüphanelerini Seç';

  @override
  String get couldNotFindLibraries => 'Hiçbir kütüphane bulunamadı.';

  @override
  String get unknownName => 'Bilinmeyen ad';

  @override
  String get tracks => 'Parçalar';

  @override
  String get albums => 'Albümler';

  @override
  String get artists => 'Sanatçılar';

  @override
  String get genres => 'Tarzlar';

  @override
  String get playlists => 'Oynatma listeleri';

  @override
  String get startMix => 'Mix\'i başlat';

  @override
  String get startMixNoTracksArtist => 'Karışımı başlatmadan önce karışım oluşturucuya eklemek veya kaldırmak için bir sanatçıya uzun basın';

  @override
  String get startMixNoTracksAlbum => 'Karışımı başlatmadan önce karışım oluşturucuya eklemek veya kaldırmak için bir albüme uzun basın';

  @override
  String get startMixNoTracksGenre => 'Karışımı başlatmadan önce karışım oluşturucuya eklemek veya kaldırmak için bir türe uzun basın';

  @override
  String get music => 'Müzik';

  @override
  String get clear => 'Temizle';

  @override
  String get favourites => 'Favoriler';

  @override
  String get shuffleAll => 'Tümünü karıştır';

  @override
  String get downloads => 'İndirilenler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get offlineMode => 'Çevrim dışı Mod';

  @override
  String get sortOrder => 'Sıralama düzeni';

  @override
  String get sortBy => 'Sıralama ölçütü';

  @override
  String get title => 'Başlık';

  @override
  String get album => 'Albüm';

  @override
  String get albumArtist => 'Albüm Sanatçısı';

  @override
  String get artist => 'Sanatçı';

  @override
  String get budget => 'Bütçe';

  @override
  String get communityRating => 'Topluluk Puanı';

  @override
  String get criticRating => 'Eleştirmen Puanı';

  @override
  String get dateAdded => 'Eklenme Tarihi';

  @override
  String get datePlayed => 'Oynatma Tarihi';

  @override
  String get playCount => 'Oynatma Sayısı';

  @override
  String get premiereDate => 'Gösterim Tarihi';

  @override
  String get productionYear => 'Prodüksiyon Yılı';

  @override
  String get name => 'Ad';

  @override
  String get random => 'Rastgele';

  @override
  String get revenue => 'Gelir';

  @override
  String get runtime => 'Oynatma süresi';

  @override
  String get syncDownloadedPlaylists => 'İndirilen oynatma listelerini eş zamanla';

  @override
  String get downloadMissingImages => 'Eksik görselleri indir';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane eksik görsel indirildi',
      one: '$count tane eksik görsel indirildi',
      zero: 'Eksik görsel yok',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Etkin İndirmeler';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane indirme$count',
      one: '$count tane indirme',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount parça',
      one: '$trackCount parça',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount görsel',
      one: '$imageCount görsel',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount düğüm eşitleniyor',
      one: '$syncCount düğüm eşitleniyor',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nŞu anda onarılıyor',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count tane tamamlandı';
  }

  @override
  String dlFailed(int count) {
    return '$count tane başarısız';
  }

  @override
  String dlEnqueued(int count) {
    return '$count tane kuyruğa alındı';
  }

  @override
  String dlRunning(int count) {
    return '$count tane devam ediyor';
  }

  @override
  String get activeDownloadsTitle => 'Etkin İndirmeler';

  @override
  String get noActiveDownloads => 'Etkin indirme yok.';

  @override
  String get errorScreenError => 'Hata listesi oluşturulurken hata meydana geldi. Bu noktada, GitHub\'da bir sorun oluşturmalı ve uygulama verilerini silmelisiniz';

  @override
  String get failedToGetTrackFromDownloadId => 'İndirme kimliğinden parça alınamadı';

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
  String get error => 'Hata';

  @override
  String discNumber(int number) {
    return 'Disk $number';
  }

  @override
  String get playButtonLabel => 'Oynat';

  @override
  String get shuffleButtonLabel => 'Karıştır';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Parça',
      one: '$count Parça',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Parça',
      one: '$count Parça',
    );
    return '$_temp0, $downloads İndirildi';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Parça',
      one: '$count Parça',
    );
    return '$_temp0 İndirildi';
  }

  @override
  String get editPlaylistNameTooltip => 'Oynatma listesi adını düzenle';

  @override
  String get editPlaylistNameTitle => 'Oynatma Listesi Adını Düzenle';

  @override
  String get required => 'Gerekli';

  @override
  String get updateButtonLabel => 'Güncelle';

  @override
  String get playlistNameUpdated => 'Oynatma listesinin adı güncellendi.';

  @override
  String get favourite => 'Favori';

  @override
  String get downloadsDeleted => 'İndirmeler silindi.';

  @override
  String get addDownloads => 'İndirme Ekle';

  @override
  String get location => 'Konum';

  @override
  String get confirmDownloadStarted => 'İndirme başladı';

  @override
  String get downloadsQueued => 'Hazırlananları indirin, dosyalar indiriliyor';

  @override
  String get addButtonLabel => 'Ekle';

  @override
  String get shareLogs => 'Uygulama dökümlerini paylaş';

  @override
  String get logsCopied => 'Uygulama dökümleri kopyalandı.';

  @override
  String get message => 'Mesaj';

  @override
  String get stackTrace => 'Fonksiyon Çağrı Yığını';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Mozilla Kamu Lisansı 2.0 ile lisanslanmıştır.\nKaynak kodu $sourceCodeLink adresinde mevcuttur.';
  }

  @override
  String get transcoding => 'Kod dönüştürme';

  @override
  String get downloadLocations => 'İndirilenler Konumları';

  @override
  String get audioService => 'Ses Servisi';

  @override
  String get interactions => 'Etkileşimler';

  @override
  String get layoutAndTheme => 'Düzen & Tema';

  @override
  String get notAvailableInOfflineMode => 'Çevrim dışı modda mevcut değil';

  @override
  String get logOut => 'Çıkış Yap';

  @override
  String get downloadedTracksWillNotBeDeleted => 'İndirilen parçalar silinmeyecek';

  @override
  String get areYouSure => 'Emin misiniz?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin kod dönüştürme için AAC kullanıyor';

  @override
  String get enableTranscoding => 'Kod dönüştürmeyi etkinleştir';

  @override
  String get enableTranscodingSubtitle => 'Sunucu tarafındaki ses akışlarının kodunu dönüştürür.';

  @override
  String get bitrate => 'Bit oranı';

  @override
  String get bitrateSubtitle => 'Daha yüksek bir bit oranı, daha fazla bant genişliği kullanır ancak daha kaliteli ses verir.';

  @override
  String get customLocation => 'Özel Konum';

  @override
  String get appDirectory => 'Uygulama Klasörü';

  @override
  String get addDownloadLocation => 'İndirme Konumu Ekle';

  @override
  String get selectDirectory => 'Klasör Seç';

  @override
  String get unknownError => 'Bilinmeyen Hata';

  @override
  String get pathReturnSlashErrorMessage => '\"/\" döndüren yollar kullanılamaz';

  @override
  String get directoryMustBeEmpty => 'Klasör boş olmalı';

  @override
  String get customLocationsBuggy => 'İzinlerden kaynaklanan sorunlar dolayısıyla özel konum seçmek fazlasıyla bug\'a yol açmakta. Şimdilik kullanmanızı önermiyorum, çözmenin bir yolunu düşünüyorum.';

  @override
  String get enterLowPriorityStateOnPause => 'Bekletmede Düşük Öncelik Durumuna Geç';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Şarkı duraklatıldığında bildirimin temizlenebilmesini sağlar. Ayrıca Android\'in hizmeti kapatmasına izin verir.';

  @override
  String get shuffleAllTrackCount => 'Karıştırılacak Tüm Parçaların Sayısı';

  @override
  String get shuffleAllTrackCountSubtitle => 'Tüm parçaları karıştır düğmesini kullanırken karıştırılacak parça sayısı.';

  @override
  String get viewType => 'Görüntüleme Tipi';

  @override
  String get viewTypeSubtitle => 'Müzik ekranı için görüntüleme tipi';

  @override
  String get list => 'Liste';

  @override
  String get grid => 'Izgara';

  @override
  String get customizationSettingsTitle => 'Özelleştirme';

  @override
  String get playbackSpeedControlSetting => 'Oynatma Hızı Görünürlüğü';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Oynatıcı ekranı menüsünde oynatma hızı kontrollerinin gösterilip gösterilmeyeceği';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Otomatik:\nFinamp, oynattığınız parçanın bir podcast mi yoksa sesli kitabın (bir parçası) mı olduğunu belirlemeye çalışır. Parçanın $trackDuration dakikadan uzun olması, parçanın albümünün $albumDuration saatten uzun olması veya parçaya şu türlerden en az birinin atanmış olması durumunda bu durum geçerli kabul edilir: $genreList\nOynatma hızı kontrolleri oynatıcı ekranı menüsünde gösterilecektir.\n\nGöster:\nOynatma hızı kontrolleri her zaman oynatıcı ekranı menüsünde gösterilecektir.\n\nGizle:\nOynatıcı ekranı menüsündeki oynatma hızı kontrolleri her zaman gizlidir.';
  }

  @override
  String get automatic => 'Otomatik';

  @override
  String get shown => 'Göster';

  @override
  String get hidden => 'Gizle';

  @override
  String get speed => 'Hız';

  @override
  String get reset => 'Sıfırla';

  @override
  String get apply => 'Uygula';

  @override
  String get portrait => 'Dikey mod';

  @override
  String get landscape => 'Yatay mod';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Izgara Çapraz Eksen Sayısı';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Değer $value olduğunda satır başına kullanılacak ızgara karosu.';
  }

  @override
  String get showTextOnGridView => 'Izgara görünümünde metin göster';

  @override
  String get showTextOnGridViewSubtitle => 'Izgara müzik ekranında metin (başlık, sanatçı, vs.) gösterilip gösterilmeyeceğini belirler.';

  @override
  String get useCoverAsBackground => 'Oynatıcı arkaplanı olarak bulanık kapak fotoğrafını göster';

  @override
  String get useCoverAsBackgroundSubtitle => 'Oynatıcı arkaplanı olarak bulanık kapak fotoğrafını gösterilip gösterilmeyeceğini belirler.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'En az albüm kapağı dolgusu';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Oynatıcı ekranında albüm kapağı çevresinde, ekran genişliğinin %\'si cinsinden en az dolgu.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Albüm sanatçılarıyla aynıysa parça sanatçılarını gizle';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Albüm sanatçılarından farklı değilse parça sanatçılarının albüm ekranında gösterilip gösterilmeyeceği.';

  @override
  String get showArtistsTopTracks => 'En iyi parçaları sanatçı görünümünde göster';

  @override
  String get showArtistsTopTracksSubtitle => 'Bir sanatçının en çok dinlenen ilk 5 parçasının gösterilip gösterilmeyeceği.';

  @override
  String get disableGesture => 'Jestleri devre dışı bırak';

  @override
  String get disableGestureSubtitle => 'Jestleri devre dışı bırakır veya aktifleştirir.';

  @override
  String get showFastScroller => 'Hızlı kaydırıcıyı göster';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistem';

  @override
  String get light => 'Aydınlık';

  @override
  String get dark => 'Karanlık';

  @override
  String get tabs => 'Sekmeler';

  @override
  String get playerScreen => 'Oynatıcı Ekranı';

  @override
  String get cancelSleepTimer => 'Uyuma Zamanlayıcısını İptal Et?';

  @override
  String get yesButtonLabel => 'Evet';

  @override
  String get noButtonLabel => 'Hayır';

  @override
  String get setSleepTimer => 'Uyuma Zamanlayıcısını Ayarla';

  @override
  String get hours => 'Saat';

  @override
  String get seconds => 'Saniye';

  @override
  String get minutes => 'Dakika';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime / $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return '$currentTrackIndex\'den $totalTrackCount tane parça';
  }

  @override
  String get invalidNumber => 'Geçersiz Sayı';

  @override
  String get sleepTimerTooltip => 'Uyku zamanlayıcısı';

  @override
  String sleepTimerRemainingTime(int time) {
    return '$time dakika içinde uyuyor';
  }

  @override
  String get addToPlaylistTooltip => 'Oynatma listesine ekle';

  @override
  String get addToPlaylistTitle => 'Listeye Ekle';

  @override
  String get addToMorePlaylistsTooltip => 'Daha fazla oynatma listesine ekle';

  @override
  String get addToMorePlaylistsTitle => 'Daha Fazla Oynatma Listesine Ekle';

  @override
  String get removeFromPlaylistTooltip => 'Bu oynatma listesinden çıkart';

  @override
  String get removeFromPlaylistTitle => 'Bu Oynatma Listesinden Çıkart';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return '\'$playlistName\' oynatma listesinden kaldır';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return '\'$playlistName\' Oynatma Listesinden kaldır';
  }

  @override
  String get newPlaylist => 'Yeni Oynatma Listesi';

  @override
  String get createButtonLabel => 'Oluştur';

  @override
  String get playlistCreated => 'Oynatma listesi oluşturuldu.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Oynatma listesine eklemek için dokunun. Favoriyi değiştirmek için uzun basın.';

  @override
  String get noAlbum => 'Albüm Yok';

  @override
  String get noItem => 'İçerik Yok';

  @override
  String get noArtist => 'Sanatçı Yok';

  @override
  String get unknownArtist => 'Bilinmeyen Sanatçı';

  @override
  String get unknownAlbum => 'Bilinmeyen Albüm';

  @override
  String get playbackModeDirectPlaying => 'Doğrudan oynatma';

  @override
  String get playbackModeTranscoding => 'Kod dönüştürme';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Yerel oynatma';

  @override
  String get queue => 'Kuyruk';

  @override
  String get addToQueue => 'Kuyruğa Ekle';

  @override
  String get replaceQueue => 'Kuyruğu Değiştir';

  @override
  String get instantMix => 'Anlık Mix';

  @override
  String get goToAlbum => 'Albüme Git';

  @override
  String get goToArtist => 'Sanatçıya git';

  @override
  String get goToGenre => 'Türe git';

  @override
  String get removeFavourite => 'Favoriden çıkart';

  @override
  String get addFavourite => 'Favoriye ekle';

  @override
  String get confirmFavoriteAdded => 'Favoriye eklendi';

  @override
  String get confirmFavoriteRemoved => 'Favoriden kaldırıldı';

  @override
  String get addedToQueue => 'Kuyruğa eklendi.';

  @override
  String get insertedIntoQueue => 'Kuyruğun içine eklendi.';

  @override
  String get queueReplaced => 'Kuyruk değiştirildi.';

  @override
  String get confirmAddedToPlaylist => 'Oynatma listesine eklendi.';

  @override
  String get removedFromPlaylist => 'Oynatma listesinden çıkarıldı.';

  @override
  String get startingInstantMix => 'Hızlı karışım başlatılıyor.';

  @override
  String get anErrorHasOccured => 'Bir hata meydana geldi.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Durum kodu $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Durum kodu $statusCode. Bu muhtemelen yanlış kullanıcı adı/şifre kullandığınız veya istemcinizin oturuma izin vermediği anlamına gelir.';
  }

  @override
  String get removeFromMix => 'Mix\'ten Çıkart';

  @override
  String get addToMix => 'Mix\'e Ekle';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane yeniden indirildi.',
      one: '$count tane yeniden indirildi.',
      zero: 'Yeniden indirmeye gerek yok.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Önden Kaydetme Süresi';

  @override
  String get bufferDurationSubtitle => 'Saniye cinsinden ara belleğe alınması gereken en fazla süre. Yeniden başlatmayı gerektirir.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Arabellek boyutunu sınırlama';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Arabellek boyutu kısıtlamalarını (\'arabellek boyutu\') devre dışı bırakır. Bellek, çok büyük dosyalar için bile her zaman yapılandırılmış süreye (\'arabellek süresi\') yüklenecektir. Kazalara neden olabilir. Yeniden başlatma gerektirir.';

  @override
  String get bufferSizeTitle => 'Arabellek Boyutu';

  @override
  String get bufferSizeSubtitle => 'MB cinsinden arabelleğin maksimum boyutu. Yeniden başlatma gerektirir';

  @override
  String get language => 'Dil';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Başlangıca veya önceki parçaya atla';

  @override
  String get skipToNextTrackButtonTooltip => 'Sonraki parçaya atla';

  @override
  String get togglePlaybackButtonTooltip => 'Toggle playback';

  @override
  String get previousTracks => 'Önceki Parçalar';

  @override
  String get nextUp => 'Sonrakiler';

  @override
  String get clearNextUp => 'Sonrakileri Temizle';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'Playing from';

  @override
  String get playNext => 'Ardından oynat';

  @override
  String get addToNextUp => 'Sonrakilere Ekle';

  @override
  String get shuffleNext => 'Sonrakileri karıştır';

  @override
  String get shuffleToNextUp => 'Shuffle to Next Up';

  @override
  String get shuffleToQueue => 'Shuffle to queue';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Parça',
        'album': 'Albüm',
        'artist': 'Artist',
        'playlist': 'Oynatma listesi',
        'genre': 'Tür',
        'other': 'Öge',
      },
    );
    return '$_temp0 sonraki sırada oynayacak';
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
  String get playbackHistory => 'Oynatma Geçmişi';

  @override
  String get shareOfflineListens => 'Çevrim dışı dinlemeleri paylaş';

  @override
  String get yourLikes => 'Beğendikleriniz';

  @override
  String mix(String mixSource) {
    return '$mixSource - Karışım';
  }

  @override
  String get tracksFormerNextUp => 'Tracks added via Next Up';

  @override
  String get savedQueue => 'Kuyruk Kayıt Edildi';

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
  String get shuffleAllQueueSource => 'Tümünü Karıştır';

  @override
  String get playbackOrderLinearButtonLabel => 'Playing in order';

  @override
  String get playbackOrderLinearButtonTooltip => 'Sırayla oynat. Karıştıra dokun.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Parçaları karıştır';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Parçalar karıştırılıyor. Sırayla oynatmak için dokun.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return '${speed}x hızda oynatılıyor';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return '${speed}x hız';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Oynatma hızını azalt';

  @override
  String get playbackSpeedIncreaseLabel => 'Oynatma hızını artır';

  @override
  String get loopModeNoneButtonLabel => 'Döngüde değil';

  @override
  String get loopModeOneButtonLabel => 'Bu parçayı döngüye al';

  @override
  String get loopModeAllButtonLabel => 'Tümünü döngüye al';

  @override
  String get queuesScreen => 'Şimdi Yürütülüyoru Geri Yükle';

  @override
  String get queueRestoreButtonLabel => 'Geri Yükle';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString kaydedildi';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Oynatılan: $track';
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
  String get queueLoadingMessage => 'Sıra geri yükleniyor...';

  @override
  String get queueRetryMessage => 'Sıra geri yüklenemedi. Yeniden denemek ister misiniz?';

  @override
  String get autoloadLastQueueOnStartup => 'Son Sırayı Otomatik Geri Yükle';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Uygulama başlatıldığında son oynatılan sırayı geri yüklemeyi dene.';

  @override
  String get reportQueueToServer => 'Mevcut sıra sunucuya raporlansın mı?';

  @override
  String get reportQueueToServerSubtitle => 'Etkinleştirildiğinde Finamp mevcut kuyruğu sunucuya gönderecektir. Şu anda bunun pek bir faydası yok gibi görünüyor ve ağ trafiğini artırıyor.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Kayıttan yürütme oturumu güncelleme sıklığı';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Geçerli oynatma durumunun sunucuya saniye cinsinden ne sıklıkta gönderileceği. Oturumun zaman aşımına uğramasını önlemek için bu süre 5 dakikadan (300 saniye) kısa olmalıdır.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Jellyfin sunucusu son 5 dakika içinde istemciden herhangi bir güncelleme almamışsa oynatmanın sona erdiğini varsayar. Bu, 5 dakikadan uzun parçalar için oynatmanın hatalı bir şekilde sona ermiş olarak rapor edilebileceği ve bunun da oynatma raporlama verilerinin kalitesinin düşebileceği anlamına gelir.';

  @override
  String get topTracks => 'En İyi Parçalar';

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
  String get shuffleAlbums => 'Albümleri Karıştır';

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
  String get confirm => 'Onayla';

  @override
  String get close => 'Kapat';

  @override
  String get showUncensoredLogMessage => 'Bu günlük oturum açma bilgilerinizi içerir. Gösterilsin mi?';

  @override
  String get resetTabs => 'Sekmeleri sıfırla';

  @override
  String get resetToDefaults => 'Varsayılanlara sıfırla';

  @override
  String get noMusicLibrariesTitle => 'Müzik Kütüphanesi Bulunamadı';

  @override
  String get noMusicLibrariesBody => 'Finamp herhangi bir müzik kütüphanesi bulamadı. Lütfen Jellyfin sunucunun içerik türü \"Müzik\" olarak ayarlanmış en az bir kütüphaneye sahip olduğundan emin ol.';

  @override
  String get refresh => 'Yenile';

  @override
  String get moreInfo => 'Daha Fazla Bilgi';

  @override
  String get volumeNormalizationSettingsTitle => 'Ses Ölçülü';

  @override
  String get volumeNormalizationSwitchTitle => 'Ses Ölçülü Etkinleştir';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Parçaların ses yüksekliğini normalleştirmek için kazanç bilgilerini kullan (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Ses Ölçülü Kipi';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Ses Ölçülü ne zaman ve nasıl uygulansın';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Hibrit (Parça + Albüm):\nParça kazancı normal çalma için kullanılır, ancak bir albüm çalıyorsa (ana çalma kuyruğu kaynağı olduğu için veya bir noktada kuyruğa eklendiği için), bunun yerine albüm kazancı kullanılır.\n\nParça tabanlı:\nParça kazancı, albümün çalınıp çalınmadığına bakılmaksızın her zaman kullanılır.\n\nYalnızca albümler:\nSes Düzeyi Normalleştirmesi yalnızca albümler oynatılırken uygulanır (albüm kazanımı kullanılarak), ancak tek tek parçalar için uygulanmaz.';

  @override
  String get volumeNormalizationModeHybrid => 'Hibrit (Parça + Albüm)';

  @override
  String get volumeNormalizationModeTrackBased => 'Parça tabanlı';

  @override
  String get volumeNormalizationModeAlbumBased => 'Albüm tabanlı';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Yalnızca albümler';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Temel Kazanç';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Şu anda iOS\'ta Ses Düzeyi Normalleştirmesi, kazanç değişikliğini taklit etmek için oynatma ses düzeyinin değiştirilmesini gerektiriyor. Sesi %100\'ün üzerine çıkaramadığımız için, sessiz parçaların sesini artırabilmek için sesi varsayılan olarak azaltmamız gerekiyor. Değer desibel (dB) cinsindendir; burada -10 dB ~%30 ses, -4,5 dB ~%60 ses ve -2 dB ~%80 ses seviyesidir.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Kaydırılan Parçayı Ardından Oynat';

  @override
  String get swipeInsertQueueNextSubtitle => 'Parça listesinde kaydırılan parçayı sona eklemek yerine sıradaki öge olarak eklemeyi etkinleştirin.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Start Instant Mixes for Individual Tracks';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Etkinleştirildiğinde, parçalar sekmesinde bir parçaya dokunulduğunda, yalnızca tek bir parçayı çalmak yerine o parçadan hızlı karışım başlatılır.';

  @override
  String get downloadItem => 'İndir';

  @override
  String get repairComplete => 'İndirmeler onarımı tamamlandı.';

  @override
  String get syncComplete => 'Tüm indirilenler eş zamanlandı.';

  @override
  String get syncDownloads => 'Eksik ögeleri indirin ve eş zamanlayın.';

  @override
  String get repairDownloads => 'İndirilen dosyalar veya meta verilerle ilgili sorunları onarın.';

  @override
  String get requireWifiForDownloads => 'Sadece kablosuz ağ üzerinden indir.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parça',
      one: '$count parça',
    );
    return 'Uyarı: $_temp0 kuyruğa geri yüklenemedi.';
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
    return '\'\'$libraryName\'\' kütüphanesindeki tüm içeriği indirmek istediğinizden emin misiniz?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Yalnızca tamamen indirilen albümleri göster';

  @override
  String get filesystemFull => 'Kalan indirmeler tamamlanamıyor. Dosya sistemi dolu.';

  @override
  String get connectionInterrupted => 'Bağlantı kesildi, indirmeler duraklatılıyor.';

  @override
  String get connectionInterruptedBackground => 'Arka planda indirirken bağlantı kesildi. Bunun nedeni işletim sistemi ayarlarından kaynaklanabilir.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'Arka planda indirirken bağlantı kesildi. Bunun nedeni \'Duraklatıldığında Düşük Öncelikli Duruma Girin\' seçeneğinin etkinleştirilmesi veya işletim sistemi ayarları olabilir.';

  @override
  String get activeDownloadSize => 'İndiriliyor...';

  @override
  String get missingDownloadSize => 'Siliniyor...';

  @override
  String get syncingDownloadSize => 'Eşitleniyor...';

  @override
  String get runRepairWarning => 'İndirilenlerin geçişini tamamlamak için sunucuyla bağlantı kurulamadı. Lütfen tekrar çevrim içi olduğunuzda indirme ekranından \'İndirilenleri Onar\' seçeneğini çalıştırın.';

  @override
  String get downloadSettings => 'İndirilenler';

  @override
  String get showNullLibraryItemsTitle => 'Bilinmeyen Kitaplığa Sahip Ortamı Göster.';

  @override
  String get showNullLibraryItemsSubtitle => 'Bazı ortamlar bilinmeyen bir kitaplıkla indirilebilir. Bunları orijinal koleksiyonlarının dışında gizlemek için kapatın.';

  @override
  String get maxConcurrentDownloads => 'En Fazla Eş Anlı İndirme Sayısı';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Eş anlı indirmelerin artırılması, arka planda indirme işlemlerinin artmasına izin verebilir ancak bazı indirmelerin çok büyük olması durumunda başarısız olmasına veya bazı durumlarda aşırı gecikmeye neden olabilir.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count eş anlı indirme';
  }

  @override
  String get downloadsWorkersSetting => 'İndirme Çalışanlarının Sayısı';

  @override
  String get downloadsWorkersSettingSubtitle => 'Meta verileri eşleme ve indirilenleri silmek için indirme çalışanı sayısı. İndirme çalışanlarının arttırılması, özellikle sunucu gecikmesi yüksek olduğunda indirme eşlemeyi ve silmeyi hızlandırabilir, ancak gecikmeye neden olabilir.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count indirme çalışanı';
  }

  @override
  String get syncOnStartupSwitch => 'İndirmeleri Başlangıçta Otomatik Olarak Eşitle';

  @override
  String get preferQuickSyncSwitch => 'Hızlı Eşitlemeleri Tercih Edin';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Eşleme gerçekleştirilirken, bazı sabit ögeler (parçalar ve albümler gibi) güncellenmez. İndirme onarımında her zaman tam eşleme gerçekleştirilir.';

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
    return 'Bu ögenin $parentName tarafından indirilmesi gerekiyor.';
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
    return '\'$libraryName\' için ön belleğe alınmış görseller';
  }

  @override
  String get transcodingStreamingContainerTitle => 'Kod dönüştürme kalıbını seçin';

  @override
  String get transcodingStreamingContainerSubtitle => 'Kodu dönüştürülmüş ses akışı sırasında kullanılacak bölüm kapsayıcısını seçin. Zaten sıraya alınmış parçalar etkilenmeyecektir.';

  @override
  String get downloadTranscodeEnableTitle => 'Kodu dönüştürülmüş indirmeleri etkinleştir';

  @override
  String get downloadTranscodeCodecTitle => 'İndirme Kodek\'ini Seçin';

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
  String get downloadBitrate => 'İndirme Bit Hızı';

  @override
  String get downloadBitrateSubtitle => 'Daha yüksek bit hızı, daha fazla depolama gereksinimleri pahasına daha yüksek kalitede ses sağlar.';

  @override
  String get transcodeHint => 'Kod dönüştürme?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return '$codec @ $bitrate$_temp0 olarak indir';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Kod Dönüştürülmüş',
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
    return 'Aslını indir$_temp0';
  }

  @override
  String get redownloadcomplete => 'Kod dönüştürme sonrası yeniden İndirme işlemi sıraya alındı.';

  @override
  String get redownloadTitle => 'Kodu dönüştürülenleri otomatik olarak yeniden indirin';

  @override
  String get redownloadSubtitle => 'Bulunduğu koleksiyondaki değişiklikler nedeniyle farklı kalitede olması beklenen parçaları otomatik olarak yeniden indir.';

  @override
  String get defaultDownloadLocationButton => 'Varsayılan indirme konumu olarak ayarlayın.  İndirme başına seçim yapmayı devre dışı bırak.';

  @override
  String get fixedGridSizeSwitchTitle => 'Sabit boyutta ızgara karoları kullan';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Grid tile sizes will not respond to window/screen size.';

  @override
  String get fixedGridSizeTitle => 'Izgara Karo Boyutu';

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
  String get allowSplitScreenTitle => 'Bölünmüş Ekran Moduna İzin Ver';

  @override
  String get allowSplitScreenSubtitle => 'Oynatıcı daha geniş ekranlarda diğer görünümlerin yanında görüntülenecektir.';

  @override
  String get enableVibration => 'Titreşimi etkinleştir';

  @override
  String get enableVibrationSubtitle => 'Titreşim etkinleştirilsin mi?';

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
  String get hidePlayerBottomActionsSubtitle => 'Oynatıcı ekranında kuyruk ve şarkı sözleri düğmelerini gizleyin. Kuyruğa erişmek için yukarı kaydırın, eğer varsa şarkı sözlerini görüntülemek için sola (albüm kapağının altında) kaydırın.';

  @override
  String get prioritizePlayerCover => 'Albüm kapağı öncelikli';

  @override
  String get prioritizePlayerCoverSubtitle => 'Oynatıcı ekranında daha büyük bir albüm kapağı göstermeye öncelik verin. Kritik olmayan kontroller küçük ekran boyutlarında daha agresif bir şekilde gizlenecektir.';

  @override
  String get suppressPlayerPadding => 'Suppress player controls padding';

  @override
  String get suppressPlayerPaddingSubtitle => 'Albüm kapağı tam boyutta olmadığında oynatıcı ekran kontrolleri arasındaki dolguları en aza indir.';

  @override
  String get lockDownload => 'Daima Cihazda Tutun';

  @override
  String get showArtistChipImage => 'Sanatçı görsellerinde sanatçı adını göster';

  @override
  String get showArtistChipImageSubtitle => 'Bu, oynatıcı ekranı gibi küçük sanatçı görseli ön izlemelerini etkiler.';

  @override
  String get scrollToCurrentTrack => 'Geçerli parçaya kaydır';

  @override
  String get enableAutoScroll => 'Otomatik kaydırmayı etkinleştir';

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
    return '$duration kaldı';
  }

  @override
  String get removeFromPlaylistConfirm => 'Kaldır';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return '\'$itemName\', \'$playlistName\' oynatma listesinden kaldırılsın mı?';
  }

  @override
  String get trackMenuButtonTooltip => 'Parça Menüsü';

  @override
  String get quickActions => 'Hızlı Eylemler';

  @override
  String get addRemoveFromPlaylist => 'Oynatma Listelerine Ekle / Kaldır';

  @override
  String get addPlaylistSubheader => 'Parçayı oynatma listesine ekle';

  @override
  String get trackOfflineFavorites => 'Tüm favori durumları eşle';

  @override
  String get trackOfflineFavoritesSubtitle => 'Bu, çevrim dışıyken sık kullanılanların daha güncel gösterilmesine olanak tanır.  Herhangi bir ek dosya indirmez.';

  @override
  String get allPlaylistsInfoSetting => 'Oynatma Listesi Meta Verilerini İndir';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Oynatma listesi deneyiminizi geliştirmek için tüm oynatma listelerinin meta verilerini eşleyin';

  @override
  String get downloadFavoritesSetting => 'Tüm favorileri indir';

  @override
  String get downloadAllPlaylistsSetting => 'Tüm oynatma listelerini indir';

  @override
  String get fiveLatestAlbumsSetting => 'En yeni 5 albümü indir';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'İndirilenler eskidikçe kaldırılacaktır.  Bir albümün kaldırılmasını önlemek için indirmeyi kilitleyin.';

  @override
  String get cacheLibraryImagesSettings => 'Geçerli kütüphane görsellerini ön belleğe al';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Şu anda etkin olan kütüphanedeki tüm albüm, sanatçı, tür ve oynatma listesi kapakları indirilecektir.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Uygulama içi mini oynatıcıda ilerlemeyi göster';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Oynatma ekranının alt kısmındaki uygulama içi mini oynatıcının / şimdi oynatılıyor çubuğunun bir ilerleme çubuğu olarak çalışıp çalışmadığını kontrol eder.';

  @override
  String get lyricsScreen => 'Şarkı Sözleri Görünümü';

  @override
  String get showLyricsTimestampsTitle => 'Eş zamanlı şarkı sözleri için zaman damgalarını göster';

  @override
  String get showLyricsTimestampsSubtitle => 'Varsa, her şarkı sözü satırının zaman damgasının şarkı sözü görünümünde gösterilip gösterilmeyeceğini kontrol eder.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Ortam bildiriminde durdur düğmesini göster';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Ortam bildiriminde duraklatma düğmesine ek olarak bir durdurma düğmesinin bulunup bulunmadığını kontrol eder. Bu, uygulamayı açmadan oynatmayı durdurmanıza olanak tanır.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Ortam bildiriminde arama kontrollerini göster';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Ortam bildiriminin ayarlanabilir bir ilerleme çubuğuna sahip olup olmadığını kontrol eder. Bu, uygulamayı açmadan oynatma konumunu değiştirmenizi sağlar.';

  @override
  String get alignmentOptionStart => 'Başla';

  @override
  String get alignmentOptionCenter => 'Merkez';

  @override
  String get alignmentOptionEnd => 'Son';

  @override
  String get fontSizeOptionSmall => 'Küçük';

  @override
  String get fontSizeOptionMedium => 'Orta';

  @override
  String get fontSizeOptionLarge => 'Büyük';

  @override
  String get lyricsAlignmentTitle => 'Şarkı sözü hizalaması';

  @override
  String get lyricsAlignmentSubtitle => 'Şarkı sözü görünümünde şarkı sözlerinin hizalamasını kontrol eder.';

  @override
  String get lyricsFontSizeTitle => 'Şarkı sözleri yazı tipi boyutu';

  @override
  String get lyricsFontSizeSubtitle => 'Şarkı sözü görünümünde şarkı sözlerinin yazı tipi boyutunu kontrol eder.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Albümü şarkı sözlerinden önce göster';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Kaydırılmadan önce albüm kapağının şarkı sözlerinin üzerinde gösterilip gösterilmeyeceğini kontrol eder.';

  @override
  String get keepScreenOn => 'Ekranı Açık Tut';

  @override
  String get keepScreenOnSubtitle => 'Ekran ne zaman açık tutulmalı';

  @override
  String get keepScreenOnDisabled => 'Kapalı';

  @override
  String get keepScreenOnAlwaysOn => 'Daima açık';

  @override
  String get keepScreenOnWhilePlaying => 'Müzik çalarken';

  @override
  String get keepScreenOnWhileLyrics => 'Şarkı sözlerini gösterirken';

  @override
  String get keepScreenOnWhilePluggedIn => 'Ekranı yalnızca fişe takılıyken açık tut';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Cihazın fişi çekilirse ekranı açık tut ayarını göz ardı eder';

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
  String get nowPlayingBarTooltip => 'Oynatıcı Ekranını Aç';

  @override
  String get additionalPeople => 'People';

  @override
  String get playbackMode => 'Oynatma Modu';

  @override
  String get codec => 'Kodlayıcı';

  @override
  String get bitRate => 'Bit Hızı';

  @override
  String get bitDepth => 'Bit Derinliği';

  @override
  String get size => 'Boyut';

  @override
  String get normalizationGain => 'Kazanç';

  @override
  String get sampleRate => 'Örnek Hızı';

  @override
  String get showFeatureChipsToggleTitle => 'Gelişmiş Parça Bilgilerini Göster';

  @override
  String get showFeatureChipsToggleSubtitle => 'Oynatıcı ekranında kodlayıcı, bit hızı ve daha fazla gelişmiş parça bilgilerini göster.';

  @override
  String get albumScreen => 'Albüm Ekranı';

  @override
  String get showCoversOnAlbumScreenTitle => 'Parçalar için Albüm Kapaklarını Göster';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Albüm ekranında her parçanın albüm kapaklarını ayrı göster.';

  @override
  String get emptyTopTracksList => 'Bu sanatçının henüz hiçbir parçasını dinlemediniz.';

  @override
  String get emptyFilteredListTitle => 'Hiçbir öge bulunamadı';

  @override
  String get emptyFilteredListSubtitle => 'Süzgeçle eşleşen öge yok. Süzgeci kapatmayı veya arama terimini değiştirmeyi deneyin.';

  @override
  String get resetFiltersButton => 'Süzgeci sıfırla';

  @override
  String get resetSettingsPromptGlobal => 'TÜM ayarları varsayılan değerlerine sıfırlamak istediğinizden emin misiniz?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'TÜM ayarları sıfırla';

  @override
  String get resetSettingsPromptLocal => 'Bu ayarları varsayılan değerlerine sıfırlamak istiyor musunuz?';

  @override
  String get genericCancel => 'İptal';

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
