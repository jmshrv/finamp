![Banner](./GitHub_Banner.png)

## Help Make Jellyfin Mixes Smarter - Introducing [AudioMuse](https://github.com/NeptuneHub/AudioMuse-AI)

We, especially @NeptuneHub, are currently trying to make Jellyfin understand your music library better by analyzing how your tracks actually sound!  
You might already be familiar with this from Plex's "Sonic Analysis" feature.

We already got a good proof-of-concept, but we need **your help** to refine the algorithms!  
All you need to do is try it out and give us feedback about what you like and don't like, specifically for *your* music library!  

**To help testing**, just do the following:

1. Install AudioMuse as a separate service next to Jellyfin, using Docker or Kubernetes: <https://neptunehub.github.io/AudioMuse-AI/>
2. Once the containers are ready, go to `http://<server ip>:8000` to open the AudioMuse dashboard
3. Now, scroll down to click the "Start Analysis" button. AudioMuse will now analyze your entire library, that might take a few hours or even days. Please leave this running.
  
We've prepared a GitHub Issues form here: <https://github.com/NeptuneHub/AudioMuse-AI/issues/new?template=support-in-test.yml>  
This will guide you through which parameters to apply, and how to evaluate the results.

- You need to use the "Advanced" tab at the top right in the AudioMuse dashboard to change all required parameters
- Please double-check your parameters before starting to make sure the results are valid
- The basic process is as follows:
  1. Take the first (or next) test from "2. Test Parameters" and configure them in AudioMuse
  2. Scroll down and click the "Start Clustering" button, then wait for the task to finish (will take a few minutes to hours)
  3. Fill out the corresponding line in "2.1 Performance Properties"
  4. Go through the generated playlists (bottom of the AudioMuse dashboard) and get a good overview. Try to judge if the tracks in the playlists fit together well or not. You can also listen to the playlists, they are automatically created in Jellyfin. Just copy the playlists name and search for it.
  5. Evaluate the playlists/parameters via "3. Playlist Evaluation"
  6. Add any additional feedback via "4. Additional Feedback"
  7. Repeat for all tests (or more!)
- You can create/submit the issue after your first test, and then later edit the issue for each new test

**It would be amazing if you could help out with this! Thank you!**

---

#### Redesign Beta

We're currently in the process of redesigning Finamp to transform it into a modern, beautiful, and feature-rich music player made specifically for Jellyfin.  
You can join the beta on [Google Play](https://play.google.com/store/apps/details?id=com.unicornsonlsd.finamp) and [Apple TestFlight](https://testflight.apple.com/join/UqHTQTSs), or download the latest beta APK from the [releases page](https://github.com/jmshrv/finamp/releases).  
Please note that the beta is still work-in-progress, so the UI and functionality might be inconsistent or incomplete, and is not final. However, the beta is **fully functional and should be stable** enough for daily use.

---

**Finamp** is a Jellyfin music player for Android and iOS. It's meant to give you a similar listening experience as traditional streaming services such as Spotify and Apple Music, but for the music that you already own. It's free, open-source software, just like Jellyfin itself.  
Some of its features include:

- A welcoming user interface that looks modern & unique, but still familiar
- Downloading files for offline listening and saving mobile data. Can use transcoded downloads to save even more space.
- Transcoded streaming for saving mobile data
- Beautiful dynamic colors that adapt to your media
- Audio volume normalization ("ReplayGain") (Jellyfin 10.9+)
- Lyrics (Jellyfin 10.9+)
- Gapless playback
- Android Auto support (coming soon™)
- Full support for Jellyfin's "Playback Reporting" feature and plugin, letting you keep track of your listening activity

***You need your own Jellyfin server to use Finamp. If you don't have one yet, take a look at [Jellyfin's website](https://jellyfin.org/) to learn more about it and how to set it up.***

## Getting Finamp

<div style="display: flex; align-items: center;" align="center">

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

### Community & Discussions

Have a simple question about Finamp, or struggling with setting up your Jellyfin correctly?  
Just want someone to talk to and share your favorite music with?  
Aside from using the [Issues](https://github.com/jmshrv/finamp/issues) and [Discussions](https://github.com/jmshrv/finamp/discussions) functionality here on GitHub, you could also **[join our Discord server](https://discord.gg/xh9SZ73jWk)!**  
We post release notes and announcements there too, and you'll likely get a reply more quickly there compared to GitHub.

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

## Contributing

Finamp is a community-driven project and relies on people like **you** and their contributions. To learn how you could help out with making Finamp even better, take a look at our [Contribution Guidelines](CONTRIBUTING.md)

### Translations

You can also contribute by helping to translate Finamp! This is done through our Weblate instance here: <https://hosted.weblate.org/engage/finamp/>. The current translation status is this:

<a href="https://hosted.weblate.org/engage/finamp/">
  <img src="https://hosted.weblate.org/widget/finamp/finamp/horizontal-auto.svg" alt="Translation status" />
</a>

## Known Issues

This app is still a work in progress, and has some bugs/issues that haven't been fixed yet. Here is a list of currently known issues:

- Reordering the queue while shuffle is enabled is not possible at the moment. It seems like this is an issue with a dependency of Finamp (`just_audio`), and is being tracked [here](https://github.com/ryanheise/just_audio/issues/1042)
- If you have a very large library or an older phone, performance might not be great in some places

## Planned Features

- Improved Android Auto / Apple CarPlay support
- Full redesign, adding more features and a home screen. See [this issue](https://github.com/jmshrv/finamp/issues/220) for more info
- Better playlist editing
- Multiple users/servers
- More customization options

## Screenshots (Stable Version, outdated)

| | |
|:-------------------------:|:-------------------------:|
|<img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/1.png> | <img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/2.png>
| <img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/3.png> | <img src=https://raw.githubusercontent.com/jmshrv/finamp/master/fastlane/metadata/android/en-US/images/phoneScreenshots/4.png> |


Name source: https://www.reddit.com/r/jellyfin/comments/hjxshn/jellyamp_crossplatform_desktop_music_player/fwqs5i0/
