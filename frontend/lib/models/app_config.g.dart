// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
  users: (json['users'] as List<dynamic>)
      .map((e) => UserConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
  supabase: json['supabase'] == null
      ? null
      : SupabaseConfig.fromJson(json['supabase'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
  'users': instance.users,
  'supabase': instance.supabase,
};

SupabaseConfig _$SupabaseConfigFromJson(Map<String, dynamic> json) =>
    SupabaseConfig(
      url: json['url'] as String,
      anonKey: json['anonKey'] as String,
    );

Map<String, dynamic> _$SupabaseConfigToJson(SupabaseConfig instance) =>
    <String, dynamic>{
      'url': instance.url,
      'anonKey': instance.anonKey,
    };

UserConfig _$UserConfigFromJson(Map<String, dynamic> json) => UserConfig(
  email: json['email'] as String,
  password: json['password'] as String,
  name: json['name'] as String?,
);

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
    };
