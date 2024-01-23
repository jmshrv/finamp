# Finamp

Finamp is a Jellyfin music player for Android and iOS. It's meant to give you a similar listening experience as traditional streaming services such as Spotify and Apple Music, but for the music that you already own. It's free, open-source software, just like Jellyfin itself.  
Some of its features include:

- A welcoming user interface that looks modern & unique, but still familiar
- Downloading files for offline listening and saving mobile data
- Transcoded streaming for saving mobile data
- Beautiful dynamic colors that adapt to your media
- Audio volume normalization ("ReplayGain") (Jellyfin 10.9+)
- Gapless playback
- Android Auto support (experimental, only works when installed via Google Play)
- Full support for Jellyfin's "Playback Reporting" feature and plugin, letting you keep track of your listening activity

## Downloading

<div style="display: flex; align-items: center;">

[<img src="app-store-badges/fdroid.png"
    alt="Get it on F-Droid"
    height="80">](https://f-droid.org/packages/com.unicornsonlsd.finamp/)

[<img src="app-store-badges/play-store.png"
    alt="Get it on Google Play"
    height="80">](https://play.google.com/store/apps/details?id=com.unicornsonlsd.finamp)

[<img style="margin-left: 15px;" src="app-store-badges/app-store.svg"
    alt="Download on the App Store"
    height="55">](https://apps.apple.com/us/app/finamp/id1574922594)

</div>

<sup>Note: The F-Droid release may take a day or two to get updates because since [F-Droid only builds once a day](https://www.f-droid.org/en/docs/FAQ_-_App_Developers/#ive-published-a-new-release-why-is-it-not-in-the-repository).</sup>  
The app is also available as an APK from the [releases page](https://github.com/jmshrv/finamp/releases).

### Frequently Asked Questions

#### Before Installing

##### Is Finamp free?
Absolutely! It costs nothing to use. We do appreciate voluntary contributions of any kind though, be that bug reports, code, designs, or ideas for new features. You can also donate to some of the developers to show your appreciation <3

##### How can I install Finamp?
On Android, Finamp can be installed from the Google Play Store, F-Droid store, or directly by installing the APK file from GitHub.  
On iOS, you can install Finamp through Apple's App Store. Just click on the buttons above.

##### Does Finamp support my media formats?
Finamp should support all formats supported by Jellyfin. Some more advanced formats could cause issues for regular playback, but transcoding should fix these issues.

##### Does Finamp support Android Auto / Apple CarPlay?
Theoretically, but not yet. There is [an issue for this](https://github.com/jmshrv/finamp/issues/24) that contains a proof of concept for Android Auto in there, but it hasn't been tested yet. Maybe you could help out!

##### Is Finamp legal?
Yes. Finamp is a *tool* that lets you interface with a Jellyfin server. Finamp does not come with any music, and will not connect to streaming services other than Jellyfin. You will need to bring your own media and add it to Jellyfin, for example by purchasing music online. This often also directly supports your favorite artists!

#### After Installing

##### I'm having trouble with Finamp, where can I find help?
If you're experiencing software bugs or other issues with Finamp, be sure to take a look at [Finamp's issue tracker](https://github.com/jmshrv/finamp/issues), especially the pinned issues at the top of the page. If you can't find anything related to your specific problem, please create a new issue (you will need a GitHub account).

##### My Playlists aren't showing up!
A recent Jellyfin update (10.8.11) included some changes to how playlists show up. This was done by mistake and should be fixed in a coming Jellyfin update soon. In case the update is delayed, we will try to temporarily change how Finamp shows playlists until the problem is resolved.

## Contributing

Finamp is a community-driven project and relies on people like **you** and their contributions. To learn how you could help out with making Finamp even better, take a look at our [Contribution Guidelines](CONTRIBUTING.md)

## Known Issues

This app is still a work in progress, and has some bugs/issues that haven't been fixed yet. Here is a list of currently known issues:

- Reordering the queue while shuffle is enabled is not possible at the moment. It seems like this is an issue with a dependency of Finamp (`just_audio`), and is being tracked [here](https://github.com/ryanheise/just_audio/issues/1042)
- If you have a very large library or an older phone, performance might not be great in some places
- Download indicators occasionally don't update

## Planned Features

- Lyrics support (Jellyfin 10.9+)
- Improved Android Auto / Apple CarPlay support
- Full redesign, adding more features and a home screen. See [this issue](https://github.com/jmshrv/finamp/issues/220) for more info
- Better playlist editing
- Transcoding support for downloads
- Multiple users/servers
- More customization options

## Screenshots

| | |
|:-------------------------:|:-------------------------:|
|<img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/1.png> | <img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/2.png>
| <img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/3.png> | <img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/4.png> |


Name source: https://www.reddit.com/r/jellyfin/comments/hjxshn/jellyamp_crossplatform_desktop_music_player/fwqs5i0/
