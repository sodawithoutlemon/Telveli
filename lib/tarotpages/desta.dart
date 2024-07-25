import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';
import 'dart:math';
import 'package:material_symbols_icons/symbols.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dotted_border/dotted_border.dart';

String faltext = "";

String falstate = "okunmadı";
String tarottext = "Tarot Falına Bak";
String text = "";
var funclist = [];
String dragfintext = "Seçtiğiniz Kartları Buraya Bırakın.";
int howmanycardtheris = 0;
double card1width = 0;
double card2width = 0;
double card3width = 0;
double buttonheight = 0;
String docid = "";
String card1str = "images/tarot back.jpg";
String card2str = "images/tarot back.jpg";
String card3str = "images/tarot back.jpg";

String card1strback = "images/tarot back.jpg";
String card2strback = "images/tarot back.jpg";
String card3strback = "images/tarot back.jpg";

class DesteScreen extends StatefulWidget {
  const DesteScreen({
    super.key,
    required this.h,
    required this.w,
    required this.s,
  });

  final double h;
  final double w;
  final double s;

  @override
  _DesteScreenState createState() => _DesteScreenState();
}

var listre = [
  "images/lowtarot/ace of cups.png",
  "images/lowtarot/ace of pentacles.png",
  "images/lowtarot/ace of swords.png",
  "images/lowtarot/ace of wands.png",
  "images/lowtarot/death.png",
  "images/lowtarot/eight of cups.png",
  "images/lowtarot/eight of pentacles.png",
  "images/lowtarot/eight of swords.png",
  "images/lowtarot/eight of wands.png",
  "images/lowtarot/five of cups.png",
  "images/lowtarot/five of pentacles.png",
  "images/lowtarot/five of swords.png",
  "images/lowtarot/five of wands.png",
  "images/lowtarot/four of cups.png",
  "images/lowtarot/four of pentacles.png",
  "images/lowtarot/four of swords.png",
  "images/lowtarot/four of wands.png",
  "images/lowtarot/judgement.png",
  "images/lowtarot/justice.png",
  "images/lowtarot/king of cups.png",
  "images/lowtarot/king of pentacles.png",
  "images/lowtarot/king of swords.png",
  "images/lowtarot/king of wands.png",
  "images/lowtarot/knight of cups.png",
  "images/lowtarot/knight of pentacles.png",
  "images/lowtarot/knight of swords.png",
  "images/lowtarot/knight of wands.png",
  "images/lowtarot/nine of cups.png",
  "images/lowtarot/nine of pentacles.png",
  "images/lowtarot/nine of swords.png",
  "images/lowtarot/nine of wands.png",
  "images/lowtarot/page of cups.png",
  "images/lowtarot/page of pentacles.png",
  "images/lowtarot/page of swords.png",
  "images/lowtarot/page of wands.png",
  "images/lowtarot/queen of cups.png",
  "images/lowtarot/queen of pentacles.png",
  "images/lowtarot/queen of swords.png",
  "images/lowtarot/queen of wands.png",
  "images/lowtarot/seven of cups.png",
  "images/lowtarot/seven of pentacles.png",
  "images/lowtarot/seven of swords.png",
  "images/lowtarot/seven of wands.png",
  "images/lowtarot/six of cups.png",
  "images/lowtarot/six of pentacles.png",
  "images/lowtarot/six of swords.png",
  "images/lowtarot/six of wands.png",
  "images/lowtarot/strength.png",
  "images/lowtarot/temperance.png",
  "images/lowtarot/ten of cups.png",
  "images/lowtarot/ten of pentacles.png",
  "images/lowtarot/ten of swords.png",
  "images/lowtarot/ten of wands.png",
  "images/lowtarot/the chariot.png",
  "images/lowtarot/the devil.png",
  "images/lowtarot/the emperor.png",
  "images/lowtarot/the empress.png",
  "images/lowtarot/the fool.jpg",
  "images/lowtarot/the hanged man.png",
  "images/lowtarot/the hermit.png",
  "images/lowtarot/the hierophant.png",
  "images/lowtarot/the hight priestess.png",
  "images/lowtarot/the lovers.png",
  "images/lowtarot/the magician.png",
  "images/lowtarot/the moon.png",
  "images/lowtarot/the star.png",
  "images/lowtarot/the sun.png",
  "images/lowtarot/the tower.png",
  "images/lowtarot/the worlds.png",
  "images/lowtarot/three of cups.png",
  "images/lowtarot/three of pentacles.png",
  "images/lowtarot/three of swords.png",
  "images/lowtarot/three of wands.png",
  "images/lowtarot/two of cups.png",
  "images/lowtarot/two of pentacles.png",
  "images/lowtarot/two of swords.png",
  "images/lowtarot/two of wands.png",
  "images/lowtarot/wheel of fortune.png",
];

