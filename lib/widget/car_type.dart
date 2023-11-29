import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/resources/resource_car_types.dart';

class CarTypeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CarTypeList();
}

class _CarTypeList extends State<CarTypeList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final e in ResourceCarTypes.res) ...[
              InkWell(
                  onTap: () {
                    ResourceCarTypes.deselect();
                    setState(() {
                      e.selected = true;
                    });
                  },
                  child: CarType(e))
            ]
          ],
        ));
  }
}

class CarType extends StatelessWidget {
  late final Color bgColor;
  final CarTypeStruct ct;

  CarType(this.ct) {
    bgColor = Color(0xffffffff);
    print(bgColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),

        height: 120,
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
              BorderSide(color: Colors.black12, width: 1)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: const EdgeInsets.all(5),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: ct.selected ? Consts.colorOrange : Consts.colorRed,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Image.asset(ct.imageName)),
            Container(height: 40, child: Text(ct.title, textAlign: TextAlign.center,))
          ],
        ));
  }
}

class CarSubtypeWidget extends StatelessWidget {
  final CarSubtypeStruct css;

  CarSubtypeWidget(this.css);

  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
        decoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
            color: css.selected ? const Color(0x40C02C63) : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        width: MediaQuery.sizeOf(context).width,
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image.asset(css.imageName, height: 70, width: 70,),
            Image.memory(base64Decode(css.image), height: 70, width: 70,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(css.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(css.subTitle, style: const TextStyle(fontSize: 12))
                  ],
                )),
            Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color(0xffC02C63) ,
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Text('${css.price} ${tr(trDramSymbol)}', style: const TextStyle(color: Colors.white)),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: const Color(0x40C02C63),
                          border: Border.fromBorderSide(BorderSide(color: const Color(0xffc02c63))),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Text('i', style: const TextStyle(color: Colors.white),),
                    )
                  ],
                )),
            SizedBox(width: 10,)
          ],
        ));
  }

}
