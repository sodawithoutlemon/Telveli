import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

import 'package:telveli/ad_helper.dart';

String mailforauth = "";
String text = "";
int coinnumber = 0;
double nameheightt = 0;
double kahvecointop = 10000;
Color primary = Color(0xffFFC6C6);
Color sec = Color(0xffF0A8D0);

String meessagecolor = "white";

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double h;
  final double w;
  final double s;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String falstate = "yok";
String kahvefal = "Kahve Falı";
String goertext = "Kahve Falı";
String ucret = "1 jeton";
late var ref;
String faldate = "01/01/2030";

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    // TODO: implement dispose
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
    _controller.dispose();

    super.dispose();
  }

  late AnimationController _controller;

  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Animasyon süresi
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animasyon tamamlandığında ters yönde oynat
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Animasyon geri döndüğünde tekrar başla
        _controller.forward();
      }
    });

    // Başlangıçta animasyonu başlat
    _controller.forward();
    loadBannerAd();
    loadRewAd();
    kahvecointop = widget.h * 2;
    nameheightt = widget.h * 1 / 48;
    getUser();
    text = loggedin.email!;
    _firestore.collection("bilgiler").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["mail"] == text) {
          setState(() {
            print("initçalıştı");
            ref = doc;
            var deneme = doc.data();
            text = deneme["ad"];

            faldate = deneme["aktiffaltarih"];
            coinnumber = deneme["coin"];
            falstate = deneme["aktifkahvefalı"];
            print(faldate);
            if (faldate != "yok") {
              var testtt = DateTime(
                int.parse(faldate.substring(0, 4)),
                int.parse(faldate.substring(5, 7)),
                int.parse(faldate.substring(8, 10)),
                int.parse(faldate.substring(11, 13)),
                int.parse(faldate.substring(14, 16)),
              );
              DateTime now = DateTime.now();

              var minn = now.difference(testtt).inMinutes;
              print("lookhere");
              print(minn);
              if (minn > 13) {
                setState(() {
                  meessagecolor = "yellow";
                });
              }
            } else {
              setState(() {
                meessagecolor = "white";
              });
            }
          });
        }
      }
    });
    // TODO: implement initState

    super.initState();
  }

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  RewardedAd? _rewardedAd;

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
        color: Color(0xff16345C),
        child: Stack(
          children: [
            Positioned(
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
                          height: (widget.h * 4 / 48),
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
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)),
                                onPressed: () async {
                                  _rewardedAd?.show(
                                      onUserEarnedReward: (_, reward) async {
                                    if (true) {
                                      setState(() {
                                        coinnumber += 1;
                                      });
                                      await _firestore
                                          .collection("bilgiler")
                                          .get()
                                          .then((event) {
                                        for (var doc in event.docs) {
                                          if (doc.data()["mail"] ==
                                              mailforauth) {
                                            doc.reference
                                                .update({"coin": coinnumber});
                                          }
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: widget.w * 1.5 / 24),
                                  width: widget.h * 4 / 48,
                                  height: widget.h * 4 / 48,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Positioned(
                                          left: (widget.h * 4 / 96) -
                                              (widget.h * 4.5 / 192) +
                                              2,
                                          top: (widget.h * 4 / 96) -
                                              (widget.h * 4.5 / 192) +
                                              2,
                                          child: Container(
                                              height: widget.h * 4.5 / 96,
                                              width: widget.h * 4.5 / 96,
                                              child: Iconify(
                                                  color: Colors.black54,
                                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35"><path d="M9 14c0 1.657 2.686 3 6 3s6-1.343 6-3s-2.686-3-6-3s-6 1.343-6 3"/><path d="M9 14v4c0 1.656 2.686 3 6 3s6-1.344 6-3v-4M3 6c0 1.072 1.144 2.062 3 2.598s4.144.536 6 0S15 7.072 15 6s-1.144-2.062-3-2.598s-4.144-.536-6 0S3 4.928 3 6"/><path d="M3 6v10c0 .888.772 1.45 2 2"/><path d="M3 11c0 .888.772 1.45 2 2"/></g></svg>'))),
                                      Positioned(
                                        top: (widget.h * 4 / 48) -
                                            (widget.h * 3 / 96) +
                                            2,
                                        left: (widget.h * 4 / 48) -
                                            (widget.h * 2.5 / 96) +
                                            2,
                                        child: Container(
                                          height: widget.h * 2 / 96,
                                          width: widget.h * 2 / 96,
                                          child: Iconify(
                                            '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256"><path fill="currentColor" d="M228 128a12 12 0 0 1-12 12h-76v76a12 12 0 0 1-24 0v-76H40a12 12 0 0 1 0-24h76V40a12 12 0 0 1 24 0v76h76a12 12 0 0 1 12 12"/></svg>',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: (widget.h * 4 / 48) -
                                            (widget.h * 3 / 96),
                                        left: (widget.h * 4 / 48) -
                                            (widget.h * 2.5 / 96),
                                        child: Container(
                                          height: widget.h * 2 / 96,
                                          width: widget.h * 2 / 96,
                                          child: Iconify(
                                            '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256"><path fill="currentColor" d="M228 128a12 12 0 0 1-12 12h-76v76a12 12 0 0 1-24 0v-76H40a12 12 0 0 1 0-24h76V40a12 12 0 0 1 24 0v76h76a12 12 0 0 1 12 12"/></svg>',
                                            color: Color(0xffF3C70D),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          left: (widget.h * 4 / 96) -
                                              (widget.h * 4.5 / 192),
                                          top: (widget.h * 4 / 96) -
                                              (widget.h * 4.5 / 192),
                                          child: Container(
                                              height: widget.h * 4.5 / 96,
                                              width: widget.h * 4.5 / 96,
                                              child: Iconify(
                                                  color: Color(0xffF3C70D),
                                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35"><path d="M9 14c0 1.657 2.686 3 6 3s6-1.343 6-3s-2.686-3-6-3s-6 1.343-6 3"/><path d="M9 14v4c0 1.656 2.686 3 6 3s6-1.344 6-3v-4M3 6c0 1.072 1.144 2.062 3 2.598s4.144.536 6 0S15 7.072 15 6s-1.144-2.062-3-2.598s-4.144-.536-6 0S3 4.928 3 6"/><path d="M3 6v10c0 .888.772 1.45 2 2"/><path d="M3 11c0 .888.772 1.45 2 2"/></g></svg>'))),
                                      Positioned(
                                          left: (widget.h * 4 / 96) -
                                              (widget.h * 4.5 / 192) -
                                              (widget.h * 1 / 96),
                                          top: (widget.h * 4 / 96) -
                                              (widget.h * 4.5 / 192) +
                                              (widget.h * 3 / 96),
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
                                                fontSize: widget.h * 2 / 96),
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              Color(0xff16345C),
                              Color(0xFF2F4D76),

                              Color(0xFF3A4A9B),
                              Color(0xFF3A4D9B),
                              Color(0xff282a8c),

                              // Kahverengiye benzeyen Saddle Brown
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                          margin: const EdgeInsets.all(0),
                          width: widget.w,
                          height: widget.h - (widget.s) - (widget.h * 4 / 48),
                          child: Stack(
                            children: [
                              Container(
                                width: widget.w,
                                height:
                                    widget.h - (widget.s) - (widget.h * 4 / 48),
                                child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Lottie.asset(
                                      'assets/star.json',
                                      controller: _controller,
                                      onLoaded: (composition) {
                                        _controller.duration =
                                            composition.duration;
                                      },
                                    )),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Color(0xff16345C),
                                    Color(0xFF2F4D76),

                                    Color(0xFF3A4A9B),
                                    Color(0xFF3A4D9B),
                                    Color(0xff282a8c),

                                    // Kahverengiye benzeyen Saddle Brown
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: widget.w * 1.5 / 24,
                                        bottom: (widget.h / 30) - 10),
                                    alignment: Alignment.bottomLeft,
                                    width: widget.w,
                                    height: widget.h * 2.5 / 48,
                                    child: Row(
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
                                            "Hoş geldin, " + text),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      pageButton(
                                        ic: '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35" d="M17 12H4v4a4 4 0 0 0 4 4h5a4 4 0 0 0 4-4zm0 0h2a2 2 0 0 1 2 2v1a2 2 0 0 1-2 2h-2m-4-8s1-1 .5-2l-1-2C12 4 13 3 13 3M8.64 9s1-1 .5-2l-1-2c-.5-1 .5-2 .5-2"/></svg>',
                                        height: widget.h / 9.5,
                                        width: widget.w * 10 / 24,
                                        textt: "Kahve Falı",
                                        func: () {
                                          print(falstate);
                                          if (falstate == "yok") {
                                            setState(() {
                                              goertext = "Kahve Falı";
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
                                        ic: '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512"><path fill="currentColor" d="M168.223 371.39c-75.49 36.68-40 115.61-40 115.61h161.9c-35.95-45.77 42.14-71.18 16.83-112.217c-20.28-32.871-108.06 46.317-138.73-3.393M88.603 487h-63.6V122.768h44.89zm203.75-221.2c72.93 83.761 16.01 221.2 16.01 221.2h38.33s27.51-85.24-3.75-195.206zM487.003 487h-63.61l18.71-364.232h44.9zM54.063 139.434h-12.4V470.33h29.4zm122.35 150.686c-33.49 143.59 102.17 31.092 131.74 63.547c.72-63.167-102.87 11.353-89.18-85.102zm127.9-123.672l29.46 94.464l-43.65-22.414c14.1-19.37 17.07-44.259 14.19-72.05m-96.63 0l-29.46 94.464l43.65-22.414c-14.09-19.37-17.06-44.259-14.19-72.05m14.28-3.326c.63-.19 1.26-.418 1.87-.686c21.44-9.361 42.87-9.408 64.31-.01q.93.408 1.89.696q.09 1.647.09 3.326c0 25.089-15.29 45.458-34.12 45.458c-18.84 0-34.13-20.369-34.13-45.458q0-1.679.09-3.326m56.74-86.928c17.05-20.178 47.2-28.588 75.62 8.048c-36.25-15.986-68.08 6.105-59.49 62.92c-25.89-11.351-51.78-11.306-77.67 0c8.59-56.815-23.24-78.906-59.49-62.92c28.42-36.636 58.57-28.226 75.63-8.048c-4.78 5.911-7.82 13.77-7.82 22.756c0 19.86 14.84 34.212 30.52 34.212s30.51-14.352 30.51-34.212c0-8.986-3.03-16.845-7.81-22.756m-22.7 5.211c7.64 0 13.85 7.862 13.85 17.545s-6.21 17.546-13.85 17.546c-7.65 0-13.85-7.862-13.85-17.546s6.2-17.545 13.85-17.545M117.063 25l-45.38 65.086h-46.68V25zm369.94 0v65.086h-46.69L394.933 25zM41.663 41.667V73.42h21.32l22.15-31.753z"/></svg>',
                                        height: widget.h / 9.5,
                                        width: widget.w * 10 / 24,
                                        textt: "Tarot Falı",
                                        func: () {
                                          setState(() {
                                            goertext = "Tarot Falı";
                                            kahvecointop = widget.h / 2;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      pageButton(
                                        ic: '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512"><path fill="currentColor" d="M248 16v32.24c-65 3.79-117.8 53.36-126.7 116.86c-5-3.2-10.9-5.1-17.3-5.1c-17.58 0-32 14.4-32 32c0 14.8 10.21 27.4 23.92 31l3.16 30.2c-.25 63.8 2.62 135.7-2.38 202.3c-2.8-7.3-3.04-12.1-4.52-20.9l-12.22 2.2c2.2 13.7 4.98 27 13.12 38.9c23.92-9.3 30.22-60.9 36.62-93.9l-20.9-11.6l24.3-7c2.3-14.3 3.8-23.3 4.6-32.4l-19.5-15.2l20.2.2c0-3.9 0-8.1-.1-12.9c-.4-13-11.8-42-23.3-48.2l-3.3-31.7c4.6-1.1 8.7-3.2 12.3-6.1c14.2 56.7 63.9 99.4 124 102.9v9.6c-9.3 3.3-16 12.2-16 22.6c0 11.6 8.3 21.3 19.3 23.5c-12.5 3.6-25.2 19.2-23.8 26.2c8.3 41.6 14.9 88.6 30.8 93.1c19.6-19.7 21.6-59.3 25.5-97.1c.5-4.8-11.6-18.8-23-22.2c10.9-2.3 19.2-12 19.2-23.5c0-10.4-6.7-19.3-16-22.6v-9.6c60.1-3.5 109.8-46.2 124-102.9c3.9 3.1 8.5 5.4 13.5 6.4l3.3 42.1c-11.6 5.4-21.7 20.6-22.1 32.1c-.6 22.2.9 46.4 5.3 70.2l23.2 10.2l-21.2-.3c.4 1.9.8 3.7 1.3 5.6l7.6 8.2l-5.1 1.4c7.1 25.3 17.8 49 32.9 67.8c5.5-10.5 9.8-22.1 13.1-34.4l-12.2-1.9c-.6 7.8-1.3 15.6-2.1 23.3c-5-58.5-4.6-127.2-4.8-183.6l-3.3-41.4c13.1-4.1 22.6-16.3 22.6-30.6c0-17.6-14.4-32-32-32c-6.4 0-12.3 1.9-17.3 5.1C381.8 101.6 329 52.03 264 48.24V16zm8 48c66.4 0 120 53.6 120 120s-53.6 120-120 120s-120-53.6-120-120S189.6 64 256 64m-4.8 15.01c-6.8.31-13.4 1.25-19.8 2.78c-3.7 7.84-6.2 16.07-7.6 24.41c-7-4.9-14.6-8.91-22.7-11.87c-5.7 3.5-11 7.57-16 11.97c14.3 3.1 27.1 9.9 37.4 19.4c.4 10.6 2.6 21.2 6.5 31.3c-10.1-3.9-20.7-6.1-31.3-6.5c-9.5-10.3-16.3-23.1-19.4-37.3q-6.75 7.35-12 15.9c3 8.1 7.1 15.7 12 22.7c-8.4 1.4-16.7 3.9-24.5 7.6c-1.5 6.4-2.5 13-2.8 19.8c12.2-7.9 26.1-12.2 40.1-12.7c7.8 7.2 16.8 13.2 26.7 17.5c-9.9 4.3-18.9 10.3-26.7 17.6c-14-.6-27.9-4.8-40.1-12.7c.3 6.8 1.3 13.3 2.8 19.7c7.8 3.7 16.1 6.2 24.5 7.6c-4.9 7-9 14.6-12 22.7q5.25 8.55 12 15.9c3.1-14.2 9.9-27 19.4-37.3c10.6-.4 21.2-2.6 31.3-6.5c-3.9 10.1-6.1 20.6-6.5 31.3c-10.3 9.5-23.1 16.3-37.4 19.3c4.9 4.5 10.3 8.6 16 12.1c8.2-3 15.8-7 22.7-11.9c1.4 8.4 3.9 16.6 7.6 24.4c6.4 1.5 12.9 2.5 19.7 2.8c-7.9-12.2-12.1-26-12.7-40.1c7.3-7.8 13.3-16.8 17.6-26.7c4.3 9.9 10.3 18.9 17.5 26.7c-.5 14-4.8 27.9-12.7 40.1c6.8-.3 13.4-1.3 19.8-2.8c3.7-7.8 6.2-16 7.6-24.4c7 4.9 14.6 8.9 22.7 11.9c5.7-3.5 11.1-7.6 16-12.1c-14.3-3-27.1-9.8-37.4-19.3c-.4-10.6-2.5-21.2-6.5-31.3c10.1 4 20.7 6.1 31.3 6.5c9.5 10.3 16.3 23.1 19.4 37.3q6.75-7.35 12-15.9c-3-8.1-7-15.7-11.9-22.7c8.4-1.4 16.6-3.9 24.4-7.6c1.5-6.4 2.5-13 2.8-19.8c-12.2 7.9-26.1 12.2-40.1 12.7c-7.8-7.2-16.8-13.2-26.7-17.5c9.9-4.3 18.9-10.3 26.7-17.6c14 .6 27.9 4.8 40.1 12.7c-.3-6.8-1.3-13.3-2.8-19.7c-7.8-3.7-16.1-6.2-24.5-7.6c4.9-7 9-14.6 12-22.7c-3.5-5.7-7.6-11.1-12.1-16c-3 14.3-9.8 27.1-19.3 37.4c-10.7.4-21.2 2.6-31.3 6.5c3.9-10.1 6.1-20.7 6.5-31.3c10.3-9.5 23.1-16.4 37.4-19.4c-5-4.5-10.3-8.47-16-11.97c-8.1 2.96-15.7 6.97-22.7 11.87c-1.4-8.34-3.9-16.57-7.6-24.41c-6.4-1.53-13-2.47-19.8-2.78c8 12.2 12.2 26.09 12.8 40.09c-7.3 7.8-13.3 16.8-17.6 26.7c-4.3-9.9-10.3-18.9-17.6-26.7c.6-14 4.8-27.89 12.8-40.09M256 160c13.2 0 24 10.8 24 24s-10.8 24-24 24s-24-10.8-24-24s10.8-24 24-24m-152 16c8.9 0 16 7.1 16 16s-7.1 16-16 16c-8.93 0-16-7.1-16-16s7.07-16 16-16m152 0c-4.5 0-8 3.5-8 8s3.5 8 8 8s8-3.5 8-8s-3.5-8-8-8m152 0c8.9 0 16 7.1 16 16s-7.1 16-16 16s-16-7.1-16-16s7.1-16 16-16M87.78 257.7c-10.12 5.9-18.62 15.3-18.82 22.9c-2 42.8-.7 90.8 8.7 145.9l14.42 5.6c-3.8-58.4-3.7-116.3-4.3-174.4M432 268c-.6 51.3-.5 102.5-4.3 154.1l14.4-5c7.6-31.7 9.6-67.4 9.3-103.2l-14.6-.3l14.4-8.4c0-5.7-.1-11.4-.4-17c-.2-6.7-8.7-15-18.8-20.2m-176 76c4.5 0 8 3.5 8 8s-3.5 8-8 8s-8-3.5-8-8s3.5-8 8-8m-4.2 31.6c1.4.3 2.8.4 4.2.4c1.3 0 2.5-.1 3.7-.3l-2.3 90.6z"/></svg>',
                                        height: widget.h / 9.5,
                                        width: widget.w * 10 / 24,
                                        textt: "Rüya Yorumlama",
                                        func: () {},
                                        tm: 0,
                                        lm: widget.w * 1.5 / 24,
                                        bm: widget.h / 25,
                                        rm: widget.w * 0.5 / 24,
                                      ),
                                      pageButton(
                                        ic: '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M20 17a3 3 0 0 1-3 3a3.163 3.163 0 0 1-3-3c.16-1.61.5-3.2 1-4.74c.54-1.71.87-3.47 1-5.26a5.136 5.136 0 0 0-5-5a5.136 5.136 0 0 0-5 5c.15 1.53.5 3.03 1 4.5l.21.7c-2.11-.67-4.35.5-5.02 2.6c-.69 2.11.49 4.36 2.6 5.03s4.35-.5 5.02-2.61c.13-.39.19-.81.19-1.22c-.16-1.73-.5-3.44-1.09-5.08A18.8 18.8 0 0 1 8 7a3.163 3.163 0 0 1 3-3c1.62.08 2.92 1.38 3 3a22.6 22.6 0 0 1-1 4.74c-.54 1.71-.87 3.47-1 5.26a5.136 5.136 0 0 0 5 5a5 5 0 0 0 5-5zM6 18a2 2 0 0 1-2-2a2 2 0 0 1 2-2a2 2 0 0 1 2 2a2 2 0 0 1-2 2"/></svg>',
                                        height: widget.h / 9.5,
                                        width: widget.w * 10 / 24,
                                        textt: "Burç Yorumu",
                                        func: () {},
                                        tm: 0,
                                        lm: widget.w * 0.5 / 24,
                                        bm: widget.h / 25,
                                        rm: widget.w * 1.5 / 24,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      pageButton(
                                        ic: '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 512 512"><path fill="currentColor" d="M496 136s-40.486 85.32-51.442 128.988c-14.33 57.118 2.078 100.297-18.747 155.68c-35.998 64.97-38.435 75.466-169.81 75.33c-48.132-.044-186.02-36.76-186.02-36.76C50.97 454.35 16 457.23 16 435.997c0-21.232 24.88-36.736 46.97-36.787l87.03 7.642c21.14-1.326 43.286-13.71 43.96-41.36c-.353-40.927-4.4-72.357-25.175-105.6l-80.67-125.864c-4.818-10.02-5.964-27.105 7.983-34.732c13.947-7.628 29.793 3.71 35.205 13.582l90.11 122.57c9.618 8.955 26.738 10.68 25.278-8.38L206.903 44.652c-2.478-12.96 4.1-28.654 19.1-28.654c19.687 0 31.795 7.515 31.413 19.413l43.75 179.984c3.42 8.76 15.545 7.59 18.807-.49l12.462-175.022c.64-5.583 7.922-15.314 21.9-13.286c13.976 2.027 22.035 17 20.555 22.793l-4.044 172.936c2.838 15.327 14.888 17.565 24.266 9.008l61.22-109.487c3.72-9.183 18.288-11.096 26.715-7.455c7.84 5.107 12.954 11.96 12.954 21.603z"/></svg>',
                                        height: widget.h / 9.5,
                                        width: widget.w * 10 / 24,
                                        textt: "El Falı",
                                        func: () {},
                                        tm: 0,
                                        lm: widget.w * 1.5 / 24,
                                        bm: 0,
                                        rm: widget.w * 0.5 / 24,
                                      ),
                                      pageButton(
                                        ic: '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M15.465 14A3.998 3.998 0 0 1 12 16a3.998 3.998 0 0 1-3.465-2M14 10l1-1l1 1m-6 0L9 9l-1 1"/></g></svg>',
                                        height: widget.h / 9.5,
                                        width: widget.w * 10 / 24,
                                        textt: "Yüz Falı",
                                        func: () {},
                                        tm: 0,
                                        lm: widget.w * 0.5 / 24,
                                        bm: 0,
                                        rm: widget.w * 1.5 / 24,
                                      ),
                                    ],
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: widget.h / 40,
                                          bottom: widget.h / 40),
                                      width: widget.w,
                                      height: (widget.h -
                                              ((widget.s) +
                                                  (widget.h * 4 / 48))) -
                                          (widget.h * 2.5 / 48) -
                                          (widget.h / 30) -
                                          ((widget.h / 9.5) + (widget.h / 25)) -
                                          ((widget.h / 9.5) + (widget.h / 25)) -
                                          ((widget.h / 9.5)) -
                                          (widget.h * 4 / 48) -
                                          (2 * (widget.h / 40)) +
                                          10,
                                      child: (_bannerAd != null)
                                          ? Container(
                                              width: _bannerAd!.size.width
                                                  .toDouble(),
                                              height: _bannerAd!.size.height
                                                  .toDouble(),
                                              child: AdWidget(ad: _bannerAd!))
                                          : null),
                                  Container(
                                      width: widget.w,
                                      height: widget.h * 4 / 48,
                                      decoration: BoxDecoration(
                                        color: Color(0xff16345C),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: widget.w / 10),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.all(0)),
                                              onPressed: () {
                                                print(meessagecolor);
                                                if (meessagecolor != "white") {
                                                  Navigator.pushNamed(
                                                      context, "trfalbilgi");
                                                }
                                              },
                                              child: Container(
                                                width: widget.h * 2.9 / 48,
                                                height: widget.h * 2.9 / 48,
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Positioned(
                                                          left: 3,
                                                          top: 2,
                                                          child: Iconify(
                                                              size: widget.h *
                                                                  2.8 /
                                                                  48,
                                                              color:
                                                                  Colors.black,
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 26 26"><path fill="currentColor" d="M3 4C1.344 4 0 5.344 0 7v12c0 1.656 1.344 3 3 3h20c1.656 0 3-1.344 3-3V7c0-1.656-1.344-3-3-3zm0 2h20c.551 0 1 .449 1 1v.5l-11 5.938L2 7.5V7c0-.551.449-1 1-1M2 7.781l6.531 5.094l-6.406 6.563l7.813-5.563L13 15.844l3.063-1.969l7.812 5.563l-6.406-6.563L24 7.781V19a.95.95 0 0 1-.125.438c-.165.325-.486.562-.875.562H3c-.389 0-.71-.237-.875-.563A.95.95 0 0 1 2 19z"/></svg>')),
                                                      Positioned(
                                                          child: Iconify(
                                                              size: widget.h *
                                                                  2.8 /
                                                                  48,
                                                              color: (meessagecolor ==
                                                                      "white")
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xffF3C70D),
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 26 26"><path fill="currentColor" d="M3 4C1.344 4 0 5.344 0 7v12c0 1.656 1.344 3 3 3h20c1.656 0 3-1.344 3-3V7c0-1.656-1.344-3-3-3zm0 2h20c.551 0 1 .449 1 1v.5l-11 5.938L2 7.5V7c0-.551.449-1 1-1M2 7.781l6.531 5.094l-6.406 6.563l7.813-5.563L13 15.844l3.063-1.969l7.812 5.563l-6.406-6.563L24 7.781V19a.95.95 0 0 1-.125.438c-.165.325-.486.562-.875.562H3c-.389 0-.71-.237-.875-.563A.95.95 0 0 1 2 19z"/></svg>')),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.all(0)),
                                              onPressed: () {},
                                              child: Container(
                                                width: widget.h * 2.9 / 48,
                                                height: widget.h * 2.9 / 48,
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Positioned(
                                                          left: 3,
                                                          top: 2,
                                                          child: Iconify(
                                                              size: widget.h *
                                                                  2.8 /
                                                                  48,
                                                              color:
                                                                  Colors.black,
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M11.336 2.253a1 1 0 0 1 1.328 0l9 8a1 1 0 0 1-1.328 1.494L20 11.45V19a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-7.55l-.336.297a1 1 0 0 1-1.328-1.494zM6 9.67V19h3v-5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v5h3V9.671l-6-5.333zM13 19v-4h-2v4z"/></svg>')),
                                                      Positioned(
                                                          child: Iconify(
                                                              size: widget.h *
                                                                  2.8 /
                                                                  48,
                                                              color:
                                                                  Colors.white,
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M11.336 2.253a1 1 0 0 1 1.328 0l9 8a1 1 0 0 1-1.328 1.494L20 11.45V19a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-7.55l-.336.297a1 1 0 0 1-1.328-1.494zM6 9.67V19h3v-5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v5h3V9.671l-6-5.333zM13 19v-4h-2v4z"/></svg>')),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: widget.w / 10),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.all(0)),
                                              onPressed: () {},
                                              child: Container(
                                                width: widget.h * 2.9 / 48,
                                                height: widget.h * 2.9 / 48,
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Positioned(
                                                          left: 3,
                                                          top: 2,
                                                          child: Iconify(
                                                              size: widget.h *
                                                                  2.8 /
                                                                  48,
                                                              color:
                                                                  Colors.black,
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none"><path stroke="currentColor" stroke-width="2.5" d="M21 12a8.958 8.958 0 0 1-1.526 5.016A8.991 8.991 0 0 1 12 21a8.991 8.991 0 0 1-7.474-3.984A9 9 0 1 1 21 12Z"/><path fill="currentColor" d="M12.75 9a.75.75 0 0 1-.75.75v2.5A3.25 3.25 0 0 0 15.25 9zm-.75.75a.75.75 0 0 1-.75-.75h-2.5A3.25 3.25 0 0 0 12 12.25zM11.25 9a.75.75 0 0 1 .75-.75v-2.5A3.25 3.25 0 0 0 8.75 9zm.75-.75a.75.75 0 0 1 .75.75h2.5A3.25 3.25 0 0 0 12 5.75zm-6.834 9.606L3.968 17.5l-.195.653l.444.517zm13.668 0l.949.814l.444-.517l-.195-.653zM9 16.25h6v-2.5H9zm0-2.5a5.252 5.252 0 0 0-5.032 3.75l2.396.713A2.752 2.752 0 0 1 9 16.25zm3 6a7.73 7.73 0 0 1-5.885-2.707L4.217 18.67A10.23 10.23 0 0 0 12 22.25zm3-3.5c1.244 0 2.298.827 2.636 1.963l2.396-.713A5.252 5.252 0 0 0 15 13.75zm2.885.793A7.73 7.73 0 0 1 12 19.75v2.5a10.23 10.23 0 0 0 7.783-3.58z"/></g></svg>')),
                                                      Positioned(
                                                          child: Iconify(
                                                              size: widget.h *
                                                                  2.8 /
                                                                  48,
                                                              color:
                                                                  Colors.white,
                                                              '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none"><path stroke="currentColor" stroke-width="2.5" d="M21 12a8.958 8.958 0 0 1-1.526 5.016A8.991 8.991 0 0 1 12 21a8.991 8.991 0 0 1-7.474-3.984A9 9 0 1 1 21 12Z"/><path fill="currentColor" d="M12.75 9a.75.75 0 0 1-.75.75v2.5A3.25 3.25 0 0 0 15.25 9zm-.75.75a.75.75 0 0 1-.75-.75h-2.5A3.25 3.25 0 0 0 12 12.25zM11.25 9a.75.75 0 0 1 .75-.75v-2.5A3.25 3.25 0 0 0 8.75 9zm.75-.75a.75.75 0 0 1 .75.75h2.5A3.25 3.25 0 0 0 12 5.75zm-6.834 9.606L3.968 17.5l-.195.653l.444.517zm13.668 0l.949.814l.444-.517l-.195-.653zM9 16.25h6v-2.5H9zm0-2.5a5.252 5.252 0 0 0-5.032 3.75l2.396.713A2.752 2.752 0 0 1 9 16.25zm3 6a7.73 7.73 0 0 1-5.885-2.707L4.217 18.67A10.23 10.23 0 0 0 12 22.25zm3-3.5c1.244 0 2.298.827 2.636 1.963l2.396-.713A5.252 5.252 0 0 0 15 13.75zm2.885.793A7.73 7.73 0 0 1 12 19.75v2.5a10.23 10.23 0 0 0 7.783-3.58z"/></g></svg>')),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          goertext,
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
                            Iconify(
                                color: Color(0xffF3C70D),
                                '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35"><path d="M9 14c0 1.657 2.686 3 6 3s6-1.343 6-3s-2.686-3-6-3s-6 1.343-6 3"/><path d="M9 14v4c0 1.656 2.686 3 6 3s6-1.344 6-3v-4M3 6c0 1.072 1.144 2.062 3 2.598s4.144.536 6 0S15 7.072 15 6s-1.144-2.062-3-2.598s-4.144-.536-6 0S3 4.928 3 6"/><path d="M3 6v10c0 .888.772 1.45 2 2"/><path d="M3 11c0 .888.772 1.45 2 2"/></g></svg>'),
                            Text(
                              ucret,
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
                            if (goertext == "Kahve Falı") {
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
                                      doc.reference
                                          .update({"coin": coinnumber});
                                    }
                                  }
                                });
                                Navigator.pushNamed(context, 'trfalbilgi',
                                    arguments: {"authdocc": ref});
                              }
                            }
                            if (goertext == "Tarot Falı") {
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
                                      doc.reference
                                          .update({"coin": coinnumber});
                                    }
                                  }
                                });
                                Navigator.pushNamed(context, 'tarotbilgi',
                                    arguments: {"authdocc": ref});
                              }
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
                            _rewardedAd?.show(
                                onUserEarnedReward: (_, reward) async {
                              if (true) {
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
                              }
                            });
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
    required this.ic,
  });

  final double width;
  final double height;
  final String textt;
  final String ic;
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
              spreadRadius: 2,
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
              Text(
                textt,
                style: TextStyle(color: Color(0xff16345C)),
              ),
              Iconify(
                ic,
                color: Color(0xff16345C),
              )
            ]),
      ),
    );
  }
}
