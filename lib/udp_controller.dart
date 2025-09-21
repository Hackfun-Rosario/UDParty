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
  Future<void> sendMulticast(String msg) async {
    await sender?.send(msg.codeUnits, multicastEndpoint!);

    // setState(() {
    //   _log += '\nEnviado: $msg';
    // });
  }


  void gyroscopeOn() async {
    gyroOn = true;
  }

  void gyroscopeOff() async {
    gyroOn = false;
  }

}