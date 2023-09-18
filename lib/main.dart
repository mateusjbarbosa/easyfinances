import 'package:easyfinances/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EasyFinances());
}

class EasyFinances extends StatelessWidget {
  const EasyFinances({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyFinances',
      theme: ThemeData(useMaterial3: true),
      home: HomeScreen(),
    );
  }
}
