import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:injectable/injectable.dart' hide Environment;
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xtridelink_driver/core/helpers/environment/environment.dart';
import 'package:xtridelink_driver/core/services/storage/index.dart';

// Enum to represent the connection status for easy state management in the UI
enum SocketStatus {
  connected,
  disconnected,
  reconnecting,
}

@LazySingleton()
class SocketService {
  final StorageServiceImpl storageServiceImpl;
  final String _baseOrderUrl =
      'wss://${Environment().config.apiHost.split('//').last}/ws/orders/';
  final String _baseNotificationUrl =
      'wss://${Environment().config.apiHost.split('//').last}/ws/rider/notifications/';

  WebSocketChannel? _orderChannel;
  WebSocketChannel? _notificationChannel;

  final StreamController<Map<String, dynamic>> _orderMessageController =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _notificationMessageController =
      StreamController.broadcast();

  final StreamController<SocketStatus> _notifChannelStatusController =
      StreamController.broadcast();

  final StreamController<SocketStatus> _orderChannelStatusController =
      StreamController.broadcast();

  Stream<SocketStatus> get notificationChannelStatus =>
      _notifChannelStatusController.stream;

  Stream<SocketStatus> get orderChannelStatus =>
      _orderChannelStatusController.stream;

  Stream<Map<String, dynamic>> get orderMessages =>
      _orderMessageController.stream;
  Stream<Map<String, dynamic>> get notificationMessages =>
      _notificationMessageController.stream;

  String? _trackingId;
  String? _token;
  int _notifReconnectAttempts = 0;
  int _orderReconnectAttempts = 0;
  bool _isNotifManuallyDisconnected = false;
  bool _isOrderManuallyDisconnected = false;

  SocketService(this.storageServiceImpl);

  bool isOrderChannelConnected() {
    // A channel exists and hasn't reported being closed
    return _orderChannel != null && _orderChannel?.closeCode == null;
  }

  bool isNotificationChannelConnected() {
    // A channel exists and hasn't reported being closed
    return _notificationChannel != null &&
        _notificationChannel?.closeCode == null;
  }

  // --- Notification Channel ---

  void connectToNotificationsChannel() async {
    _token = await storageServiceImpl.getToken();
    _isNotifManuallyDisconnected = false;
    _notifChannelStatusController.add(SocketStatus.reconnecting);
    _connectToNotificationsChannel();
  }

  void _connectToNotificationsChannel() async {
    // Re-read the token on every attempt so reconnects use the latest
    // (possibly refreshed) access token rather than a stale cached one.
    _token = await storageServiceImpl.getToken();
    if (_isNotifManuallyDisconnected ||
        _token == null ||
        _token!.isEmpty) {
      return; // Don't connect if it was a manual disconnection or if auth details are missing
    }

    final url = _baseNotificationUrl;
    try {
      _notificationChannel =
          WebSocketChannel.connect(Uri.parse(url), protocols: ['websocket']);

      // On successful connection, authenticate and reset reconnect timer
      _notifChannelStatusController.add(SocketStatus.connected);
      Logger().i('✅ WebSocket Connected');

      // 3. Listen for events and handle disconnection
      _notificationChannel!.stream.listen(
        (message) {
          Logger().i('Received message: $message');
          // Any message means we are successfully connected and authenticated
          if (!_notificationMessageController.isClosed) {
            final decodedMessage = jsonDecode(message);
            _notificationMessageController.add(decodedMessage);
          }
        },
        onDone: () {
          Logger().i('🔌 WebSocket disconnected: onDone');
          if (!_isNotifManuallyDisconnected) {
            _handleNotifDisconnection();
          }
        },
        onError: (error) {
          Logger().i('🔌 WebSocket error: $error');
          if (!_isNotifManuallyDisconnected) {
            _handleNotifDisconnection();
          }
        },
        cancelOnError: true,
      );
      // Authenticate
      _notifReconnectAttempts = 0;
      _authenticateNotif(_token!);
    } catch (e) {
      Logger().i('🔌 WebSocket connection error: $e');
      _handleNotifDisconnection();
    }
  }

  void _authenticateNotif(String token) {
    _sendMessage(_notificationChannel, {
      'action': 'authenticate',
      'token': token,
    });
  }

  void submitBid(String orderId, double bidAmount) {
    _sendMessage(_notificationChannel, {
      'action': 'submit_bid',
      'order_id': orderId,
      'proposed_price': bidAmount,
    });
  }

  void updateRiderLocation(double lat, double lng) {
    _sendMessage(_notificationChannel, {
      'action': 'update_location',
      'latitude': lat,
      'longitude': lng,
    });
  }

  void updateAvailability(bool isAvailable) {
    _sendMessage(_notificationChannel, {
      'action': 'update_availability',
      'available': isAvailable,
    });
  }

