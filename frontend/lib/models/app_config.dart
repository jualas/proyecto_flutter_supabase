import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

/// Modelo que representa la configuración de la aplicación.
@JsonSerializable()
class AppConfig {
  final UserConfig user;

  const AppConfig({
    required this.user,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}

/// Configuración del usuario único de la aplicación.
@JsonSerializable()
class UserConfig {
  final String email;
  final String password;

  const UserConfig({
    required this.email,
    required this.password,
  });

  factory UserConfig.fromJson(Map<String, dynamic> json) => _$UserConfigFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  /// Valida las credenciales proporcionadas
  bool validateCredentials(String inputEmail, String inputPassword) {
    return email.toLowerCase() == inputEmail.toLowerCase() && password == inputPassword;
  }
}
