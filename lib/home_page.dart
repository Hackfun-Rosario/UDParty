import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:udp/udp.dart';

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

  /*
   * Inicializa el objeto UDP
   */
  Future<void> _initSender() async {
    setState(() {
      _log += '\nInicializando...';
    });
    sender = await UDP.bind(Endpoint.any());
    setState(() {
      _log += '\nListo!';
    });
  }

  /*
   * Envía un mensaje por UDP
   */
  Future<void> _sendMulticast(String msg) async {
    await sender?.send(msg.codeUnits, multicastEndpoint!);
    setState(() {
      _log += '\nEnviado: $msg';
    });
  }

  void _submit() async {
    for (int i = 0; i < _repeat; i++) {
      await _sendMulticast(_inputText!);
      _counter++;
      await Future.delayed(Duration(milliseconds: _delay));
    }
  }

  /*
   * Libera el objeto UDP
   */
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
    // Tareas de limpieza
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
                onPressed: status && (_inputText?.isNotEmpty ?? false)
                    ? _submit
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
