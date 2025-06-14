

import 'dart:convert';

import 'package:eClassify/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;


  late Map<String, String> _localizedValues;

  AppLocalization(this.locale);


  static AppLocalization? of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }


  Future loadJson() async {
    String languageCode = 'ar'; // Default to Arabic
    
    // Get stored language or default to Arabic
    if (HiveUtils.getLanguage() != null &&
        HiveUtils.getLanguage()['code'] != null) {
      String storedCode = HiveUtils.getLanguage()['code'];
      // Only allow Arabic and English
      if (storedCode == 'ar' || storedCode == 'en') {
        languageCode = storedCode;
      }
    }
    
    String jsonStringValues;
    Map<String, dynamic> mappedJson = {};

    if (HiveUtils.getLanguage() == null ||
        HiveUtils.getLanguage()['data'] == null) {
      // Load from appropriate language file
      jsonStringValues = await rootBundle.loadString('assets/languages/$languageCode.json');
      mappedJson = json.decode(jsonStringValues);
    } else {
      mappedJson = Map<String, dynamic>.from(HiveUtils.getLanguage()['data']);
    }
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslatedValues(String? key) {
    return _localizedValues[key!];
  }


  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}


class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();


  @override
  bool isSupported(Locale locale) {
    // Only support Arabic and English
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.loadJson();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return true;
  }
}
