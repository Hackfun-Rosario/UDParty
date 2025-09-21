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

class _HomePageState extends State<HomePage> {
  bool udpInitialized = false;

  @override
  void initState() {
    super.initState();
    GetIt.I<UDPController>().initSender().then((_) {
      udpInitialized = true;
      setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('UDParty'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perspectiva', style: Theme.of(context).textTheme.displayMedium),
          ElevatedButton(
            style: udpInitialized
                ? ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white))
                : ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: udpInitialized ? () => context.push('/cube') : null,
            child: Text('Abrir Perspectiva'),
          ),
        ],
      ),
    );
  }
}
