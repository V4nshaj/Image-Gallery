import 'package:flutter/material.dart';
import 'screens/image_screen.dart';

void main() {
  runApp(Gallery());
}

class Gallery extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: ImageScreen.id,
      routes: {
        ImageScreen.id: (context) => ImageScreen(),
      },
    );
  }
}
