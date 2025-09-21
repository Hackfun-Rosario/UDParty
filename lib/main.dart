import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:udparty/udp_controller.dart';

import 'cubo/perspectiva_page.dart';
import 'home_page.dart';

void main() {
  GetIt.I.registerSingleton<UDPController>(UDPController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/cube',
          builder: (context, state) => PerspectivaPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'UDParty',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}
