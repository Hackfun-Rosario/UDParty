import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../udp_controller.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void dispose() {
    super.dispose();
    GetIt.I<UDPController>().sendBroadcast('standby', force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Video'),
      ),
      body: Center(
        child: FilledButton(
            onPressed: () => GetIt.I<UDPController>().sendBroadcast('video'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Reproducir',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )),
      ),
    );
  }
}
