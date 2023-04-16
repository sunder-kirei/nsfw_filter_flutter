import 'package:flutter/material.dart';
import 'package:profanity_detector/screens/image_filter.dart';
import 'package:profanity_detector/screens/text_filter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Profanity Detector"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.text_fields_rounded),
                  text: "Text Filter",
                ),
                Tab(
                  icon: Icon(Icons.camera_alt_rounded),
                  text: "Image Filter",
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TextFilter(),
              ImageFilter(),
            ],
          ),
        ),
      ),
    );
  }
}
