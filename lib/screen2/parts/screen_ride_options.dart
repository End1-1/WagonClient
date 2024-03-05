import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenRideOptions extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenRideOptions(this.model, this.parentState);
  @override
  State<StatefulWidget> createState() => _ScreenRideOptions();

}

class _ScreenRideOptions extends State<ScreenRideOptions> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(
        minHeight: 0,
        maxHeight: widget.model.appState.showRideOptions ? 300 : 0
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child:
      Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20,),
              Expanded(child: TextFormField(
                minLines: 3,
                controller: widget.model.appState.driverText,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: tr(trDriverComment),
                ),
              )),
              InkWell(onTap: (){},
              child: Image.asset('images/drivercomment.png', height: 30,),),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),);
  }



}