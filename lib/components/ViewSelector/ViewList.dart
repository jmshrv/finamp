import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApiData.dart';
import '../../models/JellyfinModels.dart';
import '../../components/errorSnackbar.dart';

class ViewList extends StatefulWidget {
  ViewList({Key key}) : super(key: key);

  @override
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  Icon _getIcon(BaseItemDto item) {
    switch (item.collectionType) {
      case "movies":
        return Icon(Icons.movie);
        break;
      case "tvshows":
        return Icon(Icons.tv);
        break;
      case "music":
        return Icon(Icons.music_note);
        break;
      case "games":
        return Icon(Icons.games);
        break;
      case "books":
        return Icon(Icons.book);
        break;
      case "musicvideos":
        return Icon(Icons.music_video);
        break;
      case "homevideos":
        return Icon(Icons.videocam);
        break;
      case "livetv":
        return Icon(Icons.live_tv);
        break;
      case "channels":
        return Icon(Icons.settings_remote);
        break;
      case "playlists":
        return Icon(Icons.queue_music);
      default:
        return Icon(Icons.warning);
        break;
    }
  }

  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  Future viewListFuture;

  @override
  void initState() {
    super.initState();
    viewListFuture = jellyfinApiData.getMusicViews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            // If snapshot.data is empty, getMusicViews returned no music libraries. This means that the user doesn't have any music libraries.
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text("Could not find any music libraries."),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  leading: _getIcon(snapshot.data[index]),
                  onTap: () async {
                    JellyfinApiData jellyfinApiData =
                        GetIt.instance<JellyfinApiData>();
                    try {
                      jellyfinApiData.saveView(snapshot.data[index],
                          jellyfinApiData.currentUser.userDetails.user.id);
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/music", (route) => false);
                    } catch (e) {
                      errorSnackbar(e, context);
                    }
                  },
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          // TODO: Let the user refresh the page
          return Text(
              "Something broke and I can't be bothered to make a refresh thing right now. The error was: ${snapshot.error}");
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
