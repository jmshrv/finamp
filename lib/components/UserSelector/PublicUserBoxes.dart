import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/JellyfinAPI.dart';
import 'loginHelper.dart';

class PublicUserBoxes extends StatelessWidget {
  const PublicUserBoxes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jellyfinApiProvider = Provider.of<JellyfinAPI>(context);

    final cardWidth = 150.0;
    final cardHeight = 200.0;

    return FutureBuilder(
        future: jellyfinApiProvider.publicUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
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
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    UserDto user = snapshot.data[i];

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
    final jellyfinApiProvider = Provider.of<JellyfinAPI>(context);

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
                        jellyfinApiProvider: jellyfinApiProvider,
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
                        child: jellyfinApiProvider.getProfilePicture(
                            user: widget.user, maxHeight: 150),
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
