import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/bloc/screen_menu_bloc.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenMenu extends StatefulWidget {
  final Screen2Model model;
  const ScreenMenu(this.model, {super.key});

  @override
  State<StatefulWidget> createState() => _ScreenMenu();
}

class _ScreenMenu extends State<ScreenMenu> {
  var pos = 0.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.8;
    return BlocBuilder<AppAnimateBloc, AppAnimateStateIdle>(
        builder: (builder, state) {
          return Stack(
            children: [
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: state.runtimeType == AppAnimateStateRaise
                      ? InkWell(
                      onTap: () {
                        pos = 0;
                        BlocProvider.of<AppAnimateBloc>(Consts.navigatorKey.currentContext!)
                            .add(AppAnimateEvent());
                      },
                      child: Container(color: Colors.black38))
                      : Container()),
              AnimatedPositioned(
                  width: width,
                  height: MediaQuery.sizeOf(context).height,
                  left:
                  state.runtimeType == AppAnimateStateRaise ? pos : 0 - width,
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                      onPanUpdate: (d) {
                        if (pos - d.delta.dx < 0) {
                          return;
                        }
                        if ((pos - d.delta.dx).abs() < width * 0.5) {
                          pos = 0;
                          BlocProvider.of<AppAnimateBloc>(Consts.navigatorKey.currentContext!)
                              .add(AppAnimateEvent());
                          return;
                        }
                        setState(() {
                          pos += d.delta.dx;
                        });
                      },
                      onPanEnd: (d) {
                        setState(() {
                          pos = 0;
                        });
                      },
                      child: Container(
                        color: Color(0xff1e3d4b),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              ElevatedButton.icon(onPressed:widget.model.logout, label: Text(tr(trEXIT)), icon: Icon(Icons.exit_to_app),)
                            ],)
                          ],
                        ),
                      )))
            ],
          );
        });
  }
}
