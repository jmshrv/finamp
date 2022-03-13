import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/AddDownloadLocationScreen/CustomDownloadLocationForm.dart';
import '../components/AddDownloadLocationScreen/AppDirectoryLocationForm.dart';
import '../models/FinampModels.dart';
import '../services/FinampSettingsHelper.dart';

class AddDownloadLocationScreen extends StatefulWidget {
  const AddDownloadLocationScreen({Key? key}) : super(key: key);

  @override
  _AddDownloadLocationScreenState createState() =>
      _AddDownloadLocationScreenState();
}

class _AddDownloadLocationScreenState extends State<AddDownloadLocationScreen>
    with SingleTickerProviderStateMixin {
  final tabs = Platform.isAndroid
      ? [
          const Tab(text: "CUSTOM LOCATION"),
          const Tab(text: "APP DIRECTORY"),
        ]
      : [
          const Tab(text: "CUSTOM LOCATION"),
        ];

  final customLocationFormKey = GlobalKey<FormState>();
  final appDirectoryFormKey = GlobalKey<FormState>();

  late TabController _tabController;

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
    return Provider<NewDownloadLocation>(
      create: (_) => NewDownloadLocation(
        name: null,
        deletable: true,
        path: null,
        useHumanReadableNames: null,
      ),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Download Location"),
            bottom: TabBar(
              controller: _tabController,
              tabs: tabs,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () {
              bool isValidated = false;

              // If _tabController.index is 0, we are on the custom location tab.
              // If not, we are on the app directory tab.
              if (_tabController.index == 0) {
                if (customLocationFormKey.currentState?.validate() == true) {
                  customLocationFormKey.currentState!.save();
                  // If we're saving to a custom location, we want to use human readable names.
                  // With app dir locations, we don't use human readable names.
                  context.read<NewDownloadLocation>().useHumanReadableNames =
                      true;
                  isValidated = true;
                }
              } else {
                if (appDirectoryFormKey.currentState?.validate() == true) {
                  appDirectoryFormKey.currentState!.save();
                  context.read<NewDownloadLocation>().useHumanReadableNames =
                      false;
                  isValidated = true;
                }
              }

              // We set a variable called isValidated so that we don't have to copy this logic into each validate()
              if (isValidated) {
                final newDownloadLocation = context.read<NewDownloadLocation>();

                // We don't use DownloadLocation when initially getting the
                // values because DownloadLocation doesn't have nullable values.
                // At this point, the NewDownloadLocation shouldn't have any
                // null values.
                final downloadLocation = DownloadLocation.create(
                  name: newDownloadLocation.name!,
                  path: newDownloadLocation.path!,
                  useHumanReadableNames:
                      newDownloadLocation.useHumanReadableNames!,
                  deletable: newDownloadLocation.deletable,
                );

                FinampSettingsHelper.addDownloadLocation(downloadLocation);
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
              if (Platform.isAndroid)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        AppDirectoryLocationForm(formKey: appDirectoryFormKey),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
