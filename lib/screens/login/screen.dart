import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/enter_sms.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screens/login/smsscreen.dart';
import 'package:wagon_client/select_server.dart';
import 'package:wagon_client/web/web_enterphone.dart';
import 'package:wagon_client/widget/stexteditingcontroller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  var _visible = false;
  var _enterTitle = tr(trEnter);
  late AnimationController _backgrounController;
  final carouselController = CarouselController();
  var _currentPage = 0;

  final _rawFocus = FocusNode();
  final _focus1 = FocusNode();
  final _focus2 = FocusNode();
  final _focus3 = FocusNode();
  final _focus4 = FocusNode();
  final _focus5 = FocusNode();
  final _focus6 = FocusNode();
  final _focus7 = FocusNode();
  final _focus8 = FocusNode();
  final _t1 = STextEditingController();
  final _t2 = STextEditingController();
  final _t3 = STextEditingController();
  final _t4 = STextEditingController();
  final _t5 = STextEditingController();
  final _t6 = STextEditingController();
  final _t7 = STextEditingController();
  final _t8 = STextEditingController();

  late Animation<Color?> background;
  Animation<double?>? langPos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _backgrounController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    background = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.transparent,
            end: Colors.black54,
          ),
        ),
      ],
    ).animate(_backgrounController);

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    if (langPos == null) {
      langPos = Tween<double?>(
              begin: MediaQuery.sizeOf(context).height,
              end: MediaQuery.sizeOf(context).height - 170)
          .animate(_backgrounController);
    }
    return Scaffold(
        body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                  SafeArea(
                      child: Stack(children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        //LANGUAGE
                        Row(
                          children: [
                            Expanded(child: Container()),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _visible = true;
                                    _backgrounController.reset();
                                    _backgrounController.forward();
                                  });
                                },
                                child: Row(children: [
                                  Image.asset('images/login/translate.png',
                                      height: 30),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(currentLanguage(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffBF2A61))),
                                  const SizedBox(width: 20),
                                ]))
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        //CAROUSEL
                        CarouselSlider(
                            carouselController: carouselController,
                            items: _pages(context),
                            options: CarouselOptions(
                              onPageChanged: (i, reason) {
                                _currentPage = i;
                                setState(() {
                                  _enterTitle =
                                      i == 7 ? tr(trNEXT) : tr(trEnter);
                                  if (i == 7) {
                                    _focus1.requestFocus();
                                  }
                                });
                              },
                              height: MediaQuery.sizeOf(context).height - 290,
                              viewportFraction: 1.0,
                              enlargeCenterPage: true,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                            )),
                        //ENTER BUTTON
                        Row(
                          children: [
                            Expanded(child: Container()),
                            InkWell(
                                onTap: () {
                                  _nextPressed();
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color(0xffBF2A61)),
                                  child: Text(_enterTitle.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                )),
                            Expanded(child: Container()),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                    _dimWidget(context),
                    _langWidget(context),
                  ]))
                ])))));
  }

  List<Widget> _pages(BuildContext context) {
    List<RichText> texts = [
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Բոլոր  ',
              style: TextStyle(color: Color(0xffBE2A60), fontSize: 20),
              children: [
                TextSpan(
                    text: 'տեսակի\n',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'շարժական ծառայությունները\n',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'քո գրպանում',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ])),
      //2
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Բարձրակարգ ',
              style: TextStyle(color: Color(0xffBE2A60), fontSize: 20),
              children: [
                TextSpan(
                    text: 'տաքսի ծառայություն\n',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'Նորույթ\n',
                    style: TextStyle(
                        color: Color(0xffF1A648),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'Ժամավարձով տաքսի',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ])),
      //3
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Բեռնափոխադրման\n',
              style: TextStyle(
                  color: Color(0xffBE2A60),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'բարձրակարգ\n',
                    style: TextStyle(
                        color: Color(0xffF1A648),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'ծառայություններ',
                    style: TextStyle(color: Color(0xffBE2A60), fontSize: 20))
              ])),
      //44
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Սթափ վարորդի\n',
              style: TextStyle(
                  color: Color(0xffBE2A60),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'բարձրակարգ\n',
                    style: TextStyle(
                        color: Color(0xffF1A648),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'ծառայություններ',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
              ])),
      //5
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Ավտոքարշակի\n',
              style: TextStyle(
                  color: Color(0xffBE2A60),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'բարձրակարգ\n',
                    style: TextStyle(
                        color: Color(0xffF1A648),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'ծառայություններ',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
              ])),
      //6
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Ավտոբուսների\n',
              style: TextStyle(
                  color: Color(0xffBE2A60),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'տրամադրման\n',
                    style: TextStyle(
                        color: Color(0xffF1A648),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'ծառայություններ',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
              ])),
      //7
      RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(
              text: 'Շարժական\n',
              style: TextStyle(
                  color: Color(0xffBE2A60),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'ավտոտեխսպասարկման\n',
                    style: TextStyle(
                        color: Color(0xffF1A648),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'ծառայություններ',
                    style: TextStyle(
                        color: Color(0xffBE2A60),
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
              ])),
    ];

    List<String> images = [
      'images/login/wp1.png',
      'images/login/wp2.png',
      'images/login/wp3.png',
      'images/login/wp4.png',
      'images/login/wp5.png',
      'images/login/wp6.png',
      'images/login/wp7.png',
    ];

    return [
      for (int i = 0; i < images.length; i++) ...[
        _page(context, images[i], i, texts[i])
      ],
      _lastPage(context)
    ];
  }

  Widget _page(BuildContext context, String image, int pagenum, RichText r) {
    return Container(
      // height: MediaQuery.sizeOf(context).height,
      // width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Image.asset(
            image,
            height: 160,
          ),
          const SizedBox(height: 40),
          r,
          const SizedBox(height: 60),
          _pageNum(7, pagenum),
        ],
      ),
    );
  }

  Widget _pageNum(int count, int num) {
    return Row(children: [
      Expanded(child: Container()),
      for (int i = 0; i < count; i++) ...[
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: i == num ? Color(0xffBE2A60) : Color(0xffd9d9d9),
              borderRadius: BorderRadius.all(Radius.circular(49))),
        ),
        const SizedBox(width: 10),
      ],
      Expanded(child: Container()),
    ]);
  }

  Widget _dimWidget(BuildContext context) {
    return Visibility(
        visible: _visible,
        child: AnimatedBuilder(
          animation: _backgrounController,
          builder: (BuildContext context, Widget? child) {
            return GestureDetector(
                onTap: () {
                  _backgrounController.reverse().whenComplete(() {
                    setState(() {
                      _visible = false;
                    });
                  });
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: background.value,
                ));
          },
        ));
  }

  Widget _langWidget(BuildContext context) {
    return Visibility(
        visible: _visible,
        child: AnimatedBuilder(
          animation: _backgrounController,
          builder: (BuildContext context, Widget? child) {
            return Positioned(
                height: 150,
                top: langPos!.value,
                width: MediaQuery.sizeOf(context).width,
                child: Container(
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(tr(trLanguage))
                          ]),
                          Divider(),
                          for (final e in trLangList) ...[
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    Consts.setString("lang", e.title);
                                    _backgrounController
                                        .reverse()
                                        .whenComplete(() {
                                      setState(() {
                                        _visible = false;
                                      });
                                    });
                                  });
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      e.image,
                                      height: 25,
                                      width: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(e.name),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ])));
          },
        ));
  }

  Widget _lastPage(BuildContext context) {
    return Container(
      // height: MediaQuery.sizeOf(context).height,
      // width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Image.asset(
            'images/login/wp1.png',
            height: 160,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: Container()),
              Text(tr(trPhoneNumber),
                  style: const TextStyle(
                      color: Color(0xffBE2A60),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 30),
          _phoneNumber(context),
          Divider(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _phoneNumber(BuildContext context) {
    return RawKeyboardListener(
        onKey: (v) {
          if (v is RawKeyUpEvent) {
            if (v.logicalKey.keyLabel != 'Backspace') {
              if (v.logicalKey.keyLabel != '0'
              && v.logicalKey.keyLabel != '1'
                  && v.logicalKey.keyLabel != '2'
                  && v.logicalKey.keyLabel != '3'
                  && v.logicalKey.keyLabel != '4'
                  && v.logicalKey.keyLabel != '5'
                  && v.logicalKey.keyLabel != '6'
                  && v.logicalKey.keyLabel != '7'
                  && v.logicalKey.keyLabel != '8'
                  && v.logicalKey.keyLabel != '9'
              ) {
                return;
              }
              if (_focus1.hasFocus) {
                _t1.text = v.logicalKey.keyLabel;
              } else if (_focus2.hasFocus) {
                _t2.text = v.logicalKey.keyLabel;
              } else if (_focus3.hasFocus) {
                _t3.text = v.logicalKey.keyLabel;
              } else if (_focus4.hasFocus) {
                _t4.text = v.logicalKey.keyLabel;
              } else if (_focus5.hasFocus) {
                _t5.text = v.logicalKey.keyLabel;
              } else if (_focus6.hasFocus) {
                _t6.text = v.logicalKey.keyLabel;
              } else if (_focus7.hasFocus) {
                _t7.text = v.logicalKey.keyLabel;
              } else if (_focus8.hasFocus) {
                _t8.text = v.logicalKey.keyLabel;
              }
              _rawFocus.nextFocus();
            } else {
              _rawFocus.previousFocus();
              // if (_focus1.hasFocus) {
              //   _t1.clear();
              // } else if (_focus2.hasFocus) {
              //   _t2.clear();
              // } else if (_focus3.hasFocus) {
              //   _t3.clear();
              // } else if (_focus4.hasFocus) {
              //   _t4.clear();
              // } else if (_focus5.hasFocus) {
              //   _t5.clear();
              // } else if (_focus6.hasFocus) {
              //   _t6.clear();
              // } else if (_focus7.hasFocus) {
              //   _t7.clear();
              // } else if (_focus8.hasFocus) {
              //   _t8.clear();
              // }
            }
          }
        },
        autofocus: true,
        focusNode: _rawFocus, child: Row(children: [
      Expanded(child: Container()),
      Image.asset(
        'images/login/am.png',
        height: 25,
        width: 25,
      ),
      const SizedBox(
        width: 5,
      ),
      Text('+374',
          style: const TextStyle(
              color: Color(0xffBE2A60),
              fontWeight: FontWeight.normal,
              fontSize: 25)),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
              child: TextField(
                  controller: _t1,
                  focusNode: _focus1,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(0),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0)),
                  ))),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
          child: TextField(
                  controller: _t2,
              focusNode: _focus2,
              textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(0),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0)),
                  ))),
      const SizedBox(
        width: 15,
      ),
      Container(
          width: 25,
          child: TextFormField(
              controller: _t3,
              focusNode: _focus3,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
              ))),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
          child: TextFormField(
              controller: _t4,
              focusNode: _focus4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
              ))),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
          child: TextFormField(
              controller: _t5,
              focusNode: _focus5,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
              ))),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
          child: TextFormField(
              controller: _t6,
              focusNode: _focus6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
              ))),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
          child: TextFormField(
              controller: _t7,
              focusNode: _focus7,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
              ))),
      const SizedBox(
        width: 5,
      ),
      Container(
          width: 25,
          child: TextFormField(
              controller: _t8,
              focusNode: _focus8,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Color(0xffBE2A60)),
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0)),
              ))),
      Expanded(child: Container()),
    ]));
  }

  void _nextPressed() async {
    if (_currentPage < 7) {
      carouselController.animateToPage(7);
      return;
    }

    String s = '+374' + _t1.text
    +_t2.text
    +_t3.text
    +_t4.text
    +_t5.text
    +_t6.text
    +_t7.text
    +_t8.text
    ;

    if (s.contains("99999999")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelectServer()));
      return;
    }
    if (s.length < 12) {
      Dlg.show(context, tr(trIncorrectPhoneNumber));
      return;
    }
    s = '+71111111111';
    Consts.setString("phone", s);
    WebEnterPhone webEnterPhone =
        WebEnterPhone(phone: Consts.getString("phone"));
    webEnterPhone.request((mp) {
      Consts.setString("sms_message", mp['message']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SmsScreen()));
    }, (c, s) {
      Dlg.show(context, s);
    });
  }
}
