import 'package:udp/udp.dart';

class UDPController {
  UDP? sender;
  Endpoint? multicastEndpoint = Endpoint.broadcast(port: const Port(12345));
  bool gyroOn = false;

  /*
   * Inicializa el objeto UDP
   */
  Future<void> initSender() async {
    // setState(() {
    //   _log += '\nInicializando...';
    // });
    sender = await UDP.bind(Endpoint.any());
    // setState(() {
    //   _log += '\nListo!';
    // });
  }

  /*
   * Libera el objeto UDP
   */
  void closeSender() {
    sender?.close();
  }

  /*
   * Envía un mensaje por UDP
   */
  Future<void> sendBroadcast(String msg, {bool force = false}) async {
    int repetitions = 0;
    if (force) {
      repetitions = 2;
    }
    do {
      await sender?.send(msg.codeUnits, multicastEndpoint!);
      repetitions++;
    } while (repetitions < 3);
  }

  void gyroscopeOn() async {
    gyroOn = true;
  }

  void gyroscopeOff() async {
    gyroOn = false;
  }
}
