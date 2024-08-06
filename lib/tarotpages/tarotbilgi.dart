import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';
import 'package:material_symbols_icons/symbols.dart';
import 'package:telveli/ad_helper.dart';

String mailforauth = "";
String text = "";
Color primary = Color(0xffE38A43);

class TarotBilgiScreen extends StatefulWidget {
  const TarotBilgiScreen({
    super.key,
    required this.h,
    required this.w,
    required this.s,
  });

  final double h;
  final double w;
  final double s;

  @override
  _TarotBilgiScreenState createState() => _TarotBilgiScreenState();
}

late var ref;
late var xd;
late var throww;
String username = "";
String usermail = "";
var bilgiler = {};

class _TarotBilgiScreenState extends State<TarotBilgiScreen> {
  @override
  void initState() {
    loadBannerAd();
    var pageheight = widget.h;
    var pagewidth = widget.w;
    // TODO: implement initState
    super.initState();
  }

  bool _isLoaded = false;
  BannerAd? _bannerAd;

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    super.dispose();
  }

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

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments as Map;
    print("bilgi");
    print(args);
    throww = args;
    ref = args["authdocc"];
    if (args["tbilgi"] != null) {
      bilgiler = args["tbilgi"];
      setState(() {
        username = bilgiler["isim"];
      });
    }
    //args["authdocc"].reference.update({"ad": "winner"});
    xd = args["authdocc"].data();
    username = xd["ad"];
    usermail = xd["mail"];
    super.didChangeDependencies();
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
        color: primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: widget.w,
              height: widget.s,
            ),
            Container(
              width: widget.w,
              height: widget.h - widget.s,
              child: Column(
                children: [
                  Container(
                    width: widget.w,
                    height: widget.h * 4 / 48,
                    decoration: const BoxDecoration(
                        color: const Color(0xff6F4E37),
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
                                    margin:
                                        EdgeInsets.only(left: widget.w / 15),
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
                    margin: EdgeInsets.only(top: widget.h / 40),
                    alignment: Alignment.center,
                    width: widget.w,
                    height: widget.h * 5 / 48,
                    color: primary,
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
                            username + ", bugün hangi konu hakkında"),
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
                            "yorum almak istersin ?")
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    width: widget.w,
                    height: (widget.h * 37 / 48) - (widget.h / 20),
                    color: primary,
                    child: Column(
                      children: [
                        loginbutton(
                            func: () {
                              Navigator.pushNamed(context, "tarotekbilgi",
                                  arguments: {"authdocc": ref});
                            },
                            marg: widget.h / 30,
                            text: "bilgiler",
                            heigh: widget.h / 22,
                            width: widget.w * 7 / 10,
                            c: Colors.white,
                            tc: Color(0xff6F4E37)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            pageButton(
                              height: widget.h / 9,
                              width: widget.w * 10 / 24,
                              textt: "Genel Açılım",
                              func: () {
                                Navigator.pushNamed(context, 'deste',
                                    arguments: {
                                      "authdocc": throww,
                                      "konu": "genel",
                                      "bilgi": bilgiler
                                    });
                              },
                              iconn:
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 48 48"><ellipse cx="20.51" cy="23.56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" rx="4.22" ry="10.21" transform="rotate(-20 20.523 23.56)"/><ellipse cx="14.75" cy="28.84" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" rx="4.22" ry="10.21" transform="rotate(-65 14.751 28.839)"/><ellipse cx="27.49" cy="23.56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" rx="10.21" ry="4.22" transform="rotate(-70 27.495 23.562)"/><ellipse cx="33.25" cy="28.84" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" rx="10.21" ry="4.22" transform="rotate(-25 33.242 28.831)"/></svg>',
                              tm: 0,
                              lm: widget.w * 1.5 / 24,
                              bm: widget.h / 25,
                              rm: widget.w * 0.5 / 24,
                            ),
                            pageButton(
                              height: widget.h / 9,
                              width: widget.w * 10 / 24,
                              textt: "Aşk",
                              iconn:
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M9 2H5v2H3v2H1v6h2v2h2v2h2v2h2v2h2v2h2v-2h2v-2h2v-2h2v-2h2v-2h2V6h-2V4h-2V2h-4v2h-2v2h-2V4H9zm0 2v2h2v2h2V6h2V4h4v2h2v6h-2v2h-2v2h-2v2h-2v2h-2v-2H9v-2H7v-2H5v-2H3V6h2V4z"/></svg>',
                              func: () {
                                Navigator.pushNamed(context, 'deste',
                                    arguments: {
                                      "authdocc": throww,
                                      "konu": "aşk",
                                      "bilgi": bilgiler
                                    });
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
                              textt: "Sağlık",
                              func: () {
                                Navigator.pushNamed(context, 'deste',
                                    arguments: {
                                      "authdocc": throww,
                                      "konu": "sağlık",
                                      "bilgi": bilgiler
                                    });
                              },
                              iconn:
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 48 48"><g fill="none"><path d="M0 0h48v48H0z"/><path fill="currentColor" fill-rule="evenodd" d="M24 24h-4v-6h4v-4h6v4h4v6h-4v4h-6zm-2-2v-2h4v-4h2v4h4v2h-4v4h-2v-4z" clip-rule="evenodd"/><path fill="currentColor" fill-rule="evenodd" d="M27 36c8.284 0 15-6.716 15-15S35.284 6 27 6s-15 6.716-15 15c0 3.782 1.4 7.238 3.71 9.876l-1.893 1.893l-2.707-.121l-6.524 6.524l4.242 4.242l6.472-6.471l-.004-2.825l1.828-1.828A14.94 14.94 0 0 0 27 36m0-2c7.18 0 13-5.82 13-13S34.18 8 27 8s-13 5.82-13 13s5.82 13 13 13M8.828 40.586l-1.414-1.414l4.486-4.487l1.397.063l.002 1.367z" clip-rule="evenodd"/></g></svg>',
                              tm: 0,
                              lm: widget.w * 1.5 / 24,
                              bm: 0,
                              rm: widget.w * 0.5 / 24,
                            ),
                            pageButton(
                              height: widget.h / 9,
                              width: widget.w * 10 / 24,
                              textt: "Kariyer",
                              func: () {
                                Navigator.pushNamed(context, 'deste',
                                    arguments: {
                                      "authdocc": throww,
                                      "konu": "kariyer",
                                      "bilgi": bilgiler
                                    });
                              },
                              iconn:
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M2 5h20v15H2zm18 13V7H4v11zM17 8a2 2 0 0 0 2 2v5a2 2 0 0 0-2 2H7a2 2 0 0 0-2-2v-5a2 2 0 0 0 2-2zm0 5v-1c0-1.1-.67-2-1.5-2s-1.5.9-1.5 2v1c0 1.1.67 2 1.5 2s1.5-.9 1.5-2m-1.5-2a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 1 .5-.5M13 13v-1c0-1.1-.67-2-1.5-2s-1.5.9-1.5 2v1c0 1.1.67 2 1.5 2s1.5-.9 1.5-2m-1.5-2a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 1 .5-.5M8 15h1v-5H8l-1 .5v1l1-.5z"/></svg>',
                              tm: 0,
                              lm: widget.w * 0.5 / 24,
                              bm: 0,
                              rm: widget.w * 1.5 / 24,
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          width: widget.w,
                          height: widget.h / 5,
                          alignment: Alignment.center,
                          child: (_bannerAd != null)
                              ? Container(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!))
                              : null,
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class pageButton extends StatelessWidget {
  const pageButton({
    super.key,
    required this.iconn,
    required this.width,
    required this.height,
    required this.func,
    required this.lm,
    required this.tm,
    required this.bm,
    required this.rm,
    required this.textt,
  });

  final String iconn;
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
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Iconify(iconn, color: Color(0xff6F4E37), size: height / 2),
              Spacer(),
              Text(
                textt,
                style: TextStyle(
                  color: Color(0xff6F4E37),
                  fontSize: height / 6,
                  shadows: const <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              Spacer()
            ]),
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
    required this.c,
    required this.tc,
  });

  final Function func;
  final String text;
  final double marg;
  final double heigh;
  final double width;
  final Color c;
  final Color tc;

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
          backgroundColor: WidgetStateProperty.all(c),
        ),
        onPressed: () {
          func();
        },
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            child: Text(
              text,
              style: TextStyle(color: tc),
            ),
          ),
          Positioned(
              child: Row(
            children: [
              Spacer(),
              Iconify(
                  color: tc,
                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 16 16"><path fill="currentColor" d="M13.8 2.2a2.51 2.51 0 0 0-3.54 0l-6.9 6.91l-1.76 3.62a1.26 1.26 0 0 0 1.12 1.8a1.23 1.23 0 0 0 .55-.13l3.62-1.76l6-6l.83-.82l.06-.06a2.52 2.52 0 0 0 .02-3.56m-.89.89a1.25 1.25 0 0 1 0 1.77l-1.77-1.77a1.24 1.24 0 0 1 .86-.37a1.22 1.22 0 0 1 .91.37M2.73 13.27L4.29 10L6 11.71zm4.16-2.4L5.13 9.11L10.26 4L12 5.74z"/></svg>')
            ],
          ))
        ]),
      ),
    );
  }
}
