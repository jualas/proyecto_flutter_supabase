import 'package:flutter/foundation.dart';
import 'dart:io';

/// Configuración del proyecto TFG
class AppConfig {
  // Configuración de Supabase - Local Development
  static const String _localUrl = 'http://127.0.0.1:54321';
  static const String _networkServerUrl = 'http://192.168.1.9:54321'; // Tu servidor de red
  static const String _cloudUrl = 'https://your-project.supabase.co'; // Para futuro uso
  
  // Claves de Supabase
  static const String _localAnonKey = 'SUPABASE_JWT_REMOVED';
  static const String _networkServerAnonKey = 'SUPABASE_JWT_REMOVED';
  
  // Configuración de Storage S3
  static const String _storageUrl = 'http://127.0.0.1:54321/storage/v1/s3';
  static const String _storageAccessKey = 'STORAGE_KEY_REMOVED';
  static const String _storageSecretKey = 'STORAGE_KEY_REMOVED';
  static const String _storageRegion = 'local';
  
  // URLs de herramientas de desarrollo
  static const String _supabaseStudioUrl = 'http://127.0.0.1:54323';
  static const String _inbucketUrl = 'http://127.0.0.1:54324';
  
  /// Obtiene la URL de Supabase según el entorno
  static String get supabaseUrl {
    // Para desarrollo, usar localhost
    return _localUrl;
  }
  
  /// Obtiene la clave anónima de Supabase
  static String get supabaseAnonKey {
    return _localAnonKey;
  }
  
  /// Obtiene la URL de Storage S3
  static String get storageUrl => _storageUrl;
  
  /// Obtiene la clave de acceso de Storage
  static String get storageAccessKey => _storageAccessKey;
  
  /// Obtiene la clave secreta de Storage
  static String get storageSecretKey => _storageSecretKey;
  
  /// Obtiene la región de Storage
  static String get storageRegion => _storageRegion;
  
  /// Obtiene la URL de Supabase Studio
  static String get supabaseStudioUrl => _supabaseStudioUrl;
  
  /// Obtiene la URL de Inbucket (Email Testing)
  static String get inbucketUrl => _inbucketUrl;
  
  /// Obtiene información de la plataforma actual
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Desconocida';
  }
  
  /// Obtiene el color de la plataforma
  static int get platformColor {
    if (kIsWeb) return 0xFF2196F3; // Blue
    if (Platform.isWindows) return 0xFF2196F3; // Blue
    if (Platform.isAndroid) return 0xFF4CAF50; // Green
    if (Platform.isIOS) return 0xFF000000; // Black
    if (Platform.isMacOS) return 0xFF9E9E9E; // Grey
    if (Platform.isLinux) return 0xFFFF9800; // Orange
    return 0xFF9E9E9E; // Grey
  }
  
  /// Obtiene el icono de la plataforma
  static String get platformIcon {
    if (kIsWeb) return '🌐';
    if (Platform.isWindows) return '🖥️';
    if (Platform.isAndroid) return '📱';
    if (Platform.isIOS) return '🍎';
    if (Platform.isMacOS) return '🍎';
    if (Platform.isLinux) return '🐧';
    return '❓';
  }
  
  /// Información de debug
  static void printConfig() {
    print('🔧 Configuración de la aplicación:');
    print('   Plataforma: ${platformName}');
    print('   Backend URL: $supabaseUrl');
    print('   Clave anónima: ${supabaseAnonKey.substring(0, 20)}...');
    print('   Storage URL: $storageUrl');
    print('   Supabase Studio: $supabaseStudioUrl');
    print('   Inbucket (Email): $inbucketUrl');
  }
  
  /// Configuración para desarrollo
  static const bool isDevelopment = true;
  
  /// Configuración para testing
  static const bool enableLogging = true;
  
  /// Configuración de la aplicación
  static const String appName = 'TFG Sistema Multiplataforma';
  static const String appVersion = '1.0.0';
  
  /// Credenciales de prueba
  static const Map<String, String> testCredentials = {
    'student': 'carlos.lopez@alumno.cifpcarlos3.es',
    'tutor': 'maria.garcia@cifpcarlos3.es',
    'admin': 'admin@cifpcarlos3.es',
    'password': 'password123',
  };
  
  /// Información del servidor
  static const Map<String, String> serverInfo = {
    'ip': '127.0.0.1',
    'port': '54321',
    'storage_port': '54321',
    'studio_port': '54323',
    'email_port': '54324',
  };
}
