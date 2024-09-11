import 'dart:io';
import 'package:image/image.dart' as img;

class RedColorDetector {
  // Convert RGB to HSV
  List<double> _rgbToHsv(int red, int green, int blue) {
    double r = red / 255;
    double g = green / 255;
    double b = blue / 255;

    double max = [r, g, b].reduce((a, b) => a > b ? a : b);
    double min = [r, g, b].reduce((a, b) => a < b ? a : b);
    double delta = max - min;

    double hue = 0.0;
    if (delta != 0) {
      if (max == r) {
        hue = ((g - b) / delta) % 6;
      } else if (max == g) {
        hue = (b - r) / delta + 2;
      } else if (max == b) {
        hue = (r - g) / delta + 4;
      }
      hue *= 60;
    }
    if (hue < 0) hue += 360;

    double saturation = (max == 0) ? 0 : delta / max;
    double value = max;

    return [hue, saturation, value];
  }

  // Convert HSV to Lightness
  double _hsvToLightness(double hue, double saturation, double value) {
    return value * (1 - saturation / 2);
  }

  // Function to process the image and detect red areas, returning average intensity and lightness
  Future<Map<String, double>> processImage(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    final image = img.decodeImage(imageBytes);

    if (image != null) {
      img.Image processedImage = img.Image.from(image);
      List<double> redIntensities = [];
      List<double> redLightnessValues = [];

      for (int y = 0; y < processedImage.height; y++) {
        for (int x = 0; x < processedImage.width; x++) {
          final pixel = processedImage.getPixel(x, y);

          // Extract red, green, and blue values
          final red = pixel.r.toInt();
          final green = pixel.g.toInt();
          final blue = pixel.b.toInt();

          // Convert RGB to HSV
          final hsv = _rgbToHsv(red, green, blue);
          final hue = hsv[0];
          final saturation = hsv[1];
          final value = hsv[2];

          // Check if the pixel is red based on hue and saturation in HSV space
          if ((hue >= 0 && hue <= 10 || hue >= 340 && hue <= 360) &&
              saturation > 0.5 &&
              value > 0.3) {
            // Calculate red intensity as a percentage
            // final redIntensity = (red / 255) * 100;
            redIntensities.add(red.toDouble());

            // Convert HSV to HSL to get the lightness percentage
            final lightness = _hsvToLightness(hue, saturation, value) * 100;
            redLightnessValues.add(lightness);
          }
        }
      }

      // Calculate average intensity and lightness
      double averageRedIntensity = redIntensities.isEmpty
          ? 0.0
          : redIntensities.reduce((a, b) => a + b) / redIntensities.length;

      double averageRedLightness = redLightnessValues.isEmpty
          ? 0.0
          : redLightnessValues.reduce((a, b) => a + b) /
              redLightnessValues.length;

      return {
        'averageRedIntensity': averageRedIntensity,
        'averageRedLightness': averageRedLightness
      };
    }

    // Return 0 for both values if no image was processed
    return {'averageRedIntensity': 0.0, 'averageRedLightness': 0.0};
  }
}
