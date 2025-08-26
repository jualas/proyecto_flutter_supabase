#!/bin/bash

# 🧪 Script de pruebas para las APIs del Sistema TFG
# Ejecutar después de iniciar Supabase: supabase start

set -e

# Configuración
BASE_URL="http://localhost:54321/functions/v1"
SUPABASE_URL="http://localhost:54321"
ANON_KEY="SUPABASE_JWT_REMOVED"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Iniciando pruebas de las APIs del Sistema TFG${NC}"
echo "=================================="

# Función para hacer requests
make_request() {
    local method=$1
    local url=$2
    local data=$3
    local token=$4
    
    if [ -z "$token" ]; then
        token=$ANON_KEY
    fi
    
    echo -e "${YELLOW}→ $method $url${NC}"
    
    if [ -z "$data" ]; then
        response=$(curl -s -X $method \
            -H "Authorization: Bearer $token" \
            -H "apikey: $ANON_KEY" \
            -H "Content-Type: application/json" \
            "$url")
    else
        response=$(curl -s -X $method \
            -H "Authorization: Bearer $token" \
            -H "apikey: $ANON_KEY" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$url")
    fi
    
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    echo ""
}

# Función para simular login y obtener JWT
simulate_login() {
    local email=$1
    local password=$2
    
    echo -e "${BLUE}🔐 Simulando login para: $email${NC}"
    
    # Usar la función de simulación que creamos anteriormente
    local jwt_response=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "
        SELECT public.simulate_login('$email', '$password') as jwt;
    " | xargs)
    
    if [ "$jwt_response" != "null" ] && [ -n "$jwt_response" ]; then
        echo -e "${GREEN}✅ Login exitoso${NC}"
        echo "$jwt_response"
    else
        echo -e "${RED}❌ Error en login${NC}"
        echo "null"
    fi
}

# Función para obtener JWT de estudiante
get_student_jwt() {
    simulate_login "juan.perez@alumno.cifpcarlos3.es" "password123"
}

# Función para obtener JWT de tutor
get_tutor_jwt() {
    simulate_login "maria.garcia@cifpcarlos3.es" "password123"
}

# Función para obtener JWT de admin
get_admin_jwt() {
    simulate_login "admin@cifpcarlos3.es" "admin123"
}

echo -e "${BLUE}📋 Prueba 1: Listar anteproyectos (sin autenticación)${NC}"
make_request "GET" "$BASE_URL/anteprojects-api/"

echo -e "${BLUE}📋 Prueba 2: Listar anteproyectos como estudiante${NC}"
STUDENT_JWT=$(get_student_jwt)
if [ "$STUDENT_JWT" != "null" ]; then
    make_request "GET" "$BASE_URL/anteprojects-api/" "" "$STUDENT_JWT"
else
    echo -e "${RED}❌ No se pudo obtener JWT de estudiante${NC}"
fi

echo -e "${BLUE}📋 Prueba 3: Listar anteproyectos como tutor${NC}"
TUTOR_JWT=$(get_tutor_jwt)
if [ "$TUTOR_JWT" != "null" ]; then
    make_request "GET" "$BASE_URL/anteprojects-api/" "" "$TUTOR_JWT"
else
    echo -e "${RED}❌ No se pudo obtener JWT de tutor${NC}"
fi

echo -e "${BLUE}📋 Prueba 4: Obtener anteproyecto específico${NC}"
make_request "GET" "$BASE_URL/anteprojects-api/1" "" "$STUDENT_JWT"

echo -e "${BLUE}📋 Prueba 5: Crear nuevo anteproyecto${NC}"
NEW_ANTEPROJECT='{
    "title": "Sistema de Gestión de Prueba",
    "project_type": "execution",
    "description": "Descripción del proyecto de prueba",
    "academic_year": "2024-2025",
    "expected_results": ["Resultado 1", "Resultado 2"],
    "timeline": {"fecha1": "2024-09-01", "fecha2": "2024-12-15"},
    "tutor_id": 2,
    "student_ids": ["06ec96b8-7e4a-4f85-bf34-5a3d5b2c1a89"],
    "objectives": [{"objective_id": 1, "is_selected": true}]
}'
make_request "POST" "$BASE_URL/anteprojects-api/" "$NEW_ANTEPROJECT" "$STUDENT_JWT"

echo -e "${BLUE}📋 Prueba 6: Enviar anteproyecto para revisión${NC}"
make_request "POST" "$BASE_URL/anteprojects-api/1/submit" "" "$STUDENT_JWT"

echo -e "${BLUE}✅ Prueba 7: Aprobar anteproyecto como tutor${NC}"
APPROVE_DATA='{"anteproject_id": 1, "comments": "Excelente propuesta, aprobado para desarrollo"}'
make_request "POST" "$BASE_URL/approval-api?action=approve" "$APPROVE_DATA" "$TUTOR_JWT"

echo -e "${BLUE}❌ Prueba 8: Rechazar anteproyecto como tutor${NC}"
REJECT_DATA='{"anteproject_id": 2, "comments": "Necesita más detalles en la justificación"}'
make_request "POST" "$BASE_URL/approval-api?action=reject" "$REJECT_DATA" "$TUTOR_JWT"

echo -e "${BLUE}🔄 Prueba 9: Solicitar cambios en anteproyecto${NC}"
CHANGES_DATA='{"anteproject_id": 1, "comments": "Por favor, añade más detalle en la metodología"}'
make_request "POST" "$BASE_URL/approval-api?action=request-changes" "$CHANGES_DATA" "$TUTOR_JWT"

echo -e "${BLUE}🚫 Prueba 10: Intentar aprobar como estudiante (debe fallar)${NC}"
make_request "POST" "$BASE_URL/approval-api?action=approve" "$APPROVE_DATA" "$STUDENT_JWT"

echo -e "${GREEN}🎉 Pruebas completadas${NC}"
echo "=================================="
echo ""
echo -e "${YELLOW}📝 Notas:${NC}"
echo "- Las pruebas requieren que Supabase esté ejecutándose localmente"
echo "- Los JWTs se generan usando la función simulate_login()"
echo "- Algunas pruebas pueden fallar si los datos de ejemplo han cambiado"
echo "- Revisa los logs de las funciones en: supabase functions serve"
