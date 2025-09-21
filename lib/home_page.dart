import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:udparty/udp_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool udpInitialized = false;

  Future<void> initSender() async {
    GetIt.I<UDPController>().initSender().then((_) {
      udpInitialized = true;
      GetIt.I<UDPController>().sendBroadcast('standby', force: true);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initSender().then((_) {
      GetIt.I<UDPController>().sendBroadcast('standby', force: true);
    });
  }

  @override
  void dispose() {
    // Tareas de limpieza
    try {
      GetIt.I<UDPController>().closeSender();
    } catch (e) {
      log(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GetIt.I<UDPController>().sendBroadcast('standby', force: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: GestureDetector(
            onTap: () =>
                GetIt.I<UDPController>().sendBroadcast('standby', force: true),
            child: Text('UDParty')),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: udpInitialized ? () => context.push('/perspectiva') : null,
              child: Card(
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Perspectiva',
                        style: Theme.of(context).textTheme.displaySmall),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/img/perspectiva.png'),
                        Text('Usa el giroscopio para simular perspectiva', style: Theme.of(context).textTheme.titleLarge,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: udpInitialized ? () => context.push('/carrera') : null,
              child: Card(
                color: Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Carrera',
                        style: Theme.of(context).textTheme.displaySmall),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset('assets/img/carrera.png'),
                        SizedBox(height:100, child: Placeholder()),
                        Text('Juego de carrera multipantalla (1x3)', style: Theme.of(context).textTheme.titleLarge,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: udpInitialized ? () => context.push('/debug') : null,
              child: Card(
                color: Colors.white38,
                child: ListTile(
                  title: Text('Debug',
                      style: Theme.of(context).textTheme.displaySmall),
                  subtitle: Text('Enviar paquetes personalizados'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
