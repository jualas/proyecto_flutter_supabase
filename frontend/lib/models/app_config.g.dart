// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      user: UserConfig.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'user': instance.user.toJson(),
    };

UserConfig _$UserConfigFromJson(Map<String, dynamic> json) => UserConfig(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
