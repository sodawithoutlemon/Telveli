import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:telveli/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ad_helper.dart';

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}

Color textcolor = Color(0xff16345C);

String errortext = "";
double kullanimheight = 0;
String ad = "";
String email = "";
String password = "";
String passwordtekrar = "";

double extraheight = 0;

double geridonheight = 0;
double adsoyadheight = 0;
Color kayitcolor = Colors.white;
double sifretekrarheight = 0;
double girisheight = 0;
double giriswidth = 0;
String gtext = "GİRİŞ YAP";
String sayfa = "g";
bool showSpinner = false;

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LogresPage extends StatefulWidget {
  const LogresPage(
      {super.key, required this.title, required this.h, required this.w});

  final String title;
  final double h;
  final double w;

  @override
  State<LogresPage> createState() => _LogresState();
}

class _LogresState extends State<LogresPage>
    with SingleTickerProviderStateMixin {
  @override
  late AnimationController _controller;

  void initState() {
    loadBannerAd();

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

    // TODO: implement initState
    kullanimheight = widget.h / 20;
    giriswidth = widget.w * 7 / 10;
    extraheight = widget.h / 22;
    girisheight = widget.h / 22;
    super.initState();
  }

  bool _isLoaded = false;
  BannerAd? _bannerAd;
  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    _controller.dispose();

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

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                child: RotatedBox(
                    quarterTurns: 1,
                    child: Lottie.asset(
                      'assets/star.json',
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller.duration = composition.duration;
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
              Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Container(
                      width: width * 7 / 10,
                      height: (width * 7 / 10) * 2488 / 3264,
                      child: Stack(
                        children: [
                          Positioned(
                              left: 2,
                              top: 2,
                              child: Container(
                                  width: width * 7 / 10,
                                  height: (width * 7 / 10) * 2488 / 3264,
                                  child: Image.asset(
                                    "images/sb.png",
                                    color: Colors.black54,
                                  ))),
                          Positioned(
                              child: Container(
                                  width: width * 7 / 10,
                                  height: (width * 7 / 10) * 2488 / 3264,
                                  child: Image.asset("images/ss.png")))
                        ],
                      ),
                    ),
                    Text(
                      errortext,
                      style: TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                      ),
                    ),
                    loginField(
                      color: textcolor,
                      func: (v) {
                        setState(() {
                          ad = v;
                          if (ad == "") {
                            errortext = "";
                            textcolor = Color(0xff16345C);
                          }
                        });
                      },
                      heigh: adsoyadheight,
                      width: width, //width
                      text: "Ad Soyad",
                    ),
                    loginField(
                        color: textcolor,
                        func: (v) {
                          setState(() {
                            email = v;
                            if (email == "") {
                              errortext = "";
                              textcolor = Color(0xff16345C);
                            }
                          });
                        },
                        heigh: height / 19,
                        width: width,
                        text: "E-Mail"),
                    loginField(
                        color: textcolor,
                        func: (v) {
                          setState(() {
                            password = v;
                            if (password == "") {
                              errortext = "";
                              textcolor = Color(0xff16345C);
                            }
                          });
                        },
                        heigh: height / 19,
                        width: width,
                        text: "Şifre"),
                    loginField(
                      color: textcolor,
                      func: (v) {
                        setState(() {
                          passwordtekrar = v;
                          if (passwordtekrar == "") {
                            errortext = "";
                            textcolor = Color(0xff16345C);
                          }
                        });
                      },
                      heigh: sifretekrarheight,
                      width: width,
                      text: "Şifre Tekrar",
                    ),
                    loginbutton(
                      c: Colors.white,
                      func: () async {
                        if (sayfa == "g") {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final au = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (au != null) {
                              Navigator.pushNamed(context, 'home');
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            setState(() {
                              errortext = "Hatalı E-Mail ya da Şifre.";
                              textcolor = Colors.red;
                            });
                            print(e);
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      },
                      heigh: girisheight,
                      width: giriswidth,
                      text: gtext,
                      marg: 20,
                      tc: Color(0xff16345C),
                    ),
                    loginbutton(
                      c: kayitcolor,
                      func: () async {
                        if (sayfa == "k") {
                          if (passwordtekrar == password) {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);

                              if (newUser != null) {
                                await _firestore.collection('bilgiler').add({
                                  "ad": ad,
                                  "mail": email,
                                  "coin": 0,
                                  "aktiffaltarih": "",
                                  "aktifkahvefalı": "yok",
                                  "toplambakılanfal": 0
                                });
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pushNamed(context, "home");
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              setState(() {
                                errortext =
                                    "Hatalı, Eksik ya da Kayıtlı E-Mail.";
                                textcolor = Colors.red;
                              });
                              setState(() {
                                showSpinner = false;
                              });
                              print(e);
                            }
                          } else {
                            setState(() {
                              errortext = "Şifreler birbiriyle uyuşmuyor.";
                              textcolor = Colors.red;
                            });
                          }
                        }
                        setState(() {
                          if (sayfa == "g") {
                            setState(() {
                              errortext = "";
                              textcolor = Color(0xff16345C);
                            });
                            sayfa = "k";
                            extraheight = 0;
                            kullanimheight = 0;
                            geridonheight = height / 25;
                            girisheight = 0;
                            sifretekrarheight = height / 19;
                            adsoyadheight = height / 19;
                          }
                        });
                      },
                      heigh: height / 22,
                      width: width * 7 / 10,
                      text: "KAYIT OL",
                      marg: 10,
                      tc: Color(0xff16345C),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      margin: EdgeInsets.only(top: 10),
                      height: geridonheight,
                      width: width * 3 / 10,
                      decoration: BoxDecoration(
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
                          backgroundColor: WidgetStateProperty.all(kayitcolor),
                        ),
                        onPressed: () {
                          if (sayfa == "k") {
                            setState(() {
                              setState(() {
                                errortext = "";
                                textcolor = Color(0xff16345C);
                              });
                              kullanimheight = height / 20;
                              extraheight = height / 22;
                              sayfa = "g";
                              geridonheight = 0;
                              girisheight = height / 22;
                              sifretekrarheight = 0;
                              adsoyadheight = 0;
                            });
                          }
                        },
                        child: Text(
                          "Girişe Geri Dön",
                          style: TextStyle(
                              color: Color(0xff16345C),
                              fontSize: geridonheight / 3),
                        ),
                      ),
                    ),
                    loginbuttonclas(
                        tc: Colors.white,
                        func: () async {
                          if (sayfa == "g") {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser = await signInWithGoogle();
                              if (true) {
                                var key = false;
                                var mmail = newUser.user!.email;
                                var nname = (newUser.user!.displayName);
                                await _firestore
                                    .collection("bilgiler")
                                    .get()
                                    .then((event) {
                                  for (var doc in event.docs) {
                                    if (doc.data()["mail"] == mmail) {
                                      key = true;
                                    }
                                  }
                                });
                                if (!key) {
                                  await _firestore.collection('bilgiler').add({
                                    "ad": nname,
                                    "mail": mmail,
                                    "coin": 0,
                                    "aktiffaltarih": "",
                                    "aktifkahvefalı": "yok",
                                    "toplambakılanfal": 0
                                  });
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  if (newUser != null) {
                                    Navigator.pushNamed(context, "home");
                                  }
                                } else {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  if (newUser != null) {
                                    Navigator.pushNamed(context, "home");
                                  }
                                }
                              }
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              print(e);
                            }
                          }
                        },
                        im: "google",
                        marg: 30,
                        text: "Sign in with Google",
                        heigh: extraheight,
                        width: width * 6 / 10,
                        c: Colors.red),
                    loginbuttonclas(
                        tc: Colors.white,
                        func: () async {
                          if (sayfa == "g") {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser = await signInWithFacebook();

                              if (true) {
                                var key = false;
                                var mmail = newUser.user!.email;
                                var nname = (newUser.user!.displayName);
                                await _firestore
                                    .collection("bilgiler")
                                    .get()
                                    .then((event) {
                                  for (var doc in event.docs) {
                                    if (doc.data()["mail"] == mmail) {
                                      key = true;
                                    }
                                  }
                                });
                                if (!key) {
                                  await _firestore.collection('bilgiler').add({
                                    "ad": nname,
                                    "mail": mmail,
                                    "coin": 0,
                                    "aktiffaltarih": "",
                                    "aktifkahvefalı": "yok",
                                    "toplambakılanfal": 0
                                  });
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  if (newUser != null) {
                                    Navigator.pushNamed(context, "home");
                                  }
                                } else {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  if (newUser != null) {
                                    Navigator.pushNamed(context, "home");
                                  }
                                }
                              }
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              print(e);
                            }
                          }
                        },
                        marg: 10,
                        im: "facebook",
                        text: "Sign in with Facebook",
                        heigh: extraheight,
                        width: width * 6 / 10,
                        c: Colors.blueAccent),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Made by Açelya & Yiğit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height / 20,
                      child: TextButton(
                          onPressed: () {
                            var url = Uri.parse(
                                "https://www.privacypolicies.com/live/8b8ad254-8730-45af-99a8-43f2b685b085");
                            launchUrl(url);
                          },
                          child: Text(
                            "Kullanım Koşulları ve Gizlilik Politikası",
                            style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
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
          backgroundColor: WidgetStateProperty.all(c),
        ),
        onPressed: () {
          func();
        },
        child: Text(
          text,
          style: TextStyle(color: tc),
        ),
      ),
    );
  }
}

