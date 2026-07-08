import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xtridelink/core/helpers/environment/environment.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';

// Enum to represent the connection status for easy state management in the UI
enum SocketStatus {
  connected,
  disconnected,
  reconnecting,
}

@LazySingleton()
class SocketService {
  SocketService(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  final String _baseUrl =
      'wss://${Environment().config.apiHost.split('//').last}/ws/orders/';

  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();

  // 1. Stream Controller for Connection Status
  final StreamController<SocketStatus> _statusController =
      StreamController.broadcast();

  // Private state variables
  String? _trackingId;
  String? _token;
  bool _isManuallyDisconnected = false;
  int _reconnectAttempts = 0;

  // --- Public Getters ---

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  Stream<SocketStatus> get connectionStatus => _statusController.stream;

  // 2. Public method to check status
  bool isConnected() {
    // A channel exists and hasn't reported being closed
    return _channel != null && _channel?.closeCode == null;
  }

  // --- Connection Management ---

  void connect(String trackingId) {
    _trackingId = trackingId;
    _token = _authenticationRepository.getAccessToken();
    _isManuallyDisconnected = false;
    _statusController
        .add(SocketStatus.reconnecting); // Indicate we are trying to connect
    _connect();
  }

  void _connect() {
    // Re-read the token on every attempt so reconnects use the latest
    // (possibly refreshed) access token rather than a stale cached one.
    _token = _authenticationRepository.getAccessToken();
    if (_isManuallyDisconnected || _trackingId == null || _token == null) {
      return; // Don't connect if it was a manual disconnection or if auth details are missing
    }

    final url = '$_baseUrl$_trackingId/';
    try {
      _channel =
          WebSocketChannel.connect(Uri.parse(url), protocols: ['websocket']);

      // On successful connection, authenticate and reset reconnect timer
      _statusController.add(SocketStatus.connected);
      Logger().i('✅ WebSocket Connected');

      // 3. Listen for events and handle disconnection
      _channel!.stream.listen(
        (message) {
          Logger().i('Received message: $message');
          // Any message means we are successfully connected and authenticated
          if (!_messageController.isClosed) {
            final decodedMessage = jsonDecode(message);
            _messageController.add(decodedMessage);
          }
        },
        onDone: () {
          Logger().i('🔌 WebSocket disconnected: onDone');
          if (!_isManuallyDisconnected) {
            _handleDisconnection();
          }
        },
        onError: (error) {
          Logger().i('🔌 WebSocket error: $error');
          if (!_isManuallyDisconnected) {
            _handleDisconnection();
          }
        },
        cancelOnError: true,
      );
      // Authenticate
      _reconnectAttempts = 0;
      _authenticate(_token!);
    } catch (e) {
      Logger().i('🔌 WebSocket connection error: $e');
      _handleDisconnection();
    }
  }

  // 4. Handle reconnection with exponential backoff
  void _handleDisconnection() {
    _channel = null; // Clear the old channel
    if (_isManuallyDisconnected) {
      _statusController.add(SocketStatus.disconnected);
      return;
    }

    _statusController.add(SocketStatus.reconnecting);
    _reconnectAttempts++;

    // Exponential backoff formula: 2^attempts * 1000ms, with a max delay
    final delay =
        min(pow(2, _reconnectAttempts) * 1000, 30000); // max 30 seconds
    Logger().i(
        'Reconnecting attempt #$_reconnectAttempts in ${delay / 1000} seconds...');

    Future.delayed(Duration(milliseconds: delay.toInt()), () {
      _connect();
    });
  }

  void _authenticate(String token) {
    final authMessage = {'action': 'authenticate', 'token': token};
    _sendMessage(authMessage);
  }

  // --- Public Actions ---

  void _sendMessage(Map<String, dynamic> message) {
    if (isConnected()) {
      _channel!.sink.add(jsonEncode(message));
    } else {
      Logger().i('Cannot send message, socket is not connected.');
      // Optional: Queue the message to be sent upon reconnection
    }
  }

  // Public methods (selectRider, proposePrice, etc.) remain the same
  void selectRider(String bidId) =>
      _sendMessage({'action': 'select_rider', 'bid_id': bidId});

  void proposePrice(double price) =>
      _sendMessage({'action': 'propose_price', 'proposed_price': price});

  void searchRiders() => _sendMessage({'action': 'restart_search'});
  // ... other actions

  // 5. Manual disconnection
  void disconnect() {
    Logger().i('Manually disconnecting...');
    _isManuallyDisconnected = true;
    _reconnectAttempts = 0;
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    _statusController.add(SocketStatus.disconnected);
  }

  void dispose() {
    _messageController.close();
    _statusController.close();
    disconnect();
  }
}
