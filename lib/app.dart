import 'package:desafio/pages/home2/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(),
      title: "Vigilância Comunitária",
      debugShowCheckedModeBanner: true,
    );
  }
}
