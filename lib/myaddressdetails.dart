import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'consts.dart';
import 'dlg.dart';
import 'model/tr.dart';
import 'screens/myaddresses_select/myaddress_select.dart';
import 'web/web_myaddresses.dart';

class MyAddressDetails extends StatefulWidget {

  late Map<String, dynamic> _address;

  MyAddressDetails(Map<String, dynamic> a) {
    _address = a;
  }

  @override
  State<StatefulWidget> createState() {
    return MyAddressDetailsState(_address);
  }
}

class MyAddressDetailsState extends State<MyAddressDetails> {

  late Map<String, dynamic> _address;
  TextEditingController _controllerCity = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerName = TextEditingController();

  MyAddressDetailsState(Map<String, dynamic> a) {
    _address = a;
    _controllerName.text = _address["name"];
    _controllerAddress.text = _address["address"];
    _controllerCity.text = _address["short_address"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView (
          child: Column (
          children: [
            Row(
                children: [
                  IconButton(
                      icon: Image.asset("images/back.png", height: 20, width: 20,),
                      onPressed: (){
                        Navigator.pop(context);
                      }),

                  Expanded(
                      child: Text("${tr(trMyAddresses)} / ${[_address["name"] == null ? tr(trNew) : _address["name"]]}", textAlign: TextAlign.left, style: Consts.textStyle6)
                  ),
                  GestureDetector(
                    onTap: _removeAddress,
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Text("Удалить", style: Consts.textStyle6)
                    )
                  )
            ]),
            Container(
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffcccccc), Colors.white]
                    )
                )
            ),
            Divider(height: 30, color: Colors.transparent,),
            Image.asset("images/logo_nyt.png",height: 50,),
            Divider(height: 30, color: Colors.transparent),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(_controllerName.text, style: Consts.textStyle8,)
              )
            ),
            Divider(height: 30, color: Colors.transparent),
            Visibility(
              visible: _isNameVisible(),
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField (
                  controller: _controllerName,
                  decoration: InputDecoration (
                      prefixIcon: Image.asset("images/placeholderlight.png", cacheWidth: 25, cacheHeight: 25,),
                      hintText: tr(trName),
                      border: OutlineInputBorder (

                      )
                  ),
                )
              )
            ),
            Divider(height: 30, color: Colors.transparent),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextField (
                controller: _controllerCity,
                readOnly: true,
                decoration: InputDecoration (
                  prefixIcon: Image.asset("images/placeholderlight.png", cacheWidth: 25, cacheHeight: 25,),
                  hintText: tr(trCity),
                  border: OutlineInputBorder (

                  )
                ),
              )
            ),
            Divider(height: 30, color: Colors.transparent),
            Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextFormField (
                  controller: _controllerAddress,
                  readOnly: true,
                  onTap: _selectAddress,
                  decoration: InputDecoration (
                      prefixIcon: Image.asset("images/placeholderlight.png",  cacheWidth: 25, cacheHeight: 25,),
                      hintText: tr(trAddress),
                      border: OutlineInputBorder (

                      )
                  ),
                )
            ),
            Divider(height: 30, color: Colors.transparent),
            Row (
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: GestureDetector(
                        onTap: _saveAddress,
                        child: Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(tr(trSave), style: Consts.textStyle9, textAlign: TextAlign.center,)
                          )
                        )
                    )
                  )
                )
            ])
          ])
        )
      )
    );
  }

  void _selectAddress() async {
    var result = await Navigator.push(context,  MaterialPageRoute(builder: (context) => MyAddressSelect(_address["name"])));
    if (result != null) {
      _address["short_address"] = result["short_address"];
      _address["address"] = result["address"];
      if (!_address.containsKey("cords")) {
        _address["cords"] = Map<String, double>();
      }
      _address["cords"]["lat"] = result["cords"]["lat"];
      _address["cords"]["lut"] = result["cords"]["lut"];
      setState(() {
        _controllerAddress.text = _address["address"];
        _controllerCity.text = _address["short_address"];
      });
    }
  }

  void _saveAddress() {
    if (_address["address_id"] == null || _address["address_id"] == 0) {
      _address["address_id"] = 0;
      WebMyAddresses.create(_controllerName.text,  _controllerCity.text, _controllerAddress.text, _address["cords"]["lat"], _address["cords"]["lut"], (d) {
        Navigator.pop(context);
      }, null);
    } else {
      WebMyAddresses.edit(_address["address_id"], _controllerName.text,  _controllerCity.text, _controllerAddress.text, _address["cords"]["lat"], _address["cords"]["lut"], (d) {
        Navigator.pop(context);
      }, null);
    }
  }

  bool _isNameVisible() {
    return _controllerName.text != tr(trHome) && _controllerName.text != tr(trWork);
  }

  void _removeAddress() {
    if (_address["address_id"] == null) {
      Dlg.show(tr(trCannotRemoveUnavailableAddress));
    }
    WebMyAddresses.remove(_address["address_id"], (d){
      Navigator.pop(context);
    }, null);
  }
}