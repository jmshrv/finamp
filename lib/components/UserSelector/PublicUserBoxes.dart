import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/JellyfinApi.dart';
import '../../models/JellyfinModels.dart';
import 'loginHelper.dart';

class PublicUserBoxes extends StatefulWidget {
  const PublicUserBoxes({Key key}) : super(key: key);

  @override
  _PublicUserBoxesState createState() => _PublicUserBoxesState();
}

class _PublicUserBoxesState extends State<PublicUserBoxes> {
  Future publicUserBoxesFuture;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiServiceProvider = Provider.of<JellyfinApi>(context);

    final cardWidth = 150.0;
    final cardHeight = 200.0;

    // This is the same hack that is explained in AlbumView
    if (publicUserBoxesFuture == null) {
      // TODO: make this widget use JellyfinApiData instead of directly interacting with Chopper.
      jellyfinApiServiceProvider.getPublicUsers();
    }

    return FutureBuilder(
        future: publicUserBoxesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // TODO: Do conversion in Chopper
            List<UserDto> decodedPublicUsers = [];

            for (final i in snapshot.data.body) {
              decodedPublicUsers.add(UserDto.fromJson(i));
            }
            if (decodedPublicUsers.length == 0) {
              return Container(
                height: cardHeight,
                child: Center(
                  child: Text("No public users found"),
                ),
              );
            } else {
              return Container(
                height: cardHeight,
                child: ListView.builder(
                  itemCount: decodedPublicUsers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    UserDto user = decodedPublicUsers[i];

                    return PublicUserBox(
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                        user: user);
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Container(
              height: cardHeight,
              child: Center(
                child: Text("Something went wrong: ${snapshot.error}"),
              ),
            );
          } else {
            return Container(
              height: cardHeight,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class PublicUserBox extends StatefulWidget {
  const PublicUserBox({
    Key key,
    @required this.cardWidth,
    @required this.cardHeight,
    @required this.user,
  }) : super(key: key);

  final double cardWidth;
  final double cardHeight;
  final UserDto user;

  @override
  _PublicUserBoxState createState() => _PublicUserBoxState();
}

class _PublicUserBoxState extends State<PublicUserBox> {
  bool isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiServiceProvider = Provider.of<JellyfinApi>(context);

    return Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
        child: Card(
          // This is so that the image gets clipped properly
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
            // TODO: Handle public users with passwords (potentially by showing a new screen to enter the password)
            onTap: isAuthenticating
                ? null // This disables the onTap function while the user is authing
                : () async {
                    setState(() {
                      isAuthenticating = true;
                    });
                    await loginHelper(
                        jellyfinApiServiceProvider: jellyfinApiServiceProvider,
                        username: widget.user.name,
                        context: context);
                    setState(() {
                      isAuthenticating = false;
                    });
                  },
            child: isAuthenticating
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Container(
                        // We use the width for both values to make the image square
                        width: widget.cardWidth,
                        height: widget.cardWidth,
                        child: jellyfinApiServiceProvider.getProfilePicture(),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            child: Text(widget.user.name)),
                      )
                    ],
                  ),
          ),
        ));
  }
}
