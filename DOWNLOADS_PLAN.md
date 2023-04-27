# Finamp 1.0 Plan - Downloads Rewrite

## Introduction

This document outlines the core plan and motivation for Finamp 1.0. This change will need a major version bump as it will introduce breaking changes. As such, we will have to ensure that users are notified well in advance.

## Motivations

Finamp's downloading infrastructure is currently very poor. It was mostly written before I had any formal computer science experience. Because of this, it is very finnicky, and frequently breaks between updates. Some highlights include:

* Download items being tracked across five key-value databases that all need to be kept in sync:
    * `DownloadedItems` - stores downloaded song data.
    * `DownloadedParents` - stores data about parents (albums, playlists), with links to children.
        * By link, I mean a copy of the Jellyfin metadata stored in `DownloadedItems`. Syncing between the two is done manually.
    * `DownloadIds` - a copy of the data stored in `DownloadedItems`, but indexed by the `flutter_downloader` download ID so that we can track the download ID back to the actual song.
    * `DownloadedImages` - stores downloaded image data.
    * `DownloadedImageIds` - same as `DownloadIds`, but for images.
        * `DownloadIds` cannot be used for images, as it takes a `DownloadedSong` data type (yes, a complete copy).
* In the past, I stored absolute paths. The `DownloadedSong` data-type has to account for this, and update as it goes along.
    * This is especially problematic on iOS, where the internal app directory changes every update.
* Off the top of my head, there is no clean way to add support for downloaded artists, or especially genres

The download system also makes use of the [flutter_downloader](https://pub.dev/packages/flutter_downloader) package. In the new system, I will be replacing it with [background_downloader](https://pub.dev/packages/background_downloader) for the following reasons:

* Desktop support - While downloading isn't 100% essential for desktop, it will be nice to have a complete version of Finamp on desktop. Desktop support will also be required for Linux phones.
* Better looking API - `flutter_downloader` is extremely finnicky, especially around listening for updates. This is why download indicators have never really worked in Finamp.
* Scoped storage support - Finamp's support for external directories is currently practically broken. It seems to be a pretty niche feature, but it would be nice to have working again.
* Relative path handling by default - this will solve the absolute path issue I mentioned earlier.
* Better stability - `flutter_downloader` has had a history of spurious bugs causing crashes and other issues. Most recently, [downloads on iOS failed to get marked as complete](https://github.com/jmshrv/finamp/issues/433), causing downloads to effectively break on iOS. I haven't tried `background_downloader` myself yet, but it has a much more rigid testing setup which should help it catch regressions like this.

Finamp also uses [Hive](https://pub.dev/packages/hive) for all of its databases. Hive is a great database, but it isn't intended for complex use-cases like this. The same people behind Hive have created [Isar](https://pub.dev/packages/isar), which supports more advanced use-cases. I didn't use this initially as it was still in early development during Finamp's initial development, but it is now stable. For downloads, it will allow me to actually model relations in the database to make adding and removing downloads more reliable. I will also likely replace Finamp's other Hive databases with Isar databases.

## Impacts

Doing all of this will be an extremely damaging breaking change. Finamp's last breaking change was [0.5.0](https://github.com/jmshrv/finamp/releases/tag/0.5.0), which required all users to clear their app data (loading databases from before 0.5.0 failed). This was almost acceptable back then - Finamp was still in its early days and hadn't yet been released on the App Store or Play Store (0.5.0 was the first release). Now, Finamp has roughly 25,000 downloads (thank you!). I can't just release an update that breaks everything without giving months of notice, especially since the app will be auto-updated to 1.0.

While the app won't fail to launch like 0.5.0 did, it will effectively log the user out (as the user database will be replaced). Downloads will also be wiped by deleting the internal song directory. Users must be aware that this is happening - one of the first "actions" of this will be to add a visible warning to the app linking here (with a brief explanation at the top).