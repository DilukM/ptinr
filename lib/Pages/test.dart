import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class PTINRPage extends StatefulWidget {
  @override
  _PTINRPageState createState() => _PTINRPageState();
}

class _PTINRPageState extends State<PTINRPage> {
  File? _image; // The selected image file
  List<dynamic>? _recognitions; // Detected objects with bounding boxes
  double _imageWidth = 0;
  double _imageHeight = 0;
  final picker = ImagePicker();

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

  // Pick an image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      setState(() {
        _image = image;
        _recognitions = null; // Reset detection results
      });

      await detectObject(image);
    }
  }

  // Detect objects on the selected image
  Future<void> detectObject(File imageFile) async {
    // Get image dimensions
    var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    setState(() {
      _imageWidth = decodedImage.width.toDouble();
      _imageHeight = decodedImage.height.toDouble();
    });

    final res = await Tflite.detectObjectOnImage(
      path: imageFile.path,
      numBoxesPerBlock: 1,
      threshold: 0.05,
      numResultsPerClass: 1,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _recognitions = res;
    });
  }

  // Draw the bounding box on the image
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PTINR Object Detection'),
      ),
      body: Center(
        child: Column(
          children: [
            _image != null
                ? Stack(
                    children: [
                      Image.file(_image!), // Display the selected image
                      if (_recognitions != null)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: BoundingBoxPainter(
                              _recognitions!,
                              _imageWidth,
                              _imageHeight,
                            ),
                          ),
                        )
                    ],
                  )
                : Text('No image selected.'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  child: Text('Pick from Gallery'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),
                  child: Text('Take a Picture'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List recognitions;
  final double imageWidth;
  final double imageHeight;

  BoundingBoxPainter(this.recognitions, this.imageWidth, this.imageHeight);

  @override
  void paint(Canvas canvas, Size size) {
    // Scaling factor to adapt to screen size
    double scaleX = size.width / imageWidth;
    double scaleY = size.height / imageHeight;

    for (var recognition in recognitions) {
      // Normalize to image size and then scale to fit screen
      var _x = recognition["rect"]["x"] * imageWidth * scaleX;
      var _w = recognition["rect"]["w"] * imageWidth * scaleX;
      var _y = recognition["rect"]["y"] * imageHeight * scaleY;
      var _h = recognition["rect"]["h"] * imageHeight * scaleY;

      print(_w);
      print(_h);

      var rect = Rect.fromLTWH(_x, _y, _w, _h);
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
