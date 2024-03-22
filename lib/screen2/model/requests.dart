import 'package:wagon_client/cars.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/resources/resource_car_types.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/payment/card_info.dart';
import 'package:wagon_client/screens/payment/cashback_info.dart';
import 'package:wagon_client/screens/payment/company_info.dart';
import 'package:wagon_client/web/web_canceloptions.dart';
import 'package:wagon_client/web/web_cancelsearchtaxi.dart';
import 'package:wagon_client/web/web_initcoin.dart';
import 'package:wagon_client/web/web_initorder.dart';

class Requests {
  final Screen2Model model;


  Requests(this.model);

  void initCoin(Function? f, Function? fail) async {
    if (Consts
        .getString("bearer")
        .isEmpty) {
      Dlg.show("Empty bearer");
      return;
    }
    //TODO THERE IS PREIVIOUSLY WAS USED CAR CLASS
    if (model.appState.structAddressFrom != null) {
      WebInitCoin initCoin = WebInitCoin(
          model.appState.structAddressFrom!,
          model.appState.structAddressTod,
          model.appState.currentCar,
          model.appState.paymentTypeId,
          model.appState.paymentTypeId == 2 ? model.appState
              .getSelectedCompanyInfo()
              .id : 0,
          Consts.getString("driverComment"),
          model.appState.selectedCarOptions,
          model.appState.isRent,
          int.tryParse(model.appState.rentTime) == null ? 0 : int.parse(
              model.appState.rentTime));
      initCoin.request((CarClasses cc) async {
        if (f != null) {
          f();
        }

        final carclasses = <dynamic>[];
        for (final c in cc.car_classes) {
          carclasses.add({'class_id': c.class_id,
            'name': c.name,
            'image': '',
            'min_price': c.min_price == null ? c.coin : c.min_price
          });
        }
        model.taxiCarsStream.add(carclasses);
        await model.mapController.paintRoute();

      }, (c, s) {
        Dlg.show(s);
        if (fail != null) {
          fail(c, s);
        }
      });
    } else {
      //Dlg.show("Точка отправления не определена");
      if (fail != null) {
        fail(0, "Точка отправления не определена");
      }
    }
  }

