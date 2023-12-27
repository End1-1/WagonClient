import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screens/app/screen.dart';

class ChangeLanguageScreen extends AppScreen {
  ChangeLanguageScreen(super.title);

  @override
  List<Widget> body() {
    return [_LanguangeBody()];
  }
}

class _LanguangeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageBodyState();
}

class _LanguageBodyState extends State<_LanguangeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Հայերեն'),
            Expanded(child: Container()),
            Checkbox(
                value: currentLanguage() == 'ՀԱՅ',
                onChanged: (v) {
                  if (v ?? false) {
                    Consts.setString('lang', 'ՀԱՅ');
                  }
                  setState(() {});
                })
          ],
        ),
        Row(
          children: [
            Text('Русский'),
            Expanded(child: Container()),
            Checkbox(value: currentLanguage() == 'РУС', onChanged: (v) {
              if (v ?? false) {
                Consts.setString('lang', 'РУС');
              }
              setState(() {});
            })
          ],
        ),
        Row(
          children: [
            Text('English'),
            Expanded(child: Container()),
            Checkbox(value: currentLanguage() == 'ENG', onChanged: (v) {
              if (v ?? false) {
                Consts.setString('lang', 'ENG');
              }
              setState(() {});
            })
          ],
        ),
      ],
    );
  }
}
