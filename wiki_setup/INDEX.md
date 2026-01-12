# 📚 Índice Visual - Configuración de Wiki GitHub

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   🎯 SISTEMA DE SEGUIMIENTO DE PROYECTOS TFCGS               │
│   📚 Configuración de GitHub Wiki                             │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 🚦 Inicio Rápido

```
┌─────────────────────┐
│  ⚡ NUEVO AQUÍ?    │
│                     │
│  EMPIEZA POR:       │
│  👉 INSTRUCCIONES_  │
│     RAPIDAS.md      │
│                     │
│  ⏱️  Solo 5 min     │
└─────────────────────┘
```

**➡️ [INSTRUCCIONES_RAPIDAS.md](INSTRUCCIONES_RAPIDAS.md)**

---

## 📋 Documentación Disponible

### 🔰 Para Principiantes

| Archivo | Descripción | Tiempo | Prioridad |
|---------|-------------|--------|-----------|
| **[INSTRUCCIONES_RAPIDAS.md](INSTRUCCIONES_RAPIDAS.md)** | 3 pasos simples | ⏱️ 5 min | 🔴 ALTA |
| **[RESUMEN_ARCHIVOS.md](RESUMEN_ARCHIVOS.md)** | Qué contiene cada archivo | ⏱️ 3 min | 🟡 MEDIA |

---

### 📖 Para Usuarios Avanzados

| Archivo | Descripción | Tiempo | Prioridad |
|---------|-------------|--------|-----------|
| **[README.md](README.md)** | Guía completa y detallada | ⏱️ 15 min | 🟢 BAJA |

---

### 🤖 Herramientas

| Archivo | Descripción | Uso |
|---------|-------------|-----|
| **[publicar_wiki.sh](publicar_wiki.sh)** | Script automático | Ejecutar después de configurar |

---

## 📁 Contenido de la Wiki

### 📄 Páginas que se Publicarán

#### ✅ Ya Listas para Publicar

```
📚 Estructura de la Wiki
│
├── 🏠 Home.md
│   └── Página principal con enlaces por rol
│
├── 📖 _Sidebar.md
│   └── Menú lateral de navegación
│
├── 📄 _Footer.md
│   └── Pie de página
│
├── ❓ FAQ.md
│   └── Preguntas frecuentes (60+ preguntas)
│
└── 🚀 Guia-Inicio-Rapido.md
    └── Inicio rápido para nuevos usuarios
```

---

#### 📋 Se Copiarán desde `docs/`

```
📂 Guías de Usuario
│
├── 🔵 guia_estudiante.md     → Guia-Estudiantes
├── 🟢 guia_tutor.md          → Guia-Tutores
└── 🔴 guia_administrador.md  → Guia-Administradores

📂 Documentación Técnica
│
└── 🔐 Arquitectura-Autenticacion.md     → Arquitectura-Autenticacion
```

---

## 🎯 Flujo de Configuración

```
PASO 1                    PASO 2                    PASO 3
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │         │              │         │              │
│  Habilitar   │  ────▶  │  Configurar  │  ────▶  │  Publicar    │
│  Wiki en     │         │  Script      │         │  Contenido   │
│  GitHub      │         │              │         │              │
│              │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
     1 min                    2 min                    2 min

                              ⏱️ TOTAL: 5 MINUTOS
```

---

## 🔧 Tareas de Configuración

### ⚙️ Antes de Publicar

```
┌─────────────────────────────────────────────────┐
│ ☐ Habilitar Wiki en repositorio GitHub        │
│ ☐ Editar publicar_wiki.sh con tu info         │
│ ☐ Actualizar USUARIO/REPO en archivos .md     │
│ ☐ Dar permisos de ejecución al script         │
└─────────────────────────────────────────────────┘
```

---

### 🚀 Primera Publicación

```
┌─────────────────────────────────────────────────┐
│ ☐ Ejecutar: ./publicar_wiki.sh                │
│ ☐ Verificar wiki en GitHub                    │
│ ☐ Probar navegación                           │
│ ☐ Compartir enlace con el equipo              │
└─────────────────────────────────────────────────┘
```

---

## 📊 Estadísticas del Proyecto

```
┌────────────────────────────────────────────┐
│                                            │
│  📄 Total de Páginas:  11                  │
│  📝 Líneas de Código:  ~4,900              │
│  💬 Palabras:          ~33,500             │
│  ⏱️  Tiempo Setup:     5 minutos           │
│  🎯 Complejidad:       Baja                │
│                                            │
└────────────────────────────────────────────┘
```

---

## 🎨 Características de la Wiki

