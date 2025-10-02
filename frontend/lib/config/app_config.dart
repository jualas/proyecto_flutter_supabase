import 'package:flutter/foundation.dart';

/// Configuración simplificada de la aplicación
class AppConfig {
  // Configuración de Supabase
  static const String supabaseUrl = 'https://zkririyknhlwoxhsoqih.supabase.co';
  static const String supabaseAnonKey =
      'SUPABASE_JWT_REMOVED';

  // Información de la aplicación
  static const String appName = 'TFG Sistema Multiplataforma';
  static const String appVersion = '1.0.0';
  static const String environment = 'cloud';
  static const String platformName = 'Flutter Web';

  // URLs de servicios externos
  static const String supabaseStudioUrl =
      'https://supabase.com/dashboard/project/zkririyknhlwoxhsoqih';
  static const String inbucketUrl = 'https://resend.com/emails';
  static const String storageUrl =
      'https://zkririyknhlwoxhsoqih.supabase.co/storage/v1/s3';

  // Credenciales de prueba
  static const Map<String, String> testCredentials = {
    'student': 'student.test@alumno.cifpcarlos3.es',
    'tutor': 'tutor.test@cifpcarlos3.es',
    'admin': 'admin@jualas.es',
    'student_password': 'password123',
    'tutor_password': 'password123',
    'admin_password': 'password123',
  };

  // Configuración de UI
  static const int platformColor = 0xFF2196F3; // Azul por defecto

  // Debug mode (compatibilidad)
  static bool get debugMode => kDebugMode;
  static bool get isDevelopment => true; // Siempre true para proyecto educativo
}