  void parseInitOpenData(dynamic mp) {
    ResourceCarTypes.res.clear();
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Taxi', selected: true));

    //DELETE FROM HEAR
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Տաքսի', selected: true));
    ResourceCarTypes.res.add(CarTypeStruct(
        'images/car.png', 'Շարժական\r\nվուլկանացում',
        selected: true));
    ResourceCarTypes.res.add(CarTypeStruct(
        'images/car.png', 'Ավտո\r\nտեխսպասարկում',
        selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Սթափ\r\nվարորդ', selected: true));
    ResourceCarTypes.res.add(
        CarTypeStruct('images/car.png', 'Կայֆարիկ\r\nվարորդ', selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Ավտոաշտարակ', selected: true));

    var first = true;
    for (final e in mp['data']['car_classes']) {
      ResourceCarTypes.res.first!.types.add(CarSubtypeStruct(
          e['class_id'],
          'images/car2.png',
          '',
          e['name'],
          'No comment for now',
          double.tryParse(e['min_price'].toString()) ?? 0));

      first = false;
    }

    model.appState.companies.clear();
    for (final e in mp['data']['companies']) {
      CompanyInfo ci = CompanyInfo.fromJson(e);
      model.appState.companies.add(ci);
    }
    //TODO GET CAR CLASSES FROM HERE
    //model.setCarClasses(CarClasses.fromJson(mp['data']));
    model.appState.rentTimes.clear();
    for (int rt in mp["data"]["rent_times"]) {
      model.appState.rentTimes.add(rt);
    }

    model.appState.paymentCards.clear();
    for (final e in mp['data']['payment_cards']) {
      if (e['payment_type_id'] == 1) {
        if (e['selected']) {
          model.appState.paymentTypeId = 1;
        }
      } else if (e['payment_type_id'] == 3) {
        for (final ee in e['cards']) {
          if (e['selected']) {
            model.appState.paymentTypeId = 3;
            model.appState.paymentCardId = ee['id'];
          }
          CardInfo ci = CardInfo.fromJson(ee);
          model.appState.paymentCards.add(ci);
        }
      }
    }
    if (mp['data']['wallet'] == null) {
      model.appState.cashbackInfo =
          CashbackInfo(client_id: 0, balance: '0', client_wallet_id: 0);
    } else {
      model.appState.cashbackInfo =
          CashbackInfo.fromJson(mp['data']['wallet'] ?? {});
    }
  }

  void searchTaxi() {
    // setState(() {
    //   model.loadingData = true;
    // });
    initCoin((){
      WebInitOrder webInitOrder = WebInitOrder(
         model.appState.structAddressFrom!,
          model.appState.structAddressTod,
          model.appState.currentCar,
          model.appState.paymentTypeId,
          model.appState.paymentTypeId == 2 ? model.appState
              .getSelectedCompanyInfo()
              .id : 0,
          Consts.getString("driverComment"),
          model.appState.selectedCarOptions,
          model.appState.orderDateTime.add(Duration(
              minutes: model.appState.orderDateTime.difference(DateTime.now()) <
                  Duration(minutes: 60)
                  ? 15
                  : 0)),
          model.appState.commentFrom.text,
          cardId: model.appState.paymentCardId,
          using_cashback: model.appState.using_cashback,
          using_cashback_balance: model.appState.using_cashback_balance);

      webInitOrder.request((mp) {
        if (mp.containsKey("message")) {
          if (mp["message"].toString() == "Order created successful") {
            Dlg.show(tr(trYourPreorderAccept));
            // setState(() {
            //   model.currentPage = pageSelectShortAddress;
            //   model.loadingData = false;
            // });
          }
        } else {
          // setState(() {
          //   model.animateWindow(pageSearchTaxi, () {});
          //   model.loadingData = false;
          // });
        }
      }, (c, s) {
        // setState(() {
        //   model.loadingData = false;
        // });
        Dlg.show(s);
      });
    }, (c,s){});

  }


  void initOrder(Function parentState) {
    model.appState.dimText = '';
    model.appState.dimVisible = true;
    parentState();
    initCoin((){
    WebInitOrder w = WebInitOrder(
        model.appState.structAddressFrom!,
        model.appState.structAddressTod,
        model.appState.currentCar,
        model.appState.paymentTypeId,
        model.appState.paymentCompanyId,
        model.appState.driverText.text,
        model.appState.selectedCarOptions,
        model.appState.orderDateTime,
        model.appState.commentFrom.text,
        cardId: model.appState.paymentCardId,
        using_cashback: model.appState.using_cashback,
        using_cashback_balance: model.appState.using_cashback_balance);
    w.request((d){
      model.appState.getState(parentState);
    }, (c,m){
      print(c);
      print(m);
    });}, (c,s){});
  }

  void endOrder(Function parentState) {
    model.appState.dimVisible = true;
    parentState();

    WebSendCancelReason webSendAssessment = WebSendCancelReason(
        0,
        int.tryParse(model.appState.order_id),
        model.appState.assassmentOption == 0 ? null : model.appState.assassmentOption,
        model.appState.assassmentText,
        model.appState.assassmentText,
        //_assessment!.assessment, <--- i dont remember what is this fucking shit
        model.appState.feedbackText.text,
        false, // DRIVER IS FAVORITE IN FUTURE
        model.appState.driverRating);
    webSendAssessment.request((mp) {
      model.appState.assassmentText = '';
      model.appState.feedbackText.clear();
      model.appState.assassmentOption = 0;
      model.appState.getState(parentState);
        //widget.model.enableTrackingPlace();
        //model.centerMeOnMap();
    }, (c, s) {
      //Dlg.show(n, s);
    });
  }

  void cancelSearchTaxi(Function parentState) {
    model.appState.dimVisible = true;
    model.appState.dimText = '';
    parentState();
    WebCancelSearchTaxi().request((d){
      model.appState.getState(parentState);
    }, (c,s){});
  }
}