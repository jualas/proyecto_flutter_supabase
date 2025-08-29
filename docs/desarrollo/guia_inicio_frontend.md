# 🚀 GUÍA DE INICIO RÁPIDO - FRONTEND TFG
# Sistema de Seguimiento de Proyectos TFG - Flutter + Supabase

## ⚡ **INICIO RÁPIDO (30 minutos)**

### **1. Prerrequisitos**
```bash
# Verificar que tienes instalado:
flutter --version  # Flutter 3.0+
dart --version     # Dart 3.0+
git --version      # Git

# Verificar plataformas habilitadas
flutter devices
```

### **2. Crear Proyecto Flutter Multiplataforma**
```bash
# Navegar al directorio del proyecto
cd /opt/proyecto_flutter_supabase

# Crear proyecto Flutter con todas las plataformas
flutter create frontend --platforms=web,android,ios,windows,macos,linux
cd frontend

# Verificar que funciona en web (más rápido para desarrollo)
flutter run -d chrome
```

### **3. Configurar Dependencias Multiplataforma**
```bash
# Añadir dependencias al pubspec.yaml
flutter pub add supabase_flutter
flutter pub add flutter_bloc
flutter pub add go_router
flutter pub add json_annotation
flutter pub add build_runner
flutter pub add json_serializable
flutter pub add universal_platform  # Para detección de plataforma

# Instalar dependencias
flutter pub get
```

