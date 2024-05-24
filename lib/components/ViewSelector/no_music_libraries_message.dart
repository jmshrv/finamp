import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoMusicLibrariesMessage extends StatelessWidget {
  const NoMusicLibrariesMessage({
    super.key,
    this.onRefresh,
  });

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.noMusicLibrariesTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!.noMusicLibrariesBody,
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                  onPressed: onRefresh,
                  child: Text(AppLocalizations.of(context)!.refresh))
            ],
          ),
        ),
      ),
    );
  }
}
