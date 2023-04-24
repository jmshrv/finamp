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
          debugPrint(LocaleHelper.locale.toString());
          return CustomScrollView(
            slivers: [
              // For some reason, setting the null (system) LanguageListTile to
              // const stops it from switching when going to/from the same
              // language as the system language (e.g., system to English on a
              // device set to English)
              // ignore: prefer_const_constructors
              SliverList(
                // ignore: prefer_const_constructors
                delegate: SliverChildListDelegate.fixed([
                  LanguageListTile(),
                  const Divider(),
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
      subtitle: locale == null
          ? null
          : Text(LocaleHelper.locale == null
              ? locale!.defaultDisplayLanguage
              : locale!.displayLanguageIn(LocaleHelper.locale!)),
      value: locale,
      groupValue: LocaleHelper.locale,
      onChanged: (_) {
        LocaleHelper.setLocale(locale);
      },
    );
  }
}
