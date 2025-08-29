#!/bin/bash

# 🧪 Script de Testing Completo del Backend
# Verifica que todas las APIs estén funcionando correctamente

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
BASE_URL="http://localhost:54321"
ANON_KEY="SUPABASE_JWT_REMOVED"

# Contadores
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Función para imprimir encabezados
print_header() {
    echo -e "\n${BLUE}=====================================================${NC}"
    echo -e "${BLUE}🧪 $1${NC}"
    echo -e "${BLUE}=====================================================${NC}\n"
}

# Función para imprimir resultados de tests
print_test_result() {
    local test_name="$1"
    local status="$2"
    local details="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$status" = "PASS" ]; then
        echo -e "✅ ${GREEN}PASS${NC} - $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        if [ -n "$details" ]; then
            echo -e "   ${details}"
        fi
    else
        echo -e "❌ ${RED}FAIL${NC} - $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        if [ -n "$details" ]; then
            echo -e "   ${RED}Error: ${details}${NC}"
        fi
    fi
}

# Función para hacer peticiones HTTP
make_request() {
    local method="$1"
    local url="$2"
    local data="$3"
    local auth_header="$4"
    
    if [ -z "$auth_header" ]; then
        auth_header="apikey: $ANON_KEY"
    fi
    
    if [ "$method" = "GET" ]; then
        curl -s -w "\n%{http_code}" -H "$auth_header" "$url"
    else
        curl -s -w "\n%{http_code}" -X "$method" -H "$auth_header" -H "Content-Type: application/json" -d "$data" "$url"
    fi
}

# Función para obtener JWT token de usuario de prueba
get_jwt_token() {
    local user_email="$1"
    
    # Simular login usando la función SQL
    local jwt_query="SELECT public.simulate_login('$user_email') as jwt_token;"
    local result=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "$jwt_query" 2>/dev/null | tr -d ' ')
    echo "$result"
}

print_header "VERIFICACIÓN COMPLETA DEL BACKEND TFG"

# 1. VERIFICAR SERVICIOS BÁSICOS
print_header "1. SERVICIOS BÁSICOS"

# Test 1.1: Supabase API Health
response=$(make_request "GET" "$BASE_URL/rest/v1/" "" "apikey: $ANON_KEY")
http_code=$(echo "$response" | tail -n1)
if [ "$http_code" = "200" ]; then
    print_test_result "Supabase API Health" "PASS" "API REST responde correctamente"
else
    print_test_result "Supabase API Health" "FAIL" "HTTP $http_code - API no responde"
fi

# Test 1.2: Base de datos conectada
db_test=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT 1;" 2>/dev/null | tr -d ' ')
if [ "$db_test" = "1" ]; then
    print_test_result "Conexión a Base de Datos" "PASS" "PostgreSQL conectado"
else
    print_test_result "Conexión a Base de Datos" "FAIL" "No se puede conectar a PostgreSQL"
fi

# Test 1.3: Edge Functions Health
functions_response=$(curl -s -w "%{http_code}" -o /dev/null "$BASE_URL/functions/v1/")
if [ "$functions_response" = "404" ]; then
    print_test_result "Edge Functions Health" "PASS" "Servidor de funciones activo"
else
    print_test_result "Edge Functions Health" "FAIL" "HTTP $functions_response - Funciones no disponibles"
fi

# 2. VERIFICAR MODELO DE DATOS
print_header "2. MODELO DE DATOS"

# Test 2.1: Tablas principales
required_tables=("users" "anteprojects" "projects" "tasks" "comments" "files" "milestones" "notifications")
for table in "${required_tables[@]}"; do
    table_exists=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '$table');" 2>/dev/null | tr -d ' ')
    if [ "$table_exists" = "t" ]; then
        print_test_result "Tabla $table" "PASS" "Tabla existe en la base de datos"
    else
        print_test_result "Tabla $table" "FAIL" "Tabla no encontrada"
    fi
