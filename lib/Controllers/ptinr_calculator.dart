import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class PTINRCalculator {
  double _imageWidth = 0;
  double _imageHeight = 0;
  final double knownHeightInMillimeters =
      3.3; // Known physical height of the object

  // Function that processes the image and returns height and width in mm
  Future<Map<String, double>> calculatePTINRDimensions(File ptImage) async {
    // Get the image dimensions
    var decodedImage = await decodeImageFromList(ptImage.readAsBytesSync());
    _imageWidth = decodedImage.width.toDouble();
    _imageHeight = decodedImage.height.toDouble();

    final res = await Tflite.detectObjectOnImage(
      path: ptImage.path,
      numBoxesPerBlock: 1,
      threshold: 0.05,
      numResultsPerClass: 1,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (res != null && res.isNotEmpty) {
      // Get the first detected object
      var firstRecognition = res[0];

      // Extract the bounding box dimensions in pixels
      double detectedWidthInPixels =
          firstRecognition['rect']['w'] * _imageWidth;
      double detectedHeightInPixels =
          firstRecognition['rect']['h'] * _imageHeight;

      // Calculate the pixels-to-millimeters conversion factor
      double pixelsPerMillimeter =
          detectedHeightInPixels / knownHeightInMillimeters;

      // Convert width and height to millimeters
      double widthInMillimeters = detectedWidthInPixels / pixelsPerMillimeter;
      double heightInMillimeters = detectedHeightInPixels / pixelsPerMillimeter;

      return {
        'width': widthInMillimeters,
        'height': heightInMillimeters,
      };
    } else {
      print('No objects detected.');
      return {'width': 0, 'height': 0};
    }
  }
}
