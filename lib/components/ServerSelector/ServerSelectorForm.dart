import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/JellyfinAPI.dart';

class ServerSelectorForm extends StatefulWidget {
  const ServerSelectorForm({Key key}) : super(key: key);

  @override
  _ServerSelectorFormState createState() => _ServerSelectorFormState();
}

class _ServerSelectorFormState extends State<ServerSelectorForm> {
  final _formKey = GlobalKey<FormState>();

  String _address;
  String _protocol;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiProvider = Provider.of<JellyfinAPI>(context);

    return Container(
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField(
                        items: [
                          DropdownMenuItem(
                            child: Text("HTTP"),
                            value: "http",
                          ),
                          DropdownMenuItem(
                            child: Text("HTTPS"),
                            value: "https",
                          ),
                        ],
                        // We don't need to change the variable every time it's changed, only when the next button is pressed
                        onChanged: (newValue) {},
                        onSaved: (newValue) => _protocol = newValue,
                        validator: (value) {
                          if (value == null) {
                            return "Please input a protocol";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Protocol",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Address (with port)",
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(),
                        validator: (value) {
                          // TODO: Check if a server exists on the given IP during this validation?
                          if (value.isEmpty) {
                            return "Please enter an address";
                          }
                          return null;
                        },
                        onSaved: (newValue) => _address = newValue,
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // If the fields are validated, save them to the API
                    _formKey.currentState.save();
                    jellyfinApiProvider.address = _address;
                    jellyfinApiProvider.protocol = _protocol;

                    // Go to user selection
                    Navigator.of(context).pushNamed("/login/userSelector");
                  }
                },
                child: Text("Next"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
