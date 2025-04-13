import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:logger/logger.dart';

class WebSocketService {
  late StompClient stompClient;
  final logger = Get.find<Logger>();
  
  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://', //to add real url later
        onConnect: onConnectCallback,
        onStompError: onErrorCallback,
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    logger.d("Connected to server");
    stompClient.subscribe(
      destination: '/topic/yourTopic',  // topic to subscribe
      callback: (frame) {
        logger.d('Received message: ${frame.body}');
      },
    );
  }

  void onErrorCallback(StompFrame frame) {
    logger.e('Connexion error: ${frame.body}');
  }

  void sendMessage(String message) {
    stompClient.send(
      destination: '/app/send',  // route on the server
      body: message,
    );
  }

  void disconnect() {
    stompClient.deactivate();
  }
}
