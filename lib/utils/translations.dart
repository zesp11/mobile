import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/services.dart';

// TODO: those files should be inside json
class Messages extends Translations {
  final Map<String, Map<String, String>> _translations;

  Messages(this._translations);

  @override
  Map<String, Map<String, String>> get keys => _translations;

  static Future<Messages> loadTranslations() async {
    final enData = await rootBundle.loadString('lib/assets/lang/en.json');
    final plData = await rootBundle.loadString('lib/assets/lang/pl.json');

    return Messages({
      'en': Map<String, String>.from(json.decode(enData)),
      'pl': Map<String, String>.from(json.decode(plData)),
    });
  }
}
