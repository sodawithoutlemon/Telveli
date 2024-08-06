import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'package:material_symbols_icons/symbols.dart';
import 'package:telveli/ad_helper.dart';
import 'package:telveli/falpages/turkfal.dart';

String okunansoru = "15";
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
Color primary = Color(0xffE38A43);
String sorutext = "";
double desentop = 0;
String sorusortext = "Fal hakkında soru sor";
double buttonad = 0;
double soruheight = 0;
double soruwidth = 0;

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
String sorudocid = "";
int min = 0;
late DateTime insert;

String sorusorstate = "soruyok";
late var _controller;

class _TrFalOkumaScreenState extends State<TrFalOkumaScreen> {
  @override
  void initState() {
    okunansoru = "15";
    loadBannerAd();
    loadRewAd();
    loadAd();
    _controller = TextEditingController();
    okumatop = 0;
    anabilgiheight = widget.h / 8;
    getUser();
    reklamheight = widget.h * 15 / 48;
    reklamizleheight = widget.h / 20;
    sorgulaheight = widget.h / 20;
    soruheight = widget.h / 20;
    soruwidth = widget.w * 8 / 10;
    buttonad = widget.h / 20;

    desentop = (widget.h / 20) + (widget.h / 16) - (widget.w / 3);

    super.initState();
  }

  late User loggedin;
  bool _isLoaded = false;
  BannerAd? _bannerAd;

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  InterstitialAd? _interstitialAd;

  RewardedAd? _rewardedAd;

