import 'package:flutter/cupertino.dart';
import 'package:wagon_client/screens/payment/card_info.dart';
import 'package:wagon_client/screens/payment/cashback_info.dart';
import 'package:wagon_client/screens/payment/company_info.dart';
import 'package:wagon_client/web/web_realstate.dart';

class AppState {
  final commentFrom = TextEditingController();
  final addressFrom = TextEditingController();
  final addressTo = TextEditingController();
  final feedbackText = TextEditingController();

  var showFullAddressWidget = false;

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

  void getState() {
    WebRealState webRealState = WebRealState();
    webRealState.request((Map<String, dynamic> mp) {
    //   model.currentState = mp["status"];
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
  }, (c, s){});}

  CompanyInfo getSelectedCompanyInfo() {
    for (final e in companies) {
      if (e.checked ?? false) {
        return e;
      }
    }
    return CompanyInfo(id: 0, name: '', car_classes: [], checked: false);
  }
}