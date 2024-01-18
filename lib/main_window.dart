import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wagon_client/assessments.dart';
import 'package:wagon_client/car.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/freezed/chat_message.dart';
import 'package:wagon_client/history_all.dart';
import 'package:wagon_client/information.dart';
import 'package:wagon_client/order_cancel_options.dart';
import 'package:wagon_client/resources/resource_car_types.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/iphonedatepicker.dart';
import 'package:wagon_client/screens/language/screen.dart';
import 'package:wagon_client/screens/login/screen.dart';
import 'package:wagon_client/screens/mainwindow/anim_placemark.dart';
import 'package:wagon_client/screens/multiaddress_to_screen/screen.dart';
import 'package:wagon_client/screens/options_screen.dart';
import 'package:wagon_client/screens/payment/screen.dart';
import 'package:wagon_client/screens/single_address/screen.dart';
import 'package:wagon_client/screens/support/screen.dart';
import 'package:wagon_client/settings.dart';
import 'package:wagon_client/web/web_assessment.dart';
import 'package:wagon_client/web/web_broadcast_auth.dart';
import 'package:wagon_client/web/web_cancelaccept.dart';
import 'package:wagon_client/web/web_canceloptions.dart';
import 'package:wagon_client/web/web_cancelsearchtaxi.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/web_initorder.dart';
import 'package:wagon_client/web/web_realstate.dart';
import 'package:wagon_client/web/web_yandexkey.dart';
import 'package:wagon_client/widget/car_type.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'model/address_model.dart';
import 'model/tr.dart';
import 'myaddresses.dart';
import 'screens/app/model.dart';
import 'screens/mainpage/mainpage.dart';

class WMainWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WMainWidowState();
  }
}

