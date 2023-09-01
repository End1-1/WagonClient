import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: const BoxDecoration(
        color: Colors.white
      ),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Row(children: [
              InkWell(onTap: (){
                widget.model.showWallet = false;
                widget.stateCallback();
              }, child: Image.asset('images/login/back.png', height: 40,))
            ],),
            const SizedBox(height: 10,),
            Row(children: [
              Text(tr(trPaymentMethods), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/cash.png', height: 30,),
                const SizedBox(width: 10,),
                Text(tr(trCash)),
                Expanded(child: Container()),
                Checkbox(
                  value: cashChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      cashChecked = true;
                      companyChecked = false;
                    });
                  },
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/cash.png', height: 30,),
                const SizedBox(width: 10,),
                Text(tr(trPayByCompany)),
                Expanded(child: Container()),
                Checkbox(
                  value: companyChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      companyChecked = true;
                      cashChecked = false;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 10,),
            Text('Платить картой пиздец как удобно, Вам не нужно каждый раз доставать кошелек и ждать сдачи, которых у таксиста может и не быть.'),
            Expanded(child: Container()),
            if (addingCard)
              SizedBox(height: 30, width: 30, child: CircularProgressIndicator())
              else

                OutlinedButton(onPressed: () {
                  setState(() {
                    errorStr = '';
                    addingCard = true;
                  });
                  final wp = WebParent('/app/mobile/transactions/make-binding-payment', HttpMethod.GET);
                  wp.request((s){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => BankWebView()))
                        .then((value) {
                      print('FINITA LA WEBVIEW');
                    });
                  }, (c, s){
                    setState(() {
                      addingCard = false;
                      errorStr = s;
                    });
                  });

                }, child: Text(tr(trAddCard).toUpperCase())),
            if (errorStr.isNotEmpty)
              Text(errorStr),
            const SizedBox(height: 50),
          ],
        ));
  }
}
