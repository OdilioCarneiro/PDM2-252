import 'dart:io';
import 'dart:async';
import 'dart:math';  

void main() async {
  const String host = 'localhost';
  const int port = 8080;
  const Duration interval = Duration(seconds: 10);  
  const Duration totalDuration = Duration(seconds: 60);  

  print('Iniciando simulação de dispositivo IoT...');

  String? localIP;  

  try {
    var interfaces = await NetworkInterface.list();  
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          localIP = addr.address;  
          break;
        }
      }
      if (localIP != null) break;
    }

    if (localIP == null) {
      localIP = 'IP desconhecido';  
      print('Não foi possível obter o IP local. Usando: $localIP');
    } else {
      print('IP local do dispositivo: $localIP');
    }


    final socket = await Socket.connect(host, port);
    print('Conectado ao servidor em $host:$port');

    final random = Random();
    Timer? timer;

    void sendTemperature() {
      final double temperature = 20.0 + random.nextDouble() * 10.0;  
      final String message = 'Temperatura: ${temperature.toStringAsFixed(1)}°C from IP: $localIP\n';  
      
      socket.write(message);  
      socket.flush(); 
      print('Enviando: $message');
    }

    timer = Timer.periodic(interval, (Timer t) {
      sendTemperature();
    });

    sendTemperature();


    await Future.delayed(totalDuration);
    timer.cancel();
    print('Simulação finalizada após ${totalDuration.inSeconds} segundos.');

  
    socket.destroy();
    print('Conexão fechada.');

  } catch (e) {
    print('Erro no dispositivo IoT: $e');
  }
}
