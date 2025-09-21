import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:udparty/udp_controller.dart';

import 'home_page.dart';
import 'efectos/debug_page.dart';
import 'efectos/perspectiva_page.dart';
import 'efectos/carrera_page.dart';

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
          path: '/debug',
          builder: (context, state) => DebugPage(),
        ),
        GoRoute(
          path: '/perspectiva',
          builder: (context, state) => PerspectivaPage(),
        ),
        GoRoute(
          path: '/carrera',
          builder: (context, state) => CarreraPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'UDParty',
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(),
        cardColor: Colors.white24,
        useMaterial3: true,
      ),
    );
  }
}
