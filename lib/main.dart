import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:udp/udp.dart';

void main() {
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _log = '';
  UDP? sender;
  UDP? receiver;
  Endpoint? multicastEndpoint;
  int _counter = 0;
  bool status = false;
  String? _inputText;
  int _repeat = 1;
  int _delay = 100;

  Future<void> _initSender() async {
    setState(() {
      _log += '\nInicializando...';
    });
    sender = await UDP.bind(Endpoint.any());
    setState(() {
      _log += '\nListo!';
    });
  }

  Future<void> _sendMulticast(String msg) async {
    sender?.send(msg.codeUnits, multicastEndpoint!);
    setState(() {
      _log += '\nEnviado: $msg';
    });
  }

  void _closeSender() {
    sender?.close();
  }

  @override
  void initState() {
    super.initState();
    multicastEndpoint = Endpoint.broadcast(port: const Port(12345));
    _initSender().then((_) {
      status = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    try {
      _closeSender();
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
          // SizedBox(height: 10),
          // Text(
          //   'Blink',
          //   style: Theme.of(context).textTheme.displaySmall,
          // ),
          // SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     status
          //         ? ElevatedButton(
          //             style: ButtonStyle(
          //                 backgroundColor: MaterialStateProperty.all<Color>(
          //                     Colors.deepOrange)),
          //             onPressed: () async {
          //               await _sendMulticast('255,0,0,3');
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.all(20.0),
          //               child: const Text(
          //                 'Rojo',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ))
          //         : SizedBox.shrink(),
          //     const SizedBox(width: 10),
          //     status
          //         ? ElevatedButton(
          //             style: ButtonStyle(
          //                 backgroundColor:
          //                     MaterialStateProperty.all<Color>(Colors.green)),
          //             onPressed: () async {
          //               await _sendMulticast('0,255,0,3');
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.all(20.0),
          //               child: const Text(
          //                 'Verde',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ))
          //         : SizedBox.shrink(),
          //     const SizedBox(width: 10),
          //     status
          //         ? ElevatedButton(
          //             style: ButtonStyle(
          //                 backgroundColor:
          //                     MaterialStateProperty.all<Color>(Colors.blue)),
          //             onPressed: () async {
          //               await _sendMulticast('0,0,255,3');
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.all(20.0),
          //               child: const Text(
          //                 'Azúl',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ))
          //         : SizedBox.shrink(),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  if (value == '') {
                    _repeat = 1;
                  } else {
                    _repeat = int.parse(value);
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
                onPressed: status && (_inputText?.isNotEmpty ?? false)
                    ? () async {
                        for (int i = 0; i < _repeat; i++) {
                          await _sendMulticast(_inputText!);
                          _counter++;
                          await Future.delayed(Duration(milliseconds: 50));
                        }
                      }
                    : null,
                child: Text('Send'),
              ),
            ),
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
                    });
                  },
                  child: const Text('Clear')),
              SizedBox(width: 10),
              Text('Total: $_counter')
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
