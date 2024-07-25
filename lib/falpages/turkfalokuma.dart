import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';
import 'package:material_symbols_icons/symbols.dart';
import 'package:telveli/falpages/turkfal.dart';

String okunanfal = "";
String text1 = "";
String text2 = "";
String textstate = "";
bool key = false;
double reklamizleheight = 0;
double anabilgiheight = 0;
double reklamheight = 0;
double sorgulaheight = 0;
double okumatop = 0;

class TrFalOkumaScreen extends StatefulWidget {
  const TrFalOkumaScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double h;
  final double w;
  final double s;

  @override
  _TrFalOkumaScreenState createState() => _TrFalOkumaScreenState();
}

late QueryDocumentSnapshot ref;
late String tarih;
late var docid;
int min = 0;
late DateTime insert;

class _TrFalOkumaScreenState extends State<TrFalOkumaScreen> {
  @override
  void initState() {
    okumatop = 0;
    anabilgiheight = widget.h / 8;
    getUser();
    reklamheight = widget.h * 15 / 48;
    reklamizleheight = widget.h / 20;
    sorgulaheight = widget.h / 20;

    super.initState();
  }

  late User loggedin;

  void getUser() async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        loggedin = user;
        await _firestore.collection("bilgiler").get().then((event) {
          for (var doc in event.docs) {
            if (doc.data()["mail"] == loggedin.email) {
              ref = doc;
              print(doc.data());
              setState(() {
                tarih = doc.data()["aktiffaltarih"];
                docid = doc.data()["aktifkahvefalı"];
                insert = DateTime(
                  int.parse(tarih.substring(0, 4)),
                  int.parse(tarih.substring(5, 7)),
                  int.parse(tarih.substring(8, 10)),
                  int.parse(tarih.substring(11, 13)),
                  int.parse(tarih.substring(14, 16)),
                );
                DateTime now = DateTime.now();
                var min = now.difference(insert).inMinutes;
                if (min < 4) {
                  setState(() {
                    text1 = "Falınız sırada.";
                    text2 =
                        "Yorumcularımız en kısa sürede falınızı yorumlayacak.";
                    textstate = "Sırada";
                  });
                }
                if (min > 3 && min < 7) {
                  setState(() {
                    reklamizleheight = 0;

                    text1 = "Falınız bize ulaşmıştır.";
                    text2 = "Yorumcularımız falınızı yorumluyor.";
                    textstate = "Yorumlanıyor";
                  });
                }
                if (min > 6 && min < 10) {
                  setState(() {
                    reklamizleheight = widget.h / 20;
                    text1 = "Fal yorumunuz hazırlanıyor.";
                    text2 = "Yorumcularımız son düzenlemeleri yapıyor.";
                    textstate = "Yükleniyor";
                  });
                }
                if (min > 9) {
                  setState(() {
                    reklamheight = widget.h * 25 / 48;
                    text1 = "Fal yorumunuz hazır.";
                    text2 = "Okumak için tıklayın.";
                    textstate = "Yorumlandı";
                    key = true;
                    sorgulaheight = 0;
                    reklamizleheight = 0;
                  });
                }
              });
            }
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
                                    Navigator.pushNamed(context, "home");
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
                                  margin: EdgeInsets.only(
                                    top: widget.h * 1.2 / 96,
                                  ),
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
            Container(
              width: widget.w,
              height: widget.h * 42 / 48,
              color: Color(0xffB67233),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: widget.w,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: widget.h / 20),
                            decoration: BoxDecoration(
                                color: Color(0xff6F4E37),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                    offset: Offset(3, 4), // Shadow position
                                  ),
                                ]),
                            height: (okunanfal == "") ? anabilgiheight : 0,
                            width: (okunanfal == "") ? widget.w * 9 / 10 : 0,
                            child: TextButton(
                              onPressed: () async {
                                if (key) {
                                  await _firestore
                                      .collection("generate")
                                      .doc(docid)
                                      .get()
                                      .then((value) {
                                    okunanfal = value.data()?["output"];
                                  });

                                  setState(() {
                                    anabilgiheight = 0;
                                    reklamheight = widget.h * 4 / 48;
                                    okumatop = widget.h * 26 / 48;
                                  });
                                  print(tarih);
                                  print(docid);
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    child: Row(
                                      children: [
                                        Text(
                                            style: TextStyle(
                                              fontSize: widget.h * 0.8 / 48,
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black54,
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 8.0,
                                                  color: Colors.black54,
                                                ),
                                              ],
                                            ),
                                            text1),
                                        Spacer(),
                                        Text(
                                            style: TextStyle(
                                              fontSize: widget.h * 1 / 48,
                                              color: Color(0xffF3C70D),
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black54,
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 8.0,
                                                  color: Colors.black54,
                                                ),
                                              ],
                                            ),
                                            textstate),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                      style: TextStyle(
                                        fontSize: widget.h * 0.8 / 48,
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color: Colors.black54,
                                          ),
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 8.0,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      text2),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          loginbutton(
                              func: () async {
                                DateTime now = DateTime.now();

                                var user = _auth.currentUser;
                                if (user != null) {
                                  loggedin = user;
                                  var _fire = FirebaseFirestore.instance;
                                  await _fire
                                      .collection("bilgiler")
                                      .get()
                                      .then((event) {
                                    for (var doc in event.docs) {
                                      if (doc.data()["mail"] ==
                                          loggedin.email) {
                                        tarih = doc.data()["aktiffaltarih"];

                                        insert = DateTime(
                                          int.parse(tarih.substring(0, 4)),
                                          int.parse(tarih.substring(5, 7)),
                                          int.parse(tarih.substring(8, 10)),
                                          int.parse(tarih.substring(11, 13)),
                                          int.parse(tarih.substring(14, 16)),
                                        );
                                      }
                                    }
                                  });
                                }

                                var min = now.difference(insert).inMinutes;
                                if (min < 4) {
                                  setState(() {
                                    text1 = "Falınız sırada.";
                                    text2 =
                                        "Yorumcularımız en kısa sürede falınızı yorumlayacak.";
                                    textstate = "Sırada";
                                  });
                                }
                                if (min > 3 && min < 7) {
                                  setState(() {
                                    reklamizleheight = 0;
                                    text1 = "Falınız bize ulaşmıştır.";
                                    text2 =
                                        "Yorumcularımız falınızı yorumluyor.";
                                    textstate = "Yorumlanıyor";
                                  });
                                }
                                if (min > 6 && min < 10) {
                                  setState(() {
                                    reklamizleheight = widget.h / 20;
                                    text1 = "Fal yorumunuz hazırlanıyor.";
                                    text2 =
                                        "Yorumcularımız son düzenlemeleri yapıyor.";
                                    textstate = "Yükleniyor";
                                  });
                                }
                                if (min > 9) {
                                  setState(() {
                                    reklamheight = widget.h * 15 / 48;
                                    text1 = "Fal yorumunuz hazır.";
                                    text2 = "Okumak için tıklayın.";
                                    textstate = "Yorumlandı";
                                    key = true;
                                    sorgulaheight = 0;
                                    reklamizleheight = 0;
                                  });
                                }
                              },
                              marg: widget.h / 20,
                              text: "Tekrar Sorgula",
                              heigh: sorgulaheight,
                              width: widget.w * 3 / 10),
                          loginbutton(
                              func: () async {
                                var user = _auth.currentUser;
                                if (user != null) {
                                  loggedin = user;
                                  var _fire = FirebaseFirestore.instance;
                                  await _fire
                                      .collection("bilgiler")
                                      .get()
                                      .then((event) {
                                    for (var doc in event.docs) {
                                      if (doc.data()["mail"] ==
                                          loggedin.email) {
                                        tarih = doc.data()["aktiffaltarih"];

                                        insert = DateTime(
                                          int.parse(tarih.substring(0, 4)),
                                          int.parse(tarih.substring(5, 7)),
                                          int.parse(tarih.substring(8, 10)),
                                          int.parse(tarih.substring(11, 13)),
                                          int.parse(tarih.substring(14, 16)),
                                        );
                                      }
                                    }
                                  });
                                }
                                print(insert);
                                await ref.reference.update({
                                  "aktiffaltarih": insert
                                      .subtract(Duration(minutes: 5))
                                      .toString()
                                });
                                print(insert.subtract(Duration(minutes: 5)));
                                DateTime now = DateTime.now();
                                var min = now.difference(insert).inMinutes;
                                if (min < 4) {
                                  setState(() {
                                    text1 = "Falınız sırada.";
                                    text2 =
                                        "Yorumcularımız en kısa sürede falınızı yorumlayacak.";
                                    textstate = "Sırada";
                                  });
                                }
                                if (min > 3 && min < 7) {
                                  setState(() {
                                    reklamizleheight = 0;
                                    text1 = "Falınız bize ulaşmıştır.";
                                    text2 =
                                        "Yorumcularımız falınızı yorumluyor.";
                                    textstate = "Yorumlanıyor";
                                  });
                                }
                                if (min > 6 && min < 10) {
                                  setState(() {
                                    reklamizleheight = widget.h / 20;
                                    text1 = "Fal yorumunuz hazırlanıyor.";
                                    text2 =
                                        "Yorumcularımız son düzenlemeleri yapıyor.";
                                    textstate = "Yükleniyor";
                                  });
                                }
                                if (min > 9) {
                                  setState(() {
                                    reklamheight = widget.h * 15 / 48;
                                    text1 = "Fal yorumunuz hazır.";
                                    text2 = "Okumak için tıklayın.";
                                    textstate = "Yorumlandı";
                                    key = true;
                                    sorgulaheight = 0;
                                    reklamizleheight = 0;
                                  });
                                }
                              },
                              marg: widget.h / 20,
                              text: "Hızlandırmak için reklam izle",
                              heigh: reklamizleheight,
                              width: widget.w * 7 / 10)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      child: Container(
                    width: widget.w,
                    height: widget.h * 42 / 48,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(bottom: widget.h / 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6,
                                  offset: Offset(3, 4), // Shadow position
                                ),
                              ]),
                          height: (okunanfal == "") ? reklamheight : 0,
                          width: (okunanfal == "") ? widget.w * 8 / 10 : 0,
                          alignment: Alignment.center,
                          child: Text(
                            "reklam",
                            style: TextStyle(color: Color(0xff6F4E37)),
                          ),
                        )
                      ],
                    ),
                  )),
                  Positioned(
                      child: Container(
                          alignment: Alignment.topCenter,
                          width: widget.w * 10 / 10,
                          height: widget.h * 42 / 48,
                          child: Container(
                            width: widget.w * 9 / 10,
                            height: widget.h * 42 / 48,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text("Reklam"),
                                  margin: EdgeInsets.only(
                                    bottom: widget.h / 100,
                                    top: widget.h / 50,
                                  ),
                                  width:
                                      (okunanfal == "") ? 0 : widget.w * 9 / 10,
                                  height: (okunanfal == "") ? 0 : widget.h / 12,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 6,
                                          offset:
                                              Offset(3, 4), // Shadow position
                                        ),
                                      ]),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: widget.h / 100),
                                  decoration: BoxDecoration(
                                      color: Color(0xff6F4E37),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 6,
                                          offset:
                                              Offset(3, 4), // Shadow position
                                        ),
                                      ]),
                                  width:
                                      (okunanfal == "") ? 0 : widget.w * 9 / 10,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    okunanfal,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                loginbutton(
                                    func: () async {
                                      setState(() {
                                        okunanfal = "";
                                      });

                                      await ref.reference.update({
                                        "aktiffaltarih": "",
                                        "aktifkahvefalı": "yok",
                                      });
                                      Navigator.pushNamed(context, "home");
                                    },
                                    marg: widget.h / 40,
                                    text: "Kaydet ve çık",
                                    heigh:
                                        (okunanfal == "") ? 0 : widget.h / 20,
                                    width: widget.w * 8 / 10)
                              ],
                            ),
                          ))),
                ],
              ),
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
      margin: EdgeInsets.only(top: marg),
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
