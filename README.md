# Finamp

Finamp is a Jellyfin music player for Android and iOS. Its main feature is the ability to download songs for offline listening.

## Downloading

Currently, the app is only available as an APK from the [releases page](https://github.com/UnicornsOnLSD/finamp/releases). I'm working on an F-Droid release, which should be available soon.

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
|<img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/screenshots/music.png> | <img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/screenshots/downloads.png>
| <img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/screenshots/album.png> | <img src=https://raw.githubusercontent.com/UnicornsOnLSD/finamp/master/screenshots/player.png> |


Name source: https://www.reddit.com/r/jellyfin/comments/hjxshn/jellyamp_crossplatform_desktop_music_player/fwqs5i0/
