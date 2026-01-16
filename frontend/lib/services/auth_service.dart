import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

/// Servicio de autenticación con soporte para múltiples usuarios.
/// 
/// Valida las credenciales contra el archivo de configuración
/// y mantiene la sesión usando SharedPreferences.
class AuthService {
  static const String _sessionKey = 'user_session';
  static const String _sessionEmailKey = 'user_email';
  static const String _sessionNameKey = 'user_name';
  
  final StorageService _storageService;
  SharedPreferences? _prefs;
  bool _isAuthenticated = false;
  String? _currentUserEmail;
  String? _currentUserName;

  AuthService(this._storageService);

  /// Inicializa el servicio de autenticación
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _checkExistingSession();
  }

  /// Verifica si hay una sesión existente
  Future<void> _checkExistingSession() async {
    final hasSession = _prefs!.getBool(_sessionKey) ?? false;
    if (hasSession) {
      _currentUserEmail = _prefs!.getString(_sessionEmailKey);
      _currentUserName = _prefs!.getString(_sessionNameKey);
      _isAuthenticated = _currentUserEmail != null;
    }
  }

  /// Indica si el usuario está autenticado
  bool get isAuthenticated => _isAuthenticated;

  /// Email del usuario actual
  String? get currentUserEmail => _currentUserEmail;

  /// Nombre del usuario actual
  String? get currentUserName => _currentUserName;

  /// Intenta iniciar sesión con las credenciales proporcionadas
  /// 
  /// Retorna `true` si el login fue exitoso, `false` en caso contrario.
  Future<bool> login(String email, String password) async {
    try {
      final config = await _storageService.getConfig();
      final user = config.getUser(email, password);
      
      if (user != null) {
        // Guardar sesión
        await _prefs!.setBool(_sessionKey, true);
        await _prefs!.setString(_sessionEmailKey, email);
        if (user.name != null) {
          await _prefs!.setString(_sessionNameKey, user.name!);
        }
        
        _isAuthenticated = true;
        _currentUserEmail = email;
        _currentUserName = user.name;
        
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    await _prefs!.remove(_sessionKey);
    await _prefs!.remove(_sessionEmailKey);
    await _prefs!.remove(_sessionNameKey);
    
    _isAuthenticated = false;
    _currentUserEmail = null;
    _currentUserName = null;
  }

  /// Verifica si las credenciales son válidas sin iniciar sesión
  Future<bool> validateCredentials(String email, String password) async {
    try {
      final config = await _storageService.getConfig();
      return config.validateCredentials(email, password);
    } catch (e) {
      return false;
    }
  }
}
