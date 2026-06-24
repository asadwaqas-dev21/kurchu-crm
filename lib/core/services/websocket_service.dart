import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:async';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';

class WebSocketService {
  io.Socket? socket;
  final AuthService authService;
  
  final _metricsUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _alertController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get metricsUpdateStream => _metricsUpdateController.stream;
  Stream<Map<String, dynamic>> get alertStream => _alertController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  WebSocketService({required this.authService});

  Future<void> connect() async {
    final token = authService.getAccessToken();
    
    socket = io.io(
      ApiConstants.wsUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setReconnectionAttempts(10)
          .build(),
    );

    // Connection events
    socket!.on('connect', (_) {
      _connectionStatusController.add(true);
      print('✅ WebSocket connected');
    });

    socket!.on('disconnect', (_) {
      _connectionStatusController.add(false);
      print('❌ WebSocket disconnected');
    });

    socket!.on('connect_error', (error) {
      print('❌ WebSocket connection error: $error');
    });

    // Dashboard events
    socket!.on('metrics:update', (data) {
      _metricsUpdateController.add(data as Map<String, dynamic>);
    });

    socket!.on('alert:new', (data) {
      _alertController.add(data as Map<String, dynamic>);
    });

    socket!.on('lead:created', (data) {
      // Handle new lead
      final alert = {
        'type': 'NEW_LEAD',
        'title': 'New Lead',
        'message': '${data['firstName']} ${data['lastName']} added',
        'severity': 'INFO',
      };
      _alertController.add(alert);
    });
  }

  // Subscribe to dashboard updates
  void subscribeToDashboard() {
    socket?.emit('dashboard:subscribe', {});
  }

  void dispose() {
    _metricsUpdateController.close();
    _alertController.close();
    _connectionStatusController.close();
    socket?.dispose();
  }
}
