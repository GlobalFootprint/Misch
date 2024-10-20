import 'package:flutter/material.dart';
import 'package:misch/api/translation_api.dart';
import 'package:misch/utils/translations.dart';

class TranslationWidget extends StatefulWidget {
  final String message;
  final String fromLanguage;
  final String toLanguage;
  final Widget Function(String translation) builder;

  const TranslationWidget({
    super.key,
    required this.message,
    required this.fromLanguage,
    required this.toLanguage,
    required this.builder,
  });

  @override
  State<TranslationWidget> createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  String? translation = "";

  @override
  Widget build(BuildContext context) {
    final fromLanguageCode = Translations.getLanguageCode(widget.fromLanguage);
    final toLanguageCode = Translations.getLanguageCode(widget.toLanguage);

    return FutureBuilder(
        future: TranslationApi.translate(
            widget.message,
            fromLanguageCode,
            toLanguageCode
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return translation == null ? Container() : widget.builder(translation!);
          }
          else if (snapshot.hasError) {
            translation = 'Could not translate due to Network problems';
          }
          else {
            translation = snapshot.data;
          }
          return widget.builder(translation!);
        }
    );
  }
}