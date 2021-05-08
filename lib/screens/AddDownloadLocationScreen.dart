import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../components/AddDownloadLocationScreen/CustomDownloadLocationForm.dart';
import '../components/AddDownloadLocationScreen/AppDirectoryLocationForm.dart';
import '../models/FinampModels.dart';
import '../services/FinampSettingsHelper.dart';

class AddDownloadLocationScreen extends StatefulWidget {
  const AddDownloadLocationScreen({Key key}) : super(key: key);

  @override
  _AddDownloadLocationScreenState createState() =>
      _AddDownloadLocationScreenState();
}

class _AddDownloadLocationScreenState extends State<AddDownloadLocationScreen>
    with SingleTickerProviderStateMixin {
  static const List<Tab> tabs = [
    Tab(text: "CUSTOM LOCATION"),
    Tab(text: "APP DIRECTORY"),
  ];

  final customLocationFormKey = GlobalKey<FormState>();
  final appDirectoryFormKey = GlobalKey<FormState>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<DownloadLocation>(
      create: (_) => DownloadLocation(
        name: null,
        deletable: true,
        path: null,
        useHumanReadableNames: null,
      ),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Add Download Location"),
            bottom: TabBar(
              controller: _tabController,
              tabs: tabs,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              bool isValidated = false;

              // If _tabController.index is 0, we are on the custom location tab.
              // If not, we are on the app directory tab.
              if (_tabController.index == 0) {
                if (customLocationFormKey.currentState.validate()) {
                  customLocationFormKey.currentState.save();
                  // If we're saving to a custom location, we want to use human readable names.
                  // With app dir locations, we don't use human readable names.
                  context.read<DownloadLocation>().useHumanReadableNames = true;
                  isValidated = true;
                }
              } else {
                if (appDirectoryFormKey.currentState.validate()) {
                  appDirectoryFormKey.currentState.save();
                  context.read<DownloadLocation>().useHumanReadableNames =
                      false;
                  isValidated = true;
                }
              }

              // We set a variable called isValidated so that we don't have to copy this logic into each validate()
              if (isValidated) {
                FinampSettingsHelper.addDownloadLocation(
                    context.read<DownloadLocation>());
                Navigator.of(context).pop();
              }
            },
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomDownloadLocationForm(
                    formKey: customLocationFormKey,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppDirectoryLocationForm(formKey: appDirectoryFormKey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
