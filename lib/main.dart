import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:ptinr/Pages/Home.dart';
import 'package:ptinr/Pages/SplashScreen.dart';
import 'package:ptinr/Theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: App(camera: firstCamera),
    ),
  );
}

class App extends StatelessWidget {
  final CameraDescription camera;
  const App({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTINR Finder',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/redhome': (context) => RedHome(),
      },
    );
  }
}
