import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:ptinr/Controllers/intensity.dart';
import 'package:ptinr/Controllers/ptinr_calculator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Diagnosis extends StatefulWidget {
  final String? PTResult;
  final String? HCTResult;
  Diagnosis({
    super.key,
    this.PTResult,
    this.HCTResult,
  });

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  double? ptImageHeight;
  double? ptImageWidth;
  bool isCalculating = false;

  double? redIntensity;
  double? redLightness;
  bool isProcessing = false;

  double? hctImageHeight;
  double? hctImageWidth;

  double? hct_redIntensity;
  double? hct_redLightness;

  double PTResult = 0;
  double HCTResult = 0;
  String PTDiagnosis = "";
  String HCTDiagnosis = "";

  int MF = 0;
  int YN = 0;

  @override
  void initState() {
    PTResult = double.parse(widget.PTResult!);
    HCTResult = double.parse(widget.HCTResult!);
    super.initState();
  }

  final PTINRCalculator _ptinrCalculator = PTINRCalculator();
  final RedColorDetector _redColorDetector = RedColorDetector();

  String getPTDiagnosis() {
    if (YN == 0 && PTResult > 2 && PTResult < 3) {
      return "PT is In Range";
    } else if (YN == 1 && PTResult > 0.8 && PTResult < 1.1) {
      return "PT is In Range";
    } else if (YN == 0 && PTResult < 2) {
      return "PT is Low";
    } else if (YN == 1 && PTResult < 0.8) {
      return "PT is Low";
    } else {
      return "PT is High";
    }
  }

  String getHCTDiagnosis() {
    if (MF == 0 && 40 < HCTResult && HCTResult < 54) {
      return "HCT is In Range";
    } else if (MF == 1 && HCTResult > 36 && HCTResult < 48) {
      return "HCT is In Range";
    } else if (MF == 0 && HCTResult < 40) {
      return "HCT is Low";
    } else if (MF == 1 && HCTResult < 36) {
      return "HCT is Low";
    } else {
      return "HCT is High";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Container(
              height: 90,
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/logo.png')),
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      textAlign: TextAlign.center,
                      "DIAGNOSIS",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildPTSection(),
                  Divider(
                    color: Colors.grey[300],
                    height: 40,
                  ),
                  buildHCTSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Widget to build PT section
  Widget buildPTSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        const BoxShadow(
            color: Colors.black26, offset: Offset(3, 3), blurRadius: 5)
      ], color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(255, 248, 186, 186),
                      Color.fromARGB(255, 248, 186, 186),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Male / Female",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          ToggleSwitch(
            minWidth: 110.0,
            initialLabelIndex: MF,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: ['Male', 'Female'],
            icons: [Icons.male, Icons.female],
            activeBgColors: [
              [Color.fromARGB(255, 250, 100, 100)],
              [Color.fromARGB(255, 250, 100, 100)]
            ],
            onToggle: (index) {
              setState(() {
                MF = index!;
              });
            },
          ),
          //Result Start

          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              padding: EdgeInsets.all(5),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(255, 250, 235, 235),
                  border: Border.all(
                    width: 2,
                    color: Color.fromARGB(255, 250, 100, 100),
                  )),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  getHCTDiagnosis(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 250, 100, 100),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHCTSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        const BoxShadow(
            color: Colors.black26, offset: Offset(3, 3), blurRadius: 5)
      ], color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(255, 142, 205, 204),
                      Color.fromARGB(255, 142, 205, 204),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "On Anticoagulation medication? Y/N",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          ToggleSwitch(
            minWidth: 110.0,
            initialLabelIndex: YN,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: ['Yes', 'No'],
            icons: [Icons.check, Icons.close],
            activeBgColors: [
              [Color.fromARGB(255, 46, 125, 124)],
              [Color.fromARGB(255, 46, 125, 124)]
            ],
            onToggle: (index) {
              setState(() {
                YN = index!;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              padding: EdgeInsets.all(5),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(255, 228, 244, 228),
                  border: Border.all(
                    width: 2,
                    color: Color.fromARGB(255, 142, 205, 204),
                  )),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  getPTDiagnosis(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 71, 162, 160),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
