import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/main_window_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screens/payment/bankwebview.dart';
import 'package:wagon_client/web/web_parent.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        height: MediaQuery.sizeOf(context).height * 0.5,
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
                      companyChecked = true;
                      cashChecked = false;
                    });
                  },
                ))
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
                        print('FINITA LA WEBVIEW');
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
