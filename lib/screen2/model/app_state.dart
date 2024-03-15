import 'package:flutter/cupertino.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screens/payment/card_info.dart';
import 'package:wagon_client/screens/payment/cashback_info.dart';
import 'package:wagon_client/screens/payment/company_info.dart';
import 'package:wagon_client/web/web_realstate.dart';

import 'model.dart';

class AppState {
  final Screen2Model model;

  AppState(this.model);

  static const int asNone = 0;
  static const int asIdle = 1;
  static const int asSearchTaxi = 2;
  static const int asDriverAccept = 3;
  static const int asDriverOnWay = 4;
  static const int asOnPlace = 5;
  static const int asOrderStarted = 6;
  static const int asOrderEnd = 7;
  static const int asSearchOnMapFrom = 11;
  static const int asSearchOnMapTo = 12;

  final commentFrom = TextEditingController();
  final addressFrom = TextEditingController();
  final addressTo = TextEditingController();
  final addressTemp = TextEditingController();
  final feedbackText = TextEditingController();
  final driverText = TextEditingController();

  AddressStruct? structAddressFrom;
  List<AddressStruct> structAddressTod = [];
  AddressStruct? structAddressTemp;

  var showFullAddressWidget = false;
  var focusFrom = true;
  var showRideOptions = false;
  var showChangePayment = false;
  var dimVisible = true;
  var dimText = '';
  var driverName = '';
  var driverPhoto = '';
  var driverRating = 0;
  var orderPrice = 0;

  var appState = asNone;
  var mapPressed = false;

  bool isRent = false;
  int acType = 0;
  String rentTime = '';
  String order_id = '';
  List<int> rentTimes = [];
  var paymentTypeId = 1;
  var paymentCompanyId = 0;
  var paymentCardId = '';
  int using_cashback = 0;
  DateTime orderDateTime = DateTime.now();
  double using_cashback_balance = 0.0;
  final List<CompanyInfo> companies = [];
  final List<CardInfo> paymentCards = [];
  var cashbackInfo =
      CashbackInfo(client_id: 0, balance: '0', client_wallet_id: 0);

  int unreadChatMessagesCount = 0;

  int currentCar = 0;
  List<int> selectedCarOptions = [];
  List<dynamic> assassment = [];
  var assassmentOption = 0;
  var assassmentText = '';

  Future<void> getState(Function parentState) async {
    dimText = '';
    dimVisible = true;
    appState = asNone;
    parentState();
    WebRealState webRealState = WebRealState();
    await webRealState.request((Map<String, dynamic> mp) {
         appState = mp['status'];
         switch (appState) {
           case asIdle:
            dimVisible = false;
            break;
           case asSearchTaxi:
             dimText = tr(trSEARCHCAR);
             dimVisible = true;
             break;
           case asDriverAccept:
           case asDriverOnWay:
           case asOnPlace:
           case asOrderStarted:
             dimText = mp['message'];
             driverName = mp['payload']['driver']['name'];
             driverPhoto = mp['payload']['driver']['photo'];
             order_id = mp['payload']['order']['order_id'].toString();
             break;
           case asOrderEnd:
             dimText = mp['message'];
             order_id = mp['payload']['order']['order_id'].toString();
             orderPrice = int.tryParse(mp['payload']['order']['price'].toString()) ?? 0 ;
             assassment = mp['payload']['assessment'];
             break;
         }
         parentState();
      //   switch (mp["status"]) {
      //     case state_none:
      //       model.currentPage = pageSelectShortAddress;
      //       break;
      //     case state_pending_search:
      //       model.tracking = false;
      //       model.currentPage = pageSearchTaxi;
      //       break;
      //     case state_driver_accept:
      //       model.tracking = false;
      //       model.currentPage = pageDriverAccept;
      //       model.events["driver_accept"] = mp;
      //       break;
      //     case state_driver_onway:
      //       model.tracking = false;
      //       model.currentPage = pageDriverOnWayToClient;
      //       model.events["driver_accept"] = mp;
      //       break;
      //     case state_driver_onplace:
      //       model.tracking = false;
      //       model.currentPage = pageDriverOnPlace;
      //       model.events["driver_accept"] = mp;
      //       break;
      //     case state_driver_orderstarted:
      //       model.tracking = false;
      //       model.currentPage = pageOrderStarted;
      //       model.order_id = mp['payload']['order']['order_id'];
      //       model.events["driver_order_started"] = mp;
      //       break;
      //     case state_driver_orderend:
      //       model.tracking = false;
      //       model.currentPage = pageOrderEnd;
      //       model.events["driver_order_end"] = mp;
      //       break;
      //   }
      //   setState(() {});
      // }, (c, s) {
      //   if (c == 401) {
      //     Consts.setString("bearer", "");
      //     Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (context) => LoginScreen()));
      //   } else {
      //     setState(() {
      //       model.currentPage = pageRealState;
      //     });
      //     sleep(const Duration(seconds: 2));
      //     model.init = false;
      //     _restoreState();
      //   }
      // });
      // model.getChatCount();
    }, (c, s) {});
  }

  CompanyInfo getSelectedCompanyInfo() {
    for (final e in companies) {
      if (e.checked ?? false) {
        return e;
      }
    }
    return CompanyInfo(id: 0, name: '', car_classes: [], checked: false);
  }

  void copyTempAddress() {
    if (appState == asSearchOnMapFrom) {
      addressFrom.text = addressTemp.text;
      structAddressFrom = structAddressTemp;
    }
    if (appState == asSearchOnMapTo) {
      addressTo.text = addressTemp.text;
      if (structAddressTod.isEmpty) {
        structAddressTod.add(structAddressTemp!);
      } else {
        structAddressTod[0] = structAddressTemp!;
      }
    }
  }
}
