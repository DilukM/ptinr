import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:ptinr/Controllers/intensity.dart';
import 'package:ptinr/Controllers/ptinr_calculator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ptinr/Pages/Calculate.dart';
import 'package:toastification/toastification.dart';

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

  final ImagePicker _picker = ImagePicker();

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
          automaticallyImplyLeading: false,
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
                isPTImageSelected && isHCTImageSelected
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Calculate(
                                  ptImage: _ptImage,
                                  hctImage: _hctImage,
                                )))
                    : toastification.show(
                        type: ToastificationType.error,
                        style: ToastificationStyle.fillColored,
                        context: context,
                        title: Text('Please select an image'),
                        autoCloseDuration: const Duration(seconds: 2),
                      );
              },
              child: Text(
                "Calculate",
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
                  _buildImageContainer(
                    context,
                    "Upload HCT Strip Image",
                    _hctImage,
                    isHCTImageSelected,
                    false,
                    Color.fromARGB(255, 248, 186, 186),
                    Color.fromARGB(255, 248, 186, 186),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildImageContainer(
                    context,
                    "Upload PT Strip Image",
                    _ptImage,
                    isPTImageSelected,
                    true,
                    Color.fromARGB(255, 142, 205, 204),
                    Color.fromARGB(255, 142, 205, 204),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, String title, File? image,
      bool isImageSelected, bool isPTImage, Color c1, Color c2) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      c1,
                      c2,
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
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
            Container(
              margin: EdgeInsets.all(12),
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_search),
                  Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
