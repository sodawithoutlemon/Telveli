import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

String faltext = "senisevom";
String text = "";
String docid = "";
double datetop = 0;

class TurkBilgiScreen extends StatefulWidget {
  const TurkBilgiScreen(
      {super.key, required this.h, required this.w, required this.s});

  final double s;
  final double h;
  final double w;

  @override
  _TurkBilgiScreenState createState() => _TurkBilgiScreenState();
}

String username = "Ad Soyad";
String usermail = "";
String userdate = "Doğum Tarihi";

late var args;

class _TurkBilgiScreenState extends State<TurkBilgiScreen> {
  @override
  void initState() {
    datetop = widget.h * 3 - (widget.h / 2.5);
    // TODO: implement initState

    super.initState();
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
              color: Color(0xffB67233),
              child: Column(
                children: [
                  topWidget(widget: widget),
                  Container(
                    width: widget.w,
                    height: widget.h * 42 / 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: widget.h / 20, bottom: widget.h / 30),
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
                              "Bilgilerinizi girin."),
                        ),
                        loginField(
                            text: username,
                            heigh: widget.h / 20,
                            func: (x) {
                              setState(() {
                                username = x;
                              });
                            },
                            width: widget.w * 6 / 10),
                        Container(
                          margin: EdgeInsets.only(bottom: widget.h / 20),
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
                          height: widget.h / 20,
                          width: widget.w * 6 / 10,
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
                        loginbutton(
                            func: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (userdate == "Doğum Tarihi") {
                                userdate = "01/01/2000";
                              }
                              Navigator.pushNamed(context, 'turkfal',
                                  arguments: {
                                    "authdocc": args["authdocc"],
                                    "date": userdate,
                                    "name": username
                                  });
                            },
                            marg: widget.h / 100,
                            text: "Devam",
                            heigh: widget.h / 20,
                            width: widget.w / 2),
                        Container(
                          alignment: Alignment.center,
                          child: Text("reklam"),
                          margin: EdgeInsets.only(top: widget.h / 25),
                          color: Colors.white,
                          width: widget.w,
                          height: widget.h / 10,
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

class topWidget extends StatelessWidget {
  const topWidget({
    super.key,
    required this.widget,
  });

  final TurkBilgiScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            margin: EdgeInsets.only(left: widget.w / 15),
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
                borderSide: BorderSide(color: Color(0xffB67233), width: 0.0),
              ),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB67233), width: 0.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB67233), width: 0.0),
                  borderRadius: BorderRadius.circular(20)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffB67233), width: 0.0),
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
