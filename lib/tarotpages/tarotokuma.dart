import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';

import 'package:telveli/ad_helper.dart';

class TarotOkumaScreen extends StatefulWidget {
  const TarotOkumaScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double h;
  final double w;
  final double s;

  @override
  _TarotOkumaScreenState createState() => _TarotOkumaScreenState();
}

late QueryDocumentSnapshot ref;
late var docid;
Color primary = Color(0xffE38A43);

String faltext = "";

class _TarotOkumaScreenState extends State<TarotOkumaScreen> {
  @override
  void initState() {
    loadBannerAd();
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
      size: AdSize(width: widget.w.toInt(), height: (widget.h / 5).toInt()),
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

  void didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments as Map;
    //args["authdocc"].reference.update({"ad": "winner"});
    ref = args["data"];
    faltext = args["text"];
    print(faltext);

    super.didChangeDependencies();
  }

  late User loggedin;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: widget.w,
        color: primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: widget.w, height: widget.s),
            Container(
              margin: EdgeInsets.only(bottom: 10),
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
              height: widget.h - (widget.s) - (widget.h * 4 / 48) - 10,
              color: primary,
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: (widget.h / 40) - 10, bottom: (0)),
                    alignment: Alignment.center,
                    width: widget.w,
                    height: widget.h / 5,
                    child: (_bannerAd != null)
                        ? Container(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!))
                        : null,
                  ),
                  Container(
                    width: widget.w,
                    height: widget.h -
                        (widget.s) -
                        (widget.h * 4 / 48) -
                        (10) -
                        (widget.h / 5) -
                        (widget.h / 20),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                            width: widget.w,
                            height: widget.h / 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loginbutton(
                                    func: () {
                                      Navigator.pushNamed(context, "home");
                                    },
                                    marg: 0,
                                    text: "Kaydet ve Çık",
                                    heigh: widget.h / 20,
                                    width: widget.w * 8 / 10)
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: widget.h / 40),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xff6F4E37),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6,
                                  offset: Offset(3, 4), // Shadow position
                                ),
                              ]),
                          width: widget.w * 9 / 10,
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: widget.h / 60),
                            faltext.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
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
          color: Colors.white,
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
