import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';

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

String faltext = "";

class _TarotOkumaScreenState extends State<TarotOkumaScreen> {
  @override
  void initState() {
    super.initState();
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
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: widget.h / 40, bottom: widget.h / 40),
                    alignment: Alignment.center,
                    width: widget.w * 9 / 10,
                    height: widget.h / 10,
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
                    child: Text(
                      "Reklam",
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: widget.h / 40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xff6F4E37),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          color: Colors.white, fontSize: widget.h / 65),
                      faltext.toString(),
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