done

# Test 2.2: Funciones SQL críticas
required_functions=("update_updated_at_column" "validate_github_url" "create_notification" "get_project_stats")
for function in "${required_functions[@]}"; do
    function_exists=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT EXISTS (SELECT FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name = '$function');" 2>/dev/null | tr -d ' ')
    if [ "$function_exists" = "t" ]; then
        print_test_result "Función $function" "PASS" "Función SQL disponible"
    else
        print_test_result "Función $function" "FAIL" "Función SQL no encontrada"
    fi
done

# Test 2.3: Datos de ejemplo
users_count=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null | tr -d ' ')
if [ "$users_count" -gt "0" ]; then
    print_test_result "Datos de Usuario" "PASS" "$users_count usuarios de ejemplo disponibles"
else
    print_test_result "Datos de Usuario" "FAIL" "No hay usuarios de ejemplo"
fi

objectives_count=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT COUNT(*) FROM dam_objectives;" 2>/dev/null | tr -d ' ')
if [ "$objectives_count" -gt "0" ]; then
    print_test_result "Objetivos DAM" "PASS" "$objectives_count objetivos disponibles"
else
    print_test_result "Objetivos DAM" "FAIL" "No hay objetivos DAM configurados"
fi

# 3. VERIFICAR RLS (ROW LEVEL SECURITY)
print_header "3. SEGURIDAD RLS"

# Test 3.1: RLS habilitado en tablas críticas
critical_tables=("users" "anteprojects" "projects" "tasks")
for table in "${critical_tables[@]}"; do
    rls_enabled=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT rowsecurity FROM pg_tables WHERE tablename = '$table';" 2>/dev/null | tr -d ' ')
    if [ "$rls_enabled" = "t" ]; then
        print_test_result "RLS en $table" "PASS" "Row Level Security habilitado"
    else
        print_test_result "RLS en $table" "FAIL" "RLS no habilitado"
    fi
done

# Test 3.2: Funciones RLS
rls_functions=("user_id" "user_role" "is_admin" "is_tutor" "is_student")
for function in "${rls_functions[@]}"; do
    function_exists=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT EXISTS (SELECT FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name = '$function');" 2>/dev/null | tr -d ' ')
    if [ "$function_exists" = "t" ]; then
        print_test_result "Función RLS $function" "PASS" "Función de seguridad disponible"
    else
        print_test_result "Función RLS $function" "FAIL" "Función de seguridad no encontrada"
    fi
done

# 4. TESTING APIs - ANTEPROJECTS
print_header "4. API ANTEPROJECTS"

# Obtener JWT token para estudiante
student_jwt=$(get_jwt_token "carlos.lopez@alumno.cifpcarlos3.es")
tutor_jwt=$(get_jwt_token "maria.garcia@cifpcarlos3.es")

