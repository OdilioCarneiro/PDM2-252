import 'dart:io';
import 'dart:convert';  

void main() async {
  const int port = 8080;
  const String host = 'localhost';  

  print('Iniciando servidor na porta $port...');

  try {

    final server = await ServerSocket.bind(host, port);
    print('Servidor escutando em $host:$port');


    await for (final socket in server) {
      final String clientIP = socket.remoteAddress.address;  
      print('Cliente conectado: $clientIP:${socket.remotePort}');

      
      socket.listen(
        (List<int> data) {
          final message = utf8.decode(data).trim();  
          if (message.isNotEmpty) {
            print('Temperatura recebida de $clientIP: $message');  
          }
        },
        onError: (error) {
          print('Erro na conexão: $error');
          socket.destroy();
        },
        onDone: () {
          print('Cliente desconectado.');
          socket.destroy();
        },
      );
    }
  } catch (e) {
    print('Erro ao iniciar servidor: $e');
  }
}
