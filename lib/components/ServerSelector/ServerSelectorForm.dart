import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApiData.dart';

class ServerSelectorForm extends StatefulWidget {
  const ServerSelectorForm({Key key}) : super(key: key);

  @override
  _ServerSelectorFormState createState() => _ServerSelectorFormState();
}

class _ServerSelectorFormState extends State<ServerSelectorForm> {
  final _formKey = GlobalKey<FormState>();

  String _address;
  String _protocol;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    Row(
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
                                return "Required";
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
                            autocorrect: false,
                            keyboardType: TextInputType.url,
                            autofillHints: [AutofillHints.url],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) async => await sendForm(),
                            validator: (value) {
                              // TODO: Check if a server exists on the given IP during this validation?
                              if (value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            onSaved: (newValue) => _address = newValue,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                    Text(
                      "You will need to use the external IP of your server if you want to use your server remotely.",
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: RaisedButton(
                  onPressed: () async => await sendForm(),
                  child: Text("Next"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendForm() async {
    if (_formKey.currentState.validate()) {
      // If the fields are validated, save them to the API
      _formKey.currentState.save();
      await jellyfinApiData.saveBaseUrl(_protocol, _address);
      // Go to user selection
      Navigator.of(context).pushNamed("/login/userSelector");
    }
  }
}
