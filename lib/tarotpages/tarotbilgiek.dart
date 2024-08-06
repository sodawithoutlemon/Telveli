import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:telveli/ad_helper.dart';
import 'package:telveli/home.dart';

String faltext = "senisevom";
String text = "";
String docid = "";
double datetop = 0;
String cinsiyet = "Cinsiyet";
String calismaDurumu = "Çalışma Durumu";
String iliskiDurumu = "İlişki Durumu";
Color primary = Color(0xffE38A43);

class TarotBilgiEkScreen extends StatefulWidget {
  const TarotBilgiEkScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double s;
  final double h;
  final double w;

  @override
  _TarotBilgiEkScreenState createState() => _TarotBilgiEkScreenState();
}

String username = "Ad Soyad";
String usermail = "";
String userdate = "Doğum Tarihi";

late var args;

class _TarotBilgiEkScreenState extends State<TarotBilgiEkScreen> {
  @override
  void initState() {
    loadBannerAd();
    datetop = widget.h * 3 - (widget.h / 2.5);
    // TODO: implement initState

    super.initState();
  }

  bool _isLoaded = false;
  BannerAd? _bannerAd;
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize(width: widget.w.toInt(), height: (widget.h / 5.5).toInt()),
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

  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    args = ModalRoute.of(context)?.settings.arguments as Map;
    //args["authdocc"].reference.update({"ad": "winner"});
    var xd = args["authdocc"].data();
    username = xd["ad"];
    usermail = xd["mail"];
    super.didChangeDependencies();
  }

  final storageRef = FirebaseStorage.instance.ref();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Container(
              width: widget.w,
              height: widget.h,
              color: primary,
              child: Column(
                children: [
                  Container(
                    width: widget.w,
                    height: widget.s,
                  ),
                  Container(
                    width: widget.w,
                    height: (widget.h * 4 / 48),
                    decoration: const BoxDecoration(
                        color: const Color(0xff6F4E37),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ]),
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
                                          top: 3,
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
                  ),
                  Container(
                    width: widget.w,
                    height: widget.h - (widget.s) - (widget.h * 4 / 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: widget.h / 40, bottom: widget.h / 40),
                          child: Text(
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
                              "Bilgilerinizi girin."),
                        ),
                        loginField(
                            text: username,
                            heigh: widget.h / 22,
                            func: (x) {
                              setState(() {
                                username = x;
                              });
                            },
                            width: widget.w * 7 / 10),
                        loginField(
                            text: cinsiyet,
                            heigh: widget.h / 22,
                            func: (x) {
                              setState(() {
                                cinsiyet = x;
                              });
                            },
                            width: widget.w * 7 / 10),
                        Container(
                          margin: EdgeInsets.only(bottom: widget.h / 40),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6,
                                  offset: Offset(3, 4), // Shadow position
                                ),
                              ]),
                          height: widget.h / 22,
                          width: widget.w * 7 / 10,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                                datetop = widget.h - (widget.h / 3);
                              });
                            },
                            child: Row(children: [
                              Text(
                                userdate,
                                style: TextStyle(
                                    fontSize: widget.h / 20 * 18 / 60,
                                    color: Color(0xff6F4E37)),
                              ),
                              Spacer(),
                              Iconify(
                                  size: widget.h / 20 / 2,
                                  color: Color(0xff6F4E37),
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 16 16"><path fill="currentColor" d="M13.8 2.2a2.51 2.51 0 0 0-3.54 0l-6.9 6.91l-1.76 3.62a1.26 1.26 0 0 0 1.12 1.8a1.23 1.23 0 0 0 .55-.13l3.62-1.76l6-6l.83-.82l.06-.06a2.52 2.52 0 0 0 .02-3.56m-.89.89a1.25 1.25 0 0 1 0 1.77l-1.77-1.77a1.24 1.24 0 0 1 .86-.37a1.22 1.22 0 0 1 .91.37M2.73 13.27L4.29 10L6 11.71zm4.16-2.4L5.13 9.11L10.26 4L12 5.74z"/></svg>')
                            ]),
                          ),
                        ),
                        loginField(
                            text: calismaDurumu,
                            heigh: widget.h / 20,
                            func: (x) {
                              setState(() {
                                calismaDurumu = x;
                              });
                            },
                            width: widget.w * 7 / 10),
                        loginField(
                            text: iliskiDurumu,
                            heigh: widget.h / 22,
                            func: (x) {
                              setState(() {
                                iliskiDurumu = x;
                              });
                            },
                            width: widget.w * 7 / 10),
                        loginbutton(
                            func: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (userdate == "Doğum Tarihi") {
                                userdate = "01/01/2000";
                              }
                              Navigator.pushNamed(context, 'tarotbilgi',
                                  arguments: {
                                    "authdocc": ref,
                                    "tbilgi": {
                                      "isim": username,
                                      "cins": cinsiyet,
                                      "tar": userdate,
                                      "cal": calismaDurumu,
                                      "ilis": iliskiDurumu,
                                    },
                                  });
                            },
                            marg: widget.h / 30,
                            text: "Kaydet",
                            heigh: widget.h / 20,
                            width: widget.w / 2),
                        Container(
                          alignment: Alignment.center,
                          child: (_bannerAd != null)
                              ? Container(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!))
                              : null,
                          margin: EdgeInsets.only(top: widget.h / 44),
                          width: widget.w,
                          height: widget.h / 5,
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: datetop,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                ),
                width: widget.w,
                height: widget.h / 3,
                child: Column(
                  children: [
                    Spacer(),
                    loginbutton(
                        func: () {
                          setState(() {
                            FocusManager.instance.primaryFocus?.unfocus();

                            datetop = widget.h * 3 - (widget.h / 3);
                          });
                        },
                        marg: 0,
                        text: "Onayla",
                        heigh: widget.h / 20,
                        width: widget.w / 4),
                    Spacer(),
                    Container(
                      width: widget.w,
                      height: (widget.h / 2.9) * 5 / 10,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime(2023, 1, 1),
                        onDateTimeChanged: (DateTime newDateTime) {
                          // Do something
                          setState(() {
                            var test = newDateTime.toString().substring(8, 10) +
                                "/" +
                                newDateTime.toString().substring(5, 7) +
                                "/" +
                                newDateTime.toString().substring(0, 4);
                            userdate = test;
                          });
                        },
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ))
        ],
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
      margin: EdgeInsets.only(bottom: marg, top: marg),
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

