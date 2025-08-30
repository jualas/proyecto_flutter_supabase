#!/usr/bin/env python3
"""
Script para probar la autenticación de Supabase y crear usuarios de prueba
"""

import requests
import json
import sys

# Configuración de Supabase local
SUPABASE_URL = "http://127.0.0.1:54321"
SUPABASE_ANON_KEY = "SUPABASE_JWT_REMOVED"

def test_connection():
    """Probar conexión básica con Supabase"""
    print("🔧 Probando conexión con Supabase...")
    print(f"URL: {SUPABASE_URL}")
    print(f"Anon Key: {SUPABASE_ANON_KEY[:20]}...")
    
    try:
        # Probar endpoint de salud
        response = requests.get(f"{SUPABASE_URL}/rest/v1/", headers={
            "apikey": SUPABASE_ANON_KEY,
            "Authorization": f"Bearer {SUPABASE_ANON_KEY}"
        })
        
        if response.status_code == 200:
            print("✅ Conexión exitosa con Supabase")
            return True
        else:
            print(f"❌ Error de conexión: {response.status_code}")
            print(f"Respuesta: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error de conexión: {e}")
        return False

def create_test_user(email, password, user_data):
    """Crear un usuario de prueba"""
    print(f"\n👤 Creando usuario: {email}")
    
    try:
        # Crear usuario
        signup_response = requests.post(f"{SUPABASE_URL}/auth/v1/signup", 
            headers={
                "apikey": SUPABASE_ANON_KEY,
                "Content-Type": "application/json"
            },
            json={
                "email": email,
                "password": password,
                "data": user_data
            }
        )
        
        print(f"Status: {signup_response.status_code}")
        print(f"Respuesta: {signup_response.text}")
        
        if signup_response.status_code in [200, 201]:
            print("✅ Usuario creado exitosamente")
            return True
        else:
            print("❌ Error al crear usuario")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_login(email, password):
    """Probar login con un usuario"""
    print(f"\n🔐 Probando login: {email}")
    
    try:
        login_response = requests.post(f"{SUPABASE_URL}/auth/v1/token?grant_type=password",
            headers={
                "apikey": SUPABASE_ANON_KEY,
                "Content-Type": "application/json"
            },
            json={
                "email": email,
                "password": password
            }
        )
        
        print(f"Status: {login_response.status_code}")
        
        if login_response.status_code == 200:
            data = login_response.json()
            print("✅ Login exitoso")
            print(f"Token: {data.get('access_token', '')[:50]}...")
            print(f"User ID: {data.get('user', {}).get('id', 'N/A')}")
            print(f"Email: {data.get('user', {}).get('email', 'N/A')}")
            return True
        else:
            print(f"❌ Error de login: {login_response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    """Función principal"""
    print("🚀 Script de prueba de autenticación Supabase")
    print("=" * 50)
    
    # Probar conexión
    if not test_connection():
        print("❌ No se pudo conectar a Supabase")
        sys.exit(1)
    
    # Usuarios de prueba
    test_users = [
        {
            "email": "admin@cifpcarlos3.es",
            "password": "password123",
            "data": {"name": "Administrador", "role": "admin"}
        },
        {
            "email": "maria.garcia@cifpcarlos3.es", 
            "password": "password123",
            "data": {"name": "María García", "role": "tutor"}
        },
        {
            "email": "carlos.lopez@alumno.cifpcarlos3.es",
            "password": "password123", 
            "data": {"name": "Carlos López", "role": "student"}
        }
    ]
    
    # Crear usuarios de prueba
    created_users = []
    for user in test_users:
        if create_test_user(user["email"], user["password"], user["data"]):
            created_users.append(user)
    
    print(f"\n📊 Resumen:")
    print(f"Usuarios creados: {len(created_users)}/{len(test_users)}")
    
    # Probar login con usuarios creados
    print(f"\n🔐 Probando login con usuarios creados:")
    for user in created_users:
        test_login(user["email"], user["password"])
    
    print(f"\n🏁 Prueba completada")
    print(f"Supabase Studio: http://127.0.0.1:54323")
    print(f"Email Testing: http://127.0.0.1:54324")

if __name__ == "__main__":
    main()
