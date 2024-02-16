# Announcing Finamp's Redesign Beta

Hi everyone! We're excited to announce that we're launching a beta of Finamp's redesign today. This is a major update to the app, and we're looking for feedback from our users before we roll it out to everyone.

The beta is a work-in-progress, there are several new features already, but we will be adding more features over time.

## How to join the beta

1. Join the [Finamp Beta Testers Discord server](https://discord.gg/)
   - This step is optional, but since we're looking for feedback, it would be great if you could join!
2. Take note of your current Finamp settings, since this is a beta it could happen that the update changes some of them.
   - Downloads should be migrated, but since the new download system is completely different, there might be inconsistencies.
3. On Android, join the beta on [Google Play](https://play.google.com/apps/testing/) or download the APK file from below.  
   On iOS, join the beta on [TestFlight](https://testflight.apple.com/join/).
   - We're currently not able to offer a beta on F-Droid ([more info here](https://github.com/jmshrv/finamp/issues/220#issuecomment-1850351616)), but you can use an app like [Obtainium](https://github.com/ImranR98/Obtainium) to automatically download the latest APK from GitHub.
4. Open Finamp and enjoy!

## What's new

There are many changes in the beta, and they have been contributed by many different people. These people spent a lot of time and effort to make Finamp better, so please take a look if they implemented something that makes your experience better, and consider donating then a coffee or two!  
You can find a list of all contributors below.

### TL;DR

- Redesigned player screen, mini player, and queue panel
- New queueing system with "Next Up" queue
- New download system
- Android Auto support
- Improved login flow
- New artist screen
- Audio volume normalization
- Playback history
- Support for Android's monochrome launcher icons
- Many bug fixes

### New Design

As the name suggests, the app is being redesigned. Most notably, the player screen, mini player, and the queue panel have a new look and many new features.  
The rest of the app will gradually be updated as well, with some design mockups already done. You can take a look at the discussion [in the pinned redesign issue](https://github.com/jmshrv/finamp/issues/220).

### Redesigned Player Screen (mainly contributed by @Y0ngg4n)

The new player screen should have everything it had before, but with a new look and some additional goodies.  
The colors used within the player screen are based on the album art, so it should look different for every song. Currently, this can't be disabled, but it will likely be an option in the future.
If a song has multiple artists (and Jellyfin has parsed them correctly), they will all be shown in the artist section. You can scroll the section horizontally if there are too many artists to fit on the screen. You can also click any artist to go to their page.  
The section above the progress bar also shows any additional information related to the song, e.g. if it's transcoding. We can hopefully add more information here in the future.  
The sleep timer has been moved to the menu, which you can open by clicking the three horizontal lines on the left side of the artist section.

### Redesigned Song Menu (mainly contributed by @Y0ngg4n)

The song menu has also been redesigned. It shows more information about the song, can fit more options, and can contain additional elements when on the player screen (sleep timer, shuffle mode, etc.).

### New Queueing System and Queue Panel

Previously, the queue panel was pretty barebones, and had a few glitches.  
The new queue panel is more beautiful, has more features, and hopefully less glitches.
Here are the highlights:

- Restore the queue from the previous session (contributed by @Komodo5197)
  - By default, the last played queue will be loaded again when the app is restarted, so you can continue listening where you left off
- Queue consists of four sections: previous tracks, current track, "Next Up", and the regular queue
  - When opening the queue panel, you'll alway see the current track at the top, and the upcoming tracks below it
  - The "Next Up" queue is pretty powerful:
    - You can add any track to it by selecting "Add to Next Up" (append) or "Play next" (prepend) from the menu
    - You can also add collections (albums, playlists, artists, etc.) to it (support varies by type of collection, let us know if you're missing something)
    - Tracks in the "Next Up" queue can be reordered
    - Toggling shuffle or repeat modes will not affect the "Next Up" queue!
- You can drag tracks to reorder them (and it actually works correctly now!)
  - This only works when *shuffle is disabled* for now
- Long press on a track to open the menu
- Toggle shuffle and repeat modes from the queue panel
- See the *source* of the queue, i.e. which album/playlist/artist you selected to play from
  - Click on the source to go directly to it

### New Download System (contributed by @Komodo5197)

Finamp was always able to download your music, but now (thanks to @Komodo5197) this functionality has been supercharged!  
The new download system should be faster, more reliable, and offers many new features:

- Download albums, playlists, artists, and even individual songs
- Download all your favorites (songs, albums, artists, playlists)
- Download your latest albums
  - Right now this is fixed to the 5 most recently added albums, but this will likely change in the future. Let us know your thoughts!
- Show missing songs in offline mode for albums and playlists
  - Let us know if you need an option to disable this
- Synchronize your downloads when you start the app
  - All your downloaded collections will be checked for updates, downloading new songs and removing deleted/removed ones
- Require WiFi for downloading
  - This setting is still experimental, and disabled by default. Please let us know if you have any issues with it.

### Android Auto Support (contributed by @puff)

Some of you have been waiting for this for a long time, and it's finally here!  
If you installed the beta from Google Play, you can connect your phone to your car and stream music right from your Jellyfin server. There might be some bugs, so please let us know if you find any.  
The functionality is limited of course, since it's not meant to be interacted with too much while driving.  
Some features are also still missing, like (voice) search, a favorite button, and a section with recommendations.

### Improved Login Flow

When opening the app for the first time, you'll be greeted with a new login screen.  
It doesn't just have a new look, but also has some new features. Servers on your local network can now be discovered automatically (if your server is configured correctly), and you can finall use Quick Connect for easy login.  
This also enables you to use Finamp in combination with a Single Sign-On solution.

### New Artist Screen (contributed by @Tiefseetauchner)

The artist screen now looks similar to the album screen, but shows not only all albums, but also the top songs of the artist.  
Top songs are determined by the play count within Jellyfin. You can also shuffle all songs, shuffle albums, or add the artist to Next Up.

### Audio Volume Normalization ("ReplayGain")

Jellyfin 10.9 will scan your music library to generate "Loudness Units Full Scale" (LUFS) values for each track. These values can be used to normalize the volume of your music, so all tracks should be equally loud.  
Finamp will use these values and apply the normalization by default, as long as the server has generated them. Of course, Jellyfin 10.9 has not been released yet, but you can try it out by setting up the unstable version of Jellyfin.  
Or just wait until it's released, you should hear the difference!

Some caveats:

- Volume will be normalized to -14 LUFS, which is the industry default. This means music played on Finamp will be quieter than before, but should now be more consistent with other music streaming apps like Spotify
- On iOS, we aren't able to directly change the gain of the audio, so we need to change the actual volume to emulate the normalization. That means the volume will be even lower, and songs much quieter than -14 LUFS will still not be as loud as the other tracks. It should still be a much better experience.

### Playback History

Finamp will now keep track of what you songs you listened to, and when. This is great for liking a song that you already finished listening to, or finding out why you have that specific song stuck in your head.  
You can see the history in the new Playback History screen, which you can open from the sidebar menu.  
The history is only stored for the current session at the moment, but will be loaded from your Jellyfin server in the future. Make sure to install the [Playback Reporting plugin](https://github.com/jellyfin/jellyfin-plugin-playbackreporting) on your server, and set the data retention interval to at least 2 years.

### Support for Android's Monochrome Launcher Icons (contributed by @AhegaHOE)

On Android 12+, Finamp's icon can now adapt to your system theme.

### Miscellaneous

- Increased default buffer duration to 10 minutes
  - Keep listening to your music even with a spotty connection
- Clicking on a song in the songs tab will now start an Instant Mix
- Repeat mode is now saved across restarts
- Show multiple artists on the album screen (mainly contributed by @rom4nik)
- There's not a "fast scroller" on the right side, where you can quickly jump to a specific letter (contributed by @Guillergood)
  - This only works when sorting by name, and can be hidden in the settings
- Improved Playback Reporting (contributed by @Maxr1998)
  - Issues with scrobbling to Last.fm should be fixed now
  - If playback reporting fails or offline mode is enabled, the app will save playback events to an internal file. To extract it, click the "share" button on the Playback History screen
- Switched to Material 3/You theme for default components
  - This only applies to sections of the app that haven't been redesigned yet
- Minimum Android version has been increased from 5.0 to 8.0. We hope this won't affect too many users!

### Fixes

There are way too many fixes to list them all here, but here are some of the most important ones:

- Various shuffling issues (#147, #491)
- Various scrobbling / Playback Reporting issues (#421, #270, #87)
- Various downloading issues (#384, #420, #188, #134, #48, #531, #97, #478)
- Missing album art in offline mode on iOS (#573)
- Album covers getting cropped on some screen layouts (#324)

---

- Discord link
- Google Play beta link
- TestFlight link
- APKs (split by architecture?)