class loginField extends StatelessWidget {
  const loginField({
    super.key,
    required this.color,
    required this.text,
    required this.heigh,
    required this.func,
    required this.width,
  });

  final Color color;
  final Function func;
  final String text;
  final double heigh;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      margin: EdgeInsets.only(bottom: 5),
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
      width: (heigh != 0) ? width * 8 / 10 : 0,
      child: TextField(
        autofocus: false,
        onChanged: (value) {
          func(value);
        },
        style: TextStyle(
          color: textcolor,
          fontSize: heigh * 18 / 60,
        ),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: text,
          hintStyle: TextStyle(
            color: textcolor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xff16345C), width: 0.0),
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff16345C), width: 0.0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff16345C), width: 0.0),
              borderRadius: BorderRadius.circular(20)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff16345C), width: 0.0),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class loginbuttonclas extends StatelessWidget {
  const loginbuttonclas({
    super.key,
    required this.im,
    required this.func,
    required this.marg,
    required this.text,
    required this.heigh,
    required this.width,
    required this.c,
    required this.tc,
  });

  final String im;
  final Function func;
  final String text;
  final double marg;
  final double heigh;
  final double width;
  final Color c;
  final Color tc;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
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
          backgroundColor: WidgetStateProperty.all(c),
        ),
        onPressed: () {
          func();
        },
        child: Stack(
          children: [
            Positioned(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(((im == "google")
                          ? "images/white-google-logo.png"
                          : "images/facebook-app-round-white-icon.png")),
                    ),
                    Spacer(),
                  ]),
            ),
            Positioned(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(color: tc),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
