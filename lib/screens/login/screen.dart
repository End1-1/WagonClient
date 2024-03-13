import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
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

  final _focus1 = FocusNode();
  final _phoneController = STextEditingController();

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
    if (langPos == null) {
      langPos = Tween<double?>(
              begin: MediaQuery.sizeOf(context).height,
              end: MediaQuery.sizeOf(context).height - 190)
          .animate(_backgrounController);
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:SafeArea(
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
                                          color: Consts.colorRed)),
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
                              height: MediaQuery.sizeOf(context).height - 390,
                              viewportFraction: 1.0,
                              enlargeCenterPage: true,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                            )),
                        if (_currentPage < 7)
                          _pageNum(7, _currentPage)
                        else
                          const SizedBox(height: 20),
                        const SizedBox(height: 50),
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
                );
  }

  List<Widget> _pages(BuildContext context) {
    Map<String, List<RichText>> texts = {
      'ՀԱՅ': [
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
      ],
      'ENG': [
        RichText(
            textAlign: TextAlign.center,
            maxLines: 3,
            text: TextSpan(
                text: 'All ',
                style: TextStyle(color: Color(0xffBE2A60), fontSize: 20),
                children: [
                  TextSpan(
                      text: 'kinds\n',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'mobile services\n',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'in your pocket',
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
                text: 'Premium ',
                style: TextStyle(color: Color(0xffBE2A60), fontSize: 20),
                children: [
                  TextSpan(
                      text: 'taxi services\n',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'NEW\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'Hourly taxi services',
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
                text: 'Transportation\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'high class\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'services',
                      style: TextStyle(color: Color(0xffBE2A60), fontSize: 20))
                ])),
        //44
        RichText(
            textAlign: TextAlign.center,
            maxLines: 3,
            text: TextSpan(
                text: 'Personal driver\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'high class\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'services',
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
                text: 'Car towing\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'high class\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'services',
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
                text: 'Any kind of Bus\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'providing\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'services',
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
                text: 'Mobile car\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'maintenance\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'services',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.normal))
                ])),
      ],
      'РУС': [
        RichText(
            textAlign: TextAlign.center,
            maxLines: 3,
            text: TextSpan(
                text: 'Все  ',
                style: TextStyle(color: Color(0xffBE2A60), fontSize: 20),
                children: [
                  TextSpan(
                      text: 'виды\n',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'транспортных средств\n',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'в твоём кармане',
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
                text: 'Комфортабельное ',
                style: TextStyle(color: Color(0xffBE2A60), fontSize: 20),
                children: [
                  TextSpan(
                      text: 'такси\n',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'новинка\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'аренда такси',
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
                text: 'Перевозка\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'грузов\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'профессионалами',
                      style: TextStyle(color: Color(0xffBE2A60), fontSize: 20))
                ])),
        //44
        RichText(
            textAlign: TextAlign.center,
            maxLines: 3,
            text: TextSpan(
                text: 'Услуга\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'трезвый водитель\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'высшего класса',
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
                text: 'Эвакуация \n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'автомобиля\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'по высшему разряду',
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
                text: 'Предоставляем\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'автобусные\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'перевозки',
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
                text: 'Услуги\n',
                style: TextStyle(
                    color: Color(0xffBE2A60),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: 'передвижного\n',
                      style: TextStyle(
                          color: Color(0xffF1A648),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'автосервиса',
                      style: TextStyle(
                          color: Color(0xffBE2A60),
                          fontSize: 20,
                          fontWeight: FontWeight.normal))
                ])),
      ]
    };

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
        _page(context, images[i], i, texts[currentLanguage()]![i])
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
                height: 170,
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
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(tr(trLanguage)))
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
    return Row(children: [
      const SizedBox(
        width: 5,
      ),
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
      Expanded(
          child: PinInputTextField(
              autoFocus: true,
              controller: _phoneController,
              focusNode: _focus1,
              pinLength: 8,
              keyboardType: TextInputType.number,
              decoration: UnderlineDecoration(
                gapSpace: 10,
                colorBuilder:
                FixedColorBuilder(Colors.black26),
                textStyle: TextStyle(
                    color: Color(0xffBE2A60), fontSize: 28),
              ),
          )),
      const SizedBox(
        width: 15,
      ),
    ]);
  }

  void _nextPressed() async {
    if (_currentPage < 7) {
      carouselController.animateToPage(7);
      return;
    }

    String s = '+374' + _phoneController.text;

    if (s.contains("99999999")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelectServer()));
      return;
    }
    if (s.length < 12) {
      Dlg.show(tr(trIncorrectPhoneNumber));
      return;
    }
    //s = '+37477019107';
    Consts.setString("phone", s);
    WebEnterPhone webEnterPhone =
        WebEnterPhone(phone: Consts.getString("phone"));
    webEnterPhone.request((mp) {
      Consts.setString("sms_message", mp['message']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SmsScreen()));
    }, (c, s) {
      Dlg.show(s);
    });
  }
}
