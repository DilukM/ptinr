import 'dart:async';
import 'dart:ffi';

import 'package:ptinr/Pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen() : super();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToNext();
  }

  void goToNext() {
    Timer(
      Duration(seconds: 5),
      () async => Navigator.pushReplacement(
        context,
        PageTransition(
          child: await RedHome(),
          type: PageTransitionType.rightToLeftWithFade,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/BG.png'), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.0,
                child: Image.asset("assets/logo.png"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: LoadingAnimationWidget.prograssiveDots(
                  color: Color.fromARGB(255, 46, 125, 124),
                  size: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
