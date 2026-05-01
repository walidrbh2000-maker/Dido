import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/core/localization/locale_provider.dart';

class AppLocalizations {
  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      MaterialLocalizations.delegate;

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('ar'),
    Locale('en'),
  ];

  static Locale localeResolution(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return const Locale('fr');
    for (final supportedLocale in supported) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return const Locale('fr');
  }

  static bool isRtl(Locale locale) => locale.languageCode == 'ar';
}

final l10nProvider = Provider<AppLocalizationsHelper>((ref) {
  return AppLocalizationsHelper();
});

class AppLocalizationsHelper {
  const AppLocalizationsHelper();

  String appName() => 'Voyageur';
}
