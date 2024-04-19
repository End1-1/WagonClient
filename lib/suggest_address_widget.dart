import 'package:flutter/material.dart';
import 'package:wagon_client/airports_metro.dart';
import 'package:wagon_client/consts.dart';

class SuggestAddressWidget extends StatelessWidget {

  final String? shortAddress;
  final String? fullAddress;
  Function()? tapCallback;
  final TP? tp;
  Image? _image;

  SuggestAddressWidget({this.shortAddress, this.fullAddress, required this.tapCallback, this.tp})
  {
    String imagename = "images/placeholderlight.png";
    switch (tp) {
      case TP.TP_METRO:
        imagename = "images/metro.png";
        break;
      case TP.TP_RAILWAY:
        imagename = "images/railway.png";
        break;
      case TP.TP_AIRPORT:
        imagename = "images/airport.png";
        break;
      default:
        imagename = "images/placeholderlight.png";
        break;
    }
    _image = Image.asset(imagename, width: 20, height: 20,);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapCallback,
      child: Wrap (
        children:[ Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row (
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: _image
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(shortAddress ?? '', style: Consts.textStyle6, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,),
                    Text(fullAddress ?? '', style: Consts.textStyle5, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,),
                    Divider(color: Colors.black38,)
                  ],
                )
              )
            ],
          )
        )]
      )
    );
  }
}