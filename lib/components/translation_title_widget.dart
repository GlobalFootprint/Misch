import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drop_down_widget.dart';

class TranslationTitleWidget extends StatelessWidget{
  final String language1;
  final String language2;
  final ValueChanged<String?> onChangedLanguage1;
  final ValueChanged<String?> onChangedLanguage2;

  const TranslationTitleWidget({
    super.key,
    required this.language1,
    required this.language2,
    required this.onChangedLanguage1,
    required this.onChangedLanguage2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropDownWidget(
          value: language1,
          onChangedLanguage: onChangedLanguage1,
        ),
        Icon(Icons.keyboard_arrow_right),
        SizedBox(width: 12,),
        Icon(Icons.translate, color: Colors.black87,),
        SizedBox(width: 12,),
        Icon(Icons.keyboard_arrow_right),
        SizedBox(width: 12,),
        DropDownWidget(
          value: language2,
          onChangedLanguage: onChangedLanguage2,
        ),
      ],
    );
  }
}