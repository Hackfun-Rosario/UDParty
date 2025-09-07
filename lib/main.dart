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
  String _log = '';
  String _myIP = '';
  UDP? sender;
  UDP? receiver;
  Endpoint? multicastEndpoint;
  int counter = 0;

  Future<void> _getMyIp() async {
    final info = NetworkInfo();
    info.getWifiIP().then((value) {
      setState(() {
        _myIP = value ?? '';
      });
    });
  }

  Future<void> _initSender() async {
    setState(() {
      _log += '\nInitializing Sender';
    });
    sender = await UDP.bind(Endpoint.any());
    setState(() {
      _log += '\nSender initialized';
    });
  }

  Future<void> _sendMulticast(String msg) async {
    sender?.send("${(counter++)}".codeUnits, multicastEndpoint!);
    setState(() {
      _log += '\nMessage sent';
    });
  }

  Future<void> _initReceiver() async {
    setState(() {
      _log += '\nInitializing Receiver';
    });
    receiver = await UDP.bind(multicastEndpoint!);
    receiver?.asStream().listen((datagram) {
      if (datagram != null) {
        var str = String.fromCharCodes(datagram.data);
        setState(() {
          _log += '\nReceived: $str';
        });
      }
    });
    setState(() {
      _log += '\nReceiver initialized';
    });
  }

  void _closeSender() {
    sender?.close();
  }

  void _closeReceiver() {
    receiver?.close();
  }

  @override
  void initState() {
    super.initState();
    _getMyIp();
    multicastEndpoint = Endpoint.broadcast(port: const Port(12345));
  }

  @override
  void dispose() {
    try {
      _closeSender();
      _closeReceiver();
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
        title: Text('UDParty - $_myIP'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await _initSender();
                    },
                    child: const Text('Init as sender')),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () async {
                      await _sendMulticast('Test');
                    },
                    child: const Text('Send broadcast'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await _initReceiver();
                    },
                    child: const Text('Init as receiver')),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _log = '';
                      });
                    },
                    child: const Text('Clear'))
              ],
            ),
            const SizedBox(height: 20),
            const Text('Log:'),
            Text(_log),
          ],
        ),
      ),
    );
  }
}