# Test 4.1: Listar anteproyectos como estudiante
if [ -n "$student_jwt" ]; then
    response=$(make_request "GET" "$BASE_URL/functions/v1/anteprojects-api/" "" "Authorization: Bearer $student_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "200" ]; then
        print_test_result "GET /anteprojects-api (estudiante)" "PASS" "Lista anteproyectos correctamente"
    else
        print_test_result "GET /anteprojects-api (estudiante)" "FAIL" "HTTP $http_code"
    fi
else
    print_test_result "GET /anteprojects-api (estudiante)" "FAIL" "No se pudo obtener JWT token"
fi

# Test 4.2: Listar anteproyectos como tutor
if [ -n "$tutor_jwt" ]; then
    response=$(make_request "GET" "$BASE_URL/functions/v1/anteprojects-api/" "" "Authorization: Bearer $tutor_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "200" ]; then
        print_test_result "GET /anteprojects-api (tutor)" "PASS" "Lista anteproyectos correctamente"
    else
        print_test_result "GET /anteprojects-api (tutor)" "FAIL" "HTTP $http_code"
    fi
else
    print_test_result "GET /anteprojects-api (tutor)" "FAIL" "No se pudo obtener JWT token"
fi

# Test 4.3: Obtener anteproyecto específico
if [ -n "$student_jwt" ]; then
    response=$(make_request "GET" "$BASE_URL/functions/v1/anteprojects-api/1" "" "Authorization: Bearer $student_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "200" ]; then
        print_test_result "GET /anteprojects-api/1" "PASS" "Obtiene anteproyecto específico"
    else
        print_test_result "GET /anteprojects-api/1" "FAIL" "HTTP $http_code"
    fi
fi

# 5. TESTING APIs - APPROVAL
print_header "5. API APPROVAL"

# Test 5.1: Aprobar anteproyecto como tutor
if [ -n "$tutor_jwt" ]; then
    approval_data='{"anteproject_id": 2, "comments": "Anteproyecto aprobado para testing"}'
    response=$(make_request "POST" "$BASE_URL/functions/v1/approval-api?action=approve" "$approval_data" "Authorization: Bearer $tutor_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "200" ]; then
        print_test_result "POST /approval-api?action=approve" "PASS" "Aprobación de anteproyecto funciona"
    else
        print_test_result "POST /approval-api?action=approve" "FAIL" "HTTP $http_code"
    fi
fi

# 6. TESTING APIs - TASKS
print_header "6. API TASKS"

# Test 6.1: Listar tareas del usuario
if [ -n "$student_jwt" ]; then
    response=$(make_request "GET" "$BASE_URL/functions/v1/tasks-api/" "" "Authorization: Bearer $student_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "200" ]; then
        print_test_result "GET /tasks-api (mis tareas)" "PASS" "Lista tareas del usuario"
    else
        print_test_result "GET /tasks-api (mis tareas)" "FAIL" "HTTP $http_code"
    fi
fi

# Test 6.2: Listar tareas por proyecto
if [ -n "$student_jwt" ]; then
    response=$(make_request "GET" "$BASE_URL/functions/v1/tasks-api/?project_id=1" "" "Authorization: Bearer $student_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "200" ]; then
        print_test_result "GET /tasks-api?project_id=1" "PASS" "Lista tareas por proyecto"
    else
        print_test_result "GET /tasks-api?project_id=1" "FAIL" "HTTP $http_code"
    fi
fi

# Test 6.3: Crear nueva tarea
if [ -n "$tutor_jwt" ]; then
    task_data='{
        "project_id": 1,
        "title": "Tarea de testing API",
        "description": "Tarea creada automáticamente para verificar la API",
        "due_date": "2024-09-15",
        "estimated_hours": 4,
        "complexity": "medium",
        "assignees": []
    }'
    response=$(make_request "POST" "$BASE_URL/functions/v1/tasks-api/" "$task_data" "Authorization: Bearer $tutor_jwt")
    http_code=$(echo "$response" | tail -n1)
    if [ "$http_code" = "201" ]; then
        print_test_result "POST /tasks-api (crear tarea)" "PASS" "Creación de tarea funciona"
        # Extraer ID de la tarea creada para tests siguientes
        task_id=$(echo "$response" | head -n -1 | grep -o '"id":[0-9]*' | cut -d':' -f2)
        echo "   Task ID creada: $task_id"
    else
        print_test_result "POST /tasks-api (crear tarea)" "FAIL" "HTTP $http_code"
    fi
fi

# 7. VERIFICAR NOTIFICACIONES
print_header "7. SISTEMA DE NOTIFICACIONES"

notifications_count=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT COUNT(*) FROM notifications;" 2>/dev/null | tr -d ' ')
if [ "$notifications_count" -gt "0" ]; then
    print_test_result "Sistema de Notificaciones" "PASS" "$notifications_count notificaciones en el sistema"
else
    print_test_result "Sistema de Notificaciones" "FAIL" "No hay notificaciones en el sistema"
fi

# 8. VERIFICAR CONFIGURACIÓN DEL SISTEMA
print_header "8. CONFIGURACIÓN DEL SISTEMA"

settings_count=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT COUNT(*) FROM system_settings;" 2>/dev/null | tr -d ' ')
if [ "$settings_count" -gt "0" ]; then
    print_test_result "Configuración del Sistema" "PASS" "$settings_count configuraciones disponibles"
else
    print_test_result "Configuración del Sistema" "FAIL" "No hay configuraciones del sistema"
fi

pdf_templates_count=$(psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -t -c "SELECT COUNT(*) FROM pdf_templates;" 2>/dev/null | tr -d ' ')
if [ "$pdf_templates_count" -gt "0" ]; then
    print_test_result "Plantillas PDF" "PASS" "$pdf_templates_count plantillas disponibles"
else
    print_test_result "Plantillas PDF" "FAIL" "No hay plantillas PDF configuradas"
fi

# RESUMEN FINAL
print_header "RESUMEN DE TESTING"

echo -e "${BLUE}📊 ESTADÍSTICAS FINALES:${NC}"
echo -e "   Total de tests: ${YELLOW}$TESTS_TOTAL${NC}"
echo -e "   Tests pasados: ${GREEN}$TESTS_PASSED${NC}"
echo -e "   Tests fallados: ${RED}$TESTS_FAILED${NC}"

success_rate=$((TESTS_PASSED * 100 / TESTS_TOTAL))
echo -e "   Tasa de éxito: ${YELLOW}$success_rate%${NC}"

echo -e "\n${BLUE}📋 ESTADO DEL BACKEND:${NC}"

if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "   ${GREEN}✅ BACKEND 100% FUNCIONAL${NC}"
    echo -e "   ${GREEN}✅ LISTO PARA ENTREGA AL EQUIPO FRONTEND${NC}"
    echo -e "   ${GREEN}✅ TODAS LAS APIs FUNCIONAN CORRECTAMENTE${NC}"
    echo -e "   ${GREEN}✅ SEGURIDAD RLS ACTIVA${NC}"
    echo -e "   ${GREEN}✅ DATOS DE EJEMPLO DISPONIBLES${NC}"
elif [ "$success_rate" -ge 90 ]; then
    echo -e "   ${YELLOW}⚠️  BACKEND FUNCIONAL CON WARNINGS MENORES${NC}"
    echo -e "   ${YELLOW}⚠️  Revisar $TESTS_FAILED tests fallidos${NC}"
else
    echo -e "   ${RED}❌ BACKEND REQUIERE CORRECCIONES${NC}"
    echo -e "   ${RED}❌ $TESTS_FAILED tests críticos fallaron${NC}"
fi

echo -e "\n${BLUE}🚀 PRÓXIMOS PASOS PARA EL EQUIPO FRONTEND:${NC}"
echo -e "   1. Configurar Flutter con Supabase SDK"
echo -e "   2. Usar API URL: $BASE_URL"
echo -e "   3. Usar anon key para auth: $ANON_KEY"
echo -e "   4. Implementar login con Supabase Auth"
echo -e "   5. Consumir APIs REST implementadas"

echo -e "\n${BLUE}📚 DOCUMENTACIÓN DISPONIBLE:${NC}"
echo -e "   - backend/supabase/README.md (Guía principal)"
echo -e "   - backend/supabase/functions/README.md (APIs)"
echo -e "   - backend/supabase/rls_setup_guide.md (Seguridad)"
echo -e "   - docs/desarrollo/ (Seguimiento del proyecto)"

echo -e "\n${BLUE}════════════════════════════════════════=${NC}"
echo -e "${BLUE}🎯 TESTING COMPLETADO${NC}"
echo -e "${BLUE}════════════════════════════════════════=${NC}\n"

exit $TESTS_FAILED