  void loadRewAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              loadRewAd();
            },
          );
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          setState(() {
            _rewardedAd = ad;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize(width: widget.w.toInt(), height: (widget.h / 10.3).toInt()),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffD2691E),
              Color(0xffcc8052),
              Color(0xffe19c7b),
              Color(0xffe19c7b),
              Color(0xffe19c7b),
              Color(0xffde9870),
              Color(0xffcc8052),
              Color(0xffD2691E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: widget.w, height: widget.s),
            Container(
              width: widget.w,
              height: widget.h * 4 / 48,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff8a674c),
                      Color(0xff946b4e),
                      Color(0xff886248),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ]),
              child: Container(
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
                              margin: EdgeInsets.only(left: widget.w / 15),
                              child: Stack(
                                children: [
                                  Positioned(
                                      left: 1,
                                      top: 2,
                                      child: Iconify(
                                          '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="black" d="M20 11H7.83l5.59-5.59L12 4l-8 8l8 8l1.41-1.41L7.83 13H20z"/></svg>',
                                          size: widget.h / 20,
                                          color: Colors.black)),
                                  Iconify(
                                      '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="black" d="M20 11H7.83l5.59-5.59L12 4l-8 8l8 8l1.41-1.41L7.83 13H20z"/></svg>',
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
                                fontSize: widget.h * 5 / 96,
                                fontFamily: "xd",
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
              ),
            ),
            Container(
              width: widget.w,
              height: widget.h - (widget.s) - (widget.h * 4 / 48),
              child: Stack(
                children: [
                  Positioned(
                      left: widget.w / 2 - (widget.w / 3),
                      top: desentop,
                      child: Container(
                        width: widget.w / 1.5,
                        height: widget.w / 1.5,
                        child: Lottie.asset("assets/u.json"),
                      )),
                  Positioned(
                    child: Container(
                      width: widget.w,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: widget.h / 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff8a674c),
                                    Color(0xff946b4e),
                                    Color(0xff886248),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
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
                                print(key);
                                if (key) {
                                  await _firestore
                                      .collection("generate")
                                      .doc(docid)
                                      .get()
                                      .then((value) {
                                    okunanfal = value.data()?["output"];
                                  });

                                  setState(() {
                                    sorgulaheight = 0;

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
                                _interstitialAd?.show();
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
                              width: widget.w * 5 / 10),
                          loginbutton(
                              func: () async {
                                _rewardedAd?.show(
                                    onUserEarnedReward: (_, reward) async {
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
                                });
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
                      top: (okunanfal == "") ? widget.h / 2 : 0,
                      left: 0,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: widget.h / 40, top: widget.h / 40),
                        height: widget.h / 10,
                        width: widget.w,
                        alignment: Alignment.center,
                        child: (_bannerAd != null)
                            ? Container(
                                width: _bannerAd!.size.width.toDouble(),
                                height: _bannerAd!.size.height.toDouble(),
                                child: AdWidget(ad: _bannerAd!))
                            : null,
                      )),
                  Positioned(
                      child: Container(
                    width: widget.w,
                    height: (okunanfal != "")
                        ? widget.h - (widget.s) - (widget.h * 4 / 48)
                        : 0,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: widget.h / 40,
                            top: widget.h / 40,
                          ),
                          width: (okunanfal == "") ? 0 : widget.w,
                          height: (okunanfal == "") ? 0 : widget.h / 10,
                        ),
                        Container(
                          width: widget.w * 10 / 10,
                          height: widget.h -
                              ((widget.h / 10) +
                                  (widget.h / 20) +
                                  (widget.s) +
                                  (widget.h * 4 / 48)),
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            children: [
                              Center(
                                  child: Container(
                                margin: (okunansoru.length > 5)
                                    ? EdgeInsets.only(bottom: widget.h / 40)
                                    : EdgeInsets.all(0),
                                height: soruheight,
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
                                width: soruwidth,
                                child: Stack(
                                  children: [
                                    TextField(
                                      readOnly: (sorusorstate == "soruyok")
                                          ? false
                                          : true,
                                      autofocus: false,
                                      onChanged: (value) {
                                        sorutext = value;
                                      },
                                      controller: _controller,
                                      style: TextStyle(
                                        color: Color(0xff6F4E37),
                                        fontSize: (widget.h / 20) * 18 / 60,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: sorusortext,
                                        hintStyle: TextStyle(
                                          color: Color(0xff6F4E37),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Color(0xff6F4E37),
                                              width: 0.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff6F4E37),
                                                width: 0.0),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff6F4E37),
                                                width: 0.0),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff6F4E37),
                                              width: 0.0),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: widget.w * 8 / 10 - widget.h / 20,
                                      child: Container(
                                        width: buttonad,
                                        height: buttonad,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(0)),
                                          onPressed: () async {
                                            _rewardedAd?.show(
                                                onUserEarnedReward:
                                                    (_, reward) async {
                                              if (sorusorstate == "soruyok") {
                                                setState(() {
                                                  soruwidth = 0;
                                                  soruheight = 0;
                                                  sorusorstate = "hold";
                                                  _controller.clear();
                                                });
                                                var _start = 15;
                                                const oneSec =
                                                    const Duration(seconds: 1);
                                                Timer.periodic(
                                                  oneSec,
                                                  (Timer timer) {
                                                    if (_start == 0) {
                                                      setState(() async {
                                                        await _firestore
                                                            .collection(
                                                                "aitext")
                                                            .doc(sorudocid)
                                                            .get()
                                                            .then((value) {
                                                          setState(() {
                                                            okunansoru =
                                                                value.data()?[
                                                                    "response"];
                                                            sorusorstate =
                                                                "soruyok";
                                                            soruheight =
                                                                widget.h / 20;
                                                            soruwidth =
                                                                widget.w *
                                                                    8 /
                                                                    10;
                                                          });
                                                        });
                                                        timer.cancel();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        okunansoru =
                                                            _start.toString();
                                                        _start--;
                                                      });
                                                    }
                                                  },
                                                );
                                                await _firestore
                                                    .collection('aitext')
                                                    .add({
                                                  "prompt": " (( " +
                                                      okunanfal +
                                                      " )) gibi bir türk kahvesi falı okundu ve müşteri ((" +
                                                      sorutext +
                                                      ")) sorusunu sordu cevap ver. (normal bir insan ağzıyla konuşuyo gibi yorumla. cümlelerini abartma gerçekçi olsun. samimi olma ve sadece ismiyle hitap et o sadece bir müşteri)",
                                                }).then((DocumentReference
                                                            doc) =>
                                                        sorudocid = doc.id);
                                              }
                                            });
                                          },
                                          child: Iconify(
                                            color: Color(0xff6F4E37),
                                            '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="black" d="M8 7.71L18 12L8 16.29v-3.34l7.14-.95L8 11.05zM12 2a10 10 0 0 1 10 10a10 10 0 0 1-10 10A10 10 0 0 1 2 12A10 10 0 0 1 12 2m0 2a8 8 0 0 0-8 8a8 8 0 0 0 8 8a8 8 0 0 0 8-8a8 8 0 0 0-8-8"/></svg>',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff8a674c),
                                          Color(0xff946b4e),
                                          Color(0xff886248),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
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
                                  width: (okunansoru == "15")
                                      ? 0
                                      : widget.w * 9 / 10,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  child: (okunansoru == "15")
                                      ? null
                                      : Text(
                                          textAlign: TextAlign.center,
                                          okunansoru,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: (okunansoru != "")
                                      ? EdgeInsets.only(top: widget.h / 40)
                                      : EdgeInsets.only(top: 0),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff8a674c),
                                          Color(0xff946b4e),
                                          Color(0xff886248),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
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
                              ),
                              Center(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(bottom: widget.h / 10),
                                  child: loginbutton(
                                    func: () async {
                                      setState(() {
                                        okunanfal = "";
                                      });

                                      await ref.reference.update({
                                        "aktiffaltarih": "yok",
                                        "aktifkahvefalı": "yok",
                                      });
                                      Navigator.pushNamed(context, "home");
                                    },
                                    marg: widget.h / 20,
                                    text: "Kaydet ve çık",
                                    heigh:
                                        (okunanfal == "") ? 0 : widget.h / 20,
                                    width: widget.w * 8 / 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
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
