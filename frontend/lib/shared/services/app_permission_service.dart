import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  static Future<void> requestInitialPermissions() async {
    if (kIsWeb) return;
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.camera,
        Permission.microphone,
      ].request();
      
      // Log status if needed
      statuses.forEach((permission, status) {
        debugPrint('Permission $permission status: $status');
      });
    } catch (e) {
      debugPrint('Error requesting initial app permissions: $e');
    }
  }
}
