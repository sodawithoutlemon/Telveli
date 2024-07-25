import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:material_symbols_icons/symbols.dart';
import 'package:telveli/falpages/turkfal.dart';

String mailforauth = "";
String text = "";
int coinnumber = 0;
double nameheightt = 0;
double kahvecointop = 10000;

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double h;
  final double w;
  final double s;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String falstate = "";
String kahvefal = "Kahve Falı";

late var ref;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    kahvecointop = widget.h * 2;
    nameheightt = widget.h * 1 / 48;
    // TODO: implement initState
    getUser();
    text = loggedin.email!;
    _firestore.collection("bilgiler").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["mail"] == text) {
          setState(() {
            ref = doc;
            text = doc.data()["ad"];
            coinnumber = doc.data()["coin"];
          });
          falstate = doc.data()["aktifkahvefalı"];
          if (doc.data()["aktifkahvefalı"] != "yok") {
            setState(() {
              kahvefal = "Falınız inceleniyor";
            });
          }
        }
      }
    });

    super.initState();
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late User loggedin;

  void getUser() {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        loggedin = user;
        mailforauth = loggedin.email!;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: widget.w,
        height: widget.h,
        color: const Color(0xffB67233),
        child: Stack(
          children: [
            Positioned(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: widget.h * 1.2 / 96,
                                      left: widget.w * 1.5 / 24),
                                  child: Text(
                                    "Telveli",
                                    style: TextStyle(
                                      fontFamily: "xd",
                                      fontSize: widget.h * 5 / 96,
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
                                Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      coinnumber += 1;
                                    });
                                    await _firestore
                                        .collection("bilgiler")
                                        .get()
                                        .then((event) {
                                      for (var doc in event.docs) {
                                        if (doc.data()["mail"] == mailforauth) {
                                          doc.reference
                                              .update({"coin": coinnumber});
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: (widget.w * 1.5 / 24) -
                                            ((widget.h * 4 / 48 -
                                                    widget.h * 4.5 / 96) /
                                                2)),
                                    width: widget.h * 4 / 48,
                                    height: widget.h * 4 / 48,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Positioned(
                                            left: (widget.h * 4 / 96) -
                                                (widget.h * 4.5 / 192),
                                            top: (widget.h * 4 / 96) -
                                                (widget.h * 4.5 / 192),
                                            child: Container(
                                                height: widget.h * 4.5 / 96,
                                                width: widget.h * 4.5 / 96,
                                                child: Image.asset(
                                                    "images/coins-512.png"))),
                                        Positioned(
                                            child: Text(
                                          coinnumber.toString(),
                                          style: TextStyle(
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
                                              color: Color(0xffF3C70D),
                                              fontSize: widget.h * 3 / 96),
                                        )),
                                      ],
                                    ),
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
                        margin: EdgeInsets.only(left: widget.w * 1.5 / 24),
                        alignment: Alignment.bottomLeft,
                        width: widget.w,
                        height: widget.h * 2.5 / 48,
                        color: const Color(0xffB67233),
                        child: Row(
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
                                "Hoş geldin, " + text),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(0),
                        width: widget.w,
                        height: widget.h * 35.5 / 48,
                        color: const Color(0xffB67233),
                        child: ListView(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                pageButton(
                                  height: widget.h / 9,
                                  width: widget.w * 10 / 24,
                                  textt: "Kahve Falı",
                                  func: () {
                                    if (falstate == "yok") {
                                      setState(() {
                                        kahvecointop = widget.h / 2;
                                      });
                                    } else {
                                      Navigator.pushNamed(
                                          context, "trfalokuma");
                                    }
                                  },
                                  tm: 0,
                                  lm: widget.w * 1.5 / 24,
                                  bm: widget.h / 25,
                                  rm: widget.w * 0.5 / 24,
                                ),
                                pageButton(
                                  height: widget.h / 9,
                                  width: widget.w * 10 / 24,
                                  textt: "Tarot Falı",
                                  func: () {
                                    Navigator.pushNamed(context, 'tarotbilgi',
                                        arguments: {"authdocc": ref});
                                  },
                                  tm: 0,
                                  lm: widget.w * 0.5 / 24,
                                  bm: widget.h / 25,
                                  rm: widget.w * 1.5 / 24,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                pageButton(
                                  height: widget.h / 9,
                                  width: widget.w * 10 / 24,
                                  textt: "Rüya Yorumlama",
                                  func: () {},
                                  tm: 0,
                                  lm: widget.w * 1.5 / 24,
                                  bm: 0,
                                  rm: widget.w * 0.5 / 24,
                                ),
                                pageButton(
                                  height: widget.h / 9,
                                  width: widget.w * 10 / 24,
                                  textt: "Günlük Burç Yorumu",
                                  func: () {},
                                  tm: 0,
                                  lm: widget.w * 0.5 / 24,
                                  bm: 0,
                                  rm: widget.w * 1.5 / 24,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: widget.w,
                    height: widget.h * 4 / 48,
                    color: const Color(0xff6F4E37),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                top: kahvecointop,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45)),
                    color: Colors.black,
                  ),
                  width: widget.w,
                  height: widget.h / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              kahvecointop = widget.h * 2;
                            });
                          },
                          child: Container(
                              width: widget.w / 4,
                              height: widget.h / 30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.black),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      width: widget.w * 90 / 400,
                                      height: widget.h / 150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.white))
                                ],
                              )),
                        ),
                        margin: EdgeInsets.only(bottom: widget.h / 20),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: widget.h / 100),
                        child: Text(
                          "Kahve Falı",
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.h / 40),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: widget.h / 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              width: widget.h / 40,
                              height: widget.h / 40,
                              child: Image.asset("images/coins-512.png"),
                            ),
                            Text(
                              "1 jeton",
                              style: TextStyle(
                                  color: Colors.white, fontSize: widget.h / 50),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: widget.h / 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: widget.h / 22,
                        width: widget.w * 7 / 10,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () async {
                            if (coinnumber > 0) {
                              setState(() {
                                coinnumber -= 1;
                              });
                              await _firestore
                                  .collection("bilgiler")
                                  .get()
                                  .then((event) {
                                for (var doc in event.docs) {
                                  if (doc.data()["mail"] == mailforauth) {
                                    doc.reference.update({"coin": coinnumber});
                                  }
                                }
                              });
                              Navigator.pushNamed(context, 'trfalbilgi',
                                  arguments: {"authdocc": ref});
                            }
                          },
                          child: Text(
                            "Jetonumu Kullan",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: widget.h / 40),
                        child: Text(
                          "ya da",
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.h / 50),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: widget.h / 22,
                        width: widget.w * 7 / 10,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'turkfal');
                          },
                          child: Text(
                            "Reklam İzle Jeton Kazan",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class pageButton extends StatelessWidget {
  const pageButton({
    super.key,
    required this.width,
    required this.height,
    required this.func,
    required this.lm,
    required this.tm,
    required this.bm,
    required this.rm,
    required this.textt,
  });

  final double width;
  final double height;
  final String textt;
  final Function func;
  final double lm;
  final double rm;
  final double bm;
  final double tm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: lm, top: tm, bottom: bm, right: rm),
      height: height,
      width: width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(3, 4), // Shadow position
            ),
          ]),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: WidgetStateProperty.all(Colors.white),
        ),
        onPressed: () {
          func();
        },
        child: Text(
          textt,
          style: const TextStyle(color: Color(0xff6F4E37)),
        ),
      ),
    );
  }
}