### **4. Configurar Supabase Multiplataforma**
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuración específica por plataforma
  if (kIsWeb) {
    // Configuraciones específicas para web
    print('Ejecutando en Web');
  } else if (Platform.isAndroid) {
    // Configuraciones específicas para Android
    print('Ejecutando en Android');
  } else if (Platform.isIOS) {
    // Configuraciones específicas para iOS
    print('Ejecutando en iOS');
  } else if (Platform.isWindows) {
    // Configuraciones específicas para Windows
    print('Ejecutando en Windows');
  } else if (Platform.isMacOS) {
    // Configuraciones específicas para macOS
    print('Ejecutando en macOS');
  } else if (Platform.isLinux) {
    // Configuraciones específicas para Linux
    print('Ejecutando en Linux');
  }
  
  await Supabase.initialize(
    url: 'http://localhost:54321',
    anonKey: 'SUPABASE_JWT_REMOVED',
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFG Sistema Multiplataforma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
```

### **5. Probar Conexión Multiplataforma**
```dart
// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login TFG - ${_getPlatformName()}'),
        backgroundColor: _getPlatformColor(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar información de plataforma
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(_getPlatformIcon(), size: 48, color: _getPlatformColor()),
                    SizedBox(height: 8),
                    Text('Plataforma: ${_getPlatformName()}'),
                    Text('Versión: ${_getPlatformVersion()}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPlatformColor(),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Desconocida';
  }
  
  Color _getPlatformColor() {
    if (kIsWeb) return Colors.blue;
    if (Platform.isAndroid) return Colors.green;
    if (Platform.isIOS) return Colors.black;
    if (Platform.isWindows) return Colors.blue;
    if (Platform.isMacOS) return Colors.grey;
    if (Platform.isLinux) return Colors.orange;
    return Colors.grey;
  }
  
  IconData _getPlatformIcon() {
    if (kIsWeb) return Icons.web;
    if (Platform.isAndroid) return Icons.android;
    if (Platform.isIOS) return Icons.phone_iphone;
    if (Platform.isWindows) return Icons.computer;
    if (Platform.isMacOS) return Icons.laptop_mac;
    if (Platform.isLinux) return Icons.laptop;
    return Icons.device_unknown;
  }
  
  String _getPlatformVersion() {
    if (kIsWeb) return 'Browser';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
  
  Future<void> _login() async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login exitoso en ${_getPlatformName()}!'),
            backgroundColor: _getPlatformColor(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

### **6. Ejecutar y Probar Multiplataforma**
```bash
# Ejecutar en Web (más rápido para desarrollo)
flutter run -d chrome

# Ejecutar en Android
flutter run -d android

# Ejecutar en iOS (requiere macOS)
flutter run -d ios

# Ejecutar en Windows
flutter run -d windows

# Ejecutar en macOS
flutter run -d macos

# Ejecutar en Linux
flutter run -d linux

# Usar credenciales de prueba:
# Email: carlos.lopez@alumno.cifpcarlos3.es
# Password: password123
```

---

## 🌐 **CONFIGURACIÓN MULTIPLATAFORMA**

### **Habilitar Plataformas**
```bash
# Verificar plataformas disponibles
flutter devices

# Habilitar plataformas específicas
flutter config --enable-web
flutter config --enable-windows
flutter config --enable-macos
flutter config --enable-linux
```

### **Configuración por Plataforma**

#### **Web (Prioridad ALTA)**
```bash
# Configurar para web
flutter config --enable-web

# Build para producción web
flutter build web --release --web-renderer html
flutter build web --release --web-renderer canvaskit

# Configurar PWA (Progressive Web App)
# Editar web/manifest.json y web/index.html
```

#### **Android (Prioridad ALTA)**
```bash
# Configurar para Android
flutter config --enable-android

# Configurar signing para Google Play
# Editar android/app/build.gradle

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

#### **iOS (Prioridad MEDIA)**
```bash
# Configurar para iOS (solo en macOS)
flutter config --enable-ios

# Configurar certificados de Apple Developer
# Editar ios/Runner.xcodeproj

# Build para iOS
flutter build ios --release
```

#### **Escritorio (Prioridad MEDIA-BAJA)**
```bash
# Configurar para escritorio
flutter config --enable-windows
flutter config --enable-macos
flutter config --enable-linux

# Build para Windows
flutter build windows --release

# Build para macOS
flutter build macos --release

# Build para Linux
flutter build linux --release
```

---

## 📁 **ESTRUCTURA DE CARPETAS RECOMENDADA MULTIPLATAFORMA**

```
frontend/
├── lib/
│   ├── main.dart                 # Punto de entrada multiplataforma
│   ├── app.dart                  # Configuración de la app
│   ├── models/                   # Modelos de datos (comunes)
│   │   ├── user.dart
│   │   ├── anteproject.dart
│   │   ├── task.dart
│   │   └── notification.dart
│   ├── services/                 # Servicios de comunicación
│   │   ├── auth_service.dart
│   │   ├── anteprojects_service.dart
│   │   ├── tasks_service.dart
│   │   ├── notifications_service.dart
│   │   └── platform_service.dart # Servicio para adaptaciones por plataforma
│   ├── blocs/                    # Gestión de estado
│   │   ├── auth_bloc.dart
│   │   ├── anteprojects_bloc.dart
│   │   ├── tasks_bloc.dart
│   │   └── platform_bloc.dart    # BLoC para gestión de plataforma
│   ├── screens/                  # Pantallas de la app
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── student/
│   │   │   ├── student_dashboard.dart
│   │   │   └── anteproject_form.dart
│   │   ├── tutor/
│   │   │   ├── tutor_dashboard.dart
│   │   │   └── approval_screen.dart
│   │   └── kanban/
│   │       ├── kanban_board.dart
│   │       └── task_card.dart
│   ├── widgets/                  # Widgets reutilizables
│   │   ├── common/
│   │   │   ├── loading_widget.dart
│   │   │   └── error_widget.dart
│   │   ├── forms/
│   │   │   ├── anteproject_form.dart
│   │   │   └── task_form.dart
│   │   └── platform/             # Widgets específicos por plataforma
│   │       ├── web_widgets.dart
│   │       ├── mobile_widgets.dart
│   │       └── desktop_widgets.dart
│   ├── utils/                    # Utilidades
│   │   ├── constants.dart
│   │   ├── validators.dart
│   │   ├── helpers.dart
│   │   └── platform_utils.dart   # Utilidades para detección de plataforma
│   └── themes/                   # Temas por plataforma
│       ├── app_theme.dart
│       ├── web_theme.dart
│       ├── mobile_theme.dart
│       └── desktop_theme.dart
├── web/                          # Configuración específica de web
│   ├── index.html
│   ├── manifest.json
│   └── favicon.png
├── android/                      # Configuración específica de Android
│   ├── app/
│   │   ├── src/
│   │   └── build.gradle
│   └── build.gradle
├── ios/                          # Configuración específica de iOS
│   ├── Runner/
│   └── Runner.xcodeproj
├── windows/                      # Configuración específica de Windows
│   ├── runner/
│   └── CMakeLists.txt
├── macos/                        # Configuración específica de macOS
│   ├── Runner/
│   └── Runner.xcodeproj
├── linux/                        # Configuración específica de Linux
│   ├── my_application.cc
│   └── CMakeLists.txt
├── test/                         # Tests
│   ├── unit/
│   ├── widget/
│   └── integration/
└── pubspec.yaml                  # Dependencias
```

---

## 🔧 **COMANDOS ÚTILES MULTIPLATAFORMA**

### **Desarrollo Diario**
```bash
# Verificar dependencias
flutter pub get

# Ejecutar aplicación en web (más rápido)
flutter run -d chrome

# Ejecutar en modo debug multiplataforma
flutter run --debug

# Ejecutar en modo release multiplataforma
flutter run --release

# Hot reload (durante desarrollo)
# Presionar 'r' en la terminal
```

### **Testing Multiplataforma**
```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests específicos
flutter test test/unit/auth_service_test.dart

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar tests por plataforma
flutter test --platform chrome
flutter test --platform android
```

### **Análisis de Código**
```bash
# Analizar código
flutter analyze

# Formatear código
flutter format .

# Limpiar proyecto
flutter clean
```

### **Generación de Código**
```bash
# Generar código para modelos JSON
flutter packages pub run build_runner build

# Generar código en modo watch
flutter packages pub run build_runner watch
```

### **Build Multiplataforma**
```bash
# Build para Web
flutter build web --release

# Build para Android
flutter build apk --release
flutter build appbundle --release

# Build para iOS
flutter build ios --release

# Build para Windows
flutter build windows --release

# Build para macOS
flutter build macos --release

# Build para Linux
flutter build linux --release

# Build para todas las plataformas
flutter build --release
```

---

## 📱 **USUARIOS DE PRUEBA**

### **Estudiante**
```json
{
  "email": "carlos.lopez@alumno.cifpcarlos3.es",
  "password": "password123",
  "role": "student",
  "full_name": "Carlos López"
}
```

### **Tutor**
```json
{
  "email": "maria.garcia@cifpcarlos3.es",
  "password": "password123",
  "role": "tutor",
  "full_name": "María García"
}
```

### **Administrador**
```json
{
  "email": "admin@cifpcarlos3.es",
  "password": "password123",
  "role": "admin",
  "full_name": "Administrador"
}
```

---

## 🛠️ **APIs DISPONIBLES**

### **1. Anteprojects API**
```dart
// Obtener anteproyectos del usuario
final response = await supabase.functions.invoke(
  'anteprojects-api',
  method: 'GET',
);

// Crear anteproyecto
final response = await supabase.functions.invoke(
  'anteprojects-api',
  method: 'POST',
  body: anteproject.toJson(),
);
```

### **2. Tasks API**
```dart
// Obtener tareas del proyecto
final response = await supabase.functions.invoke(
  'tasks-api',
  method: 'GET',
  queryParams: {'project_id': projectId.toString()},
);

// Crear tarea
final response = await supabase.functions.invoke(
  'tasks-api',
  method: 'POST',
  body: task.toJson(),
);
```

### **3. Approval API**
```dart
// Aprobar anteproyecto
final response = await supabase.functions.invoke(
  'approval-api',
  method: 'POST',
  queryParams: {'action': 'approve'},
  body: {'anteproject_id': anteprojectId},
);
```

---

## 🎯 **PRÓXIMOS PASOS MULTIPLATAFORMA**

### **Semana 1: Configuración Multiplataforma**
1. ✅ Crear proyecto Flutter multiplataforma
2. ✅ Configurar dependencias para todas las plataformas
3. ✅ Implementar login básico multiplataforma
4. ✅ Probar conexión con backend en todas las plataformas

### **Semana 2: Autenticación Multiplataforma**
1. Crear modelos de datos multiplataforma
2. Implementar servicios multiplataforma
3. Configurar gestión de estado multiplataforma
4. Implementar navegación por roles multiplataforma

### **Semana 3: Dashboards Multiplataforma**
1. Crear dashboard para estudiantes multiplataforma
2. Crear dashboard para tutores multiplataforma
3. Implementar widgets comunes multiplataforma
4. Configurar navegación principal multiplataforma

---

## 📞 **SOPORTE MULTIPLATAFORMA**

### **En caso de problemas:**
1. **Verificar backend**: `supabase status` en `/backend/supabase`
2. **Revisar logs**: `flutter run --verbose`
3. **Verificar dependencias**: `flutter pub deps`
4. **Limpiar cache**: `flutter clean && flutter pub get`
5. **Verificar plataforma específica**: `flutter doctor`

### **Problemas específicos por plataforma:**

#### **Web**
```bash
# Problemas de CORS
# Verificar configuración de Supabase para web

# Problemas de renderizado
flutter run -d chrome --web-renderer html
flutter run -d chrome --web-renderer canvaskit
```

#### **Android**
```bash
# Problemas de permisos
# Verificar android/app/src/main/AndroidManifest.xml

# Problemas de build
flutter clean
flutter pub get
flutter build apk --debug
```

#### **iOS**
```bash
# Problemas de certificados
# Verificar configuración en Xcode

# Problemas de build
flutter clean
flutter pub get
flutter build ios --debug
```

#### **Escritorio**
```bash
# Problemas de dependencias nativas
# Verificar instalación de herramientas de desarrollo

# Problemas de build
flutter clean
flutter pub get
flutter build windows --debug
```

### **Documentación adicional:**
- [Plan de desarrollo completo](plan_desarrollo_frontend.md)
- [Checklist semanal](checklist_frontend_semanal.md)
- [Entrega del backend](../backend/supabase/ENTREGA_BACKEND_FRONTEND.md)
- [Documentación oficial de Flutter](https://docs.flutter.dev/)
- [Guía de desarrollo multiplataforma](https://docs.flutter.dev/development/platform-integration)

---

**¡LISTO PARA COMENZAR DESARROLLO MULTIPLATAFORMA! 🚀**

**Fecha de creación**: 17 de agosto de 2024  
**Responsable**: Equipo Frontend  
**Estado**: ✅ **LISTO PARA INICIAR MULTIPLATAFORMA**
