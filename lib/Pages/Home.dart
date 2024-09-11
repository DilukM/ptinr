import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:ptinr/Controllers/intensity.dart';
import 'package:ptinr/Controllers/ptinr_calculator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RedHome extends StatefulWidget {
  const RedHome({
    super.key,
  });

  @override
  State<RedHome> createState() => _RedHomeState();
}

class _RedHomeState extends State<RedHome> {
  bool isPTImageSelected = false;
  bool isHCTImageSelected = false;

  File? _ptImage;
  File? _hctImage;

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

  String PTResult = "Result";
  String HCTResult = "Result";
  String PTDiagnosis = "";
  String HCTDiagnosis = "";

  final ImagePicker _picker = ImagePicker();
  final PTINRCalculator _ptinrCalculator = PTINRCalculator();
  final RedColorDetector _redColorDetector = RedColorDetector();

  Future<void> _pickImage(bool isPTImage) async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // Change to ImageSource.camera for camera
    if (image != null) {
      setState(() {
        if (isPTImage) {
          _ptImage = File(image.path);
          isPTImageSelected = true;
        } else {
          _hctImage = File(image.path);
          isHCTImageSelected = true;
        }
      });
    }
  }

  Future<void> _calculatePTINR() async {
    if (_ptImage != null) {
      setState(() {
        isCalculating = true;
      });

      // Call the function from PTINRCalculator
      final length = await _ptinrCalculator.calculatePTINRDimensions(_ptImage!);
      final intensity = await _redColorDetector.processImage(_ptImage!);

      setState(() {
        ptImageHeight = length['height'];
        ptImageWidth = length['width'];

        double PT_Distance = ptImageWidth! / (ptImageHeight! / 2);

        isCalculating = false;

        redIntensity = intensity['averageRedIntensity'];
        redLightness = intensity['averageRedLightness'];
        isProcessing = false;
        PTDiagnosis =
            "PT Image Height = $ptImageHeight \nPT Image Width = $ptImageWidth \nRed Intensity = $redIntensity\n";

        PTResult = (1.3214 + 0.0057 * PT_Distance + -0.0019 * redIntensity!)
            .toStringAsFixed(2);
      });
    }
  }

  Future<void> _calculateHCT() async {
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

        double HCT_Distance = hctImageWidth! / (hctImageHeight! / 2);

        isCalculating = false;

        hct_redIntensity = intensity['averageRedIntensity'];
        hct_redLightness = intensity['averageRedLightness'];
        isProcessing = false;
        HCTDiagnosis =
            "HCT Image Height = $hctImageHeight \nHCT Image Width = $hctImageWidth \nRed Intensity = $hct_redIntensity";

        HCTResult =
            (13.6858 + 0.0304 * HCT_Distance + -0.0098 * hct_redIntensity!)
                .toStringAsFixed(2);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "PTINR Finder",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImageContainer(
                      context, "PT Image", _ptImage, isPTImageSelected, true),
                  _buildImageContainer(context, "HCT Image", _hctImage,
                      isHCTImageSelected, false),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text(
                          "Results",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
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
                                                Color.fromARGB(255, 1, 97, 16),
                                                Color.fromARGB(
                                                    255, 10, 122, 33),
                                              ],
                                              tileMode: TileMode.mirror,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Calculate PTINR",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            PTResult,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
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
                                                Color.fromARGB(255, 1, 97, 16),
                                                Color.fromARGB(
                                                    255, 10, 122, 33),
                                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                              tileMode: TileMode.mirror,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Calculate HCT",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            HCTResult,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text(
                          "Diagnosis",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              // SizedBox(
                              //   height: 40,
                              //   child: GestureDetector(
                              //     onTap: () {},
                              //     child: Container(
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(12),
                              //           boxShadow: [
                              //             const BoxShadow(
                              //                 color: Colors.black45,
                              //                 offset: Offset(3, 3),
                              //                 blurRadius: 5)
                              //           ],
                              //           gradient: const LinearGradient(
                              //             begin: Alignment.topLeft,
                              //             end: Alignment(0.8, 1),
                              //             colors: <Color>[
                              //               Color.fromARGB(255, 1, 97, 16),
                              //               Color.fromARGB(255, 10, 122, 33),
                              //             ], // Gradient from https://learnui.design/tools/gradient-generator.html
                              //             tileMode: TileMode.mirror,
                              //           ),
                              //         ),
                              //         child: const Center(
                              //           child: Text(
                              //             "Calculate PTINR",
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.bold,
                              //             ),
                              //           ),
                              //         )),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(PTDiagnosis + HCTDiagnosis)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildImageContainer(BuildContext context, String title, File? image,
      bool isImageSelected, bool isPTImage) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 40,
            child: GestureDetector(
              onTap: () => _pickImage(isPTImage),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(3, 3),
                        blurRadius: 5)
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(255, 1, 97, 16),
                      Color.fromARGB(255, 10, 122, 33),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Load Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isImageSelected && image != null)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.file(
                image,
                height: 100,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Upload Image"),
            ),
        ],
      ),
    );
  }
}
