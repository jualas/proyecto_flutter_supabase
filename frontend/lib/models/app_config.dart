import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

/// Modelo que representa la configuración de la aplicación.
@JsonSerializable()
class AppConfig {
  final List<UserConfig> users;
  final SupabaseConfig? supabase;

  const AppConfig({
    required this.users,
    this.supabase,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  /// Valida las credenciales contra todos los usuarios configurados
  bool validateCredentials(String email, String password) {
    return users.any((user) => user.validateCredentials(email, password));
  }

  /// Obtiene el usuario que coincide con las credenciales
  UserConfig? getUser(String email, String password) {
    try {
      return users.firstWhere((user) => user.validateCredentials(email, password));
    } catch (_) {
      return null;
    }
  }
}

/// Configuración (client-safe) para conectar con Supabase desde la app.
@JsonSerializable()
class SupabaseConfig {
  final String url;
  @JsonKey(name: 'anonKey')
  final String anonKey;

  const SupabaseConfig({
    required this.url,
    required this.anonKey,
  });

  factory SupabaseConfig.fromJson(Map<String, dynamic> json) =>
      _$SupabaseConfigFromJson(json);
  Map<String, dynamic> toJson() => _$SupabaseConfigToJson(this);

  bool get isEnabled => url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}

/// Configuración de un usuario de la aplicación.
@JsonSerializable()
class UserConfig {
  final String email;
  final String password;
  final String? name;

  const UserConfig({
    required this.email,
    required this.password,
    this.name,
  });

  factory UserConfig.fromJson(Map<String, dynamic> json) => _$UserConfigFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  /// Valida las credenciales proporcionadas
  bool validateCredentials(String inputEmail, String inputPassword) {
    return email.toLowerCase() == inputEmail.toLowerCase() && password == inputPassword;
  }
}
