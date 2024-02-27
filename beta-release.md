# Announcing Finamp's Redesign Beta (v0.9.2-beta)

![Several screenshots of the app showing off different screens and features in both light and dark mode](./Showcase.png)

---

## Shortened Release Notes (For Stores)

Welcome to Finamp's redesign beta!  
This is a work-in-progress effort to transform Finamp into a modern, beautiful, and feature-rich music player made specifically for Jellyfin.

Please join the discussion on Discord (https://discord.gg/EAeSaEjtuQ) or GitHub (https://github.com/jmshrv/finamp/discussions/603) and let us know what you think!

Here are the highlights:

- Redesigned player screen, mini player, and queue panel
- New queueing system with "Next Up" queue
- New and vastly improved download system
  - Download your entire library, transcode to a lower bitrate, and much more
- Improved login flow
- New artist screen
- Audio volume normalization ("ReplayGain")
- Basic playback history & improved playback reporting
- Support for Android's monochrome launcher icons
- Many bug fixes

Thanks to all the contributors who made this possible, and thank you for using Finamp!

---

Hi everyone! We're excited to announce that we're launching a beta of Finamp's redesign today. This is a major update to the app, and we're looking for feedback from anyone willing to try it out before we roll it out to everyone.

The beta is a work-in-progress, there are several new features already, but we will be adding more features over time.

## How to join the beta

The beta is free and open to everyone, but we'd like to get as much feedback as possible. So please do try it out and then let us know what you think!

1. Join the [Finamp Beta Testers Discord server](https://discord.gg/EAeSaEjtuQ)
   - This step is optional, but since we're looking for feedback, it would be great if you could join!
2. Take note of your current Finamp settings, since this is a beta it could happen that the update changes some of them.
   - Downloads should be migrated, but since the new download system is completely different, there might be inconsistencies.
3. On Android, join the beta on [Google Play](https://play.google.com/store/apps/details?id=com.unicornsonlsd.finamp) or download the APK file from below.  
   On iOS, join the beta on [TestFlight](https://testflight.apple.com/join/AyqD6mj7).
   - We're currently not able to offer a beta on F-Droid ([more info here](https://github.com/jmshrv/finamp/issues/220#issuecomment-1850351616)), but you can use an app like [Obtainium](https://github.com/ImranR98/Obtainium) to automatically download the latest APK from GitHub.
4. Open Finamp and enjoy!

*Keep in mind that all of the text in the beta hasn't been translated yet, so it will be shown in English no matter which language your device is set to. We're not able to add more translations to the beta just yet (it's not as easy to configure as we'd hoped), but we'll let you know once you can help translating all of the new stuff!* 

## What's New

There are many changes in the beta, and they have been contributed by many different people. These people spent a lot of time and effort to make Finamp better, so please take a look if they implemented something that makes your experience better, say thanks, and consider donating then a coffee or two!  
You can find a list of all contributors below.

### TL;DR

- Redesigned player screen, mini player, and queue panel
- New queueing system with "Next Up" queue
- New and vastly improved download system
  - Download your entire library, transcode to a lower bitrate, and much more
- Improved login flow
- New artist screen
- Audio volume normalization ("ReplayGain")
- Basic playback history & improved playback reporting
- Support for Android's monochrome launcher icons
- Many bug fixes
- A few other things that I probably forgot

### New Design (contributed by @Chaphasilor)

As the title suggests, the app is being redesigned. Most notably, the player screen, mini player, queue panel, and the song menu have a new look and many new features.  
The rest of the app will gradually be updated as well, with some design mockups already done. You can take a look at the discussion [in the pinned redesign issue](https://github.com/jmshrv/finamp/issues/220).

### Redesigned Player Screen (contributed by @Y0ngg4n, @jmshrv, and @Chaphasilor)

The new player screen should have everything it had before, but with a new look and some additional goodies.  
The colors used within the player screen are based on the album art, so it should look different for every song. Currently, this can't be disabled, but it will likely be an option in the future.
If a song has multiple artists (and Jellyfin has parsed them correctly), they will all be shown in the artist section. You can scroll the section horizontally if there are too many artists to fit on the screen. You can also click any artist to go to their page.  
The section above the progress bar also shows any additional information related to the song, e.g. if it's transcoding. We can hopefully add more information here in the future.  
The sleep timer has been moved to the menu, which you can open by clicking the three horizontal lines on the left side of the artist section.

### Redesigned Song Menu (contributed by @Y0ngg4n and @Chaphasilor)

The song menu has also been redesigned. It shows more information about the song, can fit more options, and can contain additional elements when on the player screen (sleep timer, shuffle mode, etc.).

### New Queueing System and Queue Panel (contributed by @Chaphasilor)

Previously, the queue panel was pretty barebones, and had a few glitches.  
The new queue panel is more beautiful, has more features, and hopefully way less glitches.
Here are the highlights:

- Restore the queue from the previous session (contributed by @Komodo5197)
  - By default, the last played queue will be loaded again when the app is restarted, so you can continue listening where you left off
- Queue consists of four sections: previous tracks, current track, "Next Up", and the regular queue
  - When opening the queue panel, you'll alway see the current track at the top, and the upcoming tracks below it
  - The "Next Up" queue is pretty powerful:
    - You can add any track to it by selecting "Add to Next Up" (append) or "Play next" (prepend, only available if there are songs in the Next Up queue) from the menu
    - You can also add collections (albums, playlists, artists, etc.) to it (support varies by type of collection, let us know if you're missing something)
    - Tracks in the "Next Up" queue can be reordered
    - Toggling shuffle or repeat modes will not affect the "Next Up" queue!
- You can drag tracks to reorder them using the 6-dot drag handle at the right (and it actually works correctly now!)
  - This only works when *shuffle is disabled* for now, due to a bug in a dependency we use
- Long press on a track to open the menu
- Toggle shuffle and repeat modes from the queue panel
- See the *source* of the queue, i.e. which album/playlist/artist you selected to play from
  - The source is shown at the top of the player screen and in the queue panel
  - Click on the source to go directly to it
  - The source on the player screen also adapts to the source of the current track (e.g. Next Up)

### New Download System (contributed by @Komodo5197)

Finamp was always able to download your music, but now (thanks to @Komodo5197 tireless efforts) this functionality has been supercharged!  
They really did an amazing job, and made the single largest contribution to the app so far, rewriting about 50% of the code in the process.
The new download system should be faster, more reliable, and offers many new features:

- Download your entire library
- Transcode your downloads to a lower bitrate to save space on your device (initial implementation by @jmshrv)
  - On iOS it is only possible to transcode to MP3 for now, but Jellyfin 10.9 will add support for transcoding to AAC
- Download albums, playlists, artists, and even individual songs
- Download all your favorites (songs, albums, artists, playlists)
- Download your latest albums
  - Right now this is fixed to the 5 most recently added albums, but this will likely change in the future. Let us know your thoughts!
- Show missing songs in offline mode for albums and playlists
  - Let us know if you need an option to disable this
- Synchronize your downloads when you start the app
  - All your downloaded collections will be checked for updates, downloading new songs and removing deleted/removed ones
  - This works for all collections, entire libraries, favorites, and latest albums
- Require WiFi for downloading
  - Downloading will be paused when you're not connected to WiFi, and will resume when you are
  - Please let us know if you're having issues with this

### Improved Login Flow (contributed by @Chaphasilor)

When opening the app for the first time, you'll be greeted with a new login screen.  
It doesn't just have a new look, but also has some new features. Servers on your local network can now be discovered automatically (if your server is configured correctly, see below), and you can finally use Quick Connect for easy login.  
This also enables you to use Finamp in combination with a Single Sign-On solution.

#### Discovering Servers on Your Local Network

Automatic server discovery relies on UDP broadcasts. For it to work, your Jellyfin server needs to be accessible via **UDP** port `7359`.  
Server discovery is also limited to your local network, so your server can only be discovered if you're connected to the same network as your phone.

### New Artist and Genre Screens (contributed by @Tiefseetauchner)

The artist and genre screens now looks similar to the album screen, but shows not only all albums, but also the top songs of the artist/genre. Top songs are determined by the play count within Jellyfin.  
On the artist screen, you can also shuffle all songs, shuffle albums, or add the artist to Next Up.

### Audio Volume Normalization ("ReplayGain") (contributed by @Chaphasilor)

Jellyfin 10.9 will scan your music library to generate "Loudness Units Full Scale" (LUFS) values for each track. These values can be used to normalize the volume of your music, so all tracks should be equally loud.  
Finamp will use these values and apply the normalization by default, as long as the server has generated them. Of course, Jellyfin 10.9 has not been released yet, but you can try it out by setting up the unstable version of Jellyfin.  
Or just wait until it's released, you should hear the difference!

Some caveats:

- Volume will be normalized to -14 LUFS, which is the industry default. This means music played on Finamp will be quieter than before, but should now be more consistent with other music streaming apps like Spotify
- On iOS, we aren't able to directly change the gain of the audio, so we need to change the actual volume to emulate the normalization. That means the volume will be even lower, and songs much quieter than -14 LUFS will still not be as loud as the other tracks. It should still be a much better experience.

### Playback History (contributed by @Chaphasilor)

Finamp will now keep track of what you songs you listened to, and when. This is great for liking a song that you already finished listening to, or finding out why you have that specific song stuck in your head.  
You can see the history in the new Playback History screen, which you can open from the sidebar menu.  
**The history is only stored for the current session at the moment**, but will be loaded from your Jellyfin server in the future.

*Make sure to install the [Playback Reporting plugin](https://github.com/jellyfin/jellyfin-plugin-playbackreporting) on your server, and set the data retention interval to at least 2 years.*

### Support for Android's Monochrome Launcher Icons (contributed by @AhegaHOE)

On Android 12+, Finamp's icon can now adapt to your system theme.

### Miscellaneous

- Increased default buffer duration to 10 minutes
  - Keep listening to your music even with a spotty connection
  - If the app is being closed more frequently on iOS, try decreasing the duration in the settings and let us know about the issue!
- Clicking on a song in the songs tab will now start an Instant Mix
- Repeat mode is now saved across restarts
- Added an AirPlay button to the player screen on iOS (contributed by @ihatetoregister)
- Show multiple artists on the album screen (contributed by @rom4nik and @Chaphasilor)
- Added an option to choose if swiping a song within a collection adds it to the queue or to Next Up (contributed by @JAIABRIEL)
- Improved Playback Reporting (contributed by @Maxr1998)
  - Issues with scrobbling to Last.fm should be fixed now
  - If playback reporting fails or offline mode is enabled, the app will save playback events to an internal file. To extract it, click the "share" button on the Playback History screen
- Switched to Material 3/You theme for default components (contributed by @Maxr1998)
  - This only applies to sections of the app that haven't been redesigned yet

### Fixes

There are way too many fixes to list them all here, but here are some of the most important ones:

- Various shuffling issues (#147, #491)
- Various scrobbling / Playback Reporting issues (#421, #270, #87)
- Various downloading issues (#384, #420, #188, #134, #48, #531, #97, #478)
- Missing album art in offline mode on iOS (#573)
- Album covers getting cropped on some screen layouts (#324)

## List of Contributors (sorted alphabetically)

All of these people have contributed to the beta in some way, and if they implemented something that you like in particular, why not give them something back?

- @AhegaHOE: Support for Android's monochrome launcher icons
- @Chaphasilor: Redesigned player screen, mini player, queue panel, song menu, login flow, audio volume normalization, playback history, and various other features and fixes
  - Sponsor me on GitHub: <https://github.com/sponsors/Chaphasilor/>
- @jmshrv: App creator, transcoded downloads, player screen redesign
- @Komodo5197: New download system, restore queue from previous session
- @Maxr1998: Improved playback reporting, Material 3/You theme, various fixes
  - Sponsor them on GitHub: <https://github.com/sponsors/Maxr1998>
- @rom4nik: Show multiple artists on the album screen
- @Tiefseetauchner: New artist and genre screens
- @Y0ngg4n: Redesigned player screen, redesigned song menu

## Update Cadence

Since this is a beta, we'll try to have much more frequent updates. However, we need new features to be developed before we can release anything, so we cannot give a general timeframe for updates.  
If there's something that you'd like to see in the app, why not contribute it yourself? We're always looking for new contributors, and we're happy to help you get started. You can read the [contribution guidelines](https://github.com/jmshrv/finamp/CONTRIBUTING.md) for a primer.

## Upcoming Features

We have a lot of features planned for the future, and we're always open to new ideas. Here are some of the things that we're planning to add:

- Android Auto / Automotive Support
- Playback Speed Control
- Lyrics Support
- Improved Search
- Multi-Queues

You can take a look at the full list and current progress in the [Redesign project](https://github.com/users/jmshrv/projects/2).

---

Well, that was a lot of text. If you made it this far, thank you for reading!  
If you have questions about any of these new features or the beta in general, feel free to join the [Finamp Beta Testers Discord server](https://discord.gg/EAeSaEjtuQ) and ask there, or use the [Redesign Beta discussion on GitHub](https://github.com/jmshrv/finamp/discussions/603).  
And thank you for using Finamp!

\- Chaphasilor

---

## Download Links

- Google Play: [Join the beta](https://play.google.com/store/apps/details?id=com.unicornsonlsd.finamp)
- TestFlight: [Join the beta](https://testflight.apple.com/join/AyqD6mj7)
- F-Droid: not available, see above
- APK: see below
