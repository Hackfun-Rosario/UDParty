import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyro_provider/gyro_provider.dart';

import '../udp_controller.dart';

class PerspectivaPage extends StatefulWidget {
  const PerspectivaPage({super.key});

  @override
  State<PerspectivaPage> createState() => _PerspectivaPageState();
}

class _PerspectivaPageState extends State<PerspectivaPage> {
  int x = 0;
  int y = 0;

  @override
  void initState() {
    super.initState();
    GetIt.I<UDPController>().gyroscopeOn();
    GetIt.I<UDPController>().sendBroadcast('cube', force: true);
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I<UDPController>().gyroscopeOff();
    GetIt.I<UDPController>().sendBroadcast('standby', force: true);
  }

  @override
  Widget build(BuildContext context) {
    GetIt.I<UDPController>().gyroscopeOn();
    GetIt.I<UDPController>().sendBroadcast('cube', force: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Perspectiva'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GyroProvider(
            // gyroscope: (vector) {
            //   log('x: ${vector.x}');
            // },
            // rotation: (vector) {
            //   log('x: ${vector.x}');
            // },
            builder: (context, gyroscope, rotation) {
              y += (gyroscope.x * 8).round();
              x += (gyroscope.y * 8).round();
              // log('x: $x');
              if (GetIt.I<UDPController>().gyroOn) {
                GetIt.I<UDPController>().sendBroadcast('cube,$x,$y');
              }
              return SizedBox.shrink();
            },
          ),
          Flexible(
            child: Center(
              child: FilledButton(
                  onPressed: () {
                    setState(() {
                      x = 0;
                      y = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Centrar', style: Theme.of(context).textTheme.titleLarge,),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
