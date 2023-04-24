import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locale_names/locale_names.dart';

import '../../services/finamp_settings_helper.dart';
import '../../services/locale_helper.dart';

class LanguageList extends StatefulWidget {
  const LanguageList({super.key});

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  // yeah I'm a computer science student how could you tell
  // (sorts locales without having to copy them into a list first)
  final locales = SplayTreeMap<String, Locale>.fromIterable(
    AppLocalizations.supportedLocales,
    key: (element) => (element as Locale).defaultDisplayLanguage,
    value: (element) => element,
  );

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // We have a ValueListenableBuilder here to rebuild all the ListTiles when
      // the language changes
      child: ValueListenableBuilder(
        valueListenable: LocaleHelper.localeListener,
        builder: (_, __, ___) {
          return CustomScrollView(
            slivers: [
              const SliverList(
                delegate: SliverChildListDelegate.fixed([
                  LanguageListTile(),
                  Divider(),
                ]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final locale = locales.values.elementAt(index);

                    return LanguageListTile(locale: locale);
                  },
                  childCount: locales.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class LanguageListTile extends StatelessWidget {
  const LanguageListTile({
    super.key,
    this.locale,
  });

  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<Locale?>(
      title: Text(locale?.nativeDisplayLanguage ??
          AppLocalizations.of(context)!.system),
      subtitle: locale == null ? null : Text(locale!.defaultDisplayLanguage),
      value: locale,
      groupValue: LocaleHelper.locale,
      onChanged: (_) {
        LocaleHelper.setLocale(locale);
      },
    );
  }
}
