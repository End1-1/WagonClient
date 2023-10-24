import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/main_window_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/outlined_yellowbutton.dart';
import 'package:wagon_client/screens/payment/bankwebview.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/web_parent.dart';

import 'card_info.dart';
import 'company_info.dart';

class PaymentWidget extends StatefulWidget {
  late final MainWindowModel model;
  Function stateCallback;
  bool widgetMode;

  PaymentWidget(this.model, this.stateCallback, this.widgetMode);

  @override
  State<StatefulWidget> createState() => _PaymentWidget();
}

class _PaymentWidget extends State<PaymentWidget> {
  var addingCard = false;
  var errorStr = '';
  var loadingCards = false;
  var openCompany = false;
  var closing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        height: widget.widgetMode
            ? MediaQuery.sizeOf(context).height * Consts.sizeofPaymentWidget
            : double.infinity,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            if (widget.widgetMode)
              Container(
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.black12),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Container()),
                        Text(tr(trPaymentMethods).toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Container()),
                      ]))
            else
              Row(children: [
                IconButton(
                    icon: Image.asset(
                      "images/back.png",
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text(tr(trPaymentMethods).toUpperCase())
              ]),
            Container(
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffcccccc), Colors.white]))),

            Expanded(
                child: Container(
                    child: SingleChildScrollView(
                        child: Column(children: [
              //CASH METHOD
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
                    'images/wallet.png',
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(tr(trCash)),
                  Expanded(child: Container()),
                  Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        checkColor: Colors.black,
                        activeColor: Consts.colorOrange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        value: widget.model.paymentTypeId == 1,
                        onChanged: (bool? value) {
                          widget.model.paymentTypeId = 1;
                          widget.model.paymentCardId = '';
                          widget.model.paymentCompanyId = 0;
                          setState(() {
                            uncheckCompanies();
                            uncheckCards();
                          });
                        },
                      ))
                ],
              ),
              Divider(),

              //BONUSI MOMENT
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
                    'images/wallet.png',
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('${tr(trBonus)} ${widget.model.cashbackInfo.balance}'),
                  Expanded(child: Container()),
                  SizedBox(width: 150, height: 40, child: TextFormField(
                    onChanged: (s) {
                      double balance = double.tryParse(widget.model.cashbackInfo.balance) ?? 0;
                      double input = double.tryParse(s) ?? 0;
                      if (input > balance) {
                        widget.model.cashbackController.text = widget.model.cashbackInfo.balance;
                      }
                    },
                    controller: widget.model.cashbackController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(

                      )
                    ),
                  )),
                ],
              ),
              Divider(),

              //COMPANY MODE
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'images/business.png',
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(tr(trPayByCompany)),
                  Expanded(child: Container()),

                  //COMPANY OPTIONS
                  InkWell(
                    onTap: () {
                      setState(() {
                        openCompany = !openCompany;
                      });
                    },
                    child: openCompany
                        ? Image.asset(
                            'images/uparrowc.png',
                            height: 40,
                          )
                        : Image.asset(
                            'images/downarrowc.png',
                            height: 40,
                          ),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),

              //COMPANY LIST
              if (openCompany)
                for (final co in widget.model.companies) ...[
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      Image.asset(
                        'images/card.png',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(co.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Container()),
                      Transform.scale(
                          scale: 1.5,
                          child: widget.widgetMode
                              ? Checkbox(
                                  checkColor: Colors.black,
                                  activeColor: Consts.colorOrange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  value: co.checked ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      final List<CompanyInfo> tempCards = [];
                                      for (final oldCard
                                          in widget.model.companies) {
                                        tempCards.add(oldCard == co
                                            ? co.copyWith(
                                                checked: value ?? false)
                                            : oldCard.copyWith(checked: false));
                                      }
                                      widget.model.paymentTypeId = 2;
                                      widget.model.paymentCompanyId = co.id;
                                      widget.model.companies.clear();
                                      widget.model.companies.addAll(tempCards);
                                      uncheckCards();
                                    });
                                  },
                                )
                              : Container())
                    ],
                  ),
                ],

              //CARD
              Divider(),
              InkWell(
                  onTap: () {
                    setState(() {
                      loadingCards = !loadingCards;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'images/card.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(tr(trBankCard)),
                      Expanded(child: Container()),
                      if (loadingCards)
                        Image.asset(
                          'images/uparrowc.png',
                          height: 40,
                        )
                      else
                        Image.asset(
                          'images/downarrowc.png',
                          height: 40,
                        ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  )),
              if (loadingCards)
                for (final c in widget.model.paymentCards) ...[
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      Image.asset(
                        'images/card.png',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(c.number,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Container()),
                      Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            checkColor: Colors.black,
                            activeColor: Consts.colorOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            value: c.selected == 1,
                            onChanged: (bool? value) {
                              setState(() {
                                final List<CardInfo> tempCards = [];
                                for (final oldCard
                                    in widget.model.paymentCards) {
                                  tempCards.add(oldCard == c
                                      ? c.copyWith(
                                          selected: value ?? false ? 1 : 0)
                                      : oldCard.copyWith(selected: 0));
                                }
                                widget.model.paymentTypeId = 3;
                                widget.model.paymentCardId = c.id;
                                widget.model.paymentCards.clear();
                                widget.model.paymentCards.addAll(tempCards);
                                uncheckCompanies();
                              });
                            },
                          ))
                    ],
                  ),
                  Row(children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 5, left: 30),
                            child: Divider()))
                  ]),
                ],
            ])))),

            const SizedBox(
              height: 10,
            ),
            if (closing)
              Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              child: CircularProgressIndicator())))
                ],
              ),
            if (!closing)
              Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Text(
                          'Платить картой пиздец как удобно, Вам не нужно каждый раз доставать кошелек и ждать сдачи, которых у таксиста может и не быть.',
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        )))
              ]),
            // Expanded(child: Container()),
            if (addingCard)
              SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator())
            else
              Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            right: 60, left: 60, bottom: 30),
                        child: OutlinedYellowButton.createButtonText(() {
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
                                    builder: (builder) =>
                                        BankWebView(s['url']))).then((value) {
                              if (value != null) {
                                if (value) {
                                  FToast().showToast(
                                      child: Text('КАРТА ДОБАВЛЕНА, УРА!'),
                                      gravity: ToastGravity.CENTER);
                                }
                              }
                            });
                          }, (c, s) {
                            setState(() {
                              addingCard = false;
                              errorStr = s;
                            });
                          });
                        }, tr(trAddCard).toUpperCase(),
                            ts: const TextStyle(color: Colors.white))))
              ]),

            const SizedBox(height: 10),
            if (!addingCard)
              Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                          right: 60,
                          left: 60,
                        ),
                        child: OutlinedYellowButton.createButtonText(() async {
                          setState(() {
                            closing = true;
                          });
                          if (widget.widgetMode) {
                            _onlyClose();
                          } else {
                            for (final card in widget.model.paymentCards) {
                              await WebParent(
                                      '/app/mobile/transactions/select-default-card/${card.id}/0',
                                      HttpMethod.GET)
                                  .request((d) {}, (c, s) {
                                closing = false;
                              });
                            }
                            WebParent(
                                    '/app/mobile/select-payment-type/${widget.model.paymentTypeId}',
                                    HttpMethod.GET)
                                .request((d) {
                              if (widget.model.paymentTypeId == 3) {
                                WebParent(
                                        '/app/mobile/transactions/select-default-card/${widget.model.paymentCardId}/1',
                                        HttpMethod.GET)
                                    .request((d) {
                                  _closeWidget();
                                }, (c, s) {
                                  closing = false;
                                });
                                return;
                              } else {
                                _closeWidget();
                              }
                            }, (c, s) {
                              closing = false;
                            });
                          }
                        }, tr(trReady).toUpperCase(),
                            ts: const TextStyle(color: Colors.white),
                            bgColor: Consts.colorRed)))
              ]),

            if (errorStr.isNotEmpty) Text(errorStr),
            const SizedBox(height: 50),
          ],
        ));
  }

  _onlyClose() {
    widget.model.showWallet = false;
    widget.model.dimvisible = false;
    Consts.sizeofPaymentWidget = Consts.defaultSizeofPaymentWidget;
    widget.stateCallback();
  }

  _closeWidget() {
    widget.model.using_cashback_balance = double.tryParse(widget.model.cashbackController.text) ?? 0;
    widget.model.using_cashback = widget.model.using_cashback_balance > 0.1 ? 1 : 0;
    WebInitOpen webInitOpen = WebInitOpen(
        latitude: Consts.getDouble('last_lat'),
        longitude: Consts.getDouble('last_lon'));
    webInitOpen.request((mp) {
      widget.model.parseInitOpenData(mp);
      _onlyClose();
    }, (c, s) {
      closing = false;
    });
  }

  void uncheckCompanies() {
    final List<CompanyInfo> tempCards = [];
    for (final co in widget.model.companies) {
      tempCards.add(co.copyWith(checked: false));
    }
    widget.model.companies.clear();
    widget.model.companies.addAll(tempCards);
  }

  void uncheckCards() {
    final List<CardInfo> tempCards = [];
    for (final oldCard in widget.model.paymentCards) {
      tempCards.add(oldCard.copyWith(selected: 0));
    }
    widget.model.paymentCards.clear();
    widget.model.paymentCards.addAll(tempCards);
  }
}

class PaymentFullWindow extends StatelessWidget {
  final MainWindowModel model;

  PaymentFullWindow(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: PaymentWidget(model, () {
      Navigator.pop(context);
    }, false)));
  }
}
