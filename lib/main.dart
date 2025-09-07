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
  UDP? sender;
  UDP? receiver;
  Endpoint? multicastEndpoint;
  int counter = 0;
  bool status = false;

  Future<void> _initSender() async {
    setState(() {
      _log += '\nInitializing...';
    });
    sender = await UDP.bind(Endpoint.any());
    setState(() {
      _log += '\Initialized';
    });
  }

  Future<void> _sendMulticast(String msg) async {
    sender?.send(msg.codeUnits, multicastEndpoint!);
    setState(() {
      _log += '\nSent: $msg';
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              status
                  ? ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange)),
                      onPressed: () async {
                        await _sendMulticast('r');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text('Rojo', style: TextStyle(color: Colors.white),),
                      ))
                  : SizedBox.shrink(),
              const SizedBox(width: 10),
              status
                  ? ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                      onPressed: () async {
                        await _sendMulticast('g');
                      },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text('Verde', style: TextStyle(color: Colors.white),),
                  ))
                  : SizedBox.shrink(),
              const SizedBox(width: 10),
              status
                  ? ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                      onPressed: () async {
                        await _sendMulticast('b');
                      },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text('Azúl', style: TextStyle(color: Colors.white),),
                  ))
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _log = '';
                    });
                  },
                  child: const Text('Clear')),
              SizedBox(width: 10),
              Text('Total: $counter')
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