class loginField extends StatelessWidget {
  const loginField({
    super.key,
    required this.text,
    required this.heigh,
    required this.func,
    required this.width,
  });

  final Function func;
  final String text;
  final double heigh;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: heigh / 2),
      height: heigh,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(3, 4), // Shadow position
            ),
          ]),
      width: width,
      child: Stack(
        children: [
          TextField(
            maxLength: 20,
            autofocus: false,
            onChanged: (value) {
              func(value);
            },
            style: TextStyle(
              color: Color(0xff6F4E37),
              fontSize: heigh * 18 / 60,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              counterText: "",
              hintText: text,
              hintStyle: TextStyle(
                color: Color(0xff6F4E37),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: primary, width: 0.0),
              ),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 0.0),
                  borderRadius: BorderRadius.circular(20)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: primary, width: 0.0),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            width: width,
            height: heigh,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Iconify(
                      size: heigh / 2,
                      color: Color(0xff6F4E37),
                      '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 16 16"><path fill="currentColor" d="M13.8 2.2a2.51 2.51 0 0 0-3.54 0l-6.9 6.91l-1.76 3.62a1.26 1.26 0 0 0 1.12 1.8a1.23 1.23 0 0 0 .55-.13l3.62-1.76l6-6l.83-.82l.06-.06a2.52 2.52 0 0 0 .02-3.56m-.89.89a1.25 1.25 0 0 1 0 1.77l-1.77-1.77a1.24 1.24 0 0 1 .86-.37a1.22 1.22 0 0 1 .91.37M2.73 13.27L4.29 10L6 11.71zm4.16-2.4L5.13 9.11L10.26 4L12 5.74z"/></svg>')
                ]),
          )
        ],
      ),
    );
  }
}