late var ref;
double pagewidth = 0;
double pageheight = 0;

String username = "";
String usermail = "";
late FlipCardController controller1;
late FlipCardController controller2;
late FlipCardController controller3;
String konu = "";
var imagelist = [];

class _DesteScreenState extends State<DesteScreen> {
  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    controller1 = FlipCardController();
    controller2 = FlipCardController();
    controller3 = FlipCardController();

    pagewidth = widget.w;
    pageheight = widget.h;
    // TODO: implement initState
    super.initState();
  }

  void startTimer() {
    var _start = 15;
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            print("bitti");
            falstate = "hazır";
            tarottext = "Falınız Hazır";
            timer.cancel();
          });
        } else {
          setState(() {
            print(_start);
            tarottext = _start.toString();
            _start--;
          });
        }
      },
    );
  }

  void flipfunc() async {
    if (howmanycardtheris == 0) {
      setState(() {
        dragfintext = "";
        card1width = widget.w * 8 / 30;
        var rng = Random();
        var ch = rng.nextInt(listre.length);
        card1str = listre[ch];
        listre.removeAt(ch);
        controller1.toggleCard();
      });
    }
    if (howmanycardtheris == 1) {
      setState(() {
        card2width = widget.w * 8 / 30;
        var rng = Random();
        var ch = rng.nextInt(listre.length);
        card2str = listre[ch];
        listre.removeAt(ch);
        controller2.toggleCard();
      });
    }
    if (howmanycardtheris == 2) {
      setState(() {
        buttonheight = widget.h / 20;
        card3width = widget.w * 8 / 30;
        var rng = Random();
        var ch = rng.nextInt(listre.length);
        card3str = listre[ch];
        listre.removeAt(ch);
        controller3.toggleCard();
      });
    }
    howmanycardtheris += 1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments as Map;
    //args["authdocc"].reference.update({"ad": "winner"});
    ref = args["authdocc"]["authdocc"];
    var xd = args["authdocc"]["authdocc"].data();
    konu = args["konu"];

    print(konu);
    username = xd["ad"];
    usermail = xd["mail"];
    super.didChangeDependencies();
  }

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 150);
  void _onScroll() {
    for (var u = 0; u < funclist.length; u++) {
      funclist[u]();
    }
    //SingleCard xd = SingleCard();
  }

  final storeage = FirebaseStorage.instance.ref();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: widget.w,
        height: widget.h,
        color: const Color(0xffB67233),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: widget.w,
              height: widget.h * 6 / 48,
              color: const Color(0xff6F4E37),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      width: widget.w,
                      height: widget.s,
                    ),
                    Container(
                      width: widget.w,
                      height: (widget.h * 6 / 48) - widget.s,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "tarotbilgi",
                                        arguments: {"authdocc": ref});
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: widget.w / 15),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            left: 1,
                                            top: 3,
                                            child: Iconify(
                                                '<svg xmlns="http://www.w3.org/2000/svg" width="0.5em" height="1em" viewBox="0 0 12 24"><path fill="currentColor" fill-rule="evenodd" d="m3.343 12l7.071 7.071L9 20.485l-7.778-7.778a1 1 0 0 1 0-1.414L9 3.515l1.414 1.414z"/></svg>',
                                                size: widget.h / 20,
                                                color: Colors.black)),
                                        Iconify(
                                            '<svg xmlns="http://www.w3.org/2000/svg" width="0.5em" height="1em" viewBox="0 0 12 24"><path fill="currentColor" fill-rule="evenodd" d="m3.343 12l7.071 7.071L9 20.485l-7.778-7.778a1 1 0 0 1 0-1.414L9 3.515l1.414 1.414z"/></svg>',
                                            size: widget.h / 20,
                                            color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Positioned(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Telveli",
                                    style: TextStyle(
                                      fontFamily: "",
                                      fontSize: widget.h * 3.5 / 96,
                                      color: Colors.white,
                                      shadows: const <Shadow>[
                                        Shadow(
                                          offset: Offset(3.0, 3.0),
                                          blurRadius: 3.0,
                                          color: Colors.black54,
                                        ),
                                        Shadow(
                                          offset: Offset(3.0, 3.0),
                                          blurRadius: 8.0,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: widget.h / 50),
                  alignment: Alignment.center,
                  width: widget.w,
                  height: widget.h * 4 / 48,
                  color: const Color(0xffB67233),
                  child: Column(
                    children: [
                      Text(
                          style: TextStyle(
                            fontSize: widget.h * 1.2 / 48,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black54,
                              ),
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 8.0,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          username + ", lütfen dileğinizi dileyip"),
                      Text(
                          style: TextStyle(
                            fontSize: widget.h * 1.2 / 48,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black54,
                              ),
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 8.0,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          "üç kart seçiniz."),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  width: widget.w,
                  height: (widget.h * 38 / 48) - (widget.h / 50),
                  color: const Color(0xffB67233),
                  child: Column(children: [
                    Container(
                      width: widget.w,
                      height: widget.h / 3,
                      color: Color(0xffB67233),
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        controller: _scrollController,
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            height: widget.h / 3,
                            width: (7 *
                                    (widget.w * 12 / 30 +
                                        (10 * ((widget.w * 12 / 30) / 3)))) -
                                ((widget.w) * 2),
                            color: Color(0xffB67233),
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 0,
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                                Positioned(
                                    left: (1 *
                                            (widget.w * 12 / 30 +
                                                (10 *
                                                    ((widget.w * 12 / 30) /
                                                        3)))) -
                                        (1 * (widget.w * 12 / 30) * 2 / 3),
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                                Positioned(
                                    left: (2 *
                                            (widget.w * 12 / 30 +
                                                (10 *
                                                    ((widget.w * 12 / 30) /
                                                        3)))) -
                                        (2 * (widget.w * 12 / 30) * 2 / 3),
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                                Positioned(
                                    left: (3 *
                                            (widget.w * 12 / 30 +
                                                (10 *
                                                    ((widget.w * 12 / 30) /
                                                        3)))) -
                                        (3 * (widget.w * 12 / 30) * 2 / 3),
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                                Positioned(
                                    left: (4 *
                                            (widget.w * 12 / 30 +
                                                (10 *
                                                    ((widget.w * 12 / 30) /
                                                        3)))) -
                                        (4 * (widget.w * 12 / 30) * 2 / 3),
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                                Positioned(
                                    left: (5 *
                                            (widget.w * 12 / 30 +
                                                (10 *
                                                    ((widget.w * 12 / 30) /
                                                        3)))) -
                                        (5 * (widget.w * 12 / 30) * 2 / 3),
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                                Positioned(
                                    left: (6 *
                                            (widget.w * 12 / 30 +
                                                (10 *
                                                    ((widget.w * 12 / 30) /
                                                        3)))) -
                                        (6 * (widget.w * 12 / 30) * 2 / 3),
                                    child: Container(
                                        height: widget.h / 3,
                                        width: (widget.w * 12 / 30 +
                                            (10 * ((widget.w * 12 / 30) / 3))),
                                        child: TarotCard(
                                          draggfunc: () {
                                            flipfunc();
                                          },
                                          widget: widget,
                                          funcone: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functwo: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functhree: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfour: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcfive: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcsix: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcseven: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceight: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funcnine: (x) {
                                            funclist.insert(0, x);
                                          },
                                          functen: (x) {
                                            funclist.insert(0, x);
                                          },
                                          funceleven: (x) {
                                            funclist.insert(0, x);
                                          },
                                        ))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: widget.w,
                        height: widget.h / 10,
                        child: Column(
                          children: [
                            Spacer(),
                            loginbutton(
                                func: () async {
                                  if (falstate == "okunmadı") {
                                    falstate = "bekleme";
                                    var f = card1str.substring(
                                        16, card1str.length - 4);
                                    var s = card2str.substring(
                                        16, card2str.length - 4);
                                    var t = card3str.substring(
                                        16, card3str.length - 4);

                                    if (true) {
                                      startTimer();
                                      await _firestore
                                          .collection('aitext')
                                          .add({
                                        "prompt": f +
                                            "," +
                                            s +
                                            "," +
                                            t +
                                            " tarot kartlarını çekmiş birisinin falını " +
                                            konu +
                                            " anlamda yorumla. normal bir insan ağzıyla konuşuyo gibi yorumla. cümlelerini abartma gerçekçi olsun. karşındaki insanın ismi " +
                                            username +
                                            " onunla konuşuyomuş gibi yorumla ama samimi olma ve sadece ismiyle hitap et o sadece bir müşteri.(150 kelime civarı olun)"
                                      }).then((DocumentReference doc) =>
                                              docid = doc.id);
                                    }
                                  }
                                  if (falstate == "hazır") {
                                    //we are here
                                    howmanycardtheris = 0;
                                    listre = [
                                      "images/lowtarot/ace of cups.png",
                                      "images/lowtarot/ace of pentacles.png",
                                      "images/lowtarot/ace of swords.png",
                                      "images/lowtarot/ace of wands.png",
                                      "images/lowtarot/death.png",
                                      "images/lowtarot/eight of cups.png",
                                      "images/lowtarot/eight of pentacles.png",
                                      "images/lowtarot/eight of swords.png",
                                      "images/lowtarot/eight of wands.png",
                                      "images/lowtarot/five of cups.png",
                                      "images/lowtarot/five of pentacles.png",
                                      "images/lowtarot/five of swords.png",
                                      "images/lowtarot/five of wands.png",
                                      "images/lowtarot/four of cups.png",
                                      "images/lowtarot/four of pentacles.png",
                                      "images/lowtarot/four of swords.png",
                                      "images/lowtarot/four of wands.png",
                                      "images/lowtarot/judgement.png",
                                      "images/lowtarot/justice.png",
                                      "images/lowtarot/king of cups.png",
                                      "images/lowtarot/king of pentacles.png",
                                      "images/lowtarot/king of swords.png",
                                      "images/lowtarot/king of wands.png",
                                      "images/lowtarot/knight of cups.png",
                                      "images/lowtarot/knight of pentacles.png",
                                      "images/lowtarot/knight of swords.png",
                                      "images/lowtarot/knight of wands.png",
                                      "images/lowtarot/nine of cups.png",
                                      "images/lowtarot/nine of pentacles.png",
                                      "images/lowtarot/nine of swords.png",
                                      "images/lowtarot/nine of wands.png",
                                      "images/lowtarot/page of cups.png",
                                      "images/lowtarot/page of pentacles.png",
                                      "images/lowtarot/page of swords.png",
                                      "images/lowtarot/page of wands.png",
                                      "images/lowtarot/queen of cups.png",
                                      "images/lowtarot/queen of pentacles.png",
                                      "images/lowtarot/queen of swords.png",
                                      "images/lowtarot/queen of wands.png",
                                      "images/lowtarot/seven of cups.png",
                                      "images/lowtarot/seven of pentacles.png",
                                      "images/lowtarot/seven of swords.png",
                                      "images/lowtarot/seven of wands.png",
                                      "images/lowtarot/six of cups.png",
                                      "images/lowtarot/six of pentacles.png",
                                      "images/lowtarot/six of swords.png",
                                      "images/lowtarot/six of wands.png",
                                      "images/lowtarot/strength.png",
                                      "images/lowtarot/temperance.png",
                                      "images/lowtarot/ten of cups.png",
                                      "images/lowtarot/ten of pentacles.png",
                                      "images/lowtarot/ten of swords.png",
                                      "images/lowtarot/ten of wands.png",
                                      "images/lowtarot/the chariot.png",
                                      "images/lowtarot/the devil.png",
                                      "images/lowtarot/the emperor.png",
                                      "images/lowtarot/the empress.png",
                                      "images/lowtarot/the fool.jpg",
                                      "images/lowtarot/the hanged man.png",
                                      "images/lowtarot/the hermit.png",
                                      "images/lowtarot/the hierophant.png",
                                      "images/lowtarot/the hight priestess.png",
                                      "images/lowtarot/the lovers.png",
                                      "images/lowtarot/the magician.png",
                                      "images/lowtarot/the moon.png",
                                      "images/lowtarot/the star.png",
                                      "images/lowtarot/the sun.png",
                                      "images/lowtarot/the tower.png",
                                      "images/lowtarot/the worlds.png",
                                      "images/lowtarot/three of cups.png",
                                      "images/lowtarot/three of pentacles.png",
                                      "images/lowtarot/three of swords.png",
                                      "images/lowtarot/three of wands.png",
                                      "images/lowtarot/two of cups.png",
                                      "images/lowtarot/two of pentacles.png",
                                      "images/lowtarot/two of swords.png",
                                      "images/lowtarot/two of wands.png",
                                      "images/lowtarot/wheel of fortune.png",
                                    ];
                                    card1width = 0;
                                    card3width = 0;
                                    card2width = 0;
                                    var c1 = card1str.substring(
                                        16, card1str.length - 4);
                                    var c2 = card2str.substring(
                                        16, card2str.length - 4);
                                    var c3 = card3str.substring(
                                        16, card3str.length - 4);
                                    controller1.toggleCard();
                                    controller2.toggleCard();
                                    controller3.toggleCard();
                                    card1str = "images/tarot back.jpg";
                                    card2str = "images/tarot back.jpg";
                                    card3str = "images/tarot back.jpg";
                                    card1strback = "images/tarot back.jpg";
                                    card2strback = "images/tarot back.jpg";
                                    card3strback = "images/tarot back.jpg";
                                    falstate = "okunmadı";
                                    controller2.toggleCard();
                                    await _firestore
                                        .collection("aitext")
                                        .doc(docid)
                                        .get()
                                        .then((value) {
                                      tarottext = "Tarot Falına Bak";
                                      Navigator.pushNamed(context, "tarotokuma",
                                          arguments: {
                                            "text": value.data()?["response"],
                                            "data": ref,
                                            "card1": c1,
                                            "card2": c2,
                                            "card3": c3
                                          });
                                    });
                                  }
                                },
                                marg: widget.h / 100,
                                text: tarottext,
                                heigh: buttonheight, //widget.h / 20,
                                width: buttonheight * 4)
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(top: widget.h / 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      width: widget.w * 9 / 10,
                      height: widget.h / 4,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(20),
                          dashPattern: [10, 10],
                          color: Colors.white,
                          strokeWidth: 2,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Container(
                                height: widget.h / 4,
                                width: widget.w * 9 / 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: card1width,
                                      child: FlipCard(
                                        flipOnTouch: true,
                                        controller: controller1,
                                        fill: Fill
                                            .fillBack, // Fill the back side of the card to make in the same size as the front.
                                        direction:
                                            FlipDirection.HORIZONTAL, // default
                                        side: (card1str !=
                                                "images/tarot back.jpg")
                                            ? CardSide.BACK
                                            : CardSide
                                                .FRONT, // The side to initially display.
                                        front: Container(
                                            child: Image.asset(card1strback)),
                                        back: Container(
                                            child: Image.asset(card1str)),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      width: card2width,
                                      child: FlipCard(
                                        flipOnTouch: true,

                                        controller: controller2,
                                        fill: Fill
                                            .fillBack, // Fill the back side of the card to make in the same size as the front.
                                        direction:
                                            FlipDirection.HORIZONTAL, // default
                                        side: (card2str !=
                                                "images/tarot back.jpg")
                                            ? CardSide.BACK
                                            : CardSide
                                                .FRONT, // The side to initially display.
                                        front: Container(
                                          child: Container(
                                              child: Image.asset(card2strback)),
                                        ),
                                        back: Container(
                                          child: Container(
                                              child: Image.asset(card2str)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: card3width,
                                      child: FlipCard(
                                        flipOnTouch: true,

                                        controller: controller3,
                                        fill: Fill
                                            .fillBack, // Fill the back side of the card to make in the same size as the front.
                                        direction:
                                            FlipDirection.HORIZONTAL, // default
                                        side: (card3str !=
                                                "images/tarot back.jpg")
                                            ? CardSide.BACK
                                            : CardSide
                                                .FRONT, // The side to initially display.
                                        front: Container(
                                          child: Container(
                                              child: Image.asset(card3strback)),
                                        ),
                                        back: Container(
                                          child: Container(
                                              child: Image.asset(card3str)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                              Positioned(
                                  child: Container(
                                height: widget.h / 4,
                                width: widget.w * 9 / 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        style: TextStyle(
                                          fontSize: widget.h * 1 / 48,
                                          color: Colors.white,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Colors.black54,
                                            ),
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 8.0,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                        dragfintext),
                                  ],
                                ),
                              ))
                            ],
                          )),
                    )
                  ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class loginbutton extends StatelessWidget {
  const loginbutton({
    super.key,
    required this.func,
    required this.marg,
    required this.text,
    required this.heigh,
    required this.width,
  });

  final Function func;
  final String text;
  final double marg;
  final double heigh;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marg),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(3, 4), // Shadow position
            ),
          ]),
      height: heigh,
      width: width,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
        ),
        onPressed: () {
          func();
        },
        child: Text(
          text,
          style: TextStyle(color: Color(0xff6F4E37)),
        ),
      ),
    );
  }
}

class TarotCard extends StatelessWidget {
  const TarotCard({
    super.key,
    required this.widget,
    required this.funcone,
    required this.functwo,
    required this.functhree,
    required this.funcfour,
    required this.funcfive,
    required this.funcsix,
    required this.funcseven,
    required this.funceight,
    required this.funcnine,
    required this.functen,
    required this.funceleven,
    required this.draggfunc,
  });
  final Function draggfunc;
  final Function funcone;
  final Function functwo;
  final Function functhree;
  final Function funcfour;
  final Function funcfive;
  final Function funcsix;
  final Function funcseven;
  final Function funceight;
  final Function funcnine;
  final Function functen;
  final Function funceleven;

  final DesteScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.w * 12 / 30 + (10 * ((widget.w * 12 / 30) / 3)),
      child: Stack(alignment: Alignment.center, children: [
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) -
                (6 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: funceleven),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) -
                (5 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: functen),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) -
                (4 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: funcnine),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) -
                (3 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: funceight),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) -
                (2 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: funcseven),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) -
                ((widget.w * 12 / 30) / 3),
            widget: widget,
            func: funcsix),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)),
            widget: widget,
            func: funcfive),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) +
                ((widget.w * 12 / 30) / 3),
            widget: widget,
            func: funcfour),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) +
                (2 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: functhree),
        SingleCard(
          dragfunc: draggfunc,
          h: widget.h,
          l: (widget.w - ((widget.w * 12 / 30) / 2)) +
              (3 * ((widget.w * 12 / 30) / 3)),
          widget: widget,
          func: funcone,
        ),
        SingleCard(
            dragfunc: draggfunc,
            h: widget.h,
            l: (widget.w - ((widget.w * 12 / 30) / 2)) +
                (4 * ((widget.w * 12 / 30) / 3)),
            widget: widget,
            func: functwo)
      ]),
    );
  }
}

