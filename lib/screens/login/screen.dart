import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  var _visible = false;
  late AnimationController _backgrounController;

  late Animation<Color?> background;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _backgrounController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
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
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Column(
        children: [
          const SizedBox(height: 20),
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
                    Image.asset('images/login/translate.png', height: 30),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(currentLanguage(),
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xffBF2A61))),
                    const SizedBox(width: 20),
                  ]))
            ],
          ),
          const SizedBox(height: 80),
          Expanded(
              child: CarouselSlider(
                  items: _pages(context),
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                  ))),
          Row(
            children: [
              Expanded(child: Container()),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.7,
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xffBF2A61)),
                child: Text(tr(trEnter).toUpperCase(),
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
      _dimWidget(context),
              _langWidget(context),
    ])));
  }

  List<Widget> _pages(BuildContext context) {
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
      for (int i = 0; i < images.length; i++) ...[_page(context, images[i], i)]
    ];
  }

  Widget _page(BuildContext context, String image, int pagenum) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Image.asset(
            image,
            height: 160,
          ),
          const SizedBox(height: 40),
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
          height: 30,
          width: 30,
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
                  color: background.value,
                ));
          },
        ));
  }

  Widget _langWidget(BuildContext context) {
    return AnimatedBuilder(
          animation: _backgrounController,
          builder: (BuildContext context, Widget? child) {
            return Positioned(

                child: Container(
                  color: background.value,
                ));
          },
        );
  }
}
