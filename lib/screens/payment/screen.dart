import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/screen2/model/app_state.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/app/model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/outlined_yellowbutton.dart';
import 'package:wagon_client/screens/payment/bankwebview.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/web_parent.dart';

import 'card_info.dart';
import 'company_info.dart';

class PaymentWidget extends StatefulWidget {
  late final Screen2Model model;
  Function parentState;
  bool widgetMode;
  double using_cashback_balance = 0;

  PaymentWidget(this.model, this.parentState, this.widgetMode) {
    using_cashback_balance = double.tryParse(model.appState.cashbackInfo.balance) ?? 0;
    using_cashback_balance =
        using_cashback_balance > 200 ? 200 : using_cashback_balance;
  }

  @override
  State<StatefulWidget> createState() => _PaymentWidget();
}

class _PaymentWidget extends State<PaymentWidget> {
  var addingCard = false;
  var errorStr = '';
  var loadingCards = false;
  var openCompany = false;
  var closing = false;
  var _using_cashback = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        height: widget.widgetMode
            ? MediaQuery.sizeOf(context).height * 0.8
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
                    'images/gift.png',
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('${tr(trBonus)}'),
                  Expanded(child: Container()),
                  Text(
                    '${Consts.doubleToString(double.tryParse(widget.model.appState.cashbackInfo.balance) ?? 0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Consts.colorRed,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(tr(trUseAmountOfBonus).replaceAll(
                      '%bonus%', '${widget.using_cashback_balance}')),
                  Expanded(child: Container()),
                  Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        checkColor: Colors.black,
                        activeColor: Consts.colorOrange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        value: _using_cashback,
                        onChanged: (bool? value) {
                          _using_cashback = value ?? false;
                          setState(() {});
                        },
                      ))
                ],
              ),
              Divider(),

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
                        value: widget.model.appState.paymentTypeId == 1,
                        onChanged: (bool? value) {
                          widget.model.appState.paymentTypeId = 1;
                          widget.model.appState.paymentCardId = '';
                          widget.model.appState.paymentCompanyId = 0;
                          setState(() {
                            uncheckCompanies();
                            uncheckCards();
                          });
                        },
                      ))
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
                for (final co in widget.model.appState.companies) ...[
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      Image.asset(
                        'images/business.png',
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
                                          in widget.model.appState.companies) {
                                        tempCards.add(oldCard == co
                                            ? co.copyWith(
                                                checked: value ?? false)
                                            : oldCard.copyWith(checked: false));
                                      }
                                      widget.model.appState.paymentTypeId = 2;
                                      widget.model.appState.paymentCompanyId = co.id;
                                      widget.model.appState.companies.clear();
                                      widget.model.appState.companies.addAll(tempCards);
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
                      ),
                    ],
                  )),
              if (loadingCards)
                for (final c in widget.model.appState.paymentCards) ...[
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
                              for (final oldCard in widget.model.appState.paymentCards) {
                                tempCards.add(oldCard == c
                                    ? c.copyWith(
                                        selected: value ?? false ? 1 : 0)
                                    : oldCard.copyWith(selected: 0));
                              }
                              widget.model.appState.paymentTypeId = 3;
                              widget.model.appState.paymentCardId = c.id;
                              widget.model.appState.paymentCards.clear();
                              widget.model.appState.paymentCards.addAll(tempCards);
                              uncheckCompanies();
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Dlg.question(context, tr(trConfirmRemoveCard)).then((value) {
                            if (value) {
                              WebParent('/app/mobile/cards/${c.id}', HttpMethod.DELE).request((d) {

                              }, (c,d) {
                                Dlg.show(d);
                              });
                            }
                          });

                        },
                        child: Image.asset(
                          'images/delete.png',
                          height: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      )
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
            // Expanded(child: Container()),
            if (addingCard)
              SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator())
            else
              Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            right: 60, left: 60, bottom: 20),
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
                            for (final card in widget.model.appState.paymentCards) {
                              await WebParent(
                                      '/app/mobile/transactions/select-default-card/${card.id}/0',
                                      HttpMethod.GET)
                                  .request((d) {}, (c, s) {
                                closing = false;
                              });
                            }
                            WebParent(
                                    '/app/mobile/select-payment-type/${widget.model.appState.paymentTypeId}',
                                    HttpMethod.GET)
                                .request((d) {
                              if (widget.model.appState.paymentTypeId == 3) {
                                WebParent(
                                        '/app/mobile/transactions/select-default-card/${widget.model.appState.paymentCardId}/1',
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
    if (widget.model.appState.appState > AppState.asIdle) {
      final w = WebParent(
          '/app/mobile/change-current-order-payment-type/${widget.model.appState.order_id}',
          HttpMethod.POST);
      w.body = utf8.encode(jsonEncode({
        "payment_type": widget.model.appState.paymentTypeId,
        //"card_id": widget.model.paymentCardId
      }));
      w.request((d) {
        print(d);
      }, (c, e) {
        Dlg.show(e);
      });
    }
    // widget.model.showWallet = false;
    // widget.model.dimvisible = false;
    Consts.sizeofPaymentWidget = Consts.defaultSizeofPaymentWidget;
    widget.model.appState.using_cashback_balance =
        _using_cashback ? widget.using_cashback_balance : 0;
    widget.model.appState.using_cashback = _using_cashback ? 1 : 0;
    widget.model.appState.showChangePayment = false;
    widget.parentState();
  }

  _closeWidget() {
    WebInitOpen webInitOpen = WebInitOpen(
        latitude: Consts.getDouble('last_lat'),
        longitude: Consts.getDouble('last_lon'));
    webInitOpen.request((mp) {
      widget.model.requests.parseInitOpenData(mp);
      _onlyClose();
    }, (c, s) {
      closing = false;
    });
  }

  void uncheckCompanies() {
    final List<CompanyInfo> tempCards = [];
    for (final co in widget.model.appState.companies) {
      tempCards.add(co.copyWith(checked: false));
    }
    widget.model.appState.companies.clear();
    widget.model.appState.companies.addAll(tempCards);
  }

  void uncheckCards() {
    final List<CardInfo> tempCards = [];
    for (final oldCard in widget.model.appState.paymentCards) {
      tempCards.add(oldCard.copyWith(selected: 0));
    }
    widget.model.appState.paymentCards.clear();
    widget.model.appState.paymentCards.addAll(tempCards);
  }
}

class PaymentFullWindow extends StatelessWidget {
  final Screen2Model model;

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
