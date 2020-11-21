import 'package:farmersapp/Components/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class Languagelist {
  static final langs = {
    'English': 'en',
    'French': 'fr',
    'Hindi': 'hi',
    'Malayalam': 'ml',
    'Tamil': 'ta',
    'Telugu': 'te',
  };
}

class TranslateText {
  Future<String> translate(
    BuildContext context,
    String text,
  ) async {
    String lang = Provider.of<Data>(context).currentLanguage;
    var translatedText = await text.translate(to: lang);
    return translatedText.toString();
  }
}
