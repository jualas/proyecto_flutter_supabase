# 🔐 Arquitectura de Autenticación

Este documento describe la arquitectura del sistema de autenticación implementado en la aplicación de Seguimiento de Proyectos TFCGS.

---

## 📋 Tabla de Contenidos

1. [Visión General](#-visión-general)
2. [Componentes Principales](#-componentes-principales)
3. [Flujo de Autenticación](#-flujo-de-autenticación)
4. [Roles y Permisos](#-roles-y-permisos)
5. [Row Level Security (RLS)](#-row-level-security-rls)
6. [Gestión de Sesiones](#-gestión-de-sesiones)
7. [Seguridad](#-seguridad)

---

## 🎯 Visión General

La aplicación utiliza **Supabase Auth** como sistema de autenticación, combinado con una tabla `users` personalizada en la base de datos para almacenar información adicional del perfil y roles.

### Arquitectura de Alto Nivel

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENTE (Flutter)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ AuthService │──│  AuthBloc   │──│ LoginScreen/Screens │  │
│  └──────┬──────┘  └─────────────┘  └─────────────────────┘  │
└─────────┼───────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                    SUPABASE                                 │
│  ┌─────────────────┐      ┌──────────────────────────────┐  │
│  │  Supabase Auth  │      │     PostgreSQL Database      │  │
│  │  ─────────────  │      │  ────────────────────────    │  │
│  │  - JWT Tokens   │      │  - Tabla `users` (perfiles)  │  │
│  │  - Sessions     │◄────►│  - Tabla `auth.users`        │  │
│  │  - Email/Pass   │      │  - Políticas RLS             │  │
│  └─────────────────┘      └──────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Características Principales

- ✅ **Autenticación con email/contraseña** mediante Supabase Auth
- ✅ **Tokens JWT** para autorización de peticiones
- ✅ **Roles de usuario** (admin, tutor, student) almacenados en tabla `users`
- ✅ **Row Level Security (RLS)** para aislamiento de datos
- ✅ **Persistencia de sesión** automática por Supabase
- ✅ **Soporte multisesión** sin bloqueos

---

## 🧩 Componentes Principales

### 1. Supabase Auth

Supabase Auth maneja:
- Registro y verificación de usuarios
- Autenticación con email/contraseña
- Generación y gestión de tokens JWT
- Recuperación de contraseña
- Persistencia de sesión

### 2. Tabla `users` (Perfiles)

La tabla `users` en la base de datos almacena información adicional:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | INT | ID único del usuario |
| `email` | VARCHAR | Email (único, enlaza con auth.users) |
| `full_name` | VARCHAR | Nombre completo |
| `role` | ENUM | Rol: `admin`, `tutor`, `student` |
| `status` | ENUM | Estado: `active`, `inactive` |
| `nre` | VARCHAR | Número de registro (estudiantes) |
| `tutor_id` | INT | Tutor asignado (estudiantes) |
| `academic_year` | VARCHAR | Año académico |
| `created_at` | TIMESTAMP | Fecha de creación |
| `updated_at` | TIMESTAMP | Última actualización |

### 3. AuthService (Flutter)

Servicio que encapsula la comunicación con Supabase:

```dart
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Autenticación
  Future<Map<String, dynamic>> signIn({...});
  Future<void> signOut();
  
  // Gestión de perfil
  Future<User?> getCurrentUserFromSupabase();
  Future<User?> getCurrentUserProfile();
  
  // Estado de autenticación
  Stream<AuthState> get authStateChanges;
  bool get isAuthenticated;
}
```

### 4. AuthBloc (Flutter)

BLoC que gestiona el estado de autenticación:

```dart
// Estados
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState { User user; }
class AuthUnauthenticated extends AuthState {}
class AuthFailure extends AuthState { String message; }

// Eventos
class AuthLoginRequested extends AuthEvent {}
class AuthLogoutRequested extends AuthEvent {}
class AuthCheckRequested extends AuthEvent {}
```

---

## 🔄 Flujo de Autenticación

### Login

```
Usuario                  Flutter App                Supabase
  │                          │                         │
  │─── Email/Password ──────►│                         │
  │                          │                         │
  │                          │── signInWithPassword ──►│
  │                          │                         │
  │                          │◄─── JWT Token ─────────│
  │                          │                         │
  │                          │── Query users table ───►│
  │                          │                         │
  │                          │◄─── User Profile ──────│
  │                          │                         │
  │◄── Dashboard (por rol) ──│                         │
  │                          │                         │
```

### Verificación de Sesión (al arrancar la app)

```
App Inicio              AuthBloc                 Supabase
  │                        │                        │
  │── AuthCheckRequested ─►│                        │
  │                        │                        │
  │                        │── currentUser ────────►│
  │                        │                        │
  │                        │◄─── Session/null ─────│
  │                        │                        │
  │                        │── Query profile ──────►│
  │                        │                        │
  │◄─ Authenticated/Unauth │                        │
  │                        │                        │
```

---

## 👥 Roles y Permisos

### Definición de Roles

| Rol | Descripción | Accesos |
|-----|-------------|---------|
| **admin** | Administrador del sistema | Gestión de usuarios, configuración, todos los datos |
| **tutor** | Profesor/Tutor | Sus estudiantes, anteproyectos asignados, flujo de aprobación |
| **student** | Estudiante | Sus propios anteproyectos, proyectos, tareas, Kanban |

### Navegación por Rol

```dart
static String _getDashboardRoute(UserRole role) {
  switch (role) {
    case UserRole.student:
      return '/dashboard/student';
    case UserRole.tutor:
      return '/dashboard/tutor';
    case UserRole.admin:
      return '/dashboard/admin';
  }
}
```

### Protección de Rutas

El router verifica el rol antes de permitir acceso:

```dart
// Ejemplo: ruta solo para administradores
GoRoute(
  path: '/admin/users',
  builder: (context, state) {
    final user = authState.user;
    if (user.role != UserRole.admin) {
      return AccessDeniedScreen();
    }
    return UsersManagementScreen(user: user);
  },
),
```

---

## 🛡️ Row Level Security (RLS)

### Concepto

RLS asegura que cada usuario solo pueda acceder a los datos que le corresponden, **a nivel de base de datos**.

### Función `user_id()`

La base de datos obtiene el ID del usuario desde el token JWT:

```sql
CREATE OR REPLACE FUNCTION public.user_id()
RETURNS INT AS $$
BEGIN
    RETURN (current_setting('request.jwt.claims', true)::json->>'user_id')::INT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Función `is_admin()`

Verifica si el usuario actual es administrador:

```sql
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users 
        WHERE id = public.user_id() 
        AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Ejemplos de Políticas RLS

**Anteproyectos:**
```sql
-- Estudiantes ven sus anteproyectos
CREATE POLICY "students_view_own" ON anteprojects
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM anteproject_students 
            WHERE anteproject_id = anteprojects.id 
            AND student_id = public.user_id()
        )
    );

-- Tutores ven anteproyectos asignados
CREATE POLICY "tutors_view_assigned" ON anteprojects
    FOR SELECT USING (tutor_id = public.user_id());

-- Admins ven todo
CREATE POLICY "admins_view_all" ON anteprojects
    FOR SELECT USING (public.is_admin());
```

---

## 🔐 Gestión de Sesiones

### Persistencia Automática

Supabase maneja automáticamente:
- Almacenamiento seguro del token JWT
- Refresco automático de tokens expirados
- Recuperación de sesión al reiniciar la app

### Stream de Cambios

La aplicación escucha cambios en el estado de autenticación:

```dart
_authService.authStateChanges.listen((AuthState state) {
  switch (state.event) {
    case AuthChangeEvent.signedIn:
      // Usuario logueado
      break;
    case AuthChangeEvent.signedOut:
      // Usuario deslogueado
      break;
    case AuthChangeEvent.tokenRefreshed:
      // Token refrescado
      break;
  }
});
```

### Soporte Multisesión

La aplicación soporta múltiples usuarios simultáneos:

- ✅ Cada usuario tiene su propio token JWT
- ✅ No hay bloqueos de sesión
- ✅ RLS asegura aislamiento de datos
- ✅ Concurrencia manejada por Supabase

---

## 🔒 Seguridad

### Buenas Prácticas Implementadas

1. **Tokens JWT con expiración**: Los tokens tienen tiempo de vida limitado
2. **HTTPS obligatorio**: Toda comunicación está cifrada
3. **RLS activado**: Aislamiento de datos a nivel de base de datos
4. **Validación de roles**: Verificación en frontend y backend
5. **Sin almacenamiento de contraseñas**: Supabase Auth maneja el hash

### Manejo de Errores

```dart
// Errores específicos de autenticación
class AuthenticationException extends AppException {
  // 'invalid_credentials' - credenciales incorrectas
  // 'profile_not_found' - perfil no encontrado
  // 'session_expired' - sesión expirada
  // 'not_authenticated' - usuario no autenticado
}
```

### Logout Seguro

```dart
Future<void> signOut() async {
  await _supabase.auth.signOut(); // Invalida sesión en Supabase
  ThemeService.instance.reset();  // Limpia datos locales
}
```

---

## 📚 Referencias

| Archivo | Responsabilidad |
|---------|----------------|
| `frontend/lib/services/auth_service.dart` | Comunicación con Supabase Auth |
| `frontend/lib/blocs/auth_bloc.dart` | Gestión de estado de autenticación |
| `frontend/lib/screens/auth/login_screen_bloc.dart` | UI del login |
| `frontend/lib/router/app_router.dart` | Protección de rutas |
| `frontend/lib/models/user.dart` | Modelo de datos del usuario |

---

## 🔗 Documentación Relacionada

- [Ciclo de Vida del Login](Ciclo-Vida-Login) - Proceso detallado paso a paso
- [Base de Datos](02-Base-de-Datos) - Modelo de datos y RLS
- [Arquitectura del Sistema](01-Arquitectura) - Visión técnica general

---

**📅 Última actualización**: Diciembre 2025  
**📦 Versión**: 1.0



