import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:ptinr/Controllers/intensity.dart';
import 'package:ptinr/Controllers/ptinr_calculator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ptinr/Pages/Diagnosis.dart';
import 'package:toastification/toastification.dart';

class Calculate extends StatefulWidget {
  final File? ptImage;
  final File? hctImage;
  Calculate({
    super.key,
    required this.ptImage,
    required this.hctImage,
  });

  @override
  State<Calculate> createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  bool ptResultCalculated = false;
  bool hctResultCalculated = false;

  File? _ptImage;
  File? _hctImage;

  double? ptImageHeight = 0;
  double? ptImageWidth = 0;
  bool isCalculating = false;

  double? redIntensity;
  double? redLightness;
  bool isProcessing = false;

  double? hctImageHeight = 0;
  double? hctImageWidth = 0;

  double? hct_redIntensity;
  double? hct_redLightness;

  double PTResult = 0;
  double HCTResult = 0;

  final PTINRCalculator _ptinrCalculator = PTINRCalculator();
  final RedColorDetector _redColorDetector = RedColorDetector();

  Future<void> _calculatePTINR() async {
    _ptImage = widget.ptImage;
    if (_ptImage != null && hctResultCalculated) {
      setState(() {
        isCalculating = true;
      });

      // Call the function from PTINRCalculator
      final length = await _ptinrCalculator.calculatePTINRDimensions(_ptImage!);
      final intensity = await _redColorDetector.processImage(_ptImage!);

      setState(() {
        ptImageHeight = length['height'];
        ptImageWidth = length['width'];

        double PT_Distance = ptImageWidth!.toInt() * 100;

        isCalculating = false;

        redIntensity = intensity['averageRedIntensity'];
        redLightness = intensity['averageRedLightness'];
        isProcessing = false;

        PTResult = 1.3820242314914 +
            0.00562413813790166 * PT_Distance -
            0.00158872089189541 * redIntensity! -
            0.00254906778049767 * HCTResult;
        ptResultCalculated = true;
      });
    } else {
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        context: context,
        title: Text('Please Calculate HCT Results First'),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _calculateHCT() async {
    _hctImage = widget.hctImage;
    if (_hctImage != null) {
      setState(() {
        isCalculating = true;
      });

      // Call the function from PTINRCalculator
      final length =
          await _ptinrCalculator.calculatePTINRDimensions(_hctImage!);
      final intensity = await _redColorDetector.processImage(_hctImage!);

      setState(() {
        hctImageHeight = length['height'];
        hctImageWidth = length['width'];
        print("Height: $hctImageHeight");
        print("width: $hctImageWidth");

        double HCT_Distance = hctImageWidth!.toInt() * 100;

        isCalculating = false;

        hct_redIntensity = intensity['averageRedIntensity'];
        hct_redLightness = intensity['averageRedLightness'];
        isProcessing = false;

        HCTResult = 13.6857692363739 +
            0.0303837041313958 * HCT_Distance -
            0.00983776911732203 * hct_redIntensity!;
        hctResultCalculated = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future _loadModel() async {
    await Tflite.loadModel(
      model: "assets/model5.tflite",
      labels: "assets/lables.txt",
      //useGpuDelegate: true,
    );
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
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(12),
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color.fromARGB(255, 245, 195, 139)),
              onPressed: () {
                ptResultCalculated && hctResultCalculated
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Diagnosis(
                                  PTResult: PTResult.toStringAsFixed(2),
                                  HCTResult: HCTResult.toStringAsFixed(2),
                                )))
                    : toastification.show(
                        type: ToastificationType.error,
                        style: ToastificationStyle.fillColored,
                        context: context,
                        title: Text('Please Calculate Results'),
                        autoCloseDuration: const Duration(seconds: 2),
                      );
              },
              child: Text(
                "Diagnosis",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
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
                          "Test Results",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: GestureDetector(
                                    onTap: _calculateHCT,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            const BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(3, 3),
                                                blurRadius: 5)
                                          ],
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment(0.8, 1),
                                            colors: <Color>[
                                              Color.fromARGB(
                                                  255, 248, 186, 186),
                                              Color.fromARGB(
                                                  255, 248, 186, 186),
                                            ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                            tileMode: TileMode.mirror,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Calculate HCT%",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 3,
                                          color: Color.fromARGB(
                                              255, 248, 186, 186),
                                        )),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            HCTResult.toStringAsFixed(2),
                                            style: TextStyle(
                                                color: HCTResult == "Result"
                                                    ? Colors.grey[400]
                                                    : Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))),
                                Image.file(
                                  widget.hctImage!,
                                  height: 100,
                                ),
                                Text("Height: $hctImageHeight"),
                                Text("Width: $hctImageWidth"),
                                Text(
                                    "Distance: ${hctImageWidth!.toInt() * 100}"),
                                Text("Red Intensity: $hct_redIntensity"),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[300],
                            height: 40,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(3, 3),
                                      blurRadius: 5)
                                ],
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: GestureDetector(
                                    onTap: _calculatePTINR,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            const BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(3, 3),
                                                blurRadius: 5)
                                          ],
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment(0.8, 1),
                                            colors: <Color>[
                                              Color.fromARGB(
                                                  255, 142, 205, 204),
                                              Color.fromARGB(
                                                  255, 142, 205, 204),
                                            ],
                                            tileMode: TileMode.mirror,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Calculate PTINR",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 3,
                                          color: Color.fromARGB(
                                              255, 142, 205, 204),
                                        )),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            PTResult.toStringAsFixed(2),
                                            style: TextStyle(
                                                color: PTResult == "Result"
                                                    ? Colors.grey[400]
                                                    : Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))),
                                Image.file(
                                  widget.ptImage!,
                                  height: 100,
                                ),
                                Text("Height: $ptImageHeight"),
                                Text("WIdth: $ptImageWidth"),
                                Text(
                                    "Distance: ${ptImageWidth!.toInt() * 100}"),
                                Text("Red Intensity: $redIntensity"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