### ✨ Incluye

```
✅ Navegación por roles (Estudiante, Tutor, Admin)
✅ Guías completas para cada rol (500-900 líneas c/u)
✅ FAQ con 60+ preguntas frecuentes
✅ Guía de inicio rápido
✅ Documentación técnica detallada
✅ Búsqueda integrada de GitHub
✅ Menú lateral persistente
✅ Pie de página con enlaces
✅ Responsive (funciona en móvil)
✅ Markdown con emojis y formato
```

---

## 🗺️ Mapa de Navegación

```
                    ┌──────────┐
                    │   HOME   │
                    └────┬─────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼────┐     ┌────▼────┐     ┌────▼────┐
    │ 🔵      │     │ 🟢      │     │ 🔴      │
    │Estudiante│    │ Tutor   │     │  Admin  │
    └────┬────┘     └────┬────┘     └────┬────┘
         │               │               │
    ┌────▼────┐     ┌────▼────┐     ┌────▼────┐
    │ Tareas  │     │ Revisar │     │ Usuarios│
    │ Kanban  │     │ Aprobar │     │ Config  │
    │ Proyecto│     │ Gestión │     │ Sistema │
    └─────────┘     └─────────┘     └─────────┘
```

---

## 🆘 Solución de Problemas

| Problema | Solución | Archivo |
|----------|----------|---------|
| 🔴 No sé por dónde empezar | Lee INSTRUCCIONES_RAPIDAS.md | [Ver aquí](INSTRUCCIONES_RAPIDAS.md) |
| 🟠 Error al ejecutar script | Revisa sección "Troubleshooting" | [README.md](README.md#solución-de-problemas) |
| 🟡 Quiero personalizar | Lee sección "Personalización" | [RESUMEN_ARCHIVOS.md](RESUMEN_ARCHIVOS.md#personalización) |
| 🟢 ¿Cómo actualizo? | Ejecuta script nuevamente | Ver README.md |

---

## 📞 Recursos y Enlaces

### 📚 Documentación

- 📖 [README Completo](README.md)
- ⚡ [Guía Rápida](INSTRUCCIONES_RAPIDAS.md)
- 📦 [Resumen de Archivos](RESUMEN_ARCHIVOS.md)
- 📋 [Este Índice](INDEX.md)

### 🌐 Enlaces Externos

- [GitHub Wiki Docs](https://docs.github.com/es/communities/documenting-your-project-with-wikis)
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Actions](https://docs.github.com/es/actions)

---

## 🎓 Para Aprender Más

### Niveles de Conocimiento

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  🔰 Principiante                                │
│  └─▶ INSTRUCCIONES_RAPIDAS.md                  │
│                                                 │
│  📚 Intermedio                                  │
│  └─▶ RESUMEN_ARCHIVOS.md                       │
│                                                 │
│  🎓 Avanzado                                    │
│  └─▶ README.md                                  │
│                                                 │
│  🚀 Experto                                     │
│  └─▶ GitHub Actions + Automatización           │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## ✅ Estado del Proyecto

```
┌────────────────────────────────────────┐
│                                        │
│  ✅ Archivos Wiki:      COMPLETO       │
│  ✅ Scripts:            COMPLETO       │
│  ✅ Documentación:      COMPLETO       │
│  ✅ Guías de Usuario:   COMPLETO       │
│  ✅ FAQ:                COMPLETO       │
│  ⚙️  Publicación:       PENDIENTE      │
│  ⚙️  Testing:           PENDIENTE      │
│                                        │
└────────────────────────────────────────┘
```

---

## 🎯 Próximo Paso

```
╔═══════════════════════════════════════════╗
║                                           ║
║  👉 LEE: INSTRUCCIONES_RAPIDAS.md        ║
║                                           ║
║  Luego ejecuta:                          ║
║  $ cd wiki_setup                         ║
║  $ ./publicar_wiki.sh                    ║
║                                           ║
║  ¡Solo 5 minutos! ⏱️                     ║
║                                           ║
╚═══════════════════════════════════════════╝
```

**➡️ [EMPEZAR AHORA](INSTRUCCIONES_RAPIDAS.md)**

---

## 🎉 ¡Éxito!

```
    🎊    📚    🎊
     \    |    /
      \   |   /
       \  |  /
        \ | /
         \|/
          ▼
    ┌─────────┐
    │  WIKI   │
    │  LISTA  │
    └─────────┘
```

**¡Tu wiki profesional está a solo 5 minutos!**

---

**📅 Última actualización**: Diciembre 2025  
**📦 Versión**: 1.0  
**🏆 Estado**: Listo para Usar

