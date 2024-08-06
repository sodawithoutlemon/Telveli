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
import 'package:telveli/ad_helper.dart';

String faltext = "senisevom";
String text = "";
String docid = "";
File? path1;
File? path2;
File? path3;
File? path4;
var list = [];

Color primary = Color(0xffE38A43);

class TurkfalScreen extends StatefulWidget {
  const TurkfalScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double s;
  final double h;
  final double w;

  @override
  _TurkfalScreenState createState() => _TurkfalScreenState();
}

int toplamfal = 0;
String username = "";
String usermail = "";
String tarih = "";
late var args;

class _TurkfalScreenState extends State<TurkfalScreen> {
  @override
  void initState() {
    // TODO: implement initState
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

  void didChangeDependencies() {
    args = ModalRoute.of(context)?.settings.arguments as Map;
    print("bilgi");
    print(args);
    //args["authdocc"].reference.update({"ad": "winner"});
    var xd = args["authdocc"].data();

    toplamfal = xd["toplambakılanfal"];
    usermail = xd["mail"];
    username = args["name"];
    tarih = args["date"];

    super.didChangeDependencies();
  }

  final storageRef = FirebaseStorage.instance.ref();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future takePhoto() async {
    final returned = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returned != null) {
      return returned!.path;
    }
  }

  Future imageGalery() async {
    final returned = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
    if (returned != null) {
      return File(returned!.path);
    }
  }

  int p1 = 0;
  int p2 = 0;
  int p3 = 0;
  int p4 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: [
            Container(
              width: widget.w,
              height: widget.s,
            ),
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
                              Navigator.pushNamed(context, "trfalbilgi",
                                  arguments: {"authdocc": args["authdocc"]});
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: widget.h / 20),
                    child: Text(
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
                        "Fincan Fotoğraflarını Yükleyiniz."),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: widget.h / 30),
                    child: Text(
                        style: TextStyle(
                          fontSize: widget.h * 0.9 / 48,
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
                        "En az bir fotoğraf yüklemelisin."),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        B(
                            xd: path1,
                            widget: widget,
                            p: p1,
                            func: () async {
                              path1 = await imageGalery();
                              list.add(path1);
                              setState(() {
                                path1;
                                p1 = 1;
                              });
                              return path1;
                            }),
                        B(
                            xd: path2,
                            p: p2,
                            widget: widget,
                            func: () async {
                              path2 = await imageGalery();
                              list.add(path2);

                              setState(() {
                                p2 = 1;
                              });
                            }),
                        B(
                            xd: path3,
                            p: p3,
                            widget: widget,
                            func: () async {
                              path3 = await imageGalery();
                              list.add(path3);

                              setState(() {
                                p3 = 1;
                              });
                            }),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: widget.h / 40),
                    child: Text(
                        style: TextStyle(
                          fontSize: widget.h * 0.9 / 48,
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
                        "Fincan tabağını da çekebilir misin?"),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: widget.h / 100),
                      child: B(
                          xd: path4,
                          widget: widget,
                          func: () async {
                            path4 = await imageGalery();
                            setState(() {
                              p4 = 1;
                            });
                          },
                          p: p4)),
                  Container(
                    margin: EdgeInsets.only(top: widget.h / 100),
                    child: Text(
                        style: TextStyle(
                          fontSize: widget.h * 0.9 / 48,
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
                        "Fincanınınız yoksa yorumcularımız sizin için"),
                  ),
                  Container(
                    child: Text(
                        style: TextStyle(
                          fontSize: widget.h * 0.9 / 48,
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
                        "bir fincan kapatacaklar."),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: widget.h / 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(3, 4), // Shadow position
                          ),
                        ]),
                    height: widget.h / 20,
                    width: widget.w / 2,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        list.removeWhere((v) => v == null);
                        if (list.length > 0) {
                          print("here");
                          var lastpath = list[0];
                          final ref = await storageRef.child(usermail +
                              "/" +
                              username +
                              toplamfal.toString() +
                              ".jpg");
                          try {
                            await ref.putFile(lastpath!);
                            final adres = "gs://telveli-6d2af.appspot.com/" +
                                usermail +
                                "/" +
                                username +
                                toplamfal.toString() +
                                ".jpg";
                            try {
                              await _firestore
                                  .collection('generate')
                                  .add({"image": adres, "isim": username}).then(
                                      (DocumentReference doc) =>
                                          docid = doc.id);
                              DateTime now = DateTime.now();

                              toplamfal += 1;
                              await _firestore
                                  .collection("bilgiler")
                                  .get()
                                  .then((event) {
                                for (var doc in event.docs) {
                                  if (doc.data()["mail"] == usermail) {
                                    doc.reference.update({
                                      "aktifkahvefalı": docid,
                                      "toplambakılanfal": toplamfal,
                                      "aktiffaltarih": now.toString(),
                                    });
                                  }
                                }
                              });
                              Navigator.pushNamed(context, "trfalokuma");
                            } catch (e) {
                              print(e);
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      child: Text(
                        "Gönder",
                        style: TextStyle(color: const Color(0xff6F4E37)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: widget.h / 20),
                    width: widget.w,
                    height: widget.h / 10,
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
    );
  }
}

var f =
    '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10s10-4.5 10-10S17.5 2 12 2m-2 15l-5-5l1.41-1.41L10 14.17l7.59-7.59L19 8z"/></svg>';
var s =
    '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 20 20"><path fill="currentColor" fill-rule="evenodd" d="M1 8a2 2 0 0 1 2-2h.93a2 2 0 0 0 1.664-.89l.812-1.22A2 2 0 0 1 8.07 3h3.86a2 2 0 0 1 1.664.89l.812 1.22A2 2 0 0 0 16.07 6H17a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2zm13.5 3a4.5 4.5 0 1 1-9 0a4.5 4.5 0 0 1 9 0M10 14a3 3 0 1 0 0-6a3 3 0 0 0 0 6" clip-rule="evenodd"/></svg>';

class B extends StatelessWidget {
  B({
    super.key,
    required this.xd,
    required this.func,
    required this.widget,
    required this.p,
  });

  final int p;
  final Function func;
  final TurkfalScreen widget;
  final File? xd;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      width: widget.h / 12,
      height: widget.h / 12,
      decoration: BoxDecoration(border: Border.all(color: Color(0xff6F4E37))),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
        ),
        onPressed: () async {
          await func();
        },
        child: ((xd != null)
            ? Container(
                child: Image.file(xd!),
              )
            : Iconify(s, size: widget.h / 14, color: Color(0xff6F4E37))),
      ),
    );
  }
}