  void _handleNotifDisconnection() {
    _notificationChannel = null; // Clear the old channel
    if (_isNotifManuallyDisconnected) {
      _notifChannelStatusController.add(SocketStatus.disconnected);
      return;
    }

    _notifChannelStatusController.add(SocketStatus.reconnecting);
    _notifReconnectAttempts++;

    // Exponential backoff formula: 2^attempts * 1000ms, with a max delay
    final delay =
        min(pow(2, _notifReconnectAttempts) * 1000, 30000); // max 30 seconds
    Logger().i(
        'Reconnecting Notif attempt #$_notifReconnectAttempts in ${delay / 1000} seconds...');

    Future.delayed(Duration(milliseconds: delay.toInt()), () {
      _connectToNotificationsChannel();
    });
  }

  // --- Order-Specific Channel ---

  Future<void> connectToOrdersChannel(String trackingId) async {
    _trackingId = trackingId;
    _token = await storageServiceImpl.getToken();
    _isOrderManuallyDisconnected = false;
    _orderChannelStatusController.add(SocketStatus.reconnecting);
    _connectToOrdersChannel();
  }

  void _connectToOrdersChannel() async {
    // Re-read the token on every attempt so reconnects use the latest
    // (possibly refreshed) access token rather than a stale cached one.
    _token = await storageServiceImpl.getToken();
    if (_isOrderManuallyDisconnected ||
        _token == null ||
        _token!.isEmpty ||
        _trackingId == null) {
      return; // Don't connect if it was a manual disconnection or if auth details are missing
    }

    // Fixed: the order channel must use the order URL (was mistakenly
    // pointing at the notifications endpoint).
    final url = _baseOrderUrl;
    try {
      _orderChannel =
          WebSocketChannel.connect(Uri.parse(url), protocols: ['websocket']);

      // On successful connection, authenticate and reset reconnect timer
      _orderChannelStatusController.add(SocketStatus.connected);
      Logger().i('✅ WebSocket Connected');

      // 3. Listen for events and handle disconnection
      _orderChannel!.stream.listen(
        (message) {
          Logger().i('Received message: $message');
          // Any message means we are successfully connected and authenticated
          if (!_orderMessageController.isClosed) {
            final decodedMessage = jsonDecode(message);
            _orderMessageController.add(decodedMessage);
          }
        },
        onDone: () {
          Logger().i('🔌 WebSocket disconnected: onDone');
          if (!_isOrderManuallyDisconnected) {
            _handleOrderDisconnection();
          }
        },
        onError: (error) {
          Logger().i('🔌 WebSocket error: $error');
          if (!_isOrderManuallyDisconnected) {
            _handleOrderDisconnection();
          }
        },
        cancelOnError: true,
      );
      // Authenticate
      _orderReconnectAttempts = 0;
      _authenticateOrder(_token!);
    } catch (e) {
      Logger().i('🔌 WebSocket connection error: $e');
      _handleOrderDisconnection();
    }
  }

  void _handleOrderDisconnection() {
    _orderChannel = null; // Clear the old channel
    if (_isOrderManuallyDisconnected) {
      _orderChannelStatusController.add(SocketStatus.disconnected);
      return;
    }

    _orderChannelStatusController.add(SocketStatus.reconnecting);
    _orderReconnectAttempts++;

    // Exponential backoff formula: 2^attempts * 1000ms, with a max delay
    final delay =
        min(pow(2, _orderReconnectAttempts) * 1000, 30000); // max 30 seconds
    Logger().i(
        'Reconnecting Order attempt #$_orderReconnectAttempts in ${delay / 1000} seconds...');

    Future.delayed(Duration(milliseconds: delay.toInt()), () {
      _connectToOrdersChannel();
    });
  }

  void _authenticateOrder(String token) {
    _sendMessage(_orderChannel, {
      'action': 'authenticate',
      'token': token,
    });
  }

  void acceptOrder() {
    _sendMessage(_orderChannel, {'action': 'accept_order'});
  }

  void rejectOrder() {
    _sendMessage(_orderChannel, {'action': 'reject_order'});
  }

  void proposePrice(double price) {
    _sendMessage(_orderChannel, {
      'action': 'propose_price',
      'proposed_price': price,
    });
  }

  void acceptPrice(String negotiationId) {
    _sendMessage(_notificationChannel,
        {'action': 'accept_price', 'negotiation_id': negotiationId});
  }

  void rejectPrice(String negotiationId) {
    _sendMessage(_notificationChannel,
        {'action': 'reject_price', 'negotiation_id': negotiationId});
  }

  void updateOrderStatus(String status) {
    _sendMessage(_orderChannel, {
      'action': 'update_status',
      'status': status,
    });
  }

  void updateOrderLocation(double lat, double lng) {
    _sendMessage(_orderChannel, {
      'action': 'update_location',
      'latitude': lat,
      'longitude': lng,
    });
  }

  // --- General Methods ---

  void _sendMessage(WebSocketChannel? channel, Map<String, dynamic> message) {
    if (channel != null) {
      Logger().i('Sending message: ${jsonEncode(message)}');
      channel.sink.add(jsonEncode(message));
    }
  }

  void disconnectFromOrder() {
    if (_orderChannel != null) {
      _orderChannel!.sink.close();
      _orderChannel = null;
    }
  }

  void disconnectFromNotifications() {
    if (_notificationChannel != null) {
      _notificationChannel!.sink.close();
      _notificationChannel = null;
    }
  }

  void disconnectAll() {
    disconnectFromOrder();
    disconnectFromNotifications();
  }
}
