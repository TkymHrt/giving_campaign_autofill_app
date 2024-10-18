import 'package:flutter/material.dart';
import 'package:giving_campaign_autofill_app/pages/auto_input_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giving Campaign Autofill app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AutoInputPage(),
    );
  }
}