class SingleCard extends StatefulWidget {
  const SingleCard(
      {super.key,
      required this.l,
      required this.widget,
      required this.func,
      required this.dragfunc,
      required this.h});
  final DesteScreen widget;
  final Function dragfunc;
  final double l;
  final Function func;
  final double h;
  @override
  State<SingleCard> createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  GlobalKey key = GlobalKey();
  double angle = 0;
  double wid = 0;
  double topp = 0;

  funcerpos() {
    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double x = position.dx;
    double y = position.dy;
    print(x);
    print(y);
  }

  funcer() {
    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double x = position.dx;
    setState(() {
      angle = (x - ((widget.widget.w / 2) - (widget.widget.w * 6 / 30))) / 1500;
    });
    topp = widget.h / 100 +
        ((((x + widget.widget.w * 6 / 30) - ((widget.widget.w / 2))).abs()) /
            10);
    return "xd";
  }

  @override
  void initState() {
    // TODO: implement initState
    topp = widget.h / 1000;
    wid = widget.widget.w * 12 / 30;
    WidgetsBinding.instance.addPostFrameCallback((_) => funcer());
    widget.func(funcer);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topp,
      left: widget.l,
      child: Container(
        key: key,
        width: wid,
        child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              widget.func(funcer);
            },
            child: Transform.rotate(
                angle: angle,
                child: LongPressDraggable(
                    onDragStarted: () {
                      setState(() {
                        //
                      });
                    },
                    onDragEnd: (x) {
                      if (x.offset.dx + (widget.widget.w * 6 / 30) >
                              pagewidth / 20 &&
                          x.offset.dx + (widget.widget.w * 6 / 30) <
                              pagewidth * 9.5 / 10) {
                        if (x.offset.dy +
                                    (((widget.widget.w * 12 / 30) *
                                            5000 /
                                            3333) /
                                        2) >
                                ((pageheight * 12 / 48) +
                                    (pageheight / 20) +
                                    (pageheight / 3) +
                                    (pageheight / 20)) &&
                            x.offset.dy +
                                    (((widget.widget.w * 12 / 30) *
                                            5000 /
                                            3333) /
                                        2) <
                                ((pageheight * 12 / 48) +
                                    (pageheight / 20) +
                                    (pageheight / 3) +
                                    (pageheight / 20) +
                                    (pageheight / 4))) {
                          //cardrophere
                          wid = 0;

                          widget.dragfunc();
                        } else {
                          wid = widget.widget.w * 12 / 30;
                        }
                      } else {
                        wid = widget.widget.w * 12 / 30;
                      }
                    },
                    feedback: Container(
                        width: widget.widget.w * 12 / 30,
                        child: Image.asset("images/tarot back.jpg")),
                    child: Image.asset("images/tarot back.jpg")))),
      ),
    );
  }
}
