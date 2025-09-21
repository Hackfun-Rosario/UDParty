import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:udparty/udp_controller.dart';

import 'home_page.dart';

void main() {
  GetIt.I.registerSingleton<UDPController>(UDPController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDParty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
