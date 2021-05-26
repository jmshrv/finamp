# Finamp

Finamp is a Jellyfin music player for Android and iOS. Its main feature is the ability to download songs for offline listening.

## Downloading

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
    alt="Get it on F-Droid"
    height="80">](https://f-droid.org/packages/com.unicornsonlsd.finamp/)
    
Note: The F-Droid release may take a day or two to get updates because since [F-Droid only builds once a day](https://www.f-droid.org/en/docs/FAQ_-_App_Developers/#ive-published-a-new-release-why-is-it-not-in-the-repository).

The app is also available as an APK from the [releases page](https://github.com/UnicornsOnLSD/finamp/releases).

As for the Play Store and App Store, those releases will be available in a few months. Because of this, most people won't be able to use the iOS version. If you have a Mac, you should be able to build/sideload the app onto your phone.

## Known Issues

This app is still a work in progress, and has some bugs/issues that haven't been fixed yet. Here is a list of currently known issues:

* Deleting large items (such as playlists) will cause the app to freeze for a few seconds
* Download indicators don't update properly
* Very occasionally, the audio player will break and start playing songs from previous queues. If this happens, you have to force stop the app to stop audio playback (I think this was fixed in 0.4.0).
* If you download an item while playing music, that item won't be played offline until you restart the app. This should be fixed with [audio_service 0.18.0](https://pub.dev/packages/audio_service).
* Seeking doesn't work with transcoded songs

If you encounter any of these issues, please make a new Github issue with your logs, which you can get in the logs screen.

## Planned Features

* Album art in offline mode
* Transcoding support for downloads
* Playlist management
* Multiple users/servers
* App icon
* Translation support

In the long run, I would like to look into video playback. I'm pretty sure I'll be able to implement it in a way that will allow for native playback of complex video formats, such as H265 and ASS subtitles. That's a long way off though ;).

## Screenshots

| | |
|:-------------------------:|:-------------------------:|
|<img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/1.jpg> | <img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/2.jpg>
| <img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/3.jpg> | <img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/4.jpg> |


Name source: https://www.reddit.com/r/jellyfin/comments/hjxshn/jellyamp_crossplatform_desktop_music_player/fwqs5i0/
