import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyro_provider/gyro_provider.dart';
import 'package:udparty/udp_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _log = '';
  int _counter = 0;
  bool udpInitialized = false;
  String? _inputText;
  int _repeat = 1;
  int _delay = 100;

  int x = 0;
  int y = 0;

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

  void _submit() async {
    for (int i = 0; i < _repeat; i++) {
      GetIt.I<UDPController>().sendMulticast(_inputText!);
      // await _sendMulticast(_inputText!);
      _counter++;
      await Future.delayed(Duration(milliseconds: _delay));
    }
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Payload',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _repeat = 1;
                  } else {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed > 0) {
                      _repeat = parsed;
                    }
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Repeticiones (def: 1)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  if (value == '') {
                    _delay = 100;
                  } else {
                    _delay = int.parse(value);
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Delay en milisegundos (def: 100)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: udpInitialized && (_inputText?.isNotEmpty ?? false)
                    ? _submit
                    : null,
                child: Text('Enviar'),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: udpInitialized && (_inputText?.isNotEmpty ?? false)
                    ? GetIt.I<UDPController>().gyroscopeOn
                    : null,
                child: Text('Activar giroscopio'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: udpInitialized && (_inputText?.isNotEmpty ?? false)
                    ? GetIt.I<UDPController>().gyroscopeOff
                    : null,
                child: Text('Desactivar giroscopio'),
              )
            ],
          ),
          SizedBox(height: 10),
          GyroProvider(
            // gyroscope: (vector) {
            //   log('x: ${vector.x}');
            // },
            // rotation: (vector) {
            //   log('x: ${vector.x}');
            // },
            builder: (context, gyroscope, rotation) {
              y += (gyroscope.x * 20).round();
              x += (gyroscope.y * 20).round();

              // log('x: $x');

              if (GetIt.I<UDPController>().gyroOn) {
                GetIt.I<UDPController>().sendMulticast('cube,$x,$y');
              }

              return SizedBox.shrink();
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _log = '';
                      _counter = 0;
                      x = 0;
                      y = 0;
                    });
                  },
                  child: const Text('Limpiar log')),
              SizedBox(width: 10),
              Text('Paquetes enviados: $_counter')
            ],
          ),
          Flexible(
              child: SingleChildScrollView(
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _log,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )))),
        ],
      ),
    );
  }
}
