import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../udp_controller.dart';

class CarreraPage extends StatefulWidget {
  const CarreraPage({super.key});

  @override
  State<CarreraPage> createState() => _CarreraPageState();
}

class _CarreraPageState extends State<CarreraPage> {
  @override
  void initState() {
    super.initState();
    GetIt.I<UDPController>().sendBroadcast('carrera', force: true);
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I<UDPController>().sendBroadcast('standby', force: true);
  }

  @override
  Widget build(BuildContext context) {
    GetIt.I<UDPController>().sendBroadcast('carrera', force: true);

    return const Placeholder();
  }
}
