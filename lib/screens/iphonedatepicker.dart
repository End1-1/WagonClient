import 'package:flutter/cupertino.dart';
import 'package:wagon_client/main_window_model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class IPhoneDatePicker {
  static Future<void> setOrderTime(BuildContext context, MainWindowModel model) async {
    await DatePicker.showDateTimePicker(context,
        locale: LocaleType.ru,
        //currentTime: _orderDateTime.isBefore(DateTime.now()) ? DateTime.now() : _orderDateTime.add(Duration(minutes: 1)),
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 3)),
        onConfirm: (dt) {
            model.orderDateTime = dt;
            if (model.orderDateTime.isBefore(DateTime.now())) {
              model.orderDateTime = DateTime.now();
            }
        });
    // _pageBeforeChat =model.currentPage;
    // setState((){
    //  model.currentPage = pageDatepicker;
    // });
  }
}