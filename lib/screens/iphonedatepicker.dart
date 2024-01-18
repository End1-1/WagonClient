import 'package:flutter/cupertino.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/app/model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class IPhoneDatePicker {
  static Future<void> setOrderTime(BuildContext context, Screen2Model model) async {
    await DatePicker.showDateTimePicker(context,
        locale: LocaleType.ru,
        //currentTime: _orderDateTime.isBefore(DateTime.now()) ? DateTime.now() : _orderDateTime.add(Duration(minutes: 1)),
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 3)),
        onConfirm: (dt) {
            model.appState.orderDateTime = dt;
            if (model.appState.orderDateTime.isBefore(DateTime.now())) {
              model.appState.orderDateTime = DateTime.now();
            }
        });
    // _pageBeforeChat =model.currentPage;
    // setState((){
    //  model.currentPage = pageDatepicker;
    // });
  }
}