import 'dart:developer';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  String _recibido = '';
  String _myIP = '';
  UDP? sender;
  UDP? receiver;

  Future<void> _getMyIp() async {
    final info = NetworkInfo();

    info.getWifiIP().then((value) {
      setState(() {
        _myIP = value ?? '';
      });
    });
  }

  Future<void> _initSender() async {
    log('Initializing Sender');
    sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    log('Sender initialized');
  }

  Future<void> _initReceiver() async {
    log('Initializing Receiver');
    receiver = await UDP.bind(Endpoint.loopback(port: const Port(65002)));

    // receiving\listening
    receiver?.asStream(timeout: const Duration(seconds: 20)).listen((datagram) {
      var str = String.fromCharCodes(datagram!.data);
      log('Received message: $str');
      _recibido = str;
    });
    log('Receiver initialized');
  }

  Future<void> _sendUDPBroadcast(String msg) async {
    var dataLength = await sender?.send(
        msg.codeUnits, Endpoint.broadcast(port: const Port(65001)));
    log('$dataLength bytes sent');
  }

  void _closeSender() {
    sender?.close();
  }

  void _closeReceiver() {
    receiver?.close();
  }

  @override
  void initState() {
    _getMyIp();
    _initSender();
    _initReceiver();
  }

  @override
  void dispose() {
    _closeSender();
    _closeReceiver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('UDParty - $_myIP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _sendUDPBroadcast('Test');
                    },
                    child: const Text('Enviar')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _recibido = '';
                      });
                    },
                    child: const Text('Limpiar'))
              ],
            ),
            const Text('Recibido:'),
            const SizedBox(
              height: 10,
            ),
            Text(
              _recibido,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
