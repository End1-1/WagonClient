import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenAC extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenAC(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAC();
}

class _ScreenAC extends State<ScreenAC> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      acType(context, 'ac_taxicab', tr(trTaxCab), 1),
                      acType(context, 'ac_taxicab', tr(trRentTaxi), 2),
                      acType(context, 'ac_eakulator', tr(trEakulator), 3),
                      acType(context, 'ac_biznescab', tr(trBuzinesCab), 4),
                      acType(context, 'ac_limuzin', tr(trLimuzin), 5),
                      acType(context, 'ac_avtobus', tr(trAvtobus), 6),
                      acType(context, 'ac_bernatar', tr(trBernatar), 7),
                      acType(context, 'ac_stap_varord', tr(trStapVarord), 8),
                      acType(context, 'ac_vulkanacum', tr(trVulkanacum), 9),
                    ],
                  ),
                )))
      ],
    );
  }

  Widget acType(BuildContext context, String image, String text, int act) {
    return InkWell(
        onTap: () {
          widget.model.setAcType(act, widget.parentState);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border:
                  Border.fromBorderSide(BorderSide(color: Consts.colorRed))),
          child: Column(
            children: [
              SvgPicture.asset(
                'images/ac/${image}.svg',
                height: 30,
              ),
              Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Consts.colorRed, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ));
  }
}
