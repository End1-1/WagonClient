import 'package:flutter/material.dart';

class ScreenBottom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenBottom();
  
}

class _ScreenBottom extends State<ScreenBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          //Wallet button
          Container(
            child: InkWell(
              onTap:(){},
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(color: Color(0xFFF2A649))),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Image.asset('images/wallet.png', height: 30,)
              )
            )
          ),

          //Order button
          Expanded(child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: InkWell(
                  onTap:(){},
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(color: Color(0xFFF2A649))),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Image.asset('images/wallet.png', height: 30,)
                  )
              ))
          ),

          //Options button
          Container(
              child: InkWell(
                  onTap:(){},
                  child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(color: Color(0xFFF2A649))),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Image.asset('images/wallet.png', height: 30,)
                  )
              )
          )
        ],
      ),
    );
  }

}