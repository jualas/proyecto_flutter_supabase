#!/bin/bash

# =============================================================================
# Script para Publicar Documentación a GitHub Wiki
# Sistema de Seguimiento de Proyectos TFCGS
# =============================================================================

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# =============================================================================
# CONFIGURACIÓN
# =============================================================================

# ⚠️ IMPORTANTE: Reemplaza estos valores con los de tu repositorio
REPO_USER="TU_USUARIO_GITHUB"
REPO_NAME="TU_REPOSITORIO"
REPO_WIKI_URL="https://github.com/${REPO_USER}/${REPO_NAME}.wiki.git"

# Directorios
WIKI_DIR="wiki_temp"
DOCS_DIR="../docs"

# =============================================================================
# FUNCIONES
# =============================================================================

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  📚 Publicador de Wiki de GitHub${NC}"
    echo -e "${BLUE}  Sistema de Seguimiento de Proyectos TFCGS${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}➤${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✖${NC} $1"
}

print_success() {
    echo -e "${GREEN}✔${NC} $1"
}

check_prerequisites() {
    print_step "Verificando prerequisitos..."
    
    # Verificar Git
    if ! command -v git &> /dev/null; then
        print_error "Git no está instalado. Por favor instala Git primero."
        exit 1
    fi
    
    # Verificar configuración del repo
    if [ "$REPO_USER" = "TU_USUARIO_GITHUB" ] || [ "$REPO_NAME" = "TU_REPOSITORIO" ]; then
        print_error "Por favor, configura REPO_USER y REPO_NAME en el script."
        print_warning "Edita este archivo y reemplaza:"
        echo "  - REPO_USER=\"TU_USUARIO_GITHUB\""
        echo "  - REPO_NAME=\"TU_REPOSITORIO\""
        exit 1
    fi
    
    print_success "Prerequisitos verificados"
    echo ""
}

clone_or_update_wiki() {
    print_step "Clonando o actualizando wiki..."
    
    if [ -d "$WIKI_DIR" ]; then
        print_warning "Directorio wiki_temp ya existe. Actualizando..."
        cd "$WIKI_DIR"
        git pull origin master || {
            print_error "Error al actualizar wiki. ¿Tienes cambios sin guardar?"
            cd ..
            exit 1
        }
        cd ..
    else
        print_step "Clonando wiki por primera vez..."
        git clone "$REPO_WIKI_URL" "$WIKI_DIR" || {
            print_error "Error al clonar wiki. Verifica:"
            echo "  1. La URL del repositorio es correcta"
            echo "  2. Tienes permisos para acceder al repositorio"
            echo "  3. La wiki está habilitada en GitHub (Settings > Features > Wikis)"
            exit 1
        }
    fi
    
    print_success "Wiki lista para actualizar"
    echo ""
}

copy_wiki_structure() {
    print_step "Copiando archivos de estructura..."
    
    cd "$WIKI_DIR"
    
    # Copiar archivos de estructura
    if [ -f "../wiki_setup/Home.md" ]; then
        cp ../wiki_setup/Home.md Home.md
        print_success "✓ Home.md copiado"
    fi
    
    if [ -f "../wiki_setup/_Sidebar.md" ]; then
        cp ../wiki_setup/_Sidebar.md _Sidebar.md
        print_success "✓ _Sidebar.md copiado"
    fi
    
    if [ -f "../wiki_setup/_Footer.md" ]; then
        cp ../wiki_setup/_Footer.md _Footer.md
        print_success "✓ _Footer.md copiado"
    fi
    
    if [ -f "../wiki_setup/FAQ.md" ]; then
        cp ../wiki_setup/FAQ.md FAQ.md
        print_success "✓ FAQ.md copiado"
    fi
    
    if [ -f "../wiki_setup/Guia-Inicio-Rapido.md" ]; then
        cp ../wiki_setup/Guia-Inicio-Rapido.md Guia-Inicio-Rapido.md
        print_success "✓ Guia-Inicio-Rapido.md copiado"
    fi
    
    cd ..
    echo ""
}

copy_user_guides() {
    print_step "Copiando guías de usuario..."
    
    cd "$WIKI_DIR"
    
    # Guía de Estudiantes
    if [ -f "${DOCS_DIR}/guias_usuario/guia_estudiante.md" ]; then
        cp "${DOCS_DIR}/guias_usuario/guia_estudiante.md" Guia-Estudiantes.md
        print_success "✓ Guía de Estudiantes copiada"
    else
        print_warning "! Guía de estudiantes no encontrada"
    fi
    
    # Guía de Tutores
    if [ -f "${DOCS_DIR}/guias_usuario/guia_tutor.md" ]; then
        cp "${DOCS_DIR}/guias_usuario/guia_tutor.md" Guia-Tutores.md
        print_success "✓ Guía de Tutores copiada"
    else
        print_warning "! Guía de tutores no encontrada"
    fi
    
    # Guía de Administradores
    if [ -f "${DOCS_DIR}/guias_usuario/guia_administrador.md" ]; then
        cp "${DOCS_DIR}/guias_usuario/guia_administrador.md" Guia-Administradores.md
        print_success "✓ Guía de Administradores copiada"
    else
        print_warning "! Guía de administradores no encontrada"
    fi
    
    cd ..
    echo ""
}

