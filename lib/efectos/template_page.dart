import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../udp_controller.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  @override
  void initState() {
    super.initState();
    GetIt.I<UDPController>().sendBroadcast('xxx', force: true); // TODO
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I<UDPController>().sendBroadcast('standby', force: true);
  }

  @override
  Widget build(BuildContext context) {
    GetIt.I<UDPController>().sendBroadcast('xxx', force: true); // TODO

    return const Placeholder();
  }
}
