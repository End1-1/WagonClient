import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/main_window_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screens/payment/bankwebview.dart';
import 'package:wagon_client/web/web_parent.dart';

import 'card_info.dart';

class PaymentWidget extends StatefulWidget {
  late final MainWindowModel model;
  Function stateCallback;

  PaymentWidget(this.model, this.stateCallback);

  @override
  State<StatefulWidget> createState() => _PaymentWidget();
}

class _PaymentWidget extends State<PaymentWidget> {
  var cashChecked = true;
  var companyChecked = false;
  var addingCard = false;
  var errorStr = '';
  var loadingCards = false;
  final List<CardInfo> cards = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        height: MediaQuery.sizeOf(context).height * Consts.sizeofPaymentWidget,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
        Container(height: 50, decoration: const BoxDecoration(color: Colors.black12), child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Container()),
              Text(tr(trPaymentMethods).toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Container()),
            ])),
            Container(
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffcccccc), Colors.white]))),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'images/cash.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(tr(trCash)),
                Expanded(child: Container()),
                Transform.scale( scale: 2, child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Consts.colorOrange,
                  shape: CircleBorder(),
                  value: cashChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      final List<CardInfo> tempCards = [];
                      for (final oldCard in cards) {
                        tempCards.add(oldCard.copyWith(selected: false));
                        }
                            cards.clear();
                        cards.addAll(tempCards);
                      cashChecked = true;
                      companyChecked = false;
                    });
                  },
                ))
              ],
            ),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'images/cash.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(tr(trPayByCompany)),
                Expanded(child: Container()),
                Transform.scale( scale: 2, child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Consts.colorOrange,
                  shape: CircleBorder(),
                  value: companyChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      final List<CardInfo> tempCards = [];
                      for (final oldCard in cards) {
                        tempCards.add(oldCard.copyWith(selected: false));
                      }
                      cards.clear();
                      cards.addAll(tempCards);
                      companyChecked = true;
                      cashChecked = false;
                    });
                  },
                ))
              ],
            ),
            Divider(),
            InkWell(onTap:(){
              setState(() {
                loadingCards = true;
              });
              cards.clear();
              WebParent("/app/mobile/transactions/cards", HttpMethod.GET).request((s){
                print(s);
                s = '[{"name":"Card holdername","number":"480306****454680"},{"name":"Card holdername","number":"500306****454680"}]';
                List<dynamic> cardsJson = jsonDecode(s);
                for (final c in cardsJson) {
                  cards.add(CardInfo.fromJson(c));
                }
                setState(() {
                  loadingCards = false;
                  Consts.sizeofPaymentWidget = Consts.defaultSizeofPaymentWidget + (cards.length * 0.1);
                  widget.stateCallback();
                });
              }, (c, s) {
                print(s);
                s = '[{"name":"Card holdername","number":"480306****454680"},{"name":"Card holdername","number":"500306****454680"}]';
                List<dynamic> cardsJson = jsonDecode(s);
                for (final c in cardsJson) {
                  cards.add(CardInfo.fromJson(c));
                }
                setState(() {
                  loadingCards = false;
                  Consts.sizeofPaymentWidget = Consts.defaultSizeofPaymentWidget + (cards.length * 0.1);
                  widget.stateCallback();
                });
              });
            }, child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'images/wallet.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(tr(trBankCard)),
                Expanded(child: Container()),
                if (cards.length == 0)
                  Image.asset('images/arrowcircleright.png', height: 40,)
              ],
            )),
            for (final c in cards) ...[
              Row(children: [
                const SizedBox(width: 30),
                Image.asset('images/wallet.png', height: 30, width: 30,),
                const SizedBox(width: 10,),
                Text(c.number, style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                Transform.scale( scale: 2, child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Consts.colorOrange,
                  shape: CircleBorder(),
                  value: c.selected ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      final List<CardInfo> tempCards = [];
                      for (final oldCard in cards) {
                        tempCards.add(oldCard == c ? c.copyWith(selected: value ?? false) : oldCard.copyWith(selected: false));
                      }
                      cards.clear();
                      cards.addAll(tempCards);
                      cashChecked = false;
                      companyChecked = false;
                    });
                  },
                ))
              ],)
            ],
            Divider(),
            Row(
              children: [
                Expanded(child: Container()),
                if (loadingCards)
                  const SizedBox(child: CircularProgressIndicator(), height: 30, width: 30,),
                Expanded(child: Container()),
              ],
            ),
            Divider(),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Платить картой пиздец как удобно, Вам не нужно каждый раз доставать кошелек и ждать сдачи, которых у таксиста может и не быть.'),
            Expanded(child: Container()),
            if (addingCard)
              SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator())
            else
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.sizeOf(context).width * 0.9, 50),
                      backgroundColor: Consts.colorOrange,
                      textStyle: TextStyle(color: Colors.black)),
                  onPressed: () {
                    setState(() {
                      errorStr = '';
                      addingCard = true;
                    });
                    final wp = WebParent(
                        '/app/mobile/transactions/make-binding-payment',
                        HttpMethod.GET);
                    wp.request((s) {
                      setState(() {
                        errorStr = '';
                        addingCard = false;
                      });
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => BankWebView(s['url'])))
                          .then((value) {
                            if (value != null) {
                              if (value) {
                                FToast().showToast(child: Text('КАРТА ДОБАВЛЕНА, УРА!'), gravity: ToastGravity.CENTER);
                              }
                            }
                      });
                    }, (c, s) {
                      setState(() {
                        addingCard = false;
                        errorStr = s;
                      });
                    });
                  },
                  child: Text(tr(trAddCard).toUpperCase())),
            const SizedBox(height: 10),
            if (!addingCard)
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.sizeOf(context).width * 0.9, 50),
                      backgroundColor: Consts.colorWhite,
                      textStyle: TextStyle(color: Colors.black)),
                  onPressed: () {
                    widget.model.showWallet = false;
                    cards.clear();
                    Consts.sizeofPaymentWidget = Consts.defaultSizeofPaymentWidget;
                    widget.stateCallback();
                  },
                  child: Text(tr(trReady).toUpperCase())),
            if (errorStr.isNotEmpty) Text(errorStr),
            const SizedBox(height: 50),
          ],
        ));
  }
}

class PaymentFullWindow extends StatelessWidget {
  final MainWindowModel model;

  PaymentFullWindow(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea( child:  PaymentWidget(model, (){
      Navigator.pop(context);
    })));
  }

}