class WMainWidowState extends State<WMainWindow>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _backgrounController;
  late Animation<Color?> background;
  Animation<double?>? langPos;

  final Screen2Model model = Screen2Model();
  final player = AudioPlayer();


  double _menuLeft = 0;

  int _pageBeforeChat = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WebYandexKey().request(() {}, null);

    WidgetsBinding.instance.addObserver(this);

    _backgrounController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    background = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.transparent,
            //begin: Colors.yellow,
            end: Colors.black54,
          ),
        ),
      ],
    ).animate(_backgrounController);
  }



  @override
  Widget build(BuildContext context) {
    if (langPos == null) {
      langPos = Tween<double?>(
              begin: MediaQuery.sizeOf(context).height,
              end: MediaQuery.sizeOf(context).height - 140)
          .animate(_backgrounController);
    }

    return  Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Stack(children: [
              YandexMap(

              ),
              //Visibility(visible: isMenuVisible(), child: _menuWidget()),

              //TODO: whats to do
              // _appendAddressToWidget(context),
              // _multiAddressWiget(context),
              //_dimWidget(context),
              //_walletOptions(context),
            ])));
  }

  // Widget _stepChat() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _getUnreadMessages();
  //   });
  //   String chatStr = Consts.getString("chat");
  //   if (chatStr.isEmpty) {
  //     chatStr = "{\"chat\":[]}";
  //   }
  //   Map<String, dynamic> chat = jsonDecode(chatStr);
  //   return Container(
  //       padding: EdgeInsets.only(left: 10, right: 10),
  //       height: MediaQuery.of(context).size.height -
  //           MediaQuery.of(context).padding.top -
  //           MediaQuery.of(context).viewInsets.bottom,
  //       color: Colors.white,
  //       child: Column(children: [
  //         Row(children: [
  //           IconButton(
  //               icon: Image.asset(
  //                 "images/back.png",
  //                 height: 20,
  //                 width: 20,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   model.unreadChatMessagesCount = 0;
  //                   model.currentPage = _pageBeforeChat;
  //                 });
  //               }),
  //           Text(tr(trDialogWithDriver))
  //         ]),
  //         Container(
  //             height: 5,
  //             decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                     begin: Alignment.topCenter,
  //                     end: Alignment.bottomCenter,
  //                     colors: [Color(0xffcccccc), Colors.white]))),
  //         Expanded(
  //             child: ListView.builder(
  //                 controller: _scrollController,
  //                 shrinkWrap: true,
  //                 itemCount: chat["chat"].length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   bool driverMessage = chat["chat"][index]["messageData"]
  //                           ["sender"] ==
  //                       "driver";
  //                   return Column(children: [
  //                     Row(
  //                         crossAxisAlignment: CrossAxisAlignment.end,
  //                         children: [
  //                           driverMessage
  //                               ? Container()
  //                               : Expanded(child: Container()),
  //                           driverMessage
  //                               ? Container(
  //                                   padding: EdgeInsets.all(3),
  //                                   height: 36,
  //                                   width: 36,
  //                                   decoration: BoxDecoration(
  //                                       border: Border.fromBorderSide(
  //                                           BorderSide(color: Colors.black12)),
  //                                       borderRadius: BorderRadius.all(
  //                                           Radius.circular(50))),
  //                                   child: Image.asset('images/profile.png'))
  //                               : Container(),
  //                           Column(
  //                               crossAxisAlignment: driverMessage
  //                                   ? CrossAxisAlignment.start
  //                                   : CrossAxisAlignment.end,
  //                               children: [
  //                                 Align(
  //                                     alignment: driverMessage
  //                                         ? Alignment.centerLeft
  //                                         : Alignment.centerRight,
  //                                     child: Text(chat["chat"][index]
  //                                         ["messageData"]["time"])),
  //                                 Container(
  //                                   margin: EdgeInsets.only(left: 5, right: 5),
  //                                   constraints: BoxConstraints(
  //                                       minWidth: 20,
  //                                       maxWidth:
  //                                           (MediaQuery.of(context).size.width *
  //                                                   0.9) -
  //                                               30),
  //                                   padding: EdgeInsets.all(10),
  //                                   decoration: BoxDecoration(
  //                                       color: driverMessage
  //                                           ? Consts.colorOrange
  //                                           : Consts.colorGreen,
  //                                       borderRadius: BorderRadius.only(
  //                                           topLeft: Radius.circular(30),
  //                                           topRight: Radius.circular(30),
  //                                           bottomLeft: driverMessage
  //                                               ? Radius.circular(0)
  //                                               : Radius.circular(30),
  //                                           bottomRight: driverMessage
  //                                               ? Radius.circular(30)
  //                                               : Radius.circular(0))),
  //                                   child: Text(
  //                                       chat["chat"][index]["messageData"]
  //                                           ["text"],
  //                                       softWrap: true,
  //                                       style: Consts.textStyle7),
  //                                 )
  //                               ]),
  //                           driverMessage
  //                               ? Expanded(child: Container())
  //                               : Container(
  //                                   padding: EdgeInsets.all(3),
  //                                   height: 36,
  //                                   width: 36,
  //                                   decoration: BoxDecoration(
  //                                       border: Border.fromBorderSide(
  //                                           BorderSide(color: Colors.black12)),
  //                                       borderRadius: BorderRadius.all(
  //                                           Radius.circular(50))),
  //                                   child: Image.asset('images/profile.png'))
  //                         ]),
  //                     const Divider(
  //                       height: 20,
  //                       color: Colors.white10,
  //                     )
  //                   ]);
  //                 })),
  //         Container(
  //             padding: EdgeInsets.all(5),
  //             child: Row(
  //               children: [
  //                 Image.asset('images/operator.png', height: 36, width: 36),
  //                 VerticalDivider(width: 5),
  //                 Expanded(
  //                     child: TextFormField(
  //                   controller: model.chatTextController,
  //                   decoration: InputDecoration(
  //                       focusedBorder: UnderlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.red)),
  //                       hintStyle: const TextStyle(color: Colors.black12),
  //                       hintText: tr(trMessage).toUpperCase()),
  //                 )),
  //                 VerticalDivider(width: 5),
  //                 IconButton(
  //                     icon: Image.asset("images/send.png"),
  //                     onPressed: _sendChatMessage)
  //               ],
  //             ))
  //       ]));
  // }















  // void _sendChatMessage() {
  //   if (model.chatTextController.text.isEmpty) {
  //     return;
  //   }
  //   String msg = sprintf(
  //       "{\n" +
  //           "\"channel\": \"private-client-api-base.%d.%s\",\n" +
  //           "\"data\": {\"text\": \"%s\"},\n" +
  //           "\"event\": \"client-broadcast-api/broadway-driver\"\n"
  //               "}",
  //       [
  //         Consts.getInt("client_id"),
  //         Consts.getString("phone").replaceAll("+", ""),
  //         model.chatTextController.text
  //       ]);
  //   print(msg);
  //   _socket!.add(msg);
  //
  //   String chat = Consts.getString("chat");
  //   if (chat.isEmpty) {
  //     chat = "{\"chat\":[]}";
  //   }
  //   DateTime time = DateTime.now();
  //   DateFormat df = DateFormat("HH:mm");
  //
  //   Map<String, dynamic> nmsg = Map();
  //   nmsg["text"] = model.chatTextController.text;
  //   nmsg["sender"] = "passenger";
  //   nmsg["time"] = df.format(time);
  //   Map<String, dynamic> chatdata = jsonDecode(chat);
  //   Map<String, dynamic> mmsg = Map();
  //   mmsg["messageData"] = nmsg;
  //   chatdata["chat"].add(mmsg);
  //   Consts.setString("chat", jsonEncode(chatdata));
  //   setState(() {
  //     model.chatTextController.clear();
  //   });
  // }

  void _callHistory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryAll()));
  }

  void _scrollChatToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollChatToBottom());
    }
  }

  // void _setDriverComment() {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         return SimpleDialog(contentPadding: EdgeInsets.all(10), children: [
  //           SizedBox(
  //               width: MediaQuery.of(ctx).size.width * 0.95,
  //               child: TextFormField(
  //                   controller: model.commentFrom,
  //                   decoration: InputDecoration(
  //                       focusedBorder: UnderlineInputBorder(
  //                           borderSide: BorderSide(
  //                               color: Consts.colorOrange, width: 1)),
  //                       border: UnderlineInputBorder(
  //                           borderSide: BorderSide(color: Consts.colorOrange)),
  //                       hintText: tr(trCommentForDriver)))),
  //           OutlinedButton(
  //               style: OutlinedButton.styleFrom(
  //                   backgroundColor: Consts.colorOrange),
  //               onPressed: () {
  //                 Navigator.pop(ctx);
  //               },
  //               child: Text(tr(trSave),
  //                   style:
  //                       const TextStyle(fontSize: 16, color: Colors.black54)))
  //         ]);
  //       });
  // }

   String _getPhoneFormatted() {
    MaskTextInputFormatter mf = MaskTextInputFormatter(
        mask: '+### (##) ###-###',
        filter: {"#": RegExp(r'[0-9]')},
        initialText: Consts.getString("phone"));
    String s = mf.getMaskedText();
    return s;
  }

  // void _cameraPosition(
  //     CameraPosition cameraPosition, CameraUpdateReason reason, bool finished) {
  //   if (!model.tracking) {
  //     return;
  //   }
  //   if (!model.init) {
  //     return;
  //   }
  //   model.rideZoom = cameraPosition.zoom;
  //   Consts.setDouble("last_lat", cameraPosition.target.latitude);
  //   Consts.setDouble("last_lon", cameraPosition.target.longitude);
  //
  //   if (finished) {
  //     setState(() {});
  //   } else {
  //     if (!model.isMapPressed) {
  //       setState(() {
  //         model.isMapPressed = true;
  //       });
  //     }
  //   }
  //
  //   if (RouteHandler.routeHandler.destinationDefined()) {
  //     setState(() {
  //       model.loadingData = true;
  //     });
  //     model.initCoin(context, () {
  //       setState(() {
  //         model.loadingData = false;
  //       });
  //     }, () {
  //       setState(() {
  //         model.loadingData = false;
  //       });
  //     });
  //     return;
  //   }
  //
  //   model.addressFrom.text = tr(trGettingAddress);
  //   model.geocode.geocode(cameraPosition.target.latitude,
  //       cameraPosition.target.longitude, _geocodeResponse);
  // }
  //
  // void resetAddresses() {
  //   model.removePolyline(centerMe: true);
  //   model.addressTo.text = "";
  //   RouteHandler.routeHandler.directionStruct.to.clear();
  //   setState(() {});
  // }

  // void _clearTaxiOnMap() {
  //   List<MapObject> mm = [];
  //   for (MapObject mo in model.mapObjects) {
  //     if (mo.mapId.toString().contains("taxionmap")) {
  //       mm.add(mo);
  //     }
  //   }
  //   for (MapObject mo in mm) {
  //     model.mapObjects.remove(mo);
  //   }
  // }

  void _getUnreadMessages() {
    var client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);
    ioClient.get(
        Uri.parse(
            'https://${Consts.host()}/app/mobile/get_unread_messages?clientDriverConversation="true"'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Consts.getString("bearer")}'
        }).then((value) {
      print(value.body.toString());
      Map<String, dynamic> m = jsonDecode(value.body.toString());
      ChatMessageList cml = ChatMessageList.fromJson({'list': m['messages']});
      print(cml);

      String chat = Consts.getString("chat");
      if (chat.isEmpty) {
        chat = "{\"chat\":[]}";
      }
      Map<String, dynamic> chatdata = jsonDecode(chat);

      DateTime time = DateTime.now();
      DateFormat df = DateFormat("HH:mm");
      String ids = '';
      for (var e in cml.list) {
        Map<String, Map<String, String>> msg = {"messageData": {}};
        msg["messageData"]!.addAll({"sender": "driver"});
        msg["messageData"]!.addAll({"time": df.format(time)});
        msg["messageData"]!.addAll({"text": e.message});
        chatdata["chat"].add(msg);
        if (ids.isNotEmpty) {
          ids += ',';
        }
        ids += e.order_conversation_id.toString();
      }

      var client2 = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient2 = IOClient(client2);
      ioClient2
          .post(Uri.parse('https://${Consts.host()}/app/mobile/message_read'),
              headers: {
                'content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${Consts.getString("bearer")}',
              },
              body: '{"ids":[$ids], "clientDriverConversation":"true"}')
          .then((value) {
        print(value.body.toString());
      });

      Consts.setString("chat", jsonEncode(chatdata));
    });
    _scrollChatToBottom();
  }

  // Widget _appendAddressToWidget(BuildContext context) {
  //   return AnimatedPositioned(
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.height,
  //       duration: Duration(milliseconds: 300),
  //       top: model.showSingleAddress ? 00 : MediaQuery.of(context).size.height,
  //       child: Container(
  //         decoration: const BoxDecoration(color: Colors.white),
  //         child: SingleAddressSelect(model, () {
  //           FocusManager.instance.primaryFocus?.unfocus();
  //           setState(() {
  //             model.addressTo.text =
  //                 RouteHandler.routeHandler.addressTo().join(" → ");
  //           });
  //           countRoute();
  //         }),
  //
  //       ));
  // }

  // Widget _multiAddressWiget(BuildContext context) {
  //   return AnimatedPositioned(
  //       width: MediaQuery.of(context).size.width,
  //       //top: model.showMultiAddress ? MediaQuery.of(context).size.height - (RouteHandler.routeHandler.directionStruct.to.length * 30.0) : MediaQuery.of(context).size.height,
  //       top: model.showMultiAddress ? 0 : MediaQuery.of(context).size.height,
  //       child: MultiaddressToScreen(model, () {
  //         model.addressTo.text =
  //             RouteHandler.routeHandler.addressTo().join(" → ");
  //         countRoute();
  //       }),
  //       duration: Duration(milliseconds: 200));
  // }

  // Widget _walletOptions(BuildContext context) {
  //   return AnimatedPositioned(
  //       top: model.showWallet
  //           ? MediaQuery.sizeOf(context).height *
  //               (1 - Consts.sizeofPaymentWidget)
  //           : MediaQuery.sizeOf(context).height,
  //       child: PaymentWidget(model, () {
  //         setState(() {});
  //       }, true),
  //       duration: const Duration(milliseconds: 300));
  // }

  // Widget _dimWidget(BuildContext context) {
  //   return Visibility(
  //       visible: model.dimvisible,
  //       child: AnimatedBuilder(
  //         animation: _backgrounController,
  //         builder: (BuildContext context, Widget? child) {
  //           return GestureDetector(
  //               onTap: () {
  //                 _backgrounController.reverse().whenComplete(() {
  //                   setState(() {
  //                     model.dimvisible = false;
  //                     model.showWallet = false;
  //                   });
  //                 });
  //               },
  //               child: Container(
  //                 width: MediaQuery.sizeOf(context).width,
  //                 height: MediaQuery.sizeOf(context).height,
  //                 color: background.value,
  //               ));
  //         },
  //       ));
  // }
}