copy_technical_docs() {
    print_step "Copiando documentación técnica..."
    
    cd "$WIKI_DIR"
    
    # Arquitectura de Autenticación (desde wiki_setup)
    if [ -f "../wiki_setup/Arquitectura-Autenticacion.md" ]; then
        cp ../wiki_setup/Arquitectura-Autenticacion.md Arquitectura-Autenticacion.md
        print_success "✓ Arquitectura de Autenticación copiada"
    else
        print_warning "! Arquitectura de autenticación no encontrada"
    fi
    
    cd ..
    echo ""
}

copy_lifecycle_docs() {
    print_step "Copiando documentación de ciclos de vida..."
    
    cd "$WIKI_DIR"
    
    # Ciclo de Vida del Login
    if [ -f "../wiki_setup/Ciclo-Vida-Login.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Login.md Ciclo-Vida-Login.md
        print_success "✓ Ciclo de Vida del Login copiado"
    else
        print_warning "! Ciclo de Vida del Login no encontrado"
    fi
    
    # Ciclo de Vida del Administrador (cuando esté disponible)
    if [ -f "../wiki_setup/Ciclo-Vida-Administrador.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Administrador.md Ciclo-Vida-Administrador.md
        print_success "✓ Ciclo de Vida del Administrador copiado"
    fi
    
    # Ciclo de Vida del Tutor (cuando esté disponible)
    if [ -f "../wiki_setup/Ciclo-Vida-Tutor.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Tutor.md Ciclo-Vida-Tutor.md
        print_success "✓ Ciclo de Vida del Tutor copiado"
    fi
    
    # Ciclo de Vida del Estudiante (cuando esté disponible)
    if [ -f "../wiki_setup/Ciclo-Vida-Estudiante.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Estudiante.md Ciclo-Vida-Estudiante.md
        print_success "✓ Ciclo de Vida del Estudiante copiado"
    fi
    
    # Ciclo de Vida del Anteproyecto (cuando esté disponible)
    if [ -f "../wiki_setup/Ciclo-Vida-Anteproyecto.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Anteproyecto.md Ciclo-Vida-Anteproyecto.md
        print_success "✓ Ciclo de Vida del Anteproyecto copiado"
    fi
    
    # Ciclo de Vida del Proyecto (cuando esté disponible)
    if [ -f "../wiki_setup/Ciclo-Vida-Proyecto.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Proyecto.md Ciclo-Vida-Proyecto.md
        print_success "✓ Ciclo de Vida del Proyecto copiado"
    fi
    
    # Ciclo de Vida de la Tarea (cuando esté disponible)
    if [ -f "../wiki_setup/Ciclo-Vida-Tarea.md" ]; then
        cp ../wiki_setup/Ciclo-Vida-Tarea.md Ciclo-Vida-Tarea.md
        print_success "✓ Ciclo de Vida de la Tarea copiado"
    fi
    
    cd ..
    echo ""
}

commit_and_push() {
    print_step "Publicando cambios a GitHub..."
    
    cd "$WIKI_DIR"
    
    # Verificar si hay cambios
    if git diff --quiet && git diff --cached --quiet; then
        print_warning "No hay cambios para publicar"
        cd ..
        return
    fi
    
    # Agregar todos los archivos
    git add .
    
    # Commit con timestamp
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "📚 Actualizar documentación - ${TIMESTAMP}"
    
    # Push a GitHub
    git push origin master || {
        print_error "Error al publicar. Verifica tu conexión y permisos."
        cd ..
        exit 1
    }
    
    print_success "¡Cambios publicados exitosamente!"
    
    cd ..
    echo ""
}

show_summary() {
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}  ✅ Wiki Actualizada Exitosamente${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo -e "📚 Tu wiki está disponible en:"
    echo -e "${BLUE}https://github.com/${REPO_USER}/${REPO_NAME}/wiki${NC}"
    echo ""
    echo -e "📖 Páginas publicadas:"
    echo "  - 🏠 Home (página principal)"
    echo "  - 🔵 Guía de Estudiantes"
    echo "  - 🟢 Guía de Tutores"
    echo "  - 🔴 Guía de Administradores"
    echo "  - 🔐 Arquitectura de Autenticación"
    echo "  - 📝 Registro de Usuarios"
    echo "  - 🚀 Guía de Despliegue"
    echo "  - 🔄 Ciclo de Vida del Login"
    echo "  - 👥 Ciclo de Vida del Administrador"
    echo "  - 👥 Ciclo de Vida del Tutor"
    echo "  - 👥 Ciclo de Vida del Estudiante"
    echo "  - 📋 Ciclo de Vida del Anteproyecto"
    echo "  - 📋 Ciclo de Vida del Proyecto"
    echo "  - 📋 Ciclo de Vida de la Tarea"
    echo "  - ❓ FAQ"
    echo "  - 🚀 Guía de Inicio Rápido"
    echo ""
    echo -e "💡 Próximos pasos:"
    echo "  1. Visita la wiki y verifica que todo se vea bien"
    echo "  2. Actualiza los enlaces en la aplicación Flutter"
    echo "  3. Comparte la wiki con tu equipo"
    echo ""
}

# =============================================================================
# SCRIPT PRINCIPAL
# =============================================================================

main() {
    print_header
    
    check_prerequisites
    
    clone_or_update_wiki
    
    copy_wiki_structure
    
    copy_user_guides
    
    copy_technical_docs
    
    copy_lifecycle_docs
    
    commit_and_push
    
    show_summary
}

# Ejecutar script principal
main

