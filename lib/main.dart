import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telveli/cred.dart';
import 'package:telveli/falpages/turkfal.dart';
import 'package:telveli/logres.dart';
import 'package:telveli/home.dart';
import 'package:telveli/tarotpages/tarotbilgi.dart';
import 'package:telveli/tarotpages/desta.dart';
import 'package:telveli/falpages/turkfalokuma.dart';
import 'package:telveli/falpages/turkfalbilgi.dart';
import 'package:telveli/tarotpages/tarotbilgiek.dart';
import 'package:telveli/tarotpages/tarotokuma.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: apikeyy,
    appId: appidd,
    messagingSenderId: 'sendid',
    projectId: 'telveli-6d2af',
    storageBucket: 'gs://telveli-6d2af.appspot.com',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double safearea = MediaQuery.of(context).padding.top;

    return MaterialApp(
      initialRoute: 'logres',
      routes: {
        'logres': (context) => LogresPage(
              title: 'TELVELI',
              h: height,
              w: width,
            ),
        'home': (context) => HomeScreen(
              h: height,
              w: width,
              s: safearea,
            ),
        'turkfal': (context) => TurkfalScreen(
              h: height,
              w: width,
              s: safearea,
            ),
        'trfalbilgi': (context) =>
            TurkBilgiScreen(h: height, w: width, s: safearea),
        'trfalokuma': (contex) =>
            TrFalOkumaScreen(h: height, w: width, s: safearea),
        'tarotekbilgi': (context) => TarotBilgiEkScreen(
              h: height,
              w: width,
              s: safearea,
            ),
        'tarotbilgi': (context) => TarotBilgiScreen(
              h: height,
              w: width,
              s: safearea,
            ),
        'tarotokuma': (context) =>
            TarotOkumaScreen(h: height, w: width, s: safearea),
        'deste': (context) => DesteScreen(
              h: height,
              w: width,
              s: safearea,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
