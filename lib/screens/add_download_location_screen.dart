import 'dart:io';

import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../components/AddDownloadLocationScreen/app_directory_location_form.dart';
import '../components/AddDownloadLocationScreen/custom_download_location_form.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

class AddDownloadLocationScreen extends StatefulWidget {
  const AddDownloadLocationScreen({super.key});

  static const routeName = "/settings/downloadlocations/add";

  @override
  State<AddDownloadLocationScreen> createState() => _AddDownloadLocationScreenState();
}

class _AddDownloadLocationScreenState extends State<AddDownloadLocationScreen> with SingleTickerProviderStateMixin {
  final customLocationFormKey = GlobalKey<FormState>();
  final appDirectoryFormKey = GlobalKey<FormState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Since we can't initialise tabs before initState we need to awkwardly
    // provide the length directly
    _tabController = TabController(vsync: this, length: Platform.isAndroid ? 2 : 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = Platform.isAndroid
        ? [
            Tab(text: AppLocalizations.of(context)!.customLocation.toUpperCase()),
            Tab(text: AppLocalizations.of(context)!.appDirectory.toUpperCase()),
          ]
        : [Tab(text: AppLocalizations.of(context)!.customLocation.toUpperCase())];
    return Provider<NewDownloadLocation>(
      create: (_) => NewDownloadLocation(name: null, baseDirectory: DownloadLocationType.none),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.addDownloadLocation),
            bottom: TabBar(controller: _tabController, tabs: tabs),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () async {
              bool isValidated = false;

              // If _tabController.index is 0, we are on the custom location tab.
              // If not, we are on the app directory tab.
              if (_tabController.index == 0) {
                if (customLocationFormKey.currentState?.validate() ?? false) {
                  customLocationFormKey.currentState!.save();
                  // If we're saving to a custom location, we want to use human readable names.
                  // With app dir locations, we don't use human readable names.
                  context.read<NewDownloadLocation>().baseDirectory = DownloadLocationType.custom;
                  isValidated = true;
                }
              } else {
                if (appDirectoryFormKey.currentState?.validate() ?? false) {
                  appDirectoryFormKey.currentState!.save();
                  context.read<NewDownloadLocation>().baseDirectory = DownloadLocationType.external;
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
                final downloadLocation = await DownloadLocation.create(
                  name: newDownloadLocation.name!,
                  relativePath: newDownloadLocation.path!,
                  baseDirectory: newDownloadLocation.baseDirectory,
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
                  child: CustomDownloadLocationForm(formKey: customLocationFormKey),
                ),
              ),
              if (Platform.isAndroid)
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
